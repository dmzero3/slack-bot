module.exports =  (robot) ->

  appId = "dj0zaiZpPVo2OE0zSkxjb2lzcyZzPWNvbnN1bWVyc2VjcmV0Jng9OWU-"
  location =
    lat: "35.65532"
    lon: "139.69378"
  apiUrl = "http://weather.olp.yahooapis.jp/v1/place?coordinates=#{location.lat},#{location.lon}&appid=#{appId}&output=json"

  getWeatherData = () ->
    request = robot.http(apiUrl).get()
    console.log 'log'
    request (err, res, body) ->
      json = JSON.parse body

  robot.respond /天気/i, (msg) ->
    getWeatherData()
