
Program tp2ej6;

Const 
  valorAlto = 9999;
  df = 10;

Type 
  reporteD = Record
    codigoLocalidad: integer;
    codigoCepa: integer;
    cantActivos: integer;
    cantNuevos: integer;
    cantRecuperados: integer;
    cantFallecidos: integer;
  End;
  reporteM = Record
    codigoLocalidad: integer;
    nombreLocalidad: string[30];
    codigoCepa: integer;
    nombreCepa: string[30];
    cantActivos: integer;
    cantNuevos: integer;
    cantRecuperados: integer;
    cantFallecidos: integer;
  End;
  detalle = file Of reporteD;
  maestro = file Of reporteM;
  vDetalle = array [1..10] Of detalle;
  vRegistro = array [1..10] Of reporteD;

Procedure leer (Var det: detalle; Var aux : reporteD);
Begin
  If (Not eof(det)) Then
    read(det, aux)
  Else
    aux.codigoLocalidad := valorAlto;
End;

Procedure minimo(Var vD:vDetalle; Var vR: vRegistro; Var min:reporteD);
Var 
  i, pos: integer;
Begin
  min.codigoLocalidad:=valorAlto;
  min.codigoCepa:=valorAlto;
  For i:=1 To df Do
    Begin
      If ((vR[i].codigoLocalidad< min.codigoLocalidad) Or ((vR[i].
         codigoLocalidad = min.codigoLocalidad) And (vR[i].codigoCepa<min.
         codigoCepa))) Then
        Begin
          pos := i;
          min := vR[i];
        End;
    End;
  If (min.codigoLocalidad<>valorAlto) Then begin
    WriteLn('leo1: ',pos);
    leer(vD[pos], vR[pos]);
    WriteLn('leo2');
  end;
End;

Procedure verMaestro (Var mae: maestro);
Var 
  regMae: reporteM;
Begin
  assign(mae, 'maestro');
  reset(mae);
  While (Not eof(mae)) Do
    Begin
      read(mae,regMae);
      writeln('nombreLocalidad: ', regMae.codigoLocalidad, ' codigoCepa: ',regMae.codigoCepa);
      writeln('Nuevos: ', regMae.cantNuevos, ' Fallecidos: ', regMae.cantFallecidos);
      writeln('Recuperados: ', regMae.cantRecuperados, ' Activos: ',regMae.cantActivos);
    End;
  close(mae);
End;
//ASIGNAR MAESTRO Y DETALLES
Procedure asignarMyD(Var mae: maestro;var vDet:vDetalle; Var vReg:vRegistro);
Var 
  i: integer;
  iString: string[30];
Begin
  For i:= 1 To df Do
    Begin
      Str(i, iString);
      assign(vDet[i], 'detalle'+iString);
      reset(vDet[i]);
      leer(vDet[i], vReg[i]);
    End;
  assign(mae,'maestro');
  reset(mae);
End;

Var 
  vDet: vDetalle;
  vReg: vRegistro;
  mae: maestro;
  min: reporteD;
  regMae: reporteM;
  i: integer;
Begin
  //verMaestro(mae);
  asignarMyD(mae,vDet,vReg);
  min.codigoLocalidad:= valorAlto;
  //ACTUALIZAR MAESTRO
  minimo(vDet, vReg, min);
  While (min.codigoLocalidad <> valorAlto) Do
    Begin
      read(mae, regMae);
      While (regMae.codigoLocalidad <> min.codigoLocalidad) Or (regMae.codigoCepa<>min.codigoCepa) Do Begin
          read(mae,regMae);
        End;
      While ((regMae.codigoLocalidad = min.codigoLocalidad) And (regMae.codigoCepa = min.codigoCepa)) Do
        Begin
          regMae.cantFallecidos := regMae.cantFallecidos + min.cantFallecidos;
          regMae.cantRecuperados := regMae.cantRecuperados + min.cantRecuperados;
          regMae.cantActivos := min.cantActivos;
          regMae.cantNuevos := min.cantNuevos;
          minimo(vDet, vReg, min);
        End;
      seek(mae, filePos(mae)-1);
      Write(mae, regMae);
    End;
  //CIERRE MAESTRO Y DETALLES
  close(mae);
  For i:=1 To df Do
    close(vDet[i]);
  verMaestro(mae);
End.
