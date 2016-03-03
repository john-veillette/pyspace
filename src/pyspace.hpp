#include <vector>
#include <string>

class SimObject;
class SimConfig;

/*
  Status codes
*/
#define SIMULATION_RUNNING 1
#define SIMULATION_COMPLETE 2
#define SIMULATION_ERROR 3
#define SIMULATION_NOT_STARTED 4

struct ThreeTuple
{
	double x;
	double y;
	double z;
};

typedef ThreeTuple Position;
typedef ThreeTuple Velocity;

class SimConfig
{
	
public:
	double G;
	double error_margin;

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
	
	int add_object(SimObject);
	std::vector<SimObject> get_objects();
	int delete_object(int);

	void write_to_file(std::string filename);
	int get_status();
	void start_simulation(double);
	void abort();

};

class SimObject
{
	friend class Simulator;
	
private:
	//Data Structures
	static int object_id;
	
	Position position;
	Velocity velocity;
public:
	SimObject();
	~SimObject();
	
	void set_position(Position);
	void set_velocity(Velocity);
	Velocity get_velocity();
	Position get_position();
};

