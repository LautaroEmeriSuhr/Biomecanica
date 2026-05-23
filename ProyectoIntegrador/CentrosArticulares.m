function Datos = CentrosArticulares(Datos)

%% Centro articular de Caderas (Original de DAVIS)
    Beta2=Datos.Pasada.Marcadores.Valores.l_asis-Datos.Pasada.Marcadores.Valores.r_asis; %Vector de ASIS derecho a Izquierdo
    epy=ConvierteVectorAVersor(Beta2);%divido por norma para convertir el vector a versor
    
    PmedioAsis=(Datos.Pasada.Marcadores.Valores.l_asis+Datos.Pasada.Marcadores.Valores.r_asis).*0.5;
    Beta1= PmedioAsis- Datos.Pasada.Marcadores.Valores.sacrum ; %Vector de ASIS derecho a Izquierdo
    aux=dot(Beta1,epy,2);
    aux1= (epy(:,1)).*(aux);
    aux2= (epy(:,2)).*(aux);
    aux3= (epy(:,3)).*(aux);
    aux= [aux1 aux2 aux3];
    Beta3= Beta1 - aux;
    epx=ConvierteVectorAVersor(Beta3);%divido por norma para convertir el vector a versor
    epz=cross(epx,epy);%versor 2×3-->1  ;-)
    epz=ConvierteVectorAVersor(epz);%divido por norma para convertir el vector a versor
    
    %productoPunto=dot(epx,epy,2);
       
    TitaDavis=28.4*pi/180; %ángulo de inclinación promedio de 25 sujeto en el plano frontal= 28,4°
    BetaDavis=18*pi/180; %ángulo de inclinación promedio de 25 sujeto en el plano frontal= 8°
    
    LONGITUD_PIERNA_DERECHA = Datos.antropometria.LONGITUD_PIERNA_DERECHA.Valor / 100;
    LONGITUD_PIERNA_IZQUIERDA = Datos.antropometria.LONGITUD_PIERNA_IZQUIERDA.Valor / 100;

    C=0.115*(LONGITUD_PIERNA_DERECHA+LONGITUD_PIERNA_IZQUIERDA)*0.5-0.0153;

    PROFUNDIDAD_PELVIS = Datos.antropometria.PROFUNDIDAD_PELVIS.Valor / 100;
    XH = (-PROFUNDIDAD_PELVIS)*cos(BetaDavis)+C*cos(TitaDavis)*sin(BetaDavis);

    LONGITUD_ASIS = Datos.antropometria.LONGITUD_ASIS.Valor / 100;
    YH = C*sin(TitaDavis)-LONGITUD_ASIS/2;

    ZH = (-PROFUNDIDAD_PELVIS)*sin(BetaDavis)-C*cos(TitaDavis)*cos(BetaDavis);
    p_cadera_derecha = PmedioAsis + epx.*XH + epy.*YH + epz.*ZH; %me desplazo desde el punto medio de los ASIS direcciones de epx, epy y epz un porcentaje del ancho de la pelvis (de ASIS a ASIS) y profundifad de pelvis;
    p_cadera_izquierda = PmedioAsis + epx.*XH - epy.*YH + epz.*ZH; %me desplazo desde el punto medio de los ASIS direcciones de epx, epy y epz un porcentaje del ancho de la pelvis (de ASIS a ASIS) y profundifad de pelvis;

    Datos.Pasada.CentrosArticulares.Cadera.Derecha   = p_cadera_derecha;
    Datos.Pasada.CentrosArticulares.Cadera.Izquierda = p_cadera_izquierda;
%% Centro Articular Rodilla Derecha

p_rodilla_derecha = Datos.Pasada.Marcadores.Valores.r_knee_1 ...
                  + 0.000 * Datos.Pasada.Vectores.Pierna.Derecha.u ...
                  + 0.000 * Datos.Pasada.Vectores.Pierna.Derecha.v ...
                  + 0.500 * Datos.antropometria.DIAMETRO_RODILLA_DERECHA.Valor/100 * Datos.Pasada.Vectores.Pierna.Derecha.w;

Datos.Pasada.CentrosArticulares.Rodilla.Derecha = p_rodilla_derecha;

%% Centro Articular Rodilla Izquierda

