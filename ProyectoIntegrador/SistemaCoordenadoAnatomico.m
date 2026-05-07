function Datos = SistemaCoordenadoAnatomico(Datos)

%% Sistema Coordenado Local de la Pelvis
i_pelvis = Datos.Pasada.Vectores.Pelvis.w;
j_pelvis = Datos.Pasada.Vectores.Pelvis.u;
k_pelvis = Datos.Pasada.Vectores.Pelvis.v;

Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.i = i_pelvis;
Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.j = j_pelvis;
Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.k = k_pelvis;

%% Sistema Coordenado Local del Muslo Derecho
i = Datos.Pasada.CentrosArticulares.Cadera.Derecha - Datos.Pasada.CentrosArticulares.Rodilla.Derecha;
i_muslo_derecho = ConvierteVectorAVersor (i);

j = cross ((Datos.Pasada.Marcadores.Valores.r_bar_1 - Datos.Pasada.CentrosArticulares.Cadera.Derecha), ...
           (Datos.Pasada.CentrosArticulares.Rodilla.Derecha - Datos.Pasada.CentrosArticulares.Cadera.Derecha));
j_muslo_derecho = ConvierteVectorAVersor(j);

k_muslo_derecho = cross(i_muslo_derecho, j_muslo_derecho);

Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.i = i_muslo_derecho;
Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.j = j_muslo_derecho;
Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.k = k_muslo_derecho;

%% Sistema Coordenado Local Muslo Izquierdo
i = Datos.Pasada.CentrosArticulares.Cadera.Izquierda - Datos.Pasada.CentrosArticulares.Rodilla.Izquierda;
i_muslo_izquierdo = ConvierteVectorAVersor (i);

j = cross ((Datos.Pasada.CentrosArticulares.Rodilla.Izquierda - Datos.Pasada.CentrosArticulares.Cadera.Izquierda), ...
           (Datos.Pasada.Marcadores.Valores.l_bar_1 - Datos.Pasada.CentrosArticulares.Cadera.Izquierda));
j_muslo_izquierdo = ConvierteVectorAVersor(j);

k_muslo_izquierdo = cross(i_muslo_izquierdo, j_muslo_izquierdo);

Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.i = i_muslo_izquierdo;
Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.j = j_muslo_izquierdo;
Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.k = k_muslo_izquierdo;

%% Sistema Coordenado Local Pierna Derecha
i = Datos.Pasada.CentrosArticulares.Rodilla.Derecha - Datos.Pasada.CentrosArticulares.Tobillo.Derecho;
i_pierna_derecha = ConvierteVectorAVersor(i);

j = cross((Datos.Pasada.Marcadores.Valores.r_knee_1 - Datos.Pasada.CentrosArticulares.Rodilla.Derecha), ...
          (Datos.Pasada.CentrosArticulares.Tobillo.Derecho  - Datos.Pasada.CentrosArticulares.Rodilla.Derecha));
j_pierna_derecha = ConvierteVectorAVersor(j);

k_pierna_derecha = cross(i_pierna_derecha, j_pierna_derecha);

Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.i = i_pierna_derecha;
Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.j = j_pierna_derecha;
Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.k = k_pierna_derecha;

%% Sistema Coordenado Local Pierna Izquierda
i = Datos.Pasada.CentrosArticulares.Rodilla.Izquierda - Datos.Pasada.CentrosArticulares.Tobillo.Izquierdo;
i_pierna_izquierda = ConvierteVectorAVersor(i);

j = cross((Datos.Pasada.CentrosArticulares.Tobillo.Izquierdo - Datos.Pasada.CentrosArticulares.Rodilla.Izquierda), ...
          (Datos.Pasada.Marcadores.Valores.l_knee_1          - Datos.Pasada.CentrosArticulares.Rodilla.Izquierda));
j_pierna_izquierda = ConvierteVectorAVersor(j);

