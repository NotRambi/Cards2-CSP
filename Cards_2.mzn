% INPUT
int: N = 7; % numero di carte
int: M = 4; % max cards
int: D = 4; % distanza massimi
array[1..N] of var 1..M: Cards = [1,1,2,2,3,3,4];

% VARIABILI
array[1..N] of var 1..N: X;
var 1..M: CA;
var 1..M: CB;
var 1..M: CC; 
var 1..N: PA;
var 1..N: PB;
var 1..N: PC;
var 1..N: IA;
var 1..N: IB;
var 1..N: IC;

% VINCOLI
include "alldifferent.mzn";
constraint alldifferent(X);
constraint PC > PB;
constraint PB > PA;
constraint PC - PA = D;
constraint PA != 1;
constraint PC != N;
constraint CA=Cards[IA] /\ PA = X[IA];
constraint CB=Cards[IB] /\ PB = X[IB];
constraint CC=Cards[IC] /\ PC = X[IC];
constraint forall(i in 1..N) (
  (CA>=Cards[i] \/ (CA=Cards[i] /\ PA=X[i] /\ IA=i))/\  % pos first max
  (X[i]=PA \/ (CC>=Cards[i] \/ (CC=Cards[i] /\ PC=X[i] /\ IC=i)))/\  % pos second max
  (X[i]>=PC \/ X[i]<=PA \/ Cards[i]>CB \/ (CB=Cards[i] /\ PB=X[i] /\ IB=i)) /\  % pos minimo locale
  (X[i]>=PA \/ (X[i]<PA /\ (X[i]=1 \/ forall(j in 1..N)( % stret. cresc.
     X[j]=X[i] \/ X[j]>X[i]+1 \/ X[j]<X[i]-1 \/
     (X[j]<=PA /\ X[j]+1=X[i] /\ Cards[j]<Cards[i]) \/
     (X[j]<=PA /\ X[i]+1=X[j] /\ Cards[i]<Cards[j]) \/
     X[j]>PA)))) /\
  (X[i]<=PC \/ (X[i]>PC /\ (X[i]=N \/ forall(j in 1..N)( % stret. decresc.
     X[j]=X[i] \/ X[j]>X[i]+1 \/ X[j]<X[i]-1 \/
     (X[j]>=PC /\ X[j]+1=X[i] /\ Cards[j]<Cards[i]) \/
     (X[j]>=PC /\ X[i]+1=X[j] /\ Cards[i]<Cards[j]) \/
     X[j]<PC)))) /\
  (X[i]<=PA \/ X[i]>=PC \/ (X[i]>PA /\ X[i]<PC /\ forall(j in 1..N)( % stret. decresc. e stret. cresc.
     X[j]=X[i] \/ X[j]>X[i]+1 \/ X[j]<X[i]-1 \/
     (X[j]>=PA /\ X[j]<=PB /\ X[i]+1=X[j] /\ Cards[j]<Cards[i]) \/
     (X[j]>=PA /\ X[j]<=PB /\ X[i]-1=X[j] /\ Cards[j]>Cards[i]) \/
     (X[j]>=PB /\ X[j]<=PC /\ X[i]+1=X[j] /\ Cards[j]>Cards[i]) \/
     (X[j]>=PB /\ X[j]<=PC /\ X[i]-1=X[j] /\ Cards[j]<Cards[i]) \/
     X[j]>PC \/ X[j]<PA)))
  );
  
array[1..N] of var 1..M: Cards2;
constraint forall(i in 1..N)(
  forall(j in 1..N)(
    if X[j] == i then
      Cards2[i] = Cards[j]
      endif
    )
  );  
 
solve satisfy;
  
% STAMPA

output["\nCarte riordinate: \n"];
output[show(Cards2[i]) ++ " "| i in 1..N];