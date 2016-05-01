#ifndef PYSPACE_H
#define PYSPACE_H

void brute_force_update(double* x, double* y, double* z, 
        double* v_x, double* v_y, double* v_z,
        double* a_x, double* a_y, double* a_z,
        double* m, double G, double dt, int num_planets, double eps);

void barnes_update(double *x, double *y, double *z, 
        double *v_x, double *v_y, double *v_z,
        double *a_x, double *a_y, double *a_z,
        double *m, double G, double dt, int num_planets,
        double theta, double eps);

void brute_force_gpu_update(double* dev_x, double* dev_y, double* dev_z, 
        double* dev_x_old, double* dev_y_old, double* dev_z_old,
        double* dev_v_x, double* dev_v_y, double* dev_v_z,
        double* dev_a_x, double* dev_a_y, double* dev_a_z,
        double* dev_m, double G, double dt, int num_planets, double eps);

void calculate_force(double* x_old, double* y_old, double* z_old, double* m,
        double x_i, double y_i, double z_i,
        double& a_x, double& a_y, double& a_z,
        int num_planets, double eps2, double G);

void malloc_device(double* x, double* y, double* z,
        double* v_x, double* v_y, double* v_z,
        double* a_x, double* a_y, double* a_z, double* m,
        double* dev_x, double* dev_y, double* dev_z,
        double* dev_x_old, double* dev_y_old, double* dev_z_old,
        double* dev_v_x, double* dev_v_y, double* dev_v_z,
        double* dev_a_x, double* dev_a_y, double* dev_a_z, 
        double* dev_m, int num_planets);

void memcpy_to_host(double* x, double* y, double* z,
        double* v_x, double* v_y, double* v_z,
        double* a_x, double* a_y, double* a_z, double* m,
        double* dev_x, double* dev_y, double* dev_z,
        double* dev_v_x, double* dev_v_y, double* dev_v_z,
        double* dev_a_x, double* dev_a_y, double* dev_a_z,
        double* dev_m, int num_planets);

void free_device(double* dev_x, double* dev_y, double* dev_z,
        double* dev_x_old, double* dev_y_old, double* dev_z_old,
        double* dev_v_x, double* dev_v_y, double* dev_v_z,
        double* dev_a_x, double* dev_a_y, double* dev_a_z,
        double* dev_m);

#endif
