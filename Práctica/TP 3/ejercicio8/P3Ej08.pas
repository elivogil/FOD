program P3Ej08;
const 
    corte='zzz';
type
    distri=record
        nombre:string;
        anio:integer;
        kernel:integer;
        developers:integer;
        descripcion:string;
    end;

    archivo=file of distri;


procedure crearArchivo();

    procedure ingresarDatos(var arc:archivo);
    var
        d:distri;
    begin
        d.developers:=0;
        write(arc,d);
        writeln('');
        writeln('Para terminar de cargar el archivo, ingrese "zzz"');
        writeln('Ingresar nombre:');
        readln(d.nombre);
        while(d.nombre<>corte)do begin
            d.anio:=random(50)+1970;
            d.kernel:=random(1000)+1;
            d.developers:=random(100)+1;
            d.descripcion:='hsaufwjdh';
            write(arc,d);
            writeln('');            
            writeln('Para terminar de cargar el archivo, ingrese "zzz"');
            writeln('Ingresar nombre:');
            readln(d.nombre);
        end;
    end;            

var
    arc:archivo;
begin
    assign(arc,'distribuciones.bin');
    rewrite(arc);
    ingresarDatos(arc);
    close(arc);
end;


function existeDistribucion(var a:archivo;nombre:string):boolean;

    procedure leer(var a:archivo;var d:distri);
    begin
        if(not eof(a))then
            read(a,d)
        else
            d.nombre:=corte;
    end;

var
    d:distri;
    ok:boolean;
begin
    ok:=false;
    leer(a,d);
    while(d.nombre<>corte)and(not ok)do begin
        if(d.nombre=nombre)then
            ok:=true
        else
            leer(a,d);
    end;
    existeDistribucion:=ok;
end;


procedure altaDistribucion(var a:archivo);
var
    nombre:string;
    d:distri;
    pos:integer;
begin
    read(a,d);
    if(d.developers=0)then begin
        writeln('');
        writeln('El archivo esta lleno');
    end
    else begin
        writeln('');
        writeln('Ingresar nombre de la distribucion');
        readln(nombre);
        if(existeDistribucion(a,nombre))then begin
            writeln('');
            writeln('Ya existe la distribucion');
        end
        else begin
            pos:=d.developers*-1;
            seek(a,pos);
            read(a,d);
            seek(a,0);
            write(a,d);
            seek(a,pos);
            d.nombre:=nombre;
            d.anio:=random(50)+1970;
            d.kernel:=random(1000)+1;
            d.developers:=random(100)+1;
            d.descripcion:='hsaufwjdh';
            write(a,d);
            writeln('');
            writeln('Distribucion agregada con exito');
        end;
    end;
end;


procedure bajaDistribucion(var a:archivo);
var
    nombre:string;
    d:distri;
    pos:integer;
begin
    seek(a,1);
    writeln('');
    writeln('Ingresar nombre de la distribucion');
    readln(nombre);
    if(not existeDistribucion(a,nombre))then begin
        writeln('');
        writeln('Distribucion no existente');
    end
    else begin
        pos:=filepos(a)-1;
        reset(a);
        read(a,d);
        seek(a,pos);
        write(a,d);
        seek(a,0);
        d.developers:=pos*-1;
        write(a,d);
    end;
end;


procedure exportar(var a:archivo);
var
    txt:text;
    d:distri;
begin
    assign(txt,'distribuciones.txt');
    rewrite(txt);
    seek(a,1);
    while(not eof(a))do begin
        read(a,d);
        if(d.developers>0)then
            with d do begin
                writeln(txt,developers,' ',nombre);
                writeln(txt,anio,' ',kernel,' ',descripcion);
            end;
    end;
    close(txt);
end;


procedure subMenu();

    procedure mensajeSubMenu2(var num:integer);
    begin
        writeln('');
        writeln('Presione "1" si desea agregar una distribucion');
        writeln('Presione "2" si desea eliminar una distribucion');
        writeln('Presione "3" si desea exportar a un archivo de texto');
        writeln('Presione "4" para salir del archivo');
        readln(num);
    end;

var
    arc:archivo;
    num:integer;
    arcNomb:string;
begin
    assign(arc,'distribuciones.bin');
    mensajeSubMenu2(num);
    while(num<>4)do begin
        reset(arc);
        case(num)of
            1:altaDistribucion(arc);
            2:bajaDistribucion(arc);
            3:exportar(arc);
        else begin
            writeln('');
            writeln('Opcion no valida, intente de nuevo');
        end;
        end;
        close(arc);
        mensajeSubMenu2(num);
    end;
end;


procedure menu();

    procedure mensajeMenuPrincipal(var num:integer);
    begin
        writeln('');
        writeln('Bienvenido al menu principal');
        writeln('Presione "1" si desea crear un archivo');
        writeln('Presione "2" si desea abrir un archivo');
        writeln('Presione "3" para salir');
        readln(num);
    end;

var
    num:integer;
begin
    mensajeMenuPrincipal(num);
    while(num<>3)do begin
        case(num)of
            1:crearArchivo;
            2:subMenu;
        else begin
            writeln('');
            writeln('Opcion no valida, intente de nuevo');
        end;
        end;
        mensajeMenuPrincipal(num);
    end;
    writeln('');
    writeln('Adios!');
end;



begin
    menu;
end.