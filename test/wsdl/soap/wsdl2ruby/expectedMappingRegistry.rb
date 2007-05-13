require 'echo_version.rb'
require 'soap/mapping'

module Echo_versionMappingRegistry
  EncodedRegistry = ::SOAP::Mapping::EncodedRegistry.new
  LiteralRegistry = ::SOAP::Mapping::LiteralRegistry.new

  EncodedRegistry.register(
    :class => Version_struct,
    :schema_ns => "urn:example.com:simpletype-rpc-type",
    :schema_type => "version_struct",
    :schema_element => [
      ["version", ["SOAP::SOAPString", XSD::QName.new(nil, "version")]],
      ["msg", ["SOAP::SOAPString", XSD::QName.new(nil, "msg")]]
    ]
  )

  EncodedRegistry.register(
    :class => Version,
    :schema_ns => "urn:example.com:simpletype-rpc-type",
    :schema_type => "version"
  )

  LiteralRegistry.register(
    :class => Version_struct,
    :schema_ns => "urn:example.com:simpletype-rpc-type",
    :schema_type => "version_struct",
    :schema_qualified => false,
    :schema_element => [
      ["version", ["SOAP::SOAPString", XSD::QName.new(nil, "version")]],
      ["msg", ["SOAP::SOAPString", XSD::QName.new(nil, "msg")]]
    ]
  )

  LiteralRegistry.register(
    :class => Version,
    :schema_ns => "urn:example.com:simpletype-rpc-type",
    :schema_type => "version"
  )
end