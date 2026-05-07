%Calculo de Angulos Articulares de Miembros Inferiores
function Datos = CalculoAngulosArticulares(Datos)

%% Cadera Derecha
I_r_hjc = cross(Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.k, Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.i);
I_r_hjc_normalizado =  ConvierteVectorAVersor(I_r_hjc);

% Calculo de Flexión y Extensión (Alpha)
producto_punto = dot(I_r_hjc_normalizado, Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.i, 2);
alpha_r_hjc = asin(producto_punto);
Datos.Pasada.AngulosArticulares.Alpha.Cadera.Derecha = alpha_r_hjc;

% Calculo de Abducción y Aduccion (Beta)
producto_punto = dot(Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.k, Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.i, 2);
beta_r_hjc = asin(producto_punto);
Datos.Pasada.AngulosArticulares.Beta.Cadera.Derecha = beta_r_hjc;

% Calculo de Rotación Interna y Rotación Externa (Gamma)
producto_punto = dot(I_r_hjc_normalizado, Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.k, 2);
gamma_r_hjc = -asin(producto_punto);
Datos.Pasada.AngulosArticulares.Gamma.Cadera.Derecha = gamma_r_hjc;

%% Cadera Izquierda  
I_l_hjc = cross(Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.k, Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.i);
I_l_hjc_normalizado = ConvierteVectorAVersor(I_l_hjc);

% Calculo de Flexión y Extensión (Alpha)
producto_punto = dot(I_l_hjc_normalizado, Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.i, 2);
alpha_l_hjc = asin(producto_punto);
Datos.Pasada.AngulosArticulares.Alpha.Cadera.Izquierda = alpha_l_hjc;

% Calculo de Abducción y Aducción (Beta)
producto_punto = dot(Datos.Pasada.SistemaCoordenadoAnatomico.Pelvis.k, Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.i, 2);
beta_l_hjc = -asin(producto_punto);
Datos.Pasada.AngulosArticulares.Beta.Cadera.Izquierda = beta_l_hjc;

% Calculo de Rotación Interna y Rotación Externa (Gamma)
producto_punto = dot(I_l_hjc_normalizado, Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.k, 2);
gamma_l_hjc = asin(producto_punto);
Datos.Pasada.AngulosArticulares.Gamma.Cadera.Izquierda = gamma_l_hjc;

%% Rodilla Derecha
I_r_kjc = cross(Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.k, Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.i);
I_r_kjc_normalizado = ConvierteVectorAVersor(I_r_kjc);

% Calculo de Flexión y Extensión (Alpha)
producto_punto = dot(I_r_kjc_normalizado, Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.i, 2);
alpha_r_kjc = -asin(producto_punto);
Datos.Pasada.AngulosArticulares.Alpha.Rodilla.Derecha = alpha_r_kjc;

% Calculo Abducción y Aducción (Beta)
producto_punto = dot(Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.k, Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.i, 2);
beta_r_kjc = asin(producto_punto);
Datos.Pasada.AngulosArticulares.Beta.Rodilla.Derecha = beta_r_kjc;

% Calculo Rotación Interna y Rotación Externa (Gamma)
producto_punto = dot(I_r_kjc_normalizado, Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.k, 2);
gamma_r_kjc = -asin(producto_punto);
Datos.Pasada.AngulosArticulares.Gamma.Rodilla.Derecha = gamma_r_kjc;

%% Rodilla Izquierda
I_l_kjc = cross(Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.k, Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.i);
I_l_kjc_normalizado = ConvierteVectorAVersor(I_l_kjc);

% Calculo de Flexión y Extensión (Alpha)
producto_punto = dot(I_l_kjc_normalizado, Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.i, 2);
alpha_l_kjc = -asin(producto_punto);
Datos.Pasada.AngulosArticulares.Alpha.Rodilla.Izquierda = alpha_l_kjc;

% Calculo Abducción y Aducción (Beta)
producto_punto = dot(Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.k, Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.i, 2);
beta_l_kjc = -asin(producto_punto);
Datos.Pasada.AngulosArticulares.Beta.Rodilla.Izquierda = beta_l_kjc;

% Calculo Rotación Interna y Rotación Externa (Gamma)
producto_punto = dot(I_l_kjc_normalizado, Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.k, 2);
gamma_l_kjc = asin(producto_punto);
Datos.Pasada.AngulosArticulares.Gamma.Rodilla.Izquierda = gamma_l_kjc;


%% Tobillo Derecho
I_r_ajc = cross(Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.k, Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.i);
I_r_ajc_normalizado = ConvierteVectorAVersor(I_r_ajc);

% Calculo de Dorsiflexión y Plantarflexión (Alpha)
producto_punto = dot(I_r_ajc_normalizado, Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.j, 2);
alpha_r_ajc = -asin(producto_punto);
Datos.Pasada.AngulosArticulares.Alpha.Tobillo.Derecho = alpha_r_ajc;

% Calculo de Abducción y Aducción (Beta)
producto_punto = dot(Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.k, Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.i, 2);
beta_r_ajc = asin(producto_punto);
Datos.Pasada.AngulosArticulares.Beta.Tobillo.Derecho = beta_r_ajc;

% Calculo de Inversión y Eversión (Gamma)
producto_punto = dot(I_r_ajc_normalizado, Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.k, 2);
gamma_r_ajc = asin(producto_punto);
Datos.Pasada.AngulosArticulares.Gamma.Tobillo.Derecho = gamma_r_ajc;

