# Last Change:  2021-06-02 10:51:56
all: test

test: -I$HDF5DIR/include -L$HDF5DIR/lib64 -rpath $HDF5DIR/lib64 ecoslim_cthrustscan.o ecoslim_thrustscan.cuf ecoslim_cuRAND_de.cuf ecoslim_variable_list.cuf ecoslim_subdomain_bc.f90 ecoslim_device_utility.cuf ecoslim_file_read.cuf ecoslim_dynamic_DDC.cuf ecoslim_utilities.cuf ecoslim_add_particles.cuf ecoslim_compaction.cuf EcoSLIM_CUDA_MPI.cuf
	mpif90 -o test -I$HDF5DIR/include -L$HDF5DIR/lib64 -rpath $HDF5DIR/lib64 -lhdf5_fortran -lhdf5 ecoslim_thrustscan.cuf ecoslim_cuRAND_de.cuf ecoslim_variable_list.cuf ecoslim_subdomain_bc.f90 ecoslim_device_utility.cuf ecoslim_file_read.cuf ecoslim_dynamic_DDC.cuf ecoslim_utilities.cuf ecoslim_add_particles.cuf ecoslim_compaction.cuf EcoSLIM_CUDA_MPI.cuf ecoslim_cthrustscan.o -lstdc++
ecoslim_cthrustscan.o: ecoslim_cthrustscan.cu
	nvcc -c $^ -o $@
clean:
	rm *.o *.mod a.out Read_check.* topo* zone* grid* \
	slurm* *.bin Load* Log* P_init* read* Eco*.txt
