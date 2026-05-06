classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) arbgrpdelaymeas < fdesign.abstractmeas
%ARBGRPDELAYMEAS  Construct an ARBGRPDELAYMEAS object.

%   Copyright 2004-2015 The MathWorks, Inc.  
  
%fdesign.arbgrpdelaymeas class
%   fdesign.arbgrpdelaymeas extends fdesign.abstractmeas.
%
%    fdesign.arbgrpdelaymeas properties:
%       NormalizedFrequency - Property is of type 'bool' (read only) 
%       Fs - Property is of type 'mxArray' (read only) 
%       Frequencies - Property is of type 'mxArray' (read only) 
%       TotalGroupDelay - Property is of type 'mxArray' (read only) 
%       NomGrpDelay - Property is of type 'mxArray' (read only) 
%
%    fdesign.arbgrpdelaymeas methods:
%       getprops2norm - Get the props2norm.
%       setprops2norm - Set the props2norm.


properties (SetAccess=protected, AbortSet, SetObservable, GetObservable)
  %FREQUENCIES Property is of type 'mxArray' (read only)
  Frequencies = [];
  %TOTALGROUPDELAY Property is of type 'mxArray' (read only)
  TotalGroupDelay = [];
  %NOMGRPDELAY Property is of type 'mxArray' (read only)
  NomGrpDelay = [];
end


methods  % constructor block
  function this = arbgrpdelaymeas(hfilter, varargin)
    %ARBGRPDELAYMEAS Construct an ARBGRPDELAYMEAS object.


    narginchk(1,inf);
    removeFreqPointFlag = false;
    % this = fdesign.arbgrpdelaymeas;

    % Parse the inputs.
    if length(varargin) > 1
      F = varargin{2};
      if length(F) < 2
        % grpdelay only supports 2 or more frequency points, so add a dummy
        % point instead of returning an error. Remove the point after
        % measuring.
        F = [0 F];
        removeFreqPointFlag = true;
      end  
      varargin(2) = [];
      minfo = parseconstructorinputs(this, hfilter, varargin{:});
    else
      minfo = parseconstructorinputs(this, hfilter, varargin{:});
      F = minfo.Frequencies;
    end

    if this.NormalizedFrequency
      Fs = 2;
    else
      Fs = this.Fs; 
    end

    % Measure the arbitrary magnitude filter.
    this.Frequencies = F;
    this.TotalGroupDelay = grpdelay(hfilter,this.Frequencies,Fs);
    this.TotalGroupDelay = this.TotalGroupDelay(:).';
    this.NomGrpDelay = minfo.NomGrpDelay;
    % Convert to seconds if normalized frequency is false
    if ~this.NormalizedFrequency
      this.TotalGroupDelay = this.TotalGroupDelay/Fs;
      this.NomGrpDelay = this.NomGrpDelay/Fs;
    end

    if removeFreqPointFlag
      this.TotalGroupDelay = this.TotalGroupDelay(2);
      this.Frequencies = this.Frequencies(2);
    end




  end  % arbgrpdelaymeas

end  % constructor block

methods 
  function set.Frequencies(obj,value)
  obj.Frequencies = value;
  end
  %------------------------------------------------------------------------
  function set.TotalGroupDelay(obj,value)
  obj.TotalGroupDelay = value;
  end
  %------------------------------------------------------------------------
  function set.NomGrpDelay(obj,value)
  obj.NomGrpDelay = value;
  end

end   % set and get functions 

methods  % public methods
  props2norm = getprops2norm(this)
  setprops2norm(this,props2norm)
end  % public methods 

end  % classdef

