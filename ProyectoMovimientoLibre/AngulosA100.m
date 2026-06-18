function [Ang, Etiquetas] = AngulosA100(Datos)
% AngulosA100  Recorta los angulos articulares a la ventana del gesto
% (eventos Inicio:Fin) y los interpola a 100 muestras.
%
% Recorre DINAMICAMENTE Datos.Pasada.AngulosArticulares.<Plano>.<Articulacion>.<Lado>,
% asi funciona igual si calculas 2 o 3 planos por articulacion.
%
%   Ang       : 100 x M   (M = cantidad de angulos encontrados)
%   Etiquetas : 1 x M cell (ej. 'Alpha_Cadera_Derecha') -> orden de columnas

% --- Ventana del gesto en indices LOCALES del arreglo ---
ventana = (Datos.eventos.Inicio:Datos.eventos.Fin) - Datos.frame0 + 1;

A = Datos.Pasada.AngulosArticulares;
columnas  = {};
Etiquetas = {};

planos = fieldnames(A);
for p = 1:numel(planos)
    P = A.(planos{p});
    if ~isstruct(P), continue, end
    arts = fieldnames(P);
    for a = 1:numel(arts)
        Q = P.(arts{a});
        if ~isstruct(Q), continue, end
        lados = fieldnames(Q);
        for l = 1:numel(lados)
            serie = Q.(lados{l});
            if ~isnumeric(serie) || ~isvector(serie), continue, end
            serie = serie(:);
            col = InterpolaA100Muestras(serie(ventana));   % tu interpolador
            columnas{end+1}  = col(:); %#ok<AGROW>
            Etiquetas{end+1} = sprintf('%s_%s_%s', planos{p}, arts{a}, lados{l}); %#ok<AGROW>
        end
    end
end

if isempty(columnas)
    error('No se encontraron angulos en Datos.Pasada.AngulosArticulares.');
end
Ang = cell2mat(columnas);   % 100 x M
end