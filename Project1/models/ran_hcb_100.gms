$Offlisting
$Set nodec 101
Set i /n1 * n%nodec%/;
Set rep_count /n1 * n2000/;
Alias (i,j);

Scalar
Rmax maximum R /25/
EAmp  /100e-12/
EElec /50e-9/
s packet generation rate at node /1/
energy /2/
Prx reception energy
n nu value in each loop
;

Prx=EElec;
execseed=gmillisec(jnow);

option iterlim=800000000;
option reslim=1000000000000;
option solprint=off;
option bratio=1;
option threads=8;

Parameters
d(i,j) distance
Ptx(i,j) transmission energy
a(i) angle
r(i) radius;

Variables
t lifetime;

Positive Variables
f(i,j) flow;

Equations
noFlow(i,j)  no flow
flowBalance(i) flow balance
energyConstraint(i) energy constraint
maxdistance(i,j) maximum distance
;

noFlow(i,j)$(ord(i)=ord(j))..                   f(i,j) =e= 0;
flowBalance(i)$(ord(i)>1)..                     sum(j,f(i,j))  =e= sum(j,f(j,i)) + s*t;
energyConstraint(i)$(ord(i)>1)..                energy =g= sum(j,f(i,j)*Ptx(i,j)) + Prx*sum(j,f(j,i));
maxdistance(i,j)$(d(i,j)>Rmax)..                f(i,j) =e= 0;

Model maxlife /all/;

file sonuc /D:\WSN\ran_hcb_%nodec%.txt/;
put sonuc;

loop(rep_count,
        EElec=Prx;
        repeat
        (
                a(i+1)=360*uniform(0,1);
                r(i+1)=50*sqrt(uniform(0,1));
                d(i,j) =sqrt(sqr(abs(sin(a(i))*r(i)-sin(a(j))*r(j)))+sqr(abs(cos(a(i))*r(i)-cos(a(j))*r(j))));
                Ptx(i,j) = Prx + ceil(EAmp*(d(i,j)**2)/EElec)*EElec;
                Solve maxlife using lp maximizing t;
        until(t.l ne 0));

*HCB Continuous Model
        Ptx(i,j) = EElec + EAmp*(d(i,j)**2);
        Solve maxlife using lp maximizing t;
        put t.l:12:12/;

*HCB Discrete Model
        for(n=1 to 10 by 1,
                EElec=n*(50e-9);
                Ptx(i,j) = Prx + ceil(EAmp*(d(i,j)**2)/EElec)*EElec;
                Solve maxlife using lp maximizing t;
                put t.l:12:12/;
        );

        for(n=20 to 100 by 10,
                EElec=n*(50e-9);
                Ptx(i,j) = Prx + ceil(EAmp*(d(i,j)**2)/EElec)*EElec;
                Solve maxlife using lp maximizing t;
                put t.l:12:12/;
        );

        for(n=200 to 1000 by 100,
                EElec=n*(50e-9);
                Ptx(i,j) = Prx + ceil(EAmp*(d(i,j)**2)/EElec)*EElec;
                Solve maxlife using lp maximizing t;
                put t.l:12:12/;
        );

);
