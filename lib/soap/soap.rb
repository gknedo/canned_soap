require_relative './soap_action'
require_relative './soap_parameter'
require 'xmlsimple'

module Soap
	# Covert the data to hash
	# Params:
	# +object+:: the object to covert to hash
	def data_to_arr(object)
		return '' if object.nil?
		return [object] unless object.is_a? Hash

		params = {}
		object.each do |key,value|
			params["#{@name_space}:#{key}"] = data_to_arr(value)
		end

		params
	end

	# Build the body that need to be send to the service when calling the soap action and return the result
	# Params :
	# +action+:: +SoapAction+ object that keep all the data about the soap action
	# +data+:: the user data that he want to send to the server
	def build_body(action , data)
		@name_space = 'a'
		body = {
			'soap:Envelope' => {
				'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/',
				'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
				'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
				'soap:Body' => {
					"#{action.name}" => {
						"xmlns" => WsdlParser.target_namespace
					}
				}
			}
		}

		if(!data.nil?)
			data.each do |key, value|
				build_param(body['soap:Envelope']['soap:Body']["#{action.name}"],action,key,value)
			end
		end

		XmlSimple.xml_out(body, 'RootName' => nil)
	end

	# Parse the server response to hash that the user will work eith
	# Params:
	# +res+:: +HTTPI::Response+ object that represent the response from the server
	# +action_name+:: the name of the action that the response is belongs to 
	def get_wcf_response(res,action_name)
		#res.error?
		if res.code.to_i >= 400
			'error please see body'
		else
			result = XmlSimple.xml_in(res.body)['Body'].first["#{action_name}Response"].first["#{action_name}Result"].first
			if result.class == Hash
				# I dont want to return the result xml attributes
				result.select!{|k,v| v.class == Array}
			end

			result
		end
	end

	# Adds to the action element in the +Hash+ and add the user send data to the hash
	# Params:
	# +action_element+:: the action element in the hash of the body
	# +action+:: +SoapAction+ object that keep all the data about the soap action
	# +key+:: the name of the parameter
	# +value+:: the value of the parameter
	def build_param(action_element,action,key,value)
		if(action.parameters.nil?)
			action_element["#{key}"] = ((value.is_a? Hash) ? data_to_arr(value) : [value])
		else		
			current_param = action.parameters.select{|p| p.name.upcase == key.to_s.upcase}.first
			action_element["#{key}"] = ((value.is_a? Hash) ? data_to_arr(value) : [value])
	
			if !current_param.namespace.nil?
				action_element["#{key}"].merge!("xmlns:#{@name_space}" => current_param.namespace)
			end
		end
	end
end


