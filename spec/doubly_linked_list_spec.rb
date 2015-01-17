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

  describe '#missing_method' do
    it "should pass method to list and succeed if it is an array method" do
      l = DoublyLinkedList.new :items => ['cat','dog','rabbit','fish']
      expect(l.size).to eq 4
      expect(l.values_at(1..2)).to eq ['dog','rabbit']
      expect(l.sort).to eq ['cat','dog','fish','rabbit']
    end

    it "should pass method to list and raise an error if it is not an array method" do
      l = DoublyLinkedList.new :items => ['cat','dog','rabbit','fish']
      expect{ l.foo }.to raise_error(NoMethodError, /undefined method `foo'/)
    end
  end

  describe '#inspect' do
    it "should return class and items" do
      l = DoublyLinkedList.new :items => ['cat','dog','rabbit']
      expect(l.inspect).to match /#<DoublyLinkedList:0x(\d|[abcdef])* \[\"cat\", \"dog\", \"rabbit\"\]/
    end
  end

  describe "Array" do
    describe "#move" do
      it "should move an element to first position" do
        a = [1,2,3,4,5,6,7,8,9,10]
        expect(a.move(4,0)).to eq [5,1,2,3,4,6,7,8,9,10]
      end

      it "should move an element to last position" do
        a = [1,2,3,4,5,6,7,8,9,10]
        expect(a.move(5,9)).to eq [1,2,3,4,5,7,8,9,10,6]
      end

      it "should move an element from first to middle position" do
        a = [1,2,3,4,5,6,7,8,9,10]
        expect(a.move(0,4)).to eq [2,3,4,5,1,6,7,8,9,10]
      end

      it "should move an element from last to middle position" do
        a = [1,2,3,4,5,6,7,8,9,10]
        expect(a.move(9,4)).to eq [1,2,3,4,10,5,6,7,8,9]
      end

      it "should move an element forward from middle" do
        a = [1,2,3,4,5,6,7,8,9,10]
        expect(a.move(3,6)).to eq [1,2,3,5,6,7,4,8,9,10]
      end

      it "should move an element backward from middle" do
        a = [1,2,3,4,5,6,7,8,9,10]
        expect(a.move(6,3)).to eq [1,2,3,7,4,5,6,8,9,10]
      end

      it "should move an element beyond end of list" do
        a = [1,2,3,4,5,6,7,8,9,10]
        expect(a.move(6,12)).to eq [1,2,3,4,5,6,8,9,10,nil,nil,nil,7]
      end

      it "should move an element counting from right when 'from' is negative" do
        a = [1,2,3,4,5,6,7,8,9,10]
        expect(a.move(-3,2)).to eq [1,2,8,3,4,5,6,7,9,10]
      end

      it "should move an element counting to position counting from right when 'to' is negative" do
        a = [1,2,3,4,5,6,7,8,9,10]
        expect(a.move(2,-3)).to eq [1,2,4,5,6,7,8,3,9,10]
      end

      it "should add nil at 'to' position if 'from' negative number exceeds size" do
        a = [1,2,3,4,5,6,7,8,9,10]
        expect(a.move(-20,3)).to eq [1,2,3,nil,4,5,6,7,8,9,10]
      end

      it "should raise error if 'to' negative number exceeds size" do
        a = [1,2,3,4,5,6,7,8,9,10]
        expect{ a.move(3,-20) }.to raise_error(IndexError,'index -19 too small for array; minimum: -9')
      end
    end
  end
end