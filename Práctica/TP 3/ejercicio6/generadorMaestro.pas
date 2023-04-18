program generadorMaestro;

type
  datoMaestro = record
    cod:integer;
    descripcion:string;
    colores:string;
    tipo:string;
    stock:integer;
    precio:real;
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
    readln(archivoTexto, registro.cod,registro.descripcion);
    readln(archivoTexto, registro.stock,registro.colores);
    readln(archivoTexto, registro.precio,registro.tipo);
    
    // Escribir datos en el archivo binario
    write(archivoBinario, registro);
  end;
  
  // Cerrar archivos
  close(archivoTexto);
  close(archivoBinario);
  
  writeln('Datos convertidos a binario exitosamente.');
end.