k_pierna_izquierda = cross(i_pierna_izquierda, j_pierna_izquierda);

Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.i = i_pierna_izquierda;
Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.j = j_pierna_izquierda;
Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.k = k_pierna_izquierda;

%% Sistema Coordenado Local Pie Derecho
i = Datos.Pasada.Marcadores.Valores.r_heel - Datos.Pasada.CentrosArticulares.DedoGordo.Derecho;
i_pie_derecho = ConvierteVectorAVersor(i);

k = cross((Datos.Pasada.CentrosArticulares.Tobillo.Derecho   - Datos.Pasada.Marcadores.Valores.r_heel), ...
          (Datos.Pasada.CentrosArticulares.DedoGordo.Derecho - Datos.Pasada.Marcadores.Valores.r_heel));
k_pie_derecho = ConvierteVectorAVersor(k);

j_pie_derecho = cross(k_pie_derecho, i_pie_derecho);

Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.i = i_pie_derecho;
Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.j = j_pie_derecho;
Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.k = k_pie_derecho;

%% Sistema Coordenado Local Pie Izquierdo
i = Datos.Pasada.Marcadores.Valores.l_heel - Datos.Pasada.CentrosArticulares.DedoGordo.Izquierdo;
i_pie_izquierdo = ConvierteVectorAVersor(i);

k = cross((Datos.Pasada.CentrosArticulares.Tobillo.Izquierdo   - Datos.Pasada.Marcadores.Valores.l_heel), ...
          (Datos.Pasada.CentrosArticulares.DedoGordo.Izquierdo - Datos.Pasada.Marcadores.Valores.l_heel));
k_pie_izquierdo = ConvierteVectorAVersor(k);

j_pie_izquierdo = cross(k_pie_izquierdo, i_pie_izquierdo);

Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.i = i_pie_izquierdo;
Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.j = j_pie_izquierdo;
Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.k = k_pie_izquierdo;

%% Graficacion de Sistemas Coordenados Anatomicos
frames = length(i_pelvis);

color_i = 'r';
color_j = 'g';
color_k = 'b';
escala = 0.05;

figure;
hold on;
grid on;
title('Sistemas Coordenados Anatomicos');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');

