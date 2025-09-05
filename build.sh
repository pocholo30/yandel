#!/bin/bash

# Define las variables de entorno para las pruebas
export GITHUB_ACTOR="pocholo30"
export INPUT_EMAIL="pocholo30@localhost"

# Construye la imagen, pasando ambos argumentos
docker build -t zeronet-test \
  --build-arg GITHUB_ACTOR=${GITHUB_ACTOR} \
  --build-arg INPUT_EMAIL=${INPUT_EMAIL} \
  .
