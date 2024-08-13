// app.js

const readline = require('readline');
const hostsManager = require('./src/utils/managers/hosts.js');

// Crear una interfaz de lectura para la entrada del usuario
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Función para solicitar entrada del usuario
function askQuestion(query) {
    return new Promise(resolve => rl.question(query, resolve));
}

async function main() {
    const section = await askQuestion('¿Qué sección quieres listar (orgs/cas)? ');
    
    const hosts = hostsManager.getHosts(section);
    
    if (hosts.length > 0) {
        console.log(`Hosts en la sección ${section}:`);
        hosts.forEach(host => {
            console.log(`- Nombre: ${host.name}, Ansible Host: ${host.ansible_host}`);
        });
    } else {
        console.log(`No se encontraron hosts en la sección ${section}.`);
    }

    const action = await askQuestion('¿Qué acción quieres realizar (agregar/eliminar)? ');
    
    if (action === 'agregar') {
        const key = await askQuestion('¿Cuál es el nombre del host? ');
        const ansibleHost = await askQuestion('¿Cuál es el ansible_host? ');
        const ansibleUser = await askQuestion('¿Cuál es el ansible_user? ');

        hostsManager.addHost(section, key, ansibleHost, ansibleUser);
    } else if (action === 'eliminar') {
        const key = await askQuestion('¿Cuál es el nombre del host que quieres eliminar? ');

        hostsManager.removeHost(section, key);
    } else {
        console.log('Acción no válida. Por favor, elige "agregar" o "eliminar".');
    }
    
    rl.close();
}

// Ejecutar la función principal
main();
