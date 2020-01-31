import 'dart:math';

class _Node<T> {
  T value;
  _Node<T> _right;
  _Node<T> _left;

  _Node(this.value);
}

enum _DfsOrder { preOrder, inOrder, postOrder }

class NotFoundException {}

class AvlTree<T> {
  _Node<T> root;

  void insert(T value) => root = _insert(root, value);

  _Node<T> _insert(_Node<T> root, value) {
    if (root == null) {
      root = _Node(value);
    } else if (value < root.value) {
      root._left = _insert(root._left, value);
      root = _balance(root);
    } else if (value > root.value) {
      root._right = _insert(root._right, value);
      root = _balance(root);
    }
    return root;
  }

  void edit(T oldValue, T newValue) {
    var res = _find(root, oldValue);
    if (res == null) NotFoundException();
    res.value = newValue;
  }

  void delete(T key) => root = _delete(root, key);

  _Node<T> _delete(_Node<T> root, key) {
    if (root == null) return root;
    if (key > root.value) {
      root._right = _delete(root._right, key);
    } else if (key < root.value) {
      root._left = _delete(root._left, key);
    } else {
      if (root._left == null && root._right == null) {
        root = null;
      } else if (root._right != null && root._left == null) {
        root = root._right;
      } else if (root._left != null) {
        // find the largest value from the _left tree
        var currentRoot = root._left;
        var max = root._left;
        while (currentRoot != null) {
          if (currentRoot._right != null) {
            max = currentRoot._right;
            currentRoot = currentRoot._right;
          } else {
            currentRoot = currentRoot._left;
          }
        }

        root.value = max.value;
        root._left = _delete(root._left, max.value);
        max = null;
      }
    }
    root = _balance(root);
    return root;
  }

  T find(T key) {
    final res = _find(root, key);
    if (res == null) throw NotFoundException();
    return res.value;
  }

  _Node<T> _find(_Node<T> root, key) {
    if (root == null) return null;
    if (key < root.value) return _find(root._left, key);
    if (key > root.value) return _find(root._right, key);
    return root;
  }

  void inOrder(Function iteratorFunction) {
    _dfsByOrder(_DfsOrder.inOrder, iteratorFunction);
  }

  void preOrder(Function iteratorFunction) {
    _dfsByOrder(_DfsOrder.preOrder, iteratorFunction);
  }

  void postOrder(Function iteratorFunction) {
    _dfsByOrder(_DfsOrder.postOrder, iteratorFunction);
  }

  void _dfsByOrder(_DfsOrder order, Function iteratorFunction) {
    if (root == null) return;
    _dfs(root, order, iteratorFunction);
  }

  void _dfs(_Node<T> root, _DfsOrder order, Function iteratorFunction) {
    if (order == _DfsOrder.preOrder) iteratorFunction(root.value);
    if (root._left != null) _dfs(root._left, order, iteratorFunction);
    if (order == _DfsOrder.inOrder) iteratorFunction(root.value);
    if (root._right != null) _dfs(root._right, order, iteratorFunction);
    if (order == _DfsOrder.postOrder) iteratorFunction(root.value);
  }

  int _height(_Node<T> root) {
    var height = 0;
    if (root != null) {
      var _left = _height(root._left);
      var _right = _height(root._right);
      height = max(_left, _right) + 1;
    }
    return height;
  }

  int _balanceFactor(_Node<T> root) {
    if (root == null) return 0;
    return _height(root._left) - _height(root._right);
  }

  _Node<T> _balance(_Node<T> root) {
    final balanceFactor = _balanceFactor(root);
    if (balanceFactor > 1) {
      if (_balanceFactor(root._left) >= 0) {
        root = _singleRotate_right(root);
      } else {
        // lr_rotat
        root = _doubleRotate_right(root);
      }
    } else if (balanceFactor < -1) {
      if (_balanceFactor(root._right) > 0) {
        // rl_rotat
        root = _doubleRotateLeft(root);
      } else {
        root = _singleRotateLeft(root);
      }
    }
    return root;
  }

  /// 30
  ///   40
  ///     45
  ///
  ///   40
  /// 30  45
  ///
  /// LL Rotation
  _Node<T> _singleRotateLeft(_Node<T> root) {
    final newRoot = root._right;
    if (newRoot._left != null) root._left = newRoot._left;
    newRoot._left = root;
    root._right = null;
    return newRoot;
  }

  ///     70
  ///   60
  /// 55
  ///
  ///   60
  /// 55  70
  ///
  /// RR Rotation
  _Node<T> _singleRotate_right(_Node<T> root) {
    final newRoot = root._left;
    if (newRoot._right != null) root._right = newRoot._right;
    newRoot._right = root;
    root._left = null;
    return newRoot;
  }

  _Node<T> _doubleRotate_right(_Node<T> root) {
    final newRoot = root._left._right;
    newRoot._left = root._left;
    root._left._right = null;
    root._left = null;
    newRoot._right = root;
    return newRoot;
  }

  _Node<T> _doubleRotateLeft(_Node<T> root) {
    final newRoot = root._right._left;
    newRoot._right = root._right;
    root._right._left = null;
    root._right = null;
    newRoot._left = root;
    return newRoot;
  }
}

class _Number {
  int a;

  _Number(this.a);

  bool operator <(_Number other) => a < other.a;
  bool operator >(_Number other) => a > other.a;
}

void main() {
  final tree = AvlTree<_Number>();

  // double _right test
  // tree.insert(_Number(50));
  // tree.insert(_Number(90));
  // tree.insert(_Number(40));
  // tree.insert(_Number(60));
  // tree.insert(_Number(70));

  // double _left test
  // tree.insert(_Number(50));
  // tree.insert(_Number(90));
  // tree.insert(_Number(30));
  // tree.insert(_Number(40));
  // tree.insert(_Number(20));

  tree.insert(_Number(50));
  tree.insert(_Number(90));
  tree.insert(_Number(40));
  tree.insert(_Number(70));
  tree.insert(_Number(100));

  tree.delete(_Number(50));
  tree.insert(_Number(16));
  tree.insert(_Number(18));
  tree.insert(_Number(178));
  // print(tree.root.value.a);

  tree.preOrder((a) => print(a.a));
  // tree.find(_Number(50)).a = 8798797;
  // print(tree.root.value.a);
}
