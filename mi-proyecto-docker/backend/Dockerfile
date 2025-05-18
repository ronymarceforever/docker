FROM python:3.9-slim

WORKDIR /app

# Copia primero requirements.txt para aprovechar el cache de Docker
COPY requirements.txt .

# Instala las dependencias a nivel de sistema (no --user)
RUN pip install --no-cache-dir -r requirements.txt && \
    apt-get update && \
    apt-get install -y --no-install-recommends net-tools && \
    rm -rf /var/lib/apt/lists/*

# Copia el resto de los archivos
COPY app.py .

# Crea usuario no-root
RUN useradd -m myuser && \
    chown -R myuser:myuser /app

USER myuser

EXPOSE 5000

CMD ["python", "app.py"]