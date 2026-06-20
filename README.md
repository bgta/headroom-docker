# Headroom Docker - Custom Build per CPU sense AVX

Imatge Docker custom d'[Headroom](https://github.com/chopratejas/headroom) (v0.26.0), compilada des de source per CPU x86-64 **sense AVX**.

Per què? Headroom conté codi Rust nadiu (via maturin). Les wheels precompilades i les imatges oficials assumeixen CPU amb AVX (2011+). En CPUs antics com el Xeon W3530 (2009), el procés mor amb **SIGILL** (exit 132).

Aquesta build força `RUSTFLAGS="-C target-cpu=x86-64"` per generar codi compatible amb qualsevol CPU x86-64.

## Algorismes disponibles

| Algorisme | Funciona? | Notes |
|-----------|:---------:|-------|
| SmartCrusher (JSON) | ✅ | Sense dependències natives |
| CodeCompressor (AST) | ✅ | Via ast-grep-cli (binary) |
| CacheAligner | ✅ | Lògica Python pura |
| Output Shaper | ✅ | Modifica system prompt |
| Kompress-base (text) | ❌ | Requereix ONNX Runtime (AVX) |
| Magika (content detect) | ❌ | Requereix ONNX Runtime (AVX) |

Ús recomanat: `--disable-kompress` o `HEADROOM_DISABLE_KOMPRESS=1`.

## Build local

```bash
docker build -t localhost/headroom:custom .
```

## Deploy

```bash
docker run -d --name headroom \
  -p 8787:8787 \
  -e OPENAI_API_KEY="sk-..." \
  -e OPENAI_BASE_URL="https://api.deepseek.com/v1" \
  -e HEADROOM_DISABLE_KOMPRESS=1 \
  -e HEADROOM_OUTPUT_SHAPER=1 \
  ghcr.io/raul/headroom:latest
```

## Env vars

| Variable | Valor recomanat | Descripció |
|----------|:---------------:|------------|
| `OPENAI_API_KEY` | `sk-...` | API key del provider upstream |
| `OPENAI_BASE_URL` | `https://api.deepseek.com/v1` | URL del provider |
| `HEADROOM_DISABLE_KOMPRESS` | `1` | Desactiva Kompress (requereix AVX) |
| `HEADROOM_OUTPUT_SHAPER` | `1` | Activa output token reduction |
| `HEADROOM_VERBOSITY_LEVEL` | `2` | Nivell de verbosity (L2 = no echo) |
| `HEADROOM_UPDATE_CHECK` | `off` | Desactiva check d'actualitzacions |
