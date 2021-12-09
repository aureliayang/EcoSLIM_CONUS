# EcoSLIM_CONUS
## A lagrangian particle tracking code
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/demo.png)  
                                       ***(Maxwell et al., Ecohydrology, 2019)***
                                                                      
## *Leveraging the latest parallel architecture, to accelerate the understanding of water cycle!*
* A parallel version EcoSLIM based on domain decomposition using the latest multi-GPU with CUDA-aware MPI technique. 
* Halo cells are used around each subdomain to store particles out of boundary and then transfer them to neighbors. 
* This development aims to handle the particle tracking at the continental US scale with long timescale.
* It can be applied to real cases now. Irregular boundaries are supported.   
* Optimization continues. Load balancing is coming soon!
* Users please refer to README.md in ***src*** folder for details.
* Welcome to download and use. Enjoy!
## CONUS domain
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/conus.png)
## Subdomain demonstration
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/subdomain.png)  

