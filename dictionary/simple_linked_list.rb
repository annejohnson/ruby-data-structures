module Dictionary
  class SimpleLinkedList
    def insert(key, value)
      @head = Node.new(key, value, @head)
    end

    def find(key)
      curr = @head
      while !curr.nil? && curr.key != key
        curr = curr.link
      end # either curr is nil, or curr.key = key
      curr ? curr.value : nil
    end

    def remove(key)
      if @head
        if @head.key == key
          temp = @head.value
          @head = @head.link
          return temp
        end

        curr = @head
        while !curr.link.nil? && curr.link.key != key
          curr = curr.link
        end # curr.link = nil, or curr.link.key = key
        if curr.link
          temp = curr.link.value
          curr.link = curr.link.link
          return temp
        end
      end
      nil
    end

    def to_s
      str = "{"
      curr = @head
      while !curr.nil?
        str += ":#{curr.key} => #{curr.value}, "
        curr = curr.link
      end
      str.chomp(", ") + "}"
    end

    Node = Struct.new(:key, :value, :link)
  end
end
