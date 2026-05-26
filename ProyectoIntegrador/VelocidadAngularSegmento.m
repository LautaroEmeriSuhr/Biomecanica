function [wx, wy, wz] = VelocidadAngularSegmento(alfa, deralfa, beta, derbeta, gama, dergama)
% VELOCIDADANGULARSEGMENTO  Calcula la velocidad angular de un segmento en
%                           coordenadas LOCALES a partir de los ángulos de
%                           Euler (3-1-3) y sus derivadas.
%
%   [wx, wy, wz] = VelocidadAngularSegmento(alfa, deralfa, beta, derbeta, gama, dergama)
%
%   A partir de los tres ángulos de Euler (alfa, beta, gama) y de sus
%   derivadas temporales (α̇, β̇, γ̇) se obtiene la velocidad angular del
%   segmento expresada en su propio sistema coordenado:
%
%       | wx |     | α̇ · sin(β) · sin(γ) + β̇ · cos(γ) |
%       | wy |  =  | α̇ · sin(β) · cos(γ) − β̇ · sin(γ) |
%       | wz |     | α̇ · cos(β) + γ̇                   |
%
%   Esta expresión surge de sumar w_alfa + w_beta + w_gama, expresando
%   primero w_alfa y w_beta en el sistema local mediante las matrices
%   de rotación Rz(γ)·Rx(β) y Rz(γ) respectivamente (ver apunte).
%
%   ENTRADAS  (vectores columna [n x 1])
%       alfa, beta, gama          : ángulos de Euler del segmento [grados]
%       deralfa, derbeta, dergama : derivadas temporales discretas
%                                   de los ángulos [grados/segundo]
%
%   SALIDAS  (vectores columna [n x 1])
%       wx : velocidad angular del segmento en la dirección del eje x local (i)
%       wy : velocidad angular del segmento en la dirección del eje y local (j)
%       wz : velocidad angular del segmento en la dirección del eje z local (k)
%       (Todas expresadas en el sistema coordenado LOCAL del segmento.)
%
%   IMPORTANTE: como se usan las funciones sind y cosd, los ángulos
%   deben pasarse en GRADOS (no en radianes).
%
%   Ejemplo de llamada para el muslo derecho:
%       [wx_mus, wy_mus, wz_mus] = VelocidadAngularSegmento( ...
%               alfa_mus, deralfa_mus, beta_mus, derbeta_mus, gama_mus, dergama_mus);
%
%   Referencia: Apunte de Biomecánica, sección 2.5 (Cinemática angular de
%               los segmentos).

wx = deralfa .* sin(beta) .* sin(gama) + derbeta .* cos(gama);
wy = deralfa .* sin(beta) .* cos(gama) - derbeta .* sin(gama);
wz = deralfa .* cos(beta) + dergama;

end
