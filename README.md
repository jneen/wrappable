# Wrappable

This is a handy class I've used over and over again for creating unified interfaces to disparate classes.  Just include the `Wrappable` module (or subclass `Wrappable::Base`) like so:

``` ruby

class Widget
  include Wrappable

  # we already know who to delegate to, so you can optionally
  # leave out the :to => ... field here
  delegate :foo, :bar, :baz

  # create an alias for the underlying wrapped object
  wraps :widget
end

wrapped = Widget.wrap(a_widget)
wrapped.foo # sends #foo to a_widget

# it's idempotent
Widget.wrap(wrapped).object_id == wrapped.object_id # true

```

To unify disparate objects, sometimes I like to override .wrap like so:

``` ruby

class Widget
  include Wrappable

  attr_accessor :gadget

  def self.wrap(o)
    case o
    when Gadget
      new(gadget.widget, :gadget => gadget)
    else
      super(o)
    end
  end
end
```

It's just ruby :).  Have fun!

--Jay
