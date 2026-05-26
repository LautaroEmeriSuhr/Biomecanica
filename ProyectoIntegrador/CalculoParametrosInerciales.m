function Datos = CalculoParametrosInerciales(Datos)
% CALCULOPARAMETROSINERCIALES  Estima los parámetros inerciales de cada
% segmento del miembro inferior usando las ecuaciones de regresión múltiple
% de Zatsiorsky-Seluyanov (1990), Tablas 3.2 a 3.6 del apunte.
%
%   Datos = CalculoParametrosInerciales(Datos)
%
% ENTRADAS (esperadas en Datos)
%   Datos.antropometria.PESO.Valor     : masa corporal [kg]
%   Datos.antropometria.ALTURA.Valor   : altura corporal [cm]
%   Datos.Pasada.CentrosArticulares.<Articulación>.<Lado>  [n x 3, en m]
%       Articulaciones esperadas: Cadera, Rodilla, Tobillo, DedoGordo
%       Lados: Derecho / Izquierdo  (Cadera.Derecho, etc.)
%
% SALIDAS (agregadas a Datos)
%   Datos.Pasada.ParametrosInerciales.<seg>.masa      [escalar, kg]
%   Datos.Pasada.ParametrosInerciales.<seg>.longitud  [escalar, m]
%   Datos.Pasada.ParametrosInerciales.<seg>.CoM       [n x 3, m  -  global]
%   Datos.Pasada.ParametrosInerciales.<seg>.I_0       [3 x 3, kg·m²  -  local]
%
% MÉTODO
%   Ecuaciones de regresión: y = B0 + B1*peso + B2*altura
%   - Masa            (Tabla 3.2): y en kg
%   - Centro de masa  (Tabla 3.3): y en cm desde el extremo proximal,
%                                  a lo largo del eje longitudinal
%   - I_xx (AP)       (Tabla 3.4): y en kg·cm²
%   - I_yy (ML)       (Tabla 3.5): y en kg·cm²
%   - I_zz (Long.)    (Tabla 3.6): y en kg·cm²
%   La pelvis se modela como "torso inferior" de Zatsiorsky.
%
% CONVENCIÓN DE EJES LOCALES (según el modelo del usuario)
%   i = antero-posterior  →  I_0(1,1) recibe I_xx de Zatsiorsky
%   j = longitudinal      →  I_0(2,2) recibe I_zz de Zatsiorsky
%   k = medial-lateral    →  I_0(3,3) recibe I_yy de Zatsiorsky
%
% NOTAS
%   - La longitud de cada segmento se calcula como la distancia entre los
%     centros articulares proximal y distal, promediada sobre todos los
%     frames (el segmento es rígido, así que en teoría es constante; el
%     promedio limpia el ruido de marcadores).
%   - Para la pelvis se usa como "longitud" la distancia entre los dos HJC
%     y el centro de masa se ubica en el punto medio entre ambos (la
%     fórmula de Zatsiorsky para torso inferior no aplica geométricamente
%     a la pelvis del modelo de Davis).
%   - Los momentos de inercia se convierten de kg·cm² a kg·m² dividiendo
%     por 10⁴.

%% Datos antropométricos del sujeto
peso   = Datos.antropometria.PESO.Valor;     % kg
altura = Datos.antropometria.ALTURA.Valor;   % cm

%% Coeficientes de Zatsiorsky-Seluyanov (1990) - Tablas 3.2 a 3.6 del apunte
% Cada vector: [B0, B1, B2] para  y = B0 + B1*peso + B2*altura

% Tabla 3.2 - Masa del segmento [kg]
coef_masa.Pie    = [-0.829,  0.0077,  0.0073];
coef_masa.Pierna = [-1.592,  0.0362,  0.0121];
coef_masa.Muslo  = [-2.649,  0.1463,  0.0137];
coef_masa.Pelvis = [-7.498,  0.0976,  0.04896];   % "torso inferior"

% Tabla 3.3 - Centro de masa, distancia desde extremo proximal [cm]
coef_CoM.Pie    = [ 3.767,   0.065,   0.033 ];
coef_CoM.Pierna = [-6.05,   -0.039,   0.142 ];
coef_CoM.Muslo  = [-2.42,    0.038,   0.135 ];
coef_CoM.Pelvis = [ 1.182,   0.0018,  0.0434];   % no se usa (ver más abajo)

% Tabla 3.4 - I alrededor del eje antero-posterior [kg·cm²]
coef_Ixx.Pie    = [-100,     0.480,   0.626 ];
coef_Ixx.Pierna = [-1105,    4.59,    6.63  ];
coef_Ixx.Muslo  = [-3557,    31.7,    18.61 ];
coef_Ixx.Pelvis = [-1568,    12,      7.741 ];

% Tabla 3.5 - I alrededor del eje medial-lateral [kg·cm²]
coef_Iyy.Pie    = [-97.09,   0.414,   0.614 ];
coef_Iyy.Pierna = [-1152,    4.594,   6.815 ];
coef_Iyy.Muslo  = [-3690,    32.02,   19.24 ];
coef_Iyy.Pelvis = [-934,     11.8,    3.44  ];

