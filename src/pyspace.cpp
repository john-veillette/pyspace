#include "pyspace.hpp"
#include <string>
#include <vector>
#include <cmath>

Simulator::Simulator()
{
    //Constructor for Simulator
}

Simulator::Simulator(SimConfig config)
{
    this->config = config;
}

Simulator::Simulator(std::string filename)
{
    //Read from file
}

Simulator::~Simulator()
{
    //Destructor for Simulator
}

inline int Simulator::add_object(SimObject obj)
{
    this->obj_list.push_back(obj);
    return 1;
}

inline std::vector<SimObject>& Simulator::get_objects()
{
    return this->obj_list;
}

int Simulator::delete_object(int obj_id)
{
    //delete object
}

void start_simulation(double tot_time)
{
    //do calculations and return result
}

SimObject::SimObject(double mass, double radius, int object_id)
{
    this->mass = mass;
    this->radius = radius;
    this->object_id = object_id;
}

SimObject::~SimObject()
{
    //Destructor
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
    Vector a_i, v_i, x_i, x_j, temp;
    double m_j;
    SimObject *obj, *obj_j;
    
    for(int i=0; i<num_objs; i++)
    {
        obj = &obj_ref[i];
        
        a_i = obj->acceleration;
        v_i = obj->velocity;
        x_i = obj->position;

        //Update acceleration of obj
        for(int j=0; j<num_objs; j++)
        {
            if(j==i)
                continue;
            obj_j = &obj_ref[j];
            
            x_j = obj_j->position;
            m_j = obj_j->mass;
           
            //Can be optimized
            temp += (x_i - x_j)*(G*m_j/pow(x_j.magnitude(),3));
        }

        obj->acceleration = temp;
                
        //Using leapfrog integrator for updating r and v
        obj->velocity = v_i + (a_i + obj->acceleration)*0.5*dt;
        obj->position = x_i + v_i*dt + a_i*0.5*dt;
    }
}