p_rodilla_izquierda = Datos.Pasada.Marcadores.Valores.l_knee_1 ...
                    + 0.000 * Datos.Pasada.Vectores.Pierna.Izquierda.u ...
                    + 0.000 * Datos.Pasada.Vectores.Pierna.Izquierda.v ...
                    - 0.500 * Datos.antropometria.DIAMETRO_RODILLA_IZQUIERDA.Valor/100 * Datos.Pasada.Vectores.Pierna.Izquierda.w;

Datos.Pasada.CentrosArticulares.Rodilla.Izquierda = p_rodilla_izquierda;

%% Centro Articular Tobillo Derecho

p_tobillo_derecho = Datos.Pasada.Marcadores.Valores.r_mall ...
                + 0.016 * Datos.antropometria.LONGITUD_PIE_DERECHO.Valor/100    * Datos.Pasada.Vectores.Pie.Derecho.u ...
                + 0.392 * Datos.antropometria.ALTURA_MALEOLOS_DERECHO.Valor/100 * Datos.Pasada.Vectores.Pie.Derecho.v ...
                + 0.478 * Datos.antropometria.ANCHO_MALEOLOS_DERECHO.Valor/100  * Datos.Pasada.Vectores.Pie.Derecho.w;

Datos.Pasada.CentrosArticulares.Tobillo.Derecho = p_tobillo_derecho;

%% Centro Articular Tobillo Izquierdo

p_tobillo_izquierdo = Datos.Pasada.Marcadores.Valores.l_mall ...
                  + 0.016 * Datos.antropometria.LONGITUD_PIE_IZQUIERDO.Valor/100    * Datos.Pasada.Vectores.Pie.Izquierdo.u ...
                  + 0.392 * Datos.antropometria.ALTURA_MALEOLOS_IZQUIERDO.Valor/100 * Datos.Pasada.Vectores.Pie.Izquierdo.v ...
                  - 0.478 * Datos.antropometria.ANCHO_MALEOLOS_IZQUIERDO.Valor/100  * Datos.Pasada.Vectores.Pie.Izquierdo.w;

Datos.Pasada.CentrosArticulares.Tobillo.Izquierdo = p_tobillo_izquierdo;

%% Centro Articular Dedo Gordo Derecho

p_dedo_gordo_derecho = Datos.Pasada.Marcadores.Valores.r_mall ...
                     + 0.742 * (Datos.antropometria.LONGITUD_PIE_DERECHO.Valor/100)    * Datos.Pasada.Vectores.Pie.Derecho.u ... 
                     + 1.074 * (Datos.antropometria.ALTURA_MALEOLOS_DERECHO.Valor/100) * Datos.Pasada.Vectores.Pie.Derecho.v ...
                     - 0.187 * (Datos.antropometria.ANCHO_PIE_DERECHO.Valor/100)       * Datos.Pasada.Vectores.Pie.Derecho.w;

Datos.Pasada.CentrosArticulares.DedoGordo.Derecho = p_dedo_gordo_derecho;

%% Centro Articular Dedo Gordo Izquierdo 

p_dedo_gordo_izquierdo = Datos.Pasada.Marcadores.Valores.l_mall ...
                     + 0.742 * (Datos.antropometria.LONGITUD_PIE_IZQUIERDO.Valor/100)    * Datos.Pasada.Vectores.Pie.Izquierdo.u ... 
                     + 1.074 * (Datos.antropometria.ALTURA_MALEOLOS_IZQUIERDO.Valor/100) * Datos.Pasada.Vectores.Pie.Izquierdo.v ...
                     + 0.187 * (Datos.antropometria.ANCHO_PIE_IZQUIERDO.Valor/100)       * Datos.Pasada.Vectores.Pie.Izquierdo.w;
    
Datos.Pasada.CentrosArticulares.DedoGordo.Izquierdo = p_dedo_gordo_izquierdo;

%% Graficacion de centros articulares + marcadores de verificacion
frames = length(p_rodilla_derecha);
figure;
hold on;
grid on;
title('Centros Articulares + Marcadores - Miembro Inferior');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');

% Colores por articulacion
color_cadera  = [0.8 0.0 0.8];   % magenta
color_rodilla = [0.0 0.6 0.0];   % verde
color_tobillo = [0.0 0.4 1.0];   % azul
color_dedo    = [1.0 0.5 0.0];   % naranja

