function Datos = CalculoFuerzasArticulares(Datos, DerechaPlataforma1)
% CALCULOFUERZASARTICULARES  Fuerzas articulares netas de tobillo, rodilla y
% cadera por dinámica inversa (apunte, sección 2.7.2), proyectadas a ejes
% anatómicos (medio/lateral, antero/posterior, proximo/distal).
%
%   Datos = CalculoFuerzasArticulares(Datos, DerechaPlataforma1)
%
% ENTRADAS
%   DerechaPlataforma1 : 1 -> Plataforma1 = pisada DERECHA (mi caso)
%                        0 -> Plataforma1 = pisada IZQUIERDA
%   Datos.Pasada.ParametrosInerciales.<seg>.<lado>.masa            [kg]
%   Datos.Pasada.AceleracionLineal.<seg>.<lado>.{ax,ay,az}         [n x 1, m/s2]
%   Datos.Pasada.Fuerzas.Plataforma1/2.Valores.{Fx,Fy,Fz}{1,2}    [m x 1, N]
%   Datos.Pasada.SistemaCoordenadoAnatomico.<seg>.<lado>.{i,j,k}   [n x 3]
%   Datos.eventos.{FrameRHS1,FrameRHS2,FrameLHS1,FrameLHS2,FrameRTO,FrameLTO}
%
% MÉTODO
%   F_P = m*a - m*g - F_A - F_D   (Newton, segmento por segmento)
%   Cadena distal->proximal: pie -> pierna -> muslo.
%   3ra ley: la fuerza distal del segmento k es -F_P del segmento k-1.
%   La gravedad entra en Z como (az + 9.81), equivalente a -m*g con g=(0,0,-9.81).
%

%% Ruteo de plataformas + remuestreo a la grilla de la cinemática
n  = length(Datos.Pasada.AceleracionLineal.Pie.Derecho.ax);
P1 = Datos.Pasada.Fuerzas.Plataforma1.Valores;
P2 = Datos.Pasada.Fuerzas.Plataforma2.Valores;

if DerechaPlataforma1 == 0          % Plataforma1 = izquierda
    F_der = [P2.Fx2, P2.Fy2, P2.Fz2];
    F_izq = [P1.Fx1, P1.Fy1, P1.Fz1];
else                                % Plataforma1 = derecha (mi caso)
    F_der = [P1.Fx1, P1.Fy1, P1.Fz1];
    F_izq = [P2.Fx2, P2.Fy2, P2.Fz2];
end

F_GRF.Derecho   = resamplearAGrilla(F_der, n);   % [n x 3]
F_GRF.Izquierdo = resamplearAGrilla(F_izq, n);   % [n x 3]

F_GRF.Derecho   = alinearGRF(F_der, n, Datos.eventos.FrameRHS1, Datos.eventos.FrameRTO);
F_GRF.Izquierdo = alinearGRF(F_izq, n, Datos.eventos.FrameLHS1, Datos.eventos.FrameLTO);

Datos.Pasada.GRF.Derecha = F_GRF.Derecho;
Datos.Pasada.GRF.Izquierda = F_GRF.Izquierdo;

% Componentes de la GRF por lado (fuerza externa sobre el pie)
FxD = F_GRF.Derecho(:,1);   FyD = F_GRF.Derecho(:,2);   FzD = F_GRF.Derecho(:,3);
FxI = F_GRF.Izquierdo(:,1); FyI = F_GRF.Izquierdo(:,2); FzI = F_GRF.Izquierdo(:,3);

% Chequeo de alineación y de signo
fR = find(any(F_GRF.Derecho   ~= 0, 2));
fL = find(any(F_GRF.Izquierdo ~= 0, 2));
fprintf('Contacto Derecho   ~ frames %d a %d\n', fR(1), fR(end));
fprintf('Contacto Izquierdo ~ frames %d a %d\n', fL(1), fL(end));
fprintf('Fz medio en apoyo derecho = %.1f N\n', mean(F_GRF.Derecho(fR,3)));

