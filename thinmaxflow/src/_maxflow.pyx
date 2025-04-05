# distutils: language = c++

from .src._maxflow cimport Graph, bool, node_id, termtype


cpdef enum TermType:
    SOURCE = 0,
    SINK = 1

cdef public class GraphInt[object PyObject_GraphInt, type GraphInt]:

    cdef Graph[int, int, int]* c_graph

    def __cinit__(self, int node_num_max = 0, long long edge_num_max = 0):
        """Constructor. 
        The first argument gives an estimate of the maximum number of nodes that can be added
        to the graph, and the second argument is an estimate of the maximum number of edges.
        The last (optional) argument is the pointer to the function which will be called 
        if an error occurs; an error message is passed to this function. 
        If this argument is omitted, exit(1) will be called.
        
        IMPORTANT: It is possible to add more nodes to the graph than node_num_max 
        (and node_num_max can be zero). However, if the count is exceeded, then 
        the internal memory is reallocated (increased by 50%) which is expensive. 
        Also, temporarily the amount of allocated memory would be more than twice than needed.
        Similarly for edges.
        If you wish to avoid this overhead, you can download version 2.2, where nodes and edges are stored in blocks.
        """
        self.c_graph = new Graph[int, int, int](node_num_max, edge_num_max)

    def __dealloc__(self):
        """Destructor.
        """
        del self.c_graph

    def add_node(self, int num = 1):
        """Adds node(s) to the graph. By default, one node is added (num=1); then first call returns 0, second call returns 1, and so on. 
	    If num>1, then several nodes are added, and node_id of the first one is returned.
	    IMPORTANT: see note about the constructor 
        """
        return self.c_graph.add_node(num)

    def add_edge(self, node_id i, node_id j, int cap, int rev_cap):
        """Adds a bidirectional edge between 'i' and 'j' with the weights 'cap' and 'rev_cap'.
	    IMPORTANT: see note about the constructor 
        """
        self.c_graph.add_edge(i, j, cap, rev_cap)

    def add_tweights(self, node_id i, int cap_source, int cap_sink):
        """Adds new edges 'SOURCE->i' and 'i->SINK' with corresponding weights.
        Can be called multiple times for each node.
        Weights can be negative.
        NOTE: the number of such edges is not counted in edge_num_max.
	    No internal memory is allocated by this call.
        """
        self.c_graph.add_tweights(i, cap_source, cap_sink)

    def maxflow(self, bool reuse_trees = False):
        """Computes the maxflow. Can be called several times.
        FOR DESCRIPTION OF reuse_trees, SEE mark_node().
        FOR DESCRIPTION OF changed_list, SEE remove_from_changed_list().
        """
        return self.c_graph.maxflow(reuse_trees)

    def what_segment(self, node_id i, termtype default_segm = termtype.SOURCE):
        """After the maxflow is computed, this function returns to which
        segment the node 'i' belongs (Graph<captype,tcaptype,flowtype>::SOURCE or Graph<captype,tcaptype,flowtype>::SINK).
        
        Occasionally there may be several minimum cuts. If a node can be assigned
        to both the source and the sink, then default_segm is returned.
        """
        return self.c_graph.what_segment(i, default_segm)

    def reset(self):
        """Removes all nodes and edges. 
        After that functions add_node() and add_edge() must be called again. 
        
        Advantage compared to deleting Graph and allocating it again:
        no calls to delete/new (which could be quite slow).
        
        If the graph structure stays the same, then an alternative
        is to go through all nodes/edges and set new residual capacities
        (see functions below).
        """
        self.c_graph.reset()

    def get_node_num(self):
        """Gets the number of nodes in the graph.
        """
        return self.c_graph.get_node_num()

    def get_arc_num(self):
        """Gets the number of edges in the graph.
        """
        return self.c_graph.get_arc_num()

    def mark_node(self, node_id i):
        """If flag reuse_trees is true while calling maxflow(), then search trees
        are reused from previous maxflow computation. 
        In this case before calling maxflow() the user must
        specify which parts of the graph have changed by calling mark_node():
        add_tweights(i),set_trcap(i)    => call mark_node(i)
        add_edge(i,j),set_rcap(a)       => call mark_node(i); mark_node(j)
        
        This option makes sense only if a small part of the graph is changed.
        The initialization procedure goes only through marked nodes then.
        
        mark_node(i) can either be called before or after graph modification.
        Can be called more than once per node, but calls after the first one
        do not have any effect.
        
        NOTE: 
        - This option cannot be used in the first call to maxflow().
        - It is not necessary to call mark_node() if the change is ``not essential'',
            i.e. sign(trcap) is preserved for a node and zero/nonzero status is preserved for an arc.
        - To check that you marked all necessary nodes, you can call maxflow(false) after calling maxflow(true).
            If everything is correct, the two calls must return the same value of flow. (Useful for debugging).
        """
        return self.c_graph.mark_node(i)


