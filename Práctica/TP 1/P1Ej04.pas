program P1Ej04;
type
    empleado = record
        num:integer;
        apellido:string;
        nombre:string;
        edad:integer;
        dni:integer;
    end;
    archivo = file of empleado;


procedure crearArchivo();

    procedure ingresarDatos(var arc:archivo);
    var
        e:empleado;
    begin
        writeln('');
        writeln('Para terminar de cargar el archivo, ingrese el apellido "fin"');
        writeln('Ingresar apellido:');
        readln(e.apellido);
        while(e.apellido<>'fin')do begin
            writeln('Ingresar nombre:');
            readln(e.nombre);
            writeln('Ingresar numero de empleado:');
            readln(e.num);            
            writeln('Ingresar edad:');
            readln(e.edad);            
            writeln('Ingresar DNI:');
            readln(e.dni);
            write(arc,e);
            writeln('');            
            writeln('Para terminar de cargar el archivo, ingrese el apellido "fin"');
            writeln('Ingresar apellido:');
            readln(e.apellido);
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


procedure imprimirEmpleado(e:empleado);
begin
    writeln('');
    writeln('Numero de empleado: ',e.num,'; apellido: ',e.apellido,'; nombre: ',e.nombre,'; edad: ',e.edad,'; DNI: ',e.dni);
end;


procedure buscarEmpleado(var arc:archivo);

    procedure buscarXNombre(var arc:archivo);
    var
        nombre:string;
        e:empleado;
        ok:boolean;
    begin
        ok:=false;
        writeln('');
        writeln('Ingresar nombre');
        readln(nombre);
        while (not eof(arc))and(not ok)do begin
            read(arc,e);
            if(e.nombre=nombre)then begin
                imprimirEmpleado(e);
                ok:=true;
            end;
        end;
        if not ok then begin
            writeln('');
            writeln('El empleado no esta en el archivo');
        end;
    end;

    procedure buscarXApellido(var arc:archivo);
    var
        apellido:string;
        e:empleado;
        ok:boolean;
    begin
        ok:=false;
        writeln('');
        writeln('Ingresar apellido');
        readln(apellido);
        while (not eof(arc))and(not ok)do begin
            read(arc,e);
            if(e.apellido=apellido)then begin
                imprimirEmpleado(e);
                ok:=true;
            end;
        end;
        if not ok then begin
            writeln('');
            writeln('El empleado no esta en el archivo');
        end;
    end;

var
    num:integer;
begin
    writeln('');
    writeln('Ingrese "1" si desea buscar por nombre'); 
    writeln('Ingrese "2" si desea buscar por apellido');
    readln(num);
    case(num)of
        1:buscarXNombre(arc);
        2:buscarXApellido(arc);
    else
        writeln('Opcion no valida, intente de nuevo');
    end;
end;
    

procedure mostrarEmpleados(var arc:archivo);
var
    e:empleado;
begin
    while not eof(arc)do begin
        read(arc,e);
        imprimirEmpleado(e);
    end;
end;


procedure jubilados(var arc:archivo);
var
    e:empleado;
begin
    while not eof(arc)do begin
        read(arc,e);
        if(e.edad > 70)then
            imprimirEmpleado(e);
    end;
end;


procedure agregarEmpleados(var arc:archivo);

    procedure mensajeAgregarEmpleados(var e:empleado);
    begin
        writeln('');
        writeln('Ingresar numero del empleado que desea agregar');
        writeln('Para dejar de cargar empleados, ingresar "-1"');
        readln(e.num);
    end;
    
    procedure cargarEmpleado(var arc:archivo;e:empleado);
    begin
        writeln('Ingresar apellido:');
        readln(e.apellido);
        writeln('Ingresar nombre:');
        readln(e.nombre);
        writeln('Ingresar edad:');
        readln(e.edad);            
        writeln('Ingresar DNI:');
        readln(e.dni);
        write(arc,e);
    end;

var
    e,aux:empleado;
    ok:boolean;
begin
    ok:=true;
    mensajeAgregarEmpleados(e);
    while(e.num<>-1)do begin
        while (not eof(arc))and(ok)do begin
            read(arc,aux);
            if(e.num=aux.num)then
                ok:=false;
        end;
        if(ok)then
            cargarEmpleado(arc,e)
        else begin
            writeln('');
            writeln('El empleado ya se encuentra registrado');
        end;
        mensajeAgregarEmpleados(e);
        if(e.num<>-1)then begin
            reset(arc);
            ok:=true;
        end;
    end;
end;


procedure modificarEdad(var arc:archivo);

    procedure mensajeModificarEdad(var num:integer);
    begin
        writeln('');
        writeln('Ingresar numero del empleado que desea modificar la edad');
        writeln('Para dejar de modificar edades, ingresar "-1"');
        readln(num);
    end;

    procedure edadNueva(var arc:archivo;e:empleado);
    var
        edad:integer;
    begin
        writeln('');
        writeln('Ingresar la nueva edad:');
        readln(edad);
        e.edad:=edad;
        seek(arc,filepos(arc)-1);
        write(arc,e);
    end;   

var 
    e:empleado;
    num:integer;
    ok:boolean;
begin
    ok:=false;
    mensajeModificarEdad(num);
    while(num<>-1)do begin
        while (not eof(arc))and(not ok)do begin
            read(arc,e);
            if(num=e.num)then
                ok:=true;
        end;
        if(ok)then
            edadNueva(arc,e)
        else begin
            writeln('');
            writeln('No existe el empleado en el archivo');
        end;
        mensajeModificarEdad(num);
        if(num<>-1)then begin
            reset(arc);
            ok:=false;
        end;
    end;
end;
    
        
procedure exportarTodo(var arc:archivo);
var
    texto:text;
    e:empleado;
begin
    assign(texto,'todos_empleados.txt');
    rewrite(texto);
    while(not eof(arc))do begin
        read(arc,e);
        with e do begin
            writeln(texto,num,' ',edad,' ',dni,' ',apellido);
            writeln(texto,nombre)
        end;
    end;
    close(texto);
    writeln('');
    writeln('Archivo exportado con exito');
end;


procedure exportarDNI(var arc:archivo);
var
    texto:text;
    e:empleado;
begin
    assign(texto,'faltaDNIEmpleado.txt');
    rewrite(texto);
    while(not eof(arc))do begin
        read(arc,e);
        if(e.dni=0)then
            with e do begin
                writeln(texto,num,' ',edad,' ',dni,' ',apellido);
                writeln(texto,nombre)
            end;
    end;
    close(texto);
    writeln('');
    writeln('Archivo exportado con exito');
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
        writeln('Presione "1" si desea ver los datos de un empleado');
        writeln('Presione "2" si desea ver los datos de todos los empleados');
        writeln('Presione "3" si desea ver los datos de los empleados proximos a jubilarse');
        writeln('Presione "4" si desea agregar mas empleados');
        writeln('Presione "5" si desea modificar la edad de los empleados');
        writeln('Presione "6" si desea exportar el contenido a un archivo de texto');
        writeln('Presione "7" si desea exportar a los empleados que no tengan cargado el DNI a un archivo de texto');
        writeln('Presione "8" para salir del archivo');
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
        while(num<>8)do begin
            reset(arc);
            case(num)of
               1:buscarEmpleado(arc);
               2:mostrarEmpleados(arc);
               3:jubilados(arc);
               4:agregarEmpleados(arc);
               5:modificarEdad(arc);
               6:exportarTodo(arc);
               7:exportarDNI(arc);
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