function Datos = CalculoCinematicaLineal(Datos, dt, fc)
% CALCULOCINEMATICALINEAL  Calcula velocidad y aceleración lineal del CM
% de cada segmento del miembro inferior por derivada discreta centrada,
% en coordenadas GLOBALES.
%
%   Datos = CalculoCinematicaLineal(Datos, dt, fc)
%
% ENTRADAS
%   Datos.Pasada.ParametrosInerciales.<seg>[.<lado>].CoM  [n x 3, m, global]
%   dt  : intervalo de muestreo [s]
%   fc  : frecuencia de corte Butterworth pasa-bajos [Hz] (6 para marcha)
%
% SALIDAS (agregadas a Datos)
%   Datos.Pasada.VelocidadLineal.<seg>[.<lado>].{vx,vy,vz}   [n x 1, m/s]
%   Datos.Pasada.AceleracionLineal.<seg>[.<lado>].{ax,ay,az} [n x 1, m/s²]
%
% PIPELINE  (apunte, secciones 2.3.1 y 2.3.2)
%   (1) CoM en global, ya calculado en CalculoParametrosInerciales
%   (2) Filtrado Butterworth pasa-bajos componente a componente
%   (3) Velocidad por derivada discreta centrada
%   (4) Aceleración por derivada discreta centrada de la velocidad
%
% NOTA: el filtrado se aplica una sola vez sobre la posición. Las dos
% derivadas siguientes no necesitan filtrado adicional porque el ruido
% de alta frecuencia ya está atenuado en la fuente. Filtrar después de
% cada derivada produce un resultado equivalente pero más caro.

%% Configuración del filtro
fs     = 1/dt;
[b, a] = butter(2, fc/(fs/2), 'low');

%% Tabla de segmentos
% Columnas: { nombre del campo en ParametrosInerciales, sufijo der., sufijo izq. }
% Pelvis tiene un solo lado → sufijos vacíos.
segmentos = {
    'Pelvis',  '',          '';
    'Muslo',   'Derecho',   'Izquierdo';
    'Pierna',  'Derecha',   'Izquierda';
    'Pie',     'Derecho',   'Izquierdo'
};

%% Procesamiento
for s = 1:size(segmentos, 1)
    seg = segmentos{s, 1};

    for lado_idx = 2:3
        lado = segmentos{s, lado_idx};

        % ---- (1) Lectura del CoM ya calculado ----
        if isempty(lado)
            if lado_idx == 3, continue; end          % Pelvis: solo una pasada
            CoM = Datos.Pasada.ParametrosInerciales.(seg).CoM;
        else
            CoM = Datos.Pasada.ParametrosInerciales.(seg).(lado).CoM;
        end

        % ---- (2) Filtrado componente a componente ----
        CoM_f = zeros(size(CoM));
        for c = 1:3
            CoM_f(:, c) = filtfilt(b, a, CoM(:, c));
        end

        % ---- (3) Velocidad por derivada discreta centrada ----
        vx = derivadaDiscreta(CoM_f(:, 1), dt);
        vy = derivadaDiscreta(CoM_f(:, 2), dt);
        vz = derivadaDiscreta(CoM_f(:, 3), dt);

        % ---- (4) Aceleración por derivada de la velocidad ----
        ax = derivadaDiscreta(vx, dt);
        ay = derivadaDiscreta(vy, dt);
        az = derivadaDiscreta(vz, dt);

        % ---- (5) Guardado ----
        if isempty(lado)
            Datos.Pasada.VelocidadLineal.(seg).vx = vx;
            Datos.Pasada.VelocidadLineal.(seg).vy = vy;
            Datos.Pasada.VelocidadLineal.(seg).vz = vz;

            Datos.Pasada.AceleracionLineal.(seg).ax = ax;
            Datos.Pasada.AceleracionLineal.(seg).ay = ay;
            Datos.Pasada.AceleracionLineal.(seg).az = az;
        else
            Datos.Pasada.VelocidadLineal.(seg).(lado).vx = vx;
            Datos.Pasada.VelocidadLineal.(seg).(lado).vy = vy;
            Datos.Pasada.VelocidadLineal.(seg).(lado).vz = vz;

            Datos.Pasada.AceleracionLineal.(seg).(lado).ax = ax;
            Datos.Pasada.AceleracionLineal.(seg).(lado).ay = ay;
            Datos.Pasada.AceleracionLineal.(seg).(lado).az = az;
        end
    end
