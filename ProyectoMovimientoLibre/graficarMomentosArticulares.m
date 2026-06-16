function graficarMomentosArticulares(x, v_der, v_izq, x_RTO, x_LTO, titulo_grafica)
% GRAFICARMOMENTOSARTICULARES Grafica las curvas de momentos de ambos lados
% superpuestas y añade las líneas verticales de eventos de marcha.

% Graficar lado derecho (Línea Roja Continua)
plot(x, v_der, 'g-', 'LineWidth', 2, 'DisplayName', 'Derecho'); hold on;

% Graficar lado izquierdo (Línea Verde Continua)
plot(x, v_izq, 'r-', 'LineWidth', 2, 'DisplayName', 'Izquierdo');

% Configuración estética del gráfico
title(titulo_grafica, 'FontSize', 10, 'FontWeight', 'bold');
xlabel('% Ciclo de Marcha', 'FontSize', 9);
grid on;
xlim([0 100]);

% Añadir líneas verticales de eventos (Despegue de dedos / Toe-Off)
% Lado Derecho (Línea discontinua roja con etiqueta RTO)
if ~isempty(x_RTO) && ~isnan(x_RTO) && x_RTO > 0 && x_RTO < 100
    xline(x_RTO, '--g', 'RTO', 'LineWidth', 1.2, 'LabelOrientation', 'aligned', 'LabelHorizontalAlignment', 'center');
end

% Lado Izquierdo (Línea discontinua verde con etiqueta LTO)
if ~isempty(x_LTO) && ~isnan(x_LTO) && x_LTO > 0 && x_LTO < 100
    xline(x_LTO, '--r', 'LTO', 'LineWidth', 1.2, 'LabelOrientation', 'aligned', 'LabelHorizontalAlignment', 'center');
end

hold off;
end