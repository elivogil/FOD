program P2Ej02;
const 
    corte=-1;
type
    alumno=record
        cod:integer;
        ape:string;
        nom:string;
        cur:integer;
        fin:integer;
    end;
    alumnoDet=record
        cod:integer;
        cur:boolean;
        fin:boolean;
    end;
    maestro=file of alumno;
    detalle=file of alumnoDet;


procedure actualizar(var ma:maestro);

    procedure leer(var det:detalle;var alDet:alumnoDet);
    begin
        if(not eof(det))then
            read(det,alDet)
        else
            alDet.cod:=corte;
    end;

var
    det:detalle;
    alDet:alumnoDet;
    al:alumno;
begin
    assign(ma,'alumnosMaestro');
    assign(det,'alumnosDetalle');
    reset(ma);
    reset(det);
    leer(det,alDet);
    while(alDet.cod<>corte)do begin
        read(ma,al);
        while(al.cod<>alDet.cod)do
            read(ma,al);
        while(alDet.cod=al.cod)do begin
            if(alDet.cur)then
                al.cur:=al.cur+1;
            if(alDet.fin)then   
                al.fin:=al.fin+1;
            leer(det,alDet);
        end;
        seek(ma,FilePos(ma)-1);
        write(ma,al);
    end;
    close(ma);
    close(det);
end;


procedure listar(var ma:maestro);
var
    texto:text;
    al:alumno;
begin
    assign(texto,'alumnos.txt');
    reset(ma);
    rewrite(texto);
    while(not eof(ma))do begin
        read(ma,al);
        if(al.cur=al.fin+4)then
            with al do begin
                writeln(texto,cod,' ',cur,' ',fin,' ',ape);
                writeln(texto,nom);
            end;
    end;
    close(ma);
    close(texto);
end;


var
    ma:maestro;
begin
    actualizar(ma);
    listar(ma);
end.