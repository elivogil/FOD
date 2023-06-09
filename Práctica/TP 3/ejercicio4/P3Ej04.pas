program P3Ej04;
type
    reg_flor=record
        nombre:String[45];
        cod:integer;
    end;
    archivo=file of reg_flor;


procedure crearArchivo();

    procedure ingresarDatos(var arc:archivo);
    var
        f:reg_flor;
    begin
        f.cod:=0;
        write(arc,f);
        writeln('');
        writeln('Para terminar de cargar el archivo, ingrese un codigo menor a 1');
        writeln('Ingresar codigo:');
        readln(f.cod);
        while(f.cod>0)do begin
            writeln('Ingresar nombre:');
            readln(f.nombre);
            write(arc,f);
            writeln('');            
            writeln('Para terminar de cargar el archivo, ingrese un codigo menor a 1');
            writeln('Ingresar codigo:');
            readln(f.cod);
        end;
    end;            

var
    arc:archivo;
begin
    assign(arc,'flores.bin');
    rewrite(arc);
    ingresarDatos(arc);
    close(arc);
end;


procedure agregarFlor(var a:archivo);

    procedure leerDatos(var f:reg_flor);
    begin
        writeln('');
        writeln('Ingresar codigo de la flor');
        read(f.cod);
        writeln('');
        writeln('Ingresar nombre de la flor');
        read(f.nombre);
    end;

var
    f:reg_flor;
    pos:integer;
begin
    read(a,f);
    if(f.cod=0)then begin
        writeln('');
        writeln('El archivo esta lleno');
    end
    else begin
        pos:=f.cod*-1;
        seek(a,pos);
        read(a,f);
        seek(a,0);
        write(a,f);
        seek(a,pos);
        leerDatos(f);
        write(a,f);
    end;
end;
    

procedure exportar(var a:archivo);
var
    txt:text;
    f:reg_flor;
begin
    assign(txt,'flores.txt');
    rewrite(txt);
    seek(a,1);
    while(not eof(a))do begin
        read(a,f);
        if(f.cod>0)then
            with f do
                writeln(txt,cod,' ',nombre);
    end;
    close(txt);
end;


procedure subMenu();

    procedure mensajeSubMenu2(var num:integer);
    begin
        writeln('');
        writeln('Presione "1" si desea agregar una flor');
        writeln('Presione "2" si desea exportar a un archivo de texto');
        writeln('Presione "3" para salir del archivo');
        readln(num);
    end;

var
    arc:archivo;
    num:integer;
    arcNomb:string;
begin
    assign(arc,'flores.bin');
    mensajeSubMenu2(num);
    while(num<>3)do begin
        reset(arc);
        case(num)of
            1:agregarFlor(arc);
            2:exportar(arc);
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

