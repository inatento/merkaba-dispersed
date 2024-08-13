const fs = require('fs');
const yaml = require('js-yaml');

const filePath = './ansible/inventory/hosts.yml'; // Ruta al archivo YAML

// Leer y parsear el archivo YAML
function readYAMLFile() {
    try {
        return yaml.load(fs.readFileSync(filePath, 'utf8'));
    } catch (e) {
        console.error('Error al leer el archivo YAML:', e);
        return null;
    }
}

// Guardar el archivo YAML
function writeYAMLFile(data) {
    try {
        fs.writeFileSync(filePath, yaml.dump(data));
        console.log('Archivo YAML actualizado exitosamente.');
    } catch (e) {
        console.error('Error al escribir en el archivo YAML:', e);
    }
}

// Obtener los hosts de la sección específica
function getHosts(section) {
    const data = readYAMLFile();
    if (data && data[section] && data[section].hosts) {
        return Object.entries(data[section].hosts).map(([name, details]) => ({
            name,
            ansible_host: details.ansible_host
        }));
    } else {
        console.log(`No se encontraron hosts en la sección ${section}.`);
        return [];
    }
}

// Agregar un nuevo host
function addHost(section, key, ansibleHost, ansibleUser) {
    const data = readYAMLFile();
    if (data && data[section] && data[section].hosts) {
        data[section].hosts[key] = {
            ansible_host: ansibleHost,
            ansible_user: ansibleUser
        };
        writeYAMLFile(data);
        console.log(`Host ${key} agregado en la sección ${section}.`);
    } else {
        console.log(`Sección ${section} no encontrada.`);
    }
}

// Eliminar un host existente
function removeHost(section, key) {
    const data = readYAMLFile();
    if (data && data[section] && data[section].hosts && data[section].hosts[key]) {
        delete data[section].hosts[key];
        writeYAMLFile(data);
        console.log(`Host ${key} eliminado de la sección ${section}.`);
    } else {
        console.log(`Host ${key} no encontrado en la sección ${section}.`);
    }
}

// Listar todos los hosts en una sección
function printHosts(section) {
    const hosts = getHosts(section);
    console.log(`Hosts en la sección ${section}:`);
    hosts.forEach(host => {
        console.log(`- ${host.name}:`);
        console.log(`  ansible_host: ${host.ansible_host}`);
    });
}

module.exports = {
    addHost,
    removeHost,
    printHosts,
    getHosts
};
