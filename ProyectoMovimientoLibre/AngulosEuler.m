function [alfa_sen, alfa_cos, beta_sen, beta_cos, gama_sen, gama_cos] = AngulosEuler(i, j, k)
% ANGULOSEULER  Calcula los ángulos de Euler de un segmento (convención 3-1-3, Z-x''-z).
%
%   [alfa_sen, alfa_cos, beta_sen, beta_cos, gama_sen, gama_cos] = ...
%                                                AngulosEuler(i, j, k)
%
%   Calcula los tres ángulos de Euler (alfa, beta, gama) que definen la
%   orientación del sistema coordenado LOCAL de un segmento respecto al
%   sistema coordenado GLOBAL. Devuelve los ángulos calculados de dos
%   formas distintas:
%       - con arco-seno  (rango -90° a 90°)
%       - con arco-coseno (rango   0° a 180°, con signo aux. para alfa y gama)
%
%   Convención 3-1-3 (Z-x''-z):
%       alfa  (también llamado phi)   : rotación alrededor del eje K global,
%                                       entre el eje X y la Línea de Nodos.
%       beta  (también llamado theta) : rotación alrededor de la Línea de Nodos,
%                                       entre el eje z local y el eje Z global.
%       gama  (también llamado psi)   : rotación alrededor del eje k local,
%                                       entre la Línea de Nodos y el eje x.
%
%   ENTRADAS
%       i, j, k : matrices [n x 3] con los versores del sistema coordenado
%                 LOCAL del segmento, expresados en el sistema GLOBAL.
%                 Cada fila corresponde a una muestra temporal.
%
%   SALIDAS  (todas en GRADOS, vectores columna [n x 1])
%       alfa_sen, beta_sen, gama_sen : ángulos calculados con arco-seno.
%       alfa_cos, beta_cos, gama_cos : ángulos calculados con arco-coseno.
%
%   Referencia:
%       Apunte de Biomecánica, sección 2.4.2 (Ángulos de Euler).
%       Línea de nodos: LN = (K x k) / |K x k|

% ---------- Versores del sistema GLOBAL (uno por muestra) ----------
n = size(i, 1);
I = repmat([1 0 0], n, 1);   % eje X global en cada muestra
J = repmat([0 1 0], n, 1);   % eje Y global en cada muestra
K = repmat([0 0 1], n, 1);   % eje Z global en cada muestra

% ---------- Línea de Nodos:  LN = (K x k) / |K x k| ----------
Kxk      = cross(K, k, 2);
normaKxk = sqrt(sum(Kxk.^2, 2));
LN       = Kxk ./ [normaKxk normaKxk normaKxk];

% ======================================================================
%                CÁLCULO CON ARCO-SENO  (-90° a 90°)
% ======================================================================
%
%   El seno de cada ángulo es el módulo del producto vectorial entre los
%   versores que lo definen, proyectado sobre el eje de rotación
%   correspondiente.
%
%       alfa : eje de rotación = K   ->  sen(alfa) = (I x LN) · K
%       beta : eje de rotación = LN  ->  sen(beta) = (K x k)  · LN
%       gama : eje de rotación = k   ->  sen(gama) = (LN x i) · k

alfa_sen = asin( dot( cross(I, LN, 2), K, 2 ) );
beta_sen = asin( dot( cross(K, k,  2), LN, 2 ) );
gama_sen = asin( dot( cross(LN, i, 2), k, 2 ) );

% ======================================================================
%                CÁLCULO CON ARCO-COSENO  (0° a 180°)
% ======================================================================
%
%   El arco-coseno por sí solo no distingue signos. Para alfa y gama se
%   usa una expresión auxiliar (J·LN o j·LN) que aporta el signo, tal
%   como se desarrolla en la sección 2.4.2 del apunte.
%
%       alfa  =  sign(J · LN) * acos(I · LN)
%       beta  =                 acos(K · k)
%       gama  = -sign(j · LN) * acos(i · LN)

signo_alfa = dot(J, LN, 2) ./ abs( dot(J, LN, 2) );
alfa_cos   = signo_alfa .* acos( dot(I, LN, 2) );

beta_cos   = acos( dot(K, k, 2) );

signo_gama = dot(j, LN, 2) ./ abs( dot(j, LN, 2) );
gama_cos   = -signo_gama .* acos( dot(i, LN, 2) );

end
