% Esta función sirve para calcular un vector entre dos puntos, 
% los asis izquierdo y derecho en el espacio 3D y lo grafica. También grafica solapado con ese mismo vector 
% en otro color el vector convertido a versor unitario (1 metro de longitud)  
% asimismo, usando el producto cruz calcula un vector perpendicular a tres
% puntos sacro, asis izquierdo y derecho y de igual forma lo grafica en 3D
% como vector y como versor unitario en otro color se grafica en la misma
% figura. Finalmente calcula un tercer versor perpendicular a los dos
% anteriores lo que daría un sistema de tres versores ortonormles entre sí.
% Este tercer versor se grafica también todo en una misma figura.
% IMPORTANTE: Todo este código es usando "SIN" usar bucles con "for"
% esto requiere dos funciones adicionales para la graficación no se utiliza una función 
% aparte lo que podría resultar conveniente      
% IMPORTANTE2: tener en cuenta que esta escrita con los marcadores
% organizados en una estructura "Datos.Pasada.Marcadores.Crudos.Valores" esto puede
% haber definido usted que sea otra forma de estructura, debe adaptarla
function Datos = SegmentosArticulares(Datos)

%% Colores fijos por versor (definir una vez arriba del todo)
color_u = 'm';   % magenta  → siempre u
color_v = 'b';   % azul     → siempre v
color_w = 'g';   % verde    → siempre w
escala  = 0.05;  % ajustá este valor según la escala de tus datos

figure;
hold on;
grid on;

%% ---- PELVIS ----
frames = length(Datos.Pasada.Marcadores.Valores.sacrum);

v = Datos.Pasada.Marcadores.Valores.l_asis - Datos.Pasada.Marcadores.Valores.r_asis;
vnormalizado = ConvierteVectorAVersor(v);

w = cross(Datos.Pasada.Marcadores.Valores.r_asis - Datos.Pasada.Marcadores.Valores.sacrum, ...
          Datos.Pasada.Marcadores.Valores.l_asis - Datos.Pasada.Marcadores.Valores.sacrum);
wnormalizado = ConvierteVectorAVersor(w);

unormalizado = cross(vnormalizado, wnormalizado);

Origen = Datos.Pasada.Marcadores.Valores.sacrum;

for nframe = 1:10:frames
    o = Origen(nframe,:);
    quiver3(o(1),o(2),o(3), escala*vnormalizado(nframe,1), escala*vnormalizado(nframe,2), escala*vnormalizado(nframe,3), color_v, 'AutoScale','off', 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*wnormalizado(nframe,1), escala*wnormalizado(nframe,2), escala*wnormalizado(nframe,3), color_w, 'AutoScale','off', 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*unormalizado(nframe,1), escala*unormalizado(nframe,2), escala*unormalizado(nframe,3), color_u, 'AutoScale','off', 'LineWidth',1);
end

Datos.Pasada.Vectores.Pelvis.v = vnormalizado;
Datos.Pasada.Vectores.Pelvis.u = unormalizado;
Datos.Pasada.Vectores.Pelvis.w = wnormalizado;

%% ---- PIERNA DERECHA ----
frames = length(Datos.Pasada.Marcadores.Valores.r_knee_1);

v = Datos.Pasada.Marcadores.Valores.r_mall - Datos.Pasada.Marcadores.Valores.r_knee_1;
vnormalizado = ConvierteVectorAVersor(v);

u = cross(Datos.Pasada.Marcadores.Valores.r_bar_1 - Datos.Pasada.Marcadores.Valores.r_knee_1, v);
unormalizado = ConvierteVectorAVersor(u);

w = cross(u, v);
wnormalizado = ConvierteVectorAVersor(w);

Origen = Datos.Pasada.Marcadores.Valores.r_knee_1;
for nframe = 1:10:frames
    o = Origen(nframe,:);
    quiver3(o(1),o(2),o(3), escala*vnormalizado(nframe,1), escala*vnormalizado(nframe,2), escala*vnormalizado(nframe,3), color_v, 'AutoScale','off', 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*wnormalizado(nframe,1), escala*wnormalizado(nframe,2), escala*wnormalizado(nframe,3), color_w, 'AutoScale','off', 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*unormalizado(nframe,1), escala*unormalizado(nframe,2), escala*unormalizado(nframe,3), color_u, 'AutoScale','off', 'LineWidth',1);
end

Datos.Pasada.Vectores.Pierna.Derecha.v = vnormalizado;
Datos.Pasada.Vectores.Pierna.Derecha.u = unormalizado;
Datos.Pasada.Vectores.Pierna.Derecha.w = wnormalizado;

%% ---- PIE DERECHO ----
frames = length(Datos.Pasada.Marcadores.Valores.r_mall);

u = Datos.Pasada.Marcadores.Valores.r_met - Datos.Pasada.Marcadores.Valores.r_heel;
unormalizado = ConvierteVectorAVersor(u);

