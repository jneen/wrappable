describe Wrappable do
  let(:klass) { Class.new { include Wrappable } }

  it 'wraps a thing' do
    wrapped = klass.wrap(:foo)
    assert { wrapped.class == klass }
    assert { wrapped.wrapped == :foo }
  end

  it 'is idempotent' do
    first_wrapped = klass.wrap(:bar)
    second_wrapped = klass.wrap(first_wrapped)

    assert { first_wrapped.object_id == second_wrapped.object_id }
  end

  it 'provides fancy aliases' do
    klass.class_eval do
      wraps :widget
    end

    assert { klass.wrap(:a_widget).widget == :a_widget }
  end

  describe 'with an alias and an accessor' do
    before do
      klass.class_eval do
        wraps :gadget
        attr_accessor :widget
      end
    end

    it 'sets other things with an options hash' do
      # note .new here, not .wrap
      wrapped = klass.new(:a_gadget, :widget => :a_widget)

      assert { wrapped.gadget == :a_gadget }
      assert { wrapped.widget == :a_widget }
    end

    # assuming #delegate is defined...
    # ... nothing to see here ...
    class Module
      def delegate(*args)
        methods = args.dup

        opts = if methods.last.is_a? Hash
          methods.pop
        else
          {}
        end

        methods.each do |method|
          define_method(method) { |*a| send(opts[:to]).send(method, *a) }
        end
      end
    end

    it 'delegates to the wrapped object by default' do
      widget = Object.new
      gadget = Object.new

      mock(gadget).method1
      mock(widget).method2

      klass.class_eval do
        delegate :method1
        delegate :method2, :to => :widget
      end

      wrapped = klass.new(gadget, :widget => widget)

      wrapped.method1
      wrapped.method2
    end
  end
end
