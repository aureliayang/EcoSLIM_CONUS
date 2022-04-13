# EcoSLIM_CONUS  
**Long-term effective:** Welcome collaborations from experts good at parallelization of Lagrangian method and its load balancing! Please contact me via cy15@princeton.edu 
## A lagrangian particle tracking code
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/demo.png)                                 
A particle tracking code simulates water ages and source-water mixing, working seamlessly with the integrated hydrologic model ParFlow-CLM ***(Maxwell et al., Ecohydrology, 2019)***.                                                               
## *Leveraging the latest parallel architecture, to accelerate the understanding of water cycle in the changing world!*
* A parallel version EcoSLIM based on domain decomposition using the latest multi-GPU with CUDA-aware MPI technique. 
* Halo cells are used around each subdomain to store particles out of boundary and then transfer them to neighbors. 
* This development aims to handle the particle tracking at the continental US scale with long timescale.
* It can be applied to real cases now. Irregular boundaries are supported. HDF5 is supported.      
* Optimization continues. **Technical support will be provided in about October 2022 after we release the first steady version.**  
* Users are welcome to download and use per interests at current time. Please refer to ***README.md*** in ***src*** folder for details. 
* Enjoy! 
## Publications 
* **Yang C.**, Maxwell R., McDonnell J., Yang X., Tijerina D., 2022. The role of topography in controlling evapotranspiration age. Submitted to ***Geophysical Research Letters***, under review. 
* **Yang C.**, Ponder C., Wang B., Tran H., Zhang J., Swilley J., Condon L., Maxwell R., 2022. Accelerating the Lagrangian particle tracking in hydrology to continental-scale. Submitted to ***Journal of Advances in Modeling Earth Systems***, under review. 
* **Yang C.**, Maxwell R., Valent R., 2022. Accurate load balancing accelerates Lagrangian simulation of water ages on distributed, multi-GPU platforms. ***Computers & Geosciences***, moderate revision.
* **Yang C.**, Zhang Y.-K., Liang X., Olschanowsky C., Yang X., Maxwell R., 2021. Accelerating the Lagrangian particle tracking of residence time distributions and source water mixing towards large scales. ***Computers & Geosciences***, https://doi.org/10.1016/j.cageo.2021.104760
## Presentations
* **Yang C.**, **MODFLOW and More 2022**, oral presentation, Accelerating the Lagrangian particle tracking in hydrologic modeling at the continental-scale 
* **Yang C.**, **EGU General Assembly 2022**, oral presentation, Accelerating the Lagrangian particle tracking in hydrologic modeling at continental-scale 
* **Yang C.**, **NCAR HPC User Group (NHUG) monthly meeting 2022**, oral presentation: https://wiki.ucar.edu/pages/viewpage.action?pageId=484344890
* **Maxwell R.**, **NCAR HPC User Group (NHUG) monthly meeting 2022**, oral presentation: https://wiki.ucar.edu/pages/viewpage.action?pageId=475760826
* **Yang C.**, **American Geophysical Union Fall meeting 2021**, Topography-driven flow paths control spatiotemporal variabilities of ET age: A perspective from particle tracking at the regional scale (H11A-06), oral presentation. https://agu.confex.com/agu/fm21/meetingapp.cgi/Paper/870631
* **Yang C.**, **American Geophysical Union Fall meeting 2021**, Accurate load balancing accelerates Lagrangian simulation of water ages on distributed, multi-GPU platforms (H53F-08), oral presentation. https://agu.confex.com/agu/fm21/meetingapp.cgi/Paper/871082
## Acknowledgments
* Thanks so much to the following software engineers for their guidance in the code development:  
***NVIDIA, Carl Ponder; Princeton University, Bei Wang***
* Thanks so much to ***the CONUS2.0 team*** for offering the CONUS2.0 ParFlow model for code tests 
* Thanks so much to ***Prof. Reed Maxwell*** at Princeton University and ***Prof. Laura Condon*** at the University of Arizona for their support in the application of computational resources: We won the **NACR Accelerated Scientific Discovery program** 2021 fall. We will run particle tracking based on the CONUS2.0 ParFlow model on the coming NCAR supercomputer ***Derecho*** using ***100 NVIDIA A100 GPUs***
## Tests across three spatial scales
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/3tests.jpeg)
## Test on CONUS2.0 without LB (particle distribution)
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/NLB.png)  
## Subdomain demonstration
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/subdomain.png)  
## Parallel performance
Currently, optimization continues, so **only the particle loop kernel** got tested on the Della-GPU cluster at Princeton University. Each GPU node is equipped with **2 NVIDIA A100 GPUs** and **2 2.60-GHz AMD EPYC 7H12 sockets**. Each socket has 64 cores without hyperthreading.  
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/test.png)  
* Tests used ER_Shrub and LW_Shrub cases based on the Hillslope model in Maxwell et al. (Ecohydrology, 2019).  
* Speedup is calculated by comparing the wall-clock time used by 128-thread to that used by 2-A100.
* Results show speedup of ~10-fold for ER_Shrub and ~12.5-fold for LW_Shrub on one node. 
* The more the particles, the higher the speedup. Particle numbers for ER_Shrub and LW_Shrub are 5.6- and 17.4-million, respectively. 
* Results show good parallel scalability across two nodes, ~10-fold to ~20-fold for ER_Shrub and ~12.5-fold to ~25-fold for LW_Shrub. 
* LB is Load Balancing. S*n* represents LB schemes. Speedup by S3 using 4-GPU is smaller due to the uneven split in y direction (5 grid-cells).  
* **Latest parallel performance tests based on the whole code show as good performance as this single kernel tests. This part will be updated soon.** 
