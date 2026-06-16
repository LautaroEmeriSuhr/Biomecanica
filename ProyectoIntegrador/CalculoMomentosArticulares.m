function Datos = CalculoMomentosArticulares(Datos)
% CALCULOMOMENTOSRESIDUALES  Momento residual de cada segmento del miembro
% inferior (pie, pierna, muslo), TEMA 16:
%
%   M_RES = (r_D x F_D) + (r_P x F_P) + (r_A x F_A) + M_A   [coord. GLOBALES]
%
% con r_* = (punto de aplicacion) - (CoM del segmento), en metros y globales.
% Luego se rota a locales por producto punto con los versores anatomicos
% (slide "Cambio de Base de Global a Local"), que es lo que alimenta M_P.
%
% Numeracion apunte: 1 MusloD 2 MusloI 3 PiernaD 4 PiernaI 5 PieD 6 PieI
%

[Datos,HayNAN,QueMarcaEsNAN,Nombres] = VerificarNAN(Datos)

% ---------------------------------------------------------------------
% PIE DERECHO  (segmento 5)   F_D = 0 ; F_A = GRF ; M_A = [0 0 Tz]
% ---------------------------------------------------------------------
n = length(Datos.Pasada.AceleracionLineal.Pie.Derecho.ax);   % 560

CoM_pie_D = Datos.Pasada.ParametrosInerciales.Pie.Derecho.CoM;     % [n x 3] m

% Fuerza PROXIMAL del pie = fuerza de tobillo, ya calculada (global)
F_tobillo_D = [Datos.Pasada.FuerzasArticulares.Tobillo.Derecho.Fx, ...
               Datos.Pasada.FuerzasArticulares.Tobillo.Derecho.Fy, ...
               Datos.Pasada.FuerzasArticulares.Tobillo.Derecho.Fz];

% --- GRF: reuso la YA alineada en CalculoFuerzasArticulares ---
F_plataforma_derecha = Datos.Pasada.GRF.Derecha;     % [n x 3] N

% --- Free moment: MISMO anclaje que la GRF, sobre el Mz CRUDO de plataforma ---
%     alinearMomento es el gemelo escalar de alinearGRF.
Mz_der = alinearMomento(Datos.Pasada.Fuerzas.Plataforma1.Valores.Mz1, ...
                        n, Datos.eventos.FrameRHS1, Datos.eventos.FrameRTO) / 1000;  % N·mm -> N·m

M_plataforma_d = [zeros(n,2), Mz_der];               % Tz = [0 0 Mz]   [n x 3]

CP1x = alinearMomento(Datos.Pasada.Fuerzas.Plataforma1.Valores.CP1x, ...
                      n , Datos.eventos.FrameRHS1, Datos.eventos.FrameRTO);

CP1y = alinearMomento(Datos.Pasada.Fuerzas.Plataforma1.Valores.CP1y, ...
                      n , Datos.eventos.FrameRHS1, Datos.eventos.FrameRTO);

CentroPresionDerecho = [CP1x CP1y zeros(n,1)];

% Brazos de momento (desde el CoM del pie)
rProx_pie_D = Datos.Pasada.CentrosArticulares.Tobillo.Derecho - CoM_pie_D;
rDis_pie_D  = CentroPresionDerecho - CoM_pie_D;

% Momento residual del pie en GLOBAL  (M_Res.5)
MR_pie_D = M_plataforma_d ...
         + cross(rProx_pie_D, F_tobillo_D,          2) ...
         + cross(rDis_pie_D,  F_plataforma_derecha, 2);

% Versores anatomicos del pie
i_pie_D = Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.i;
j_pie_D = Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.j;
k_pie_D = Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Derecho.k;

% Residual rotado a LOCAL:  i5·MRes , j5·MRes , k5·MRes
MR_pie_D_local = [dot(MR_pie_D, i_pie_D, 2), ...
                  dot(MR_pie_D, j_pie_D, 2), ...
                  dot(MR_pie_D, k_pie_D, 2)];

