# Cards2-CSP
CSP in MiniZinc che risolve il problema Cards2

Considerare il seguente problema combinatorio: è data una collezione Cards di carte (ad
es., da gioco) in cui ad ogni carta è associato un intero. La collezione è costituita da
N > 0 carte con valori tra 1 e M > 0.
Vogliamo disporre in fila le N carte di modo che la sequenza di interi ottenuta leggendo le carte da sinistra a destra sia, nell’ordine: (i) strettamente crescente; (ii) strettamente decrescente; (iii) strettamente crescente; (iv) strettamente decrescente.
Inoltre, le due carte al termine dei tratti della sequenza di cui ai punti (i) e (iii)
(ovvero i massimi locali della sequenza) siano a distanza (valore assoluto della differenza
tra i valori delle loro posizioni) D > 0 (un ulteriore parametro).
