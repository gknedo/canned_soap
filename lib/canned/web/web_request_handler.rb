require 'httpi'
require 'canned/web/security_protocol'

# Handle all the communication to the service
module Canned::Web
	# Send Http get rquest to a url and return his result via +HTTPI+
	# Params:
	# +url+:: the url to send the request to
	# +headers+:: hash that keeps the headers that need to be send to the service
	def get_web_response(url,headers)
		request = HTTPI::Request.new(url)

		request.headers = headers
		response = HTTPI.get(request)

		response
	end

	# Send http request to the service
	# Params:
	# +url+:: the url to send the request to
	# +headers+:: hash that keeps the headers that need to be send to the service
	# +body+:: the body of the HTTP request
	# +args+:: metadata that indicate wich autountication to use
	def send_message_to_wcf(url,headers,body,*args)
		request = HTTPI::Request.new(url)
		request.headers = headers
		request.body = body

		#TODO: change to user self.send('use_'+)
		case args.first
		when SecurityProtocol::NTLM
				use_ntlm(request,*args)
			when SecurityProtocol::GGS_API
				use_kerberos(request)
			when SecurityProtocol::BASIC
				use_basic(request,*args)
			when SecurityProtocol::DIGEST
				use_digest(request,*args)
		end

		response = HTTPI.post(request)
		response
	end

	private
		# Use ntlm auth in the request
		# Params:
		# +request+:: +HTTPI::Request+ request
		# +args+:: keep the data that need to be uses for the NTLM auth
		def use_ntlm(request,*args)
			# the first is the security name
			user = args[1]
			password = args[2]
			domain = args[3]

			request.auth.ntlm(user,password,domain)# if request.auth.ntlm?
		end

		# Use kerberos auth in the request
		# Params:
		# +request+:: +HTTPI::Request+ request
		def use_kerberos(request)
			request.auth.gssnegotiate
		end

		# Use basic auth in the request
		# Params:
		# +request+:: +HTTPI::Request+ request
		# +args+:: keep the data that need to be uses for the basic auth
		def use_basic(request,*args)
			user = args[1]
			password = args[2]

			request.auth.basic(user,password)
		end

		# Use digest auth in the request
		# Params:
		# +request+:: +HTTPI::Request+ request
		# +args+:: keep the data that need to be uses for the digest auth
		def use_digest(request,*args)
			user = args[1]
			password = args[2]

			request.auth.digest(user,password)
		end
end
