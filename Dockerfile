FROM python:3.13-slim

# 0.20.15 = Última versió pure Python (abans del Rust nadiu)
RUN pip install --no-cache-dir "headroom-ai==0.20.15" uvicorn httpx "openai>=2.14.0" websockets fastapi && \
    python3 -c "import headroom; print(f'Headroom {headroom.__version__} pure Python OK')"

EXPOSE 8787
ENTRYPOINT ["headroom", "proxy"]
CMD ["--host", "0.0.0.0", "--port", "8787"]
