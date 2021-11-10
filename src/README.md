# Transfer schemes
* **neigh_list** uses *managed memory* and has the length of total GPU number. This is because the do loop use it can pass the non-neighbor quickly. However, if we compact is with pure neighbors, there should be extra work. But we can think carefully about this to choose the best way.  
* Label the destination of particles which will be transferred by P(ii,13+2\*nind), where ii is the number of particle. It saves the rank of the destination. It is the original pid, but after using mpi and transfer, there is no sense for this attribute anymore. We ca try to rebuild *pid* attribute later.  
## One by one transfer
* add if condition and atomic operation to calculate the number of particles which will be transferred to each neighbor
* put N_send array in managed memory
* send N_send to each neighbor 
* copy attribute (13+2\*nind) of P back to CPU 
* use (13+2\*nind) to do the do loop
* We need P_send anyway since cuda-aware mpi doesn't support row memory
## Packed transfer
###### compaction after each transfer for a neighbor
* This will shorten the thrustscan length but increase the frequency of compaction
###### compaction after transfers for all neighbors
* This will keep the length of peripherical particles and compact at the end of the send
## Separation
* If we do separation?
* If we rearrange the array or just label the array?
## Others
loop.txt is just for residual of previous code.
