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
* Users please refer to ***README.md*** in ***src*** folder for details.
* Welcome to download and use. Enjoy!
## Acknowledgements
* Thanks so much to the following software engineers for their guidance in the development:  
***NVIDIA, Carl Ponder; Princeton University, Bei Wang***
* Thanks so much to CONUS2.0 team for providing the CONUS2.0 model for tests
* Thanks so much to Prof. Reed Maxwell and Prof. Laura Condon for the support in the application of conputational resources.  
  We won the **NACR Accelerated Scientific Discovery program** this fall. We will run the CONUS2.0 model on the coming supercomputer Derecho using 100 NVIDIA A100 GPUs.
  
## CONUS domain
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/conus.png)
## Subdomain demonstration
![image](https://github.com/aureliayang/EcoSLIM_CONUS/blob/main/imgs/subdomain.png)  

