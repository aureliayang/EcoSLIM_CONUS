# Input file 
1. **runname,** EcoSLIM run name
2. **pname,** Path of ParFlow files
3. **DEMname,** pfb file name of DEM
4. **nx,** Dimension in x direction
5. **ny,** Dimension in y direction
6. **nz,** Dimension in z direction
7. **nCLMsoil,** Layers coupled between CLM and ParFlow
8. **ppx,** Split in x direction, like P in ParFlow
9. **qqy,** Split in y direction, like Q in ParFlow
10. **transfer,** Transfer scheme; 0 is no transfer, >0 is packed transfer, <0 is 1-by-1 transfer, abs(transfer) is frequency. Theoretically, packed with separation is better for long time-interval transfer while 1-by-1 without separation is better for transfer every timestep.
11. **separate,** If we separate particles into interior and peripheric portions for transfer? If you do separate, you must do transfer (this is automatically set in the code).
12. **LB,** LB frequency, e.g., 24 means every 24 hours. LB must be n\*add_f
13. **th_value,** The threshold to start a new GPU
14. **spinup,** If true, C array will not be calculated. This aims to speedup the spinup.
15. **np_ic,** If np_ic /= -1, abs(np_ic) is the number of particles per cell at the start of simulation. If np_if = -1, the simulation is restarted. 
16. **np,** Maximum number permitted during run time 
17. **dx,** grid-cell size in x direction
18. **dy,** grid-cell size in y direction
19. **dz,** grid-cell size in z direction from bottom to top, separated by comma
20. **pfdt,** ParFlow dt, need double-check in the code for mass balance
21. **pft1,** ParFlow start time
22. **pft2,** ParFlow end time
23. **tout1,** EcoSLIM start number; it is 0 for cold start; it is the last completed timestep for hot start
24. **n_cycle,** The cycles to use ParFlow files
25. **add_f,** The time interval to add particles
26. **restart_f,** The time interval to restart. It should be n\*add_f. 
27. **ipwrite,** Not supported now
28. **ibinpntswrite,** Not supported now
29. **etwrite,** Not supported now
30. **icwrite,** Not supported now
31. **V_mult,** Velocity multiplier. If > 0, it is the forward tracking. If < 0, it is the backward tracking.
32. **clmtrans,** clm evap trans?
33. **clmfile,** clm output file?
34. **iflux_p_res,** The number of particles added into the domain if PME > 0
35. **denh2o,** density of water
36. **moldiff,** Molecular diffusivity
37. **dtfrac,** Numerical stability information
38. **nfactor,** It should be a large number, if you use LB2. For example, it is 100,000 for CONUS2.0.
39. **nind,** Number of subsurface indicator. If nind < 1, Indname can be empty.
40. **Indname,** pfb file of indicator
# Build 
**An example of environment on Della GPU cluster at Princeton University:**  
1. Without hdf5:  
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
2. With hdf5:  
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
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/3LB.png)
* The idea of GPU Help (LB1) in EcoSLIM is borrowed from ***OhHelp: A Scalable Domain-Decomposing Dynamic Load Balancing for Particle-in-Cell Simulations*** and then modified based on the characteristics of EcoSLIM (***Nakashima et al., 2009, Ics'09: Proceedings of the 2009 Acm Sigarch International Conference on Supercomputing***). Code is started with a number of GPUs (subdomains) fewer than the total scheduled GPUs. Manager rank periodically checks the number of particles on each GPU. If the number of particles on a GPU is larger than a given number, one more GPU will be started to help that GPU/subdomain. For a subdomain with more than one GPU, source particles from positive PME will be added into the GPU with the fewest number of particles.  
* **Test results of Little Washita watershed. In test with LB1, simulation started using 2 GPUs while 4 GPUs were scheduled.**
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/LBs.png)    
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




