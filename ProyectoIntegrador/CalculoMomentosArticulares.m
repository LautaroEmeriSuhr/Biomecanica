function Datos = CalculoMomentosArticulares(Datos, DerechaPlataforma1)
% CALCULOMOMENTOSARTICULARES  Momentos musculares netos de tobillo, rodilla y
% cadera por dinámica inversa, proyectados a ejes articulares anatómicos.

% =========================================================================
% CHEQUEO: poné este flag en FALSE para verificar la dinámica SIN el momento
% libre (MA = 0). Si las curvas quedan fisiológicas (~tobillo 100 N·m) el
% cálculo está bien. Después ponelo en TRUE para incluir el momento libre ya
% anclado a los eventos y convertido a N·m.
% =========================================================================
usar_momento_libre = false;

% Sufijo de lado por estructura.
segPie    = {'Pie',    'Derecho',  'Izquierdo'};
segPierna = {'Pierna', 'Derecha',  'Izquierda'};
segMuslo  = {'Muslo',  'Derecho',  'Izquierdo'};

ladoCA_R = 'Derecho';   ladoCA_L = 'Izquierdo';

n = length(Datos.Pasada.AceleracionLineal.Pie.Derecho.ax);

% 1. Extraer los momentos libres crudos (eje Z) de cada plataforma
M_Plat1_z = Datos.Pasada.Fuerzas.Plataforma1.Valores.Mz1;
M_Plat2_z = Datos.Pasada.Fuerzas.Plataforma2.Valores.Mz2;

if DerechaPlataforma1 == 0
    M_libre_der_raw = M_Plat2_z;
    M_libre_izq_raw = M_Plat1_z;
else
    M_libre_der_raw = M_Plat1_z;
    M_libre_izq_raw = M_Plat2_z;
end

% 2. Momento libre: se ancla el bloque de contacto del Mz CRUDO a la ventana
%    de apoyo [FrameHS:FrameTO] (que coincide con la GRF ya sincronizada) y se
%    convierte de N·mm a N·m. alinearMomento busca el bloque no-cero del crudo
%    y lo re-estira a esa ventana, con ceros afuera.
if usar_momento_libre
    Datos.Pasada.MomentoLibre.Derecho = ...
        alinearMomento(M_libre_der_raw, n, Datos.eventos.FrameRHS1, Datos.eventos.FrameRTO) / 1000;
    Datos.Pasada.MomentoLibre.Izquierdo = ...
        alinearMomento(M_libre_izq_raw, n, Datos.eventos.FrameLHS1, Datos.eventos.FrameLTO) / 1000;
else
    Datos.Pasada.MomentoLibre.Derecho   = zeros(n, 1);
    Datos.Pasada.MomentoLibre.Izquierdo = zeros(n, 1);
end

% Limpieza preventiva de NaNs en los vectores de centro de presión
rGr_limpio = Datos.Pasada.Marcadores.Valores.rGr;
lGR_limpio = Datos.Pasada.Marcadores.Valores.lGr;
if any(isnan(rGr_limpio), 'all'), rGr_limpio = limpiarNaN(rGr_limpio); end
if any(isnan(lGR_limpio), 'all'), lGR_limpio = limpiarNaN(lGR_limpio); end

%% ---------------------------- LADO DERECHO ------------------------------
SD = armarEntradas(Datos, segPie, segPierna, segMuslo, ...
        ladoCA_R, 'Derecho', 'Derecha', 'Derecho', ...
        rGr_limpio, Datos.Pasada.GRF.Derecha, ...
        Datos.Pasada.MomentoLibre.Derecho);
[Mtob_D, Mrod_D, Mcad_D] = momentosCadena(SD);

%% --------------------------- LADO IZQUIERDO -----------------------------
SI = armarEntradas(Datos, segPie, segPierna, segMuslo, ...
        ladoCA_L, 'Izquierdo', 'Izquierda', 'Izquierdo', ...
        lGR_limpio, Datos.Pasada.GRF.Izquierda, ...
        Datos.Pasada.MomentoLibre.Izquierdo);
[Mtob_I, Mrod_I, Mcad_I] = momentosCadena(SI);