% Momento NETO del tobillo (M_R.Ankle) = dH/dt_local - MRes_local
dHdt_pie_D = [Datos.Pasada.DerivadaCantidadMovimientoAngular.Pie.Derecho.dHx_dt, ...
              Datos.Pasada.DerivadaCantidadMovimientoAngular.Pie.Derecho.dHy_dt, ...
              Datos.Pasada.DerivadaCantidadMovimientoAngular.Pie.Derecho.dHz_dt];

M_tobillo_D_local = dHdt_pie_D - MR_pie_D_local;

M_tobillo_D_global = M_tobillo_D_local(:,1) .* i_pie_D ...
                   + M_tobillo_D_local(:,2) .* j_pie_D ...
                   + M_tobillo_D_local(:,3) .* k_pie_D;

% ---------------------------------------------------------------------
% PIERNA DERECHA  (segmento 3)   F_D = -F_tobillo ; F_A = 0 ; M_A = 0
% ---------------------------------------------------------------------
CoM_pierna_D = Datos.Pasada.ParametrosInerciales.Pierna.Derecha.CoM;   % [n x 3] m, global

% Fuerza PROXIMAL de la pierna = fuerza de RODILLA, ya calculada (global)
F_rodilla_D = [Datos.Pasada.FuerzasArticulares.Rodilla.Derecha.Fx, ...
               Datos.Pasada.FuerzasArticulares.Rodilla.Derecha.Fy, ...
               Datos.Pasada.FuerzasArticulares.Rodilla.Derecha.Fz];

% Brazos de momento (desde el CoM de la pierna)
rP_pierna_D = Datos.Pasada.CentrosArticulares.Rodilla.Derecha - CoM_pierna_D;  
rD_pierna_D = Datos.Pasada.CentrosArticulares.Tobillo.Derecho - CoM_pierna_D;  

% Momento residual de la pierna en GLOBAL  (M_Res.3 = solo terminos de fuerza)
MR_pierna_D = - M_tobillo_D_global ... 
              - cross(rD_pierna_D, F_tobillo_D, 2) ...
              + cross(rP_pierna_D, F_rodilla_D, 2);

% Versores anatomicos de la pierna
i_pierna_D = Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.i;
j_pierna_D = Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.j;
k_pierna_D = Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Derecha.k;


% Residual rotado a LOCAL:  i3·MRes , j3·MRes , k3·MRes
MR_pierna_D_local = [dot(MR_pierna_D, i_pierna_D, 2), ...
                     dot(MR_pierna_D, j_pierna_D, 2), ...
                     dot(MR_pierna_D, k_pierna_D, 2)];

% dH/dt de la pierna (LOCAL)
dHdt_pierna_D = [Datos.Pasada.DerivadaCantidadMovimientoAngular.Pierna.Derecha.dHx_dt, ...
                 Datos.Pasada.DerivadaCantidadMovimientoAngular.Pierna.Derecha.dHy_dt, ...
                 Datos.Pasada.DerivadaCantidadMovimientoAngular.Pierna.Derecha.dHz_dt];

% Momento NETO de RODILLA (M_R.Knee) = dH/dt_local - M_D_local - MRes_local
M_rodilla_D_local = dHdt_pierna_D - MR_pierna_D_local;

M_rodilla_D_global = M_rodilla_D_local(:,1) .* i_pierna_D ...
                   + M_rodilla_D_local(:,2) .* j_pierna_D ...
                   + M_rodilla_D_local(:,3) .* k_pierna_D;

% ---------------------------------------------------------------------
% MUSLO DERECHO  (segmento 1)   F_D = -F_rodilla ; F_A = 0 ; M_A = 0
% ---------------------------------------------------------------------
CoM_muslo_D = Datos.Pasada.ParametrosInerciales.Muslo.Derecho.CoM;     % [n x 3] m, global

% Fuerza PROXIMAL del muslo = fuerza de CADERA, ya calculada (global)
F_cadera_D = [Datos.Pasada.FuerzasArticulares.Cadera.Derecha.Fx, ...
              Datos.Pasada.FuerzasArticulares.Cadera.Derecha.Fy, ...
              Datos.Pasada.FuerzasArticulares.Cadera.Derecha.Fz];

% Brazos de momento (desde el CoM del muslo)
rP_muslo_D = Datos.Pasada.CentrosArticulares.Cadera.Derecha  - CoM_muslo_D;  
rD_muslo_D = Datos.Pasada.CentrosArticulares.Rodilla.Derecha - CoM_muslo_D;  