cdef public class GraphShort[object PyObject_GraphShort, type GraphShort]:

    cdef Graph[short, int, int]* c_graph

    def __cinit__(self, int node_num_max = 0, long long edge_num_max = 0):
        """Constructor. 
        The first argument gives an estimate of the maximum number of nodes that can be added
        to the graph, and the second argument is an estimate of the maximum number of edges.
        The last (optional) argument is the pointer to the function which will be called 
        if an error occurs; an error message is passed to this function. 
        If this argument is omitted, exit(1) will be called.
        
        IMPORTANT: It is possible to add more nodes to the graph than node_num_max 
        (and node_num_max can be zero). However, if the count is exceeded, then 
        the internal memory is reallocated (increased by 50%) which is expensive. 
        Also, temporarily the amount of allocated memory would be more than twice than needed.
        Similarly for edges.
        If you wish to avoid this overhead, you can download version 2.2, where nodes and edges are stored in blocks.
        """
        self.c_graph = new Graph[short, int, int](node_num_max, edge_num_max)

    def __dealloc__(self):
        """Destructor.
        """
        del self.c_graph

    def add_node(self, int num = 1):
        """Adds node(s) to the graph. By default, one node is added (num=1); then first call returns 0, second call returns 1, and so on. 
	    If num>1, then several nodes are added, and node_id of the first one is returned.
	    IMPORTANT: see note about the constructor 
        """
        return self.c_graph.add_node(num)

    def add_edge(self, node_id i, node_id j, short cap, short rev_cap):
        """Adds a bidirectional edge between 'i' and 'j' with the weights 'cap' and 'rev_cap'.
	    IMPORTANT: see note about the constructor 
        """
        self.c_graph.add_edge(i, j, cap, rev_cap)

    def add_tweights(self, node_id i, int cap_source, int cap_sink):
        """Adds new edges 'SOURCE->i' and 'i->SINK' with corresponding weights.
        Can be called multiple times for each node.
        Weights can be negative.
        NOTE: the number of such edges is not counted in edge_num_max.
	    No internal memory is allocated by this call.
        """
        self.c_graph.add_tweights(i, cap_source, cap_sink)

    def maxflow(self, bool reuse_trees = False):
        """Computes the maxflow. Can be called several times.
        FOR DESCRIPTION OF reuse_trees, SEE mark_node().
        FOR DESCRIPTION OF changed_list, SEE remove_from_changed_list().
        """
        return self.c_graph.maxflow(reuse_trees)

    def what_segment(self, node_id i, termtype default_segm = termtype.SOURCE):
        """After the maxflow is computed, this function returns to which
        segment the node 'i' belongs (Graph<captype,tcaptype,flowtype>::SOURCE or Graph<captype,tcaptype,flowtype>::SINK).
        
        Occasionally there may be several minimum cuts. If a node can be assigned
        to both the source and the sink, then default_segm is returned.
        """
        return self.c_graph.what_segment(i, default_segm)

    def reset(self):
        """Removes all nodes and edges. 
        After that functions add_node() and add_edge() must be called again. 
        
        Advantage compared to deleting Graph and allocating it again:
        no calls to delete/new (which could be quite slow).
        
        If the graph structure stays the same, then an alternative
        is to go through all nodes/edges and set new residual capacities
        (see functions below).
        """
        self.c_graph.reset()

    def get_node_num(self):
        """Gets the number of nodes in the graph.
        """
        return self.c_graph.get_node_num()

    def get_arc_num(self):
        """Gets the number of edges in the graph.
        """
        return self.c_graph.get_arc_num()

    def mark_node(self, node_id i):
        """If flag reuse_trees is true while calling maxflow(), then search trees
        are reused from previous maxflow computation. 
        In this case before calling maxflow() the user must
        specify which parts of the graph have changed by calling mark_node():
        add_tweights(i),set_trcap(i)    => call mark_node(i)
        add_edge(i,j),set_rcap(a)       => call mark_node(i); mark_node(j)
        
        This option makes sense only if a small part of the graph is changed.
        The initialization procedure goes only through marked nodes then.
        
        mark_node(i) can either be called before or after graph modification.
        Can be called more than once per node, but calls after the first one
        do not have any effect.
        
        NOTE: 
        - This option cannot be used in the first call to maxflow().
        - It is not necessary to call mark_node() if the change is ``not essential'',
            i.e. sign(trcap) is preserved for a node and zero/nonzero status is preserved for an arc.
        - To check that you marked all necessary nodes, you can call maxflow(false) after calling maxflow(true).
            If everything is correct, the two calls must return the same value of flow. (Useful for debugging).
        """
        return self.c_graph.mark_node(i)


