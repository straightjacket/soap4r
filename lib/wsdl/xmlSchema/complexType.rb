=begin
WSDL4R - XMLSchema complexType definition for WSDL.
Copyright (C) 2002, 2003  NAKAMURA, Hiroshi.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PRATICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 675 Mass
Ave, Cambridge, MA 02139, USA.
=end


require 'wsdl/info'
require 'wsdl/xmlSchema/content'


module WSDL
  module XMLSchema


class ComplexType < Info
  attr_accessor :name
  attr_accessor :complexcontent
  attr_accessor :content
  attr_reader :attributes

  def initialize(name = nil)
    super()
    @name = name
    @complexcontent = nil
    @content = nil
    @attributes = NamedElements.new
  end

  def targetnamespace
    parent.targetnamespace
  end

  def each_content
    if content
      content.each do |item|
	yield(item)
      end
    end
  end

  def each_element
    if content
      content.elements.each do |name, element|
	yield(name, element)
      end
    end
  end

  def find_element(name)
    @content.elements.each do |key, element|
      return element if name == key
    end
    nil
  end

  def sequence_elements=(elements)
    @content = Content.new
    @content.type = 'sequence'
    elements.each do |element|
      @content << element
    end
  end

  def all_elements=(elements)
    @content = Content.new
    @content.type = 'all'
    elements.each do |element|
      @content << element
    end
  end

  def parse_element(element)
    case element
    when AllName, SequenceName, ChoiceName
      @content = Content.new
      @content.type = element.name
      @content
    when ComplexContentName
      @complexcontent = ComplexContent.new
      @complexcontent
    when AttributeName
      o = Attribute.new
      @attributes << o
      o
    else
      nil
    end
  end

  def parse_attr(attr, value)
    case attr
    when NameAttrName
      @name = XSD::QName.new(targetnamespace, value)
    else
      raise WSDLParser::UnknownAttributeError.new("Unknown attr #{ attr }.")
    end
  end
end

  end
end
