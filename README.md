# Thin wrapper for Maxflow
Thin Python wrapper for a modified version of the Maxflow algorithm by Yuri Boykov and Vladimir Kolmogorov. The original source code by Vladimir Kolmogorov availbable at http://pub.ist.ac.at/~vnk/software.html. This wrapper uses a modified version with support for larger graphs and slightly lower memory usage.

## Installation
Install package using `pip install thinmaxflow` or clone this repository. Building the package requires Cython.

## Graph types
Currently, there are four different types of graphs: `GraphInt`, `GraphShort`, `GraphFloat` and `GraphDouble`. The only difference is the underlying datatypes used for the edge capacities in the graph. For stability, it is recommended to use `GraphInt` for integer capacities and `GraphDouble` for floating point capacities. However, in some cases, it maybe be favourable to use `GraphShort` or `GraphFloat` to reduce memory consumption.

## Tiny example
```python
import thinmaxflow as tf

# Create graph object.
graph = tf.GraphInt()

# Number of nodes to add.
nodes_to_add = 2

# Add two nodes.
first_node_id = graph.add_node(nodes_to_add)

# Add edges.
graph.add_tweights(0, 5, 0) # s     --5->   n(0)
graph.add_tweights(0, 0, 1) # n(0)  --1->   t
graph.add_tweights(1, 0, 3) # n(1)  --3->   t
graph.add_edge(0, 1, 2, 1)  # n(0)  --2->   n(1)
                            # n(1)  --1->   n(0)

# Find maxflow/cut graph.
flow = graph.maxflow()

for n in range(nodes_to_add):
    segment = graph.what_segment(n)
    print('Node %d belongs to segment %d.' % (n, segment))
# Node 0 belongs to segment 0.
# Node 1 belongs to segment 1.
    
print('Maximum flow: %s' % flow)
# Maximum flow: 3
```

## License
As the Maxflow implementation is distributed under the GPLv3 license, so is this package.