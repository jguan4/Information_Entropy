function [v,i,p] = vc_post_new(vin,iin,period)
vml = ml_post(vin,period);
iml = ml_post(iin,period);
pml = ml_post(vin.*iin,period);
v = abs(vml)*12/3.92;
i = abs(iml)*1.2000e-05/3.88;
p = abs(pml)*(1.2000e-05/3.88)*(12/3.92);
return