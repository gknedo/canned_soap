module Soap
	class SoapParamter
		attr_accessor :name, :nullable, :type, :namespace

		# Gets the xml element of the paramter and parse it to a +SoapParamter+ object
		# Params:
		# +param_element+:: +Hash+ that represent the xml element of the paramter
		def self.parse(param_element)
			param = SoapParamter.new
			param.name = param_element['name']
			param.type = param_element['type'].split(':').last
			yield param if block_given?

			param
		end
	end
end