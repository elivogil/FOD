program P3Ej03;
const 
    corte='zzz';
type
    novela=record
        cod:integer;
        genero:string;
        nombre:string;
        duracion:integer;
        director:string;
        precio:real;
    end;

    archivo=file of novela;


procedure crearArchivo();

    procedure ingresarDatos(var arc:archivo);
    var
        n:novela;
    begin
        n.cod:=0;
        write(arc,n);
        writeln('');
        writeln('Para terminar de cargar el archivo, ingrese un codigo menor a 1');
        writeln('Ingresar codigo:');
        readln(n.cod);
        while(n.cod>0)do begin
            writeln('Ingresar genero:');
            readln(n.genero);
            writeln('Ingresar nombre:');
            readln(n.nombre);
            n.duracion:=random(120)+1;            
            writeln('Ingresar director:');
            readln(n.director);            
            n.precio:=random(1000)+1;
            write(arc,n);
            writeln('');            
            writeln('Para terminar de cargar el archivo, ingrese un codigo menor a 1');
            writeln('Ingresar codigo:');
            readln(n.cod);
        end;
    end;            

var
    arc:archivo;
    arcNomb:string;
begin
    writeln('');
    writeln('Ingresar nombre del archivo:');
    readln(arcNomb);
    assign(arc,arcNomb);
    rewrite(arc);
    ingresarDatos(arc);
    close(arc);
end;


procedure altaNovela(var arc:archivo);

    procedure leerDatos(var n:novela);
    begin
        writeln('');
        writeln('Ingresar codigo:');
        readln(n.cod);
        writeln('Ingresar genero:');
        readln(n.genero);
        writeln('Ingresar nombre:');
        readln(n.nombre);
        n.duracion:=random(120)+1;            
        writeln('Ingresar director:');
        readln(n.director);            
        n.precio:=random(1000)+1;
    end;

var
    n:novela;
    pos:integer;
begin
    read(arc,n);
    if(n.cod=0)then begin
        writeln('');
        writeln('El archivo esta lleno');
    end
    else begin
        pos:=n.cod*-1;
        seek(arc,pos);
        read(arc,n);
        seek(arc,0);
        write(arc,n);
        seek(arc,pos);
        leerDatos(n);
        write(arc,n);
    end;
end;


procedure leer(var arc:archivo;var n:novela);
begin
    if(not eof(arc))then
        read(arc,n)
    else
        n.nombre:=corte;
end;


procedure modificarNovela(var arc:archivo);

    procedure cambiar(var n:novela);
    begin
        writeln('');
        writeln('Ingresar nuevo genero:');
        readln(n.genero);
        writeln('');
        writeln('Ingresar nuevo nombre:');
        readln(n.nombre);
        writeln('');
        writeln('Ingresar nueva duracion:');
        readln(n.duracion);
        writeln('');
        writeln('Ingresar nuevo director:');
        readln(n.director);
        writeln('');
        writeln('Ingresar nuevo precio:');
        readln(n.genero);
    end;

var
    n:novela;
    cod:integer;
begin
    writeln('');
    writeln('Ingresar codigo de novela:');
    readln(cod);
    leer(arc,n);
    while(n.nombre<>corte)and(n.cod<>cod)do
        leer(arc,n);
    if(n.nombre=corte)then begin
        writeln(''); 
        writeln('La novela ingresada no existe en el archivo');
    end
    else begin
        cambiar(n);
        seek(arc,filepos(arc)-1);
        write(arc,n);
    end;
end;


procedure eliminarNovela(var arc:archivo);
var
    n:novela;
    cod,pos:integer;
begin
    writeln('');
    writeln('Ingresar codigo de novela a eliminar:');
    readln(cod);
    leer(arc,n);
    while(n.nombre<>corte)and(n.cod<>cod)do
        leer(arc,n);
    if(n.nombre=corte)then begin
        writeln('');
        writeln('La novela ingresada no existe en el archivo');
    end
    else begin
        pos:=filepos(arc)-1;
        seek(arc,0);
        read(arc,n);
        seek(arc,pos);
        write(arc,n);
        seek(arc,0);
        n.cod:=pos*-1;
        write(arc,n);
    end;
end;


procedure exportar(var arc:archivo);
var
    txt:text;
    n:novela;
begin
    assign(txt,'novelas.txt');
    rewrite(txt);
    seek(arc,1);
    while(not eof(arc))do begin
        read(arc,n);
        with n do begin
            writeln(txt,cod,' ',genero);
            writeln(txt,duracion,' ',nombre);
            writeln(txt,precio:0:2,' ',director);
        end;
    end;
    close(txt);
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
        writeln('Presione "1" si desea dar de alta una novela');
        writeln('Presione "2" si desea modificar los datos de una novela');
        writeln('Presione "3" si desea eliminar una novela');
        writeln('Presione "4" si desea listar en un archivo de texto todas las novelas');
        writeln('Presione "5" para salir del archivo');
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
        while(num<>5)do begin
            reset(arc);
            case(num)of
               1:altaNovela(arc);
               2:modificarNovela(arc);
               3:eliminarNovela(arc);
               4:exportar(arc);
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