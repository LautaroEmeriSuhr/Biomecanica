function Datos = CalculoFuerzasArticulares(Datos, DerechaPlataforma1, PrimerFrame, UltimoFrame)
% CALCULOFUERZASARTICULARES  Calcula las fuerzas articulares netas de
% tobillo, rodilla y cadera por dinámica inversa (apunte, sección 2.7.2).
%
%   Datos = CalculoFuerzasArticulares(Datos)
%
% ENTRADAS (esperadas en Datos)
%   Datos.Pasada.ParametrosInerciales.<seg>.<lado>.masa     [kg]
%   Datos.Pasada.AceleracionLineal.<seg>.<lado>.{ax,ay,az}  [n x 1, m/s²]
%   Datos.Pasada.Fuerzas.Plataforma1.Valores                struct con:
%       .Fx1, .Fy1, .Fz1  [n x 1, N]    -- GRF sobre el pie en coord. globales
%   Datos.lado_plataforma1 : 'Derecho' o 'Izquierdo'
%
% SALIDAS (agregadas a Datos)
%   Datos.Pasada.FuerzasArticulares.Tobillo.<lado>.{Fx,Fy,Fz}  [n x 1, N]
%   Datos.Pasada.FuerzasArticulares.Rodilla.<lado>.{Fx,Fy,Fz}  [n x 1, N]
%   Datos.Pasada.FuerzasArticulares.Cadera.<lado>.{Fx,Fy,Fz}   [n x 1, N]
%
% MÉTODO
%   F_P = m·a - F_D - m·g - F_A      (Newton, segmento por segmento)
%   Cadena: pie → pierna → muslo (de distal a proximal).
%   Por 3ª ley de Newton: F_D del segmento k es -F_P del segmento k-1.
%
% NOTAS
%   - Todo en coordenadas GLOBALES.
%   - g = (0, 0, -9.8) m/s² (Z vertical hacia arriba).
%   - F_GRF en el pie del lado opuesto a Plataforma1 queda en cero. Si hay
%     Plataforma2, agregar aquí la asignación correspondiente.
%   - F_A_pie debe ser la reacción del PISO sobre el pie (sentido físico:
%     empuja hacia arriba). Verificar el signo de Fz1 — si la plataforma
%     reporta la fuerza que el pie ejerce sobre ella, invertir el signo.

%% Constante
g = [0, 0, -9.8];   % [m/s²], coord. globales

%% Tabla de segmentos
% Inconsistencia Derecho/Izquierdo vs Derecha/Izquierda
% Columnas: { sufijo lado para Muslo/Pie, sufijo lado para Pierna }
lados = {
    'Derecho',    'Derecha';
    'Izquierdo',  'Izquierda'
};

%% Fuerza de reacción del piso, ruteada al pie correspondiente
n = length(Datos.Pasada.AceleracionLineal.Pie.Derecho.ax);

if (DerechaPlataforma1==0)
        F_GRx_i = Datos.Pasada.Fuerzas.Plataforma1.Valores.Fx1(PrimerFrame:UltimoFrame);
        F_GRy_i= Datos.Pasada.Fuerzas.Plataforma1.Valores.Fy1(PrimerFrame:UltimoFrame);
        F_GRz_i = Datos.Pasada.Fuerzas.Plataforma1.Valores.Fz1(PrimerFrame:UltimoFrame);


        F_GRx_d= Datos.Pasada.Fuerzas.Plataforma2.Valores.Fx2(PrimerFrame:UltimoFrame);
        F_GRy_d= Datos.Pasada.Fuerzas.Plataforma2.Valores.Fy2(PrimerFrame:UltimoFrame);
        F_GRz_d = Datos.Pasada.Fuerzas.Plataforma2.Valores.Fz2(PrimerFrame:UltimoFrame);
else
    F_GRx_d = Datos.Pasada.Fuerzas.Plataforma1.Valores.Fx1(PrimerFrame:UltimoFrame);
    F_GRy_d= Datos.Pasada.Fuerzas.Plataforma1.Valores.Fy1(PrimerFrame:UltimoFrame);
    F_GRz_d = Datos.Pasada.Fuerzas.Plataforma1.Valores.Fz1(PrimerFrame:UltimoFrame);


    F_GRx_i= Datos.Pasada.Fuerzas.Plataforma2.Valores.Fx2(PrimerFrame:UltimoFrame);
    F_GRy_i= Datos.Pasada.Fuerzas.Plataforma2.Valores.Fy2(PrimerFrame:UltimoFrame);
    F_GRz_i = Datos.Pasada.Fuerzas.Plataforma2.Valores.Fz2(PrimerFrame:UltimoFrame);
end


% Asignación de cada fuerza con su reacción
F_der   = [F_GRx_d, F_GRy_d, F_GRz_d];
F_izq = [F_GRx_i, F_GRy_i, F_GRz_i];

% Remuestreo a las n muestras de la cinemática (la fuerza viene a mayor frecuencia)
F_GRF.Derecho   = resamplearAGrilla(F_der, n);
F_GRF.Izquierdo = resamplearAGrilla(F_izq, n);

% Chequeo de alineación (frames de marcador, 1..n)
fR = find(any(F_GRF.Derecho   ~= 0, 2));
fL = find(any(F_GRF.Izquierdo ~= 0, 2));
fprintf('Contacto Derecho   ~ frames %d a %d\n', fR(1), fR(end));
fprintf('Contacto Izquierdo ~ frames %d a %d\n', fL(1), fL(end));

fprintf('Fz medio en apoyo derecho = %.1f N\n', mean(F_GRF.Derecho(fR,3)));

