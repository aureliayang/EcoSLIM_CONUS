# Last Change:  2021-07-20 22:29:28
CUF=ecoslim_thrustscan.cuf \
    ecoslim_cuRAND_de.cuf \
    ecoslim_variable_list.cuf \
    ecoslim_subdomain_bc.cuf \
    ecoslim_device_utility.cuf \
    ecoslim_dynamic_DDC.cuf \
    ecoslim_utilities.cuf \
    ecoslim_add_particles.cuf \
    ecoslim_compaction.cuf \
    ecoslim_particle_loop.cuf \
    ecoslim_particle_exch.cuf \
    pfb_read.f90 \
    EcoSLIM_CUDA_MPI.cuf

all: test

test: ecoslim_cthrustscan.o ${CUF}
	mpif90 -o test ${CUF} ecoslim_cthrustscan.o -lstdc++

ecoslim_cthrustscan.o: ecoslim_cthrustscan.cu
	nvcc -c $^ -o $@ -std=c++11

clean:
	rm *.o *.mod test \
	Read_check.* \
	slurm* \
	EcoSLIM_Device_Utility.txt \
	test*.txt \
	grid.* \
	topology.* \
	Zone_de_before.* \
	Zone_de_after.* \
	Load* \
	Local* \
	Variable_init* \
	P_init.* \
	Neighbor.* \
	Exited_particles.* \
	Log_particles.* \
	P_new.* \
	P_separa.* \
	P_peri.* \
	Send_Recv.* \



