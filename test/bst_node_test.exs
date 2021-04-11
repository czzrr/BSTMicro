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

  test "Insert sequence of elements" do
    node1 = %BSTNode{value: 19}
    node2 = BSTNode.insert(node1, 7)
    node3 = BSTNode.insert(node2, 11)
    node4 = BSTNode.insert(node3, 5)

    assert node4 == %BSTNode{
             left: %BSTNode{left: %BSTNode{value: 5}, value: 7, right: %BSTNode{value: 11}},
             value: 19
           }
  end
end
