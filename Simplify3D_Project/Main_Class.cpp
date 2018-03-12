#include <iostream>
#include <string>

using namespace std;

class dbs
{
public:
	int id;
	int state;
        void *data;
	dbs()
	{
		id = state = 0;
                data = nullptr;
	}
};

class Node : public dbs
{
public:
		double x,y,z;
                Node(double x,double y, double z):x(x),y(y),z(z){}
                Node(double& x,double& y, double& z){this->x=x,this->y=y,this->z=z;}

                bool operator==(const Node& rhs)
                {
                    return (fabs(x-rhs.x) < 1e-12 && fabs(y-rhs.y) < 1e-12 && fabs(z-rhs.z) < 1e-12);
                }

                bool operator<(const Node& rhs)
                {
                    if(x != rhs.x)    return x < rhs.x;
                    else if(y != rhs.y)    return y < rhs.y;
                    else if(z != rhs.z)    return z < rhs.z;
                    else                    return false;
                }

};

class Element: public dbs
{
public:
                int e_nodes[3];
        Element(int id)
        {
            e_nodes[0]=e_nodes[1]=e_nodes[2]=-1;
            this->id = id;
        }
};

class Edge: public dbs
{
public:
		Node *n1;
		Node *n2;
	Edge()
	{
		n1=n2=nullptr;		
	}
};

class ModelClass : public dbs
{
public:
            QString name = "";
            QVector<Node> m_nodes;
            QVector<Element> m_elements;
};

static ModelClass current_model;

void buildNodeElementModel(vector<Node> temp_nodes)
{
    vector<Node> model_nodes;
    vector<Element> model_elements[temp_nodes.size()/3];
    int node_count = 0;

    for(int i = 0; i < temp_nodes.size(); i++)
    {
        int flag = 0;
        if(i==0 || !(temp_nodes[i] == temp_nodes[i-1]))
        {
            model_nodes.push_back(temp_nodes[i]);
            flag = 1;
        }
        if(model_elements[(*(int*)temp_nodes[i].data)-1].n1 == 0 )
            model_elements[(*(int*)temp_nodes[i].data)-1].n1 = node_count+1;
        else if(model_elements[(*(int*)temp_nodes[i].data)-1].n2 == 0 )
            model_elements[(*(int*)temp_nodes[i].data)-1].n2 = node_count+1;
        else if(model_elements[(*(int*)temp_nodes[i].data)-1].n3 == 0 )
            model_elements[(*(int*)temp_nodes[i].data)-1].n3 = node_count+1;

        if(flag)node_count++;
    }
}

static void buildModel(string file_path) //Assumed to be ASCII for now
{
        QFile file;
        file.open(file_path);
	
        if(!file)
	{
            return;
	}
	
        auto name = file.readLine().trimmed().split(' '); //get the first line i.e. SOLID name
        for(int i = 1; i < name.size(); i++)
            current_model.name += name[i];

        int node_count = 0;
        QVector<Node> temp_nodes;

        while (!file.atEnd()) {
            auto line = file.readLine();//this is to skip the facet normal line
            if(line.trimmed() == "endsolid")
                break;

            file.readLine();//this is to skip the outer loop line

            for(int i = 0; i < 3; i++)
            {
                auto line = file.readLine().trimmed().split(' ');//this splits the vertex line into vertex V1x V1y V1z
                temp_nodes.push_back(Node(line[1].toDouble(), line[2].toDouble(), line[3].toDouble()));
                temp_nodes[node_count++].data = (void*)(new int(node_count/3 + 1)); //this is to save which element given node belongs to
            }
            file.readLine();//to skip endloop
            file.readLine();//to skip endfacet
        }

        /*
            The idea is that we get the element's nodes by doing a simple sort and filling up the
            element's node values through this code.
        */
        sort(temp_nodes.begin(),temp_nodes.end()); //this sorts out all the nodes

        buildNodeElementModel(temp_nodes);

        /*
            The next step after obtaining the above element node relationship is to
            build the Edge-Element connectivity matrix.

            To determine if the edge is non-manifold, the number of elements connected to that edge should be more than 2.
                If edge is determined to be non-manifold, mark that edge with a Non-Manifold flag.

            If while looping over the edges, we find out that 2 elements are non-manifold, we can conclude that that element is
            a Duplicate face. (Duplicate faces are triangles which share 3 common nodes, but remain as 2 separate entities.

            If while looping over the edges, we find out that there is only one element attached, to that edge,
            we can conclude that the edge makes up a hole or is a free edge.
        */

}


/*
    The below code is to find elements whose normals are to be flipped.
*/




/*
    To find connected elements for a given element, toggle the states of the nodes attached to the parent element as 1,
    while keeping all the other nodes in the model as 0.
    To find the attached elements, loop over each element to check if their state if 1 or not.
    Even if one node's state is one, the conclusion is that the node belongs to an attached element.
*/
vector<Element> findConnectedElementsGivenParentElement(Element elem)
{
    vector<Element> child_elems;
    vector<int> backup_nodes_states;
    for(auto n:current_model.m_nodes)
    {
        backup_nodes_states.push_back(n.state);
        n.state = 0;
    }

    m_nodes[elem.e_nodes[0]].state = 1;
    m_nodes[elem.e_nodes[1]].state = 1;
    m_nodes[elem.e_nodes[2]].state = 1;

    for(auto e:current_model.m_elements)
    {
        if(m_nodes[e.e_nodes[0]].state || m_nodes[e.e_nodes[1]].state || m_nodes[e.e_nodes[2]].state)
            child_elems.push_back(e);
    }

    for(int n=0; n<backup_nodes_states.size(); n++)
    {
        current_model.m_nodes[n] = backup_nodes_states[n];
    }
    return child_elems;
}


/*
    To get the elements that have their normals flipped, use either the facet normals provided in the stl file
    OR calculate the normal by finding the cross product of any 2 edges of the triangle.

    I formulated a tree structure for this purpose.
*/
struct Tree
{
    Element parent;
    QVector<Tree> children;
};


void findChildTree(Tree tree)
{
    vector<Element> child_elements = findConnectedElementsGivenParentElement(tree.parent);

    //Use the facet normals or compute Element normal using the cross product method and get angle between the parent and child element

    for(int i = 0; i < child_elements.size();i++)
    {
        tree.children[i] = new Tree();
        tree.children[i].parent = child_elements[i];
        findChildTree(tree.children[i]);
    }
}



int isElementFlipped(Element parent, Element child)
{
    //mathVector parent_normal = parent.normal();
    //mathVector child_normal = child.normal();


    int isFlipped = 1;//if mathDotProduct(parent_normal, child_normal) == -1 conclude child is flipped. Else it is aligned to parent.
    return isFlipped;
}












