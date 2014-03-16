require_relative 'lib\wcf_handler'

#http://localhost:1659/Service1.svc
handler = WcfHandler.new('http://localhost:1659/Service1.svc')
res = handler.GetDataUsingDataContract(:composite => {
		:BoolValue => true,
		:StringValue => "ruby2soap"
	})

#res = handler.ConversionRate(:FromCurrency => 'ILS', :ToCurrency => 'GBP')
puts res.body # need to be .result and get the real result !


