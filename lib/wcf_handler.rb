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

class WcfHandler
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

	def cookies
		@cookies
	end

	private
		def define_wcf_action(action)
		 	self.class.send(:define_method ,action.name) do |data,*args|
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
