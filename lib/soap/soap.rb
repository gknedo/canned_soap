require_relative './soap_action'
require_relative './soap_parameter'

module Soap
	def varibles_to_xml(veribles ,*args)
		# check if the number of args is equels to the exptecrd

		params = {}
		args.each_with_index do |arg,i|
			params[veribles[i]] = arg
		end

		XmlSimple.xml_out(params,'RootName' => nil)#.gsub(/\s+/,'').match('<root>(.*)</root>')[1]
	end

	def data_to_xml(object)
		varibles_to_xml(object.keys,object.values)
	end

	def data_to_arr(object)
		return '' if object.nil?
		return [object] unless object.is_a? Hash

		params = {}
		object.each do |key,value|
			params["#{@name_space}:#{key}"] = data_to_arr(value)
		end

		params
	end

	def build_body(action , data)
		#xml_data = data_to_xml(data)
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

	def get_wcf_response(res,action_name)
		#result = XmlSimple.xml_in(res.body)
		if res.code.to_i >= 400
			#error
			#fault = result['Body'].first['Fault']
			#fault.first['faultstring'].first['content']
			'error'
		else
			#m = res.body.match("<#{action_name}Result>(.*)</#{action_name}Result>")
			#return nil if m.nil?

			#XmlSimple.xml_in(m[0])
		end
	end

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