%% Cálculo por lado
for k = 1:2
    L_mp = lados{k, 1};   % 'Derecho'/'Izquierdo' (Muslo, Pie)
    L_p  = lados{k, 2};   % 'Derecha'/'Izquierda' (Pierna)

    % ---------- PIE ----------
    m   = Datos.Pasada.ParametrosInerciales.Pie.(L_mp).masa;
    a   = aceleracion(Datos, 'Pie', L_mp);
    F_D = zeros(n, 3);                              % extremo libre
    F_A = F_GRF.(L_mp);                             % reacción del piso
    F_P_pie = m*a - F_D - m*g - F_A;

    % ---------- PIERNA ----------
    m   = Datos.Pasada.ParametrosInerciales.Pierna.(L_p).masa;
    a   = aceleracion(Datos, 'Pierna', L_p);
    F_D = -F_P_pie;                                 % 3ra ley
    F_A = zeros(n, 3);
    F_P_pierna = m*a - F_D - m*g - F_A;

    % ---------- MUSLO ----------
    m   = Datos.Pasada.ParametrosInerciales.Muslo.(L_mp).masa;
    a   = aceleracion(Datos, 'Muslo', L_mp);
    F_D = -F_P_pierna;
    F_A = zeros(n, 3);
    F_P_muslo = m*a - F_D - m*g - F_A;

    % ---------- Guardado ----------
    Datos = guardarFuerza(Datos, 'Tobillo', L_mp, F_P_pie);
    Datos = guardarFuerza(Datos, 'Rodilla', L_mp, F_P_pierna);
    Datos = guardarFuerza(Datos, 'Cadera',  L_mp, F_P_muslo);
end

%% Graficacion

%% Preparación: normalización al ciclo de marcha
x = linspace(0, 100, 100);

ciclo_derecho   = Datos.eventos.FrameRHS2 - Datos.eventos.FrameRHS1;
ciclo_izquierdo = Datos.eventos.FrameLHS2 - Datos.eventos.FrameLHS1;

x_RTO = (Datos.eventos.FrameRTO - Datos.eventos.FrameRHS1) / ciclo_derecho   * 100;
x_LTO = (Datos.eventos.FrameLTO - Datos.eventos.FrameLHS1) / ciclo_izquierdo * 100;

rng_R = Datos.eventos.FrameRHS1 : Datos.eventos.FrameRHS2;
rng_L = Datos.eventos.FrameLHS1 : Datos.eventos.FrameLHS2;

%% Figura: Fuerzas Articulares
% Filas: articulaciones (orden del target). Columnas: componentes.
articulaciones = {'Cadera'; 'Rodilla'; 'Tobillo'};

% Mapeo componente global → dirección anatómica (orden de columnas del target).
% OJO: este mapeo depende de la convención de ejes de tu laboratorio.
% Asumido (típico Vicon): X = AP, Y = ML, Z = vertical/longitudinal.
componentes = {'Fy',                       'Fx',                  'Fz'};
ejesF       = {'Lateral(-)/Medial(+) [N]', 'Post(-)/Ant(+) [N]',  'Dist(-)/Prox(+) [N]'};

figure('Name', 'Fuerzas articulares')
sgtitle('Fuerzas Articulares Netas - Ciclo de Marcha', ...
        'FontSize', 14, 'FontWeight', 'bold')

for a = 1:size(articulaciones, 1)
    art = articulaciones{a};
    for c = 1:length(componentes)
        subplot(3, 3, (a-1)*3 + c)
        [senal_der, senal_izq] = obtenerSenales(Datos, ...
            'FuerzasArticulares', art, 'Derecho', 'Izquierdo', componentes{c});
        graficarFuerzaArticulares(x, ...
            InterpolaA100Muestras(senal_der(rng_R)), ...
            InterpolaA100Muestras(senal_izq(rng_L)), ...
            x_RTO, x_LTO, ...
            ['Fuerza ', art]);
        ylabel(ejesF{c})
    end
end
end

% =========================================================================
%                          Funciones locales
% =========================================================================

function a = aceleracion(Datos, seg, lado)
% Arma la matriz [n x 3] de aceleración del CM en coord. globales.
S = Datos.Pasada.AceleracionLineal.(seg).(lado);
a = [S.ax, S.ay, S.az];
end

function Datos = guardarFuerza(Datos, articulacion, lado, F)
% Guarda la fuerza articular en la estructura.
Datos.Pasada.FuerzasArticulares.(articulacion).(lado).Fx = F(:, 1);
Datos.Pasada.FuerzasArticulares.(articulacion).(lado).Fy = F(:, 2);
Datos.Pasada.FuerzasArticulares.(articulacion).(lado).Fz = F(:, 3);
end

function Y = resamplearAGrilla(X, n)
% Remuestrea cada columna de X a n muestras por interpolación lineal
% sobre una grilla temporal normalizada (0..1).
S = size(X, 1);
if S == n
    Y = X;
    return
end
t_orig = linspace(0, 1, S);
t_new  = linspace(0, 1, n);
Y = interp1(t_orig, X, t_new, 'linear');   % interp1 trabaja por columnas
end

function [sDer, sIzq] = obtenerSenales(Datos, campo, seg, sufDer, sufIzq, comp)
% Obtiene las señales derecha e izquierda de un segmento dado.
% Para Pelvis (sin sufijos) devuelve la misma señal en ambos lados.
if isempty(sufDer)
    s    = Datos.Pasada.(campo).(seg).(comp);
    sDer = s;
    sIzq = s;
else
    sDer = Datos.Pasada.(campo).(seg).(sufDer).(comp);
    sIzq = Datos.Pasada.(campo).(seg).(sufIzq).(comp);
end
end