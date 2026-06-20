FROM python:3.13-slim

# NO compilem Rust. Instal·lem Headroom versió SENSE Rust nadiu.
# Les primeres versions d'headroom-ai eren pur Python.
RUN apt-get update && apt-get install -y curl build-essential pkg-config && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN . "$HOME/.cargo/env" && \
    pip install --no-cache-dir "headroom-ai<0.20" uvicorn httpx "openai>=2.14.0" websockets fastapi && \
    python3 -c "import headroom; print('Headroom OK:', headroom.__version__)" && \
    rm -rf "$HOME/.cargo" /root/.rustup

EXPOSE 8787
ENTRYPOINT ["headroom", "proxy"]
CMD ["--host", "0.0.0.0", "--port", "8787"]
