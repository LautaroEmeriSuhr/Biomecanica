function Angulos = Cinematica(UbNombre, Nombretxt)
% =========================================================================
% Cinematica  --  Devuelve la matriz Angulos (100 x 18) de UN registro.
%   100 filas  = 0..100% del gesto (pitching)
%   18 columnas= 3 articulaciones x 3 planos x 2 lados, en el ORDEN de abajo
% Interface de 2 argumentos = la misma que espera el main del profe.
% =========================================================================

%% 1) Correr TU pipeline para este c3d (carga eventos y frame0 adentro) ---
Datos = ProcesarRegistro(UbNombre, Nombretxt);

Inicio = Datos.eventos.Inicio;
Fin    = Datos.eventos.Fin;
frame0 = Datos.frame0;

%% 2) Ventana del gesto en indices LOCALES del arreglo -------------------
ventana = (Inicio:Fin) - frame0 + 1;

%% 3) Extraer los 18 angulos en ORDEN FIJO e interpolar a 100 muestras ---
A = Datos.Pasada.AngulosArticulares;

% ----------------------- ORDEN DE LAS 18 COLUMNAS ------------------------
% CONFIRMA que estos nombres de campo coincidan con tu struct y que tengas
% los 3 planos por articulacion (Alpha/Beta/Gamma). Si tu modelo calcula solo
% 2 planos por articulacion, son 12 columnas, no 18 (avisame y lo ajusto).
% Convencion: primero DERECHO (9), luego IZQUIERDO (9); por articulacion el
% orden de planos es Alpha, Beta, Gamma.
crudos = {
    A.Alpha.Cadera.Derecha,    A.Beta.Cadera.Derecha,    A.Gamma.Cadera.Derecha,   ...
    A.Alpha.Rodilla.Derecha,   A.Beta.Rodilla.Derecha,   A.Gamma.Rodilla.Derecha,  ...
    A.Alpha.Tobillo.Derecho,   A.Beta.Tobillo.Derecho,   A.Gamma.Tobillo.Derecho,  ...
    A.Alpha.Cadera.Izquierda,  A.Beta.Cadera.Izquierda,  A.Gamma.Cadera.Izquierda, ...
    A.Alpha.Rodilla.Izquierda, A.Beta.Rodilla.Izquierda, A.Gamma.Rodilla.Izquierda,...
    A.Alpha.Tobillo.Izquierdo, A.Beta.Tobillo.Izquierdo, A.Gamma.Tobillo.Izquierdo ...
};
% -------------------------------------------------------------------------

Angulos = zeros(100, 18);
for k = 1:18
    serie = crudos{k}(:);                                  % arreglo completo (columna)
    Angulos(:,k) = InterpolaA100Muestras(serie(ventana));  % tu interpolador
end
% Si InterpolaA100Muestras devuelve fila, deja igual: el (:,k) ya la encolumna.
end