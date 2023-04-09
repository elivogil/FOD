{7- El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos
los productos que comercializa. De cada producto se maneja la siguiente información:
código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas de productos
realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas.
Se pide realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.}

program tp2ej7;
const 
    valor_alto=9999;
type 
    producto= record
        cod : integer;
        nombre: string;
        precio: Integer;
        stock_actual: integer;
        stock_min: integer;
    end;

    venta=record
        cod:integer;
        cant:integer;
    end;

    maestro=file of producto;
    detalle=file of venta;

procedure actualizarMaestro(var m:maestro);

    procedure leer(var d:detalle;var ven:venta);
    begin
        if(not eof(d))then
            read(d,ven)
        else
            ven.cod:=valor_alto;
    end;
var
    d:detalle;
    ven:venta;
    prod:producto;
begin
    assign(d,'detalle.bin');
    reset(d);
    leer(d,ven);
    while(ven.cod<>valor_alto)do begin
        read(m,prod);
        while(prod.cod<>ven.cod)do
            read(m,prod);
        while(prod.cod=ven.cod)do begin
            prod.stock_actual:=prod.stock_actual-ven.cant;
            leer(d,ven);
        end;
        seek(m,FilePos(m)-1);
        write(m,prod);
    end;
    close(d);
    close(m);    
    WriteLn('Actualizacion de maestro generado con exito');
end;

procedure minTxt(var m : maestro);
var
  aux: producto;
  txt: text;
begin
  reset(m);
  assign(txt,'productosMin.txt');
  rewrite(txt);
  while not eof (m) do begin
    read(m,aux);
    with aux do 
        if stock_actual<stock_min then 
            writeln (txt, cod ,' ', stock_actual,' ',stock_min,' ', precio,' ',nombre);
  end;
  close(m);
  close(txt);  
  WriteLn('Reporte generados con exito');
end;  

var
    m:maestro;
begin
    assign(m,'maestro.bin');
    reset(m);
    actualizarMaestro(m);
    minTxt(m);
end.