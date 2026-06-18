function [MediayDesvio] = CalcularMediaYDesvio(APromediar,NRegistros);

Media=[];
MediayDesvio=[];
for j=1:18
    for i=1:NRegistros
        Columna=((i-1)*(18)) + j;
        Media=[Media APromediar(:,Columna)];
    end;
    Med=mean(Media,2);
    Des=std(Media,0,2);
    MediayDesvio=[MediayDesvio Med];
    MediayDesvio=[MediayDesvio Des];
    Media=[];
end;

