% INPUT
int: N = 7; % numero di carte
int: M = 4; % max cards
int: D = 4; % distanza massimi
array[1..N] of 1..M: Cards = [1,1,2,2,3,3,4];

% VARIABILI
array[1..N] of var 1..N: X;  % X[i] = nuova posizione della Cards i-esima 
var 1..M: CA;  % valore pt. di massimo locale A 
var 1..M: CB;  % valore pt. di minimo locale B
var 1..M: CC;  % valore pt. di massimo locale C
var 1..N: PA;  % nuova pos. pt. di massimo locale A 
var 1..N: PB;  % nuova pos. pt. di minimo locale B
var 1..N: PC;  % nuova pos. pt. di massimo locale C 
var 1..N: IA;  % indice di Cards del pt. A
var 1..N: IB;  % indice di Cards del pt. B
var 1..N: IC;  % indice di Cards del pt. C

%  PUNTI MASSIMO/MINIMO NELLA SOLUZIONE
%
%      A       C
%      4       4
%        3       3
%    2      2      
%  1                1
%           B

% VINCOLI
include "alldifferent.mzn";
constraint alldifferent(X);  % essendo delle posizioni devono essere tutte diverse
constraint PC > PB;  % il pt. di massimo C deve trovarsi dopo il pt. di minimo B
constraint PB > PA;  % il pt. di minimo B deve trovarsi dopo il pt. di massimo A
constraint PC - PA = D;  % come da problema la distanza tra i due massimi deve essere D
constraint PA != 1;  % il primo massimo non può essere in prima posizione
constraint PC != N;  % il secondo massimo non può essere in ultima posizione
constraint CA=Cards[IA] /\ PA = X[IA];
constraint CB=Cards[IB] /\ PB = X[IB];
constraint CC=Cards[IC] /\ PC = X[IC];
constraint forall(i in 1..N) (
  (CA>=Cards[i] \/ (CA=Cards[i] /\ PA=X[i] /\ IA=i))/\  % definisco il primo massimo come il valore maggiore di tutti in Cards, vincolandone anche la nuova posizione e l'indice
  (X[i]=PA \/ (CC>=Cards[i] \/ (CC=Cards[i] /\ PC=X[i] /\ IC=i)))/\  % definisco il secondo massimo come il valore maggiore di tutti in Cards diverso da A, vincolandone anche la nuova pos. e l'indice
  (X[i]>=PC \/ X[i]<=PA \/ Cards[i]>CB \/ (CB=Cards[i] /\ PB=X[i] /\ IB=i)) /\  % definisco il minimo locale tra i due massimi, vincolandone anche la posizione e l'indici
  (X[i]>=PA \/ (X[i]<PA /\ (X[i]=1 \/ forall(j in 1..N)(     % (I) strettamente crescente prima di A,  
     X[j]=X[i] \/ X[j]>X[i]+1 \/ X[j]<X[i]-1 \/              % per ogni carta prima di A la precedente deve essere minore e la successiva maggiore.
     (X[j]<=PA /\ X[j]+1=X[i] /\ Cards[j]<Cards[i]) \/
     (X[j]<=PA /\ X[i]+1=X[j] /\ Cards[i]<Cards[j]) \/
     X[j]>PA)))) /\
  (X[i]<=PC \/ (X[i]>PC /\ (X[i]=N \/ forall(j in 1..N)(     %  (IV) strettamente decrescente dopo C, 
     X[j]=X[i] \/ X[j]>X[i]+1 \/ X[j]<X[i]-1 \/              % per ogni carta dopo C la precedente deve essere maggiore e la successiva minore.
     (X[j]>=PC /\ X[j]+1=X[i] /\ Cards[j]<Cards[i]) \/
     (X[j]>=PC /\ X[i]+1=X[j] /\ Cards[i]<Cards[j]) \/
     X[j]<PC)))) /\
  (X[i]<=PA \/ X[i]>=PC \/ (X[i]>PA /\ X[i]<PC /\ forall(j in 1..N)(     %  (II,III) strettamente decrescente tra A e B, strettamente crescente tra B e C,
     X[j]=X[i] \/ X[j]>X[i]+1 \/ X[j]<X[i]-1 \/                          % per ogni carta tra A e B la precedente deve essere maggiore e la successiva minore,
     (X[j]>=PA /\ X[j]<=PB /\ X[i]+1=X[j] /\ Cards[j]<Cards[i]) \/       % per ogni carta tra B e C la precedente deve essere minore e la successiva maggiore.
     (X[j]>=PA /\ X[j]<=PB /\ X[i]-1=X[j] /\ Cards[j]>Cards[i]) \/
     (X[j]>=PB /\ X[j]<=PC /\ X[i]+1=X[j] /\ Cards[j]>Cards[i]) \/
     (X[j]>=PB /\ X[j]<=PC /\ X[i]-1=X[j] /\ Cards[j]<Cards[i]) \/
     X[j]>PC \/ X[j]<PA)))
  );
  
array[1..N] of var 1..M: Cards2;  % nuova lista di Carte necessaria per la stampa
constraint forall(i in 1..N)(
  forall(j in 1..N)(
    if X[j] == i then
      Cards2[i] = Cards[j]  % in Cards2[1] vincolo il valore di Cards[i] per il quale X[i]=1,
      endif                 % in Cards2[2] vincolo il valore di Cards[i] per il quale X[i]=2, ecc.. fino ad N
    )
  );  
 
solve satisfy;
  
% STAMPA

output["\nCarte riordinate: \n"];
output[show(Cards2[i]) ++ " "| i in 1..N];
