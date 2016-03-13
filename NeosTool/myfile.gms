Set i nodes /n1*n4/;

Alias (i,j);

Scalar
         EAmp  /100e-12/
         EElec /50e-9/
         s packet generation rate at node /1/
         energy /2/
         Prx reception energy;

Prx = EElec;

Parameters
         d(i,j) distance
         Ptx(i,j) transmission energy;

         d(i,j) = abs(ord(i)-ord(j));
         Ptx(i,j) = EElec + EAmp*sqr(d(i,j))*sqr(d(i,j));

Variables
         t Lifetime;

Positive Variables
         f(i,j) flow;

Equations
         noFlow(i,j)  no flow
         flowBalance(i) flow balance
         energyConstraint(i) energy constraint
         maxdistance(i,j);

         noFlow(i,j)$(ord(i)=ord(j))..                   f(i,j) =e= 0;
         flowBalance(i)$(ord(i)>1)..                     sum(j,f(i,j))  =e= sum(j,f(j,i)) + s*t;
         energyConstraint(i)$(ord(i)>1)..                energy =g= sum(j,f(i,j)*Ptx(i,j)) + Prx*sum(j,f(j,i));
         maxdistance(i,j)$(ord(i)>ord(j)+4)..            f(i,j) =e= 0;

Model maxlife /noFlow,flowBalance,energyConstraint/;

Solve maxlife using lp maximizing t;

*file sonuc /C:\sonuc.txt/;

*put sonuc;

display t.l;


