Program generadorDetalle;
Type 
  venta = Record
    cod: integer;
  End;


Var 
  archivoTexto: Text;
  archivoBinario: file Of venta;
  detalle: venta;

Begin
  // Asignar archivo de texto para lectura
  Assign(archivoTexto, 'detalle.txt');
  Reset(archivoTexto);

  // Asignar archivo binario para escritura
  Assign(archivoBinario, 'detalle.bin');
  Rewrite(archivoBinario);

  // Leer datos del archivo de texto y guardarlos en el archivo binario
  While Not Eof(archivoTexto) Do
    Begin
      Read(archivoTexto, detalle.cod);
      Write(archivoBinario, detalle);
    End;

  // Cerrar archivos
  Close(archivoTexto);
  Close(archivoBinario);

  // Mostrar mensaje de finalización
  WriteLn('El archivo se ha convertido a binario exitosamente.');

End.
