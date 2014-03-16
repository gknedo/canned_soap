require_relative 'lib\wcf_handler'

def complex_object_example
	handler = WcfHandler.new('http://localhost:1659/Service1.svc')
	res = handler.GetDataUsingDataContract(:composite => {
		:BoolValue => true,
		:StringValue => "ruby2soap"
	})
end

##http://localhost:1659/Service1.svc
#handler = WcfHandler.new('http://localhost:1659/Service1.svc')
##handler.Initialize(:clientName => "ruby2soap")
##handler.
#res = handler.GetDataUsingDataContract(:composite => {
#		:BoolValue => true,
#		:StringValue => "ruby2soap"
#	})
#
#puts res.body # need to be .result and get the real result !

#handler = WcfHandler.new('http://www.webservicex.net/CurrencyConvertor.asmx')
#puts handler.ConversionRate(:FromCurrency => 'GBP', :ToCurrency => 'ILS').body
def cookie_state_full_example
	handler = WcfHandler.new('http://localhost:1659/Service1.svc')
	handler.Init(:userName => 'ericman93')
	handler.IncreaseScore()
end