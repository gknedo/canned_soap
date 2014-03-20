require 'net/http'
require 'xmlsimple'
require_relative 'wsdl\wsdl'
include Wsdl
#require 'soap/soap'
#include Soap
#include WebRequestHandler
#require_relative 'wsdl.rb'
#require_relative 'wsdl_parser.rb'
#require_relative 'soap.rb'
#include WsdlParser
#include Soap

#Dir["lib/*.rb"].each {|file| 
#	require file
#	#require_relative file# if file != 'wcf_handler'
#	#include file.gsub('.rb','')
#}

# Handle the requests to the service
class WcfHandler
	# C'tor.
	# Parse the wsdl and create a method to each WCF/WebService method
	# Params:
	# +service_url+:: the url of your service
	# +save_cookeis+:: should save cookies of the result
	def initialize(service_url,save_cookeis = true)
		HTTPI.log = false
		@cookies = []
		@save_cookeis = save_cookeis

		@uri = URI("#{service_url}")

		wsdl = WsdlParser.parse(service_url)
		@service_address = wsdl.location_address

		wsdl.actions.each do |action|
			define_wcf_action(action)
		end

		# maybe create class for each service and the function will be there
	end

	# Return the the current cookie set
	def cookies
		@cookies
	end

	private
		# Define a method to the +WcfHandler+ object base on the method from the WSDL
		# Params:
		# +action+:: +SoapAction+ that have all the info about the method from the WSDL
		def define_wcf_action(action)
		 	self.class.send(:define_method ,action.name) do |data=nil,*args|
				body = build_body(action, data)

				res = send_wcf_action(action.soap_action,body,*args)
				(@cookies << res.headers["Set-Cookie"]) if @save_cookeis
				
				result = get_wcf_response(res,action.name)
				res.singleton_class.send(:define_method,:result) do
					result
				end

				#if(res.code == '401') # not autorized
				#	(raise "Please use ntlm") if res['WWW-Authenticate'].include?('NTLM')
				#end

				res
			end

			#create new method that takes the data and user and password and user ntlm
		end

		# Call to wcf method
		# Params:
		# +soap_action+:: the value of the SOAPAction header
		# +body+:: the body of the HTTP request
		# +args+:: metadata that indicate wich autountication to use
		def send_wcf_action(soap_action,body,*args)
			#req = Net::HTTP::Post.new(@uri.path)
			#req = Net::HTTP::Post.new(@service_address)

			#req["SOAPAction"] = soap_action
			#req["Content-Type"] = "text/xml; charset=utf-8"
			#req["Cookie"] = @cookies.join(',') unless @cookies.empty?
			#req.body = body

			yield(req) if block_given?

			#get_web_response(req,@uri,*args)
			# "Cookie" => (@cookies.join(',') unless @cookies.empty?)
			cookies = @cookies.empty? ? "" : @cookies.join(',')
			send_message_to_wcf(@service_address,
							 {"SOAPAction" => soap_action,
							  "Content-Type" => "text/xml; charset=utf-8",
							  "Cookie" => cookies},
							  body, *args)
		end 
end
