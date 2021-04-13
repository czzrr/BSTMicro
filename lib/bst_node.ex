defmodule BSTNode do
  @moduledoc """
  A node of a binary search tree with integer elements.

  Keys:

  * left: The left child of the node. Default value is nil.

  * value: The element of the node. Default value is 0.
    
  * right: The right child of the node. Default value is nil.
  """
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

      # Insert smaller elements to the left
      %BSTNode{left: left, value: value} when n < value ->
          %{node | left: insert(left, n)}

      # Insert larger elements to the right
      %BSTNode{value: value, right: right} when n > value -> 
          %{node | right: insert(right, n)}

      # Return unchanged node if element already exists
      _ -> node
    end
  end

  @type bst_map :: %{
    String.t => bst_map,
    String.t => integer,
    String.t => bst_map
  } | nil
  @spec from_map(bst_map) :: BSTNode
  @doc """
  Transforms a binary search tree represented as a map with string keys into a BSTNode struct.

  ## Examples

       iex> map_to_bst_node(%{})
       nil

       iex> map_to_bst_node(%{"left" => %{"left" => nil, "value" => 3, "right" => nil}, "value" => 5, "right" => nil})
       %BSTNode{left: %BSTNode{left: nil, right: nil, value: 3}, right: nil, value: 5}
  """
  def from_map(map) do
    case map do
      nil -> nil
      %{"left" => left, "value" => value, "right" => right} when map_size(map) == 3 ->
        %BSTNode{left: from_map(left), value: value, right: from_map(right)}
      _ -> raise "Error when transforming map to BSTNode"
    end
  end

  @spec from_list([integer]) :: BSTNode
  @doc """
  Creates a binary search tree from the given list by repeatedly inserting its elements.

  ## Examples
  
       iex> from_list([3, 1, 2])
       %BSTNode{
         left: %BSTNode{
           left: nil,
           right: %BSTNode{left: nil, right: nil, value: 2},
           value: 1
         },
         right: nil,
         value: 3
       }

  """
  def from_list(list) do
    Enum.reduce(list, nil,
      (fn n, node -> BSTNode.insert(node, n) end))
  end
  
end
