program P3Ej06;
const 
    corte=-1;
type
    prenda=record
        cod:integer;
        descripcion:string;
        colores:string;
        tipo:string;
        stock:integer;
        precio:real;
    end;

    maestro=file of prenda;
    detalle=file of integer;


procedure actualizarMaestro(var m:maestro);

    procedure leer(var d:detalle;var cod:integer);
    begin
        if(not eof(d))then
            read(d,cod)
        else 
            cod:=corte;
    end;

var
    d:detalle;
    p:prenda;
    cod:integer;
begin
    
    assign(m,'maestro.bin');
    reset(m);
    assign(d,'detalle.bin');
    reset(d);
    writeln('asigno los archivos');
    leer(d,cod);
    while(cod<>corte)do begin
        read(m,p);
        while(not eof(m))and(p.cod<>cod)do  
            read(m,p);
        if(p.cod=cod)then begin
            p.stock:=-1;
            seek(m,filepos(m)-1);
            write(m,p);
        end;
        seek(m,0);
        leer(d,cod);
    end;
    close(m);
    close(d);
    writeln('Termine de actualziar');
end;


procedure compactarMaestro(var m,nuevo:maestro);
var
    p:prenda;
begin
    assign(nuevo,'temporal');
    rewrite(nuevo);
    reset(m);
    while(not eof(m))do begin
        read(m,p);
        if(p.stock>=0)then
            write(nuevo,p);
    end;
    close(m);
    erase(m);
    close(nuevo);
    rename(nuevo,'maestro.bin');
end;


procedure imprimirNuevo(var nuevo:maestro);
var
    p:prenda;
begin
    reset(nuevo);
    while(not eof(nuevo))do begin
        read(nuevo,p);
        writeln(p.cod);
    end;
end;


var
    m,nuevo:maestro;
begin
    actualizarMaestro(m);
    compactarMaestro(m,nuevo);
    imprimirNuevo(nuevo);
end.