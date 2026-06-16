function [Datos,DerechaPlataforma1,PrimerFrame,UltimoFrame]=Ciclo2Pasos(Datos)
% CICLO2PASOS  Adaptada para el movimiento de PITCHING .
%
% El movimiento se define con una ventana Inicio - Fin (en FRAMES) que viene del
% Excel de eventos. Por eso aca solo se calcula esa ventana de recorte.
%
% Se conserva la MISMA lista de salidas para no romper la llamada del main.
% Las salidas propias de la marcha (FrameRHS1, FrameLHS1, etc.) quedan en NaN
% porque no aplican a este movimiento.

% --- ventana del lanzamiento (Inicio/Fin ya vienen en FRAMES) ---
PrimerFrame = Datos.eventos.Inicio;
UltimoFrame = Datos.eventos.Fin;

% frames relativos al inicio de la ventana (el primer frame pasa a ser 1),
% por si el resto del codigo trabaja con el tramo ya recortado
Datos.eventos.FrameInicio = 1;
Datos.eventos.FrameFin    = UltimoFrame - PrimerFrame + 1;

% pierna dominante (leida del Excel). true si la dominante es la derecha.
% OJO: verifica que esto coincida con que el pie derecho sea el de la
% Plataforma1 en tu montaje; si no, invertilo.
if isfield(Datos.eventos,'PiernaDominante') && ~isempty(Datos.eventos.PiernaDominante)
    DerechaPlataforma1 = strcmpi(Datos.eventos.PiernaDominante,'DER');
else
    DerechaPlataforma1 = true;
end

end