%% --------------------------- Guardado (LOCAL) ---------------------------
Datos.Pasada.MomentosArticulares.Tobillo.Derecho   = Mtob_D;
Datos.Pasada.MomentosArticulares.Rodilla.Derecho   = Mrod_D;
Datos.Pasada.MomentosArticulares.Cadera.Derecho    = Mcad_D;
Datos.Pasada.MomentosArticulares.Tobillo.Izquierdo = Mtob_I;
Datos.Pasada.MomentosArticulares.Rodilla.Izquierdo = Mrod_I;
Datos.Pasada.MomentosArticulares.Cadera.Izquierdo  = Mcad_I;

%% ----------------- Proyección a ejes articulares (global) ---------------
SCA = Datos.Pasada.SistemaCoordenadoAnatomico;

% Tobillo: proximal = Pierna, distal = Pie
[Mtob_D_g] = localAGlobal(Mtob_D, SCA.Pie.Derecho.i,   SCA.Pie.Derecho.j,   SCA.Pie.Derecho.k);
[Mtob_I_g] = localAGlobal(Mtob_I, SCA.Pie.Izquierdo.i, SCA.Pie.Izquierdo.j, SCA.Pie.Izquierdo.k);
[tobD.flexext, tobD.rotie, tobD.abdadd] = proyectarEjesArticulares(Mtob_D_g, SCA.Pierna.Derecha.k,   SCA.Pie.Derecho.i);
[tobI.flexext, tobI.rotie, tobI.abdadd] = proyectarEjesArticulares(Mtob_I_g, SCA.Pierna.Izquierda.k, SCA.Pie.Izquierdo.i);

% Rodilla: proximal = Muslo, distal = Pierna
[Mrod_D_g] = localAGlobal(Mrod_D, SCA.Pierna.Derecha.i,   SCA.Pierna.Derecha.j,   SCA.Pierna.Derecha.k);
[Mrod_I_g] = localAGlobal(Mrod_I, SCA.Pierna.Izquierda.i, SCA.Pierna.Izquierda.j, SCA.Pierna.Izquierda.k);
[rodD.flexext, rodD.rotie, rodD.abdadd] = proyectarEjesArticulares(Mrod_D_g, SCA.Muslo.Derecho.k,   SCA.Pierna.Derecha.i);
[rodI.flexext, rodI.rotie, rodI.abdadd] = proyectarEjesArticulares(Mrod_I_g, SCA.Muslo.Izquierdo.k, SCA.Pierna.Izquierda.i);

% Cadera: proximal = Pelvis, distal = Muslo
[Mcad_D_g] = localAGlobal(Mcad_D, SCA.Muslo.Derecho.i,   SCA.Muslo.Derecho.j,   SCA.Muslo.Derecho.k);
[Mcad_I_g] = localAGlobal(Mcad_I, SCA.Muslo.Izquierdo.i, SCA.Muslo.Izquierdo.j, SCA.Muslo.Izquierdo.k);
[cadD.flexext, cadD.rotie, cadD.abdadd] = proyectarEjesArticulares(Mcad_D_g, SCA.Pelvis.k, SCA.Muslo.Derecho.i);
[cadI.flexext, cadI.rotie, cadI.abdadd] = proyectarEjesArticulares(Mcad_I_g, SCA.Pelvis.k, SCA.Muslo.Izquierdo.i);

% Corrección de signos morfológicos según convenciones biomecánicas estándares
tobD.flexext = -tobD.flexext; tobI.flexext = -tobI.flexext;
rodD.flexext = -rodD.flexext; rodI.flexext = -rodI.flexext;
cadD.flexext = -cadD.flexext; cadI.flexext = -cadI.flexext;

tobI.abdadd = -tobI.abdadd;   tobI.rotie = -tobI.rotie;
rodI.abdadd = -rodI.abdadd;   rodI.rotie = -rodI.rotie;
cadI.abdadd = -cadI.abdadd;   cadI.rotie = -cadI.rotie;

Datos.Pasada.MomentosArticularesEjes.Tobillo.Derecho   = tobD;
Datos.Pasada.MomentosArticularesEjes.Tobillo.Izquierdo = tobI;
Datos.Pasada.MomentosArticularesEjes.Rodilla.Derecho   = rodD;
Datos.Pasada.MomentosArticularesEjes.Rodilla.Izquierdo = rodI;
Datos.Pasada.MomentosArticularesEjes.Cadera.Derecho    = cadD;
Datos.Pasada.MomentosArticularesEjes.Cadera.Izquierdo  = cadI;

