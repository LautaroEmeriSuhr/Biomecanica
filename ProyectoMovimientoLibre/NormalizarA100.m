function [Mat, Etiquetas] = NormalizarA100(nodo, ventana)
% NormalizarA100  Recorre recursivamente una estructura de series temporales,
% recorta cada serie a 'ventana' (el gesto) y la interpola a 100 muestras.
%
% Sirve para angulos (Datos.Pasada.AngulosArticulares) y para velocidad
% angular (Datos.Pasada.<campoVel>), sin importar los nombres de los campos.
%
%   Mat       : 100 x M
%   Etiquetas : 1 x M  (ruta de cada columna, ej. 'Alpha_Cadera_Derecha'
%                        o 'Pelvis_Derecho_X' si la hoja trae 3 componentes)
%
% Reglas para las hojas numericas:
%   - vector (1xN o Nx1)   -> 1 columna
%   - 3 componentes (3xN o Nx3) -> 3 columnas, con sufijo _X/_Y/_Z

[Mat, Etiquetas] = recorrer(nodo, '', ventana);
end


function [Mat, Et] = recorrer(nodo, prefijo, ventana)
Mat = []; Et = {};
campos = fieldnames(nodo);
for i = 1:numel(campos)
    v = nodo.(campos{i});
    if isempty(prefijo), ruta = campos{i}; else, ruta = [prefijo '_' campos{i}]; end

    if isstruct(v)
        [m, e] = recorrer(v, ruta, ventana);
        Mat = [Mat m]; Et = [Et e];

    elseif isnumeric(v) && ~isempty(v)
        cols = aColumnas(v, ventana);            % 100 x c
        if size(cols,2) == 1
            Mat = [Mat cols]; Et = [Et {ruta}];
        else
            comp = {'X','Y','Z'};
            for c = 1:size(cols,2)
                Mat = [Mat cols(:,c)];
                Et  = [Et {[ruta '_' comp{min(c,3)}]}];
            end
        end
    end
end
end


function cols = aColumnas(v, ventana)
% Recorta a 'ventana' e interpola a 100. Acepta vector o 3 componentes.
if isvector(v)
    s = v(:);
    c1 = InterpolaA100Muestras(s(ventana));
    cols = c1(:);
else
    if size(v,1) < size(v,2), v = v.'; end       % tiempo en filas (N x c)
    lista = {};
    for c = 1:size(v,2)
        s = v(:,c);
        cc = InterpolaA100Muestras(s(ventana));
        lista{end+1} = cc(:); %#ok<AGROW>
    end
    cols = cell2mat(lista);
end
end