cdef public class GraphFloat[object PyObject_GraphFloat, type GraphFloat]:

    cdef Graph[float, float, float]* c_graph

    def __cinit__(self, int node_num_max = 0, long long edge_num_max = 0):
        """Constructor. 
        The first argument gives an estimate of the maximum number of nodes that can be added
        to the graph, and the second argument is an estimate of the maximum number of edges.
        The last (optional) argument is the pointer to the function which will be called 
        if an error occurs; an error message is passed to this function. 
        If this argument is omitted, exit(1) will be called.
        
        IMPORTANT: It is possible to add more nodes to the graph than node_num_max 
        (and node_num_max can be zero). However, if the count is exceeded, then 
        the internal memory is reallocated (increased by 50%) which is expensive. 
        Also, temporarily the amount of allocated memory would be more than twice than needed.
        Similarly for edges.
        If you wish to avoid this overhead, you can download version 2.2, where nodes and edges are stored in blocks.
        """
        self.c_graph = new Graph[float, float, float](node_num_max, edge_num_max)

    def __dealloc__(self):
        """Destructor.
        """
        del self.c_graph

    def add_node(self, int num = 1):
        """Adds node(s) to the graph. By default, one node is added (num=1); then first call returns 0, second call returns 1, and so on. 
	    If num>1, then several nodes are added, and node_id of the first one is returned.
	    IMPORTANT: see note about the constructor 
        """
        return self.c_graph.add_node(num)

    def add_edge(self, node_id i, node_id j, float cap, float rev_cap):
        """Adds a bidirectional edge between 'i' and 'j' with the weights 'cap' and 'rev_cap'.
	    IMPORTANT: see note about the constructor 
        """
        self.c_graph.add_edge(i, j, cap, rev_cap)

    def add_tweights(self, node_id i, float cap_source, float cap_sink):
        """Adds new edges 'SOURCE->i' and 'i->SINK' with corresponding weights.
        Can be called multiple times for each node.
        Weights can be negative.
        NOTE: the number of such edges is not counted in edge_num_max.
	    No internal memory is allocated by this call.
        """
        self.c_graph.add_tweights(i, cap_source, cap_sink)

    def maxflow(self, bool reuse_trees = False):
        """Computes the maxflow. Can be called several times.
        FOR DESCRIPTION OF reuse_trees, SEE mark_node().
        FOR DESCRIPTION OF changed_list, SEE remove_from_changed_list().
        """
        return self.c_graph.maxflow(reuse_trees)

    def what_segment(self, node_id i, termtype default_segm = termtype.SOURCE):
        """After the maxflow is computed, this function returns to which
        segment the node 'i' belongs (Graph<captype,tcaptype,flowtype>::SOURCE or Graph<captype,tcaptype,flowtype>::SINK).
        
        Occasionally there may be several minimum cuts. If a node can be assigned
        to both the source and the sink, then default_segm is returned.
        """
        return self.c_graph.what_segment(i, default_segm)

    def reset(self):
        """Removes all nodes and edges. 
        After that functions add_node() and add_edge() must be called again. 
        
        Advantage compared to deleting Graph and allocating it again:
        no calls to delete/new (which could be quite slow).
        
        If the graph structure stays the same, then an alternative
        is to go through all nodes/edges and set new residual capacities
        (see functions below).
        """
        self.c_graph.reset()

    def get_node_num(self):
        """Gets the number of nodes in the graph.
        """
        return self.c_graph.get_node_num()

    def get_arc_num(self):
        """Gets the number of edges in the graph.
        """
        return self.c_graph.get_arc_num()

    def mark_node(self, node_id i):
        """If flag reuse_trees is true while calling maxflow(), then search trees
        are reused from previous maxflow computation. 
        In this case before calling maxflow() the user must
        specify which parts of the graph have changed by calling mark_node():
        add_tweights(i),set_trcap(i)    => call mark_node(i)
        add_edge(i,j),set_rcap(a)       => call mark_node(i); mark_node(j)
        
        This option makes sense only if a small part of the graph is changed.
        The initialization procedure goes only through marked nodes then.
        
        mark_node(i) can either be called before or after graph modification.
        Can be called more than once per node, but calls after the first one
        do not have any effect.
        
        NOTE: 
        - This option cannot be used in the first call to maxflow().
        - It is not necessary to call mark_node() if the change is ``not essential'',
            i.e. sign(trcap) is preserved for a node and zero/nonzero status is preserved for an arc.
        - To check that you marked all necessary nodes, you can call maxflow(false) after calling maxflow(true).
            If everything is correct, the two calls must return the same value of flow. (Useful for debugging).
        """
        return self.c_graph.mark_node(i)


