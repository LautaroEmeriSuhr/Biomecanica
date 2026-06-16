%% GRAFICARANGULOSEULER  Diagnóstico de los ángulos de Euler por segmento.
%
% Este script grafica los ángulos α, β, γ de cada segmento (muslo, pierna,
% pie) para ambos lados, superpuestos en cada subplot. Sirve para detectar:
%
%   1. Saltos / discontinuidades que generan ruido en la derivada.
%   2. Forma general de cada ángulo (¿tiene sentido biomecánico?).
%   3. Qué método (seno o coseno) eligió la heurística automática.
%
% El método elegido aparece en el título de cada subplot: [der:X | izq:Y].
% Los gráficos están en grados para mejor lectura, pero los datos
% subyacentes están en radianes. Las derivadas se grafican en rad/s.
%
% Pre-requisito: haber ejecutado CalculoCinematicaAngular previamente.

%% Configuración
N_MUESTRAS = 560;   % Número total de muestras en el eje X

segmentos = {
    'Muslo',   'Derecho',  'Izquierdo';
    'Pierna',  'Derecha',  'Izquierda';
    'Pie',     'Derecho',  'Izquierdo'
};
angulos         = {'alfa',  'beta',  'gama'};
nombres_angulos = {'\alpha', '\beta', '\gamma'};
eje_x           = (1:N_MUESTRAS)';   % Vector de frames común para ambas figuras

%% ── FIGURA 1: Ángulos de Euler ──────────────────────────────────────────────
figure('Name', 'Diagnóstico: Ángulos de Euler');
sgtitle('Ángulos de Euler por segmento - Diagnóstico', ...
        'FontSize', 14, 'FontWeight', 'bold');

for s = 1:size(segmentos, 1)
    seg    = segmentos{s, 1};
    sufDer = segmentos{s, 2};
    sufIzq = segmentos{s, 3};

    for a = 1:3
        ang = angulos{a};

        subplot(3, 3, (s-1)*3 + a);

        % Datos en grados (solo para visualización)
        datos_der = rad2deg(Datos.Pasada.AngulosEuler.(seg).(sufDer).(ang));
        datos_izq = rad2deg(Datos.Pasada.AngulosEuler.(seg).(sufIzq).(ang));

        % Recortar o rellenar al tamaño N_MUESTRAS por seguridad
        datos_der = datos_der(1:min(end, N_MUESTRAS));
        datos_izq = datos_izq(1:min(end, N_MUESTRAS));

        plot(eje_x(1:length(datos_der)), datos_der, 'g', 'LineWidth', 1.2);
        hold on;
        plot(eje_x(1:length(datos_izq)), datos_izq, 'r', 'LineWidth', 1.2);
        hold off;

        % Método usado para cada lado
        met_der = Datos.Pasada.AngulosEuler.(seg).(sufDer).metodo.(ang);
        met_izq = Datos.Pasada.AngulosEuler.(seg).(sufIzq).metodo.(ang);

        title(sprintf('%s %s   [der:%s | izq:%s]', ...
                      seg, nombres_angulos{a}, met_der, met_izq));
        xlabel('Frame');
        ylabel('°');
        xlim([1, N_MUESTRAS]);
        grid on;

        if s == 1 && a == 1
            legend('Derecho', 'Izquierdo', 'Location', 'best');
        end
    end
end

%% ── FIGURA 2: Derivadas de los ángulos de Euler ─────────────────────────────
figure('Name', 'Diagnóstico: Derivadas de Ángulos de Euler');
sgtitle('Derivadas de Ángulos de Euler por segmento - Diagnóstico', ...
        'FontSize', 14, 'FontWeight', 'bold');

for s = 1:size(segmentos, 1)
    seg    = segmentos{s, 1};
    sufDer = segmentos{s, 2};
    sufIzq = segmentos{s, 3};

    for a = 1:3
        ang      = angulos{a};
        campo_d  = ['derivada_' ang];   % e.g. 'derivada_alfa'

        subplot(3, 3, (s-1)*3 + a);

        % Recuperar derivadas
        deriv_der = rad2deg(Datos.Pasada.AngulosEuler.(seg).(sufDer).(campo_d));
        deriv_izq = rad2deg(Datos.Pasada.AngulosEuler.(seg).(sufIzq).(campo_d));

        % Recortar al tamaño N_MUESTRAS por seguridad
        deriv_der = deriv_der(1:min(end, N_MUESTRAS));
        deriv_izq = deriv_izq(1:min(end, N_MUESTRAS));

        plot(eje_x(1:length(deriv_der)), deriv_der, 'g', 'LineWidth', 1.2);
        hold on;
        plot(eje_x(1:length(deriv_izq)), deriv_izq, 'r', 'LineWidth', 1.2);
        hold off;

        title(sprintf('d%s/dt  –  %s', nombres_angulos{a}, seg));
        xlabel('Frame');
        ylabel('°/s');
        xlim([1, N_MUESTRAS]);
        grid on;

        if s == 1 && a == 1
            legend('Derecho', 'Izquierdo', 'Location', 'best');
        end
    end
end