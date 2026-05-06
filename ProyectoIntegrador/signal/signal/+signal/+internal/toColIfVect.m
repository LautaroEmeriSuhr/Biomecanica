%--------------------------------------------------------------------------
function colvec = toColIfVect(vec)
% Convert vect to a column vector if it is a rowvector, maintaining
% complexity. This is different than calling vec(:) in two ways: 1)
% matrices stay as matrices and 2) complex vectors with zero imaginary
% part stay imaginary.
  if(isvector(vec)) && size(vec,1)==1
    colvec = vec.';
  else
    colvec = vec;
  end