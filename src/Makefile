# Last Change:  2022-01-17 10:27:27
CUF=ecoslim_thrustscan.o \
    ecoslim_device_rand.o \
    ecoslim_variable_list.o \
    ecoslim_subdomain_bc.o \
    ecoslim_device_utility.o \
    ecoslim_dynamic_DDC.o \
    ecoslim_utilities.o \
    ecoslim_particle_add.o \
    ecoslim_compaction.o \
    ecoslim_particle_loop.o \
    ecoslim_particle_exch1.o \
    ecoslim_particle_exch2.o \
    ecoslim_particle_sort.o \
    ecoslim_pfb_read.o \
    ecoslim_particle_LB1.o \
    ecoslim_particle_separ.o \
    ecoslim_particle_pme.o \
    ecoslim_read_input.o \
    ecoslim_working_comm.o \
    ecoslim_particle_init.o \
    ecoslim_particle_LB2.o \
    EcoSLIM.cuf

HDF5 = 0

FFLAGS = -Mpreprocess -D_TIMING=1 -D_HDF5=$(HDF5)

HDF5FLAGS = -I$(HDF5DIR)/include -L$(HDF5DIR)/lib64 -rpath $(HDF5DIR)/lib64 -lhdf5_fortran -lhdf5

ifneq ($(HDF5),1)
    HDF5FLAGS = ''
else
    CUF += ecoslim_read_hdf5.o
endif

all: EcoSLIM

EcoSLIM: ecoslim_thrustscanc.o ${CUF}
	mpif90 -o $@ $^ $(FFLAGS) $(HDF5FLAGS) -lstdc++

ecoslim_thrustscanc.o: ecoslim_thrustscanc.cu
	nvcc -c $^ -o $@ -std=c++14
ecoslim_device_rand.o: ecoslim_device_rand.cuf
	mpif90 -c $^ -o $@
ecoslim_thrustscan.o: ecoslim_thrustscan.cuf
	mpif90 -c $^ -o $@
ecoslim_variable_list.o: ecoslim_variable_list.cuf ecoslim_device_rand.o
	mpif90 -c $< -o $@ $(FFLAGS)
ecoslim_subdomain_bc.o: ecoslim_subdomain_bc.cuf ecoslim_variable_list.o
	mpif90 -c $< -o $@ $(FFLAGS)
ecoslim_device_utility.o: ecoslim_device_utility.cuf
	mpif90 -c $^ -o $@
ecoslim_dynamic_DDC.o: ecoslim_dynamic_DDC.cuf ecoslim_variable_list.o
	mpif90 -c $< -o $@
ecoslim_utilities.o: ecoslim_utilities.cuf ecoslim_variable_list.o
	mpif90 -c $< -o $@
ecoslim_particle_add.o: ecoslim_particle_add.cuf ecoslim_device_rand.o ecoslim_variable_list.o
	mpif90 -c $< -o $@
ecoslim_compaction.o: ecoslim_compaction.cuf ecoslim_variable_list.o
	mpif90 -c $< -o $@
ecoslim_particle_loop.o: ecoslim_particle_loop.cuf ecoslim_device_rand.o ecoslim_variable_list.o
	mpif90 -c $< -o $@ $(FFLAGS)
ecoslim_particle_exch1.o: ecoslim_particle_exch1.cuf ecoslim_particle_loop.o ecoslim_variable_list.o
	mpif90 -c $< -o $@ $(FFLAGS)
ecoslim_particle_exch2.o: ecoslim_particle_exch2.cuf ecoslim_particle_loop.o ecoslim_variable_list.o
	mpif90 -c $< -o $@ $(FFLAGS)
ecoslim_particle_sort.o: ecoslim_particle_sort.cuf ecoslim_variable_list.o
	mpif90 -c $< -o $@ $(FFLAGS)
ecoslim_pfb_read.o: ecoslim_pfb_read.f90
	mpif90 -c $^ -o $@
ecoslim_particle_LB1.o: ecoslim_particle_LB1.cuf ecoslim_utilities.o ecoslim_subdomain_bc.o ecoslim_variable_list.o
	mpif90 -c $< -o $@ $(FFLAGS)
ecoslim_particle_separ.o: ecoslim_particle_separ.cuf ecoslim_compaction.o ecoslim_variable_list.o
	mpif90 -c $< -o $@ $(FFLAGS)
ecoslim_particle_pme.o: ecoslim_particle_pme.cuf ecoslim_particle_add.o ecoslim_variable_list.o
	mpif90 -c $< -o $@ $(FFLAGS)
ecoslim_read_input.o: ecoslim_read_input.cuf ecoslim_variable_list.o
	mpif90 -c $< -o $@
ecoslim_working_comm.o: ecoslim_working_comm.cuf ecoslim_variable_list.o
	mpif90 -c $< -o $@
ecoslim_particle_init.o: ecoslim_particle_init.cuf ecoslim_particle_add.o ecoslim_variable_list.o
	mpif90 -c $< -o $@
ifeq ($(HDF5),1)
ecoslim_read_hdf5.o: ecoslim_read_hdf5.cuf ecoslim_variable_list.o
	mpif90 -c $< -o $@ $(HDF5FLAGS)
endif
ecoslim_particle_LB2.o: ecoslim_particle_LB2.cuf ecoslim_utilities.o ecoslim_subdomain_bc.o ecoslim_variable_list.o ecoslim_dynamic_DDC.o
	mpif90 -c $< -o $@ $(FFLAGS)

.PHONY: clean
clean:
	rm *.o *.mod EcoSLIM \
	slurm* \
	Device_Utility.txt \
	SLIM*.txt \
	Load* \
	Exited_particles.* \
	Particle_restart.* \
	EcoSLIM_restart.* \
	Log_particles.* \
	null \
	Debug* \
	Timing*.txt

