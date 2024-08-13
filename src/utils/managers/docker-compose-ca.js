const fs = require('fs');
const yaml = require('js-yaml');
const path = require('path');

// Ruta a la plantilla de Docker Compose
const TEMPLATE_FILE_PATH = path.join(__dirname, 'templates', 'docker-compose-template.yml');

// Función para cargar la plantilla de Docker Compose
function loadTemplate() {
  try {
    const fileContents = fs.readFileSync(TEMPLATE_FILE_PATH, 'utf8');
    return yaml.load(fileContents);
  } catch (e) {
    console.error(`Error loading template: ${e.message}`);
    throw e;
  }
}

// Función para guardar el archivo Docker Compose
function saveComposeFile(filePath, data) {
  try {
    fs.writeFileSync(filePath, yaml.dump(data), 'utf8');
    console.log(`Docker Compose file saved to ${filePath}`);
  } catch (e) {
    console.error(`Error saving Docker Compose file: ${e.message}`);
    throw e;
  }
}

// Función para generar Docker Compose para cada host
function generateComposeFiles(hosts) {
  const template = loadTemplate();

  hosts.forEach(host => {
    const compose = { ...template }; // Clonar la plantilla
    compose.services[host.name] = {
      ...compose.services['ca_merkaba'], // Copiar configuración base
      container_name: host.name,
      ports: [`${host.port}:7054`, `${host.operationPort}:17054`],
      command: `sh -c 'fabric-ca-server start -b admin:adminpw -d'`,
    };
    
    // Eliminar el servicio base para evitar conflictos
    delete compose.services['ca_merkaba'];

    // Guardar el archivo Docker Compose
    saveComposeFile(`docker-compose-${host.name}.yml`, compose);
  });
}

// Simulación de la lectura de hosts desde el inventario (ejemplo)
const hosts = [
  { name: 'ca_merkaba', port: 7054, operationPort: 17054 },
  // Agregar más hosts según el inventario
];

// Generar Docker Compose para cada host
generateComposeFiles(hosts);
