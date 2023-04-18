program generadorMaestro;

type
  datoMaestro = record
    cod:integer;
    nombre:string;
    familia:string;
    descripcion:string;
    zona:string;
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
    readln(archivoTexto, registro.cod,registro.nombre);
    readln(archivoTexto, registro.familia);
    readln(archivoTexto, registro.descripcion);
    readln(archivoTexto, registro.zona);
    
    // Escribir datos en el archivo binario
    write(archivoBinario, registro);
  end;
  
  // Cerrar archivos
  close(archivoTexto);
  close(archivoBinario);
  
  writeln('Datos convertidos a binario exitosamente.');
end.
