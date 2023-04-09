program P1Ej01;
type
    archivo = file of integer;


procedure crearArchivo(var a:archivo);

    procedure cargarArchivo(var a:archivo);
    var
        num:integer;
    begin
        writeln('Ingresar un numero entero:');
        readln(num);
        while(num<>30000)do begin
            write(a,num);
            writeln('Ingresar un numero entero:');
            readln(num);
        end;
    end;

var
    nombre:string;
begin
    writeln('Ingresar nombre del archivo:');
    readln(nombre);
    assign(a,nombre);
    rewrite(a);
    cargarArchivo(a);
    close(a);
end;


var 
    a:archivo;
begin
    crearArchivo(a);
end.