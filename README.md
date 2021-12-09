# EcoSLIM_CONUS
## A lagrangian particle tracking code
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/demo.png)  
                                       ***(Maxwell et al., Ecohydrology, 2019)***
## We are doing super cool stuff!
* A parallel version EcoSLIM based on domain decomposition using the latest multi-GPU with CUDA-aware MPI technique. 
* Halo cells are used around each subdomain to store particles out of boundary and then transfer these particles. 
* The purpose of this development is to handle the particle tracking at the continental US scale with long timescale.
* It can be applied to real cases now. Optimization continues.  
* Load balancing is coming soon!
* Welcome to download and use. Enjoy!
* Please refer to README.md in src folder for details.
## CONUS domain
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/conus.png)
## Subdomain demonstration
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/subdomain.png)  

