function updatecurrentfdesign(this)
%UPDATECURRENTFDESIGN   Update the current FDesign object.

%   Copyright 2005 The MathWorks, Inc.

% Get the constructor for the current specification type.
cFDesignCon = getconstructor(this);

% If the CurrentSpecs is already correct, just return.
if ~strcmpi(class(this.CurrentFDesign), cFDesignCon),
    % If there are any stored SPEC objects see if our constructor matches.
    allFDesign = this.AllFDesign;
    if isempty(allFDesign) 
      cFDesign = [];
    else    
      if ishandle(allFDesign)
        cFDesign = find(allFDesign, '-class', cFDesignCon); 
      else
        cFDesignCla = arrayfun(@class,allFDesign,'UniformOutput',false);
        cFDesign = allFDesign(strcmp(cFDesignCla,cFDesignCon));
      end
    end
    % If we could not find the needed spec object, create it and store it.
    if isempty(cFDesign),
        cFDesign = feval(cFDesignCon);
        
        % Add smart defaults.
        multiratedefaults(cFDesign, max(getratechangefactors(this)));
        
        this.AllFDesign = [allFDesign; cFDesign];
    end

    % Set the current specs, this will fire the pre-set to update the props.
    this.CurrentFDesign = cFDesign;
    
    l = [event.listener(cFDesign,'FaceChanged',@(~,e) addprops(this, cFDesign)); ...
    event.listener(cFDesign,'FaceChanging',@(~,e) rmprops(this, cFDesign))];
  
    this.SpecificationTypeListeners = l;
end

updatefdesignfactors(this);

% [EOF]
