function [] = Graficador(Datos)

%% Graficacion: Centros Articulares + Sistemas Coordenados Anatomicos

frames     = length(Datos.Pasada.CentrosArticulares.Cadera.Derecha);
escala_sc  = 0.05;
lw_sc      = 2.0;

% Colores sistemas coordenados
color_i = [0.8 0.0 0.0];   % rojo oscuro
color_j = [0.0 0.5 0.0];   % verde oscuro
color_k = [0.0 0.0 0.8];   % azul oscuro

% Colores centros articulares
color_cadera  = [0.8 0.0 0.8];   % magenta
color_rodilla = [0.0 0.6 0.0];   % verde
color_tobillo = [0.0 0.4 1.0];   % azul
color_dedo    = [1.0 0.5 0.0];   % naranja

figure;
hold on;
grid on;
title('Centros Articulares + Sistemas Coordenados Anatomicos');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');

for nframe = 1:10:frames

    %% ---- CENTROS ARTICULARES ----

    % Cadera
    plot3(Datos.Pasada.CentrosArticulares.Cadera.Derecha(nframe,1),  Datos.Pasada.CentrosArticulares.Cadera.Derecha(nframe,2),  Datos.Pasada.CentrosArticulares.Cadera.Derecha(nframe,3),  'd', 'MarkerSize',7, 'MarkerEdgeColor',color_cadera, 'MarkerFaceColor',color_cadera);
    plot3(Datos.Pasada.CentrosArticulares.Cadera.Izquierda(nframe,1), Datos.Pasada.CentrosArticulares.Cadera.Izquierda(nframe,2), Datos.Pasada.CentrosArticulares.Cadera.Izquierda(nframe,3), 'd', 'MarkerSize',7, 'MarkerEdgeColor',color_cadera, 'MarkerFaceColor','w');

    % Rodilla
    plot3(Datos.Pasada.CentrosArticulares.Rodilla.Derecha(nframe,1),  Datos.Pasada.CentrosArticulares.Rodilla.Derecha(nframe,2),  Datos.Pasada.CentrosArticulares.Rodilla.Derecha(nframe,3),  's', 'MarkerSize',7, 'MarkerEdgeColor',color_rodilla, 'MarkerFaceColor',color_rodilla);
    plot3(Datos.Pasada.CentrosArticulares.Rodilla.Izquierda(nframe,1), Datos.Pasada.CentrosArticulares.Rodilla.Izquierda(nframe,2), Datos.Pasada.CentrosArticulares.Rodilla.Izquierda(nframe,3), 's', 'MarkerSize',7, 'MarkerEdgeColor',color_rodilla, 'MarkerFaceColor','w');

    % Tobillo
    plot3(Datos.Pasada.CentrosArticulares.Tobillo.Derecho(nframe,1),   Datos.Pasada.CentrosArticulares.Tobillo.Derecho(nframe,2),   Datos.Pasada.CentrosArticulares.Tobillo.Derecho(nframe,3),   'o', 'MarkerSize',7, 'MarkerEdgeColor',color_tobillo, 'MarkerFaceColor',color_tobillo);
    plot3(Datos.Pasada.CentrosArticulares.Tobillo.Izquierdo(nframe,1), Datos.Pasada.CentrosArticulares.Tobillo.Izquierdo(nframe,2), Datos.Pasada.CentrosArticulares.Tobillo.Izquierdo(nframe,3), 'o', 'MarkerSize',7, 'MarkerEdgeColor',color_tobillo, 'MarkerFaceColor','w');

    % Dedo gordo
    plot3(Datos.Pasada.CentrosArticulares.DedoGordo.Derecho(nframe,1),   Datos.Pasada.CentrosArticulares.DedoGordo.Derecho(nframe,2),   Datos.Pasada.CentrosArticulares.DedoGordo.Derecho(nframe,3),   '^', 'MarkerSize',7, 'MarkerEdgeColor',color_dedo, 'MarkerFaceColor',color_dedo);
    plot3(Datos.Pasada.CentrosArticulares.DedoGordo.Izquierdo(nframe,1), Datos.Pasada.CentrosArticulares.DedoGordo.Izquierdo(nframe,2), Datos.Pasada.CentrosArticulares.DedoGordo.Izquierdo(nframe,3), '^', 'MarkerSize',7, 'MarkerEdgeColor',color_dedo, 'MarkerFaceColor','w');

    %% ---- SISTEMAS COORDENADOS ANATOMICOS ----

    % Pelvis
    o = Datos.Pasada.Marcadores.Valores.sacrum(nframe,:);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.i(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.i(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.i(nframe,3), 0,'Color',color_i,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.j(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.j(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.j(nframe,3), 0,'Color',color_j,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.k(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.k(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.k(nframe,3), 0,'Color',color_k,'LineWidth',lw_sc);

    % Muslo Derecho
    o = Datos.Pasada.CentrosArticulares.Cadera.Derecha(nframe,:);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.i(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.i(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.i(nframe,3), 0,'Color',color_i,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.j(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.j(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.j(nframe,3), 0,'Color',color_j,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.k(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.k(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.k(nframe,3), 0,'Color',color_k,'LineWidth',lw_sc);

    % Muslo Izquierdo
    o = Datos.Pasada.CentrosArticulares.Cadera.Izquierda(nframe,:);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.i(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.i(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.i(nframe,3), 0,'Color',color_i,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.j(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.j(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.j(nframe,3), 0,'Color',color_j,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.k(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.k(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.k(nframe,3), 0,'Color',color_k,'LineWidth',lw_sc);

    % Pierna Derecha
    o = Datos.Pasada.CentrosArticulares.Rodilla.Derecha(nframe,:);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.i(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.i(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.i(nframe,3), 0,'Color',color_i,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.j(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.j(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.j(nframe,3), 0,'Color',color_j,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.k(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.k(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.k(nframe,3), 0,'Color',color_k,'LineWidth',lw_sc);

    % Pierna Izquierda
    o = Datos.Pasada.CentrosArticulares.Rodilla.Izquierda(nframe,:);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.i(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.i(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.i(nframe,3), 0,'Color',color_i,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.j(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.j(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.j(nframe,3), 0,'Color',color_j,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.k(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.k(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.k(nframe,3), 0,'Color',color_k,'LineWidth',lw_sc);

    % Pie Derecho
    o = Datos.Pasada.CentrosArticulares.Tobillo.Derecho(nframe,:);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.i(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.i(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.i(nframe,3), 0,'Color',color_i,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.j(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.j(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.j(nframe,3), 0,'Color',color_j,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.k(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.k(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.k(nframe,3), 0,'Color',color_k,'LineWidth',lw_sc);

    % Pie Izquierdo
    o = Datos.Pasada.CentrosArticulares.Tobillo.Izquierdo(nframe,:);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.i(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.i(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.i(nframe,3), 0,'Color',color_i,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.j(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.j(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.j(nframe,3), 0,'Color',color_j,'LineWidth',lw_sc);
    quiver3(o(1),o(2),o(3), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.k(nframe,1), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.k(nframe,2), escala_sc*Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.k(nframe,3), 0,'Color',color_k,'LineWidth',lw_sc);

end

%% Leyenda
h1  = plot3(nan,nan,nan,'d',  'MarkerEdgeColor',color_cadera,  'MarkerFaceColor',color_cadera);
h2  = plot3(nan,nan,nan,'d',  'MarkerEdgeColor',color_cadera,  'MarkerFaceColor','w');
h3  = plot3(nan,nan,nan,'s',  'MarkerEdgeColor',color_rodilla, 'MarkerFaceColor',color_rodilla);
h4  = plot3(nan,nan,nan,'s',  'MarkerEdgeColor',color_rodilla, 'MarkerFaceColor','w');
h5  = plot3(nan,nan,nan,'o',  'MarkerEdgeColor',color_tobillo, 'MarkerFaceColor',color_tobillo);
h6  = plot3(nan,nan,nan,'o',  'MarkerEdgeColor',color_tobillo, 'MarkerFaceColor','w');
h7  = plot3(nan,nan,nan,'^',  'MarkerEdgeColor',color_dedo,    'MarkerFaceColor',color_dedo);
h8  = plot3(nan,nan,nan,'^',  'MarkerEdgeColor',color_dedo,    'MarkerFaceColor','w');
h9  = plot3(nan,nan,nan,'-',  'Color',color_i, 'LineWidth',lw_sc);
h10 = plot3(nan,nan,nan,'-',  'Color',color_j, 'LineWidth',lw_sc);
h11 = plot3(nan,nan,nan,'-',  'Color',color_k, 'LineWidth',lw_sc);

legend([h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11], ...
    {'Cadera D', 'Cadera I', 'Rodilla D', 'Rodilla I', ...
     'Tobillo D', 'Tobillo I', 'Dedo D', 'Dedo I', ...
     'SC i', 'SC j', 'SC k'});

view(3);
end