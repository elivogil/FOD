program P1Ej07;
type
    novela = record
        cod:integer;
        nombre:string;
        genero:string;
        precio:real;
    end;
    archivo = file of novela;


procedure cargarNovela(var nov:novela);
begin
    writeln('');
    writeln('Para cancelar la carga, ingresa "-1"');
    writeln('Ingresar codigo de novela');
    readln(nov.cod);
    if(nov.cod<>-1)then begin
        writeln('');
        writeln('Ingresar el nombre');
        readln(nov.nombre);
        writeln('');
        writeln('Ingresar el genero');
        readln(nov.genero);
        writeln('');
        writeln('Ingresar el precio');
        readln(nov.precio);
    end;
end;


procedure crearTexto;
var
    texto:text;
    nov:novela;
begin
    assign(texto,'novelas.txt');
    rewrite(texto);
    cargarNovela(nov);
    while(nov.cod<>-1)do begin
        with nov do begin
            writeln(texto,cod,' ',precio:0:2,' ',genero);
            writeln(texto,nombre);
        end;
        cargarNovela(nov);
    end;
    close(texto);
end;


procedure crearArchivo;
var
    arc:archivo;
    texto:text;
    nov:novela;
    nombre:string;
begin
    assign(texto,'novelas.txt');
    reset(texto);
    writeln('');
    writeln('Ingresar nombre del archivo');
    readln(nombre);
    assign(arc,nombre);
    rewrite(arc);
    while(not eof(texto))do begin
        with nov do begin
            readln(texto,cod,precio,genero);
            readln(texto,nombre);
        end;
        write(arc,nov);
    end;
    close(texto);
    close(arc);
end;


procedure agregarNovela(var arc:archivo);
var
    nov:novela;
begin
    cargarNovela(nov);
    if(nov.cod<>-1)then begin
        seek(arc,fileSize(arc));
        write(arc,nov);
    end;
end;


procedure modificarNovela(var arc:archivo);
var
    cod:integer;
    nov:novela;
    ok:boolean;
begin
    ok:=false;
    writeln('');
    writeln('Ingresar el codigo de novela');
    readln(cod);
    while(not eof(arc))and(not ok)do begin
        read(arc,nov);
        if(nov.cod=cod)then begin
            ok:=true;
            cargarNovela(nov);
            if(nov.cod<>-1)then begin
                seek(arc,filePos(arc)-1);
                write(arc,nov);
            end;
        end;
    end;
    if(not ok)then begin
        writeln('');
        writeln('No se encuentra la novela en el archivo');
    end;
end;


procedure subMenu();

    procedure mensajeSubMenu1(var arcNomb:string);
    begin
        writeln('');
        writeln('Ingrese nombre del archivo que desea abrir');
        writeln('Para volver al menu principal ingrese "salir"');
        readln(arcNomb);
    end;

    procedure mensajeSubMenu2(var num:integer);
    begin
        writeln('');
        writeln('Presione "1" si desea agregar una novela');
        writeln('Presione "2" si desea modificar una novela');
        writeln('Presione "3" para salir del archivo');
        readln(num);
    end;

var
    arc:archivo;
    num:integer;
    arcNomb:string;
begin
    mensajeSubMenu1(arcNomb);
    while(arcNomb<>'salir')do begin
        assign(arc,arcNomb);
        mensajeSubMenu2(num);
        while(num<>3)do begin
            reset(arc);
            case(num)of
               1:agregarNovela(arc);
               2:modificarNovela(arc);
            else begin
                writeln('');
                writeln('Opcion no valida, intente de nuevo');
            end;
            end;
            close(arc);
            mensajeSubMenu2(num);
        end;
        mensajeSubMenu1(arcNomb);
    end;
end;






procedure menu();

    procedure mensajeMenuPrincipal(var num:integer);
    begin
        writeln('');
        writeln('Bienvenido al menu principal');
        writeln('Presione "1" si desea crear un archivo de texto');
        writeln('Presione "2" si desea crear un archivo de novelas');
        writeln('Presione "3" si desea abrir un archivo de novelas');
        writeln('Presione "4" para salir');
        readln(num);
    end;

var
    num:integer;
begin
    mensajeMenuPrincipal(num);
    while(num<>4)do begin
        case(num)of
            1:crearTexto;
            2:crearArchivo;
            3:subMenu;
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