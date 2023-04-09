program P1Ej02;
type
    archivo = file of integer;


procedure recorrerArchivo(var a:archivo);
var
    num,cant,total:integer;
begin
    cant:=0;
    total:=0;
    reset(a);
    writeln('Elementos del archivo:');
    while not eof(a) do begin
        read(a,num);
        if(num<1500)then
            cant:=cant + 1;
        total:=total + num;
        writeln(num);
    end;
    writeln('Cantidad de numeros menores a 1500: ',cant);
    writeln('Promedio de numeros ingresados: ',total/FileSize(a):0:2);
    close(a);
end;


var 
    a:archivo;
    nombre:string;
begin
    writeln('Ingresar nombre del archivo:');
    readln(nombre);
    assign(a,nombre);
    recorrerArchivo(a);
end.