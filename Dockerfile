FROM python:3.13-slim

# Build Headroom per CPU x86-64 baseline (compatible W3530 sense AVX)
# Per defecte, Rust optimitza per la CPU del build, que te AVX.
# RUSTFLAGS forza target x86-64 generic.
ENV RUSTFLAGS="-C target-cpu=x86-64"

# Instal·lar dependències de build + Headroom
RUN apt-get update && apt-get install -y curl build-essential && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    . "$HOME/.cargo/env" && \
    pip install --no-cache-dir \
        --no-binary headroom-ai \
        "headroom-ai[proxy]" \
        fastapi uvicorn httpx "openai>=2.14.0" \
        zstandard websockets && \
    python3 -c "import headroom; print('Headroom build OK')" && \
    rm -rf "$HOME/.cargo" /root/.rustup

EXPOSE 8787

ENTRYPOINT ["headroom", "proxy"]
CMD ["--host", "0.0.0.0", "--port", "8787"]

