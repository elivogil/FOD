program P2Ej03;
const 
    dimF=30;
    corte=9999;
type 
    producto=record
        cod:integer;
        nombre:string[30];
        desc:string[50];
        stockDisp:integer;
        stockMin:integer;
        precio:real;
    end;
    producto_detalle=record 
        cod:integer;
        cant:integer;
    end;
    maestro=file of producto;
    detalle=file of producto_detalle;
    vector_detalle=array[1..dimF]of detalle;
    vector_producto=array[1..dimF]of producto_detalle;


procedure actualizarMaestro(var m:maestro);

    procedure leer(var d:detalle;var p:producto_detalle);
    begin
        if(not eof(d))then
            read(d,p)
        else
            p.cod:=corte;
    end;

    procedure cargarDetalles(var vD:vector_detalle;var vP:vector_producto);
    var
        iString,nombre:string;
        i:integer;
    begin
        for i:=1 to dimF do begin
            str(i,iString);
            nombre:=('detalle1 (' + iString + ')');
            assign(vD[i],nombre);
            reset(vD[i]);
            leer(vD[i],vP[i]);
        end;
    end;

    procedure minimo(var vD:vector_detalle;var vP:vector_producto;var p:producto_detalle);
    var
        posMin,i:integer;
    begin
        p.cod:=corte;
        for i:=1 to dimF do 
            if(vP[i].cod<p.cod)then begin
                p:=vP[i];
                posMin:=i;
            end;
        if(p.cod<>corte)then
            leer(vD[posMin],vP[posMin]);
    end;

var
    vD:vector_detalle;
    vP:vector_producto;
    prod:producto;
    prodDet:producto_detalle;
    i:integer;
begin
    reset(m);
    cargarDetalles(vD,vP);
    minimo(vD,vP,prodDet);
    while(prodDet.cod<>corte)do begin
        read(m,prod);
        while(prod.cod<>prodDet.cod)do begin
            read(m,prod);
        end;
        while(prod.cod=prodDet.cod)do begin
            prod.stockDisp:=prod.stockDisp-prodDet.cant;
            minimo(vD,vP,prodDet);
        end;
        seek(m,FilePos(m)-1);
        write(m,prod);
    end;
    for i:=1 to dimF do
        close(vD[i]);
    close(m);
    Writeln('Actualizacion realizada con exito');
end;


procedure exportar(var m:maestro);
var
    texto:text;
    p:producto;
begin
    reset(m);
    assign(texto,'productos.txt');
    rewrite(texto);
    while(not eof(m))do begin
        read(m,p);
        if(p.stockDisp<p.stockMin)then
            with p do begin
                writeln(texto,precio:0:2,' ',nombre);
                writeln(texto,stockDisp,' ',desc);
            end;
    end;
    close(texto);
    close(m);
    writeln('Archivo exportado con exito');
end;


var 
    m:maestro;
begin
    assign(m,'maestro');
    actualizarMaestro(m);
    exportar(m);
end.