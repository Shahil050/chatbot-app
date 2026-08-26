# Stage 1: Build dependencies
FROM python:3.12-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends gcc python3-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: Final minimal runtime
FROM python:3.12-slim AS runner

WORKDIR /app

# Copy installed dependencies from builder
COPY --from=builder /install /usr/local
COPY . .
RUN chown -R 1001:0 /app && chmod -R g=u /app

# Ensure local binaries are in PATH
# ENV PATH=/root/.local/bin:$PATH

EXPOSE 7860

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860"]

