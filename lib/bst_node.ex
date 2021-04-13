defmodule BSTNode do
  @moduledoc """
  A node of a binary search tree with integer elements.

  Keys:

  * left: The left child of the node. Default value is nil.

  * value: The element of the node. Default value is 0.
    
  * right: The right child of the node. Default value is nil.
  """
  @derive [Poison.Encoder]
  defstruct left: nil, value: 0, right: nil
  
  @spec insert(BSTNode, integer) :: BSTNode
  @doc """
  Insert the integer n into the binary search tree rooted at the given node.
  If n is already present the tree is unchanged.

  ## Examples

       iex> BSTNode.insert(nil, 7)
       %BSTNode{left: nil, right: nil, value: 7}


       iex> node = %BSTNode{value: 7}
       %BSTNode{left: nil, right: nil, value: 7}
       iex> BSTNode.insert(node, 7)
       %BSTNode{left: nil, right: nil, value: 7}

       

       iex> node = %BSTNode{left: %BSTNode{value: 5}, value: 7}
       %BSTNode{left: %BSTNode{left: nil, right: nil, value: 5}, right: nil, value: 7}
       iex> BSTNode.insert(node, 6)
       %BSTNode{
         left: %BSTNode{
         left: nil,
         right: %BSTNode{left: nil, right: nil, value: 6},
         value: 5
         },
         right: nil,
         value: 7
       }

  """
  def insert(node, n) do
    case node do
      nil -> %BSTNode{value: n}
      
      %BSTNode{left: left, value: value} when n < value ->
          %{node | left: insert(left, n)}
      
      %BSTNode{value: value, right: right} when n > value ->
          %{node | right: insert(right, n)}
      
      _ -> node
    end
  end

  @spec mapToBSTNode(%{}) :: BSTNode
  @doc """
  Transforms a binary search tree represented as a map with string keys into a BSTNode struct.

  ## Examples

  iex> mapToBSTNode(%{})
  nil

  iex> mapToBSTNode(%{"left" => %{"left" => nil, "value" => 3, "right" => nil} "value" => 5, "right" => nil})
  %BSTNode{left: %BSTNode{left: nil, value: 3, right: nil}, value: 5, right= nil}
  """
  def mapToBSTNode(map) do
    case map do
      nil -> nil
      %{"left" => left, "value" => value, "right" => right} when map_size(map) == 3 ->
        %BSTNode{left: mapToBSTNode(left), value: value, right: mapToBSTNode(right)}
      _ -> raise "Error when transforming map to BSTNode"
    end
  end

  def fromList(xs) do
    Enum.reduce(xs, nil,
      (fn n, node -> BSTNode.insert(node, n) end))
  end
  
end
