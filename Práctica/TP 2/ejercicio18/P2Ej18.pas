program P2Ej18;
const 
    valor_alto=9999;
type
    hospital=record
        codLoc:integer;
        nombreLoc:string;
        codMuni:integer;
        nombreMuni:string;
        codHosp:integer;
        nombreHosp:string;
        fecha:integer;
        cant:integer;
    end;

    archivo=file of hospital;


procedure procesarArchivo(var a:archivo);

    procedure leer(var a:archivo;var h:hospital);
    begin
        if(not eof(a))then
            read(a,h)
        else
            h.codLoc:=valor_alto;
    end;

var
    h,actual:hospital;
    casosMuni,casosLoc,casosProv:integer;
    txt:text;
begin
    assign(a,'maestro.bin');
    reset(a);
    assign(txt,'reporte.txt');
    rewrite(txt);
    leer(a,h);
    casosProv:=0;
    while(h.codLoc<>valor_alto)do begin
        actual.codLoc:=h.codLoc;
        actual.nombreLoc:=h.nombreLoc;
        writeln('Localidad ',h.nombreLoc,':');
        casosLoc:=0;
        while(h.codLoc=actual.codLoc)do begin
            actual.codMuni:=h.codMuni;
            actual.nombreMuni:=h.nombreMuni;
            writeln('   Municipio ',h.nombreMuni,':');
            casosMuni:=0;
            while(h.codLoc=actual.codLoc)and(h.codMuni=actual.codMuni)do begin
                writeln('       Hospital ',h.nombreHosp,', cantidad de casos: ',h.cant);
                casosMuni:=casosMuni+h.cant;
                leer(a,h);
            end;
            writeln('   Cantidad de casos del municipio ',actual.nombreMuni,': ',casosMuni);
            casosLoc:=casosLoc+casosMuni;
            if(casosMuni>1500)then begin
                writeln(txt,casosMuni,' ',actual.nombreMuni);
                writeln(txt,actual.nombreLoc);
            end;
        end;
        writeln('Cantidad de casos de la localidad ',actual.nombreLoc,': ',casosLoc);
        casosProv:=casosProv+casosLoc;
    end;
    writeln('');
    writeln('Cantidad de casos totales en la provincia: ',casosProv);
    close(a);
    close(txt);        
end;


var 
    a:archivo;
begin
    procesarArchivo(a);
end.
