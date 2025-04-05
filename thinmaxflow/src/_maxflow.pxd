# _maxflow.pxd
# distutils: language = c++

from libcpp cimport bool


cdef extern from "core/graph.h":
    ctypedef enum termtype:
        SOURCE = 0,
        SINK = 1

    ctypedef int node_id

    cdef cppclass Graph[captype, tcaptype, flowtype]:
        Graph(int node_num_max, long long edge_num_max) except +
        node_id add_node(int num)
        void add_edge(node_id i, node_id j, captype cap, captype rev_cap)
        void add_tweights(node_id i, tcaptype cap_source, tcaptype cap_sink)
        flowtype maxflow(bool reuse_trees)
        termtype what_segment(node_id i, termtype default_segm)
        void reset()
        int get_node_num()
        long long get_arc_num()
        void mark_node(node_id i)
