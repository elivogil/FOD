program generadorDetalle;
const 
  df=2;
type
  datoDetalle = record
    codPcia: integer;
    codLoc: integer;
    conLuz: integer;
    construidas: integer;  // Resta a las de chapas
    conAgua: integer;
    conGas: integer;
    conSanitario: integer;
  end;

var
  archivoTexto: Text;
  archivoBinario: file of datoDetalle;
  detalle: datoDetalle;
  i:integer;
  iString:string;
begin
  // Asignar archivo de texto para lectura
  Assign(archivoTexto, 'detalle.txt');

  // Asignar archivo binario para escritura

  // Leer datos del archivo de texto y guardarlos en el archivo binario
  for i:=1 to df do begin
    Reset(archivoTexto);
    str(i,iString);
    Assign(archivoBinario, 'detalle'+iString+'.dat');
    Rewrite(archivoBinario);
    while not Eof(archivoTexto) do
    begin
      Read(archivoTexto, detalle.codPcia, detalle.codLoc, detalle.conLuz, detalle.construidas, detalle.conAgua, detalle.conGas, detalle.conSanitario);
      Write(archivoBinario, detalle);
    end;
    Close(archivoTexto);
    Close(archivoBinario);
  end;

  // Cerrar archivos

  // Mostrar mensaje de finalización
  WriteLn('El archivo se ha convertido a binario exitosamente.');

end.
