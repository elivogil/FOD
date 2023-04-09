
Program crearBinNac;

Type 
  strini = String[30];
  dire = Record
    calle: integer;
    nro: integer;
    piso: integer;
    depto: integer;
    ciudad: strini;
  End;
  reg_nac = Record
    nro_partida : integer;
    nombre : strini;
    apellido: strini;
    direccion : dire;
    mat_medico: integer;
    nombre_madre: strini;
    apellido_madre: strini;
    dni_madre: integer;
    nombre_padre: strini;
    apellido_padre: strini;
    dni_padre: integer;
  End;
  det_nac = file Of reg_nac;

Var 
  aux : reg_nac;
  txt : Text;
  nombre, n_bin: strini;
  i,A: Integer;
  i_string: string[1];
  det: det_nac;

Begin
  For i:= 1 To 3 Do
    Begin
      str(i, i_string);
      nombre := 'Nac ('+i_string+').txt';
      n_bin := 'Nac ('+i_string+')';
      Assign(txt,nombre);
      Assign(det,n_bin);
      Reset(txt);
      Rewrite(det);

      While Not eof (txt) Do Begin
          With aux Do
            Begin
              ReadLn(txt,nro_partida,nombre);
              readLn(txt,apellido);
              With direccion Do
                readLn(txt,calle,nro,piso,depto,ciudad);
              readLn(txt,mat_medico,nombre_madre);
              readLn(txt,apellido_madre);
              readLn(txt,dni_madre,nombre_padre);
              readLn(txt,dni_padre,apellido_padre);
          End;
          write(det,aux);
        End;
      close(txt);

  End;
  close(det);
  WriteLn('Archivos creados con exito!');
End.