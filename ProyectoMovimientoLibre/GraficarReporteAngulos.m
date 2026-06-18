function GraficarReporteAngulos(Media, Desvio, Etiquetas, x_evento)
% GraficarReporteAngulos  Reporte 3x3 del gesto de pitcheo con MEDIA y DESVIO
% entre todas las pasadas. Reescritura del reporte de un registro para
% trabajar con las salidas del lote (Media, Desvio : 100 x M).
%
%   Media, Desvio : 100 x M  (salidas de ProyectoMovimientoLibre_Lote)
%   Etiquetas     : 1 x M     (nombre/orden de columnas, ej. 'Alpha_Cadera_Derecha')
%   x_evento      : (opcional) % del gesto donde marcar un evento intermedio
%                   (ej. contacto del pie de aterrizaje). NaN -> no se dibuja.

if nargin < 4 || isempty(x_evento), x_evento = NaN; end

% Eje normalizado: 0-100 % del gesto de pitcheo
x = linspace(0, 100, size(Media,1));

% Reconstruyo la estructura anidada para poder nombrar cada angulo como en
% el reporte original (M.Plano.Articulacion.Lado).
M = ReconstruirAng(Media,  Etiquetas);
S = ReconstruirAng(Desvio, Etiquetas);

figure
sgtitle('Ángulos Articulares - Gesto de Pitcheo (Media ± Desvío)', ...
        'FontSize',14,'FontWeight','bold')

% ===== CADERA =====
subplot(3,3,1)
h = banda(x, M.Alpha.Cadera.Derecha, S.Alpha.Cadera.Derecha, ...
             M.Alpha.Cadera.Izquierda, S.Alpha.Cadera.Izquierda, x_evento, 'Cadera Flex/Ext');
legend(h, {'Derecha','Izquierda'}, 'Location','best', 'FontSize',7);

subplot(3,3,2)
banda(x, M.Beta.Cadera.Derecha, S.Beta.Cadera.Derecha, ...
         M.Beta.Cadera.Izquierda, S.Beta.Cadera.Izquierda, x_evento, 'Cadera Abd/Add');

subplot(3,3,3)
banda(x, M.Gamma.Cadera.Derecha, S.Gamma.Cadera.Derecha, ...
         M.Gamma.Cadera.Izquierda, S.Gamma.Cadera.Izquierda, x_evento, 'Cadera Rotación');

% ===== RODILLA =====
subplot(3,3,4)
banda(x, M.Alpha.Rodilla.Derecha, S.Alpha.Rodilla.Derecha, ...
         M.Alpha.Rodilla.Izquierda, S.Alpha.Rodilla.Izquierda, x_evento, 'Rodilla Flex/Ext');

subplot(3,3,5)
banda(x, M.Beta.Rodilla.Derecha, S.Beta.Rodilla.Derecha, ...
         M.Beta.Rodilla.Izquierda, S.Beta.Rodilla.Izquierda, x_evento, 'Rodilla Abd/Add');

subplot(3,3,6)
banda(x, M.Gamma.Rodilla.Derecha, S.Gamma.Rodilla.Derecha, ...
         M.Gamma.Rodilla.Izquierda, S.Gamma.Rodilla.Izquierda, x_evento, 'Rodilla Rotación');

% ===== TOBILLO =====  (ojo: campos .Derecho/.Izquierdo; orden Alpha, Gamma, Beta)
subplot(3,3,7)
banda(x, M.Alpha.Tobillo.Derecho, S.Alpha.Tobillo.Derecho, ...
         M.Alpha.Tobillo.Izquierdo, S.Alpha.Tobillo.Izquierdo, x_evento, 'Tobillo Dorsi/Plantar');

subplot(3,3,8)
banda(x, M.Gamma.Tobillo.Derecho, S.Gamma.Tobillo.Derecho, ...
         M.Gamma.Tobillo.Izquierdo, S.Gamma.Tobillo.Izquierdo, x_evento, 'Tobillo Inv/Ever');

subplot(3,3,9)
banda(x, M.Beta.Tobillo.Derecho, S.Beta.Tobillo.Derecho, ...
         M.Beta.Tobillo.Izquierdo, S.Beta.Tobillo.Izquierdo, x_evento, 'Tobillo Progresión Int/Ext');

end


% ===================== FUNCIONES LOCALES =============================

function h = banda(x, mD, sD, mI, sI, x_evento, titulo)
% Dibuja media +/- 1 desvio para derecha (azul) e izquierda (roja).
x = x(:); mD = mD(:); sD = sD(:); mI = mI(:); sI = sI(:);
cD = [0 1 0];   % derecha
cI = [1 0 0];   % izquierda
hold on

% bandas (+/- desvio)
fill([x; flipud(x)], [mD+sD; flipud(mD-sD)], cD, 'FaceAlpha',0.15, 'EdgeColor','none');
fill([x; flipud(x)], [mI+sI; flipud(mI-sI)], cI, 'FaceAlpha',0.15, 'EdgeColor','none');

% medias
pD = plot(x, mD, 'Color',cD, 'LineWidth',1.5);
pI = plot(x, mI, 'Color',cI, 'LineWidth',1.5);

% evento intermedio opcional
if ~isnan(x_evento)
    xline(x_evento, 'k--');   % R2018b+. Si tu MATLAB es anterior:
    % yl = ylim; plot([x_evento x_evento], yl, 'k--');
end

title(titulo); xlabel('% del pitcheo'); ylabel('°');
xlim([0 100]); grid on
h = [pD pI];
end


function S = ReconstruirAng(Mat, Etiquetas)
S = struct();
for k = 1:numel(Etiquetas)
    p = strsplit(Etiquetas{k}, '_');
    S.(p{1}).(p{2}).(p{3}) = rad2deg(Mat(:,k)); 
end
end