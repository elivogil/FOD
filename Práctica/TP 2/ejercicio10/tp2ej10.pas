
{Se tiene información en un archivo de las horas extras realizadas por los empleados de
una empresa en un mes. Para cada empleado se tiene la siguiente información:
departamento, división, número de empleado, categoría y cantidad de horas extras
realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por
departamento, luego por división, y por último, por número de empleados. Presentar en
pantalla un listado con el siguiente formato:
Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ____
Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.
    
}

Program tp2ej10;

Const 
  valor_alto=9999;
  df=15;
type
    horas=record
        cat:integer;
        val:integer;
    end;
    empleado = Record
        dto: integer;
        divi: Integer;
        n_emp: Integer;
        cat: integer;
        hs: integer;
    End;
    archivo = file of empleado;
    vector=array [1..df] of Integer;


procedure leer(var a:archivo; var e:empleado);
begin
  if not eof (a) then
    read(a,e)
  else 
    e.dto := valor_alto;
end;


procedure importarVector(var v:vector);
var
  txt: Text;
  h:horas;
begin
    assign(txt,'valores.txt');
    reset(txt);
    while(not eof(txt))do begin
        with h do
            readln(txt,cat,val);
        v[h.cat]:=h.val;
    end;
    close(txt);
    writeln('array creado con exito');
end;


Procedure crearBin(Var a:archivo);
Var 
  txt: Text;
  e:empleado;
Begin
  assign(a,'empleados');
  assign(txt,'empleados.txt');
  reset(txt);
  rewrite(a);
  While Not eof(txt) Do
    Begin
      With e Do
        readln(txt,dto,divi,n_emp,cat,hs);
      write(a,e);
    End;
  close(txt);
  close(a);
  WriteLn('binario creado con exito');
End;

procedure procesarArchivo(var a:archivo;v:vector);
var
    e,actual:empleado;
    depHoras,depMonto,diviHoras,diviMonto,monto:integer;
begin
    assign (a,'empleados');
    reset(a);
    leer(a,e);
    while (e.dto<>valor_alto)do begin
      actual.dto:=e.dto;
      depHoras:=0;
      depMonto:=0;
      writeln('Departamento: ', e.dto);
      while (actual.dto=e.dto)do begin
        diviHoras:=0;
        diviMonto:=0;
        actual.divi:= e.divi;
        writeln('Division: ', e.divi);
        while (actual.dto=e.dto)and (actual.divi=e.divi) do begin
          monto:=e.hs*v[e.cat];
          writeln('Numero de empleado: ',e.n_emp,', total de horas: ',e.hs,', importe a cobrar: ',monto);
          diviHoras:=diviHoras+e.hs;
          diviMonto:= diviMonto + monto;
          leer(a,e);
        end;
        writeln('Total horas division: ',diviHoras);
        writeln('Monto total division: ',diviMonto);
        depMonto:=depMonto+diviMonto;
        depHoras:=depHoras+diviHoras;
      end;
      WriteLn('Horas total departamento: ',depHoras);
      WriteLn('Monto total departamento: ',depMonto);
    end;
    close(a);
    writeLn('Fin de procesamiento');
end;

var
    a:archivo;
    v:vector;
begin
    crearBin(a);
    importarVector(v);
    procesarArchivo(a,v);
end.
