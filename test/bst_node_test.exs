defmodule BSTNodeTest do
  use ExUnit.Case

  test "Default values" do
    assert %BSTNode{} == %BSTNode{left: nil, value: 0, right: nil}
  end

  test "Insert into empty tree" do
    assert BSTNode.insert(nil, 1) == %BSTNode{value: 1}
  end

  test "Insert element already in tree" do
    node = %BSTNode{value: 1}
    assert BSTNode.insert(node, 1) == node
  end

  test "Insert smaller element" do
    node = %BSTNode{value: 3}
    assert BSTNode.insert(node, 1) == %BSTNode{left: %BSTNode{value: 1}, value: 3}
  end

  test "Insert larger element" do
    node = %BSTNode{value: 3}
    assert BSTNode.insert(node, 5) == %BSTNode{value: 3, right: %BSTNode{value: 5}}
  end

  test "Insert sequence of positive elements" do
    node = BSTNode.from_list([19, 7, 11, 5])
    assert node == %BSTNode{
             left: %BSTNode{left: %BSTNode{value: 5}, value: 7, right: %BSTNode{value: 11}},
             value: 19
           }
  end

  test "Insert sequence of negative elements" do
    node = BSTNode.from_list([-101, -47, -61, -11])
    assert node == %BSTNode{
      left: nil,
      value: -101,
      right: %BSTNode{
        left: %BSTNode{value: -61},
        value: -47,
        right: %BSTNode{value: -11}},
    }
  end

  test "Insert sequence of mixed elements" do
    node = BSTNode.from_list([14, -51, -13, 79])
    assert node == %BSTNode{
      left: %BSTNode{value: -51, right: %BSTNode{value: -13}},
      value: 14,
      right: %BSTNode{value: 79}
    }
  end
end
