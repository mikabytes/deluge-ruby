## Deluge Ruby Client

This is a client library written in Ruby for communicating with Deluge daemon process. This implementation currently only supports V3 of the protocol (any version with major number 3, e.g. Deluge 3.3).

It has all core and daemon RPC functions defined, and you can access any plugin exported functions through the Deluge#call method. 

### Usage

```ruby
gem install deluge

# defaults are 'localhost', '58846'
d = Deluge.new '192.168.1.11', '58800'

d.login 'user', 'pass'

d.add_torrent_url 'http://some-evil-tracker.com/juicy.torrent'

# example of the dynamic Deluge#call method
d.call 'webui.get_config', {}
```

### Methods

See _lib/deluge_ for all defined methods.