fprintf('GRF der activa: %d-%d | eventos: RHS1=%d RTO=%d RHS2=%d\n', ...
    fR(1), fR(end), Datos.eventos.FrameRHS1, Datos.eventos.FrameRTO, Datos.eventos.FrameRHS2);
fprintf('GRF izq activa: %d-%d | eventos: LHS1=%d LTO=%d LHS2=%d\n', ...
    fL(1), fL(end), Datos.eventos.FrameLHS1, Datos.eventos.FrameLTO, Datos.eventos.FrameLHS2);

%% Cadena cinética distal -> proximal, por lado
% F5/F6 = tobillo, F3/F4 = rodilla, F1/F2 = cadera

% ----- DERECHA -----
[Fx5,Fy5,Fz5] = calculofuerzas(Datos.Pasada.ParametrosInerciales.Pie.Derecho.masa, ...
    aceleracion(Datos,'Pie','Derecho'),    FxD, FyD, FzD);
[Fx3,Fy3,Fz3] = calculofuerzas(Datos.Pasada.ParametrosInerciales.Pierna.Derecha.masa, ...
    aceleracion(Datos,'Pierna','Derecha'), -Fx5, -Fy5, -Fz5);   % 3ra ley: -F_tobillo
[Fx1,Fy1,Fz1] = calculofuerzas(Datos.Pasada.ParametrosInerciales.Muslo.Derecho.masa, ...
    aceleracion(Datos,'Muslo','Derecho'),  -Fx3, -Fy3, -Fz3);   % 3ra ley: -F_rodilla
F5 = [Fx5,Fy5,Fz5]; F3 = [Fx3,Fy3,Fz3]; F1 = [Fx1,Fy1,Fz1];

% ----- IZQUIERDA -----
[Fx6,Fy6,Fz6] = calculofuerzas(Datos.Pasada.ParametrosInerciales.Pie.Izquierdo.masa, ...
    aceleracion(Datos,'Pie','Izquierdo'),    FxI, FyI, FzI);
[Fx4,Fy4,Fz4] = calculofuerzas(Datos.Pasada.ParametrosInerciales.Pierna.Izquierda.masa, ...
    aceleracion(Datos,'Pierna','Izquierda'), -Fx6, -Fy6, -Fz6);
[Fx2,Fy2,Fz2] = calculofuerzas(Datos.Pasada.ParametrosInerciales.Muslo.Izquierdo.masa, ...
    aceleracion(Datos,'Muslo','Izquierdo'),  -Fx4, -Fy4, -Fz4);
F6 = [Fx6,Fy6,Fz6]; F4 = [Fx4,Fy4,Fz4]; F2 = [Fx2,Fy2,Fz2];

%% Guardado de datos en coordenadas globales
% Derecha
Datos.Pasada.FuerzasArticulares.Tobillo.Derecho.Fx         = F5(:,1); 
Datos.Pasada.FuerzasArticulares.Tobillo.Derecho.Fy         = F5(:,2);
Datos.Pasada.FuerzasArticulares.Tobillo.Derecho.Fz         = F5(:,3);

Datos.Pasada.FuerzasArticulares.Rodilla.Derecha.Fx      = F3(:,1);
Datos.Pasada.FuerzasArticulares.Rodilla.Derecha.Fy      = F3(:,2);
Datos.Pasada.FuerzasArticulares.Rodilla.Derecha.Fz      = F3(:,3);

Datos.Pasada.FuerzasArticulares.Cadera.Derecha.Fx       = F1(:,1);
Datos.Pasada.FuerzasArticulares.Cadera.Derecha.Fy       = F1(:,2);
Datos.Pasada.FuerzasArticulares.Cadera.Derecha.Fz       = F1(:,3);

