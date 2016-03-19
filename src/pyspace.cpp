#include "pyspace.h"
#include <cmath>
#include <omp.h>

#define MAGNITUDE(x, y, z) sqrt(x*x + y*y + z*z)
void brute_force_update(double* x, double* y, double* z, 
        double* v_x, double* v_y, double* v_z,
        double* a_x, double* a_y, double* a_z,
        double* m, double G, double dt, int num_planets)
{
    //Calculate and update all pointers
    double a_x_i, a_y_i, a_z_i;
    double v_x_i, v_y_i, v_z_i;
    double r_x_i, r_y_i, r_z_i;
    double r_x_j, r_y_j, r_z_j;
    double x_ij, y_ij, z_ij;
    double temp_a_x = 0, temp_a_y = 0, temp_a_z = 0;
    double dist_ij, cnst;
    double m_j;
    
    for(int i=0; i<num_planets; i++)
    {
        a_x_i = a_x[i];
        a_y_i = a_y[i];
        a_z_i = a_z[i];

        v_x_i = v_x[i];
        v_y_i = v_y[i];
        v_z_i = v_z[i];

        r_x_i = x[i];
        r_y_i = y[i];
        r_z_i = z[i];

       for(int j=0; j<num_planets; j++)
        {
            if(j == i)
                continue;
            
            r_x_j = x[j];
            r_y_j = y[j];
            r_z_j = z[j];

            m_j = m[j];

            x_ij = r_x_i - r_x_j;
            y_ij = r_y_i - r_y_j;
            z_ij = r_z_i - r_z_j;

            dist_ij = MAGNITUDE(x_ij, y_ij, z_ij);

            cnst = (G*m_j/dist_ij*dist_ij*dist_ij);

            temp_a_x += x_ij*cnst;
            temp_a_y += y_ij*cnst;
            temp_a_z += z_ij*cnst;
        }

        a_x[i] = temp_a_x;
        a_y[i] = temp_a_y;
        a_z[i] = temp_a_z;

        temp_a_x = 0;
        temp_a_y = 0;
        temp_a_z = 0;

        v_x[i] += (a_x_i + a_x[i])*0.5*dt;
        v_y[i] += (a_y_i + a_y[i])*0.5*dt;
        v_z[i] += (a_z_i + a_z[i])*0.5*dt;

        x[i] += v_x_i*dt + a_x_i*0.5*dt*dt;
        y[i] += v_y_i*dt + a_y_i*0.5*dt*dt;
        z[i] += v_z_i*dt + a_z_i*0.5*dt*dt;
    }
}


