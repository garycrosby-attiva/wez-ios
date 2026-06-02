export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);

    if (url.pathname === "/ping") {
      const body = {
        service: "wez-backend",
        status: "ok",
        time: new Date().toISOString(),
      };
      return new Response(JSON.stringify(body), {
        headers: { "content-type": "application/json" },
      });
    }

    return new Response("Not found", { status: 404 });
  },
};
