# SOAP4R - Ruby type mapping schema definition utility.
# Copyright (C) 2007  NAKAMURA Hiroshi <nahi@ruby-lang.org>.

# This program is copyrighted free software by NAKAMURA, Hiroshi.  You can
# redistribute it and/or modify it under the same terms of Ruby's license;
# either the dual license version in 2003, or any later version.


require 'xsd/codegen/gensupport'


module SOAP
module Mapping


class SchemaElementDefinition
  attr_reader :varname, :mapped_class, :elename

  def initialize(varname, mapped_class, elename, as_any, as_array)
    @varname = varname
    @mapped_class = mapped_class
    @elename = elename
    @as_any = as_any
    @as_array = as_array
  end

  def as_any?
    @as_any
  end

  def as_array?
    @as_array
  end
end

module SchemaComplexTypeDefinition
  include Enumerable

  def initialize
    @content = []
    @element_cache = {}
  end

  def is_concrete_definition
    true
  end

  def <<(ele)
    @content << ele
  end

  def each
    @content.each do |ele|
      yield ele
    end
  end

  def size
    @content.size
  end

  def as_any?
    false
  end

  def as_array?
    false
  end

  def find_element(qname)
    @element_cache[qname] ||= search_element(qname)
  end

private

  def search_element(qname)
    each do |ele|
      if ele.respond_to?(:find_element)
        found = ele.find_element(qname)
        return found if found
      else
        # relaxed match
        if ele.elename == qname or
            (qname.namespace.nil? and ele.elename.name == qname.name)
          return ele
        end
      end
    end
    nil
  end
end

class SchemaEmptyDefinition
  include SchemaComplexTypeDefinition

  def initialize
    super()
    @content.freeze
  end
end

class SchemaSequenceDefinition
  include SchemaComplexTypeDefinition

  def initialize
    super()
  end

  def choice?
    false
  end

  # override
  def as_array?
    @as_array ||= false
  end

  def set_array
    @as_array = true
  end
end

class SchemaChoiceDefinition
  include SchemaComplexTypeDefinition

  def initialize
    super()
  end

  def choice?
    true
  end
end

class SchemaDefinition
  EMPTY = SchemaEmptyDefinition.new

  attr_reader :class_for
  attr_reader :elename, :type
  attr_reader :qualified
  attr_accessor :attributes
  attr_accessor :elements

  def initialize(class_for, elename, type, qualified)
    @class_for = class_for
    @elename = elename
    @type = type
    @qualified = qualified
    @elements = EMPTY
    @attributes = nil
  end

  def choice?
    @elements.choice?
  end
end


end
end