for nframe = 1:10:frames

    %% --- PELVIS ---
    o = Datos.Pasada.Marcadores.Valores.sacrum(nframe,:);
    quiver3(o(1),o(2),o(3), escala*i_pelvis(nframe,1), escala*i_pelvis(nframe,2), escala*i_pelvis(nframe,3), 0, 'Color',color_i, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*j_pelvis(nframe,1), escala*j_pelvis(nframe,2), escala*j_pelvis(nframe,3), 0, 'Color',color_j, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*k_pelvis(nframe,1), escala*k_pelvis(nframe,2), escala*k_pelvis(nframe,3), 0, 'Color',color_k, 'LineWidth',1);

    %% --- MUSLO DERECHO ---
    o = Datos.Pasada.CentrosArticulares.Cadera.Derecha(nframe,:);
    quiver3(o(1),o(2),o(3), escala*i_muslo_derecho(nframe,1), escala*i_muslo_derecho(nframe,2), escala*i_muslo_derecho(nframe,3), 0, 'Color',color_i, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*j_muslo_derecho(nframe,1), escala*j_muslo_derecho(nframe,2), escala*j_muslo_derecho(nframe,3), 0, 'Color',color_j, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*k_muslo_derecho(nframe,1), escala*k_muslo_derecho(nframe,2), escala*k_muslo_derecho(nframe,3), 0, 'Color',color_k, 'LineWidth',1);

    %% --- MUSLO IZQUIERDO ---
    o = Datos.Pasada.CentrosArticulares.Cadera.Izquierda(nframe,:);
    quiver3(o(1),o(2),o(3), escala*i_muslo_izquierdo(nframe,1), escala*i_muslo_izquierdo(nframe,2), escala*i_muslo_izquierdo(nframe,3), 0, 'Color',color_i, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*j_muslo_izquierdo(nframe,1), escala*j_muslo_izquierdo(nframe,2), escala*j_muslo_izquierdo(nframe,3), 0, 'Color',color_j, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*k_muslo_izquierdo(nframe,1), escala*k_muslo_izquierdo(nframe,2), escala*k_muslo_izquierdo(nframe,3), 0, 'Color',color_k, 'LineWidth',1);

    %% --- PIERNA DERECHA ---
    o = Datos.Pasada.CentrosArticulares.Rodilla.Derecha(nframe,:);
    quiver3(o(1),o(2),o(3), escala*i_pierna_derecha(nframe,1), escala*i_pierna_derecha(nframe,2), escala*i_pierna_derecha(nframe,3), 0, 'Color',color_i, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*j_pierna_derecha(nframe,1), escala*j_pierna_derecha(nframe,2), escala*j_pierna_derecha(nframe,3), 0, 'Color',color_j, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*k_pierna_derecha(nframe,1), escala*k_pierna_derecha(nframe,2), escala*k_pierna_derecha(nframe,3), 0, 'Color',color_k, 'LineWidth',1);

    %% --- PIERNA IZQUIERDA ---
    o = Datos.Pasada.CentrosArticulares.Rodilla.Izquierda(nframe,:);
    quiver3(o(1),o(2),o(3), escala*i_pierna_izquierda(nframe,1), escala*i_pierna_izquierda(nframe,2), escala*i_pierna_izquierda(nframe,3), 0, 'Color',color_i, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*j_pierna_izquierda(nframe,1), escala*j_pierna_izquierda(nframe,2), escala*j_pierna_izquierda(nframe,3), 0, 'Color',color_j, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*k_pierna_izquierda(nframe,1), escala*k_pierna_izquierda(nframe,2), escala*k_pierna_izquierda(nframe,3), 0, 'Color',color_k, 'LineWidth',1);

    %% --- PIE DERECHO ---
    o = Datos.Pasada.CentrosArticulares.Tobillo.Derecho(nframe,:);
    quiver3(o(1),o(2),o(3), escala*i_pie_derecho(nframe,1), escala*i_pie_derecho(nframe,2), escala*i_pie_derecho(nframe,3), 0, 'Color',color_i, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*j_pie_derecho(nframe,1), escala*j_pie_derecho(nframe,2), escala*j_pie_derecho(nframe,3), 0, 'Color',color_j, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*k_pie_derecho(nframe,1), escala*k_pie_derecho(nframe,2), escala*k_pie_derecho(nframe,3), 0, 'Color',color_k, 'LineWidth',1);

    %% --- PIE IZQUIERDO ---
    o = Datos.Pasada.CentrosArticulares.Tobillo.Izquierdo(nframe,:);
    quiver3(o(1),o(2),o(3), escala*i_pie_izquierdo(nframe,1), escala*i_pie_izquierdo(nframe,2), escala*i_pie_izquierdo(nframe,3), 0, 'Color',color_i, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*j_pie_izquierdo(nframe,1), escala*j_pie_izquierdo(nframe,2), escala*j_pie_izquierdo(nframe,3), 0, 'Color',color_j, 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*k_pie_izquierdo(nframe,1), escala*k_pie_izquierdo(nframe,2), escala*k_pie_izquierdo(nframe,3), 0, 'Color',color_k, 'LineWidth',1);

end

% Leyenda
h1 = plot3(nan,nan,nan, '-r', 'LineWidth', 2);
h2 = plot3(nan,nan,nan, '-g', 'LineWidth', 2);
h3 = plot3(nan,nan,nan, '-b', 'LineWidth', 2);
legend([h1 h2 h3], {'i (longitudinal)', 'j (anteroposterior)', 'k (mediolateral)'});
view(3);