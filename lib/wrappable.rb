module Wrappable
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def wrap(o)
      case o
      when self
        o
      else
        new(o)
      end
    end

    alias [] wrap

    def wraps(m)
      alias_method m, :wrapped
    end

    # by default, delegate to :@wrapped, so you don't have
    # to pass the :to => ... option
    def delegate(*args)
      args = args.dup

      if args.last.is_a? Hash
        opts = args.pop
      else
        opts = {}
      end

      opts[:to] ||= :wrapped

      super(*args << opts)
    end
  end

  attr_reader :wrapped
  def initialize(wrapped, opts={})
    @wrapped = wrapped
    set!(opts)
  end

  def set!(opts={})
    opts.each do |k, v|
      send("#{k}=", v)
    end

    self
  end

  class Base
    include Wrappable
  end
end
