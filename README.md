#Canned#

A rewrite version of the [ruby2soap](https://github.com/ericman93/ruby2soap) gem.

##Motivation
The original gem has a lot of bugs and don't work on Linux environments. I started to maintain an old gem that uses this gem, so I started to maintain this gem too.

#Ruby2Soap Doc
I started this project when I needed to call a WCF method which required cookies on init. Unfortunalty, I could not find any gem that will help me so, so I implemented it myself.

While working I noticed that I need more features - authentication, for example.

Please post any bugs, questions and feature requests using the 'Issues' page.

Thank you,
Eric


##Examples

###Initialize the handler

```ruby
handler = WcfHandler.new('http://www.webservicex.net/CurrencyConvertor.asmx')
```

###Simple objects
```ruby
handler.ConversionRate(:FromCurrency => 'ILS', :ToCurrency => 'GBP')
```

###Statefull
```ruby
  handler.Init(:userName => 'ericman93')
  handler.IncreaseScore() #the cookies saved automaticly
```

###Complex type
```ruby
handler = WcfHandler.new('http://localhost:1659/Service1.svc')
res = handler.GetDataUsingDataContract(:composite => {:BoolValue => true,:StringValue => "ruby2soap"})
```

##Result
The object that the soap service function returns is actually a HTTP response with 'result' function that returns the actual value.
If the value is a complex object, then it would be represented as a hash


##Authentication
Available authentications
1. NTLM
2. Basic
3. Digest

###NTLM Auth
```ruby
handler.ConversionRate({:FromCurrency => 'ILS', :ToCurrency => 'GBP'},SecutryProtocol::NTLM,'user','password')
```
###With domain
```ruby
handler.ConversionRate({:FromCurrency => 'ILS', :ToCurrency => 'GBP'},SecutryProtocol::NTLM,'user','password','domain')
```