% Momento residual del muslo en GLOBAL  (M_Res.1)
MR_cadera_D_global = - M_rodilla_D_global ... 
                    - cross(rD_muslo_D, F_rodilla_D, 2) ...
                    + cross(rP_muslo_D, F_cadera_D,  2);

% Versores anatomicos del muslo
i_muslo_D = Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.i;
j_muslo_D = Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.j;
k_muslo_D = Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Derecho.k;

% Residual rotado a LOCAL:  i3·MRes , j3·MRes , k3·MRes
MR_cadera_D_local = [dot(MR_cadera_D_global, i_muslo_D, 2), ...
                     dot(MR_cadera_D_global, j_muslo_D, 2), ...
                     dot(MR_cadera_D_global, k_muslo_D, 2)];


% dH/dt del muslo (LOCAL)
dHdt_muslo_D = [Datos.Pasada.DerivadaCantidadMovimientoAngular.Muslo.Derecho.dHx_dt, ...
                Datos.Pasada.DerivadaCantidadMovimientoAngular.Muslo.Derecho.dHy_dt, ...
                Datos.Pasada.DerivadaCantidadMovimientoAngular.Muslo.Derecho.dHz_dt];

% Momento NETO de CADERA (M_R.Hip) = dH/dt_local - MRes_local
M_cadera_D_local = dHdt_muslo_D - MR_cadera_D_local;

M_cadera_D_global = M_cadera_D_local(:,1) .* i_muslo_D ...
                  + M_cadera_D_local(:,2) .* j_muslo_D ...
                  + M_cadera_D_local(:,3) .* k_muslo_D;

% % =====================================================================
% % GUARDAR LADO DERECHO
% % =====================================================================
Datos.Pasada.MomentosArticulares.Tobillo.Derecho.Mx = M_tobillo_D_global(:,1);
Datos.Pasada.MomentosArticulares.Tobillo.Derecho.My = M_tobillo_D_global(:,2);
Datos.Pasada.MomentosArticulares.Tobillo.Derecho.Mz = M_tobillo_D_global(:,3);

Datos.Pasada.MomentosArticulares.Rodilla.Derecha.Mx = M_rodilla_D_global(:,1);
Datos.Pasada.MomentosArticulares.Rodilla.Derecha.My = M_rodilla_D_global(:,2);
Datos.Pasada.MomentosArticulares.Rodilla.Derecha.Mz = M_rodilla_D_global(:,3);

Datos.Pasada.MomentosArticulares.Cadera.Derecha.Mx  = M_cadera_D_global(:,1);
Datos.Pasada.MomentosArticulares.Cadera.Derecha.My  = M_cadera_D_global(:,2);
Datos.Pasada.MomentosArticulares.Cadera.Derecha.Mz  = M_cadera_D_global(:,3);

% % =====================================================================
% % PIE IZQUIERDO  (segmento 6)   F_D = 0 ; F_A = GRF ; M_A = [0 0 Tz]
% % =====================================================================
n = length(Datos.Pasada.AceleracionLineal.Pie.Izquierdo.ax);   % 560

CoM_pie_I = Datos.Pasada.ParametrosInerciales.Pie.Izquierdo.CoM;     % [n x 3] m

% Fuerza PROXIMAL del pie = fuerza de tobillo, ya calculada (global)
F_tobillo_I = [Datos.Pasada.FuerzasArticulares.Tobillo.Izquierdo.Fx, ...
               Datos.Pasada.FuerzasArticulares.Tobillo.Izquierdo.Fy, ...
               Datos.Pasada.FuerzasArticulares.Tobillo.Izquierdo.Fz];

% --- GRF: reuso la YA alineada en CalculoFuerzasArticulares ---
F_plataforma_izquierda = Datos.Pasada.GRF.Izquierda;     % [n x 3] N

% --- Free moment: MISMO anclaje que la GRF, sobre el Mz CRUDO de plataforma ---
%     alinearMomento es el gemelo escalar de alinearGRF.
Mz_izq = alinearMomento(Datos.Pasada.Fuerzas.Plataforma2.Valores.Mz2, ...
                        n, Datos.eventos.FrameLHS1, Datos.eventos.FrameLTO) / 1000;  % N·mm -> N·m

