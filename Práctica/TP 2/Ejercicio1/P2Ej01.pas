program P2Ej01;
const 
    corte=-1;
type
    empleado=record
        cod:integer;
        nombre:string[15];
        monto:real;
    end;
    archivo=file of empleado;


procedure compactar(var a,nue:archivo);

    procedure leer(var a:archivo;var e:empleado);
    begin
        if(not eof(a))then
            read(a,e)
        else
            e.cod:=corte;
    end;

var
    e,eAct:empleado;
    total:real;
begin
    assign(a,'empleadoViejo');
    assign(nue,'empleadoNuevo');
    reset(a);
    rewrite(nue);
    leer(a,e);
    while(e.cod<>corte)do begin
        eAct:=e;
        total:=0;
        while(e.cod=eAct.cod)do begin
            total:=total+e.monto;
            leer(a,e);
        end;
        eAct.monto:=total;
        write(nue,eAct);
    end;
    close(a);
    close(nue);
end;


var
    a,nue:archivo;
begin
    compactar(a,nue);
end.