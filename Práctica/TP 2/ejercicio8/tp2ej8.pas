{Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente.
Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta.
El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras.}

program tp2ej8;
const
    valor_alto = 9999;
type
    cliente=record
        cod:integer;
        nombre:string;
        apellido:string;
    end;
    venta=record
        c:cliente;
        anio:integer;
        mes:integer;
        dia:integer;
        monto:integer;
    end;
    archivo = file of venta;


procedure leer(var a : archivo ; var v: venta);
begin
    if (not eof (a))then
        read(a,v)
    else
        v.c.cod:= valor_alto;
end;

procedure crearBin(var a:archivo);
var
    txt: Text;
    v:venta;
begin
    assign(a,'ventas');
    assign(txt,'ventas.txt');
    reset(txt);
    rewrite(a);
    while not eof(txt) do begin
        with v do begin
            readln(txt,c.cod,anio,mes,dia,monto,c.nombre);
            readln(txt,c.apellido);
        end;
        write(a,v);
    end;
    close(txt);
    close(a);
end;
  
  
procedure recorrerArchivo(var a:archivo);
var 
    v,actual:venta;
    montoM,montoA,montoTot:integer;
begin
    assign(a,'ventas');
    reset(a);
    leer(a,v);
    montoTot:=0;
    while(v.c.cod<>valor_alto)do begin
        actual:=v;
        Writeln('----------------------------------------------------------------------------------------');
        WriteLn('codigo: ',actual.c.cod, ' apellido: ',actual.c.apellido,' Nombre: ', actual.c.nombre);
        while(actual.c.cod=v.c.cod)do begin
            actual.anio:=v.anio;
            montoA:=0;
            while(actual.c.cod=v.c.cod)and(actual.anio= v.anio)do begin
                actual.mes:=v.mes;
                montoM:=0;
                while(actual.c.cod=v.c.cod)and(actual.anio= v.anio)and(actual.mes=v.mes)do begin
                    montoM:= montoM + v.monto;
                    leer(a,v);
                end;
                writeln('En el anio ',actual.anio,', mes ',actual.mes, ' se acumulo: $',montoM);
                montoA:= montoA + montoM;
            end;
            writeln('Monto total del anio ',actual.anio,': $',montoA);
            montoTot:=montoTot+montoA;
        end;
    end;
    WriteLn('------------------------------------------------------------------------------------------');
    writeln('Monto total de la empresa : $',montoTot);
    close(a);
end;       

var 
    a:archivo;
  
begin
    crearBin(a);
    recorrerArchivo(a);
end.