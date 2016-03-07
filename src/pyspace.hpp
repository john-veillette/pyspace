#include <vector>
#include <string>
#include <cmath>

class SimObject;
class SimConfig;

/*
  Status codes
*/
#define SIMULATION_RUNNING 1
#define SIMULATION_COMPLETE 2
#define SIMULATION_ERROR 3
#define SIMULATION_NOT_STARTED 4

struct Vector
{
    double x, y, z;

    Vector()
    {
        this->x = 0;
        this->y = 0;
        this->z = 0;
    }

    Vector(double x, double y, double z)
    {
        this->x = x;
        this->y = y;
        this->z = z;
    }
    
    void operator=(const Vector& v)
    {
        this->x = v.x;
        this->y = v.y;
        this->z = v.z;
    }

    Vector operator+(const Vector& v)
    {
        Vector result;
        result.x = this->x + v.x;
        result.y = this->y + v.y;
        result.z = this->z + v.z;
        return result;
    }

    Vector operator-(const Vector& v)
    {
        Vector result;
        result.x = this->x - v.x;
        result.y = this->y - v.y;
        result.z = this->z - v.z;
        return result;
    }

    Vector operator*(const double& scalar)
    {
        Vector result;
        result.x = this->x*scalar;
        result.y = this->y*scalar;
        result.z = this->z*scalar;
        return result;
    }

    void operator+=(const Vector& v)
    {
        this->x += v.x;
        this->y += v.y;
        this->z += v.z;
    }

    inline double magnitude()
    {
        return sqrt(this->x*this->x + this->y*this->y + this->z*this->z);
    }

};

struct SimConfig
{
    double G;
    double step_size;
    
    SimConfig();
    SimConfig(double G, double step_size);
    SimConfig(std::string filename);
    void write_to_file(std::string filename);
};

class Simulator
{
private:
    //Data Structures
    std::vector<SimObject> obj_list;
    SimConfig config;
public:
    Simulator();
    Simulator(SimConfig);
    Simulator(std::string filename);
    ~Simulator();
    
    inline int add_object(SimObject);
    inline std::vector<SimObject> &get_objects();
    int delete_object(int);

    void write_to_file(std::string filename);
    int get_status();
    void start_simulation(double);
    void abort();

};

class SimObject
{
private:
    int object_id;
public:
    //Data Structures
    double mass;
    double radius;
    Vector position;
    Vector velocity;
    Vector acceleration;
    
    SimObject(double mass, double radius, int object_id);
    ~SimObject();
};

class Engine
{
private:
    //Private members
    std::vector<SimObject> *obj_list;
    SimConfig* config;
public:
    Engine(std::vector<SimObject> *obj_list, SimConfig* config);
    void update();
};



