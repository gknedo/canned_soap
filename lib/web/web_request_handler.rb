#require 'ntlm/http'
require 'httpi'
require_relative './secutry_protocols'

module Web
	def get_web_response2(request,uri,*args)
		case args.first
			when SecutryProtocol::NTLM
				use_ntlm(request,*args)
			when SecutryProtocol::GGS_API
				use_kerberos
		end

		res = Net::HTTP::start(uri.host,uri.port) do |http|
			http.request(request)
		end

		res
	end

	def get_web_response(url,headers)
		request = HTTPI::Request.new(url)

		request.headers = headers
		response = HTTPI.get(request)

		response
	end

	def send_message_to_wcf(url,headers,body,*args)
		request = HTTPI::Request.new(url)
		request.headers = headers
		request.body = body

		#TODO: change to user self.send('use_'+)
		case args.first
			when SecutryProtocol::NTLM
				use_ntlm(request,*args)
			when SecutryProtocol::GGS_API
				use_kerberos(request)
			when SecutryProtocol::BASIC
				use_basic(request,*args)
			when SecutryProtocol::DIGEST
				use_digest(request,*args)
		end

		response = HTTPI.post(request)
		response
	end

	private
		def use_ntlm(request,*args)
			# the first is the security name
			user = args[1]
			password = args[2]
			domain = args[3]

			request.auth.ntlm(user,password,domain)# if request.auth.ntlm?
		end

		def use_kerberos(request)
			request.auth.gssnegotiate
		end

		def use_basic(request,*args)
			user = args[1]
			password = args[2]

			request.auth.basic(user,password)
		end

		def use_digest(request,*args)
			user = args[1]
			password = args[2]

			request.auth.digest(user,password)
		end
end