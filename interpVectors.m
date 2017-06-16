% interpVectors
%
% A: (matrix(p,2)) contains two sets of data
% N: final number of samples

function B = interpVectors(A, N)

%% prep
p = size(A,1); % number of poles
b = ones(p, N); % output
steep = 0; offset = 0;

%% LOOP
for i = 1:p,
  % compute interpolating parameter
  steep = ( A(i,2) - A(i,1) ) / ( N -1 );
  offset= A(i, 1); 

  % Interpolation
  for j = 1 : N,  
    b(i,j) = steep*j + offset;
  end
end

%% END
B = b;
