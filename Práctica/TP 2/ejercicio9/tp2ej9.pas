{Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..
Total General de Votos: ___
NOTA: La información se encuentra ordenada por código de provincia y código de
localidad.

}

program tp2ej9;
const
    valor_alto= 9999;
type
    votos=record
        prov:integer;
        loc:integer;
        mesa:integer;
        cant:integer;
    end;
    archivo=file of votos;
        
procedure leer (var a:archivo; var v:votos);
begin
    if (not eof (a))then
        read(a,v)
    else
        v.prov:= valor_alto;
end;
Procedure crearBin(Var a:archivo);
Var 
  txt: Text;
  v: votos;
Begin
  assign(a,'votos');
  assign(txt,'votos.txt');
  reset(txt);
  rewrite(a);
  While Not eof(txt) Do
    Begin
      With v Do
        readln(txt,prov,loc,mesa,cant);
      write(a,v);
    End;
  close(txt);
  close(a);
End;


procedure procesarVotos(var a:archivo);
var 
    v,actual:votos;
    votLoc,votProv,votTot:integer;
begin
    assign(a,'votos');
    reset(a);
    leer(a,v);
    votTot:=0;
    while (v.prov<>valor_alto) do begin
        actual.prov:=v.prov;
        votProv:=0;
        WriteLn('Provincia: ', actual.prov);
        while (actual.prov = v.prov)do begin
          actual.loc:= v.loc;
          votLoc:=0;
          while(actual.prov = v.prov) and (actual.loc= v.loc)do begin
            votLoc:= votLoc+v.cant;
            leer(a,v);
          end;
          WriteLn('Localidad: ',actual.loc,'; votos: ',votLoc);
          votProv:=votProv+votLoc;
        end;
        writeln('Total de votos de la provincia: ',votProv);
        votTot:=votTot+votProv;
    end;
    writeln('Total General Votos: ',votTot);
    close(a);
end;

var
    a:archivo;
begin
    crearBin(a);
    procesarVotos(a);
end.