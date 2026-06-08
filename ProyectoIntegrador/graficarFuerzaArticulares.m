function graficarFuerzaArticulares(x, F_der, F_izq, x_RTO, x_LTO, titulo)
% Misma estética que graficar.m pero para fuerzas: sin rad2deg, manejo
% robusto de vectores columna, y el ylabel lo define quien la llama.

    F_der = F_der(:);
    F_izq = F_izq(:);

    plot(x, F_der, 'g', 'LineWidth', 2)
    hold on
    plot(x, F_izq, 'r', 'LineWidth', 2)

    % HS
    xline(0, 'k--', 'HS', 'LabelVerticalAlignment', 'bottom')

    % TO
    xline(x_RTO, 'g--', 'LineWidth', 2)
    xline(x_LTO, 'r--', 'LineWidth', 2)

    % Límites eje Y (concatenación VERTICAL para columnas)
    yl = [min([F_der; F_izq]), max([F_der; F_izq])];
    y_text = yl(2) + 0.05*(yl(2) - yl(1));

    text(x_RTO, y_text, 'RTO', 'Color','g','HorizontalAlignment','center')
    text(x_LTO, y_text, 'LTO', 'Color','r','HorizontalAlignment','center')

    ylim([yl(1), y_text])

    title(titulo)
    xlabel('% CM')
    grid on
    hold off
end