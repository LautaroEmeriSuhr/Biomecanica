function graficar(x, y_der, y_izq, x_RTO, x_LTO, titulo)

    % Convertir a grados
    y_der = rad2deg(y_der);
    y_izq = rad2deg(y_izq);

    plot(x, y_der, 'g', 'LineWidth', 2)
    hold on

    plot(x, y_izq, 'r', 'LineWidth', 2)

    % HS
    xline(0,'k--','HS','LabelVerticalAlignment','bottom')

    % TO
    xline(x_RTO,'g--','LineWidth',2)
    xline(x_LTO,'r--','LineWidth',2)

    % Límites eje Y
    yl = [min([y_der y_izq]) max([y_der y_izq])];
    ylim(yl)

    % Texto fuera del gráfico
    y_text = yl(2) + 0.05*(yl(2)-yl(1));

    text(x_RTO, y_text, 'RTO', 'Color','g','HorizontalAlignment','center')
    text(x_LTO, y_text, 'LTO', 'Color','r','HorizontalAlignment','center')

    ylim([yl(1), y_text])

    title(titulo)
    xlabel('% Ciclo de Marcha')
    ylabel('°') 
    grid on

    hold off
end