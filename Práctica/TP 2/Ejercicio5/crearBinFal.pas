Program crearBinFal;
Type 
  strini = String[30];
  dire = Record
    calle: integer;
    nro: integer;
    piso: integer;
    depto: integer;
    ciudad: strini;
  End;
  reg_fallecido = Record
    nro_partida : Integer;
    DNI : integer;
    nombre : strini;
    apellido : strini;
    mat_medico : Integer;
    fecha_fallece : string [8];
    hora_deceso : string[5];
    lugar_deceso : strini;
  End;
  det_fal = file Of reg_fallecido;

Var 
  aux : reg_fallecido;
  txt : Text;
  nombre, n_bin: strini;
  i: Integer;
  i_string: string[1];
  det: det_fal;
Begin
  For i:= 1 To 3 Do
    Begin
      str(i, i_string);
      nombre := 'Fal ('+i_string+').txt';
      n_bin := 'Fal ('+i_string+')';
      Assign(txt,nombre);
      Assign(det,n_bin);
      Reset(txt);
      Rewrite(det);
      While Not eof (txt) Do
        Begin
          With aux Do
            Begin
              readln(txt,nro_partida,DNI, nombre);
              readln(txt,apellido);
              readln(txt,mat_medico,fecha_fallece);
              readln(txt,hora_deceso);
              readln(txt,lugar_deceso);
            End;
          write(det,aux);  
        End;
      close(txt);
    End;
  close(det);
  WriteLn('Archivos creados con exito!');
End.