program P1Ej06;

type
    celular=record
        codCelu:integer;
        nombre:string;
        desc:string;
        marca:string;
        precio:real;
        stockMin:integer;
        stockDisp:integer;
    end;
    archivo=file of celular;


procedure crearArchivo();

    procedure ingresarDatos(var arc:archivo);
    var
        cel:celular;
        texto:text;
    begin
        assign(texto,'celulares.txt');
        reset(texto);
        while not eof(texto)do begin
            with cel do begin
                readln(texto,codCelu,precio,marca);
                readln(texto,stockDisp,stockMin,desc);
                readln(texto,nombre);
            end;
            write(arc,cel);
        end;
        close(texto);
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


procedure cargarCelular(var cel:celular);
begin
    writeln('');
    writeln('Para dejar de cargar, ingresa "-1"');
    writeln('Ingresar codigo de celular');
    readln(cel.codCelu);
    if(cel.codCelu<>-1)then begin
        writeln('');
        writeln('Ingresar el nombre');
        readln(cel.nombre);
        writeln('');
        writeln('Ingresar la descripcion');
        readln(cel.desc);
        writeln('');
        writeln('Ingresar la marca');
        readln(cel.marca);
        writeln('');
        writeln('Ingresar el precio');
        readln(cel.precio);
        writeln('');
        writeln('Ingresar stock minimo');
        readln(cel.stockMin);
        writeln('');
        writeln('Ingresar stock disponible');
        readln(cel.stockDisp);
    end;
end;


procedure cargarArchivoTexto(var texto:text;cel:celular);
begin
    with cel do begin
        writeln(texto,codCelu,' ',precio:0:2,' ',marca);
        writeln(texto,stockDisp,' ',stockMin,' ',desc);
        writeln(texto,nombre);
    end;
end;


procedure crearTexto();
var
    cel:celular;
    texto:text;
begin
    assign(texto,'celulares.txt');
    rewrite(texto);
    cargarCelular(cel);
    while(cel.codCelu<>-1)do begin
        cargarArchivoTexto(texto,cel);
        cargarCelular(cel);
    end;
    close(texto);
end;


procedure imprimirCelular(cel:celular);
begin
    writeln('');
    writeln('Codigo de celular: ',cel.codCelu,'; precio: ',cel.precio:0:2,'; marca: ',cel.marca,'; stock disponible: ',cel.stockDisp,'; stock minimo: ',cel.stockMin,'; descripcion: ',cel.desc,'; nombre: ',cel.nombre);
end;


procedure celuStockMenor(var arc:archivo);
var
    cel:celular;
begin
    while(not eof(arc))do begin
        read(arc,cel);
        if(cel.stockDisp<cel.stockMin)then
            imprimirCelular(cel);
    end;
end;


procedure celuDescripcion(var arc:archivo);
var
    cad:string;
    cel:celular;
begin
    writeln('');
    writeln('Ingresar cadena de caracteres a buscar');
    readln(cad);
    while(not eof(arc))do begin
        read(arc,cel);
        if(pos(cad,cel.desc)>0)then 
            imprimirCelular(cel);
    end;
end;


procedure exportarTodo(var arc:archivo);
var
    cel:celular;
    texto:text;
begin
    assign(texto,'celulares.txt');
    rewrite(texto);
    while(not eof(arc))do begin
        read(arc,cel);
        cargarArchivoTexto(texto,cel);
    end;
    close(texto);
end;


procedure agregarCelulares(var arc:archivo);
var
    cel:celular;
begin
    seek(arc,fileSize(arc));
    cargarCelular(cel);
    while(cel.codCelu<>-1)do begin
        write(arc,cel);
        cargarCelular(cel);
    end;
end;


procedure modificarStock(var arc:archivo);
var 
    nombre:string;
    cel:celular;
    ok:boolean;
begin
    ok:=false;
    writeln('');
    writeln('Ingresar nombre del celular que desea modificar');
    readln(nombre);
    while(not eof(arc))and(not ok)do begin
        read(arc,cel);
        if(cel.nombre=nombre)then begin
            ok:=true;
            writeln('');
            writeln('Ingresar stock nuevo');
            readln(cel.stockDisp);
            seek(arc,filePos(arc)-1);
            write(arc,cel);
            writeln('');
            writeln('Stock modificado con exito!');
        end;
    end;
    if(not ok)then begin
        writeln('');
        writeln('El celular no se encuentra en el archivo');
    end;
end;


procedure exportarStock0(var arc:archivo);
var
    texto:text;
    cel:celular;
begin
    assign(texto,'SinStock.txt');
    rewrite(texto);
    while(not eof(arc))do begin
        read(arc,cel);
        if(cel.stockDisp=0)then
            cargarArchivoTexto(texto,cel);
    end;
    close(texto);
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
        writeln('Presione "1" si desea ver los celulares con un stock menor al stock minimo');
        writeln('Presione "2" si desea ver celulares segun su descripcion');
        writeln('Presione "3" si desea exportar el contenido a un archivo de texto');
        writeln('Presione "4" si desea agregar mas celulares al archivo');
        writeln('Presione "5" si desea modificar el stock de un celular');
        writeln('Presione "6" si desea exportar a los celulares con stock 0 a un archivo de texto');
        writeln('Presione "7" para salir del archivo');
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
        while(num<>7)do begin
            reset(arc);
            case(num)of
               1:celuStockMenor(arc);
               2:celuDescripcion(arc);
               3:exportarTodo(arc);
               4:agregarCelulares(arc);
               5:modificarStock(arc);
               6:exportarStock0(arc);
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
        writeln('Presione "1" si desea crear un archivo de celulares');
        writeln('Presione "2" si desea crear un archivo de texto');
        writeln('Presione "3" si desea abrir un archivo de celulares');
        writeln('Presione "4" para salir');
        readln(num);
    end;

var
    num:integer;
begin
    mensajeMenuPrincipal(num);
    while(num<>4)do begin
        case(num)of
            1:crearArchivo;
            2:crearTexto;
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