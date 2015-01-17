require 'spec_helper'

describe 'DoublyLinkedList' do

  describe '#new' do
    it "should initialize to empty list" do
      l = DoublyLinkedList.new
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil
    end

    it "should initialize with list info" do
      l = DoublyLinkedList.new :list_info => {:title =>'test list', :description => 'Test out my doubly linked list.'}
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil
      expect(l.list_info).to be_kind_of(Hash)
      expect(l.list_info).to eq( {:title =>'test list', :description => 'Test out my doubly linked list.'} )
    end

    it "should initialize with items" do
      l = DoublyLinkedList.new :items => ['cat','dog','rabbit','fish']
      expect(l.size).to eq 4
      expect(l.first).to eq 'cat'
      expect(l.last).to eq 'fish'
      expect(l.to_a).to eq ['cat','dog','rabbit','fish']
    end

    it "should initialize with list info and items" do
      l = DoublyLinkedList.new :list_info => {:title =>'test list', :description => 'Test out my doubly linked list.'},
                         :items => ['cat','dog','rabbit','fish']
      expect(l.size).to eq 4
      expect(l.first).to eq 'cat'
      expect(l.last).to eq 'fish'
      expect(l.to_a).to eq ['cat','dog','rabbit','fish']
      expect(l.list_info).to be_kind_of(Hash)
      expect(l.list_info).to eq( {:title =>'test list', :description => 'Test out my doubly linked list.'} )
    end
  end

  describe '#add_last' do
    it "should create list and add item when list is empty" do
      l = DoublyLinkedList.new
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil

      expect(l.add_last('cat')).to eq 1
      expect(l.size).to eq 1
      expect(l.first).to eq 'cat'
      expect(l.last).to eq 'cat'
      expect(l.to_a).to eq ['cat']
    end

    it "should add item after last when one item list" do
      l = DoublyLinkedList.new :items => ['dog']
      expect(l.size).to eq 1
      expect(l.first).to eq 'dog'
      expect(l.last).to eq 'dog'

      expect(l.add_last('cat')).to eq 2
      expect(l.size).to eq 2
      expect(l.first).to eq 'dog'
      expect(l.last).to eq 'cat'
      expect(l.to_a).to eq ['dog','cat']
    end

    it "should add item after last when multiple item list" do
      l = DoublyLinkedList.new :items => ['cat','dog','rabbit','fish']
      expect(l.size).to eq 4
      expect(l.first).to eq 'cat'
      expect(l.last).to eq 'fish'

      expect(l.add_last('gerbil')).to eq 5
      expect(l.size).to eq 5
      expect(l.first).to eq 'cat'
      expect(l.last).to eq 'gerbil'
      expect(l.to_a).to eq ['cat','dog','rabbit','fish','gerbil']
    end
  end

  describe '#add_first' do
    it "should create list and add item when list is empty" do
      l = DoublyLinkedList.new
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil

      expect(l.add_first('cat')).to eq 1
      expect(l.size).to eq 1
      expect(l.first).to eq 'cat'
      expect(l.last).to eq 'cat'
      expect(l.to_a).to eq ['cat']
    end

    it "should add item before first when one item list" do
      l = DoublyLinkedList.new :items => ['dog']
      expect(l.size).to eq 1
      expect(l.first).to eq 'dog'
      expect(l.last).to eq 'dog'

      expect(l.add_first('cat')).to eq 2
      expect(l.size).to eq 2
      expect(l.first).to eq 'cat'
      expect(l.last).to eq 'dog'
      expect(l.to_a).to eq ['cat','dog']
    end

    it "should add item before first when multiple item list" do
      l = DoublyLinkedList.new :items => ['cat','dog','rabbit','fish']
      expect(l.size).to eq 4
      expect(l.first).to eq 'cat'
      expect(l.last).to eq 'fish'

      expect(l.add_first('gerbil')).to eq 5
      expect(l.size).to eq 5
      expect(l.first).to eq 'gerbil'
      expect(l.last).to eq 'fish'
      expect(l.to_a).to eq ['gerbil','cat','dog','rabbit','fish']
    end
  end

  describe '#remove_last' do
    it "should return nil when list is empty" do
      l = DoublyLinkedList.new
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil

      expect(l.remove_last).to be_nil
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil
    end

    it "should remove item emptying the list and return item's data when one item list" do
      l = DoublyLinkedList.new :items => ['dog']
      expect(l.size).to eq 1
      expect(l.first).to eq 'dog'
      expect(l.last).to eq 'dog'

      expect(l.remove_last).to eq 'dog'
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil
    end

    it "should add item before first when multiple item list" do
      l = DoublyLinkedList.new :items => ['cat','dog','rabbit','fish']
      expect(l.size).to eq 4
      expect(l.first).to eq 'cat'
      expect(l.last).to eq 'fish'

      expect(l.remove_last).to eq 'fish'
      expect(l.size).to eq 3
      expect(l.first).to eq 'cat'
      expect(l.last).to eq 'rabbit'
      expect(l.to_a).to eq ['cat','dog','rabbit']
    end
  end

  describe '#remove_first' do
    it "should return nil when list is empty" do
      l = DoublyLinkedList.new
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil

      expect(l.remove_first).to be_nil
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil
    end

    it "should remove item emptying the list and return item's data when one item list" do
      l = DoublyLinkedList.new :items => ['dog']
      expect(l.size).to eq 1
      expect(l.first).to eq 'dog'
      expect(l.last).to eq 'dog'

      expect(l.remove_first).to eq 'dog'
      expect(l.size).to eq 0
      expect(l.first).to be_nil
      expect(l.last).to be_nil
    end

    it "should add item before first when multiple item list" do
      l = DoublyLinkedList.new :items => ['cat','dog','rabbit','fish']
      expect(l.size).to eq 4
      expect(l.first).to eq 'cat'
      expect(l.last).to eq 'fish'

      expect(l.remove_first).to eq 'cat'
      expect(l.size).to eq 3
      expect(l.first).to eq 'dog'
      expect(l.last).to eq 'fish'
      expect(l.to_a).to eq ['dog','rabbit','fish']
    end
  end

end