w = cross((Datos.Pasada.Marcadores.Valores.r_met - Datos.Pasada.Marcadores.Valores.r_mall), ...
          (Datos.Pasada.Marcadores.Valores.r_heel - Datos.Pasada.Marcadores.Valores.r_mall));
wnormalizado = ConvierteVectorAVersor(w);

v = cross(w, u);
vnormalizado = ConvierteVectorAVersor(v);

Origen = Datos.Pasada.Marcadores.Valores.r_mall;
for nframe = 1:10:frames
    o = Origen(nframe,:);
    quiver3(o(1),o(2),o(3), escala*vnormalizado(nframe,1), escala*vnormalizado(nframe,2), escala*vnormalizado(nframe,3), color_v, 'AutoScale','off', 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*wnormalizado(nframe,1), escala*wnormalizado(nframe,2), escala*wnormalizado(nframe,3), color_w, 'AutoScale','off', 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*unormalizado(nframe,1), escala*unormalizado(nframe,2), escala*unormalizado(nframe,3), color_u, 'AutoScale','off', 'LineWidth',1);
end

Datos.Pasada.Vectores.Pie.Derecho.v = vnormalizado;
Datos.Pasada.Vectores.Pie.Derecho.u = unormalizado;
Datos.Pasada.Vectores.Pie.Derecho.w = wnormalizado;

%% ---- PIERNA IZQUIERDA ----
frames = length(Datos.Pasada.Marcadores.Valores.l_knee_1);

v = Datos.Pasada.Marcadores.Valores.l_mall - Datos.Pasada.Marcadores.Valores.l_knee_1;
vnormalizado = ConvierteVectorAVersor(v);

u = cross(v, Datos.Pasada.Marcadores.Valores.l_bar_2 - Datos.Pasada.Marcadores.Valores.l_knee_1);
unormalizado = ConvierteVectorAVersor(u);

w = cross(u, v);
wnormalizado = ConvierteVectorAVersor(w);

Origen = Datos.Pasada.Marcadores.Valores.l_knee_1;
for nframe = 1:10:frames
    o = Origen(nframe,:);
    quiver3(o(1),o(2),o(3), escala*vnormalizado(nframe,1), escala*vnormalizado(nframe,2), escala*vnormalizado(nframe,3), color_v, 'AutoScale','off', 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*wnormalizado(nframe,1), escala*wnormalizado(nframe,2), escala*wnormalizado(nframe,3), color_w, 'AutoScale','off', 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*unormalizado(nframe,1), escala*unormalizado(nframe,2), escala*unormalizado(nframe,3), color_u, 'AutoScale','off', 'LineWidth',1);
end

Datos.Pasada.Vectores.Pierna.Izquierda.v = vnormalizado;
Datos.Pasada.Vectores.Pierna.Izquierda.u = unormalizado;
Datos.Pasada.Vectores.Pierna.Izquierda.w = wnormalizado;

%% ---- PIE IZQUIERDO ----
frames = length(Datos.Pasada.Marcadores.Valores.l_mall);

u = Datos.Pasada.Marcadores.Valores.l_met - Datos.Pasada.Marcadores.Valores.l_heel;
unormalizado = ConvierteVectorAVersor(u);

w = cross(u, Datos.Pasada.Marcadores.Valores.l_heel - Datos.Pasada.Marcadores.Valores.l_mall);
wnormalizado = ConvierteVectorAVersor(w);

v = cross(w, u);
vnormalizado = ConvierteVectorAVersor(v);

Origen = Datos.Pasada.Marcadores.Valores.l_mall;
for nframe = 1:10:frames
    o = Origen(nframe,:);
    quiver3(o(1),o(2),o(3), escala*vnormalizado(nframe,1), escala*vnormalizado(nframe,2), escala*vnormalizado(nframe,3), color_v, 'AutoScale','off', 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*wnormalizado(nframe,1), escala*wnormalizado(nframe,2), escala*wnormalizado(nframe,3), color_w, 'AutoScale','off', 'LineWidth',1);
    quiver3(o(1),o(2),o(3), escala*unormalizado(nframe,1), escala*unormalizado(nframe,2), escala*unormalizado(nframe,3), color_u, 'AutoScale','off', 'LineWidth',1);
end

Datos.Pasada.Vectores.Pie.Izquierdo.v = vnormalizado;
Datos.Pasada.Vectores.Pie.Izquierdo.u = unormalizado;
Datos.Pasada.Vectores.Pie.Izquierdo.w = wnormalizado;

%% Leyenda
legend([plot3(nan,nan,nan,color_u), plot3(nan,nan,nan,color_v), plot3(nan,nan,nan,color_w)], ...
       {'u (mediolateral)', 'v (longitudinal)', 'w (anteroposterior)'});