for nframe = 1:10:frames

    %% ---- MARCADORES CRUDOS (cruz x, mismo color que su CA) ----

    % Pelvis → cadera
    plot3(Datos.Pasada.Marcadores.Valores.r_asis(nframe,1), Datos.Pasada.Marcadores.Valores.r_asis(nframe,2), Datos.Pasada.Marcadores.Valores.r_asis(nframe,3), 'x', 'MarkerSize',6, 'Color',color_cadera, 'LineWidth',1.5);
    plot3(Datos.Pasada.Marcadores.Valores.l_asis(nframe,1), Datos.Pasada.Marcadores.Valores.l_asis(nframe,2), Datos.Pasada.Marcadores.Valores.l_asis(nframe,3), 'x', 'MarkerSize',6, 'Color',color_cadera, 'LineWidth',1.5);

    % Epicóndilo → rodilla
    plot3(Datos.Pasada.Marcadores.Valores.r_knee_1(nframe,1), Datos.Pasada.Marcadores.Valores.r_knee_1(nframe,2), Datos.Pasada.Marcadores.Valores.r_knee_1(nframe,3), 'x', 'MarkerSize',6, 'Color',color_rodilla, 'LineWidth',1.5);
    plot3(Datos.Pasada.Marcadores.Valores.l_knee_1(nframe,1), Datos.Pasada.Marcadores.Valores.l_knee_1(nframe,2), Datos.Pasada.Marcadores.Valores.l_knee_1(nframe,3), 'x', 'MarkerSize',6, 'Color',color_rodilla, 'LineWidth',1.5);

    % Maléolo → tobillo
    plot3(Datos.Pasada.Marcadores.Valores.r_mall(nframe,1), Datos.Pasada.Marcadores.Valores.r_mall(nframe,2), Datos.Pasada.Marcadores.Valores.r_mall(nframe,3), 'x', 'MarkerSize',6, 'Color',color_tobillo, 'LineWidth',1.5);
    plot3(Datos.Pasada.Marcadores.Valores.l_mall(nframe,1), Datos.Pasada.Marcadores.Valores.l_mall(nframe,2), Datos.Pasada.Marcadores.Valores.l_mall(nframe,3), 'x', 'MarkerSize',6, 'Color',color_tobillo, 'LineWidth',1.5);

    % Metatarso → dedo gordo
    plot3(Datos.Pasada.Marcadores.Valores.r_met(nframe,1), Datos.Pasada.Marcadores.Valores.r_met(nframe,2), Datos.Pasada.Marcadores.Valores.r_met(nframe,3), 'x', 'MarkerSize',6, 'Color',color_dedo, 'LineWidth',1.5);
    plot3(Datos.Pasada.Marcadores.Valores.l_met(nframe,1), Datos.Pasada.Marcadores.Valores.l_met(nframe,2), Datos.Pasada.Marcadores.Valores.l_met(nframe,3), 'x', 'MarkerSize',6, 'Color',color_dedo, 'LineWidth',1.5);

   %% ---- CENTROS ARTICULARES ----

    % Cadera (diamante ◆)
    plot3(p_cadera_derecha(nframe,1),   p_cadera_derecha(nframe,2),   p_cadera_derecha(nframe,3),   'd', 'MarkerSize',7, 'MarkerEdgeColor',color_cadera, 'MarkerFaceColor',color_cadera);
    plot3(p_cadera_izquierda(nframe,1), p_cadera_izquierda(nframe,2), p_cadera_izquierda(nframe,3), 'd', 'MarkerSize',7, 'MarkerEdgeColor',color_cadera, 'MarkerFaceColor','w');

    % Rodilla (cuadrado ■)
    plot3(p_rodilla_derecha(nframe,1),   p_rodilla_derecha(nframe,2),   p_rodilla_derecha(nframe,3),   's', 'MarkerSize',7, 'MarkerEdgeColor',color_rodilla, 'MarkerFaceColor',color_rodilla);
    plot3(p_rodilla_izquierda(nframe,1), p_rodilla_izquierda(nframe,2), p_rodilla_izquierda(nframe,3), 's', 'MarkerSize',7, 'MarkerEdgeColor',color_rodilla, 'MarkerFaceColor','w');

    % Tobillo (circulo ●)
    plot3(p_tobillo_derecho(nframe,1),   p_tobillo_derecho(nframe,2),   p_tobillo_derecho(nframe,3),   'o', 'MarkerSize',7, 'MarkerEdgeColor',color_tobillo, 'MarkerFaceColor',color_tobillo);
    plot3(p_tobillo_izquierdo(nframe,1), p_tobillo_izquierdo(nframe,2), p_tobillo_izquierdo(nframe,3), 'o', 'MarkerSize',7, 'MarkerEdgeColor',color_tobillo, 'MarkerFaceColor','w');

    % Dedo gordo (triangulo ▲)
    plot3(p_dedo_gordo_derecho(nframe,1),   p_dedo_gordo_derecho(nframe,2),   p_dedo_gordo_derecho(nframe,3),   '^', 'MarkerSize',7, 'MarkerEdgeColor',color_dedo, 'MarkerFaceColor',color_dedo);
    plot3(p_dedo_gordo_izquierdo(nframe,1), p_dedo_gordo_izquierdo(nframe,2), p_dedo_gordo_izquierdo(nframe,3), '^', 'MarkerSize',7, 'MarkerEdgeColor',color_dedo, 'MarkerFaceColor','w');

