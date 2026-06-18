clear all
close all
clc

[Datos,Archivo]=CargarRegistro();% El llamado a esta funci�n permite cargar el archivo c3d. AHORA tiene la ventaja que los archivos pueden estar en cualquier carpeta del r�gido 
                                                                  % y no hace falta cambiar de directorio. Este cambio permite conservar la ruta y el nombre del archivo y mantener el directorio actual sin mover.
                                                                  % esta funci�n no requiere ningun par�metro de ida y regresa con par�mtros:
                                                                  % "Datos" donde est� toda la estructura del registro y 
                                                                  %"Archivo" que es solamente el nombre del archivo que permite ver en el workspace el archivo sobre el que estoy trabajando

 
[Datos, DerechaPlataforma1,PrimerFrame,UltimoFrame]=Ciclo2Pasos(Datos);
% La funci�n "Ciclo2Pasos" Recibe como par�metro la estuctura de "Datos"
% completa no la modifica, pero si devuelve los parametros convertidos en
% frame (cuadros) en los que se producen los eventos de apoyo del ta�n y
%  despegue de la punta del pie que permiten recortar los datos de cada
%  ciclo ixquierdo y derecho. Adem�s se indica en "DerechaPlataforma1" con
%  una variable booleana si pisa primero con el pie derecho 


AntesHS=10; % es es parametro de cuantos datos antes de el primer contacto del pie 
%que pisa primero se inicia el recorte de los datos para pasar
% como par�metro a la funci�n "RecortaDatos"
DespuesHS=10;
% es es parametro de cuantos datos despues del segundo contacto del pie 
% que pisa en  segundo t�rmino se inicia el recorte de los datos para pasar
% como par�metro a la funci�n "RecortaDatos"
Datos=RecortaDatos(Datos,PrimerFrame-AntesHS,UltimoFrame+DespuesHS);
% esta funci�n recorta los datos a un paso de ambos pies + la cantidad de
% datos definidas por "AntesHS" y "DespuesHS" 
% IMPORTANTE: tener en cuenta que esta escrita con los marcadores
% organizados en una estructura "Datos.Pasada.Marcadores.Crudos" esto puede
% haber definido usted que sea otra forma de estructura, debe adaptarla 


Datos = SegmentosArticulares(Datos);% Esta funci�n sirve para calcular un vector entre dos puntos, 
% los asis izquierdo y derecho en el espacio 3D y lo grafica. Tambi�n grafica solapado con ese mismo vector 
% en otro color el vector convertido a versor unitario (1 metro de longitud)  
% asimismo, usando el producto cruz calcula un vector perpendicular a tres
% puntos sacro, asis izquierdo y derecho y de igual forma lo grafica en 3D
% como vector y como versor unitario en otro color se grafica en la misma
% figura. Finalmente calcula un tercer versor perpendicular a los dos
% anteriores lo que dar�a un sistema de tres versores ortonormles entre s�.
% Este tercer versor se grafica tambi�n todo en una misma figura.
% IMPORTANTE: Todo este c�digo es usando "SIN" usar bucles con "for"
% esto requiere dos funciones adicionales para la graficaci�n no se utiliza una funci�n 
% aparte lo que podr�a resultar conveniente      
% IMPORTANTE2: tener en cuenta que esta escrita con los marcadores
% organizados en una estructura "Datos.Pasada.Marcadores.Crudos" esto puede
% haber definido usted que sea otra forma de estructura, debe adaptarla

Datos = CentrosArticulares(Datos);

Datos = SistemaCoordenadoAnatomico(Datos);

Datos = CalculoAngulosArticulares(Datos);

Datos = CalculoParametrosInerciales(Datos);

dt = 1/Datos.info.Cinematica.frequency; %% Periodo de muestreo del sistema de Adquisici�n
fc = 6; %% Frecuencia de corte del Filtro Pasa-Bajos de Butterworth de 2do Orden

Datos = CalculoCinematicaAngular(Datos, dt, fc);