M_plataforma_i = [zeros(n,2), Mz_izq];               % Tz = [0 0 Mz]   [n x 3]

CP2x = alinearMomento(Datos.Pasada.Fuerzas.Plataforma2.Valores.CP2x, ...
                      n , Datos.eventos.FrameLHS1, Datos.eventos.FrameLTO);

CP2y = alinearMomento(Datos.Pasada.Fuerzas.Plataforma2.Valores.CP2y, ...
                      n , Datos.eventos.FrameLHS1, Datos.eventos.FrameLTO);

CentroPresionIzquierdo = [CP2x CP2y zeros(n,1)];

% Brazos de momento (desde el CoM del pie)
rP_pie_I  = Datos.Pasada.CentrosArticulares.Tobillo.Izquierdo - CoM_pie_I;
rD_pie_I  = CentroPresionIzquierdo                            - CoM_pie_I;

% Momento residual del pie en GLOBAL  (M_Res.5)
MR_pie_I_global = M_plataforma_i ...
                + cross(rP_pie_I, F_tobillo_I,            2) ...
                + cross(rD_pie_I, F_plataforma_izquierda, 2);

% Versores anatomicos del pie
i_pie_I = Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.i;
j_pie_I = Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.j;
k_pie_I = Datos.Pasada.SistemaCoordenadoAnatomico.Pie.Izquierdo.k;

% Resultante rotado a LOCAL:  i5·MRes , j5·MRes , k5·MRes
MR_pie_I_local = [dot(MR_pie_I_global, i_pie_I, 2), ...
                  dot(MR_pie_I_global, j_pie_I, 2), ...
                  dot(MR_pie_I_global, k_pie_I, 2)];

% Momento NETO del tobillo (M_R.Ankle) = dH/dt_local - MRes_local
dHdt_pie_I = [Datos.Pasada.DerivadaCantidadMovimientoAngular.Pie.Izquierdo.dHx_dt, ...
              Datos.Pasada.DerivadaCantidadMovimientoAngular.Pie.Izquierdo.dHy_dt, ...
              Datos.Pasada.DerivadaCantidadMovimientoAngular.Pie.Izquierdo.dHz_dt];

M_tobillo_I_local = dHdt_pie_I - MR_pie_I_local;

M_tobillo_I_global = M_tobillo_I_local(:,1) .* i_pie_I ...
                   + M_tobillo_I_local(:,2) .* j_pie_I ...
                   + M_tobillo_I_local(:,3) .* k_pie_I;

% =====================================================================
% PIERNA IZQUIERDA  (segmento 4)
% =====================================================================
CoM_pierna_I = Datos.Pasada.ParametrosInerciales.Pierna.Izquierda.CoM;   % [n x 3] m, global

% Fuerza PROXIMAL = fuerza de rodilla izquierda, ya calculada (global)
F_rodilla_I = [Datos.Pasada.FuerzasArticulares.Rodilla.Izquierda.Fx, ...
               Datos.Pasada.FuerzasArticulares.Rodilla.Izquierda.Fy, ...
               Datos.Pasada.FuerzasArticulares.Rodilla.Izquierda.Fz];

% Brazos de momento (desde el CoM de la pierna izquierda)
rP_pierna_I = Datos.Pasada.CentrosArticulares.Rodilla.Izquierda  - CoM_pierna_I;  
rD_pierna_I = Datos.Pasada.CentrosArticulares.Tobillo.Izquierdo  - CoM_pierna_I;  

% Momento residual de la pierna izquierda en GLOBAL  (M_Res.4)
MR_pierna_I_global = - M_tobillo_I_global ...
                     - cross(rD_pierna_I, F_tobillo_I,  2) ...
                     + cross(rP_pierna_I, F_rodilla_I,  2);

% Versores anatomicos de la pierna izquierda
i_pierna_I = Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.i;
j_pierna_I = Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.j;
k_pierna_I = Datos.Pasada.SistemaCoordenadoAnatomico.Pierna.Izquierda.k;

