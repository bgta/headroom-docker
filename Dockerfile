FROM python:3.13-slim

# Pure Python headroom-ai (0.20.15 = abans del Rust nadiu)
ENV HEADROOM_REQUIRE_RUST_CORE=false

RUN pip install --no-cache-dir "headroom-ai==0.20.15" httpx uvicorn "openai>=2.14.0" websockets fastapi h2 "transformers<4.50" sentencepiece && \
    python3 -c "import headroom; from transformers import AutoTokenizer; print(f'Headroom {headroom.__version__} + transformers OK')"

EXPOSE 8787
ENTRYPOINT ["headroom", "proxy"]
CMD ["--host", "0.0.0.0", "--port", "8787"]
