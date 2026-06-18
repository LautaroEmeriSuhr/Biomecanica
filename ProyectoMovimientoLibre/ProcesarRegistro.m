function Datos = ProcesarRegistro(UbNombre, fileName)
% ProcesarRegistro  Tu pipeline (ex-ProyectoMovimientoLibre.m) como FUNCION,
% para poder llamarlo dentro del loop del multiabridor.
%   UbNombre : carpeta de los c3d
%   fileName : nombre del trial (con o sin ".c3d")
% Devuelve Datos con los angulos articulares ya calculados (a largo completo).

% --- Carga (c3d + antropometria + eventos + frame0) ---
[Datos, ~] = CargarRegistro(UbNombre, fileName);

% --- OJO: Ciclo2Pasos y RecortaDatos son de MARCHA ---
% Detectan apoyo de talon/despegue con plataformas de fuerza y recortan los
% arreglos. En pitching no aplican y ademas te desalinean la ventana de
% eventos. Por eso quedan COMENTADOS: el recorte al gesto se hace en
% Cinematica usando Datos.eventos.Inicio:Fin sobre los arreglos a largo completo.
%
% [Datos, DerechaPlataforma1, PrimerFrame, UltimoFrame] = Ciclo2Pasos(Datos);
% AntesHS = 10; DespuesHS = 10;
% Datos = RecortaDatos(Datos, PrimerFrame-AntesHS, UltimoFrame+DespuesHS);

% --- Modelo: segmentos -> centros -> sistemas -> angulos ---
Datos = SegmentosArticulares(Datos);
Datos = CentrosArticulares(Datos);
Datos = SistemaCoordenadoAnatomico(Datos);
Datos = CalculoAngulosArticulares(Datos);

% --- Etapas opcionales (no hacen falta para los angulos; descomenta si las
%     queres en el lote) ---
% Datos = CalculoParametrosInerciales(Datos);
% dt = 1/Datos.info.Cinematica.frequency;
% fc = 6;
% Datos = CalculoCinematicaAngular(Datos, dt, fc);
end