% Residual rotado a LOCAL de la pierna izquierda
MR_pierna_I_local = [dot(MR_pierna_I_global, i_pierna_I, 2), ...
                     dot(MR_pierna_I_global, j_pierna_I, 2), ...
                     dot(MR_pierna_I_global, k_pierna_I, 2)];

% dH/dt de la pierna izquierda (LOCAL)
dHdt_pierna_I = [Datos.Pasada.DerivadaCantidadMovimientoAngular.Pierna.Izquierda.dHx_dt, ...
                 Datos.Pasada.DerivadaCantidadMovimientoAngular.Pierna.Izquierda.dHy_dt, ...
                 Datos.Pasada.DerivadaCantidadMovimientoAngular.Pierna.Izquierda.dHz_dt];

% Momento NETO de RODILLA izquierda
M_rodilla_I_local = dHdt_pierna_I - MR_pierna_I_local;

M_rodilla_I_global = M_rodilla_I_local(:,1) .* i_pierna_I ...
                   + M_rodilla_I_local(:,2) .* j_pierna_I ...
                   + M_rodilla_I_local(:,3) .* k_pierna_I;

% % =====================================================================
% % MUSLO IZQUIERDO 
% % =====================================================================
CoM_muslo_I = Datos.Pasada.ParametrosInerciales.Muslo.Izquierdo.CoM;   % [n x 3] m, global

% Fuerza PROXIMAL = fuerza de cadera izquierda, ya calculada (global)
F_cadera_I = [Datos.Pasada.FuerzasArticulares.Cadera.Izquierda.Fx, ...
              Datos.Pasada.FuerzasArticulares.Cadera.Izquierda.Fy, ...
              Datos.Pasada.FuerzasArticulares.Cadera.Izquierda.Fz];

% Brazos de momento (desde el CoM del muslo izquierdo)
rP_muslo_I = Datos.Pasada.CentrosArticulares.Cadera.Izquierda   - CoM_muslo_I;  
rD_muslo_I = Datos.Pasada.CentrosArticulares.Rodilla.Izquierda  - CoM_muslo_I;  

% Momento residual del muslo izquierdo en GLOBAL  (M_Res.2)
MR_cadera_I_global = - M_rodilla_I_global ...
                     - cross(rD_muslo_I, F_rodilla_I, 2) ...
                     + cross(rP_muslo_I, F_cadera_I,  2);

% Versores anatomicos del muslo izquierdo
i_muslo_I = Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.i;
j_muslo_I = Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.j;
k_muslo_I = Datos.Pasada.SistemaCoordenadoAnatomico.Muslo.Izquierdo.k;

% Residual rotado a LOCAL del muslo izquierdo
MR_cadera_I_local = [dot(MR_cadera_I_global, i_muslo_I, 2), ...
                     dot(MR_cadera_I_global, j_muslo_I, 2), ...
                     dot(MR_cadera_I_global, k_muslo_I, 2)];

% dH/dt del muslo izquierdo (LOCAL)
dHdt_muslo_I = [Datos.Pasada.DerivadaCantidadMovimientoAngular.Muslo.Izquierdo.dHx_dt, ...
                Datos.Pasada.DerivadaCantidadMovimientoAngular.Muslo.Izquierdo.dHy_dt, ...
                Datos.Pasada.DerivadaCantidadMovimientoAngular.Muslo.Izquierdo.dHz_dt];

% Momento NETO de CADERA izquierda
M_cadera_I_local = dHdt_muslo_I - MR_cadera_I_local;

M_cadera_I_global = M_cadera_I_local(:,1) .* i_muslo_I ...
                  + M_cadera_I_local(:,2) .* j_muslo_I ...
                  + M_cadera_I_local(:,3) .* k_muslo_I;

% =====================================================================
% GUARDAR LADO IZQUIERDO
% =====================================================================
Datos.Pasada.MomentosArticulares.Tobillo.Izquierdo.Mx = M_tobillo_I_global(:,1);
Datos.Pasada.MomentosArticulares.Tobillo.Izquierdo.My = M_tobillo_I_global(:,2);
Datos.Pasada.MomentosArticulares.Tobillo.Izquierdo.Mz = M_tobillo_I_global(:,3);

