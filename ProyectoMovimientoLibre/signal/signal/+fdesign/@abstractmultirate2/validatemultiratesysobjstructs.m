function validatemultiratesysobjstructs(this, method, struct, sysObjFlag)
%DESIGN   

%   Copyright 2011 The MathWorks, Inc.

if sysObjFlag
  % If sysObjFlag is true, then check if the requested structure is
  % supported by System objects before designing the single rate filter.   
  if any(strcmpi(method,designmethods(this,'iir')))
    error(message('signal:fdesign:basecatalog:IIRStructureNotSupportedBySystemObjects','''SystemObject'''))
  end  
  validStructs = validstructures(this,method,'SystemObject',true);  
  if isempty(intersect(validStructs,struct))
    error(message('signal:fdesign:basecatalog:StructureNotSupportedBySystemObjects',struct,'''SystemObject'''))
  end
else
  % If sysObjFlag is absent or false, throw a warning to set it to true as
  % long as the requested structure is supported by System objects. MFILT
  % objects are on their deprecation path, and we want to prevent / reduce
  % generation of MFILT objects.
  validStructs = validstructures(this,method,'SystemObject',true);
  if ~any(strcmpi(method,designmethods(this,'iir'))) && ~isempty(intersect(validStructs,struct))
     warning(message('signal:fdesign:basecatalog:UseSystemObjectForMultirateDesigns'));
  end
end