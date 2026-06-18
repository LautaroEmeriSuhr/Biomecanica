% =========================================================================
% ProyectoMovimientoLibre_Lote.m
% -------------------------------------------------------------------------
% Procesa TODOS los .c3d de una carpeta y saca MEDIA y DESVIO (entre todas
% las pasadas) de:
%   - los ANGULOS articulares            -> reporte 3x3  (grados)
%   - la VELOCIDAD ANGULAR de segmentos  -> reporte por segmento (°/s)
%
% Requiere (ya parametrizados, sin uigetfile):
%   leer_c3d(filePath,fileName) -> devuelve frame0
%   CargarRegistro(UbNombre,fileName) -> guarda Datos.frame0
%   NormalizarA100(nodo,ventana)
%   GraficarReporteAngulos(Media,Desvio,Etiquetas)
%   GraficarReporteVelocidad(Media,Desvio,Etiquetas)
%
% Salidas principales:
%   MediaAng, DesvioAng (100 x Ma)   + EtiqAng
%   MediaVel, DesvioVel (100 x Mv)   + EtiqVel
% =========================================================================

clear all
close all
clc

%% --- CONFIG -------------------------------------------------------------
% Campo de Datos.Pasada donde CalculoCinematicaAngular deja la velocidad
% angular de los segmentos. Si no acertas el nombre, el codigo te lista los
% campos disponibles para que pongas el correcto.
campoVel = 'VelocidadAngular';

fc = 6;     % frecuencia de corte del filtro (la que ya usabas)

%% --- Carpeta con los c3d ------------------------------------------------
UbCodigo = cd;
Ubc3d = uigetdir(cd, 'Selecciona la carpeta con los .c3d');
if isequal(Ubc3d,0); error('No se selecciono carpeta.'); end

cd(Ubc3d);  C3ds = dir('*.c3d');  cd(UbCodigo);
N = numel(C3ds);
if N == 0; error('No hay .c3d en %s', Ubc3d); end

%% --- Loop por registro --------------------------------------------------
TodosAng = [];  EtiqAng = {};
TodosVel = [];  EtiqVel = {};

for r = 1:N
    Nombre = C3ds(r).name(1:end-4);
    fprintf('(%d/%d)  %s\n', r, N, Nombre);

    [Datos, Archivo] = CargarRegistro(Ubc3d, Nombre);

    Datos = SegmentosArticulares(Datos);
    Datos = CentrosArticulares(Datos);
    Datos = SistemaCoordenadoAnatomico(Datos);
    Datos = CalculoAngulosArticulares(Datos);

    % --- cinematica angular (velocidad angular de segmentos) ---
    Datos = CalculoParametrosInerciales(Datos);          % si CalculoCinematicaAngular lo necesita
    dt = 1/Datos.info.Cinematica.frequency;
    Datos = CalculoCinematicaAngular(Datos, dt, fc);

    % --- ventana del gesto (frames absolutos -> indices locales) ---
    ventana = (Datos.eventos.Inicio:Datos.eventos.Fin) - Datos.frame0 + 1;

    % --- angulos ---
    [Aa, Ea] = NormalizarA100(Datos.Pasada.AngulosArticulares, ventana);

    % --- velocidad angular ---
    if ~isfield(Datos.Pasada, campoVel)
        error(['No existe Datos.Pasada.%s\n' ...
               'Campos disponibles en Datos.Pasada: %s\n' ...
               'Edita "campoVel" arriba con el nombre correcto.'], ...
               campoVel, strjoin(fieldnames(Datos.Pasada), ', '));
    end
    [Av, Ev] = NormalizarA100(Datos.Pasada.(campoVel), ventana);

    if isempty(EtiqAng), EtiqAng = Ea; end
    if isempty(EtiqVel), EtiqVel = Ev; end
    TodosAng = cat(3, TodosAng, Aa);     % 100 x Ma x N
    TodosVel = cat(3, TodosVel, Av);     % 100 x Mv x N
end

%% --- Media y desvio entre pasadas --------------------------------------
MediaAng  = mean(TodosAng, 3);   DesvioAng = std(TodosAng, 0, 3);
MediaVel  = mean(TodosVel, 3);   DesvioVel = std(TodosVel, 0, 3);

fprintf('\nListo: %d registros | %d angulos | %d series de velocidad.\n', ...
        N, numel(EtiqAng), numel(EtiqVel));

%% --- Reportes -----------------------------------------------------------
GraficarReporteAngulos(MediaAng, DesvioAng, EtiqAng);     % grados
GraficarReporteVelocidad(MediaVel, DesvioVel, EtiqVel);   % °/s