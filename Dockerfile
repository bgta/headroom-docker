FROM python:3.13-slim

# Pure Python headroom-ai (0.20.15 = abans del Rust nadiu)
ENV HEADROOM_REQUIRE_RUST_CORE=false

# Instal·lar h2 explícitament per HTTP/2
RUN pip install --no-cache-dir "headroom-ai==0.20.15" httpx uvicorn "openai>=2.14.0" websockets fastapi h2 && \
    python3 -c "import h2; import headroom; print(f'Headroom {headroom.__version__} + h2 OK')"

EXPOSE 8787
ENTRYPOINT ["headroom", "proxy"]
CMD ["--host", "0.0.0.0", "--port", "8787"]
