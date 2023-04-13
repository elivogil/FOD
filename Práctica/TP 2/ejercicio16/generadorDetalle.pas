Program generadorDetalle;
Type 
  venta = Record
    fecha: LongInt;
    codigo: integer;
    cant: integer;
  End;


Var 
  archivoTexto: Text;
  archivoBinario: file Of venta;
  detalle: venta;

Begin
  // Asignar archivo de texto para lectura
  Assign(archivoTexto, 'det1.txt');
  Reset(archivoTexto);

  // Asignar archivo binario para escritura
  Assign(archivoBinario, 'det1.bin');
  Rewrite(archivoBinario);

  // Leer datos del archivo de texto y guardarlos en el archivo binario
  While Not Eof(archivoTexto) Do
    Begin
      Read(archivoTexto, detalle.codigo, detalle.cant, detalle.fecha);
      Write(archivoBinario, detalle);
    End;

  // Cerrar archivos
  Close(archivoTexto);
  Close(archivoBinario);

  // Mostrar mensaje de finalización
  WriteLn('El archivo se ha convertido a binario exitosamente.');

End.
