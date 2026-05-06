classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) cicinterp < fdesign.abstractcic & dynamicprops
%fdesign.cicinterp class
%   fdesign.cicinterp extends fdesign.abstractcic.
%
%    fdesign.cicinterp properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Specification - Property is of type 'cicSpecTypes enumeration: {'Fp,Ast'}'  
%       DifferentialDelay - Property is of type 'posint user-defined'  
%
%    fdesign.cicinterp methods:
%       getconstructor -   Get the constructor.
%       getmask -   Get the mask.
%       propstocopy -   Returns the properties to copy.



methods  % constructor block
  function this = cicinterp(varargin)
  %CICINTERP   Construct a CICINTERP object.

  % this = fdesign.cicinterp;

  this.Response = 'CIC Interpolator';
  
  this.Specification = 'Fp,Ast';

  this.setspecs(varargin{:});

  end  % cicinterp

end  % constructor block

methods (Access = protected)
  %This function defines the display behavior for the class
  %using matlab.mixin.util.CustomDisplay
  function propgrp = getPropertyGroups(obj)
    propList = get(obj);
    cpropList = propstoadd(obj.CurrentSpecs);
    propList = reorderstructure(propList,'Response','Specification','Description','DifferentialDelay',cpropList{:});
    if propList.NormalizedFrequency 
      propList = rmfield(propList, 'Fs');
    end
    propgrp = matlab.mixin.util.PropertyGroup(propList);
  end
end

methods  % public methods
  constructor = getconstructor(this,stype)
  [F,A] = getmask(this,fcns,R,specs)
  p = propstocopy(this)
end  % public methods 

end  % classdef

