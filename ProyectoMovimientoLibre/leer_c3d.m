function [marcadores,informacionCine,Fuerzas,informacionFuerzas,Antropometria,Eventos,fileName] = leer_c3d()
% LEER_C3D  Carga un archivo C3D (cinematica y fuerzas) y lee la ANTROPOMETRIA
% y los EVENTOS (Inicio/Fin) desde archivos de Excel.
%
% - Los marcadores se renombran a la convencion que usan SegmentosArticulares
%   y CentrosArticulares (r_asis, r_knee_1, r_bar_2, etc.).
% - La antropometria se guarda SOLO con los nombres del modelo (Davis); los
%   nombres crudos del Excel no se conservan.
% - Para no seleccionar los Excel cada vez, completa las rutas en CONFIGURACION.

% ====================================================================
% CONFIGURACION  <-- editar aca una sola vez
% ====================================================================
rutaAntropometria = 'C:\Users\lauta\OneDrive\Escritorio\Biomecanica\ProyectoMovimientoLibre\c3d\Medidas_Antropometricas.xlsx';   % p.ej. 'C:\Datos\Softbol\Medidas_Antropometricas.xlsx'
rutaEventos       = 'C:\Users\lauta\OneDrive\Escritorio\Biomecanica\ProyectoMovimientoLibre\c3d\Eventos.xlsx';   % p.ej. 'C:\Datos\Softbol\Eventos.xlsx'

% ====================================================================
% 1) Cargar el archivo C3D
% ====================================================================
[fileName, filePath] = uigetfile('*.c3d','Seleccione el archivo C3D');
if isequal(fileName,0)
    error('No se selecciono ningun archivo C3D.');
end
[h,~,~] = btkReadAcquisition([filePath fileName]);
btkSetPointsUnit(h, 'marker', 'm')

[premarcadores, informacionCine]   = btkGetMarkers(h);
[preFuerzas, informacionFuerzas]   = btkGetForcePlatforms(h);

Fuerzas.Plataforma1.Valores=0;
Fuerzas.Plataforma1.Unidades=0;
Fuerzas.Plataforma1.Frecuencia=0;
Fuerzas.Plataforma2.Valores=0;
Fuerzas.Plataforma2.Unidades=0;
Fuerzas.Plataforma2.Frecuencia=0;

[ANALOGS, ANALOGSINFO] = btkGetAnalogs(h);

% ---- Renombrar marcadores ----
% Los marcadores vienen con prefijo "x_" (p.ej. x_R_ASIS). La regla base pasa
% a minusculas y saca ese prefijo. 'overrides' renombra cada marcador real al
% nombre EXACTO que usan las funciones del modelo  { real , final }:
overrides = { ...
    'r_mal_l',    'r_mall'   ; ...   % maleolo lateral
    'l_mal_l',    'l_mall'   ; ...
    'r_meta',     'r_met'    ; ...   % metatarsiano
    'l_meta',     'l_met'    ; ...
    'r_knee_el',  'r_knee_1' ; ...   % rodilla (epicondilo lateral)
    'l_knee_el',  'l_knee_1' ; ...
    'r_tib_diaf', 'r_bar_2'  ; ...   % wand de la PIERNA (tibia) -> bar_2
    'l_tib_diaf', 'l_bar_2'  ; ...
    'r_fem_diaf', 'r_bar_1'  ; ...   % wand del MUSLO (femur) -> bar_1
    'l_fem_diaf', 'l_bar_1'  };

nombresDeseados = {'r_asis','l_asis','sacrum', ...
    'r_heel','l_heel','r_met','l_met','r_mall','l_mall', ...
    'r_knee_1','l_knee_1','r_bar_2','l_bar_2','r_bar_1','l_bar_1'};

nombresMarc = fieldnames(premarcadores);
marcadoresRenombrados = struct();
for k = 1:numel(nombresMarc)
    viejo = nombresMarc{k};
    nuevo = lower(viejo);
    nuevo = regexprep(nuevo, '^markerset_', '');
    nuevo = regexprep(nuevo, '^x_', '');
    nuevo = regexprep(nuevo, '^_+', '');
    idx = find(strcmp(nuevo, overrides(:,1)), 1);
    if ~isempty(idx)
        nuevo = overrides{idx,2};
    end
    nuevo = matlab.lang.makeValidName(nuevo);
    marcadoresRenombrados.(nuevo) = premarcadores.(viejo);
end
premarcadores = marcadoresRenombrados;

producidos = fieldnames(premarcadores);
faltan = setdiff(nombresDeseados, producidos);
sobran = setdiff(producidos, nombresDeseados);
if ~isempty(faltan)
    warning('Marcadores esperados que NO aparecieron: %s', strjoin(faltan, ', '));
end
if ~isempty(sobran)
    warning('Marcadores con nombre inesperado (revisar overrides): %s', strjoin(sobran, ', '));
end

marcadores.Valores    = premarcadores;
marcadores.Unidades   = informacionCine.units.ALLMARKERS;
marcadores.Frecuencia = informacionCine.frequency;

