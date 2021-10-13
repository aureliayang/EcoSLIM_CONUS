# Last Change:  2021-07-20 22:29:28
CUF=ecoslim_thrustscan.o \
    ecoslim_cuRAND_de.o \
    ecoslim_variable_list.o \
    ecoslim_subdomain_bc.o \
    ecoslim_device_utility.o \
    ecoslim_dynamic_DDC.o \
    ecoslim_utilities.o \
    ecoslim_add_particles.o \
    ecoslim_compaction.o \
    ecoslim_particle_loop.o \
    ecoslim_particle_exch.o \
    ecoslim_pfb_read.o \
    EcoSLIM_CUDA_MPI.cuf

FFLAGS = -Mpreprocess -D_TIMING=1 -D_TEXTURE=1

all: test

test: ecoslim_cthrustscan.o ${CUF}
	mpif90 -o $@ $^ $(FFLAGS) -lstdc++

ecoslim_cthrustscan.o: ecoslim_cthrustscan.cu
	nvcc -c $^ -o $@ -std=c++14
ecoslim_cuRAND_de.o: ecoslim_cuRAND_de.cuf
	mpif90 -c $^ -o $@
ecoslim_thrustscan.o: ecoslim_thrustscan.cuf
	mpif90 -c $^ -o $@
ecoslim_variable_list.o: ecoslim_variable_list.cuf ecoslim_cuRAND_de.o
	mpif90 -c $< -o $@ $(FFLAGS)
ecoslim_subdomain_bc.o: ecoslim_subdomain_bc.cuf ecoslim_variable_list.o
	mpif90 -c $< -o $@ $(FFLAGS)
ecoslim_device_utility.o: ecoslim_device_utility.cuf
	mpif90 -c $^ -o $@
ecoslim_dynamic_DDC.o: ecoslim_dynamic_DDC.cuf ecoslim_variable_list.o
	mpif90 -c $< -o $@
ecoslim_utilities.o: ecoslim_utilities.cuf ecoslim_variable_list.o
	mpif90 -c $< -o $@
ecoslim_add_particles.o: ecoslim_add_particles.cuf ecoslim_cuRAND_de.o ecoslim_variable_list.o
	mpif90 -c $< -o $@
ecoslim_compaction.o: ecoslim_compaction.cuf ecoslim_variable_list.o
	mpif90 -c $< -o $@
ecoslim_particle_loop.o: ecoslim_particle_loop.cuf ecoslim_cuRAND_de.o ecoslim_variable_list.o
	mpif90 -c $< -o $@ $(FFLAGS)
ecoslim_particle_exch.o: ecoslim_particle_exch.cuf ecoslim_particle_loop.o \
	ecoslim_cuRAND_de.o ecoslim_variable_list.o
	mpif90 -c $< -o $@ $(FFLAGS)
ecoslim_pfb_read.o: ecoslim_pfb_read.f90
	mpif90 -c $^ -o $@

.PHONY: clean
clean:
	rm *.o *.mod test \
	Read_check.* \
	slurm* \
	EcoSLIM_Device_Utility.txt \
	SLIM*.txt \
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
	null