% Izquierda
Datos.Pasada.FuerzasArticulares.Tobillo.Izquierdo.Fx       = F6(:,1);
Datos.Pasada.FuerzasArticulares.Tobillo.Izquierdo.Fy       = F6(:,2);
Datos.Pasada.FuerzasArticulares.Tobillo.Izquierdo.Fz       = F6(:,3);

Datos.Pasada.FuerzasArticulares.Rodilla.Izquierda.Fx      = F4(:,1);
Datos.Pasada.FuerzasArticulares.Rodilla.Izquierda.Fy      = F4(:,2);
Datos.Pasada.FuerzasArticulares.Rodilla.Izquierda.Fz      = F4(:,3);

Datos.Pasada.FuerzasArticulares.Cadera.Izquierda.Fx       = F2(:,1);
Datos.Pasada.FuerzasArticulares.Cadera.Izquierda.Fy       = F2(:,2);
Datos.Pasada.FuerzasArticulares.Cadera.Izquierda.Fz       = F2(:,3);

%% Proyección a ejes articulares (anatómicos)
SCA = Datos.Pasada.SistemaCoordenadoAnatomico;

% Tobillo (pie):  prxdis = Pie.i (distal),    medlat = Pierna.k (proximal)
[Fpieder_prxdis, Fpieder_medlat, Fpieder_antpos] = proyectarAnatomico(F5, SCA.Pie.Derecho.i,   SCA.Pierna.Derecha.k);
[Fpieizq_prxdis, Fpieizq_medlat, Fpieizq_antpos] = proyectarAnatomico(F6, SCA.Pie.Izquierdo.i, SCA.Pierna.Izquierda.k);
Fpieizq_medlat = -Fpieizq_medlat;   % medial es opuesto en Y global entre lados

% Rodilla (pierna): prxdis = Pierna.i,        medlat = Muslo.k
[Fpierder_prxdis, Fpierder_medlat, Fpierder_antpos] = proyectarAnatomico(F3, SCA.Pierna.Derecha.i,   SCA.Muslo.Derecho.k);
[Fpierizq_prxdis, Fpierizq_medlat, Fpierizq_antpos] = proyectarAnatomico(F4, SCA.Pierna.Izquierda.i, SCA.Muslo.Izquierdo.k);
Fpierizq_medlat = -Fpierizq_medlat;

% Cadera (muslo):  prxdis = Muslo.i,          medlat = Pelvis.k
[Fmusder_prxdis, Fmusder_medlat, Fmusder_antpos] = proyectarAnatomico(F1, SCA.Muslo.Derecho.i,   SCA.Pelvis.k);
[Fmusizq_prxdis, Fmusizq_medlat, Fmusizq_antpos] = proyectarAnatomico(F2, SCA.Muslo.Izquierdo.i, SCA.Pelvis.k);
Fmusizq_medlat = -Fmusizq_medlat;

%% Graficación: Fuerzas articulares en ejes anatómicos
x = linspace(0, 100, 100);

ciclo_derecho   = Datos.eventos.FrameRHS2 - Datos.eventos.FrameRHS1;
ciclo_izquierdo = Datos.eventos.FrameLHS2 - Datos.eventos.FrameLHS1;
x_RTO = (Datos.eventos.FrameRTO - Datos.eventos.FrameRHS1) / ciclo_derecho   * 100;
x_LTO = (Datos.eventos.FrameLTO - Datos.eventos.FrameLHS1) / ciclo_izquierdo * 100;
rng_R = Datos.eventos.FrameRHS1 : Datos.eventos.FrameRHS2;
rng_L = Datos.eventos.FrameLHS1 : Datos.eventos.FrameLHS2;