% ====================================================================
% 2) ANTROPOMETRIA desde Excel  (se guarda SOLO con los nombres del modelo)
% ====================================================================
archivoAntro = resolverArchivo(rutaAntropometria, ...
                'Seleccione el archivo de medidas antropometricas');
% readcell requiere MATLAB R2019a+. Version anterior:  [~,~,celdas]=xlsread(archivoAntro);
celdas = readcell(archivoAntro);

% --- 2a) lectura cruda a una estructura TEMPORAL (no se conserva) ---
crudo = struct();
for i = 2:size(celdas,1)            % fila 1 = encabezado (R/L | Nombre | cm)
    lado   = celdas{i,1};
    nombre = celdas{i,2};
    valor  = celdas{i,3};

    if esVacio(nombre), continue, end
    nombreTxt = strtrim(char(string(nombre)));

    if esVacio(valor) || ~isnumeric(valor)
        valorNum = NaN;
    else
        valorNum = valor;
    end

    clave = sanitizarNombre(nombreTxt);
    if ~esVacio(lado)
        ladoTxt = upper(strtrim(char(string(lado))));
        if strcmp(ladoTxt,'R') || strcmp(ladoTxt,'L')
            clave = [clave '_' ladoTxt];
        end
    end
    crudo.(clave).Valor  = valorNum;
    crudo.(clave).Unidad = 'cm';
end

% --- 2b) antropometria final con los nombres del modelo (Davis) ---
alturaCm = campoAntro(crudo,'ALTURA');   % se usa para las estimaciones de referencia

Antropometria = struct();

% Datos generales (se conservan: hacen falta mas adelante p/ masas de segmento)
Antropometria.ALTURA = nuevoCampo(alturaCm, 'cm');
Antropometria.PESO   = nuevoCampo(campoAntro(crudo,'PESO'), 'Kg');

% Longitud de pierna = (trocanter->tibial) + (tibial->maleolo)   [confirmado]
Antropometria.LONGITUD_PIERNA_DERECHA   = nuevoCampo( ...
    campoAntro(crudo,'TROCANTER_A_TIBIAL_R') + campoAntro(crudo,'TIBIAL_L_MALEOLO_L_R'), 'cm');
Antropometria.LONGITUD_PIERNA_IZQUIERDA = nuevoCampo( ...
    campoAntro(crudo,'TROCANTER_A_TIBIAL_L') + campoAntro(crudo,'TIBIAL_L_MALEOLO_L_L'), 'cm');

% Ancho de pelvis = bileocrestal   [confirmado]
Antropometria.LONGITUD_ASIS = nuevoCampo(campoAntro(crudo,'BILEOCRESTAL'), 'cm');

% Diametro de rodilla = biepicondilo de femur
Antropometria.DIAMETRO_RODILLA_DERECHA   = nuevoCampo(campoAntro(crudo,'BIEPICONDELO_FEMUR_R','BIEPIC_NDELO_FEMUR_R'), 'cm');
Antropometria.DIAMETRO_RODILLA_IZQUIERDA = nuevoCampo(campoAntro(crudo,'BIEPICONDELO_FEMUR_L','BIEPIC_NDELO_FEMUR_L'), 'cm');

% Longitud de pie
Antropometria.LONGITUD_PIE_DERECHO   = nuevoCampo(campoAntro(crudo,'LONGITUD_PIE_R'), 'cm');
Antropometria.LONGITUD_PIE_IZQUIERDO = nuevoCampo(campoAntro(crudo,'LONGITUD_PIE_L'), 'cm');

% Ancho de maleolos = diametro de maleolo
Antropometria.ANCHO_MALEOLOS_DERECHO   = nuevoCampo(campoAntro(crudo,'DIAMETRO_MALEOLO_R'), 'cm');
Antropometria.ANCHO_MALEOLOS_IZQUIERDO = nuevoCampo(campoAntro(crudo,'DIAMETRO_MALEOLO_L'), 'cm');

% Altura de maleolos (piso->maleolo). Si no se midio -> 0.039*ALTURA
% (Drillis & Contini, 1966: ankle height = 0.039 H)
Antropometria.ALTURA_MALEOLOS_DERECHO   = nuevoCampo(valorOEstimado(crudo,'ALTURA_MALEOLO_R', 0.039*alturaCm, 'ALTURA_MALEOLOS_DERECHO'), 'cm');
Antropometria.ALTURA_MALEOLOS_IZQUIERDO = nuevoCampo(valorOEstimado(crudo,'ALTURA_MALEOLO_L', 0.039*alturaCm, 'ALTURA_MALEOLOS_IZQUIERDO'), 'cm');

% Ancho de pie. Si no se midio -> 0.055*ALTURA  (Drillis & Contini, 1966)
Antropometria.ANCHO_PIE_DERECHO   = nuevoCampo(valorOEstimado(crudo,'ANCHO_PIE_R', 0.055*alturaCm, 'ANCHO_PIE_DERECHO'), 'cm');
Antropometria.ANCHO_PIE_IZQUIERDO = nuevoCampo(valorOEstimado(crudo,'ANCHO_PIE_L', 0.055*alturaCm, 'ANCHO_PIE_IZQUIERDO'), 'cm');

