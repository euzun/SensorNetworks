$Offlisting
$Set nodec 73
Set i /n1 * n%nodec%/;
Alias (i,j,k);

Scalar
repeatLoop /0/
Rmax maximum R /82.91/
derr /2/
Mp packet size /255/
Mh packet overhead /25/
Md packet payload /230/
Ma packet ack /20/

pBer bit error rate /1e-4/
pDs data packet success rate
pDf data packet failure rate
pAs ack packet success rate
pAf ack packet failure rate

pHSs handshake packet success rate
pHSf handshake packet failure rate

Trnd duration of one round /10/
Tslot slot time /58e-3/
Epp packet processing energy dissipation /120e-6/
Eda data acquisition energy /600e-6/
Epsilon /38400/
Gamma /1.7/
angle /30/
angleNode /30/
Prx reception power
loopStart /0/
angleLoop /0/
ang /0/
shift /0/
insideIndex /2/
Pslp sleep mode power consumption /30e-6/
Tda data acquisition time /20e-3/
;

Rmax=Rmax+derr;
Prx=(35.4e-3);
Mp=Mp*8;
Mh=Mh*8;
Md=Md*8;
Ma=Ma*8;

pDs=(1-pBer)**(Mp);
pDf=1-pDs;
pAs=(1-pBer)**(Ma);
pAf=1-pAs;

pHSs=pDs*pAs;
pHSf=pDf*pAf;
execseed=gmillisec(jnow);
option iterlim=800000000;
option reslim=1000000000000;
option solprint=off;
option bratio=1;
option threads=8;
option lp=XPRESS;

Parameters

d(i,j) distance
Ptx(i,j) transmission energy
EPtxMP(i,j) energy dissipation of transmitting Mp
EPtxMA(i,j) energy dissipation of transmitting Ma
EHStx(i,j) total energy dissipation of a transmitter in a slot
EDtx(i,j) equation 14
EHSsrx(j,i) successful handshake
EHSfrx(j,i) fail handshake
EDrx(j,i) equation 17
a(i) angle
r(i) radius
alpha(i,j)
;

Variable
t  lifetime;

Positive Variables
f(i,j,k) Kflow
g(i,j) flow
Inter(i,j,k) interference function
Etx(i) transmission energy dissipation
Erx(i) reception energy dissipation
Eslp(i) sleep mode energy dissipation
Tbsy(i) busy time
;

Equations
noFlow(i,j,k)  no flow
cons3(i)
cons4(i)
flowBalance(i,j) flow balance
cons6(i,j)
cons7(i,j)
cons19(i)
perSource(i,j,k)
cons8(i,j)
maxdistance(i,j) maximum distance
cons20(i,j,k)
cons21(i,j,k)
energyConstraint(i) energy constraint
busyTime(i)
transmissionEnergy(i)
receptionEnergy(i)
sleepEnergy(i)
;

