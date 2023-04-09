{5. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información. 
Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
padre.
En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
lugar.
Realizar un programa que cree el archivo maestro a partir de toda la información de los
archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
deberá, además, listar en un archivo de texto la información recolectada de cada persona.
Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.}

{SE USARAN 5 detalles  de nac y 5 de fall para crear el maestro dado que crear los bin de prueba 
no tiene sentido}

program  tp2ej5;
const
    df = 3;
    valor_alto= 9999;
type
    strini= String[30];
    dire = record
        calle: integer;
        nro: integer;
        piso: integer;
        depto: integer;
        ciudad: strini;
    end;
    reg_nac = record
        nro_partida : integer;
        nombre : strini;
        apellido: strini;
        direccion : dire;
        mat_medico_nac: integer;
        nombre_madre: strini;
        apellido_madre: strini;
        dni_madre: integer;
        nombre_padre: strini;
        apellido_padre: strini;
        dni_padre: integer;
    end;
    reg_fallecido= record
        nro_partida :Integer;
        DNI : integer;
        nombre : strini;
        apellido : strini;
        mat_medico : Integer;
        fecha_fallece : string [8];
        hora_deceso : string[5];
        lugar_deceso : strini;
    end;
    reg_maestro =record
        nro_partida :Integer;
        nombre : strini;
        apellido : strini;
        direccion : dire;        
        DNI : integer;
        mat_medico_nac : Integer;
        nombre_madre: strini;
        apellido_madre: strini;
        dni_madre: integer;
        nombre_padre: strini;
        apellido_padre: strini;
        dni_padre: integer;
        mat_medico_fal : Integer;
        fecha_fallece : string [8];
        hora_deceso : string[5];
        lugar_deceso : strini;
    end;
    det_nac= file of reg_nac;
    det_fal= file of reg_fallecido;
    mae_bin= file of reg_maestro;
    Vec_nac = array [1..df] of det_nac;
    Vec_fal = array [1..df] of det_fal;
    nacimientos=array[1..df]of reg_nac;
    fallecimientos=array[1..df]of reg_fallecido;
    

 procedure leerN(var det : det_nac; var aux: reg_nac);
  begin
      if not eof (det)then 
        read(det,aux)
      else aux.nro_partida:= valor_alto;  
  end;
  procedure leerF(var det : det_fal; var aux: reg_fallecido);
  begin
      if not eof (det)then 
        read(det,aux)
      else aux.nro_partida:= valor_alto;  
 end;


 procedure verMaestro(var mae:mae_bin);
        procedure datos(aux: reg_maestro);
        begin
          WriteLn('°°°°°-----------Datos Personales-----------°°°°°');

          WriteLn('Reg Nro',aux.nro_partida);
          Writeln(' Nombre: ',aux.nombre,' Apellido: ',aux.apellido, ' Dni: ',aux.DNI);
          WriteLn(' Direccion: ',aux.direccion.calle,' NRO: ',aux.direccion.nro);
          WriteLn(' PISO: ',aux.direccion.piso);
          WriteLn(' dTO: ',aux.direccion.depto);
          WriteLn(' Ciudad: ',aux.direccion.ciudad);
          WriteLn('-----Datos de Nacimiento------');
          WriteLn(' Matricula medico del acta de nacimiento',aux.mat_medico_nac);
          WriteLn(' Nombre Madre: ',aux.nombre_madre,' Apellido madre: ',aux.dni_madre,' DNI Madre: ',aux.dni_madre);
          WriteLn(' Nombre padre: ',aux.nombre_padre,' Apellido Padre: ',aux.apellido_padre,' DNI Padre: ',aux.dni_padre);
          if (aux.mat_medico_fal <> 0) then
          begin
            writeLn('---------Si fallecio-------- ');
            writeln(' Matricula Medico del acta de fallecimiento: ',aux.mat_medico_fal);
             writeln(' Fecha Fallecimiento: ',aux.fecha_fallece,' Hora: ',aux.hora_deceso,' donde Fallece: ',aux.lugar_deceso);
          end else WriteLn('No fallecio');
        end;
  var
    aux: reg_maestro;
  begin
    reset(mae);
    while not eof (mae)do begin
        read(mae, aux);
        datos(aux);
      end;
      close(mae);
 end;
 procedure minimoNac(var vD: Vec_nac;var vN:nacimientos; var minimo: reg_nac);
 var
  pos,i:integer;
  begin
    minimo.nro_partida := valor_alto;
    pos :=0;
    for i:=1 to df do begin
      if vN[i].nro_partida<minimo.nro_partida then
      begin
        pos:=i;
        minimo:= vN[i];
      end;
    if(minimo.nro_partida<>valor_alto)then
      leerN(vD[pos],vN[pos]);
    end;
  end;
 procedure minimoFal(var vD: Vec_fal;var vF:fallecimientos; var minimo: reg_fallecido);
 var
  pos,i:integer;
  begin
    minimo.nro_partida := valor_alto;
    pos := 0;
    for i:=1 to df do begin
      if (vF[i].nro_partida<minimo.nro_partida) then
      begin
        pos:=i;
        minimo:= vF[i];
      end;
    if(minimo.nro_partida<>valor_alto)then
      leerF(vD[pos],vF[pos]);
    end;
  end;

