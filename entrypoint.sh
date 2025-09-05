#!/bin/bash

# Define el comando que quieres ejecutar
COMMAND="./ZeroNet-linux-dist-linux64/ZeroNet.sh --tor disable \
	siteNeedFile 1JKe3VPvFe35bm1aiHdD4p1xcGCkZKhH3Q data/listas/lista_fuera_iptv.m3u"
# Define el límite de tiempo de espera en segundos
TIMEOUT=60
# Define el número máximo de reintentos
MAX_RETRIES=3

# Define la función para ejecutar el comando con reintentos
function run_with_retries() {
    for (( i=1; i<=MAX_RETRIES; i++ )); do
        echo "Intento $i de $MAX_RETRIES..."
        echo

        $COMMAND 2>&1 | sed 's/^/\x1b[35m[ZeroNet]:\x1b[0m /' &
        PID=$!

        start_time=$(date +%s)
        while true; do
            if ! kill -0 "$PID" 2>/dev/null; then
                wait "$PID"
                if [ $? -eq 0 ]; then
                    echo -e "\e[34m[Command]: \e[32mCommand executed successfully\e[0m"
                    return 0 # Devuelve 0 para éxito
                else
                    echo -e "\e[34m[Command]: \e[31mThe command failed\e[0m"
                    break
                fi
            fi

            current_time=$(date +%s)
            elapsed_time=$(( current_time - start_time ))

            if [ "$elapsed_time" -ge "$TIMEOUT" ]; then
                echo -e "\e[34m[Command]: \e[33mTimeout. Terminating the process\e[0m"
                kill "$PID"
                break
            fi
            sleep 1
        done
    done
    return 1 # Devuelve 1 para fallo
}

# --- A PARTIR DE AQUI EMPIEZA LA LOGICA PRINCIPAL DE TU SCRIPT ---

echo "==================="

git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${INPUT_EMAIL}"
git config --global --add safe.directory /github/workspace
	
#python3 /usr/bin/feed.py

# Ejecuta ZeroNet en segundo plano
#./ZeroNet-linux-dist-linux64/ZeroNet.sh > /dev/null 2>&1 &

if run_with_retries; then
    echo -e "\e[90m[exec]: \e[0mFile obtained"
else
    echo -e "\e[90m[exec]: \e[0mFile not obtained"
    exit 1
fi

# Agrega un retraso para que ZeroNet se inicie por completo
#sleep 60

#echo "Running ZeroNet"

#wget -O maluma.m3u http://127.0.0.1:43110/1JKe3VPvFe35bm1aiHdD4p1xcGCkZKhH3Q/data/listas/lista_fuera_iptv.m3u
#curl http://127.0.0.1:43110/1JKe3VPvFe35bm1aiHdD4p1xcGCkZKhH3Q/data/listas/lista_fuera_iptv.m3u -o maluma.m3u
#kill "$ZERONET_PID"
#cat maluma.m3u

cp ZeroNet-linux-dist-linux64/data/1JKe3VPvFe35bm1aiHdD4p1xcGCkZKhH3Q\
/data/listas/lista_fuera_iptv.m3u maluma.m3u

#ls 2>&1 | sed 's/^/\x1b[90m[ls]:\x1b[0m /'
#ls ZeroNet-linux-dist-linux64/data/1JKe3VPvFe35bm1aiHdD4p1xcGCkZKhH3Q\
#/data/listas/

git add maluma.m3u && git commit -m "Update Feed"
git push --set-upstream origin main

echo "==================="
