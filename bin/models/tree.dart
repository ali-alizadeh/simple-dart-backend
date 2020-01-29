import 'dart:math';

class _Node<W> {
  W _value;
  _Node _right;
  _Node _left;

  _Node(this._value);
}

class Tree<T> {
  _Node<T> _root;

  Tree();

  void insert(T value) => _root = _insert(_root, value);

  _Node<T> _insert(_Node<T> root, value) {
    if (root == null) {
      root = _Node(value);
    } else if (value < root._value) {
      root._left = _insert(root._left, value);
    } else if (value > root._value) {
      root._right = _insert(root._right, value);
    }
    return root;
  }

  void depthFirstTraversal(
    DepthFirstTraversalOrder order,
    Function iteratorFunction,
  ) {
    if (_root == null) return;
    _depthFirstTraversal(_root, order, iteratorFunction);
  }

  void _depthFirstTraversal(
    _Node<T> root,
    DepthFirstTraversalOrder order,
    Function iteratorFunction,
  ) {
    if (order == DepthFirstTraversalOrder.preOrder) {
      iteratorFunction(root._value);
    }
    if (root._left != null) {
      _depthFirstTraversal(root._left, order, iteratorFunction);
    }
    if (order == DepthFirstTraversalOrder.inOrder) {
      iteratorFunction(root._value);
    }
    if (root._right != null) {
      _depthFirstTraversal(root._right, order, iteratorFunction);
    }
    if (order == DepthFirstTraversalOrder.postOrder) {
      iteratorFunction(root._value);
    }
  }

  void breadthFirstTraversal(Function iteratorFunction) {
    var queue = [_root];
    while (queue.isNotEmpty) {
      var tree_Node = queue.removeAt(0);
      iteratorFunction(tree_Node._value);
      if (tree_Node._left != null) {
        queue.add(tree_Node._left);
      }
      if (tree_Node._right != null) {
        queue.add(tree_Node._right);
      }
    }
  }

  int get height => _height(_root);

  int _height(_Node root) {
    var height = 0;
    if (root != null) {
      var left = _height(root._left);
      var right = _height(root._right);
      height = max(left, right) + 1;
    }
    return height;
  }

  /// R Rotation
  void _rightRotaion(_Node node) {}

  /// L Rotation
  void _leftRotate(_Node node) {}

  /// RR Rotation
  void _rightleftRotaion(_Node node) {}

  /// LR Rotation
  void _leftRightRotaion(_Node node) {}
}

enum DepthFirstTraversalOrder { preOrder, inOrder, postOrder }

class PrimitiveWrapper {
  var value;
  PrimitiveWrapper(this.value);

  bool operator <(PrimitiveWrapper other) => value < other.value;

  bool operator >(PrimitiveWrapper other) => value > other.value;
}

void main() {
  var tree = Tree<PrimitiveWrapper>();
  tree.insert(PrimitiveWrapper(50));
  tree.insert(PrimitiveWrapper(40));
  tree.insert(PrimitiveWrapper(30));
  tree.insert(PrimitiveWrapper(45));
  tree.insert(PrimitiveWrapper(60));
  tree.insert(PrimitiveWrapper(70));
  tree.insert(PrimitiveWrapper(55));
  tree.insert(PrimitiveWrapper(56));
  tree.insert(PrimitiveWrapper(57));
  tree.insert(PrimitiveWrapper(58));
  tree.insert(PrimitiveWrapper(41));

  print(tree.height);

  // tree.depthFirstTraversal(
  //     DepthFirstTraversalOrder.inOrder, (node) => print(node.value));

  // tree.breadthFirstTraversal((a) => print(a.value));
}
