const net = require("net");
const fs = require("fs");
const path = require("path");
const os = require("os");
const chokidar = require("chokidar");
const { exec, execSync } = require('child_process');
const yargs = require('yargs/yargs');
const { hideBin } = require('yargs/helpers');
const retry = require('retry');

// Ruta del directorio que contiene los directorios openmsx
const directoryPath = `/tmp/openmsx-${os.userInfo().username}`;

const argv = yargs(hideBin(process.argv))
  .usage('Usage: $0 <asmFile> [options]')
  .command('<asmFile>', 'path to .asm file')
  .option('open-openmsx', {    
    alias: 'r',
    type: 'boolean',
    description: 'Run OpenMSX and reset after each compilation'
  })
  .option('create-autoexec', {
    alias: 'c',
    type: 'boolean',
    description: 'Create autoexec.bas file based on the provided .asm file'
  })
  .demandCommand(1, 'Must indicate the path to the .asm file')
  .help()
  .argv;


var socketPath;

const mainSrcFile =  argv._[0];
const absoluteFilePath = path.resolve(mainSrcFile);
// Obtener el directorio que contiene el archivo
const watchedFolder = path.dirname(absoluteFilePath);


// Aquí pones el comando que quieres ejecutar cuando cambie un archivo
const command = `asmsx ${mainSrcFile}`;

// Función para encontrar el directorio socket.numero
function findOpenMSXSocket(directoryPath) {
  return new Promise((resolve, reject) => {
    fs.readdir(directoryPath, (err, files) => {
      if (err) {
        return reject(`Unable to scan directory: ${err}`);
      }
      // Filtrar los directorios que coincidan con el patrón openmsx.numero
      const openmsxDir = files.find((file) => /^socket\.\d+$/.test(file));

      if (openmsxDir) {
        resolve(path.join(directoryPath, openmsxDir));
      } else {
        reject("No matching openmsx directory found");
      }
    });
  });
}

const setSocketPath = async () => {
    // Uso de la función para capturar el directorio openmsx.numero
    socketPath = await findOpenMSXSocket(directoryPath)  
    console.log(`Found OpenMSX socket: ${socketPath}`);
}

async function reset() {
  // Función para esperar un tiempo especificado
  function wait(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  // Función para enviar un comando y esperar una respuesta
  function sendCommand(client, command) {
    return new Promise((resolve, reject) => {
      client.write(`<command>${command}</command>`, (err) => {
        if (err) {
          return reject(err);
        }
        // console.log(`Enviado comando: ${command.trim()}`);
        resolve();
      });
    });
  }

  // Crear un cliente que se conectará al socket
  const client = net.createConnection(socketPath, async () => {
    try {
      client.write(`<openmsx-control>`);
      await sendCommand(client, "set speed 10000\n");
      await sendCommand(client, "reset");
      await wait(500);
      await sendCommand(client, "set speed 100\n");
      await sendCommand(client, 'type "\r"');

      // Cerrar la conexión
      client.end();
    } catch (err) {
      console.error(`Error al enviar comando: ${err.message}`);
      client.end();
    }
  });
}

const watchFolder = (onChanged) => {
  // Especificar el directorio que quieres observar
  //const directoryToWatch = path.join(__dirname, watchedFolder);

  // Inicializar el observador
  const watcher = chokidar.watch(`${watchedFolder}/*.asm`, {
    persistent: true,
  });

  // Definir lo que se debe hacer cuando un archivo cambia
  watcher.on("change", (filePath) => {
    console.log(`File changed: ${filePath}`);
    onChanged();
  });

  watcher.on("error", (error) => {
    console.error(`Watcher error: ${error}`);
  });

  console.log(`Watching for changes in ${watchedFolder}/*.asm`);
};


const compile = () => {
  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error executing command: ${error}`);
      return;
    }
    if (stderr) {
      console.error(`stderr: ${stderr}`);
    }
    console.log(`${stdout}`);
  });
};

const runOpenMsx = (diskFolder) => {
  exec(`openmsx -diska ${diskFolder}`, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error executing command: ${error}`);
      return;
    }
    if (stderr) {
      console.error(`stderr: ${stderr}`);
    }
    console.log(`${stdout}`);
  });
};

const createAutoexec = async (absoluteFilePath) => {
  const fileNameWithoutExt = path.basename(absoluteFilePath, path.extname(absoluteFilePath));
  const containerFolder = path.dirname(absoluteFilePath);
  const autoexecContent = `10 bload"${fileNameWithoutExt}.bin",r`;
  fs.writeFileSync(`${containerFolder}/autoexec.bas`, autoexecContent, 'utf8');
}

async function main() {
  if(argv['create-autoexec']) {
    await createAutoexec(mainSrcFile)
  }
  if(argv['open-openmsx']) {
    runOpenMsx(watchedFolder)
    const operation = retry.operation({
      retries: 10, // Número de reintentos
      factor: 1, // Factor de multiplicación para el intervalo entre reintentos
      minTimeout: 500, // Tiempo mínimo entre reintentos (en milisegundos)
      maxTimeout: Infinity, // Tiempo máximo entre reintentos (en milisegundos)
      randomize: false, // Si se debe aleatorizar el intervalo entre reintentos
    });
    
    operation.attempt(async () => {
      try {
        await setSocketPath();
        reset()
      } catch (error) {
        if (operation.retry(error)) {
          console.log(`Retrying...`);
          return;
        }
        console.error(`Failed to find OpenMSX socket. Is it running?`);
      }
    });


  }
  watchFolder(() => {
    // on changes
    compile();
    if (argv['open-openmsx']) reset();
  });
}

main();