%% ------------------------------ Graficación -----------------------------
x = linspace(0, 100, 100);
ciclo_derecho   = Datos.eventos.FrameRHS2 - Datos.eventos.FrameRHS1;
ciclo_izquierdo = Datos.eventos.FrameLHS2 - Datos.eventos.FrameLHS1;

if isempty(ciclo_derecho) || ciclo_derecho <= 0, ciclo_derecho = n; end
if isempty(ciclo_izquierdo) || ciclo_izquierdo <= 0, ciclo_izquierdo = n; end

x_RTO = (Datos.eventos.FrameRTO - Datos.eventos.FrameRHS1) / ciclo_derecho   * 100;
x_LTO = (Datos.eventos.FrameLTO - Datos.eventos.FrameLHS1) / ciclo_izquierdo * 100;

if isempty(Datos.eventos.FrameRHS1) || isnan(Datos.eventos.FrameRHS1), rng_R = 1:n; else, rng_R = Datos.eventos.FrameRHS1 : Datos.eventos.FrameRHS2; end
if isempty(Datos.eventos.FrameLHS1) || isnan(Datos.eventos.FrameLHS1), rng_L = 1:n; else, rng_L = Datos.eventos.FrameLHS1 : Datos.eventos.FrameLHS2; end

% NORMALIZACIÓN: Por masa del sujeto (N·m/kg)
masa_sujeto = Datos.antropometria.PESO.Valor;

filas = {
 'Cadera',  cadD.flexext, cadI.flexext, cadD.abdadd, cadI.abdadd, cadD.rotie, cadI.rotie;
 'Rodilla', rodD.flexext, rodI.flexext, rodD.abdadd, rodI.abdadd, rodD.rotie, rodI.rotie;
 'Tobillo', tobD.flexext, tobI.flexext, tobD.abdadd, tobI.abdadd, tobD.rotie, tobI.rotie
};
ejesM = {'Ext(-)/Flex(+) [N·m/kg]', 'Add(-)/Abd(+) [N·m/kg]', 'RotExt(-)/RotInt(+) [N·m/kg]'};

figure('Name', 'Momentos articulares (ejes anatómicos)')
sgtitle('Momentos Articulares Netos - Ciclo de Marcha', 'FontSize', 14, 'FontWeight', 'bold')

for f = 1:size(filas, 1)
    art = filas{f, 1};
    for c = 1:3
        der = filas{f, 2 + (c-1)*2} / masa_sujeto;
        izq = filas{f, 3 + (c-1)*2} / masa_sujeto;
        subplot(3, 3, (f-1)*3 + c)

        v_der = der(rng_R); v_izq = izq(rng_L);

        graficarMomentosArticulares(x, ...
            InterpolaSegura(v_der), ...
            InterpolaSegura(v_izq), ...
            x_RTO, x_LTO, ['Momento ', art]);
        ylabel(ejesM{c})
    end
end
end

% =========================================================================
%                          FUNCIONES LOCALES
% =========================================================================

function [Mtob, Mrod, Mcad] = momentosCadena(S)
% Resuelve la dinámica inversa usando vectores consistentes en el espacio GLOBAL.
n = size(S.GRF, 1);
ML = S.MLibre(:);
if length(ML) ~= n
    t_orig = linspace(0, 1, length(ML)); t_new = linspace(0, 1, n);
    ML = interp1(t_orig, ML, t_new, 'linear')';
end
MA = [zeros(n,1), zeros(n,1), ML];   % momento libre (solo eje vertical, en N·m)

% --- Convertir fuerzas articulares de LOCAL (del paso previo) a GLOBAL ---
Fp_pie_g    = localAGlobal(S.Fp_pie_loc, S.i5, S.j5, S.k5);
Fp_pierna_g = localAGlobal(S.Fp_pierna_loc, S.i3, S.j3, S.k3);
Fp_muslo_g  = localAGlobal(S.Fp_muslo_loc, S.i1, S.j1, S.k1);

% -------------------------------- PIE -----------------------------------
rP1 = S.AJC - S.CoM_pie;    % Global
rA1 = S.rGR - S.CoM_pie;    % Global

MR1_global = cross(rP1, Fp_pie_g, 2) + cross(rA1, S.GRF, 2) + MA;
dH_pie_g   = localAGlobal(S.dH_pie, S.i5, S.j5, S.k5);

