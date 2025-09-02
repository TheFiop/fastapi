# ===== Stage 1: builder =====
FROM python:3.12-slim AS builder


ENV PYTHONDONTWRITEBYTECODE=1 \
PYTHONUNBUFFERED=1 \
PIP_DISABLE_PIP_VERSION_CHECK=1 \
PIP_NO_CACHE_DIR=1


WORKDIR /app
COPY app/requirements.txt ./
RUN python -m venv /opt/venv \
&& /opt/venv/bin/pip install --upgrade pip \
&& /opt/venv/bin/pip wheel --wheel-dir /wheels -r requirements.txt


# ===== Stage 2: runtime =====
FROM python:3.12-slim AS runtime


ENV PATH="/opt/venv/bin:$PATH" \
PYTHONDONTWRITEBYTECODE=1 \
PYTHONUNBUFFERED=1


# Crear usuario no-root
RUN useradd -u 10001 -m appuser


# Copiar dependencias precompiladas
COPY --from=builder /wheels /wheels
RUN python -m venv /opt/venv \
&& /opt/venv/bin/pip install --no-index --find-links=/wheels /wheels/* \
&& rm -rf /wheels


WORKDIR /srv/app
COPY app/ ./


USER appuser
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]