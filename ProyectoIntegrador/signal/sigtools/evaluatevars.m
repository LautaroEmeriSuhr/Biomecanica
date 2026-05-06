function [vals, errStr, mssgObj] = evaluatevars(strs, name)
%EVALUATEVARS   Evaluate variables in the MATLAB workspace.
%
%   EVALUATEVARS will take a string (or cell array of strings)
%   representing filter coefficients or the Sampling frequency and evaluate 
%   it in the base MATLAB workspace. If the variables exist and are numeric, the 
%   workspace variables values are returned in VALS, if they do not exist, an 
%   error dialog is launched and the error message is returned in ERRSTR. 
%
%   Input:
%     strs   - String or cell array of strings from edit boxes
%     names  - String or cell array of names for the edit boxes.  This
%              allows EVALUATEVARS to give customized error messages if the
%              editboxes are empty.  If this input is not given a generic
%              message 'Editboxes cannot be empty.' will be given.  If this
%              input is empty it will be ignored.
%
%   Outputs:
%     vals    - Values returned after evaluating the input strs in the
%               MATLAB workspace.
%     errStr  - Error string returned if evaluation failed.
%     mssgObj - Message object

%   Author(s): R. Losada, P. Costa
%   Copyright 1988-2005 The MathWorks, Inc.

errStr = '';
mssgObj = [];
vals = {};

if  iscell(strs)
    for n = 1:length(strs), % Loop through strings
        if ~isempty(strs{n}),
            try
                vals{n} = evalin('base',['[',strs{n},']']);
                % Check that vals is a numeric array and not a string.
                if ~isnumeric(vals{n})
                  mssgObj = message('signal:evaluatevars:NotNumeric',strs{n});       
                  errStr= getString(mssgObj);
                end     
            catch
                mssgObj = message('signal:evaluatevars:NotDefined',strs{n});
                errStr= getString(mssgObj);
                break;
            end
        else
            if nargin > 1 & ~isempty(name{n})
              mssgObj = message('signal:evaluatevars:EmptyEditBox',name{n});
              errStr = getString(mssgObj);
            else
              mssgObj = message('signal:evaluatevars:EmptyEditBoxes');
              errStr = getString(mssgObj);
            end
            break;
        end 
    end
else
    if ~isempty(strs),
        try
            vals = evalin('base',['[',strs,']']);
            if ~isnumeric(vals)             
              mssgObj = message('signal:evaluatevars:NotNumeric',strs);       
              errStr= getString(mssgObj);              
            end
        catch
            mssgObj = message('signal:evaluatevars:NotDefined',strs);
            errStr= getString(mssgObj);            
        end
    else
        if nargin > 1 & ~isempty(name)
            mssgObj = message('signal:evaluatevars:EmptyEditBox',name);
            errStr = getString(mssgObj);          
        else
            mssgObj = message('signal:evaluatevars:EmptyEditBoxes');
            errStr = getString(mssgObj);
        end
    end
end

if nargout < 2,
    if ~isempty(errStr), error(mssgObj); end % Top level try catch will display the error dialog.
end

% [EOF] evaluatevars.m
