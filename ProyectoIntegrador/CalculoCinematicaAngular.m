function Datos = CalculoCinematicaAngular(Datos, dt, fc)
% CALCULOCINEMATICAANGULAR  Calcula los ángulos de Euler, sus derivadas 
% temporales y la velocidad angular en coordenadas LOCALES para los
% segmentos del miembro inferior (muslo, pierna y pie, ambos lados).
%
%   Datos = CalculoCinematicaAngular(Datos, dt, fc)
%
% ENTRADAS
%   Datos : estructura con los versores de cada segmento en
%               Datos.Pasada.SistemaCoordenadoAnatomico.<Seg>.<Lado>.{i,j,k}
%   dt    : intervalo de muestreo en segundos (1/frecuencia de la cámara).
%   fc    : frecuencia de corte del filtro Butterworth pasa-bajos [Hz].
%           Valor típico para marcha: 6 Hz (técnica de Winter).
%
% SALIDAS  (agregadas a la estructura Datos)
%   Datos.Pasada.AngulosEuler.<Seg>.<Lado>.alfa            [n x 1, rad]
%   Datos.Pasada.AngulosEuler.<Seg>.<Lado>.beta            [n x 1, rad]
%   Datos.Pasada.AngulosEuler.<Seg>.<Lado>.gama            [n x 1, rad]
%   Datos.Pasada.AngulosEuler.<Seg>.<Lado>.derivada_alfa   [n x 1, rad/s]
%   Datos.Pasada.AngulosEuler.<Seg>.<Lado>.derivada_beta   [n x 1, rad/s]
%   Datos.Pasada.AngulosEuler.<Seg>.<Lado>.derivada_gama   [n x 1, rad/s]
%   Datos.Pasada.AngulosEuler.<Seg>.<Lado>.metodo.{alfa,beta,gama}
%       'seno' o 'coseno' según la heurística automática.
%   Datos.Pasada.VelocidadAngular.<Seg>.<Lado>.{wx,wy,wz}  [n x 1, rad/s]
%
% PIPELINE para cada segmento/lado:
%   (1) Versores i, j, k del sistema local
%   (2) Ángulos de Euler por arco-seno y arco-coseno (AngulosEuler)
%   (3) Elección automática sen/cos
%   (4) UNWRAP para eliminar saltos discontinuos de ±2π
%   (5) Filtrado Butterworth pasa-bajos (orden 2, doble pasada con filtfilt)
%   (6) Derivada discreta centrada (apunte, sección 2.3.1)
%   (7) Velocidad angular en coordenadas locales (VelocidadAngularSegmento)
%
% NOTAS
%   - Todo trabaja en RADIANES (AngulosEuler usa asin/acos, no asind/acosd).
%   - El paso (4) es CRÍTICO: sin unwrap, un salto de 2π en α o γ produce
%     un pico enorme en su derivada, y el filtro lo convierte en oscilaciones
%     espurias en ωx y ωy (sin afectar ωz, que está dominado por β̇).
%
% Referencia: Apunte de Biomecánica, secciones 2.3.1, 2.4.2 y 2.5.

%% Configuración del filtro Butterworth (orden 4 efectivo con filtfilt)
fs     = 1/dt;
[b, a] = butter(2, fc/(fs/2), 'low');

%% Tabla de segmentos a procesar
% Columnas: { nombre del segmento, sufijo derecho, sufijo izquierdo }
% La inconsistencia Derecho/Izquierdo vs Derecha/Izquierda obliga a tener
% esta tabla en vez de iterar con 'Derecho'/'Izquierdo' fijo.
segmentos = {
    'Muslo',   'Derecho',  'Izquierdo';
    'Pierna',  'Derecha',  'Izquierda';
    'Pie',     'Derecho',  'Izquierdo'
};

%% Procesamiento de cada segmento-lado
for s = 1:size(segmentos, 1)
    seg = segmentos{s, 1};

    for lado_idx = 2:3                      % 2 = derecho, 3 = izquierdo
        lado = segmentos{s, lado_idx};

        % ---- (1) Versores del sistema local del segmento ----
        i = Datos.Pasada.SistemaCoordenadoAnatomico.(seg).(lado).i;
        j = Datos.Pasada.SistemaCoordenadoAnatomico.(seg).(lado).j;
        k = Datos.Pasada.SistemaCoordenadoAnatomico.(seg).(lado).k;

        % ---- (2) Ángulos de Euler con ambas formulaciones ----
        [alfa_sen, alfa_cos, beta_sen, beta_cos, gama_sen, gama_cos] = ...
            AngulosEuler(i, j, k);

        % ---- (3) Elección automática sen/cos ----
        [alfa, met_alfa] = elegirAngulo(alfa_sen, alfa_cos);
        [beta, met_beta] = elegirAngulo(beta_sen, beta_cos);
        [gama, met_gama] = elegirAngulo(gama_sen, gama_cos);

        % ---- (4) UNWRAP para eliminar saltos de ±2π ----
        % unwrap detecta cualquier salto > pi entre muestras consecutivas
        % y lo corrige sumando o restando 2π. Sin esto, el filtfilt convierte
        % los saltos en oscilaciones (efecto Gibbs).
        alfa = unwrap(alfa);
        beta = unwrap(beta);
        gama = unwrap(gama);

        % ---- (5) Filtrado Butterworth pasa-bajos ----
        alfa = filtfilt(b, a, alfa);
        beta = filtfilt(b, a, beta);
        gama = filtfilt(b, a, gama);

        % ---- (6) Derivadas discretas centradas ----
        derivada_alfa = derivadaDiscreta(alfa, dt);
        derivada_beta = derivadaDiscreta(beta, dt);
        derivada_gama = derivadaDiscreta(gama, dt);

        % ---- (7) Velocidad angular en coordenadas locales ----
        [wx, wy, wz] = VelocidadAngularSegmento(alfa, derivada_alfa, ...
                                                beta, derivada_beta, ...
                                                gama, derivada_gama);

        % ---- Guardado en la estructura Datos ----
        Datos.Pasada.AngulosEuler.(seg).(lado).alfa          = alfa;
        Datos.Pasada.AngulosEuler.(seg).(lado).beta          = beta;
        Datos.Pasada.AngulosEuler.(seg).(lado).gama          = gama;
        Datos.Pasada.AngulosEuler.(seg).(lado).derivada_alfa = derivada_alfa;
        Datos.Pasada.AngulosEuler.(seg).(lado).derivada_beta = derivada_beta;
        Datos.Pasada.AngulosEuler.(seg).(lado).derivada_gama = derivada_gama;
        Datos.Pasada.AngulosEuler.(seg).(lado).metodo.alfa   = met_alfa;
        Datos.Pasada.AngulosEuler.(seg).(lado).metodo.beta   = met_beta;
        Datos.Pasada.AngulosEuler.(seg).(lado).metodo.gama   = met_gama;

        Datos.Pasada.VelocidadAngular.(seg).(lado).wx = wx;
        Datos.Pasada.VelocidadAngular.(seg).(lado).wy = wy;
        Datos.Pasada.VelocidadAngular.(seg).(lado).wz = wz;
    end
