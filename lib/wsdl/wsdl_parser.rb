require 'xmlsimple'
require_relative '..\soap\soap'
require_relative '..\web\web_request_handler'
include Soap
include Web

module Wsdl
	class WsdlParser
		def self.parse(service)
			@service = service
			wsdl_xml = get_wsdl_xml('wsdl')
			doc = XmlSimple.xml_in(wsdl_xml)

			res = Wsdl.new
			res.actions = get_action_from_wsdl(doc)
			res.location_address = get_location_address(doc)
			res.target_namespace = doc['targetNamespace']

			res
		end

		def self.target_namespace
			@@target_namespace
		end

		private
			def self.get_wsdl_xml(extension)
				uri = URI("#{@service}")

				res = get_web_response("#{@service}?#{extension}",
										{"Accept" => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
										 "Accept-Encoding" => 'gzip,deflate,sdch'})
				res.body
			end

			def self.get_action_datacontact(action_name)
				if @xsd_namespace.nil?
					xsd0 = get_wsdl_xml('xsd=xsd0')
					doc = XmlSimple.xml_in(xsd0)

					import = doc['import']
					@xsd_namespace = (import.first['namespace'] unless import.nil?)
				end

				@xsd_namespace
			end

			def self.get_action_from_wsdl(doc)
				result = []

				@@target_namespace = doc['targetNamespace']
				should_read_from_xsd = !doc['types'].first['schema'].nil?

				binding = doc['binding'].first
				binding['operation'].each do |opp|
					action = SoapAction.new

					action.name = opp['name']
					action.soap_action = opp['operation'].first['soapAction']
					action.parameters = get_action_params(action.name,opp, should_read_from_xsd)

					result << action
				end

				result
			end

			def self.get_location_address(doc)
				service = doc['service']
				location = service.first['port'].first['address'].first['location']

				location
			end

			def self.get_action_params(action_name,opp,should_read_from_xsd)	
				if(should_read_from_xsd)
					#get_action_params_from_xsd(action_name)
				else
					#get_action_params_from_wsdl(action_name,opp)
				end
			end

			def self.get_action_params_from_wsdl(action_name, opp)
				#puts opp['input'].first
				nil #soon
			end

			def self.get_action_params_from_xsd(action_name)
				if @elements.nil?
					#@elements = {}
					xsd0 = get_wsdl_xml('xsd=xsd0')
					doc = XmlSimple.xml_in(xsd0)

					@elements = doc['element']

					return nil if @elements.nil? # the page dose not have shceme
				end

				element = @elements.select{|e| e['name'] == action_name}.first
				sequence = element['complexType'].first['sequence'].first

				sequence['element'].map do |e|
					param = SoapParamter.new
					param.name = e['name']
					param.nullable = e['nillable']
					param.type = e['type'].split(':').last

					namespace_element = e.select{|key,value| key.match(/xmlns(.*)/)}.first
					(param.namespace = namespace_element[1]) unless namespace_element.nil?
					
					param
				end
			end
	end
end