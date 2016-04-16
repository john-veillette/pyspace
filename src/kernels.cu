#include "pyspace.h"
#include <math.h>

#define NORM2(X, Y, Z) X*X + Y*Y + Z*Z

__device__
void calculate_force(double* x_old, double* y_old, double* z_old, double* m,
        double x_i, double y_i, double z_i,
        double& a_x, double& a_y, double& a_z,
        int num_planets, double eps2, double G)
{
    double r_x_j, r_y_j, r_z_j;
    double x_ji, y_ji, z_ji;
    double m_j;

    double cnst;
    double dist_ij;

    for(int j=0; j<num_planets; j++)
    {
        r_x_j = x_old[j];
        r_y_j = y_old[j];
        r_z_j = z_old[j];

        m_j = m[j];

        x_ji = r_x_j - x_i;
        y_ji = r_y_j - y_i;
        z_ji = r_z_j - z_i;

        dist_ij = sqrt(eps2 + NORM2(x_ji, y_ji, z_ji));

        if(dist_ij == 0)
            return;

        cnst = (G*m_j/(dist_ij*dist_ij*dist_ij));

        a_x += x_ji*cnst;
        a_y += y_ji*cnst;
        a_z += z_ji*cnst;
    }

}


__global__
void brute_force_kernel(double* x, double* y, double* z,
        double* x_old, double* y_old, double* z_old,
        double* v_x, double* v_y, double* v_z,
        double* a_x, double* a_y, double* a_z,
        double* m, double G, double dt, int num_planets)
{
    double eps2 = eps*eps;

    int id = blockIdx.x*blockDim.x + threadIdx.x;

    if(id > num_planets)
        return;
    
    //Update id'th planet

    double a_x_i = a_x[i];
    double a_y_i = a_y[i];
    double a_z_i = a_z[i];

    calculate_force(x_old, y_old, z_old, m,
            x_old[id], y_old[id], z_old[id],
            a_x[id], a_y[id], a_z[id],
            num_planets, eps2, G);

    x[i] += v_x[i]*dt + a_x_i*0.5*dt*dt;
    y[i] += v_y[i]*dt + a_y_i*0.5*dt*dt;
    z[i] += v_z[i]*dt + a_z_i*0.5*dt*dt;

    v_x[i] += (a_x_i + a_x[i])*0.5*dt;
    v_y[i] += (a_y_i + a_y[i])*0.5*dt;
    v_z[i] += (a_z_i + a_z[i])*0.5*dt;
}


