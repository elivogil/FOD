

{11. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.   
}
Program tp2ej11;
Const 
  valor_alto = '9999';
Type 
  rArchivo = Record
    nProv: string;
    cant: integer;
    totEnc: integer;
  End;
  rDetalle = Record
    codLoc: Integer;
    nProv: string;
    cant: integer;
    cantEnc: integer;
  End;
  arch = file Of rArchivo;
  det = file Of rDetalle;

Procedure leer(Var d: det; Var r:rDetalle);
Begin
  If (Not eof(d)) Then
    read (d,r)
  Else
    r.nProv := valor_alto;
End;

Procedure minimo(Var d1, d2 :det; Var r1 , r2 ,min:rDetalle);
Begin
  If (r1.nProv < r2.nProv) Then
    Begin
      min := r1;
      leer(d1,r1);
    End
  Else
    Begin
      min := r2;
      leer(d2,r2);
    End;
End;

Procedure crearBin(Var a:arch; Var d1,d2: det);
Var 
  txt: Text;
  e: rArchivo;
  i: integer;
  iString: string;
  rD: rDetalle;
  d: det;
Begin
  assign(a,'archivo');
  assign(txt,'archivo.txt');
  reset(txt);
  rewrite(a);
  While Not eof(txt) Do
    Begin
      With e Do
        readln(txt,cant,totEnc,nProv);
      write(a,e);
    End;
  close(txt);
  close(a);
  For i:=1 To 2 Do
    Begin
      str(i,iString);
      assign(txt,'detalle'+iString+'.txt');
      assign(d,'detalle'+iString);
      reset(txt);
      rewrite(d);
      While (Not eof(txt)) Do
        Begin
          With rD Do
            readln(txt,cant,cantEnc,codLoc,nProv);
          write(d,rD);
        End;
      close(d);
      close(txt);
    End;
  WriteLn('binarios creados con exito');
End;



Procedure procesarArchivo(Var a:arch; Var d1:det;Var d2:det);
Var 
  r1,r2,min : rDetalle;
  aux: rArchivo;
Begin
  assign(a,'archivo');
  assign(d1,'detalle1');
  assign(d2,'detalle2');
  reset(a);
  reset(d1);
  reset(d2);
  leer(d1,r1);
  leer(d2,r2);
  minimo(d1,d2,r1,r2,min);
  While (min.nProv<>valor_alto) Do
    Begin
      read(a,aux);
      While (aux.nProv<>min.nProv) Do
        Read(a,aux);
      While (aux.nProv= min.nProv) Do
        Begin
        aux.cant := aux.cant + min.cant;
        aux.totEnc := aux.totEnc+min.cantEnc;
        minimo(d1,d2,r1,r2,min);
        End;
      seek(a, FilePos(a)-1);
      write(a,aux);
    End;
End;

procedure verArchivo(var a :arch);
var
  r:rArchivo;
begin
  reset(a);
  while(not eof(a))do begin
    read(a,r);
    writeln(r.nProv,': alfabetizados: ',r.cant,'; total encuestados: ',r.totEnc);
  end;
  close(a);
  WriteLn('fin muestra de archivo');
end;
Var 
  a: arch;
  d1,d2: det;
Begin
  crearBin(a,d1,d2);
  procesarArchivo(a,d1,d2);
  verArchivo(a);
End.
