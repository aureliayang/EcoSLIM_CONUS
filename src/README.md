# Input file (for users)
* **runname,** EcoSLIM run name
* **pname,** Path of ParFlow files
* **DEMname,** pfb file name of DEM
* **nx,** Dimension in x direction
* **ny,** Dimension in y direction
* **nz,** Dimension in z direction
* **nCLMsoil,** Layers coupled between CLM an ParFlow
* **ppx,** Split in x direction
* **qqy,** Split in y direction
* **transfer,** Transfer scheme; options are 0, 1, 2; 0 is no transfer, 1 is transfer with separation, 2 is transfer without separation
* **separate,** Separate or not
* **np_ic,** Number o particle per cell at the start of simulation
* **np,** Maximum number permitted during run time 
* **dx,** grid-cell size in x direction
* **dy,** grid-cell size in y direction
* **dz,** grid-cell size in z direction from bottom to top, separated by comma
* **pfdt,** ParFlow dt, need double-check in the code for mass balance
* **pft1,** ParFlow start time
* **pft2,** ParFlow end time
* **tout1,** EcoSLIM start number; it is 0 for cold start; it is the last completed timestep for hot start
* **n_cycle,** The cycles to use the ParFlow files
* **add_f,** The time interval to add particles
* **ipwrite,**
* **ibinpntswrite,**
* **etwrite,**
* **icwrite,**
* **V_mult,**
* **clmtrans,**
* **clmfile,**
* **iflux_p_res,**
* **denh2o,**
* **moldiff,**
* **dtfrac,**
* **nind,**
* **Indname,**
# Transfer schemes (for dev)
* **neigh_list** uses *managed memory* and has the length of total number of GPUs. This is because the do loop using it can skip the non-neighbor quickly. However, if we compact it with pure neighbors, there should be extra work. We can think carefully about this to choose the best way.  
* Label the destination of particles which will be transferred by P(ii,13+2\*nind), where ii is the number of particle. It saves the rank of the destination. It is the original pid attribute, but after using mpi and transfer, there is no sense for this attribute anymore. We can try to rebuild *pid* attribute later.  
## One by one transfer
* adding **if condition** and **atomic operation** to calculate the number of particles which will be transferred to each neighbor
* put **N_send** array in **managed memory**
* send each **N_send** element to the corresponding neighbor 
* copy P(ii,13+2\*nind) back to CPU 
* use P(ii,13+2\*nind) to do the do loop
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


