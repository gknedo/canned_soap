module Soap
	class SoapParamter
		attr_accessor :name, :nullable, :type, :namespace

		def self.parse()
			#TODO:parse from xml to SoapParamter object
		end
	end
end