noFlow(i,j,k)$(ord(i)=ord(j))..                                                  f(i,j,k) =e= 0;
cons3(i)$(ord(i)>1)..                                                            sum(j,f(i,j,i))=e= t;
cons4(i)$(ord(i)>1)..                                                            sum(j$(ord(j) > 1),f(j,i,i))=e= 0;
flowBalance(i,j)$((ord(i) <> ord(j)) and (ord(i)>1) and (ord(j)>1))..            sum(k,f(i,k,j)) =e= sum(k$(ord(k) > 1),f(k,i,j));
cons6(i,j)$((ord(j)>1) and (ord(i)=1))..                                         sum(k$(ord(k) > 1),f(k,i,j)) =e= t;
cons7(i,j)$((ord(j)>1) and (ord(i)=1))..                                         sum(k$(ord(k) > 1),f(i,k,j))=e= 0;
perSource(i,j,k)$((ord(j)>1)and (alpha(k,j) > angle/2))..                        f(i,j,k) =e= 0;
cons8(i,j)$((ord(i)>1))..                                                        sum(k$(ord(k) > 1),f(i,j,k))=e=g(i,j);
maxdistance(i,j)$(d(i,j)>Rmax)..                                                 g(i,j) =e= 0;
cons20(i,j,k)$((ord(j)>1)and ((Gamma*d(j,k)) ge d(k,i)))..                       Inter(i,j,k)=e=g(j,k);
cons21(i,j,k)$((ord(j)>1)and ((Gamma*d(j,k)) < d(k,i)))..                        Inter(i,j,k)=e=0;
cons19(i)..                                                                      t*Trnd=g=(Tslot/pHSs)*( sum(j,g(i,j))+sum(j$(ord(j)>1),g(j,i)) +sum(j$(ord(j)>1),sum(k,Inter(i,j,k))) );
busyTime(i)$(ord(i)>1)..                                                         Tbsy(i)=e=(Tslot/pHSs)*( sum(j,g(i,j))+sum(j$(ord(j)>1),g(j,i)) )  + t*Tda;
sleepEnergy(i)$(ord(i)>1)..                                                      Eslp(i)=e=Pslp*(t*Trnd-Tbsy(i));
transmissionEnergy(i)$(ord(i)>1)..                                               Etx(i)=e=sum(j,g(i,j)*EDtx(i,j));
receptionEnergy(i)$(ord(i)>1)..                                                  Erx(i)=e=sum(j$(ord(j)>1),g(j,i)*EDrx(j,i));
energyConstraint(i)$(ord(i)>1)..                                                 25000=g=Etx(i)+Erx(i)+t*Eda+Eslp(i);


Model maxlife /all/;


file sonuc /C:\WSN\2_MODEL%nodec%.txt/;
file energyDis /C:\WSN\2_MODEL%nodec%_ED.txt/;
file lifetime /C:\WSN\2_MODEL%nodec%_LT.txt/;


