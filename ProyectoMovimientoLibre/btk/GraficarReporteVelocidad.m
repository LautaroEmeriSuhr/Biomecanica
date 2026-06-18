function GraficarReporteVelocidad(Media, Desvio, Etiquetas)
% GraficarReporteVelocidad  Reporte de la velocidad angular de los segmentos:
% media +/- 1 desvio entre todas las pasadas. Descubre los segmentos solo y
% empareja derecha/izquierda, asi no depende de nombres fijos.
%
%   Media, Desvio : 100 x M   (salidas del lote para la velocidad angular)
%   Etiquetas     : 1 x M       (rutas, ej. 'Pelvis_Derecho_X')

x = linspace(0, 100, size(Media,1));

ladosD = {'Derecha','Derecho'};
ladosI = {'Izquierda','Izquierdo'};

% --- Separar cada etiqueta en "clave (sin lado)" + "lado" ---
clave = cell(size(Etiquetas));
lado  = cell(size(Etiquetas));
for k = 1:numel(Etiquetas)
    t  = strsplit(Etiquetas{k}, '_');
    iL = find(ismember(t, [ladosD ladosI]), 1);
    if isempty(iL)
        clave{k} = Etiquetas{k};  lado{k} = '';
    else
        lado{k}  = t{iL};
        t(iL)    = [];
        clave{k} = strjoin(t, '_');
    end
end

grupos = unique(clave, 'stable');
ng = numel(grupos);
nc = 3;  nf = ceil(ng/nc);

figure
sgtitle('Velocidad Angular de los Segmentos (media ± 1 desvío)', ...
        'FontSize',14,'FontWeight','bold')

cD = [0.20 0.40 0.80];   % derecha
cI = [0.85 0.20 0.20];   % izquierda
cU = [0.20 0.60 0.20];   % sin lado (ej. pelvis/tronco)

for g = 1:ng
    subplot(nf, nc, g); hold on
    esGrupo = strcmp(clave, grupos{g});
    idxD = find(esGrupo & ismember(lado, ladosD), 1);
    idxI = find(esGrupo & ismember(lado, ladosI), 1);
    idx0 = find(esGrupo & strcmp(lado, ''), 1);

    hs = []; ls = {};
    if ~isempty(idxD), hs(end+1)=banda(x,Media(:,idxD),Desvio(:,idxD),cD); ls{end+1}='Derecha';    end
    if ~isempty(idxI), hs(end+1)=banda(x,Media(:,idxI),Desvio(:,idxI),cI); ls{end+1}='Izquierda';  end
    if ~isempty(idx0), hs(end+1)=banda(x,Media(:,idx0),Desvio(:,idx0),cU); ls{end+1}=grupos{g};    end

    title(strrep(grupos{g},'_','\_'));
    xlabel('% del pitcheo'); ylabel('°/s');
    xlim([0 100]); grid on
    if g==1 && ~isempty(hs), legend(hs, ls, 'Location','best', 'FontSize',7); end
end
end


function h = banda(x, m, s, c)
x = x(:); m = m(:); s = s(:);
fill([x; flipud(x)], [m+s; flipud(m-s)], c, 'FaceAlpha',0.15, 'EdgeColor','none');
h = plot(x, m, 'Color',c, 'LineWidth',1.5);
end