%% Tobillo Izquierdo
I_l_ajc = cross(Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.k, Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.i);
I_l_ajc_normalizado = ConvierteVectorAVersor(I_l_ajc);

% Calculo de Dorsiflexión y Plantarflexión (Alpha)
producto_punto = dot(I_l_ajc_normalizado, Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.j, 2);
alpha_l_ajc = -asin(producto_punto);
Datos.Pasada.AngulosArticulares.Alpha.Tobillo.Izquierdo = alpha_l_ajc;

% Calculo de Abducción y Aducción (Beta)
producto_punto = dot(Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.k, Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.i, 2);
beta_l_ajc = -asin(producto_punto);
Datos.Pasada.AngulosArticulares.Beta.Tobillo.Izquierdo = beta_l_ajc;

% Calculo de Inversión y Eversión (Gamma)
producto_punto = dot(I_l_ajc_normalizado, Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.k, 2);
gamma_l_ajc = -asin(producto_punto);
Datos.Pasada.AngulosArticulares.Gamma.Tobillo.Izquierdo = gamma_l_ajc;

%% Graficación de Reporte
%% =======================
%% PREPARACIÓN
% Eje normalizado
x = linspace(0,100,100);

% Eventos reales
ciclo_derecho  = Datos.eventos.FrameRHS2 - Datos.eventos.FrameRHS1;
ciclo_izquierdo = Datos.eventos.FrameLHS2 - Datos.eventos.FrameLHS1;

x_RTO = (Datos.eventos.FrameRTO - Datos.eventos.FrameRHS1) / ciclo_derecho * 100;
x_LTO = (Datos.eventos.FrameLTO - Datos.eventos.FrameLHS1) / ciclo_izquierdo * 100;

%% =======================
%% FIGURA COMPLETA

figure
sgtitle('Ángulos Articulares - Ciclo de Marcha','FontSize',14,'FontWeight','bold')

%% ===== CADERA =====

subplot(3,3,1)
graficar(x, ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Alpha.Cadera.Derecha(Datos.eventos.FrameRHS1:Datos.eventos.FrameRHS2)), ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Alpha.Cadera.Izquierda(Datos.eventos.FrameLHS1:Datos.eventos.FrameLHS2)), ...
    x_RTO, x_LTO, 'Cadera Flex/Ext')

subplot(3,3,2)
graficar(x, ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Beta.Cadera.Derecha(Datos.eventos.FrameRHS1:Datos.eventos.FrameRHS2)), ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Beta.Cadera.Izquierda(Datos.eventos.FrameLHS1:Datos.eventos.FrameLHS2)), ...
    x_RTO, x_LTO, 'Cadera Abd/Add')

subplot(3,3,3)
graficar(x, ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Gamma.Cadera.Derecha(Datos.eventos.FrameRHS1:Datos.eventos.FrameRHS2)), ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Gamma.Cadera.Izquierda(Datos.eventos.FrameLHS1:Datos.eventos.FrameLHS2)), ...
    x_RTO, x_LTO, 'Cadera Rotación')

%% ===== RODILLA =====

subplot(3,3,4)
graficar(x, ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Alpha.Rodilla.Derecha(Datos.eventos.FrameRHS1:Datos.eventos.FrameRHS2)), ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Alpha.Rodilla.Izquierda(Datos.eventos.FrameLHS1:Datos.eventos.FrameLHS2)), ...
    x_RTO, x_LTO, 'Rodilla Flex/Ext')

subplot(3,3,5)
graficar(x, ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Beta.Rodilla.Derecha(Datos.eventos.FrameRHS1:Datos.eventos.FrameRHS2)), ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Beta.Rodilla.Izquierda(Datos.eventos.FrameLHS1:Datos.eventos.FrameLHS2)), ...
    x_RTO, x_LTO, 'Rodilla Abd/Add')

subplot(3,3,6)
graficar(x, ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Gamma.Rodilla.Derecha(Datos.eventos.FrameRHS1:Datos.eventos.FrameRHS2)), ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Gamma.Rodilla.Izquierda(Datos.eventos.FrameLHS1:Datos.eventos.FrameLHS2)), ...
    x_RTO, x_LTO, 'Rodilla Rotación')

%% ===== TOBILLO =====

subplot(3,3,7)
graficar(x, ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Alpha.Tobillo.Derecho(Datos.eventos.FrameRHS1:Datos.eventos.FrameRHS2)), ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Alpha.Tobillo.Izquierdo(Datos.eventos.FrameLHS1:Datos.eventos.FrameLHS2)), ...
    x_RTO, x_LTO, 'Tobillo Dorsi/Plantar')

subplot(3,3,8)
graficar(x, ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Beta.Tobillo.Derecho(Datos.eventos.FrameRHS1:Datos.eventos.FrameRHS2)), ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Beta.Tobillo.Izquierdo(Datos.eventos.FrameLHS1:Datos.eventos.FrameLHS2)), ...
    x_RTO, x_LTO, 'Tobillo Abd/Add')

subplot(3,3,9)
graficar(x, ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Gamma.Tobillo.Derecho(Datos.eventos.FrameRHS1:Datos.eventos.FrameRHS2)), ...
    InterpolaA100Muestras(Datos.Pasada.AngulosArticulares.Gamma.Tobillo.Izquierdo(Datos.eventos.FrameLHS1:Datos.eventos.FrameLHS2)), ...
    x_RTO, x_LTO, 'Tobillo Inv/Ever')