Mtob_g     = dH_pie_g - MR1_global;
Mtob       = globalALocal(Mtob_g, S.i5, S.j5, S.k5); % Se guarda en el sistema local del Pie

% ------------------------------- PIERNA ---------------------------------
FD2_g   = -Fp_pie_g;
rD2     = S.AJC - S.CoM_pierna;
rP2     = S.KJC - S.CoM_pierna;

MR2_global = cross(rD2, FD2_g, 2) + cross(rP2, Fp_pierna_g, 2) - Mtob_g;
dH_pierna_g = localAGlobal(S.dH_pierna, S.i3, S.j3, S.k3);

Mrod_g     = dH_pierna_g - MR2_global;
Mrod       = globalALocal(Mrod_g, S.i3, S.j3, S.k3); % Se guarda en el sistema local de la Pierna

% -------------------------------- MUSLO ---------------------------------
FD3_g   = -Fp_pierna_g;
rD3     = S.KJC - S.CoM_muslo;
rP3     = S.HJC - S.CoM_muslo;

MR3_global = cross(rD3, FD3_g, 2) + cross(rP3, Fp_muslo_g, 2) - Mrod_g;
dH_muslo_g = localAGlobal(S.dH_muslo, S.i1, S.j1, S.k1);

Mcad_g     = dH_muslo_g - MR3_global;
Mcad       = globalALocal(Mcad_g, S.i1, S.j1, S.k1); % Se guarda en el sistema local del Muslo
end

function S = armarEntradas(Datos, segPie, segPierna, segMuslo, ...
        ladoCA, ladoPie, ladoPierna, ladoMuslo, rGRlado, GRFlado, MLibre)
SCA = Datos.Pasada.SistemaCoordenadoAnatomico;
CA  = Datos.Pasada.CentrosArticulares;
PI  = Datos.Pasada.ParametrosInerciales;

S.i5 = SCA.Pie.(ladoPie).i;     S.j5 = SCA.Pie.(ladoPie).j;     S.k5 = SCA.Pie.(ladoPie).k;
S.i3 = SCA.Pierna.(ladoPierna).i; S.j3 = SCA.Pierna.(ladoPierna).j; S.k3 = SCA.Pierna.(ladoPierna).k;
S.i1 = SCA.Muslo.(ladoMuslo).i; S.j1 = SCA.Muslo.(ladoMuslo).j; S.k1 = SCA.Muslo.(ladoMuslo).k;

S.dH_pie    = getdH(Datos, 'Pie',    ladoPie);
S.dH_pierna = getdH(Datos, 'Pierna', ladoPierna);
S.dH_muslo  = getdH(Datos, 'Muslo',  ladoMuslo);

FA = Datos.Pasada.FuerzasArticulares;
opcionesLado = {'Derecha', 'Derecho'};
if ~strcmp(ladoPie, 'Derecho') && ~strcmp(ladoPie, 'Derecha'), opcionesLado = {'Izquierda', 'Izquierdo'}; end

if isfield(FA.Tobillo, opcionesLado{1}), lTobF = opcionesLado{1}; else, lTobF = opcionesLado{2}; end
S.Fp_pie_loc = [FA.Tobillo.(lTobF).x, FA.Tobillo.(lTobF).y, FA.Tobillo.(lTobF).z];

if isfield(FA.Rodilla, opcionesLado{1}), lRodF = opcionesLado{1}; else, lRodF = opcionesLado{2}; end
S.Fp_pierna_loc = [FA.Rodilla.(lRodF).x, FA.Rodilla.(lRodF).y, FA.Rodilla.(lRodF).z];

if isfield(FA.Cadera, opcionesLado{1}), lCadF = opcionesLado{1}; else, lCadF = opcionesLado{2}; end
S.Fp_muslo_loc = [FA.Cadera.(lCadF).x, FA.Cadera.(lCadF).y, FA.Cadera.(lCadF).z];

opcionesCA = {'Derecha', 'Derecho'};
if ~strcmp(ladoCA, 'Derecho') && ~strcmp(ladoCA, 'Derecha'), opcionesCA = {'Izquierda', 'Izquierdo'}; end

