#include <thrust/device_vector.h>
#include <thrust/scan.h>
#include <thrust/execution_policy.h>
extern "C" {
    void scan_int_wrapper(cudaStream_t s, int *data_in, int N, int *data_out)
    {
    thrust::device_ptr<int> dev_ptr_in(data_in);
    thrust::device_ptr<int> dev_ptr_out(data_out);
    thrust::inclusive_scan(thrust::cuda::par.on(s), dev_ptr_in, dev_ptr_in+N, dev_ptr_out);
    }

    void scan_float_wrapper( float *data_in, int N, float *data_out)
    {
    thrust::device_ptr<float> dev_ptr_in(data_in);
    thrust::device_ptr<float> dev_ptr_out(data_out);
    thrust::inclusive_scan(dev_ptr_in, dev_ptr_in+N, dev_ptr_out);
    }
    void scan_double_wrapper( double *data_in, int N, double *data_out)
    {
    thrust::device_ptr<double> dev_ptr_in(data_in);
    thrust::device_ptr<double> dev_ptr_out(data_out);
    thrust::inclusive_scan(dev_ptr_in, dev_ptr_in+N, dev_ptr_out);
    }
    void scan_longint_wrapper( long long int *data_in, int N, int *data_out)
    {
    thrust::device_ptr<long long int> dev_ptr_in(data_in);
    thrust::device_ptr<int> dev_ptr_out(data_out);
    thrust::inclusive_scan(dev_ptr_in, dev_ptr_in+N, dev_ptr_out);
    }
}