Datos.Pasada.MomentosArticulares.Rodilla.Izquierda.Mx = M_rodilla_I_global(:,1);
Datos.Pasada.MomentosArticulares.Rodilla.Izquierda.My = M_rodilla_I_global(:,2);
Datos.Pasada.MomentosArticulares.Rodilla.Izquierda.Mz = M_rodilla_I_global(:,3);

Datos.Pasada.MomentosArticulares.Cadera.Izquierda.Mx  = M_cadera_I_global(:,1);
Datos.Pasada.MomentosArticulares.Cadera.Izquierda.My  = M_cadera_I_global(:,2);
Datos.Pasada.MomentosArticulares.Cadera.Izquierda.Mz  = M_cadera_I_global(:,3);

% %% ============================================================
% %  PROYECCION A EJES ANATOMICOS
% %% ============================================================
SCA = Datos.Pasada.SistemaCoordenadoAnatomico;

% TOBILLO: momento en LOCAL del PIE -> GLOBAL -> proyecto
%   flex/ext = k de la PIERNA (proximal) ; rot int/ext = i del PIE (distal)
[tobD.flexext, tobD.rotie, tobD.abdadd] = ...
    proyectarEjesArticulares(M_tobillo_D_global, SCA.Pierna.Derecha.k, SCA.Pie.Derecho.i);

% RODILLA: momento en LOCAL de la PIERNA -> GLOBAL -> proyecto
%   flex/ext = k del MUSLO (proximal) ; rot int/ext = i de la PIERNA (distal)
[rodD.flexext, rodD.rotie, rodD.abdadd] = ...
    proyectarEjesArticulares(M_rodilla_D_global, SCA.Muslo.Derecho.k, SCA.Pierna.Derecha.i);

% CADERA: momento en LOCAL del MUSLO -> GLOBAL -> proyecto
%   flex/ext = k de la PELVIS (proximal) ; rot int/ext = i del MUSLO (distal)
[cadD.flexext, cadD.rotie, cadD.abdadd] = ...
    proyectarEjesArticulares(M_cadera_D_global, SCA.Pelvis.k, SCA.Muslo.Derecho.i);

% TOBILLO I: LOCAL del pie -> GLOBAL -> proyectar
[tobI.flexext, tobI.rotie, tobI.abdadd] = ...
    proyectarEjesArticulares(M_tobillo_I_global, SCA.Pierna.Izquierda.k, SCA.Pie.Izquierdo.i);

% RODILLA I: LOCAL de la pierna -> GLOBAL -> proyectar
[rodI.flexext, rodI.rotie, rodI.abdadd] = ...
    proyectarEjesArticulares(M_rodilla_I_global, SCA.Muslo.Izquierdo.k, SCA.Pierna.Izquierda.i);

% CADERA I: LOCAL del muslo -> GLOBAL -> proyectar
[cadI.flexext, cadI.rotie, cadI.abdadd] = ...
    proyectarEjesArticulares(M_cadera_I_global, SCA.Pelvis.k, SCA.Muslo.Izquierdo.i);

%% ---- Ajuste de signos morfologicos - DERECHO ----

%tobD.flexext = -tobD.flexext; 
%tobD.rotie   = -tobD.rotie;
%tobD.abdadd = - tobD.abdadd;
%rodD.flexext = -rodD.flexext;
%rodD.rotie   = -rodD.rotie;
%rodD.abdadd  = -rodD.abdadd;
%cadD.flexext = -cadD.flexext;
%cadD.rotie   = -cadD.rotie;
%cadD.abdadd  = -cadD.abdadd;

%% ---- Ajuste de signos morfologicos - IZQUIERDO ----

%tobI.flexext = -tobI.flexext;
%tobI.rotie   = -tobI.rotie;
tobI.abdadd = - tobI.abdadd;
%rodI.flexext = -rodI.flexext;
rodI.rotie   = -rodI.rotie;
rodI.abdadd  = -rodI.abdadd;
%cadI.flexext = -cadI.flexext;
cadI.rotie   = -cadI.rotie;
cadI.abdadd  = -cadI.abdadd;
 

