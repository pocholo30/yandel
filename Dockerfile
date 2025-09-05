# Usa una imagen ligera de Linux. Alpine es una buena opción.
FROM debian:trixie-slim

# Instala las herramientas necesarias
RUN apt-get update && apt-get install -y \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Establece el directorio de trabajo
WORKDIR /app

# Descarga y descomprime ZeroNet en el directorio de trabajo del contenedor
# Esto prepara el entorno para que el entrypoint.sh pueda ejecutar ZeroNet
RUN wget https://github.com/HelloZeroNet/ZeroNet-linux/archive/dist-linux64/ZeroNet-py3-linux64.tar.gz -O ZeroNet.tar.gz
RUN tar -xvzf ZeroNet.tar.gz

# Ahora, copia tu script de entrada
COPY entrypoint.sh .

# Da permisos de ejecución al script
RUN chmod +x entrypoint.sh

# Define el punto de entrada
ENTRYPOINT ["./entrypoint.sh"]


# FROM ubuntu:latest

# RUN apt-get update && apt-get install -y \
#   wget \
#   python3.12 \
#   python3-pip \
#   git

# COPY entrypoint.sh /entrypoint.sh

# WORKDIR /app
# RUN wget https://github.com/HelloZeroNet/ZeroNet-linux/archive/dist-linux64/ZeroNet-py3-linux64.tar.gz \
#     && tar xvpfz ZeroNet-py3-linux64.tar.gz \
#     && rm ZeroNet-py3-linux64.tar.gz

# WORKDIR /app/ZeroNet-linux-dist-linux64

# RUN ./ZeroNet.sh &

# RUN wget -O test.html http://127.0.0.1:43110/1JKe3VPvFe35bm1aiHdD4p1xcGCkZKhH3Q 

# CMD ls

# #CMD ["echo", "Hello World"]

# #ENTRYPOINT ["/entrypoint.sh"]

