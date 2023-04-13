
{16. La editorial X, autora de diversos semanarios, posee un archivo maestro con la
información correspondiente a las diferentes emisiones de los mismos. De cada emisión se
registra: fecha, código de semanario, nombre del semanario, descripción, precio, total de
ejemplares y total de ejemplares vendido.
Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información queposeen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas.

 Además deberá informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo}


Program  tp2ej16;

Const 
  df = 5;
  valor_alto = 999999;

Type 
  emision = Record
    fecha: LongInt;
    cod: integer;
    nombre: string;
    descripcion: string;
    precio: integer;
    totEjempl: integer;
    totVendido: integer;
  End;

  venta = Record
    fecha: LongInt;
    cod: integer;
    cant: integer;
  End;

  maestro = file Of emision;
  detalle = file Of venta;
  vDet = array[1..df] Of detalle;
  vReg = array [1..df] Of venta;


Procedure leer(Var det : detalle; Var reg : venta);
Begin
  If (Not eof (det)) Then
    read(det,reg)
  Else
    reg.fecha := valor_alto;
End;

Procedure minimo(Var vD:vDet;Var vR:vReg;Var min:venta);

Var 
  i,pos: integer;
Begin
  min.fecha := valor_alto;
  min.cod := valor_alto;
  For i:=1 To df Do
    If (vR[i].fecha<min.fecha)Or((vR[i].fecha=min.fecha)And(vR[i].cod<min.cod))
      Then
      Begin
        min := vR[i];
        pos := i;
      End;
  If (min.fecha<>valor_alto)Then
    leer(vD[pos],vR[pos]);
End;

Procedure actualizarMaestro(Var m: maestro; Var vD : vDet);
Var 
  vR: vReg;
  min: venta;
  i: integer;
  auxM: emision;
Begin
  reset(m);

  For i:= 1 To df Do
    Begin
      reset(vD[i]);
      leer(vD[i],vR[i]);
    End;
  minimo(vD,vR,min);
  While min.fecha<> valor_alto Do
    Begin
      read(m,auxM);
      While (auxM.fecha<>min.fecha) Or (auxM.cod<>min.cod) Do
        read(m,auxM);
      While (auxM.fecha=min.fecha) And (auxM.cod=min.cod) Do
        Begin
          auxM.totEjempl := auxM.totEjempl - min.cant;
          auxM.totVendido := auxM.totVendido + min.cant;
          minimo(vD,vR,min);
        End;
      seek (m, FilePos(m)-1);
      write(m,auxM);
    End;
  close(m);
  For i:= 1 To df Do
    close(vD[i]);
End;

Procedure minMax(Var m:maestro);

Var 
  min,max,reg: emision;
Begin
    WriteLn('****************************************************************');
  max.totVendido := -1;
  min.totVendido := valor_alto;
  reset(m);
  While (Not eof(m)) Do
    Begin
      read(m,reg);
      If (reg.totVendido>max.totVendido)Then
        max := reg;
      If (reg.totVendido<min.totVendido)Then
        min := reg;
    End;
  writeln('Semanario mas vendido: fecha: ',max.fecha,'; codigo: ',max.cod);
  writeln('Semanario menos vendido: fecha: ',min.fecha,'; codigo: ',min.cod);
  close(m);
    WriteLn('****************************************************************');
End;

Procedure asignar(Var m: maestro; Var vD : vDet);

Var 
  i: integer;
  iString: string;
Begin
  Assign(m,'maestro.bin');
  For i:=1 To df Do
    Begin
      str(i,iString);
      assign(vD[i],'det'+iString+'.bin');
    End;
  Writeln('termine de asignar');
End;
Procedure verDet(Var d:detalle);
Var 
  aux: venta;
Begin
  WriteLn('Imprimimos detalle');
  reset(d);
  While Not eof(d) Do
    Begin
      read(d,aux);
      With aux Do
        Begin
          writeln('Codigo: ',cod,' Cantidad: ',cant,' fecha: ',fecha);
        End;
    End;
    close(d);
End;
Procedure vermae(Var m:maestro);
Var 
  aux: emision;
Begin
  WriteLn('Imprimimos maestro');
  reset(m);
  While Not eof(m) Do
    Begin
      read(m,aux);
      With aux Do
        Begin
          writeln('Nombre: ',nombre);
          writeln('Descripcion: ',descripcion);
          writeln('Codigo: ',cod,' totalEjmpl: ',totEjempl,' tot Vend: ',totVendido,' precio: ',precio,' fecha: ',fecha);
        End;
    End;
    close(m);
End;

Var 
  m: maestro;
  vD: vDet;
Begin
  asignar(m,vD);
  vermae(m);
  actualizarMaestro(m,vD);
  minMax(m);
  vermae(m);
 
 
End.
