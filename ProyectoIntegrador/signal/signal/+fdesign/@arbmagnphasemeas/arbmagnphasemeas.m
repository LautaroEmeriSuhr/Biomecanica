classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) arbmagnphasemeas < fdesign.abstractmeas
%ARBMAGNPHASEMEAS  Construct an ARBMAGNPHASEMEAS object.

%   Copyright 2004-2015 The MathWorks, Inc.    
  
%fdesign.arbmagnphasemeas class
%   fdesign.arbmagnphasemeas extends fdesign.abstractmeas.
%
%    fdesign.arbmagnphasemeas properties:
%       NormalizedFrequency - Property is of type 'bool' (read only) 
%       Fs - Property is of type 'mxArray' (read only) 
%       Frequencies - Property is of type 'mxArray' (read only) 
%       FreqResponse - Property is of type 'mxArray' (read only) 
%
%    fdesign.arbmagnphasemeas methods:
%       getprops2norm -   Get the props2norm.
%       setprops2norm -   Set the props2norm.


properties (SetAccess=protected, AbortSet, SetObservable, GetObservable)
  %FREQUENCIES Property is of type 'mxArray' (read only)
  Frequencies = [];
  %FREQRESPONSE Property is of type 'mxArray' (read only)
  FreqResponse = [];
end


methods  % constructor block
  function this = arbmagnphasemeas(hfilter, varargin)
    %ARBMAGNPHASEMEAS Construct an ARBMAGNPHASEMEAS object.


    narginchk(1,inf);
    % this = fdesign.arbmagnphasemeas;

    normFlag = false;
    removeFreqPointFlag = false;

    % Parse the inputs.
    if length(varargin) > 1
      % Expect specified frequencies to be correctly normalized if a sampling
      % frequency has been specified in the design.
      F = varargin{2};  
      if length(F) < 2
        % Freqz only supports 2 or more frequency points, so add a dummy point
        % instead of returning an error. Remove the point after measuring.
        F = [0 F];
        removeFreqPointFlag = true;
      end
      varargin(2) = [];
      parseconstructorinputs(this, hfilter, varargin{:});
    else
      % minfo always returns normalized frequencies
      minfo = parseconstructorinputs(this, hfilter, varargin{:});
      F = minfo.Frequencies;
      normFlag = true; 
    end
    if this.NormalizedFrequency
      Fs = 2;
    else
      Fs = this.Fs;
    end

    if normFlag
       F = F*Fs/2;
    end
    this.Frequencies = F;

    % Measure the arbitrary magnitude filter.
    this.FreqResponse = freqz(hfilter,F,Fs);

    if removeFreqPointFlag
      this.Frequencies = this.Frequencies(2);
      this.FreqResponse = this.FreqResponse(2);
    end



  end  % arbmagnphasemeas

end  % constructor block

methods 
  function set.Frequencies(obj,value)
  obj.Frequencies = value;
  end
  %------------------------------------------------------------------------
  function set.FreqResponse(obj,value)
  obj.FreqResponse = value;
  end

end   % set and get functions 

methods  % public methods
  props2norm = getprops2norm(this)
  setprops2norm(this,props2norm)
end  % public methods 

end  % classdef

