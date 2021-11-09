# Transfer schemes
* *neigh_list* uses **managed memory** and has the length of total GPU number. This is because the do loop use it can pass the non-neighbor quickly. However, if we compact is with pure neighbors, there should be extra work. But we can think carefully about this to choose the best way.  
* We label the destination of particles which will be transferred by attribute (13+2\*nind) of P. It saves the rank of the destination.  
## One by one transfer
## Packed transfer
###### compaction after each transfer for a neighbor
###### compaction after transfers for all neighbors
## Separation
## Other notes
loop.txt is just for residual of previous code.
