require_relative 'lib\wcf_handler'

handler = WcfHandler.new('http://www.webservicex.net/CurrencyConvertor.asmx')
res = handler.ConversionRate(:FromCurrency => 'ILS', :ToCurrency => 'GBP')
puts res.body # need to be .result and get the real result !


