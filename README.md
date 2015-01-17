# DoublyLinkedList

[![Build Status](https://travis-ci.org/elrayle/doubly_linked_list.png?branch=master)](https://travis-ci.org/elrayle/doubly_linked_list) 
[![Coverage Status](https://coveralls.io/repos/elrayle/doubly_linked_list/badge.png?branch=master)](https://coveralls.io/r/elrayle/doubly_linked_list?branch=master)
[![Gem Version](https://badge.fury.io/rb/doubly_linked_list.svg)](http://badge.fury.io/rb/doubly_linked_list)
[![Dependency Status](https://www.versioneye.com/ruby/doubly_linked_list/0.0.4/badge.svg)](https://www.versioneye.com/ruby/doubly_linked_list/0.0.4)


Ruby implementation of doubly linked list, following some Ruby idioms.



## Installation

Add this line to your application's Gemfile:

    gem 'doubly_linked_list'
    

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install doubly_linked_list 


## Usage

```ruby
l = DoublyLinkedList.new
l.add_last('cat')
l.add_last('dog')
l.add_first('fish')
l.to_a
# => ['fish','cat','dog']
l.size
# => 3

l = DoublyLinkedList.new :items => ['cat','dog','fish']
l.to_a
# => ['cat','dog','fish']

l = DoublyLinkedList.new :list_info => {:title =>'test list', :description => 'Test out my doubly linked list.'},
                   :items => ['cat','dog','rabbit','fish']
l.to_a
# => ['cat','dog','rabbit','fish']
l.list_info
# => {:title =>'test list', :description => 'Test out my doubly linked list.'}

l.remove_first
#=> 'cat'
l.remove_last
#=> 'fish'
```


## TODO

* Insert / delete in the middle
* Batch add in the middle
* Move item to different position
* Call back for item movements

## Tests

Run test with

```shell
$ rspec
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/doubly_linked_list/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

