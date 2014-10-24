module Dictionary
  class SplayTree
    attr_reader :size

    def initialize
      @root, @size = nil, 0
    end
    
    def insert(key, value)
      @root = splay(key, @root)
      return nil if @root && @root.key == key
      @size += 1
      if @root.nil?
        @root = Node.new(key, value)
      elsif key > @root.key
        @root = Node.new(key, value, @root, @root.right_child)
	@root.left_child.right_child = nil
      else
        @root = Node.new(key, value, @root.left_child, @root)
	@root.right_child.left_child = nil
      end
    end

    def remove(key)
      @root = splay(key, @root)
      return nil unless @root && @root.key == key
      elem = @root.value
      @size -= 1
      @root.left_child = splay(10000000000000, @root.left_child)
      if @root.left_child
        @root.left_child.right_child = @root.right_child
	@root = @root.left_child
      else
        @root = @root.right_child
      end
      return elem
    end

    def find(key)
      @root = splay(key, @root)
      return nil unless @root && @root.key == key
      @root.value
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
        " [#{key}: #{value}] " 
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

    def rotate_right(node)
      unless node.nil? || node.left_child.nil?
        new_root = node.left_child
        node.left_child = new_root.right_child
        new_root.right_child = node
        return new_root
      end
      return node
    end

    def rotate_left(node)
      unless node.nil? || node.right_child.nil?
        new_root = node.right_child
        node.right_child = new_root.left_child
        new_root.left_child = node
        return new_root
      end
      return node
    end

    def splay(key, node)
      return nil if node.nil?
      if node.key == key
        return node
      elsif key < node.key
        if node.left_child.nil?
	  return node # inorder successor
	elsif key < node.left_child.key
	  node.left_child.left_child = splay(key, node.left_child.left_child)
	  node.left_child = rotate_right(node.left_child)
	elsif key > node.left_child.key
	  node.left_child.right_child = splay(key, node.left_child.right_child)
	  node.left_child = rotate_left(node.left_child)
        end
        return rotate_right(node)
      elsif key > node.key
        if node.right_child.nil?
	  return node # inorder predecessor
	elsif key > node.right_child.key
	  node.right_child.right_child = splay(key, node.right_child.right_child)
	  node.right_child = rotate_left(node.right_child)
	elsif key < node.right_child.key
	  node.right_child.left_child = splay(key, node.right_child.left_child)
	  node.right_child = rotate_right(node.right_child)
	end
	return rotate_left(node)
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
    end
  end
end