% Profundidad de pelvis: el Excel no la trae y no hay estimacion confiable por
% altura -> queda en NaN (hay que medirla o cargar un valor).
Antropometria.PROFUNDIDAD_PELVIS = nuevoCampo(campoAntro(crudo,'PROFUNDIDAD_PELVIS'), 'cm');
if isnan(Antropometria.PROFUNDIDAD_PELVIS.Valor)
    warning(['Falta PROFUNDIDAD_PELVIS (no esta en el Excel y no se estima por ' ...
             'altura). Los centros de cadera quedaran en NaN hasta cargarla.']);
end

% ====================================================================
% 3) EVENTOS desde Excel (Inicio / Fin del trial actual)
% ====================================================================
archivoEventos = resolverArchivo(rutaEventos, ...
                'Seleccione el archivo de eventos (Inicio/Fin)');
celdasEv = readcell(archivoEventos);

[~, trialActual] = fileparts(fileName);   % nombre del trial (ej. "pitching_002")

Eventos = struct('Trial',trialActual,'Inicio',NaN,'Fin',NaN,'PiernaDominante','');

encabezado = upper(char(string(celdasEv{1,1})));
if contains(encabezado,'DER')
    Eventos.PiernaDominante = 'DER';
elseif contains(encabezado,'IZQ')
    Eventos.PiernaDominante = 'IZQ';
end

encontrado = false;
for i = 1:size(celdasEv,1)
    nom = celdasEv{i,1};
    if esVacio(nom), continue, end
    if strcmpi(strtrim(char(string(nom))), trialActual)
        Eventos.Inicio = leerNumero(celdasEv{i,2});
        Eventos.Fin    = leerNumero(celdasEv{i,3});
        encontrado = true;
        break
    end
end
if ~encontrado
    warning(['No se encontro el trial "%s" en el archivo de eventos. ' ...
             'Inicio/Fin quedan en NaN.'], trialActual);
end
end


% ========================== FUNCIONES AUXILIARES =====================

function s = nuevoCampo(valor, unidad)
% Crea un campo de antropometria con la forma .Valor / .Unidad
    s.Valor  = valor;
    s.Unidad = unidad;
end

function val = campoAntro(A, varargin)
% Devuelve A.<campo>.Valor probando varios nombres posibles (por diferencias
% de acentos al sanitizar). Si no encuentra ninguno, NaN.
    val = NaN;
    for k = 1:numel(varargin)
        if isfield(A, varargin{k})
            val = A.(varargin{k}).Valor;
            return
        end
    end
end

function v = valorOEstimado(A, campo, estimado, etiqueta)
% Devuelve la medida real si esta en el Excel; si no, usa el valor estimado
% (referencia Drillis & Contini) y avisa.
    if isfield(A, campo) && ~isnan(A.(campo).Valor)
        v = A.(campo).Valor;
    else
        v = estimado;
        warning('%s no medido: se usa valor de referencia (Drillis & Contini, 1966) = %.1f cm.', ...
                etiqueta, estimado);
    end
end

function ruta = resolverArchivo(rutaConfig, titulo)
% Usa la ruta configurada si existe; si no, abre una ventana para elegir.
    if ~isempty(rutaConfig) && isfile(rutaConfig)
        ruta = rutaConfig;
    else
        if ~isempty(rutaConfig)
            warning('No se encontro el archivo configurado:\n  %s\nSe pedira por ventana.', rutaConfig);
        end
        [arch, carpeta] = uigetfile({'*.xlsx;*.xls','Planillas de Excel (*.xlsx, *.xls)'}, titulo);
        if isequal(arch,0)
            error('No se selecciono ningun archivo (%s).', titulo);
        end
        ruta = fullfile(carpeta, arch);
    end
end

function tf = esVacio(x)
    tf = false;
    if isa(x,'missing') || (isnumeric(x) && isempty(x))
        tf = true; return
    end
    if isnumeric(x) && all(isnan(x(:)))
        tf = true; return
    end
    if (ischar(x) || isstring(x)) && isempty(strtrim(char(string(x))))
        tf = true;
    end
end

function n = leerNumero(x)
% Convierte una celda a numero (acepta numero directo o texto numerico).
    if isnumeric(x)
        n = double(x);
    else
        n = str2double(string(x));
    end
end

function s = sanitizarNombre(txt)
    s = upper(strtrim(txt));
    s = strrep(s,'[KG]','');
    s = regexprep(s,'[\xC1\xC0\xC4\xC2]','A');
    s = regexprep(s,'[\xC9\xC8\xCB\xCA]','E');
    s = regexprep(s,'[\xCD\xCC\xCF\xCE]','I');
    s = regexprep(s,'[\xD3\xD2\xD6\xD4]','O');
    s = regexprep(s,'[\xDA\xD9\xDC\xDB]','U');
    s = regexprep(s,'\xD1','N');
    s = regexprep(s,'[^A-Z0-9]+','_');
    s = regexprep(s,'^_+|_+$','');
    s = matlab.lang.makeValidName(s);
end