% Tabla 3.6 - I alrededor del eje longitudinal [kg·cm²]
coef_Izz.Pie    = [-15.48,   0.144,   0.088 ];
coef_Izz.Pierna = [-70.5,    1.134,   0.3   ];
coef_Izz.Muslo  = [-13.5,    11.3,   -2.28  ];
coef_Izz.Pelvis = [-775,     14.7,    1.685 ];

%% Definición de segmentos
% Columnas: { nombre en estructura | tipo Zatsiorsky | proximal | distal }
segmentos = {
    'Pelvis.',              'Pelvis', 'Cadera.Derecha',    'Cadera.Izquierda';
    'Muslo.Derecho',        'Muslo',  'Cadera.Derecha',    'Rodilla.Derecha';
    'Muslo.Izquierdo',      'Muslo',  'Cadera.Izquierda',  'Rodilla.Izquierda';
    'Pierna.Derecha',       'Pierna', 'Rodilla.Derecha',   'Tobillo.Derecho';
    'Pierna.Izquierda',     'Pierna', 'Rodilla.Izquierda', 'Tobillo.Izquierdo';
    'Pie.Derecho',          'Pie',    'Tobillo.Derecho',   'DedoGordo.Derecho';
    'Pie.Izquierdo',        'Pie',    'Tobillo.Izquierdo', 'DedoGordo.Izquierdo'
};

%% Cálculo de parámetros para cada segmento
PI = struct();   % estructura local que se va llenando

for s = 1:size(segmentos, 1)
    fprintf('Segmento %d: %s | prox=%s | dist=%s\n', ...
        s, segmentos{s,1}, segmentos{s,3}, segmentos{s,4});
    nombre = segmentos{s, 1};
    tipo   = segmentos{s, 2};
    P_prox = obtenerCentro(Datos, segmentos{s, 3});   % [n x 3]
    P_dist = obtenerCentro(Datos, segmentos{s, 4});   % [n x 3]

    % --- Longitud del segmento [m] ---
    L_frame = sqrt(sum((P_dist - P_prox).^2, 2));
    L_m     = mean(L_frame);

    % --- Masa del segmento [kg] ---
    c        = coef_masa.(tipo);
    masa_seg = c(1) + c(2) * peso + c(3) * altura;

    % --- Centro de masa [n x 3 en m, sistema GLOBAL] ---
    if strcmp(tipo, 'Pelvis')
        % Simplificación: punto medio entre los dos HJC
        CoM = (P_prox + P_dist) / 2;
    else
        c       = coef_CoM.(tipo);
        d_cm    = c(1) + c(2) * peso + c(3) * altura;   % cm desde proximal
        fraccion = (d_cm / 100) / L_m;                  % fracción de la longitud
        CoM     = P_prox + fraccion * (P_dist - P_prox);
    end

    % --- Momentos de inercia [kg·m²] ---
    % Zatsiorsky devuelve kg·cm²  →  dividir por 10⁴
    c = coef_Ixx.(tipo);  I_xx = (c(1) + c(2) * peso + c(3) * altura) / 1e4;
    c = coef_Iyy.(tipo);  I_yy = (c(1) + c(2) * peso + c(3) * altura) / 1e4;
    c = coef_Izz.(tipo);  I_zz = (c(1) + c(2) * peso + c(3) * altura) / 1e4;

    % --- Matriz de inercia I_0 en coordenadas LOCALES (i, j, k) ---
    %   i (eje 1) = antero-posterior  →  I_xx
    %   j (eje 2) = longitudinal      →  I_zz
    %   k (eje 3) = medial-lateral    →  I_yy
    I_0 = diag([I_xx, I_zz, I_yy]);

    % --- Guardar en estructura local ---
    PI = guardarSegmento(PI, nombre, masa_seg, L_m, CoM, I_0);
end

%% Asignar a la estructura Datos
Datos.Pasada.ParametrosInerciales = PI;

end

% =========================================================================
%                          Funciones locales
% =========================================================================

function P = obtenerCentro(Datos, ruta)
% Obtiene Datos.Pasada.CentrosArticulares.<articulación>.<lado>
% ruta tiene la forma 'Articulación.Lado' (ej: 'Cadera.Derecho').
partes = strsplit(ruta, '.');
P = Datos.Pasada.CentrosArticulares.(partes{1}).(partes{2});
end

function PI = guardarSegmento(PI, nombre, masa, L, CoM, I_0)
% Guarda los 4 campos del segmento en PI.<nombre>, donde <nombre> puede
% tener un nivel ('Pelvis') o dos ('Muslo.Derecho').
partes = strsplit(nombre, '.');
% Para Pelvis llega como 'Pelvis.' (con punto final por uniformidad);
% normalizo eliminando el segundo nivel vacío
partes = partes(~cellfun('isempty', partes));

datos_seg = struct('masa', masa, 'longitud', L, 'CoM', CoM, 'I_0', I_0);

if length(partes) == 1
    PI.(partes{1}) = datos_seg;
else
    PI.(partes{1}).(partes{2}) = datos_seg;
end
end
