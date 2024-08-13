# merkaba-dispersed - Proyecto para generar el material criptográfico necesario para desplegar los nodos de la red merkaba.

1. Las instrucciones para instalar las dependencias y herramientas para desplegar el proyecto las encontrarás en:
setup/README.md

2. El procedimiento para desplegar el proyecto se puede seguir en:
test-network/README.md

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.bashrc
nvm list-remote
nvm install v18.20.4
nvm list
npm install express yamljs shelljs fabric-ca-client
npm install --save-dev nodemon
npm install yamljs
npm install js-yaml
