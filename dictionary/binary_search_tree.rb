module Dictionary
  class BinarySearchTree
    attr_reader :size

    def initialize
      @root, @size = nil, 0
    end
    
    def insert(key, value)
      @root = insert_r(key, value, @root) 
    end

    def remove(key)
      @root = remove_r(key, @root)
    end

    def find(key)
      find_r(key, @root)
    end

    def to_s(style = :inorder)
      str = case style
        when :inorder then inorder(@root)
	when :preorder then preorder(@root)
	when :postorder then postorder(@root)
	when :levelorder then levelorder(@root)
	when :structured then structured_string(@root, 0)
      end.strip
    end

    class Node < Struct.new(:key, :value, :left_child, :right_child) 
      def to_s
        " [#{key.to_s}: #{value.to_s}] " 
      end

      def is_leaf?
        left_child.nil? && right_child.nil?
      end
    end

    class Queue < Array
      def enqueue(node)
        push(node)
      end

      def dequeue
        shift
      end
    end
    
    private

    def insert_r(key, value, node)
      if node.nil?
	@size += 1
        return Node.new(key, value)
      elsif key < node.key
        node.left_child = insert_r(key, value, node.left_child)
      elsif key > node.key
        node.right_child = insert_r(key, value, node.right_child)
      end
      return node
    end

    def remove_r(key, node)
      if node.nil?
        return nil
      elsif key < node.key
        node.left_child = remove_r(key, node.left_child)
      elsif key > node.key
        node.right_child = remove_r(key, node.right_child)
      else # key == node.key
        if node.is_leaf?
	  @size -= 1
          return nil
	elsif node.left_child.nil?
	  @size -= 1
	  return node.right_child
	elsif node.right_child.nil?
	  @size -= 1
	  return node.left_child
	else # node has 2 children
          successor = leftmost(node.right_child)
	  node.key = successor.key
	  node.value = successor.value
          node.right_child = remove_r(successor.key, node.right_child)
        end
      end
      return node
    end

    def find_r(key, node)
      return nil if node.nil?
      if key < node.key
        find_r(key, node.left_child)
      elsif key > node.key
        find_r(key, node.right_child)
      else # key == node.key
        node.value
      end
    end

    def leftmost(node)
      if node.left_child.nil?
        return node
      else
        return leftmost(node.left_child)
      end
    end
    
    def structured_string(node, indentation)
      return "" if node.nil?
      str = "\n" + (" " * indentation) + node.to_s
      str += structured_string(node.left_child, indentation + 2)
      str += structured_string(node.right_child, indentation + 2)
    end

    def preorder(node)
      return "" if node.nil?
      str = node.to_s
      str += preorder(node.left_child)
      str += preorder(node.right_child)
    end

    def postorder(node)
      return "" if node.nil?
      str = postorder(node.left_child)
      str += postorder(node.right_child)
      str += node.to_s
    end

    def levelorder(node)
      str = ""
      unless node.nil?
        q = Queue.new
	q.enqueue(node)
	while !q.empty?
          curr = q.dequeue
          str += curr.to_s
	  q.enqueue(curr.left_child) unless curr.left_child.nil?
	  q.enqueue(curr.right_child) unless curr.right_child.nil?
        end
      end
      str
    end

    def inorder(node)
      str = ""
      return str if node.nil?
      str += inorder(node.left_child)
      str += node.to_s
      str += inorder(node.right_child)
      str
    end
  end
end