end
%% Graficacion
%% Preparación
% Eje normalizado al ciclo de marcha
x = linspace(0, 100, 100);
 
% Duración del ciclo de cada lado en frames
ciclo_derecho   = Datos.eventos.FrameRHS2 - Datos.eventos.FrameRHS1;
ciclo_izquierdo = Datos.eventos.FrameLHS2 - Datos.eventos.FrameLHS1;
 
% Toe-off de cada lado, expresado como % del ciclo correspondiente
x_RTO = (Datos.eventos.FrameRTO - Datos.eventos.FrameRHS1) / ciclo_derecho   * 100;
x_LTO = (Datos.eventos.FrameLTO - Datos.eventos.FrameLHS1) / ciclo_izquierdo * 100;
 
% Rangos de frames para recortar cada lado
rng_R = Datos.eventos.FrameRHS1 : Datos.eventos.FrameRHS2;
rng_L = Datos.eventos.FrameLHS1 : Datos.eventos.FrameLHS2;
 
%% Tabla de segmentos y componentes
% Inconsistencia Derecho/Izquierdo vs Derecha/Izquierda → tabla explícita
segmentos = {
    'Muslo',   'Derecho',  'Izquierdo';
    'Pierna',  'Derecha',  'Izquierda';
    'Pie',     'Derecho',  'Izquierdo'
};
componentes = {'wx',     'wy',          'wz'};
ejes        = {'i (AP)', 'j (long.)',   'k (ML)'};
 
%% Figura
figure('Name', 'Velocidades angulares de los segmentos');
sgtitle('Velocidades Angulares de los Segmentos - Ciclo de Marcha', ...
        'FontSize', 14, 'FontWeight', 'bold');
 
for s = 1:size(segmentos, 1)
    seg    = segmentos{s, 1};
    sufDer = segmentos{s, 2};
    sufIzq = segmentos{s, 3};
 
    for c = 1:length(componentes)
        subplot(3, 3, (s-1)*3 + c);
 
        senal_der = Datos.Pasada.VelocidadAngular.(seg).(sufDer).(componentes{c});
        senal_izq = Datos.Pasada.VelocidadAngular.(seg).(sufIzq).(componentes{c});
 
        graficar(x, ...
            InterpolaA100Muestras(senal_der(rng_R)), ...
            InterpolaA100Muestras(senal_izq(rng_L)), ...
            x_RTO, x_LTO, ...
            ['Vel Ang ', seg, ' - versor ', ejes{c}]);
    end
end

end % ===================== fin función principal =========================

% =========================================================================
%                          FUNCIONES LOCALES
% =========================================================================

function [ang, metodo] = elegirAngulo(ang_sen, ang_cos)
% Elige entre la versión con seno y la versión con coseno la que presente
% menos discontinuidades grandes (> π/2) entre muestras consecutivas.
% Devuelve también el nombre del método elegido (para diagnóstico).

umbral     = pi/2;     % radianes (salto considerado discontinuidad)
saltos_sen = sum( abs(diff(ang_sen)) > umbral );
saltos_cos = sum( abs(diff(ang_cos)) > umbral );

if saltos_cos <= saltos_sen
    ang    = ang_cos;
    metodo = 'coseno';
else
    ang    = ang_sen;
    metodo = 'seno';
end

end


function deriv = derivadaDiscreta(senal, dt)
% Derivada discreta por el método de Euler centrado (apunte, sección 2.3.1):
%     v_i = (x_{i+1} - x_{i-1}) / (2·dt)
% En los extremos se usa diferencia hacia adelante/atrás para conservar el
% mismo número de muestras que la señal original.

n = length(senal);
deriv = zeros(n, 1);

% Extremos: diferencia simple
deriv(1) = (senal(2)   - senal(1))     / dt;
deriv(n) = (senal(n)   - senal(n-1))   / dt;

% Interior: diferencia centrada
deriv(2:n-1) = (senal(3:n) - senal(1:n-2)) / (2*dt);

end