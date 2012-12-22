Mongoid Colors
===============

Mongoid Colors colorizes the mongoid query debug traces.  
It uses [Coderay](https://github.com/rubychan/coderay) to do so.

Best served chilled with [irb-config](https://github.com/nviennot/irb-config).

What does it look like?
------------------------

### Watch the screencast of irb config

[![Watch the screencast!](https://s3.amazonaws.com/velvetpulse/screencasts/irb-config-screencast.jpg)](http://velvetpulse.com/2012/11/19/improve-your-ruby-workflow-by-integrating-vim-tmux-pry/)

Usage
------

If you don't use irb-config, you can use it as follow:

```ruby
gem 'mongoid-colors'
```

```ruby
MongoidColors::Colorizer.setup # hijack Mongoid.logger.formatter
```

TODO
----

* Testing

License
-------

MIT License