procedure crearMaestro(var m:mae_bin;var aNac:Vec_nac;var aFal:Vec_fal;var naci:nacimientos;var falle:fallecimientos);
  procedure cargarNyF( n: reg_nac; f:reg_fallecido; var m:reg_maestro);
  begin
    m.nro_partida:=n.nro_partida;
    m.nombre:= n.nombre;
    m.apellido:= n.apellido;
    m.direccion.calle:= n.direccion.calle;
    m.direccion.nro:= n.direccion.nro;
    m.direccion.piso:= n.direccion.piso;
    m.direccion.depto:= n.direccion.depto;
    m.direccion.ciudad:= n.direccion.ciudad;
    m.nombre_madre:= n.nombre_madre;
    m.apellido_madre:= n.apellido_madre;
    m.nombre_padre:= n.nombre_padre;
    m.apellido_padre:= n.apellido_padre;
    m.dni_madre:=n.dni_madre;
    m.dni_padre:= n.dni_padre;
    m.mat_medico_nac:= n.mat_medico_nac;
    { aca arrancan fallecimientos}
    m.DNI:= f.DNI;
    m.mat_medico_fal:= f.mat_medico;
    m.fecha_fallece:= f.fecha_fallece;
    m.hora_deceso:= f.hora_deceso;
    m.lugar_deceso:= f.lugar_deceso;
  end;
  procedure cargarN( n: reg_nac; var m:reg_maestro);
  begin
    m.nro_partida:=n.nro_partida;
    m.nombre:= n.nombre;
    m.apellido:= n.apellido;
    m.direccion.calle:= n.direccion.calle;
    m.direccion.nro:= n.direccion.nro;
    m.direccion.piso:= n.direccion.piso;
    m.direccion.depto:= n.direccion.depto;
    m.direccion.ciudad:= n.direccion.ciudad;
    m.nombre_madre:= n.nombre_madre;
    m.apellido_madre:= n.apellido_madre;
    m.nombre_padre:= n.nombre_padre;
    m.apellido_padre:= n.apellido_padre;
    m.dni_madre:=n.dni_madre;
    m.dni_padre:= n.dni_padre;
    m.mat_medico_nac:= n.mat_medico_nac;
    { nota: se pone en 0 la matricula del medico que declara el fallecimientopara usarlo como boolean cuando mostramosMaestro}
    m.mat_medico_fal:= 0;
  end;
var
  minNaci:reg_nac;
  minFal:reg_fallecido;
  regMae:reg_maestro;
  i:integer;
begin
  assign(m,'maestro');
  rewrite(m);
  minimoNac(aNac,naci,minNaci);
  minimoFal(aFal,falle,minFal);
  while(minNaci.nro_partida<>valor_alto)do begin
    if(minNaci.nro_partida=minFal.nro_partida)then begin
      cargarNyF(minNaci,minFal,regMae);
      minimoNac(aNac,naci,minNaci);
      minimoFal(aFal,falle,minFal);
    end
    else begin 
      cargarN(minNaci,regMae);
      minimoNac(aNac,naci,minNaci);
    end;
    write(m,regMae);
  end;
  close(m);
  for i:=1 to df do begin
    close(aNac[i]);
    close(aFal[i]);
  end;
end;

 procedure asignarDetalles(var aNac : Vec_nac;var aFal: Vec_fal;var naci:nacimientos;var falle:fallecimientos);
 var
  i:integer;
  nombreN,nombreF,iString:string;
  detN:det_nac;
  detF:det_fal;
 begin
  for i:=1 to df do begin
    str(i,iString);
    nombreN:= 'Nac ('+istring+')';
    nombreF:= 'Fal ('+istring+')';
    Assign(detN,nombreN);
    Assign(detF,nombreF);
    reset(detN);
    reset(detF);
    aNac[i]:=detN;
    aFal[i]:=detF;
    leerN(aNac[i],naci[i]);
    leerF(aFal[i],falle[i]);
  end;
 end;


procedure exportar(var mae:mae_bin);
var
  texto:text;
  regMae:reg_maestro;
begin
  assign(texto,'maestro.txt');
  rewrite(texto);
  reset(mae);
  while(not eof(mae))do begin
    read(mae,regMae);
    with regMae do begin
      writeln(texto,nro_partida,' ',DNI,' ',mat_medico_nac,' ',dni_madre,' ',dni_padre,' ',direccion.calle,' ',direccion.piso,' ',direccion.depto,' ',direccion.ciudad);
      writeln(texto,nombre);
      writeln(texto,apellido);
      writeln(texto,nombre_madre);
      writeln(texto,apellido_madre);
      writeln(texto,nombre_padre);
      writeln(texto,apellido_padre);
      writeln(texto,mat_medico_fal,' ',fecha_fallece);
      writeln(texto,hora_deceso);
      writeln(texto,lugar_deceso);
    end;
  end;
  close(mae);
  close(texto);
end;

var
  aNac:Vec_nac;
  aFal : Vec_fal;
  naci:nacimientos;
  falle:fallecimientos;
  mae : mae_bin;
begin
  asignarDetalles(aNac,aFal,naci,falle);
  crearMaestro(mae,aNac,aFal,naci,falle);
  verMaestro(mae);
  exportar(mae);
End.

{Archivo creado por Gonzalez Ivan y Massera Felipe}