if isfield(CA.Tobillo, opcionesCA{1}), lTobCA = opcionesCA{1}; else, lTobCA = opcionesCA{2}; end
S.AJC = CA.Tobillo.(lTobCA);
if isfield(CA.Rodilla, opcionesCA{1}), lRodCA = opcionesCA{1}; else, lRodCA = opcionesCA{2}; end
S.KJC = CA.Rodilla.(lRodCA);
if isfield(CA.Cadera, opcionesCA{1}), lCadCA = opcionesCA{1}; else, lCadCA = opcionesCA{2}; end
S.HJC = CA.Cadera.(lCadCA);

S.CoM_pie    = PI.Pie.(ladoPie).CoM;
S.CoM_pierna = PI.Pierna.(ladoPierna).CoM;
S.CoM_muslo  = PI.Muslo.(ladoMuslo).CoM;

S.rGR    = rGRlado; S.GRF = GRFlado; S.MLibre = MLibre;
end

function MatrizLimpia = limpiarNaN(MatrizConNaN)
MatrizLimpia = MatrizConNaN; [filas, columnas] = size(MatrizLimpia); t = 1:filas;
for c = 1:columnas
    columna_actual = MatrizLimpia(:, c); nans = isnan(columna_actual);
    if any(nans)
        if all(nans), columna_actual(:) = 0; else, columna_actual(nans) = interp1(t(~nans), columna_actual(~nans), t(nans), 'linear', 'extrap'); end
        MatrizLimpia(:, c) = columna_actual;
    end
end
end

function Y = InterpolaSegura(V)
V(isnan(V)) = [];
if isempty(V), Y = zeros(1, 100); elseif length(V) < 2, Y = ones(1, 100) * V(1); else
    t_orig = linspace(0, 1, length(V)); t_new = linspace(0, 1, 100); Y = interp1(t_orig, V, t_new, 'spline');
end
end

function dH = getdH(Datos, seg, lado)
D  = Datos.Pasada.DerivadaCantidadMovimientoAngular.(seg).(lado); dH = [D.dHx_dt, D.dHy_dt, D.dHz_dt];
end

function Vg = localAGlobal(Vl, i, j, k)
Vg = Vl(:,1).*i + Vl(:,2).*j + Vl(:,3).*k;
end

function Vl = globalALocal(Vg, i, j, k)
Vl = [dot(Vg, i, 2), dot(Vg, j, 2), dot(Vg, k, 2)];
end

function [flexext, rotie, abdadd] = proyectarEjesArticulares(M, k_prox, i_dist)
flexext = dot(M, k_prox, 2); rotie = dot(M, i_dist, 2);
eje_flot = cross(k_prox, i_dist, 2); eje_flot = eje_flot ./ vecnorm(eje_flot, 2, 2); abdadd = dot(M, eje_flot, 2);
end

function Y = resamplearAGrilla(X, n)
% Remuestrea X a n filas. Acepta vector fila/columna o matriz (por columnas).
if isrow(X)            % si viene como fila, lo paso a columna
    X = X(:);
end
S = size(X, 1);
if S == n
    Y = X;
    return;
end
if S < 2               % sin suficientes muestras para interpolar
    Y = repmat(X(1,:), n, 1);
    return;
end
t_orig = linspace(0, 1, S);
t_new  = linspace(0, 1, n);
Y = interp1(t_orig, X, t_new, 'linear');
if size(Y, 1) ~= n     % interp1 devuelve fila cuando X es vector columna
    Y = Y.';
end
end

function Mout = alinearMomento(Mraw, n, iniApoyo, finApoyo)
% Ancla el bloque de apoyo (no-cero) del momento libre CRUDO a [iniApoyo:finApoyo]
% sobre una grilla de n muestras de marcador; ceros fuera del apoyo.
Mraw = Mraw(:);                 % momento libre = escalar por frame -> columna
Mout = zeros(n, 1);

idx = find(Mraw ~= 0);          % bloque de contacto en frames crudos
if isempty(idx)
    return;                     % sin apoyo detectado -> todo cero
end
bloque = Mraw(idx(1):idx(end)); % columna

% Clamp de seguridad de los eventos al rango válido
iniApoyo = max(1, round(iniApoyo));
finApoyo = min(n, round(finApoyo));
if finApoyo <= iniApoyo
    return;
end

L = finApoyo - iniApoyo + 1;
Mout(iniApoyo:finApoyo) = resamplearAGrilla(bloque, L);
end