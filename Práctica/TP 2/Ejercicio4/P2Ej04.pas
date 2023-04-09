program P2Ej04;
const 
    dimF=5;
    corte=9999;
type
    sesion=record
        cod:integer;
        fecha:longint;
        tiempo:integer;
    end;
    archivo = file of sesion;
    vector_detalle=array[1..dimF]of archivo;
    vector_sesion=array[1..dimF]of sesion;


procedure crearMaestro(var m:archivo);

    procedure leer(var d:archivo;var s:sesion);
    begin
        if(not eof(d))then
            read(d,s)
        else
            s.cod:=corte;
    end;

    procedure cargarDetalles(var vD:vector_detalle;var vS:vector_sesion);
    var
        i:integer;
        ind:string[3];
    begin
        for i:=1 to dimF do begin
            str(i,ind);
            assign(vD[i],('detalle('+ind+')'));
            reset(vD[i]);
            leer(vD[i],vS[i]);
        end;
    end;

    procedure minimo(var vD:vector_detalle;var vS:vector_sesion;var s:sesion);
    var
        posMin,i:integer;
    begin
        s.cod:=corte;
        for i:=1 to dimF do 
            if(vS[i].cod<s.cod)then begin
                s:=vS[i];
                posMin:=i;
            end;
        if(s.cod<>corte)then
            leer(vD[posMin],vS[posMin]);
    end;

var
    vD:vector_detalle;
    vS:vector_sesion;
    sesM,sesD:sesion;
    i:integer;
begin
    assign(m,'maestro');
    rewrite(m);
    cargarDetalles(vD,vS);
    minimo(vD,vS,sesD);
    while(sesD.cod<>corte)do begin
        sesM.cod:=sesD.cod;
        sesM.fecha:=sesD.fecha;
        sesM.tiempo:=0;
        while(sesD.cod=sesM.cod)and(sesD.fecha=sesM.fecha)do begin
            sesM.tiempo:=sesM.tiempo + sesD.tiempo;
            minimo(vD,vS,sesD);
        end;
        write(m,sesM);
    end;
    for i:=1 to dimF do
        close(vD[i]);
    close(m);
end;


procedure exportar(var m:archivo);
var
    texto:text;
    s:sesion;
begin   
    assign(texto,'maestro.txt');
    rewrite(texto);
    reset(m);
    while(not eof(m))do begin
        read(m,s);
        with s do
            writeln(texto,cod,' ',fecha,' ',tiempo);
    end;
    close(m);
    close(texto);
end;


var
    m:archivo;
begin
    crearMaestro(m);
    exportar(m);
    writeln('Maestro creado con exito');
end.