%% ============================================================
%  GRAFICACION: Momentos articulares en ejes anatómicos
%% ============================================================
x = linspace(0, 100, 100);
ciclo_derecho   = Datos.eventos.FrameRHS2 - Datos.eventos.FrameRHS1;
ciclo_izquierdo = Datos.eventos.FrameLHS2 - Datos.eventos.FrameLHS1;
x_RTO = (Datos.eventos.FrameRTO - Datos.eventos.FrameRHS1) / ciclo_derecho   * 100;
x_LTO = (Datos.eventos.FrameLTO - Datos.eventos.FrameLHS1) / ciclo_izquierdo * 100;
rng_R = Datos.eventos.FrameRHS1 : Datos.eventos.FrameRHS2;
rng_L = Datos.eventos.FrameLHS1 : Datos.eventos.FrameLHS2;

% Filas: articulación. Columnas (pares der/izq): flexext, abdadd, rotie
filas = {
    'Cadera',   cadD.flexext, cadI.flexext, cadD.abdadd, cadI.abdadd, cadD.rotie, cadI.rotie;
    'Rodilla',  rodD.flexext, rodI.flexext, rodD.abdadd, rodI.abdadd, rodD.rotie, rodI.rotie;
    'Tobillo',  tobD.flexext, tobI.flexext, tobD.rotie, tobI.rotie, tobD.abdadd, tobI.abdadd
};
ejesM = {'Ext(-)/Flex(+) [N·m/kg]', 'Add(-)/Abd(+) [N·m/kg]', 'RotExt(-)/RotInt(+) [N·m/kg]'};

figure('Name', 'Momentos articulares (ejes anatómicos)')
sgtitle('Momentos Articulares Netos - Ciclo de Marcha', 'FontSize', 14, 'FontWeight', 'bold')

masa = Datos.antropometria.PESO.Valor;   % [kg]

for f = 1:size(filas, 1)
    art = filas{f, 1};
    for c = 1:3
        % Saltar Tobillo Abd/Add (fila 3, columna 2)
        if f == 3 && c == 2
            continue
        end
        der = filas{f, 2 + (c-1)*2} / masa;
        izq = filas{f, 3 + (c-1)*2} / masa;
        subplot(3, 3, (f-1)*3 + c)
        graficarFuerzaArticulares(x, ...
            InterpolaA100Muestras(der(rng_R)), ...
            InterpolaA100Muestras(izq(rng_L)), ...
            x_RTO, x_LTO, ['Momento ', art]);
        % Tobillo columna 3: ylabel cambia a Abd/Add aunque grafique rotie
        if f == 3 && c == 3
            ylabel('Add(-)/Abd(+) [N·m/kg]')
        else
            ylabel(ejesM{c})
        end
    end
end

 end
% % =========================================================================
% %                          FUNCIONES LOCALES
% % =========================================================================

function [flexext, rotie, abdadd] = proyectarEjesArticulares(M, k_prox, i_dist)
flexext = dot(M, k_prox, 2); rotie = dot(M, i_dist, 2);
eje_flot = cross(k_prox, i_dist, 2); eje_flot = eje_flot ./ vecnorm(eje_flot, 2, 2); abdadd = dot(M, eje_flot, 2);
end
 
function Mout = alinearMomento(Mraw, n, iniApoyo, finApoyo)
Mraw = Mraw(:);
Mout = zeros(n, 1);
idx = find(Mraw ~= 0 & ~isnan(Mraw));      % bloque de contacto: no-cero y no-NaN
if isempty(idx), return; end
bloque = Mraw(idx(1):idx(end));
nan_int = isnan(bloque);
if any(nan_int)
    t = 1:numel(bloque);
    bloque(nan_int) = interp1(t(~nan_int), bloque(~nan_int), t(nan_int), 'linear', 0);
end
iniApoyo = max(1, round(iniApoyo));
finApoyo = min(n, round(finApoyo));
if finApoyo <= iniApoyo, return; end
L = finApoyo - iniApoyo + 1;
Mout(iniApoyo:finApoyo) = resamplearAGrilla(bloque, L);   % <-- esta linea faltaba
end

function Y = resamplearAGrilla(X, n)
S = size(X,1);
if S == n, Y = X; return; end
Y = interp1(linspace(0,1,S), X, linspace(0,1,n), 'linear');
end