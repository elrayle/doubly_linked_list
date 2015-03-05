require 'spec_helper'

describe 'DoublyLinkedList' do

  before(:all) do
    class DummyList < DoublyLinkedList

      @@clear_first_callback  = lambda { |list_info| list_info.first_item = nil }
      @@clear_last_callback   = lambda { |list_info| list_info.last_item  = nil }
      @@update_first_callback = lambda { |list_info, list| list_info.first_item = list.first.item_id }
      @@update_last_callback  = lambda { |list_info, list| list_info.last_item  = list.last.item_id }

      @@clear_next_callback   = lambda { |list, item_idx| list[item_idx].next_item = nil }
      @@clear_prev_callback   = lambda { |list, item_idx| list[item_idx].prev_item = nil }
      @@update_next_callback  = lambda { |list, item_idx| list[item_idx].next_item = list[item_idx+1].item_id }
      @@update_prev_callback  = lambda { |list, item_idx| list[item_idx].prev_item = list[item_idx-1].item_id }

      @@find_first_callback   = lambda do |list_info, list|
        if list_info
          first_id  = list_info.first_item
          first_idx = list.index { |item| item.item_id == first_id }
          return list[first_idx] if first_idx
        end

        # if first isn't set, try to figure out first by looking for an item with prev_item == nil
        # NOTE: If multiple items have prev_item == nil, it will return the first one it finds.
        first_idx = list.index { |item| item.prev_item == nil }
        first_idx ? list[first_idx] : nil
      end

      @@find_last_callback    = lambda do |list_info, list|
        if list_info
          last_id  = list_info.last_item
          last_idx = list.index { |item| item.item_id == last_id }
          return list[last_idx] if last_idx && last_idx >= 0 && last_idx < list.size
        end

        # if last isn't set, try to figure out last by looking for an item with next_item == nil
        # NOTE: If multiple items have next_item == nil, it will return the first one it finds.
        last_idx = list.index { |item| item.next_item == nil }
        last_idx ? list[last_idx] : nil
      end

      @@find_next_callback    = lambda do |list, current_item|
        next_id  = current_item.next_item
        next_idx = list.index { |item| item.item_id == next_id }
        next_idx ? list[next_idx] : nil
      end
      @@find_prev_callback    = lambda do |list, current_item|
        prev_id  = current_item.prev_item
        prev_idx = list.index { |item| item.item_id == prev_id }
        prev_idx ? list[prev_idx] : nil
      end

      def initialize(*args)
        new_args = args[0].dup unless args.empty?
        new_args = {}  if args.empty?

        # set callbacks
        new_args[:clear_first_callback]  = @@clear_first_callback
        new_args[:clear_last_callback]   = @@clear_last_callback
        new_args[:update_first_callback] = @@update_first_callback
        new_args[:update_last_callback]  = @@update_last_callback

        new_args[:clear_next_callback]   = @@clear_next_callback
        new_args[:clear_prev_callback]   = @@clear_prev_callback
        new_args[:update_next_callback]  = @@update_next_callback
        new_args[:update_prev_callback]  = @@update_prev_callback

        new_args[:find_first_callback]   = @@find_first_callback
        new_args[:find_last_callback]    = @@find_last_callback
        new_args[:find_next_callback]    = @@find_next_callback
        new_args[:find_prev_callback]    = @@find_prev_callback

        super(new_args)
      end

      def self.get_item_by_id(list,id)
        list.index { |item| item.item_id == id }
      end

    end

    class DummyListInfo
      attr_accessor :first_item, :last_item, :item_ids
      def initialize(info)
        @first_item = info[:first_item]  if info.has_key? :first_item
        @last_item  = info[:last_item]   if info.has_key? :last_item
        @item_ids   = info[:item_ids]    if info.has_key? :item_ids
      end
    end

    class DummyListItem
      attr_accessor :next_item, :prev_item, :value, :item_id
      def initialize(item)
        @next_item = item[:next_item]   if item.has_key? :next_item
        @prev_item = item[:prev_item]   if item.has_key? :prev_item
        @value     = item[:value]       if item.has_key? :value
        @item_id   = item[:item_id]     if item.has_key? :item_id
      end
    end
  end

  after(:all) do
    Object.send(:remove_const, "DummyList")
    Object.send(:remove_const, "DummyListInfo")
    Object.send(:remove_const, "DummyListItem")
  end


  describe '#new' do
    it "should initialize to empty list" do
      l = DummyList.new
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil
    end

    it "should initialize with list info" do
      l = DummyList.new :list_info => {:title =>'test list', :description => 'Test out my doubly linked list.'}
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil
      expect(l.list_info).to be_kind_of(Hash)
      expect(l.list_info).to eq( {:title =>'test list', :description => 'Test out my doubly linked list.'} )
    end

    it "should initialize with items" do
      # info  = DummyListInfo.new( :first_item => 2, :last_item => 4, :item_ids => [1,2,3,4] )
      items = []
      items << DummyListItem.new( :item_id => 1, :prev_item => 2,   :next_item => 3,   :value => 'cat' )
      items << DummyListItem.new( :item_id => 2, :prev_item => nil, :next_item => 1,   :value => 'dog' )
      items << DummyListItem.new( :item_id => 3, :prev_item => 1,   :next_item => 4,   :value => 'rabbit' )
      items << DummyListItem.new( :item_id => 4, :prev_item => 3,   :next_item => nil, :value => 'fish' )
      l = DummyList.new :items => items
      # l = DummyList.new :items => items, :list_info => info
      expect(l.size).to eq 4
      expect(l.first.value).to eq 'dog'
      expect(l.last.value).to eq 'fish'
      list_items = l.to_a.collect {|i| i.value }
      expect(list_items).to eq ['dog','cat','rabbit','fish']
    end

    it "should initialize with list info and items" do
      info  = DummyListInfo.new( :first_item => 4, :last_item => 3, :item_ids => [1,2,3,4] )
      items = []
      items << DummyListItem.new( :item_id => 1, :prev_item => 2,   :next_item => 3,   :value => 'cat' )
      items << DummyListItem.new( :item_id => 2, :prev_item => 4,   :next_item => 1,   :value => 'dog' )
      items << DummyListItem.new( :item_id => 3, :prev_item => 1,   :next_item => nil, :value => 'rabbit' )
      items << DummyListItem.new( :item_id => 4, :prev_item => nil, :next_item => 2,   :value => 'fish' )
      l = DummyList.new :items => items, :list_info => info
      expect(l.first_item).to eq 4
      expect(l.last_item).to eq 3
      expect(l.size).to eq 4
      expect(l.first.value).to eq 'fish'
      expect(l.last.value).to eq 'rabbit'
      list_items = l.to_a.collect {|i| i.value }
      expect(list_items).to eq ['fish','dog','cat','rabbit']
    end
  end

  describe '#add_last' do
    it "should create list and add item when list is empty" do
      l = DummyList.new
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil

      new_item = DummyListItem.new({:value=>'cat',:item_id=>'c1'})
      expect(l.add_last(new_item)).to eq 1
      expect(l.size).to eq 1
      expect(l.first.value).to eq 'cat'
      expect(l.last.value).to eq 'cat'
      list_items = l.to_a.collect {|i| i.value }
      expect(list_items).to eq ['cat']
    end

    it "should add item after last when one item list" do
      l = DummyList.new :items => [
          DummyListItem.new({:value=>'dog',:item_id=>'d1',:prev_item=>nil,:next_item=>nil}) ]
      expect(l.size).to eq 1
      expect(l.first.value).to eq 'dog'
      expect(l.last.value).to eq 'dog'

      new_item = DummyListItem.new({:value=>'cat',:item_id=>'c1'})
      expect(l.add_last(new_item)).to eq 2
      expect(l.size).to eq 2
      expect(l.first.value).to eq 'dog'
      expect(l.last.value).to eq 'cat'
      list_items = l.to_a.collect {|i| i.value }
      expect(list_items).to eq ['dog','cat']
    end

    it "should add item after last when multiple item list" do
      l = DummyList.new :items => [
          DummyListItem.new({:value=>'cat',    :item_id=>'c1', :prev_item=>nil,  :next_item=>'d1'}),
          DummyListItem.new({:value=>'dog',    :item_id=>'d1', :prev_item=>'c1', :next_item=>'r1'}),
          DummyListItem.new({:value=>'rabbit', :item_id=>'r1', :prev_item=>'d1', :next_item=>'f1'}),
          DummyListItem.new({:value=>'fish',   :item_id=>'f1', :prev_item=>'r1', :next_item=>nil })]
      expect(l.size).to eq 4
      expect(l.first.value).to eq 'cat'
      expect(l.last.value).to eq 'fish'

      new_item = DummyListItem.new({:value=>'gerbil',:item_id=>'g1'})
      expect(l.add_last(new_item)).to eq 5
      expect(l.size).to eq 5
      expect(l.first.value).to eq 'cat'
      expect(l.last.value).to eq 'gerbil'
      list_items = l.to_a.collect {|i| i.value }
      expect(list_items).to eq ['cat','dog','rabbit','fish','gerbil']
    end
  end

  describe '#add_first' do
    it "should create list and add item when list is empty" do
      l = DummyList.new
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil

      new_item = DummyListItem.new({:value=>'cat',:item_id=>'c1'})
      expect(l.add_first(new_item)).to eq 1
      expect(l.size).to eq 1
      expect(l.first.value).to eq 'cat'
      expect(l.last.value).to eq 'cat'
      list_items = l.to_a.collect {|i| i.value }
      expect(list_items).to eq ['cat']
    end

    it "should add item before first when one item list" do
      l = DummyList.new :items => [
          DummyListItem.new({:value=>'dog',:item_id=>'d1',:prev_item=>nil,:next_item=>nil}) ]
      expect(l.size).to eq 1
      expect(l.first.value).to eq 'dog'
      expect(l.last.value).to eq 'dog'

      new_item = DummyListItem.new({:value=>'cat',:item_id=>'c1'})
      expect(l.add_first(new_item)).to eq 2
      expect(l.size).to eq 2
      expect(l.first.value).to eq 'cat'
      expect(l.last.value).to eq 'dog'
      list_items = l.to_a.collect {|i| i.value }
      expect(list_items).to eq ['cat','dog']
    end

    it "should add item before first when multiple item list" do
      l = DummyList.new :items => [
          DummyListItem.new({:value=>'cat',    :item_id=>'c1', :prev_item=>nil,  :next_item=>'d1'}),
          DummyListItem.new({:value=>'dog',    :item_id=>'d1', :prev_item=>'c1', :next_item=>'r1'}),
          DummyListItem.new({:value=>'rabbit', :item_id=>'r1', :prev_item=>'d1', :next_item=>'f1'}),
          DummyListItem.new({:value=>'fish',   :item_id=>'f1', :prev_item=>'r1', :next_item=>nil })]
      expect(l.size).to eq 4
      expect(l.first.value).to eq 'cat'
      expect(l.last.value).to eq 'fish'

      new_item = DummyListItem.new({:value=>'gerbil',:item_id=>'g1'})
      expect(l.add_first(new_item)).to eq 5
      expect(l.size).to eq 5
      expect(l.first.value).to eq 'gerbil'
      expect(l.last.value).to eq 'fish'
      list_items = l.to_a.collect {|i| i.value }
      expect(list_items).to eq ['gerbil','cat','dog','rabbit','fish']
    end
  end

  describe '#remove_last' do
    it "should return nil when list is empty" do
      l = DummyList.new
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil

      expect(l.remove_last).to be_nil
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil
    end

    it "should remove item emptying the list and return item's data when one item list" do
      l = DummyList.new :items => [
          DummyListItem.new({:value=>'dog',:item_id=>'d1',:prev_item=>nil,:next_item=>nil}) ]
      expect(l.size).to eq 1
      expect(l.first.value).to eq 'dog'
      expect(l.last.value).to eq 'dog'

      expect(l.remove_last.value).to eq 'dog'
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil
    end

    it "should add item before first when multiple item list" do
      l = DummyList.new :items => [
          DummyListItem.new({:value=>'cat',    :item_id=>'c1', :prev_item=>nil,  :next_item=>'d1'}),
          DummyListItem.new({:value=>'dog',    :item_id=>'d1', :prev_item=>'c1', :next_item=>'r1'}),
          DummyListItem.new({:value=>'rabbit', :item_id=>'r1', :prev_item=>'d1', :next_item=>'f1'}),
          DummyListItem.new({:value=>'fish',   :item_id=>'f1', :prev_item=>'r1', :next_item=>nil })]
      expect(l.size).to eq 4
      expect(l.first.value).to eq 'cat'
      expect(l.last.value).to eq 'fish'

      expect(l.remove_last.value).to eq 'fish'
      expect(l.size).to eq 3
      expect(l.first.value).to eq 'cat'
      expect(l.last.value).to eq 'rabbit'
      list_items = l.to_a.collect {|i| i.value }
      expect(list_items).to eq ['cat','dog','rabbit']
    end
  end

  describe '#remove_first' do
    it "should return nil when list is empty" do
      l = DummyList.new
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil

      expect(l.remove_first).to be_nil
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil
    end

    it "should remove item emptying the list and return item's data when one item list" do
      l = DummyList.new :items => [
          DummyListItem.new({:value=>'dog',:item_id=>'d1',:prev_item=>nil,:next_item=>nil}) ]
      expect(l.size).to eq 1
      expect(l.first.value).to eq 'dog'
      expect(l.last.value).to eq 'dog'

      expect(l.remove_first.value).to eq 'dog'
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil
    end

    it "should add item before first when multiple item list" do
      l = DummyList.new :items => [
          DummyListItem.new({:value=>'cat',    :item_id=>'c1', :prev_item=>nil,  :next_item=>'d1'}),
          DummyListItem.new({:value=>'dog',    :item_id=>'d1', :prev_item=>'c1', :next_item=>'r1'}),
          DummyListItem.new({:value=>'rabbit', :item_id=>'r1', :prev_item=>'d1', :next_item=>'f1'}),
          DummyListItem.new({:value=>'fish',   :item_id=>'f1', :prev_item=>'r1', :next_item=>nil })]
      expect(l.size).to eq 4
      expect(l.first.value).to eq 'cat'
      expect(l.last.value).to eq 'fish'

      expect(l.remove_first.value).to eq 'cat'
      expect(l.size).to eq 3
      expect(l.first.value).to eq 'dog'
      expect(l.last.value).to eq 'fish'
      list_items = l.to_a.collect {|i| i.value }
      expect(list_items).to eq ['dog','rabbit','fish']
    end
  end

  describe '#missing_method' do
    before(:all) do
      class Dummy < DummyListInfo
        def hello
          "hello back at you"
        end
        def size
          "very large indeed"
        end
      end
    end
    after(:all) do
      Object.send(:remove_const, "Dummy")
    end

    context "when list responds to missing method" do
      it "should pass method to list and succeed" do
        l = DummyList.new :list_info => Dummy.new({}), :items => [
            DummyListItem.new({:value=>'cat',    :item_id=>'c1', :prev_item=>nil,  :next_item=>'d1'}),
            DummyListItem.new({:value=>'dog',    :item_id=>'d1', :prev_item=>'c1', :next_item=>'r1'}),
            DummyListItem.new({:value=>'rabbit', :item_id=>'r1', :prev_item=>'d1', :next_item=>'f1'}),
            DummyListItem.new({:value=>'fish',   :item_id=>'f1', :prev_item=>'r1', :next_item=>nil })]
        list_items = l.values_at(1..2).collect {|i| i.value }
        expect(list_items).to eq ['dog','rabbit']
        sort_list = l.sort { |x,y| x.value <=> y.value }
        list_items = sort_list.to_a.collect {|i| i.value }
        expect(list_items).to eq ['cat','dog','fish','rabbit']
      end

      it "should pass method to list only even if list_info has the same method and succeed" do
        l = DummyList.new :list_info => Dummy.new({}), :items => [
            DummyListItem.new({:value=>'cat',    :item_id=>'c1', :prev_item=>nil,  :next_item=>'d1'}),
            DummyListItem.new({:value=>'dog',    :item_id=>'d1', :prev_item=>'c1', :next_item=>'r1'}),
            DummyListItem.new({:value=>'rabbit', :item_id=>'r1', :prev_item=>'d1', :next_item=>'f1'}),
            DummyListItem.new({:value=>'fish',   :item_id=>'f1', :prev_item=>'r1', :next_item=>nil })]
        expect(l.size).to eq 4
      end

      it "should pass method each to the list" do
        l = DummyList.new :list_info => Dummy.new({}), :items => [
            DummyListItem.new({:value=>'cat',    :item_id=>'c1', :prev_item=>nil,  :next_item=>'d1'}),
            DummyListItem.new({:value=>'dog',    :item_id=>'d1', :prev_item=>'c1', :next_item=>'r1'}),
            DummyListItem.new({:value=>'rabbit', :item_id=>'r1', :prev_item=>'d1', :next_item=>'f1'}),
            DummyListItem.new({:value=>'fish',   :item_id=>'f1', :prev_item=>'r1', :next_item=>nil })]
        a = []
        l.each do |i|
          a << i
          list_items = l.to_a.collect {|i| i.value }
          expect(list_items).to include i.value
        end
        list_items = a.to_a.collect {|i| i.value }
        expect(list_items).to eq ['cat','dog','rabbit','fish']
      end

      it "should pass method each to the list when block is inline" do
        l = DummyList.new :list_info => Dummy.new({}), :items => [
            DummyListItem.new({:value=>'cat',    :item_id=>'c1', :prev_item=>nil,  :next_item=>'d1'}),
            DummyListItem.new({:value=>'dog',    :item_id=>'d1', :prev_item=>'c1', :next_item=>'r1'}),
            DummyListItem.new({:value=>'rabbit', :item_id=>'r1', :prev_item=>'d1', :next_item=>'f1'}),
            DummyListItem.new({:value=>'fish',   :item_id=>'f1', :prev_item=>'r1', :next_item=>nil })]
        a = []
        l.each { |i| a<<i; list_items = l.to_a.collect {|i| i.value }; expect(list_items).to include i.value }
        list_items = a.to_a.collect {|i| i.value }
        expect(list_items).to eq ['cat','dog','rabbit','fish']
      end
    end

    context "when list does not respond to missing method" do
      it "should pass method to list_info and succeed if list_info responds to that method" do
        l = DummyList.new :list_info => Dummy.new({}), :items => [
            DummyListItem.new({:value=>'cat',    :item_id=>'c1', :prev_item=>nil,  :next_item=>'d1'}),
            DummyListItem.new({:value=>'dog',    :item_id=>'d1', :prev_item=>'c1', :next_item=>'r1'}),
            DummyListItem.new({:value=>'rabbit', :item_id=>'r1', :prev_item=>'d1', :next_item=>'f1'}),
            DummyListItem.new({:value=>'fish',   :item_id=>'f1', :prev_item=>'r1', :next_item=>nil })]
        expect(l.hello).to eq 'hello back at you'
      end

      it "should not pass array method to list_info when @list is empty and succeed if list_info responds to that method" do
        l = DummyList.new :list_info => Dummy.new({})
        expect(l.size).not_to eq 'very large indeed'
        expect(l.size).to eq 0
      end
    end

    context "when neither list nor list_info respond to missing method" do
      it "should raise an error if it is not an array method nor list_info method" do
        l = DummyList.new :list_info => Dummy.new({}), :items => [
            DummyListItem.new({:value=>'cat',    :item_id=>'c1', :prev_item=>nil,  :next_item=>'d1'}),
            DummyListItem.new({:value=>'dog',    :item_id=>'d1', :prev_item=>'c1', :next_item=>'r1'}),
            DummyListItem.new({:value=>'rabbit', :item_id=>'r1', :prev_item=>'d1', :next_item=>'f1'}),
            DummyListItem.new({:value=>'fish',   :item_id=>'f1', :prev_item=>'r1', :next_item=>nil })]
        expect{ l.foo }.to raise_error(NoMethodError, /undefined method `foo'/)
      end
    end
  end

  describe '#inspect' do
    it "should return class and items" do
      l = DummyList.new :list_info => DummyListInfo.new({}), :items => [
          DummyListItem.new({:value=>'cat',    :item_id=>'c1', :prev_item=>nil,  :next_item=>'d1'}),
          DummyListItem.new({:value=>'dog',    :item_id=>'d1', :prev_item=>'c1', :next_item=>'r1'}),
          DummyListItem.new({:value=>'rabbit', :item_id=>'r1', :prev_item=>'d1', :next_item=>nil })]
      expect(l.inspect).to match /#<DummyList:0x(\d|[abcdef])* \[(\s|\S)*@value="cat"(\s|\S)*@value="dog"(\s|\S)*@value="rabbit"(\s|\S)*/
    end
  end

end