import unittest

from thinmaxflow import GraphDouble, GraphFloat, GraphInt, GraphShort


class TestGraph(unittest.TestCase):

    def setUp(self):
        self.graph_types = [GraphShort, GraphInt, GraphFloat, GraphDouble]

    def test_create_graph(self):
        """Test graph constructors."""
        for graph_type in self.graph_types:
            graph_type()

        for graph_type in self.graph_types:
            graph_type(100, 100)

    def test_add_node(self):
        """Test add_node function."""
        for graph_type in self.graph_types:

            graph = graph_type()

            node_id = graph.add_node(1)
            self.assertEqual(node_id, 0)

            node_count = graph.get_node_num()
            self.assertEqual(node_count, 1)

            node_id = graph.add_node(100)
            self.assertEqual(node_id, 1)

            node_count = graph.get_node_num()
            self.assertEqual(node_count, 101)

    def test_add_edge(self):
        """Test add_edge function."""
        for graph_type in self.graph_types:

            graph = graph_type()

            node_id = graph.add_node(2)
            self.assertEqual(node_id, 0)

            node_count = graph.get_node_num()
            self.assertEqual(node_count, 2)

            graph.add_edge(0, 1, 1, 2)
            edge_count = graph.get_arc_num()
            self.assertEqual(edge_count, 2)

    def test_example(self):
        """Test maxflow function."""
        for graph_type in self.graph_types:

            graph = graph_type()

            # Number of nodes to add.
            nodes_to_add = 2

            # Add two nodes.
            first_node_id = graph.add_node(nodes_to_add)
            self.assertEqual(first_node_id, 0)

            # Add edges.
            graph.add_tweights(0, 5, 0)  # s     --5->   n(0)
            graph.add_tweights(0, 0, 1)  # n(0)  --1->   t
            graph.add_tweights(1, 0, 3)  # n(1)  --3->   t
            graph.add_edge(0, 1, 2, 1)  # n(0)  --2->   n(1)
            # n(1)  --1->   n(0)
            self.assertEqual(graph.get_arc_num(), 2)

            # Find maxflow/cut graph.
            flow = graph.maxflow()

            for n in range(nodes_to_add):
                segment = graph.what_segment(n)
                self.assertEqual(n, segment)
            # Node 0 belongs to segment 0.
            # Node 1 belongs to segment 1.

            self.assertEqual(flow, 3)
            # Maximum flow: 3


if __name__ == "__main__":
    unittest.main()
