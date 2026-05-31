# design/

This directory holds **our** handover artefacts — the inputs we (Praxis: Producer, Architect,
Creative) hand to the implementation tool. It is deliberately separate from `openspec/`, which the
tool owns and writes into.

## The boundary

- **We author:** briefs, the glossary, prototype-reference manifests, capture guides, and the
  captured screens. These express *intent* and *experience*.
- **The tool authors:** the spec — `openspec/changes/<change>/` (proposal, design, specs, tasks).
  We review and approve that spec **against the brief**. We never author the spec.
- Authority over any conflict between a brief and a spec (or between a brief and a prototype) sits
  on our side, not the tool's.

This split is the methodology discipline `tool-owned-artefacts-are-instructed-not-authored`, and the
brief crossing the boundary is `brief-is-the-interface`.

## The brief model

The brief is the only thing that crosses the Praxis -> tool boundary. It carries semantic content
in plain implementation terms; methodology vocabulary (capability codes, graph-internal terms, role
names) stays upstream. Briefs come in two shapes by change type
(`briefs-come-in-shapes-by-change-type`):

- **Substrate brief** (foundation changes) — the product's intent from an architectural perspective,
  plus our considered layers. Names seams and direction without dictating their shape.
- **Design brief** (feature changes) — the product in ubiquitous language to the point the tool
  understands it, with no prescription over implementation.

The `glossary.md` is the ubiquitous-language spine that binds brief, spec, and implementation.

## Layout

```
design/
  README.md                 (this file)
  glossary.md               shared ubiquitous language
  capture-protocol.md       how we capture a prototype walkthrough (three passes)
  change-1-foundation/
    brief.md                substrate brief
  change-2-spotted/
    brief.md                design brief
    prototype-reference.md  manifest: label <-> blueprint step <-> brief section, + Ez intent
    ez-walkthrough-guide.md the per-journey capture guide for the creative
    screens/                captured states (committed, curated, small)
      spotted-capture/  spotted-feed/  _substrate/
```

The cloned Lovable prototype lives **beside** this repo as a sibling (`../wez-lovable-reference/`),
not inside it — authoritative over experience and behaviour, reference-only over structure.
