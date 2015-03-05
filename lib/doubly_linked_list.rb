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

  @clear_first  = nil   # ( list_info )           returns nothing
  @clear_last   = nil   # ( list_info )           returns nothing
  @update_first = nil   # ( list_info, list )     returns nothing
  @update_last  = nil   # ( list_info, list )     returns nothing

  @clear_next   = nil   # ( list, item_idx )      returns nothing
  @clear_prev   = nil   # ( list, item_idx )      returns nothing
  @update_next  = nil   # ( list, item_idx )      returns nothing
  @update_prev  = nil   # ( list, item_idx )      returns nothing

  @find_first   = nil   # ( list_info, list )     returns instance of item in list
  @find_last    = nil   # ( list_info, list )     returns instance of item in list
  @find_next    = nil   # ( list, current_item )  returns instance of item in list
  @find_prev    = nil   # ( list, current_item )  returns instance of item in list

  def initialize(*args)
    @list      = []
    @list_info = nil

    if !args.empty? && args[0].is_a?(Hash)
      @list      = args[0][:items]              if args[0].key?(:items)
      @list_info = args[0][:list_info]          if args[0].key?(:list_info)

      # set callbacks
      @clear_first  = args[0][:clear_first_callback]  if args[0].key?(:clear_first_callback)
      @clear_last   = args[0][:clear_last_callback]   if args[0].key?(:clear_last_callback)
      @update_first = args[0][:update_first_callback] if args[0].key?(:update_first_callback)
      @update_last  = args[0][:update_last_callback]  if args[0].key?(:update_last_callback)

      @clear_next   = args[0][:clear_next_callback]   if args[0].key?(:clear_next_callback)
      @clear_prev   = args[0][:clear_prev_callback]   if args[0].key?(:clear_prev_callback)
      @update_next  = args[0][:update_next_callback]  if args[0].key?(:update_next_callback)
      @update_prev  = args[0][:update_prev_callback]  if args[0].key?(:update_prev_callback)

      @find_first   = args[0][:find_first_callback]   if args[0].key?(:find_first_callback)
      @find_last    = args[0][:find_last_callback]    if args[0].key?(:find_last_callback)
      @find_next    = args[0][:find_next_callback]    if args[0].key?(:find_next_callback)
      @find_prev    = args[0][:find_prev_callback]    if args[0].key?(:find_prev_callback)

      unless @list.empty?
        @list = organize_list
        update_first_in_listinfo
        update_last_in_listinfo
      end
    end
    raise ArgumentError, "items list must be an Array" unless @list.kind_of?(Array)
    self
  end

  ##
  # Get the number of items in the list.
  #
  # @return the number of items
  def size
    @list.size
  end
  alias_method :count, :size

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
    raise ArgumentError 'data must have non-nil value' unless data
    @list << data
    if @list.size > 1
      update_next_in_listitem(tail-1)
      update_prev_in_listitem(tail)
    else
      clear_prev_in_listitem(tail)
      update_first_in_listinfo
    end
    clear_next_in_listitem(tail)
    update_last_in_listinfo
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
    raise ArgumentError 'data must have non-nil value' unless data
    @list.insert(0,data)
    if @list.size > 1
      update_prev_in_listitem(head+1)
      update_next_in_listitem(head)
    else
      clear_next_in_listitem(head)
      update_last_in_listinfo
    end
    clear_prev_in_listitem(head)
    update_first_in_listinfo
    @list.size
  end

  ##
  # Remove node from the end of the list.
  #
  # @return data stored in the removed node
  def remove_last
    return nil if @list.empty?
    item = @list.delete_at(tail)
    if @list.size > 0
      clear_next_in_listitem(tail)
      update_last_in_listinfo
    else
      clear_first_in_listinfo
      clear_last_in_listinfo
    end
    item
  end

  ##
  # Removes data from the beginning of the list.
  #
  # @return data stored in the removed node
  def remove_first
    return nil if @list.empty?
    item = @list.delete_at(head)
    if @list.size > 0
      clear_prev_in_listitem(head)
      update_first_in_listinfo
    else
      clear_first_in_listinfo
      clear_last_in_listinfo
    end
    item
  end

  # Returns list array without list info.
  #
  def to_a
    @list
  end
  alias_method :to_ary, :to_a

  # Passing all missing methods to the list so all array operations can be performed.
  def method_missing method_id, *args, &block
    begin
      return @list.send(method_id,*args, &block)     if @list.respond_to?(method_id)
      return @list_info.send(method_id,*args,&block) if @list_info.respond_to?(method_id)
      super
    rescue
      super
    end
  end

  def inspect
    sprintf('#<%s:%#x %s>', self.class, self.__id__, to_a.inspect)
  end

private

  # head returns the first index into the array list.  See first method to get the first item in the list.
  def head
    @list && @list.size > 0 ? 0 : nil
  end

  # tail returns the last index into the array list.  See last method to get the last item in the list.
  def tail
    @list && @list.size > 0 ? @list.size-1 : nil
  end

  def valid_list?
    @list && !@list.empty?
  end

  def item_idx_in_range(item_idx)
    item_idx >= head && item_idx <= tail
  end

  def clear_first_in_listinfo
    @clear_first.call(@list_info,@list)  if @clear_first && @list_info
  end

  def update_first_in_listinfo
    @update_first.call(@list_info,@list) if @update_first && @list_info && valid_list?
  end

  def clear_last_in_listinfo
    @clear_last.call(@list_info,@list)   if @clear_last && @list_info
  end

  def update_last_in_listinfo
    @update_last.call(@list_info,@list)  if @update_last && @list_info && valid_list?
  end

  def clear_next_in_listitem(item_idx)
    @clear_next.call(@list,item_idx)     if @clear_next && valid_list? && item_idx_in_range(item_idx)
  end

  def update_next_in_listitem(item_idx)
    @update_next.call(@list,item_idx)    if @update_next && valid_list? && item_idx_in_range(item_idx)
  end

  def clear_prev_in_listitem(item_idx)
    @clear_prev.call(@list,item_idx)     if @clear_prev && valid_list? && item_idx_in_range(item_idx)
  end

  def update_prev_in_listitem(item_idx)
    @update_prev.call(@list,item_idx)    if @update_prev && valid_list? && item_idx_in_range(item_idx)
  end

  def find_first_in_listinfo
    @find_first.call(@list_info,@list)   if @find_first && (@list_info || valid_list?)
  end

  def find_last_in_listinfo
    @find_last.call(@list_info,@list)   if @find_last && (@list_info || valid_list?)
  end

  def find_next_listitem(current_item)
    @find_next.call(@list,current_item) if @find_next && valid_list? && current_item
  end

  def find_prev_listitem(current_item)
    @find_prev.call(@list,current_item) if @find_prev && valid_list? && current_item
  end

  def organize_list
    return @list unless @find_first && @find_next
    first_item = find_first_in_listinfo
    return @list unless first_item
    organized = []
    organized[0] = first_item
    1.upto(@list.length-1) do |idx|
      current_item = organized[idx-1]
      next_item = find_next_listitem(current_item)
      organized[idx] = next_item
    end
    organized
  end

end
