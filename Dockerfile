FROM python:3.13-slim

# Build Headroom per W3530 - forcem x86-64-v2 (SSE4.2) i desactivem AVX explicitament
ENV RUSTFLAGS="-C target-cpu=x86-64-v2 -C target-feature=-avx,-avx2,-avx512f,-fma,-bmi,-bmi2"
ENV CFLAGS="-march=x86-64-v2 -mno-avx -mno-avx2 -mno-avx512f -mno-fma"
ENV CXXFLAGS="-march=x86-64-v2 -mno-avx -mno-avx2 -mno-avx512f -mno-fma"
ENV CARGO_BUILD_RUSTFLAGS="-C target-cpu=x86-64-v2 -C target-feature=-avx,-avx2,-avx512f,-fma,-bmi,-bmi2"

# Instal·lar Rust + build deps
RUN apt-get update && apt-get install -y curl build-essential pkg-config && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Instal·lar Headroom CORE (sense onnxruntime!) + uvicorn per proxy
RUN . "$HOME/.cargo/env" && \
    pip install --no-cache-dir \
        --no-binary headroom-ai,zstandard \
        headroom-ai uvicorn httpx "openai>=2.14.0" websockets fastapi && \
    python3 -c "import headroom; print('Headroom build OK')" && \
    rm -rf "$HOME/.cargo" /root/.rustup

EXPOSE 8787

ENTRYPOINT ["headroom", "proxy"]
CMD ["--host", "0.0.0.0", "--port", "8787", "--disable-kompress"]
