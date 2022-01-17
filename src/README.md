# Input file 
* **runname,** EcoSLIM run name
* **pname,** Path of ParFlow files
* **DEMname,** pfb file name of DEM
* **nx,** Dimension in x direction
* **ny,** Dimension in y direction
* **nz,** Dimension in z direction
* **nCLMsoil,** Layers coupled between CLM and ParFlow
* **ppx,** Split in x direction, like P in ParFlow
* **qqy,** Split in y direction, like Q in ParFlow
* **transfer,** Transfer scheme; 0 is no transfer, >0 is packed transfer, <0 is one by one transfer, abs(transfer) is frequency, one by one transfer is not supported with LB at current time.
* **separate,** If we separate particles into interior and peripheric portions for transfer?
* **LB,** LB frequency, e.g., 24 means every 24 hours. LB must be n\*add_f
* **th_value,** The threshold to start a new GPU
* **spinup,** If true, C array will not be calculated. This aims to speedup the spinup.
* **np_ic,** Number of particles per cell at the start of simulation
* **np,** Maximum number permitted during run time 
* **dx,** grid-cell size in x direction
* **dy,** grid-cell size in y direction
* **dz,** grid-cell size in z direction from bottom to top, separated by comma
* **pfdt,** ParFlow dt, need double-check in the code for mass balance
* **pft1,** ParFlow start time
* **pft2,** ParFlow end time
* **tout1,** EcoSLIM start number; it is 0 for cold start; it is the last completed timestep for hot start
* **n_cycle,** The cycles to use ParFlow files
* **add_f,** The time interval to add particles
* **ipwrite,** Not supported now
* **ibinpntswrite,** Not supported now
* **etwrite,** Not supported now
* **icwrite,** Not supported now
* **V_mult,** Velocity multiplier. Not supported now and only used for transfer test.
* **clmtrans,** clm evap trans?
* **clmfile,** clm output file?
* **iflux_p_res,** The number of particles added into the domain if PME > 0
* **denh2o,** density of water
* **moldiff,** Molecular diffusivity
* **dtfrac,** Numerical stability information
* **nind,** Number of subsurface indicator
* **Indname,** pfb file of indicator
# Build 
**An example of environment on Della GPU cluster at Princeton University:**  
1. If hdf5 is disabled:  
    <table>  
      <tr>
        <td>Compiler</td>
        <td>nvhpc/21.5</td>
      </tr> 
      <tr>
        <td>CUDA</td>
        <td>cudatoolkit/11.3</td>
      </tr> 
      <tr>
        <td>MPI</td>
        <td>openmpi/cuda-11.3/nvhpc-21.5/4.1.1</td>  
      </tr>  
    </table>  

* Build in the src folder:  
  ```
  make
  ```
2. If hdf5 is enabled:  
    <table>  
      <tr>  
        <td>Compiler</td>
        <td>nvhpc/21.5</td>
      </tr>
      <tr>
        <td>CUDA</td>
        <td>cudatoolkit/11.3</td>
      </tr>
      <tr>
        <td>MPI</td>
        <td>openmpi/cuda-11.3/nvhpc-21.5/4.1.1</td>
      </tr>
      <tr>
        <td>HDF5</td>
        <td>hdf5/nvhpc-21.5/1.10.6</td>
      </tr>  
    </table>   

* Build in the src folder:  
  ```
  make HDF5=1 
  ```
# Load Balancing (LB)
* The idea of LB in EcoSLIM is borrowed from ***OhHelp: A Scalable Domain-Decomposing Dynamic Load Balancing for Particle-in-Cell Simulations*** and then modified based on the characteristics of EcoSLIM (***Nakashima et al., 2009, Ics'09: Proceedings of the 2009 Acm Sigarch International Conference on Supercomputing***).  
* Code is started with a number of GPUs (subdomains) fewer than the total scheduled GPUs. Manager rank periodically checks the number of particles on each GPU. If the number of particles on a GPU is larger than a given number, one more GPU will be started to help that GPU/subdomain.  
* For a subdomain with more than one GPU, source particles from positive PME will be added into the GPU with the fewest number of particles. 
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




