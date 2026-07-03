/// <reference types="@cloudflare/workers-types" />

interface Env {
  DB: D1Database;
  PHOTOS: R2Bucket;
}

const json = (body: unknown, status = 200): Response =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json" },
  });

// A SpottedPost row as the Swift Codable type expects it (dates are ISO8601 strings).
interface PostBody {
  id: string;
  beachId: string;
  photoUrl: string;
  caption: string | null;
  captureConditions: unknown;
  derivedTags: string[];
  summary: string | null;
  author: string | null;
  createdAt: string;
}

// Editorial-pair invariant (mirrors SpottedPost.validate): summary/author both null or
// both populated, and non-empty when populated.
function editorialPairValid(summary: string | null, author: string | null): boolean {
  const summaryNil = summary === null || summary === undefined;
  const authorNil = author === null || author === undefined;
  if (summaryNil !== authorNil) return false;
  if (summary === "" || author === "") return false;
  return true;
}

async function createPost(request: Request, env: Env): Promise<Response> {
  const p = (await request.json()) as PostBody;
  if (!p.id || !p.beachId || !p.photoUrl) {
    return json({ error: "missing required fields" }, 400);
  }
  if (!editorialPairValid(p.summary ?? null, p.author ?? null)) {
    return json({ error: "editorial pair mismatch" }, 422);
  }
  await env.DB.prepare(
    `INSERT INTO SpottedPost
       (id, beachId, photoUrl, caption, captureConditions, derivedTags, summary, author, createdAt)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`
  )
    .bind(
      p.id,
      p.beachId,
      p.photoUrl,
      p.caption ?? null,
      JSON.stringify(p.captureConditions),
      JSON.stringify(p.derivedTags),
      p.summary ?? null,
      p.author ?? null,
      p.createdAt
    )
    .run();
  return json(p, 201);
}

async function listFeed(env: Env): Promise<Response> {
  const { results } = await env.DB.prepare(
    `SELECT id, beachId, photoUrl, caption, captureConditions, derivedTags, summary, author, createdAt
       FROM SpottedPost
       ORDER BY createdAt DESC
       LIMIT 50`
  ).all<Record<string, string | null>>();

  const posts = (results ?? []).map((r) => ({
    id: r.id,
    beachId: r.beachId,
    photoUrl: r.photoUrl,
    caption: r.caption ?? null,
    captureConditions: JSON.parse(r.captureConditions as string),
    derivedTags: JSON.parse(r.derivedTags as string),
    summary: r.summary ?? null,
    author: r.author ?? null,
    createdAt: r.createdAt,
  }));
  return json(posts);
}

async function putPhoto(id: string, request: Request, env: Env): Promise<Response> {
  const body = await request.arrayBuffer();
  if (body.byteLength === 0) return json({ error: "empty body" }, 400);
  await env.PHOTOS.put(`spotted/${id}.jpg`, body, {
    httpMetadata: { contentType: "image/jpeg" },
  });
  return json({ key: `spotted/${id}.jpg` }, 201);
}

async function getPhoto(id: string, env: Env): Promise<Response> {
  const object = await env.PHOTOS.get(`spotted/${id}.jpg`);
  if (object === null) return new Response("Not found", { status: 404 });
  const headers = new Headers();
  object.writeHttpMetadata(headers);
  headers.set("etag", object.httpEtag);
  if (!headers.has("content-type")) headers.set("content-type", "image/jpeg");
  return new Response(object.body, { headers });
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    const { pathname } = url;
    const method = request.method;

    if (pathname === "/ping") {
      return json({ service: "wez-backend", status: "ok", time: new Date().toISOString() });
    }

    if (pathname === "/posts" && method === "POST") return createPost(request, env);
    if (pathname === "/feed" && method === "GET") return listFeed(env);

    const photoMatch = pathname.match(/^\/photos\/([A-Za-z0-9._-]+)$/);
    if (photoMatch) {
      const id = photoMatch[1];
      if (method === "PUT" || method === "POST") return putPhoto(id, request, env);
      if (method === "GET") return getPhoto(id, env);
    }

    return new Response("Not found", { status: 404 });
  },
};
