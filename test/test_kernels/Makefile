# Last Change:  2021-06-02 10:51:56
all: test_kernels

test_kernels: ecoslim_cthrustscan.o ecoslim_thrustscan.cuf ecoslim_compaction.cuf test_kernels.cuf
	nvfortran -o test_kernels ecoslim_thrustscan.cuf ecoslim_compaction.cuf test_kernels.cuf ecoslim_cthrustscan.o -lstdc++
ecoslim_cthrustscan.o: ecoslim_cthrustscan.cu
	nvcc -c $^ -o $@
clean:
	rm *.o *.mod test_kernels
