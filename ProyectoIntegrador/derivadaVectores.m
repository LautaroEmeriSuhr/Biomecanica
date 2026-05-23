%deriva la filas o las columnas de una matriz por el método de euler,
%selecciona derivar filas o columnas en funcion de la cantidad de filas o
%columnas. Siempre deriva los vectores mas largos.
% esta primer Parte, 

% Rehago para que derive los vectores mas en las filas
% considerando que el tiempo esta en Frames en filas diferentes


function d1Vectores=derivadaVectores(Vectores, dt)
SDelta=1/(2*dt);
d1Vectores=zeros(length(Vectores(:,1)),length(Vectores(1,:)));
Aux1 = zeros(length(Vectores(:,1)),length(Vectores(1,:)));
Aux1(1:end-2,:) = Vectores(3:end,:);
Aux1= Aux1-Vectores;
d1Vectores(2:end-1,:) = Aux1(1:end-2,:).*(SDelta);
end