__host__
void brute_force_gpu_update(double* x, double* y, double* z,
        double* v_x, double* v_y, double* v_z,
        double* a_x, double* a_y, double* a_z,
        double* m, double G, double dt, int num_planets, double eps)
{
    if( cudaMalloc((void**)&dev_x, num_planets*sizeof(double)) != cudaSuccess ||
        cudaMalloc((void**)&dev_y, num_planets*sizeof(double)) != cudaSuccess ||
        cudaMalloc((void**)&dev_z, num_planets*sizeof(double)) != cudaSuccess ||
        cudaMalloc((void**)&dev_x_old, num_planets*sizeof(double)) != cudaSuccess ||
        cudaMalloc((void**)&dev_y_old, num_planets*sizeof(double)) != cudaSuccess ||
        cudaMalloc((void**)&dev_z_old, num_planets*sizeof(double)) != cudaSuccess ||
        cudaMalloc((void**)&dev_v_x, num_planets*sizeof(double)) != cudaSuccess ||
        cudaMalloc((void**)&dev_v_y, num_planets*sizeof(double)) != cudaSuccess ||
        cudaMalloc((void**)&dev_v_z, num_planets*sizeof(double)) != cudaSuccess ||
        cudaMalloc((void**)&dev_a_x, num_planets*sizeof(double)) != cudaSuccess ||
        cudaMalloc((void**)&dev_a_y, num_planets*sizeof(double)) != cudaSuccess ||
        cudaMalloc((void**)&dev_a_z, num_planets*sizeof(double)) != cudaSuccess ||
        cudaMalloc((void**)&dev_m, num_planets*sizeof(double)) != cudaSuccess   )
    {
        fprintf(stderr, "ERROR: cudaMalloc failed!");
        exit(0);
    }

    if( cudaMemcpy(dev_x, x, num_planets*sizeof(double), cudaMemcpyHostToDevice) != cudaSuccess ||
        cudaMemcpy(dev_y, y, num_planets*sizeof(double), cudaMemcpyHostToDevice) != cudaSuccess ||
        cudaMemcpy(dev_z, z, num_planets*sizeof(double), cudaMemcpyHostToDevice) != cudaSuccess ||
        cudaMemcpy(dev_x_old, x_old, num_planets*sizeof(double), cudaMemcpyHostToDevice) != cudaSuccess ||
        cudaMemcpy(dev_y_old, y_old, num_planets*sizeof(double), cudaMemcpyHostToDevice) != cudaSuccess ||
        cudaMemcpy(dev_z_old, z_old, num_planets*sizeof(double), cudaMemcpyHostToDevice) != cudaSuccess ||
        cudaMemcpy(dev_v_x, v_x, num_planets*sizeof(double), cudaMemcpyHostToDevice) != cudaSuccess ||
        cudaMemcpy(dev_v_y, v_y, num_planets*sizeof(double), cudaMemcpyHostToDevice) != cudaSuccess ||
        cudaMemcpy(dev_v_z, v_z, num_planets*sizeof(double), cudaMemcpyHostToDevice) != cudaSuccess ||
        cudaMemcpy(dev_a_x, a_x, num_planets*sizeof(double), cudaMemcpyHostToDevice) != cudaSuccess ||
        cudaMemcpy(dev_a_y, a_y, num_planets*sizeof(double), cudaMemcpyHostToDevice) != cudaSuccess ||
        cudaMemcpy(dev_a_z, a_z, num_planets*sizeof(double), cudaMemcpyHostToDevice) != cudaSuccess ||
        cudaMemcpy(dev_m, m, num_planets*sizeof(double), cudaMemcpyHostToDevice) != cudaSuccess )
    {
        fprintf(stderr, "ERROR: cudaMemcpy from host to device failed!");
        exit(0);
    }

    brute_force_kernel<<<num_planets/1024 + 1, 1024>>>(dev_x, dev_y, dev_z,
            dev_x_old, dev_y_old, dev_z_old,
            dev_v_x, dev_v_y, dev_v_z,
            dev_a_x, dev_a_y, dev_a_z,
            dev_m, G, dt, num_planets);

    if( cudaMemcpy(dev_x, x, num_planets*sizeof(double), cudaMemcpyDeviceToHost) != cudaSuccess ||
        cudaMemcpy(dev_y, y, num_planets*sizeof(double), cudaMemcpyDeviceToHost) != cudaSuccess ||
        cudaMemcpy(dev_z, z, num_planets*sizeof(double), cudaMemcpyDeviceToHost) != cudaSuccess ||
        cudaMemcpy(dev_x_old, x_old, num_planets*sizeof(double), cudaMemcpyDeviceToHost) != cudaSuccess ||
        cudaMemcpy(dev_y_old, y_old, num_planets*sizeof(double), cudaMemcpyDeviceToHost) != cudaSuccess ||
        cudaMemcpy(dev_z_old, z_old, num_planets*sizeof(double), cudaMemcpyDeviceToHost) != cudaSuccess ||
        cudaMemcpy(dev_v_x, v_x, num_planets*sizeof(double), cudaMemcpyDeviceToHost) != cudaSuccess ||
        cudaMemcpy(dev_v_y, v_y, num_planets*sizeof(double), cudaMemcpyDeviceToHost) != cudaSuccess ||
        cudaMemcpy(dev_v_z, v_z, num_planets*sizeof(double), cudaMemcpyDeviceToHost) != cudaSuccess ||
        cudaMemcpy(dev_a_x, a_x, num_planets*sizeof(double), cudaMemcpyDeviceToHost) != cudaSuccess ||
        cudaMemcpy(dev_a_y, a_y, num_planets*sizeof(double), cudaMemcpyDeviceToHost) != cudaSuccess ||
        cudaMemcpy(dev_a_z, a_z, num_planets*sizeof(double), cudaMemcpyDeviceToHost) != cudaSuccess ||
        cudaMemcpy(dev_m, m, num_planets*sizeof(double), cudaMemcpyDeviceToHost) != cudaSuccess )
    {
        fprintf(stderr, "ERROR: cudaMemcpy from device to host failed!");
        exit(0);
    }

}

