function [Datos, fileName] = CargarRegistro(UbNombre, fileName)
% CargarRegistro  Carga UN registro y arma la estructura Datos.
% AHORA recibe (UbNombre, fileName) y se los pasa a leer_c3d (sin uigetfile).
%
% NOTA: ajusta los nombres de los campos para que COINCIDAN EXACTAMENTE con
% los que ya usa tu pipeline (SegmentosArticulares, CentrosArticulares, etc.).
% Lo unico imprescindible que se agrega respecto a tu version es Datos.frame0.

[marcadores, informacionCine, Fuerzas, informacionFuerzas, ...
 Antropometria, Eventos, fileName, frame0] = leer_c3d(UbNombre, fileName);


% [marcadores,informacionCine,Fuerzas,informacionFuerzas,Antropometria,Eventos,fileName] = Nuevo_leer_c3d();

% --- Marcadores ---
Datos.Pasada.Marcadores = marcadores;        % marcadores.Valores / .Unidades / .Frecuencia

% --- Info cinematica (la usa CalculoCinematicaAngular: Datos.info.Cinematica.frequency) ---
Datos.info.Cinematica = informacionCine;

% --- Fuerzas ---
Datos.Fuerzas       = Fuerzas;
Datos.info.Fuerzas  = informacionFuerzas;

% --- Antropometria y Eventos ---
Datos.antropometria = Antropometria;
Datos.eventos       = Eventos;               % .Inicio / .Fin / .Trial / .PiernaDominante

% % --- Primer frame real del c3d (para alinear la ventana de eventos) ---
Datos.frame0        = frame0;
end