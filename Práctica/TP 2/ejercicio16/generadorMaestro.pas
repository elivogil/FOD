program generadorMaestro;

type
  datoMaestro = record
    fecha: longint; // Se asume que el nombre de la localidad tiene un máximo de 50 caracteres
    cod: integer;
    nombre: string; // Se asume que el nombre de la localidad tiene un máximo de 50 caracteres
    descripcion:string;
    precio: integer;
    totEjempl: integer;
    totVendido: integer;
  end;

var
  archivoTexto: text;
  archivoBinario: file of datoMaestro;
  registro: datoMaestro;

begin
  // Abrir archivo de texto en modo lectura
  assign(archivoTexto, 'maestro.txt');
  reset(archivoTexto);
  
  // Crear archivo binario en modo escritura
  assign(archivoBinario, 'maestro.bin');
  rewrite(archivoBinario);
  
  // Leer datos del archivo de texto y escribirlos en el archivo binario
  while not eof(archivoTexto) do
  begin
    // Leer datos del archivo de texto
    readln(archivoTexto, registro.cod,registro.totEjempl,registro.totVendido,registro.precio,registro.fecha);
    readln(archivoTexto, registro.nombre);
    readln(archivoTexto, registro.descripcion);
    
    // Escribir datos en el archivo binario
    write(archivoBinario, registro);
  end;
  
  // Cerrar archivos
  close(archivoTexto);
  close(archivoBinario);
  
  writeln('Datos convertidos a binario exitosamente.');
end.
