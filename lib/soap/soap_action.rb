module Soap
	class SoapAction
		attr_accessor :name, :soap_action, :parameters

		def self.parse()
			#TODO:parse from xml to SoapParamter object
		end
	end
end