end

%% Verificacion de distancias CA - Marcador
fprintf('\n=== DISTANCIAS PROMEDIO CA - MARCADOR ===\n');

% Tobillo Derecho (CA vs r_mall)
d = sqrt(sum((p_tobillo_derecho - Datos.Pasada.Marcadores.Valores.r_mall).^2, 2));
fprintf('Tobillo Derecho:   media=%.1f mm,  min=%.1f mm,  max=%.1f mm\n', mean(d)*1000, min(d)*1000, max(d)*1000);

% Tobillo Izquierdo (CA vs l_mall)
d = sqrt(sum((p_tobillo_izquierdo - Datos.Pasada.Marcadores.Valores.l_mall).^2, 2));
fprintf('Tobillo Izquierdo: media=%.1f mm,  min=%.1f mm,  max=%.1f mm\n', mean(d)*1000, min(d)*1000, max(d)*1000);

% Dedo Gordo Derecho (CA vs r_met)
d = sqrt(sum((p_dedo_gordo_derecho - Datos.Pasada.Marcadores.Valores.r_met).^2, 2));
fprintf('Dedo Gordo Derecho:   media=%.1f mm,  min=%.1f mm,  max=%.1f mm\n', mean(d)*1000, min(d)*1000, max(d)*1000);

% Dedo Gordo Izquierdo (CA vs l_met)
d = sqrt(sum((p_dedo_gordo_izquierdo - Datos.Pasada.Marcadores.Valores.l_met).^2, 2));
fprintf('Dedo Gordo Izquierdo: media=%.1f mm,  min=%.1f mm,  max=%.1f mm\n', mean(d)*1000, min(d)*1000, max(d)*1000);

% Rodilla Derecha (CA vs r_knee_1)
d = sqrt(sum((p_rodilla_derecha - Datos.Pasada.Marcadores.Valores.r_knee_1).^2, 2));
fprintf('Rodilla Derecha:   media=%.1f mm,  min=%.1f mm,  max=%.1f mm\n', mean(d)*1000, min(d)*1000, max(d)*1000);

% Rodilla Izquierda (CA vs l_knee_1)
d = sqrt(sum((p_rodilla_izquierda - Datos.Pasada.Marcadores.Valores.l_knee_1).^2, 2));
fprintf('Rodilla Izquierda: media=%.1f mm,  min=%.1f mm,  max=%.1f mm\n', mean(d)*1000, min(d)*1000, max(d)*1000);

%% Leyenda
h1 = plot3(nan,nan,nan,'x',  'Color',color_cadera,  'LineWidth',1.5);
h2 = plot3(nan,nan,nan,'-',  'Color',color_cadera,  'LineWidth',2);
h3 = plot3(nan,nan,nan,'x',  'Color',color_rodilla, 'LineWidth',1.5);
h4 = plot3(nan,nan,nan,'-',  'Color',color_rodilla, 'LineWidth',2);
h5 = plot3(nan,nan,nan,'x',  'Color',color_tobillo, 'LineWidth',1.5);
h6 = plot3(nan,nan,nan,'-',  'Color',color_tobillo, 'LineWidth',2);
h7 = plot3(nan,nan,nan,'x',  'Color',color_dedo,    'LineWidth',1.5);
h8 = plot3(nan,nan,nan,'-',  'Color',color_dedo,    'LineWidth',2);

legend([h1 h2 h3 h4 h5 h6 h7 h8], ...
    {'Marcador Cadera',  'CA Cadera', ...
     'Marcador Rodilla', 'CA Rodilla', ...
     'Marcador Tobillo', 'CA Tobillo', ...
     'Marcador Dedo',    'CA Dedo'});

view(3);