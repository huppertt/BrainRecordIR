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
T=init_args{2};  %Temporal Basis function
G=init_args{3};  %Spatial Basis function
fs=init_args{4};

nMeas=size(L,1);

model.Frq=[.25 1]*2*pi/fs;

nX=size(G,2)*size(T,2)+size(L,2)*4*length(model.Frq)+nMeas;


  model.type = 'gssm';                       % object type = generalized state space model
  model.tag  = 'GSSM_GLM';                  % ID tag

  model.ffun_type = 'lti';                   % state transition function type  : linear time invariant
  model.hfun_type = 'ltc';                   % state observation function type : linear time variant

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
  model.U2dim      = 1;                      %   exogenous control input 2 dimension
  model.Vdim       = nX;                     %   process noise dimension
  model.Ndim       = nMeas;                  %   observation noise dimension

  cnt=0;  
  for idx=1:size(T,2)  
      model.lstBeta(:,idx)=[1:size(G,2)]+cnt;
      cnt=cnt+size(G,2);
  end
  
  for idx=1:length(model.Frq)
      for idx2=1:4
        model.lstfrq(:,idx,idx2)=[1:size(L,2)]+cnt;
        cnt=cnt+size(L,2);
      end
  end
  
  model.lstDC=[1:nMeas]+cnt;
  
  model.L=sparse(L);
  model.G=G;
  model.T=T;
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
  Arg.cov  = 1E-3*eye(model.obsdim);
  model.oNoise     = gennoiseds(Arg);     % observation noise : zero mean white Gaussian noise, cov=0.2
  model.params     = [];


%===============================================================================================
function new_state = ffun(model, state, V, U1)

% farras: this function remains unchanged. 
% Is U1 used?
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

% To be modified as per 07/01/08 morning conv

Beta=state(model.lstBeta);
DeltaSin=state(model.lstfrq(:,:,1));
DeltaCos=state(model.lstfrq(:,:,2));
PhiSin=0.1*state(model.lstfrq(:,:,3));
PhiCos=0.1*state(model.lstfrq(:,:,4));
DC=state(model.lstDC);

if(isnumeric(model.T))
    Tk=model.T(k,:);
else
    Tk=feval(model.T,k);
end
observ=model.L*(kron(model.G,Tk)*Beta(:)+...
    .1*sum(DeltaSin.*sin((ones(size(model.L,2),1)*model.Frq).*k+PhiSin),2)+...
    .1*sum(DeltaCos.*cos((ones(size(model.L,2),1)*model.Frq).*k+PhiCos),2))+DC;

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
      
     

%       observ=model.L*(kron(model.G,model.T(k,:))*Beta(:)+...
%           sum(DeltaSin.*sin(ones(size(model.L,2),1)*model.Frq.*k+PhiSin),2)+...
%           sum(DeltaCos.*cos(ones(size(model.L,2),1)*model.Frq.*k+PhiCos),2))+DC;

      out=zeros(model.obsdim,model.statedim);  

  
Beta=state(model.lstBeta);
DeltaSin=state(model.lstfrq(:,:,1));
DeltaCos=state(model.lstfrq(:,:,2));
PhiSin=0.1*state(model.lstfrq(:,:,3));
PhiCos=0.1*state(model.lstfrq(:,:,4));
DC=state(model.lstDC);
%         
% for idx=1:size(model.T,2)
%     F0=model.L*(kron(model.G,model.T(k,idx)));
% 
% 
%     for idx2=1:model.obsdim
%         out(idx2,model.lstBeta(idx2,idx))=F0(idx2,idx2);
%     end
% end
%       
%       for idx=1:length(model.Frq)
%         F1=model.L*(sin(model.Frq(idx)*k+PhiSin(idx)));
%         F2=model.L*(cos(model.Frq(idx)*k+PhiCos(idx)));
%         F3=model.L*(DeltaSin(idx).*cos(model.Frq(idx)*k+PhiSin(idx)));
%         F4=-model.L*(DeltaCos(idx).*sin(model.Frq(idx)*k+PhiCos(idx)));
%         
%         for idx2=1:model.obsdim
%             out(idx2,model.lstfrq(idx2,idx,1))=F1(idx2,idx2);
%             out(idx2,model.lstfrq(idx2,idx,2))=F2(idx2,idx2);
%             out(idx2,model.lstfrq(idx2,idx,3))=F3(idx2,idx2);
%             out(idx2,model.lstfrq(idx2,idx,4))=F4(idx2,idx2);
%         end
%         
%       end    
%           
%        for idx2=1:model.obsdim
%             out(idx2,model.lstDC(idx2))=1;
%        end
       

if(isnumeric(model.T))
    Tk=model.T(k,:);
else
    Tk=feval(model.T,k);
end

       out=[];
       
       Fb=model.L*(kron(model.G,Tk));
       out=[out Fb];
       
       for idx=1:length(model.Frq)
            F1=.1*model.L*(sin(model.Frq(idx)*k+PhiSin(idx)));
            out=[out F1];
       end
       
       for idx=1:length(model.Frq)
            F2=.1*model.L*(cos(model.Frq(idx)*k+PhiCos(idx)));
            out=[out F2];
       end
       
       for idx=1:length(model.Frq)
            F3=.1*model.L*(DeltaSin(idx).*cos(model.Frq(idx)*k+PhiSin(idx)));
            out=[out F3];
       end
       for idx=1:length(model.Frq)
            F4=-.1*model.L*(DeltaCos(idx).*sin(model.Frq(idx)*k+PhiCos(idx)));
            out=[out F4];
       end
       out=[out eye(model.obsdim)];
       
       
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