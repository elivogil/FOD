program P2Ej15;
const 
    df=2;
    valor_alto=9999;
type
    registro_maestro=record
        codProv:integer;
        codLoc:integer;
        nombreProv:string;
        nombreLoc:string;
        luz:integer;
        gas:integer;
        chapa:integer;
        agua:integer;
        sanitario:integer;
    end;

    registro_detalle=record
        codProv:integer;
        codLoc:integer;
        luz:integer;
        constru:integer;
        agua:integer;
        gas:integer;
        sanitario:integer;
    end;

    maestro=file of registro_maestro;
    detalle=file of registro_detalle;

    vDetalle=array[1..df]of detalle;
    vRegistro=array[1..df]of registro_detalle;


procedure actualizarMaestro(var m:maestro);

    procedure leer(var det:detalle;var dato:registro_detalle);
    begin
        if(not eof(det))then
            read(det,dato)
        else
            dato.codProv:=valor_alto;
    end;

    procedure abrirArchivos(var m:maestro;var vD:vDetalle;var vR:vRegistro);
    var
        i:integer;
        iString:string;
    begin
        assign(m,'maestro.dat');
        reset(m);
        for i:=1 to df do begin
            str(i,iString);
            assign(vD[i],'detalle'+iString+'.dat');
            reset(vD[i]);
            leer(vD[i],vR[i]);
        end;
    end;

    procedure minimo(var vD:vDetalle;var vR:vRegistro;var min:registro_detalle);
    var
        i,pos:integer;
    begin
        min.codProv:=valor_alto;
        min.codLoc:=valor_alto;
        for i:=1 to df do
            if(vR[i].codProv<min.codProv)or((vR[i].codProv=min.codProv)and(vR[i].codLoc<min.codLoc))then begin
                min:=vR[i];
                pos:=i;
            end;
        if(min.codProv<>valor_alto)then
            leer(vD[pos],vR[pos]);
    end;

    procedure cerrarArchivos(var m:maestro;var vD:vDetalle);
    var
        i:integer;
    begin
        close(m);
        for i:=1 to df do
            close(vD[i]);
    end;

var
    vD:vDetalle;
    vR:vRegistro;
    min:registro_detalle;
    aux:registro_maestro;
    sinChap:integer;
begin
    sinChap:=0;
    abrirArchivos(m,vD,vR);
    minimo(vD,vR,min);
    while(min.codProv<>valor_alto)do begin
        read(m,aux);
        while(aux.codProv<>min.codProv)or(aux.codLoc<>min.codLoc)do begin
            if(aux.chapa=0)then
                sinChap:=sinChap+1;
            read(m,aux);
        end;
        while(aux.codProv=min.codProv)and(aux.codLoc=min.codLoc)do begin
            aux.luz:=aux.luz-min.luz;
            aux.agua:=aux.agua-min.agua;
            aux.gas:=aux.gas-min.gas;
            aux.sanitario:=aux.sanitario-min.sanitario;
            aux.chapa:=aux.chapa-min.constru;
            minimo(vD,vR,min);
        end;
        if(aux.chapa=0)then
            sinChap:=sinChap+1;
        seek(m,FilePos(m)-1);
        write(m,aux);
    end;
    while(not eof(m))do begin
        read(m,aux);
        if(aux.chapa=0)then
            sinChap:=sinChap+1;
    end;
    cerrarArchivos(m,vD);
    writeln('Localidades sin vivienda de chapa: ',sinChap);
end;


var
    m:maestro;
begin
    actualizarMaestro(m);
end.