%--- Recortado hacia adentro ---------------
%--------------------------------------------------------------------------
function [Datos] = RecortaDatos(Datos,PrimerMuestra,UltimaMuestra);
subnivel=fieldnames(Datos.Pasada.Marcadores.Valores);
tamano=size(subnivel)
CantidadFilas= tamano(1)
for cont=1:CantidadFilas
    sub=char(subnivel{cont});
    
    variable= (sprintf('%s%s','Datos.Pasada.Marcadores.Valores.',sub));
    Coordenada = eval(variable);
    Datos.Pasada.Marcadores.Valores = rmfield( Datos.Pasada.Marcadores.Valores,sub);
    
    Datos.Pasada.Marcadores.Valores.(sprintf('%s',sub))=Coordenada(PrimerMuestra:UltimaMuestra,:);
end


