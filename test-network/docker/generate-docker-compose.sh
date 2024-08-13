#!/bin/bash

# Función para mostrar el uso del script
show_usage() {
  echo "Uso: $0 -o <org1,org2,...> -n <num_nodes_per_org>"
  echo "  -o: Nombres de las organizaciones, separados por comas"
  echo "  -n: Número de nodos por organización"
  exit 1
}

# Función para generar un archivo docker-compose a partir de la plantilla
generate_docker_compose() {
  local org_name=$1
  local node_index=$2
  local org_dir=$3

  # Asignar puertos automáticamente
  local ca_port=$((7054 + node_index))
  local peer_port=$((7051 + (node_index * 10)))
  local chaincode_port=$((7052 + (node_index * 10)))
  local node_name=peer${node_index}.${org_name}

  # Reemplazar los placeholders en la plantilla
  sed -e "s/\${ORG_NAME}/${org_name}/g" \
      -e "s/\${CA_PORT}/${ca_port}/g" \
      -e "s/\${NODE_NAME}/${node_name}/g" \
      -e "s/\${PEER_PORT}/${peer_port}/g" \
      -e "s/\${CHAINCODE_PORT}/${chaincode_port}/g" \
      ca-docker-compose-template.yml > ${org_dir}/docker-compose.yml
}

# Verificar que se proporcionaron los parámetros necesarios
if [ $# -lt 4 ]; then
  show_usage
fi

# Procesar los argumentos
while getopts "o:n:" opt; do
  case ${opt} in
    o)
      IFS=',' read -r -a org_names <<< "${OPTARG}"
      ;;
    n)
      num_nodes_per_org=${OPTARG}
      ;;
    *)
      show_usage
      ;;
  esac
done

# Verificar que se proporcionaron ambos parámetros
if [ -z "${org_names}" ] || [ -z "${num_nodes_per_org}" ]; then
  show_usage
fi

# Directorio base para los archivos generados
base_dir="./fabric-network"

# Crear directorios y generar archivos docker-compose para cada organización y nodo
for org_name in "${org_names[@]}"; do
  org_dir="${base_dir}/${org_name}"
  mkdir -p ${org_dir}

  for ((i=0; i<num_nodes_per_org; i++)); do
    generate_docker_compose ${org_name} $i ${org_dir}
  done
done

echo "Archivos docker-compose generados con éxito."
