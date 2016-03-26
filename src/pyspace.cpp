#include "pyspace.h"
#include <cmath>
#include <iostream>
#include <omp.h>
#include <list>
#include <iostream>

#define MAGNITUDE(x, y, z) sqrt(x*x + y*y + z*z)
#define MIN(X,Y) ((X) < (Y)) ? (X) : (Y)
#define MAX(X,Y) ((X) < (Y)) ? (Y) : (X)
#define ERR 1e-7

using namespace std;

struct Vec3
{
    double x;
    double y;
    double z;
    Vec3() = default;
    Vec3(double x, double y, double z)
    {
        this->x = x;
        this->y = y;
        this->z = z;
    }
};

struct BarnesNode
{
    double mass;
    double x;
    double y;
    double z;
    double width;
    BarnesNode *children[2][2][2];
    
    BarnesNode()
    {
        mass = x = y = z = width = 0;
        for(int i=0;i<2;i++)
            for(int j=0;j<2;j++)
                for(int k=0;k<2;k++)
                    children[i][j][k] = NULL;
    }
    
    ~BarnesNode()
    {
        for(int i=0;i<2;i++)
            for(int j=0;j<2;j++)
                for(int k=0;k<2;k++)
                    if(children[i][j][k]!=NULL)
                        delete children[i][j][k];
    }
 
    bool isChild()
    {
        for(int i=0;i<2;i++)
            for(int j=0;j<2;j++)
                for(int k=0;k<2;k++)
                    if(children[i][j][k] != NULL)
                        return false;
        return true;
    }
};

struct BarnesPlanet
{
    double x;
    double y;
    double z;
    double mass;
    
    BarnesPlanet()
    {
        x = y = z = 0;
    }

    BarnesPlanet(double x, double y, double z, double mass)
    {
        this->x = x;
        this->y = y;
        this->z = z;
        this->mass = mass;
    }
};

BarnesPlanet build_barnes_tree(BarnesNode *node, list<BarnesPlanet> &planets,
                                 double x0, double y0, double z0, double width)
{
    if(planets.size() == 1)
    {
        node->x = planets.front().x;
        node->y = planets.front().y;
        node->z = planets.front().z;
        node->mass = planets.front().mass;
        node->width = width;
     
        return BarnesPlanet(planets.front().x, planets.front().y, planets.front().z, planets.front().mass);
    }

    list<BarnesPlanet> temp;
    BarnesPlanet com(0,0,0,0);

    for(int octant=0;octant<8;octant++)
    {
        int i=(octant&1);
        int j=((octant&2)>>1);
        int k=((octant&4)>>2);
        
        double x1 = x0 + i*width/2;
        double x2 = x0 + (i+1)*width/2;
        double y1 = y0 + j*width/2;
        double y2 = y0 + (j+1)*width/2;
        double z1 = z0 + k*width/2;
        double z2 = z0 + (k+1)*width/2;
                                      
        for(list<BarnesPlanet>::iterator it = planets.begin();it != planets.end();)
        {
            list<BarnesPlanet>::iterator next_it = it;
            ++next_it;

            if((it->x)>= x1 && (it->x)<x2 &&
               (it->y)>= y1 && (it->y)<y2 &&
               (it->z)>= z1 && (it->z)<z2)
            {
                temp.push_back(BarnesPlanet(it->x, it->y, it->z, it->mass));
                planets.erase(it);
            }
            
            it=next_it;
        }
        
        if(temp.size()==0)
            continue;

        node->children[i][j][k] = new BarnesNode;
        BarnesPlanet octant_com = build_barnes_tree(node->children[i][j][k], temp,
                          x1, y1, z1, width/2);

        double total_mass = octant_com.mass + com.mass;
 
        com.x = (octant_com.mass*octant_com.x + com.mass*com.x)/total_mass;
        com.y = (octant_com.mass*octant_com.y + com.mass*com.y)/total_mass;
        com.z = (octant_com.mass*octant_com.z + com.mass*com.z)/total_mass;
        com.mass += octant_com.mass;
       
    }
 
    node->x = com.x;
    node->y = com.y;
    node->z = com.z;
    node->mass = com.mass;
    node->width = width;
    //cout << node->x << " " << node->y << " " << node->z << endl;
 
 
    return com;
}