end

%% Preparación: normalización al ciclo de marcha
x = linspace(0, 100, 100);

ciclo_derecho   = Datos.eventos.FrameRHS2 - Datos.eventos.FrameRHS1;
ciclo_izquierdo = Datos.eventos.FrameLHS2 - Datos.eventos.FrameLHS1;

x_RTO = (Datos.eventos.FrameRTO - Datos.eventos.FrameRHS1) / ciclo_derecho   * 100;
x_LTO = (Datos.eventos.FrameLTO - Datos.eventos.FrameLHS1) / ciclo_izquierdo * 100;

rng_R = Datos.eventos.FrameRHS1 : Datos.eventos.FrameRHS2;
rng_L = Datos.eventos.FrameLHS1 : Datos.eventos.FrameLHS2;

%% Tabla de segmentos
% Columnas: { nombre, sufijo derecho, sufijo izquierdo }
% Pelvis es un único segmento → sufijos vacíos.
segmentos = {
    'Pelvis',  '',          '';
    'Muslo',   'Derecho',   'Izquierdo';
    'Pierna',  'Derecha',   'Izquierda';
    'Pie',     'Derecho',   'Izquierdo'
};

% Ajustá los labels según la convención de tu laboratorio.
% Típico Vicon: X = dirección de marcha (AP), Y = ML, Z = vertical.
ejes = {'X (AP)', 'Y (ML)', 'Z (vert.)'};

%% Figura: Velocidad Lineal
componentes = {'vx', 'vy', 'vz'};

figure('Name', 'Velocidades lineales de los segmentos');
sgtitle('Velocidades Lineales del CM - Ciclo de Marcha', ...
        'FontSize', 14, 'FontWeight', 'bold');

for s = 1:size(segmentos, 1)
    seg    = segmentos{s, 1};
    sufDer = segmentos{s, 2};
    sufIzq = segmentos{s, 3};

    for c = 1:length(componentes)
        subplot(4, 3, (s-1)*3 + c);

        [senal_der, senal_izq] = obtenerSenales(Datos, ...
            'VelocidadLineal', seg, sufDer, sufIzq, componentes{c});

        graficar(x, ...
            InterpolaA100Muestras(senal_der(rng_R)), ...
            InterpolaA100Muestras(senal_izq(rng_L)), ...
            x_RTO, x_LTO, ...
            ['Vel ', seg, ' - eje ', ejes{c}]);
        ylabel('m/s')
    end
end

%% Figura: Aceleración Lineal
componentes = {'ax', 'ay', 'az'};

figure('Name', 'Aceleraciones lineales de los segmentos');
sgtitle('Aceleraciones Lineales del CM - Ciclo de Marcha', ...
        'FontSize', 14, 'FontWeight', 'bold');

for s = 1:size(segmentos, 1)
    seg    = segmentos{s, 1};
    sufDer = segmentos{s, 2};
    sufIzq = segmentos{s, 3};

    for c = 1:length(componentes)
        subplot(4, 3, (s-1)*3 + c);

        [senal_der, senal_izq] = obtenerSenales(Datos, ...
            'AceleracionLineal', seg, sufDer, sufIzq, componentes{c});

        graficar(x, ...
            InterpolaA100Muestras(senal_der(rng_R)), ...
            InterpolaA100Muestras(senal_izq(rng_L)), ...
            x_RTO, x_LTO, ...
            ['Acel ', seg, ' - eje ', ejes{c}]);
        ylabel('m/s^2')
    end
end

end

% =========================================================================
%                          Función local
% =========================================================================

function deriv = derivadaDiscreta(senal, dt)
% Derivada discreta por Euler centrado (apunte, sección 2.3.1).
% Idéntica a la versión que ya usás en CalculoCinematicaAngular.
n = length(senal);
deriv = zeros(n, 1);
deriv(1)     = (senal(2)   - senal(1))     / dt;
deriv(n)     = (senal(n)   - senal(n-1))   / dt;
deriv(2:n-1) = (senal(3:n) - senal(1:n-2)) / (2*dt);
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