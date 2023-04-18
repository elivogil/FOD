program P3Ej07;
const 
    corte=5000;
type
    ave=record
        cod:integer;
        nombre:string;
        familia:string;
        descripcion:string;
        zona:string;
    end;

    maestro=file of ave;


procedure marcarMaestro(var m:maestro);
var
    a:ave;
    cod:integer;
begin
    assign(m,'maestro.bin');
    reset(m);
    writeln('');
    writeln('Ingresar codigo de especie a borrar');
    readln(cod);
    while(cod<>corte)do begin
        read(m,a);
        while(not eof(m))and(a.cod<>cod)do
            read(m,a);
        if(a.cod=cod)then begin
            a.cod:=-1;
            seek(m,filepos(m)-1);
            write(m,a);
        end
        else begin
            writeln('');
            writeln('El codigo no existe o ya fue borrado');
        end;
        seek(m,0);
        writeln('');
        writeln('Ingresar codigo de especie a borrar');
        readln(cod);
    end;
    close(m);
end;


procedure eliminar(var m:maestro);

    procedure leer(var m:maestro;var a:ave);
    begin
        if(not eof(m))then
            read(m,a)
        else 
            a.cod:=corte;
    end;

var
    a:ave;
    pos:integer;
begin
    reset(m);
    leer(m,a);
    while(a.cod<>corte)do begin
        if(a.cod=-1)then begin
            if(filepos(m)=filesize(m))then begin
                seek(m,filepos(m)-1);
                truncate(m);
            end
            else begin
                pos:=filepos(m)-1;
                seek(m,filesize(m)-1);
                read(m,a);
                seek(m,filepos(m)-1);
                truncate(m);
                seek(m,pos);
                write(m,a);
                seek(m,filepos(m)-1);
            end;
        end;
        leer(m,a);
    end;
    close(m);
end;


procedure imprimir(var m:maestro);
var
    a:ave;
begin
    reset(m);
    writeln('');
    while(not eof(m))do begin
        read(m,a);
        writeln(a.cod);
    end;
end;


var
    m:maestro;
begin
    marcarMaestro(m);
    imprimir(m);
    eliminar(m);
    imprimir(m);
end.