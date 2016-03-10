#include "pyspace.h"
#include <string>
#include <vector>
#include <cmath>

SimConfig::SimConfig(std::string filename)
{
    //Read config from file
}

SimConfig::SimConfig()
{
    //Dummy constructor to enable stack allocation with cython
    this->G = 0;
    this->step_size = 0;
}

SimConfig::SimConfig(double G, double step_size)
{
    this->G = G;
    this->step_size = step_size;
}

void SimConfig::write_to_file(std::string filename)
{
    //Write this config to filename
}

SimObject::SimObject(double mass, double radius, cVector *init_pos,
        cVector *init_vel, int object_id)
{
    this->mass = mass;
    this->radius = radius;
    this->position = init_pos;
    this->velocity = init_vel;
    this->object_id = object_id;
}

SimObject::SimObject()
{
    //Dummy constructor to enable stack allocation with cython
    this->mass = 0;
    this->radius = 0;
    this->object_id = 0;
}

Engine::Engine(std::vector<SimObject> *obj_list, SimConfig* config)
{
    this->config = config;
    this->obj_list = obj_list;
}

void Engine::update()
{
    double dt = this->config->step_size;
    double G = this->config->G;
    
    std::vector<SimObject> &obj_ref = *this->obj_list;
    
    int num_objs = obj_ref.size();
    cVector a_i, v_i, x_i, x_j, temp;
    double m_j;
    SimObject *obj, *obj_j;
    
    for(int i=0; i<num_objs; i++)
    {
        obj = &obj_ref[i];
        
        a_i = *obj->acceleration;
        v_i = *obj->velocity;
        x_i = *obj->position;

        //Update acceleration of obj
        for(int j=0; j<num_objs; j++)
        {
            if(j==i)
                continue;
            obj_j = &obj_ref[j];
            
            x_j = *obj_j->position;
            m_j = obj_j->mass;
           
            //Can be optimized
            temp += (x_i - x_j)*(G*m_j/pow(x_j.magnitude(),3));
        }

        *obj->acceleration = temp;
                
        //Using leapfrog integrator for updating r and v
        *obj->velocity = v_i + (a_i + *obj->acceleration)*0.5*dt;
        *obj->position = x_i + v_i*dt + a_i*0.5*dt;
    }
}