% Filas: articulación. Columnas (pares der/izq): medlat, antpos, prxdis
filas = {
 'Cadera',  Fmusder_medlat,  Fmusizq_medlat,  Fmusder_antpos,  Fmusizq_antpos,  Fmusder_prxdis,  Fmusizq_prxdis;
 'Rodilla', Fpierder_medlat, Fpierizq_medlat, Fpierder_antpos, Fpierizq_antpos, Fpierder_prxdis, Fpierizq_prxdis;
 'Tobillo', Fpieder_medlat,  Fpieizq_medlat,  Fpieder_antpos,  Fpieizq_antpos,  Fpieder_prxdis,  Fpieizq_prxdis
};
ejesF = {'Lateral(-)/Medial(+) [N]', 'Post(-)/Ant(+) [N]', 'Dist(-)/Prox(+) [N]'};

figure('Name', 'Fuerzas articulares (ejes anatómicos)')
sgtitle('Fuerzas Articulares Netas - Ciclo de Marcha', 'FontSize', 14, 'FontWeight', 'bold')

% Normalización por peso corporal
peso_sujeto = Datos.antropometria.PESO.Valor;                 

for f = 1:size(filas, 1)
    art = filas{f, 1};
    for c = 1:3
        der = filas{f, 2 + (c-1)*2} / peso_sujeto;   % columnas 2,4,6
        izq = filas{f, 3 + (c-1)*2} / peso_sujeto;   % columnas 3,5,7
        subplot(3, 3, (f-1)*3 + c)
        graficarFuerzaArticulares(x, ...
            InterpolaA100Muestras(der(rng_R)), ...
            InterpolaA100Muestras(izq(rng_L)), ...
            x_RTO, x_LTO, ['Fuerza ', art]);
        ylabel(ejesF{c})
    end
end
end

% =========================================================================
%                          Funciones locales
% =========================================================================

function [Fpx, Fpy, Fpz] = calculofuerzas(masa, a, Fdx, Fdy, Fdz)
% F_proximal = m*a - m*g - F_distal, con g = (0,0,-9.81).
% La gravedad entra en Z como (az + 9.81).
Fpx = masa .*  a(:,1)          - Fdx;
Fpy = masa .*  a(:,2)          - Fdy;
Fpz = masa .* (a(:,3) + 9.81)  - Fdz;
end

function a = aceleracion(Datos, seg, lado)
% Aceleración del CM como matriz [n x 3] en coord. globales.
S = Datos.Pasada.AceleracionLineal.(seg).(lado);
a = [S.ax, S.ay, S.az];
end

function [pd, ml, ap] = proyectarAnatomico(F, eje_pd, eje_ml)
% Proyecta F [n x 3] a ejes articulares:
%   pd = prox/distal (eje largo del segmento distal)
%   ml = medio/lateral (eje ML del segmento proximal)
%   ap = ant/post (eje flotante perpendicular a ambos)
pd = dot(F, eje_pd, 2);
ml = dot(F, eje_ml, 2);
eje_ap = cross(eje_ml, eje_pd, 2);
eje_ap = eje_ap ./ vecnorm(eje_ap, 2, 2);
ap = dot(F, eje_ap, 2);
end

function Y = resamplearAGrilla(X, n)
% Remuestrea cada columna de X a n muestras por interpolación lineal.
S = size(X, 1);
if S == n
    Y = X;
    return
end
t_orig = linspace(0, 1, S);
t_new  = linspace(0, 1, n);
Y = interp1(t_orig, X, t_new, 'linear');
end

function Fout = alinearGRF(Fraw, n, iniApoyo, finApoyo)
% Toma el bloque de contacto (no-cero) de la GRF cruda y lo remuestrea para
% que ocupe exactamente [iniApoyo:finApoyo] en una grilla de n muestras de
% marcador, con ceros fuera del apoyo. Así la GRF queda anclada a los eventos.
idx    = find(any(Fraw ~= 0, 2));          % bloque de apoyo en frames crudos
bloque = Fraw(idx(1):idx(end), :);
L      = finApoyo - iniApoyo + 1;          % duración del apoyo en frames de marcador
Fout   = zeros(n, 3);
Fout(iniApoyo:finApoyo, :) = resamplearAGrilla(bloque, L);
end
