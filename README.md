# EcoSLIM_CONUS
## A lagrangian particle tracking code
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/demo.png)                                 
A particle tracking code simulates water ages and source-water mixing, working seamlessly with the integrated hydrologic model ParFlow-CLM ***(Maxwell et al., Ecohydrology, 2019)***.                                                               
## *Leveraging the latest parallel architecture, to accelerate the understanding of water cycle in the changing world!*
* A parallel version EcoSLIM based on domain decomposition using the latest multi-GPU with CUDA-aware MPI technique. 
* Halo cells are used around each subdomain to store particles out of boundary and then transfer them to neighbors. 
* This development aims to handle the particle tracking at the continental US scale with long timescale.
* It can be applied to real cases now. Irregular boundaries are supported.   
* Optimization continues. Load balancing is coming soon! Please refer to ***README.md*** in ***src*** for algorithms.
* Users please refer to ***README.md*** in ***src*** folder for details.
* Welcome to download and use. Enjoy!
## Parallel performance
Currently, optimization continues, so **only the particle loop kernel** got tested on the Della-GPU cluster at Princeton University. Each GPU node is equipped with **2 NVIDIA A100 GPUs** and **2 2.60-GHz AMD EPYC 7H12 sockets**. Each socket has 64 cores without hyperthreading.  
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/test.png)  
* Tests used ER_Shrub and LW_Shrub cases based on the Hillslope model in Maxwell et al. (Ecohydrology, 2019).  
* Speedup is calculated by comparing the wall-clock time used by 128-thread to that used by 2-A100.
* Results show speedup of ~10-fold for ER_Shrub and ~12.5-fold for LW_Shrub on one node. 
* The more the particles, the higher the speedup. Particle numbers for ER_Shrub and LW_Shrub are 5.6- and 17.4-million, respectively. 
* Results show good parallel scalability across two nodes, ~10-fold to ~20-fold for ER_Shrub and ~12.5-fold to ~25-fold for LW_Shrub. 
* LB is Load Balancing. S*n* represents LB schemes. Speedup by S3 using 4-GPU is smaller due to the uneven split in y direction (5 grid-cells).
## Acknowledgements
* Thanks so much to the following software engineers for their guidance in the code development:  
***NVIDIA, Carl Ponder; Princeton University, Bei Wang***
* Thanks so much to ***the CONUS2.0 team*** for offering the CONUS2.0 ParFlow model for code tests 
* Thanks so much to ***Prof. Reed Maxwell*** at Princeton University and ***Prof. Laura Condon*** at the University of Arizona for their support in the application of computational resources: We won the **NACR Accelerated Scientific Discovery program** 2021 fall. We will run particle tracking based on the CONUS2.0 ParFlow model on the coming NCAR supercomputer ***Derecho*** using ***100 NVIDIA A100 GPUs***
## CONUS2.0 domain
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/conus.png)  
***(Zhang et al., Earth System Science Data, 2021)***
## Subdomain demonstration
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/subdomain.png)  

