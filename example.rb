require_relative 'lib\ruby2soap'

def complex_object_example
	handler = Ruby2Soap.new('http://localhost:1659/Service1.svc')
	res = handler.GetDataUsingDataContract(:composite => {
		:BoolValue => true,
		:StringValue => "ruby2soap"
	})
end

def cookie_state_full_example
	handler = Ruby2Soap.new('http://localhost:1659/Service1.svc')
	handler.Init(:userName => 'ericman93')
	handler.IncreaseScore()
end

def few_params_example
	handler = Ruby2Soap.new('http://www.webservicex.net/CurrencyConvertor.asmx')
	handler.ConversionRate(:FromCurrency => 'ILS', :ToCurrency => 'GBP')
end

def ntlm_example
	handler = Ruby2Soap.new('http://localhost:1659/Service1.svc')
	handler.AddPoints({:points => 6},SecutryProtocol::NTLM,'user','password','domain')
end


#puts few_params_example.body
handler = Ruby2Soap.new('http://localhost:1659/Service1.svc')
res = handler.GetDataUsingDataContract(:composite => {
	:BoolValue => true,
	:StringValue => "ruby2soap"
})
puts res.result