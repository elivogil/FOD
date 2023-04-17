program P3Ej02;
const 
    corte=-1;
type
    asistente=record
        num:integer;
        apellido:string;
        nombre:string;
        email:string;
        telefono:longint;
        dni:longint;
    end;

    archivo=file of asistente;


procedure crearArchivo(var a:archivo);

    procedure leerDatos(var reg:asistente);
    begin
        writeln('');
        writeln('Ingresar numero de empleado:');
        readln(reg.num);
        if(reg.num>0)then begin
            writeln('');
            writeln('Ingresar apellido de empleado:');
            readln(reg.apellido);
            reg.nombre:='carlos';
            reg.email:='juancho@hotmail.com';
            reg.telefono:=11234567;
            reg.dni:=54312;
        end;
    end;

var
    reg:asistente;
begin
    assign(a,'asistentes.bin');
    rewrite(a);
    leerDatos(reg);
    while(reg.num>0)do begin
        write(a,reg);
        leerDatos(reg);
    end;
    close(a);
end;


procedure imprimirArchivo(var a:archivo);
var
    reg:asistente;
begin
    reset(a);
    writeln('');
    while(not eof(a))do begin
        read(a,reg);
        writeln('Numero de asistente: ',reg.num,'; apellido: ',reg.apellido);
    end;
end;


procedure eliminar(var a:archivo);

    procedure leer(var a:archivo;var reg:asistente);
    begin
        if(not eof(a))then
            read(a,reg)
        else 
            reg.num:=-1;
    end;

var
    reg:asistente;
begin
    reset(a);
    leer(a,reg);
    while(reg.num<>corte)do begin
        if(reg.num<1000)then begin
            reg.apellido:='@'+reg.apellido;
            seek(a,filepos(a)-1);
            write(a,reg);
        end;
        leer(a,reg);
    end;
    close(a);
end;


var 
    a:archivo;
begin
    crearArchivo(a);
    imprimirArchivo(a);
    eliminar(a);
    imprimirArchivo(a);
end.