cdef public class GraphDouble[object PyObject_GraphDouble, type GraphDouble]:

    cdef Graph[double, double, double]* c_graph

    def __cinit__(self, int node_num_max = 0, long long edge_num_max = 0):
        """Constructor. 
        The first argument gives an estimate of the maximum number of nodes that can be added
        to the graph, and the second argument is an estimate of the maximum number of edges.
        The last (optional) argument is the pointer to the function which will be called 
        if an error occurs; an error message is passed to this function. 
        If this argument is omitted, exit(1) will be called.
        
        IMPORTANT: It is possible to add more nodes to the graph than node_num_max 
        (and node_num_max can be zero). However, if the count is exceeded, then 
        the internal memory is reallocated (increased by 50%) which is expensive. 
        Also, temporarily the amount of allocated memory would be more than twice than needed.
        Similarly for edges.
        If you wish to avoid this overhead, you can download version 2.2, where nodes and edges are stored in blocks.
        """
        self.c_graph = new Graph[double, double, double](node_num_max, edge_num_max)

    def __dealloc__(self):
        """Destructor.
        """
        del self.c_graph

    def add_node(self, int num = 1):
        """Adds node(s) to the graph. By default, one node is added (num=1); then first call returns 0, second call returns 1, and so on. 
	    If num>1, then several nodes are added, and node_id of the first one is returned.
	    IMPORTANT: see note about the constructor 
        """
        return self.c_graph.add_node(num)

    def add_edge(self, node_id i, node_id j, double cap, double rev_cap):
        """Adds a bidirectional edge between 'i' and 'j' with the weights 'cap' and 'rev_cap'.
	    IMPORTANT: see note about the constructor 
        """
        self.c_graph.add_edge(i, j, cap, rev_cap)

    def add_tweights(self, node_id i, double cap_source, double cap_sink):
        """Adds new edges 'SOURCE->i' and 'i->SINK' with corresponding weights.
        Can be called multiple times for each node.
        Weights can be negative.
        NOTE: the number of such edges is not counted in edge_num_max.
	    No internal memory is allocated by this call.
        """
        self.c_graph.add_tweights(i, cap_source, cap_sink)

    def maxflow(self, bool reuse_trees = False):
        """Computes the maxflow. Can be called several times.
        FOR DESCRIPTION OF reuse_trees, SEE mark_node().
        FOR DESCRIPTION OF changed_list, SEE remove_from_changed_list().
        """
        return self.c_graph.maxflow(reuse_trees)

    def what_segment(self, node_id i, termtype default_segm = termtype.SOURCE):
        """After the maxflow is computed, this function returns to which
        segment the node 'i' belongs (Graph<captype,tcaptype,flowtype>::SOURCE or Graph<captype,tcaptype,flowtype>::SINK).
        
        Occasionally there may be several minimum cuts. If a node can be assigned
        to both the source and the sink, then default_segm is returned.
        """
        return self.c_graph.what_segment(i, default_segm)

    def reset(self):
        """Removes all nodes and edges. 
        After that functions add_node() and add_edge() must be called again. 
        
        Advantage compared to deleting Graph and allocating it again:
        no calls to delete/new (which could be quite slow).
        
        If the graph structure stays the same, then an alternative
        is to go through all nodes/edges and set new residual capacities
        (see functions below).
        """
        self.c_graph.reset()

    def get_node_num(self):
        """Gets the number of nodes in the graph.
        """
        return self.c_graph.get_node_num()

    def get_arc_num(self):
        """Gets the number of edges in the graph.
        """
        return self.c_graph.get_arc_num()

    def mark_node(self, node_id i):
        """If flag reuse_trees is true while calling maxflow(), then search trees
        are reused from previous maxflow computation. 
        In this case before calling maxflow() the user must
        specify which parts of the graph have changed by calling mark_node():
        add_tweights(i),set_trcap(i)    => call mark_node(i)
        add_edge(i,j),set_rcap(a)       => call mark_node(i); mark_node(j)
        
        This option makes sense only if a small part of the graph is changed.
        The initialization procedure goes only through marked nodes then.
        
        mark_node(i) can either be called before or after graph modification.
        Can be called more than once per node, but calls after the first one
        do not have any effect.
        
        NOTE: 
        - This option cannot be used in the first call to maxflow().
        - It is not necessary to call mark_node() if the change is ``not essential'',
            i.e. sign(trcap) is preserved for a node and zero/nonzero status is preserved for an arc.
        - To check that you marked all necessary nodes, you can call maxflow(false) after calling maxflow(true).
            If everything is correct, the two calls must return the same value of flow. (Useful for debugging).
        """
        return self.c_graph.mark_node(i)
