 % GSSM_GLM  Generalized state space model for Spatio-temporal GLM 

%===============================================================================================
function [varargout] = model_interface(func, varargin)

  switch func
    %--- Initialize GSSM data structure --------------------------------------------------------
    case 'init'
      model = init(varargin);
        error(consistent(model,'gssm'));               % check consistentency of initialized model
      varargout{1} = model;
    %--------------------------------------------------------------------------------------------
    otherwise
      error(['Function ''' func ''' not supported.']);
  end





%===============================================================================================
function model = init(init_args)

L=init_args{1};  %Lead field
nMeas=size(L,1);
nX=size(L,2);

model.type = 'gssm';                       % object type = generalized state space model
model.tag  = 'GSSM_recon';                   % ID tag

model.ffun_type = 'lti';                   % state transition function type  : linear time invariant
model.hfun_type = 'lti';                   % state observation function type : linear time invariant

model.ffun       = @ffun;                  % file handle to FFUN
model.hfun       = @hfun;                  % file handle to HFUN
model.prior      = @prior;                 % file handle to PRIOR
model.likelihood = @likelihood;            % file handle to LIKELIHOOD
model.linearize  = @linearize;             % file handle to LINEARIZE
model.setparams  = [];             % file handle to SETPARAMS

model.statedim   = nX;                     %   state dimension
model.obsdim     = nMeas;                  %   observation dimension
model.paramdim   = 0;                      %   parameter dimension
model.U1dim      = 0;                      %   exogenous control input 1 dimension
model.U2dim      = 0;                      %   exogenous control input 2 dimension
model.Vdim       = nX;                     %   process noise dimension
model.Ndim       = nMeas;                  %   observation noise dimension

model.L=sparse(L);
model.A=speye(model.statedim);
  
Arg.type = 'gaussian';
Arg.cov_type = 'full';
Arg.dim = model.Vdim;
Arg.mu = zeros(model.statedim,1);
Arg.cov  = 1E-3*eye(model.statedim);
model.pNoise  = gennoiseds(Arg);   % process noise : zero mean white Gaussian noise , cov=0.001

Arg.type = 'gaussian';
Arg.cov_type = 'full';
Arg.dim = model.Ndim;
Arg.mu = zeros(model.obsdim,1);
Arg.cov  = .5*eye(model.obsdim);
model.oNoise     = gennoiseds(Arg); % observation noise : zero mean white Gaussian noise, cov=0.2
model.params     = [];


%===============================================================================================
function new_state = ffun(model, state, V, U1)
%Random walk update on the states
new_state = model.A*state;
if ~isempty(V)
    new_state = new_state + V;
end


%===============================================================================================
function tranprior = prior(model, nextstate, state, U1, pNoiseDS)
X = nextstate - ffun(model, state, [], U1);
tranprior = feval(pNoiseDS.likelihood, pNoiseDS, X(1,:));

  
  
%===============================================================================================
function observ = hfun(model, state, N, k)
observ=model.L*state(:);

if ~isempty(N)
    observ = observ + N;
end




%===============================================================================================
function llh = likelihood(model, obs, state, k, oNoiseDS)

X = obs - hfun(model, state, [], k);
llh = feval(oNoiseDS.likelihood, oNoiseDS, X);


%===============================================================================================
function out = linearize(model, state, V, N, U1, k, term, index_vector)

  if (nargin<7)
    error('[ linearize ] Not enough input arguments!');
  end

  %--------------------------------------------------------------------------------------
  switch (term)

    case 'A'
      %%%========================================================
      %%%             Calculate A = df/dstate
      %%%========================================================
      out = model.A;

    case 'B'
      %%%========================================================
      %%%             Calculate B = df/dU1
      %%%========================================================
      out =0;

    case 'C'
      %%%========================================================
      %%%             Calculate C = dh/dx
      %%%========================================================
      
     out=model.L;  

    case 'D'
      %%%========================================================
      %%%             Calculate D = dh/dU2
      %%%========================================================
      out = 0;

    case 'G'
      %%%========================================================
      %%%             Calculate G = df/dv
      %%%========================================================
      out = speye(model.statedim);

    case 'H'
      %%%========================================================
      %%%             Calculate H = dh/dn
      %%%========================================================
      out = speye(model.obsdim);

    case 'JFW'
      %%%========================================================
      %%%             Calculate  = dffun/dparameters
      %%%========================================================
      out = [];


    case 'JHW'
      %%%========================================================
      %%%             Calculate  = dhfun/dparameters
      %%%========================================================
      out = [];

    otherwise
      error('[ linearize ] Invalid model term requested!');

  end

  if (nargin==8), out = out(:,index_vector); end

  %--------------------------------------------------------------------------------------