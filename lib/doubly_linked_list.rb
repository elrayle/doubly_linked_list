class Array
  def move(from,to)
    insert(to, delete_at(from))
  end
end

class DoublyLinkedList
  ## Doubly Linked List implementation
  #
  # The list is implemented using an array such that the following linked list concepts are represented as...
  #    * head is the first item in the list
  #    * tail is the last item in the list
  #    * next is the next array element
  #    * prev is the previous array element
  #

  # include Conversions

  attr_accessor :list_info
  # attr_writer   :node_update_callback   # TODO Add callback to update node info

  def initialize(*args)
    @list      = []
    @list      = args[0][:items] if ! args.empty? && args[0].is_a?(Hash) && args[0].key?(:items)
    @list_info = nil
    @list_info = args[0][:list_info] if ! args.empty? && args[0].is_a?(Hash) && args[0].key?(:list_info)
    self
  end

  ##
  # Get the first element of the list.
  #
  # @return first node in the list or nil
  def first
    return nil if @list.empty?
    @list[head]
  end

  ##
  # Get the last element of the list.
  #
  # @return last node in the list or nil
  def last
    return nil if @list.empty?
    @list[tail]
  end

  ##
  # Add data to the end of the list.
  #
  # @parameter [Object] data - any object
  #
  # @return position where added
  def add_last(data)
    @list << data
    @list.size
  end
  alias_method :<<, :add_last

  ##
  # Add data as the first item in the list.
  #
  # @parameter [Object] data - any object
  #
  # @return position where added
  def add_first(data)
    @list.insert(0,data)
    @list.size
  end

  ##
  # Remove node from the end of the list.
  #
  # @return data stored in the removed node
  def remove_last
    return nil if @list.empty?
    @list.delete_at(tail)
  end

  ##
  # Removes data from the beginning of the list.
  #
  # @return data stored in the removed node
  def remove_first
    return nil if @list.empty?
    @list.delete_at(head)
  end

  # Returns list array without list info.
  #
  def to_a
    @list
  end
  alias_method :to_ary, :to_a

  # Passing all missing methods to the list so all array operations can be performed.
  def method_missing method_id, *args, &block
  # def method_missing method_id, *args
    begin
      # return @list.send(method_id,*args)
      return @list.send(method_id,*args, &block)
    rescue
      super
    end
  end

  def inspect
    sprintf('#<%s:%#x %s>', self.class, self.__id__, to_a.inspect)
  end

private

  def head
    @list && @list.size > 0 ? 0 : nil
  end

  def tail
    @list && @list.size > 0 ? @list.size-1 : nil
  end
end