for(repeatLoop=1 to 100 by 1,
shift = round((card(i)-1)/12);

for (loopStart=1 to 12 by 1,
         for(insideIndex=(loopStart-1)*shift+1 to (loopStart-1)*shift+shift by 1,

                 ang = angleNode*sqrt(uniform(0,1));
                 ang$(ang eq 0) = 1;
                 a(i)$(ord(i) = insideIndex+1)=ceil(ang+(angleNode*(loopStart-1)));
                 r(i)$(ord(i) = insideIndex+1)=90*sqrt(uniform(0,1));
         );
);

a(i)$(ord(i) = 1)=0;
r(i)$(ord(i) = 1)=0;
alpha(i,j)$(abs(a(i)-a(j)) > 180) = 360-abs(a(i)-a(j));
alpha(i,j)$(abs(a(i)-a(j)) le 180) = abs(a(i)-a(j));
d(i,j) =sqrt(sqr(abs(sin(a(i))*r(i)-sin(a(j))*r(j)))+sqr(abs(cos(a(i))*r(i)-cos(a(j))*r(j))));

         Ptx(i,j)$(d(i,j) gt 82.92+derr)=100000000000;
         Ptx(i,j)$((d(i,j) le 82.92+derr)and(d(i,j) gt 78.22-derr))=76.2e-3;
         Ptx(i,j)$((d(i,j) le 78.22+derr)and(d(i,j) gt 73.79-derr))=63.9e-3;
         Ptx(i,j)$((d(i,j) le 73.79+derr)and(d(i,j) gt 69.61-derr))=57.6e-3;
         Ptx(i,j)$((d(i,j) le 69.61+derr)and(d(i,j) gt 65.67-derr))=55.5e-3;
         Ptx(i,j)$((d(i,j) le 65.67+derr)and(d(i,j) gt 61.95-derr))=51.6e-3;
         Ptx(i,j)$((d(i,j) le 61.95+derr)and(d(i,j) gt 58.44-derr))=50.4e-3;
         Ptx(i,j)$((d(i,j) le 58.44+derr)and(d(i,j) gt 55.13-derr))=47.4e-3;
         Ptx(i,j)$((d(i,j) le 55.13+derr)and(d(i,j) gt 52.01-derr))=45.3e-3;
         Ptx(i,j)$((d(i,j) le 52.01+derr)and(d(i,j) gt 49.07-derr))=43.6e-3;
         Ptx(i,j)$((d(i,j) le 49.07+derr)and(d(i,j) gt 46.29-derr))=43.5e-3;
         Ptx(i,j)$((d(i,j) le 46.29+derr)and(d(i,j) gt 43.67-derr))=41.4e-3;
         Ptx(i,j)$((d(i,j) le 43.67+derr)and(d(i,j) gt 41.19-derr))=33.3e-3;
         Ptx(i,j)$((d(i,j) le 41.19+derr)and(d(i,j) gt 38.86-derr))=32.4e-3;
         Ptx(i,j)$((d(i,j) le 38.86+derr)and(d(i,j) gt 36.66-derr))=31.8e-3;
         Ptx(i,j)$((d(i,j) le 36.66+derr)and(d(i,j) gt 34.58-derr))=31.2e-3;
         Ptx(i,j)$((d(i,j) le 34.58+derr)and(d(i,j) gt 32.62-derr))=30.3e-3;
         Ptx(i,j)$((d(i,j) le 32.62+derr)and(d(i,j) gt 30.78-derr))=29.7e-3;
         Ptx(i,j)$((d(i,j) le 30.78+derr)and(d(i,j) gt 29.03-derr))=29.1e-3;
         Ptx(i,j)$((d(i,j) le 29.03+derr)and(d(i,j) gt 27.39-derr))=28.5e-3;
         Ptx(i,j)$((d(i,j) le 27.39+derr)and(d(i,j) gt 25.84-derr))=27.9e-3;
         Ptx(i,j)$((d(i,j) le 25.84+derr)and(d(i,j) gt 24.38-derr))=27.8e-3;
         Ptx(i,j)$((d(i,j) le 24.38+derr)and(d(i,j) gt 22.99-derr))=27.3e-3;
         Ptx(i,j)$((d(i,j) le 22.99+derr)and(d(i,j) gt 21.69-derr))=27.1e-3;
         Ptx(i,j)$((d(i,j) le 21.69+derr)and(d(i,j) gt 20.46-derr))=27.0e-3;
         Ptx(i,j)$((d(i,j) le 20.46+derr)and(d(i,j) gt 19.30-derr))=26.4e-3;
         Ptx(i,j)$(d(i,j) le 19.30+derr)=25.8e-3;

         EPtxMP(i,j)=Ptx(i,j)*(Mp/Epsilon);
         EPtxMA(i,j)=Ptx(i,j)*(Ma/Epsilon);

         EHStx(i,j)=EPtxMP(i,j)+Prx*(Tslot-(Mp/Epsilon));


         EDtx(i,j)=(1/pHSs)*EHStx(i,j) + Epp;

         EHSsrx(j,i)=Prx*(Tslot-(Ma/Epsilon))+EPtxMA(i,j);

         EHSfrx(j,i)=Prx*Tslot;

         EDrx(j,i)= EHSsrx(j,i)+(1/pHSs)*(pDs*pAf*EHSsrx(j,i)+pDf*EHSfrx(j,i))+Epp;


         option kill=EPtxMP;
         option kill=EPtxMA;
         option kill=EHStx;
         option kill=EHSsrx;
         option kill=EHSfrx;




for(angleLoop=1 to 2 by 1,
         angle $(angleLoop eq 1)=45;
         angle $(angleLoop eq 2)=180;



         Solve maxlife using lp maximizing t;
         put sonuc;

         put (Eda*1000):16:16/;
         if(t.l gt 0,
                 put (sum(i,Etx.l(i))*1000/((%nodec%-1)*t.l) ):16:16 /;
                 put (sum(i,Erx.l(i))*1000/((%nodec%-1)*t.l) ):16:16 /;
                 put (sum(i,Eslp.l(i))*1000/((%nodec%-1)*t.l) ):16:16 /;
         else
                 put 0/;
                 put 0/;
                 put 0/;
         );


         put lifetime;
         put t.l:16:16/;

         put energyDis;
         loop(i,
                 if(ord(i) gt 1,
                         put  (Eda*(t.l) + Etx.l(i) + Erx.l(i) + Eslp.l(i)):16:16/;
                 );

         );

);
);
