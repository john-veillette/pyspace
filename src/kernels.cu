#include "pyspace.h"

__global__ void brute_force_kernel()
{
    //Update all pointers here
}

void brute_force_gpu_update(double* x, double* y, double* z,
        double* v_x, double* v_y, double* v_z,
        double* a_x, double* a_y, double* a_z,
        double* m, double G, double dt, int num_planets, double eps)
{
    //Call gpu kernels here
    //brute_force_kernel();
}