Vec3 get_barnes_acceleration(BarnesNode *node, 
                             double mass, double x, double y, double z,
                             double G, double theta)
{
    double r_x = node->x - x;
    double r_y = node->y - y;
    double r_z = node->z - z;
    double dist = MAGNITUDE(r_x, r_y, r_z);
    
    if(dist<ERR)
        return Vec3(0,0,0);

    if(node->isChild() || (node->width)/dist < theta)
    {      

        double cnst = G*(node->mass)/(dist*dist*dist);
        return Vec3(cnst*r_x, cnst*r_y, cnst*r_z);
    }
    else
    {
        double a_x = 0;
        double a_y = 0;
        double a_z = 0;
        for(int i=0;i<2;i++)
            for(int j=0;j<2;j++)
                for(int k=0;k<2;k++)
                {
                    BarnesNode *child = node->children[i][j][k];
                    if(child!=NULL)
                    {
                        Vec3 temp = get_barnes_acceleration(child, mass, x, y, z, G, theta);
                        a_x += temp.x;
                        a_y += temp.y;
                        a_z += temp.z;
                    }
                }
        return Vec3(a_x, a_y, a_z);
    }
}

void barnes_update(double *x, double *y, double *z,
                   double *v_x, double *v_y, double *v_z,
                   double *a_x, double *a_y, double *a_z,
                   double *m, double G, double dt, int num_planets,
                   double theta)
{
    list<BarnesPlanet> planets;
    double min_x, max_x, min_y, max_y, min_z, max_z;
    min_x = min_y = min_z = INFINITY;
    max_x = max_y = max_z = -INFINITY;

    for(int i=0;i<num_planets;i++)
    {
        planets.push_back(BarnesPlanet(x[i], y[i], z[i],m[i]));

        min_x = MIN(min_x, x[i]); 
        max_x = MAX(max_x, x[i]);
        min_y = MIN(min_y, y[i]);
        max_y = MAX(max_y, y[i]);
        min_z = MIN(min_z, z[i]);
        max_z = MAX(max_z, z[i]);
    }
    
    double width = MAX(max_x - min_x, MAX(max_y - min_y, max_z - min_z));

    BarnesNode *root = new BarnesNode;
    build_barnes_tree(root, planets, min_x, min_y, min_z, width);

    for(int i=0;i<num_planets;i++)
    {
        Vec3 a = get_barnes_acceleration(root, m[i], x[i], y[i], z[i], G, theta);
        
        x[i] += v_x[i]*dt + a_x[i]*dt*dt/2;
        y[i] += v_y[i]*dt + a_y[i]*dt*dt/2;
        z[i] += v_z[i]*dt + a_z[i]*dt*dt/2;

        v_x[i] += (a_x[i] + a.x)*dt/2;
        v_y[i] += (a_y[i] + a.y)*dt/2;
        v_z[i] += (a_z[i] + a.z)*dt/2;
        
        a_x[i] = a.x;
        a_y[i] = a.y;
        a_z[i] = a.z;
    }
}

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
    double x_ji, y_ji, z_ji;
    double temp_a_x = 0, temp_a_y = 0, temp_a_z = 0;
    double dist_ij, cnst;
    double m_j;

    double* x_old = new double[num_planets];
    double* y_old = new double[num_planets];
    double* z_old = new double[num_planets];

    #pragma omp parallel for shared(x_old, y_old, z_old, x, y, z)
    for(int i=0; i<num_planets; i++)
    {
        x_old[i] = x[i];
        y_old[i] = y[i];
        z_old[i] = z[i];
    }

    #pragma omp parallel for shared(x, y, z, x_old, y_old, z_old, v_x, v_y, v_z, \
            a_x, a_y, a_z, m, G, dt) \
    private(a_x_i, a_y_i, a_z_i, v_x_i, v_y_i, v_z_i, r_x_i, r_y_i, r_z_i, r_x_j, \
      r_y_j, r_z_j, x_ji, y_ji, z_ji, temp_a_x, temp_a_y, temp_a_z, dist_ij, \
      cnst, m_j)
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

            r_x_j = x_old[j];
            r_y_j = y_old[j];
            r_z_j = z_old[j];

            m_j = m[j];

            x_ji = r_x_j - r_x_i;
            y_ji = r_y_j - r_y_i;
            z_ji = r_z_j - r_z_i;

            dist_ij = MAGNITUDE(x_ji, y_ji, z_ji);

            cnst = (G*m_j/(dist_ij*dist_ij*dist_ij));

            temp_a_x += x_ji*cnst;
            temp_a_y += y_ji*cnst;
            temp_a_z += z_ji*cnst;
        }

        a_x[i] = temp_a_x;
        a_y[i] = temp_a_y;
        a_z[i] = temp_a_z;

        temp_a_x = 0;
        temp_a_y = 0;
        temp_a_z = 0;

        x[i] += v_x_i*dt + a_x_i*0.5*dt*dt;
        y[i] += v_y_i*dt + a_y_i*0.5*dt*dt;
        z[i] += v_z_i*dt + a_z_i*0.5*dt*dt;

        v_x[i] += (a_x_i + a_x[i])*0.5*dt;
        v_y[i] += (a_y_i + a_y[i])*0.5*dt;
        v_z[i] += (a_z_i + a_z[i])*0.5*dt;

    }

    delete[] x_old;
    delete[] y_old;
    delete[] z_old;
}
