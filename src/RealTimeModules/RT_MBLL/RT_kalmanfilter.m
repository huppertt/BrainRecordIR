function  [kalmanparam, state]=RT_kalmanfilter(currentdata,kalmanparam);
   
A=kalmanparam.F;
C=kalmanparam.H;

xh_k=A*kalmanparam.xk;
ph_k=A*kalmanparam.pk*A'+kalmanparam.Q;
G = ph_k*C'*inv(C*ph_k*C'+kalmanparam.R);

kalmanparam.xk=xh_k+G*(currentdata-C*xh_k);

kalmanparam.pk=(eye(size(xh_k,1))-G*C)*ph_k;

state=kalmanparam.xk;

return

