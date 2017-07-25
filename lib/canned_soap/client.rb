include CannedSoap::Wsdl
# Handle the requests to the service
module CannedSoap
	class Client
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
		end

		# Return the the current cookie set
		def cookies
			@cookies
		end

		private
		# Define a method to the +Ruby2Soap+ object base on the method from the WSDL
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
				res
			end
		end

		# Call to wcf method
		# Params:
		# +soap_action+:: the value of the SOAPAction header
		# +body+:: the body of the HTTP request
		# +args+:: metadata that indicate wich autountication to use
		def send_wcf_action(soap_action,body,*args)
			yield(req) if block_given?
			cookies = @cookies.empty? ? "" : @cookies.join(',')
			header = {
				"SOAPAction" => soap_action,
				"Content-Type" => "text/xml; charset=utf-8",
				"Cookie" => cookies
			}
			send_message_to_wcf(@service_address, header, body, *args)
		end
	end
end
