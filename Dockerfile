FROM python:3.13-slim

# Pure Python headroom-ai (0.20.15 = abans del Rust nadiu)
# HEADROOM_REQUIRE_RUST_CORE=false = mode degraded sense Rust
ENV HEADROOM_REQUIRE_RUST_CORE=false

RUN pip install --no-cache-dir "headroom-ai==0.20.15" "httpx[http2]" uvicorn "openai>=2.14.0" websockets fastapi && \
    python3 -c "import headroom; print(f'Headroom {headroom.__version__} OK')"

EXPOSE 8787
ENTRYPOINT ["headroom", "proxy"]
CMD ["--host", "0.0.0.0", "--port", "8787"]
