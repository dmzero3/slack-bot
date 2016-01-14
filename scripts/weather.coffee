module.exports =  (robot) ->

  # 雨の強さについては気象庁のWEBサイト参考
   # http://www.jma.go.jp/jma/kishou/know/yougo_hp/amehyo.html

  yahooAppId = "dj0zaiZpPVo2OE0zSkxjb2lzcyZzPWNvbnN1bWVyc2VjcmV0Jng9OWU-"
  location =
    lat: "35.65532"
    lon: "139.69378"
  yahooApiUrl = "http://weather.olp.yahooapis.jp/v1/place?coordinates=#{location.lat},#{location.lon}&appid=#{yahooAppId}&output=json"

  getWeatherData = () ->
    request = robot.http(yahooApiUrl).get()
    request (err, res, body) ->
      json = JSON.parse body
      weather = json.Feature[0].Property.WeatherList.Weather
      rainFall = weather[0].Rainfall

      if err
        console.log "天気データを取得できませんでした。"
        return

      if !rainFall
        text = "現在雨は降ってません"
      else
        if rainFall >= 1
          text = "弱い雨が降ってます。傘は必要ないかもしれないです。"
        else if rainFall >= 3
          text = "弱い雨が降ってます。傘は必要だと思われます。"
        else if rainFall >= 5
          text = "雨が降ってます。傘は必要です。"
        else if rainFall >= 10
          text = "やや強い雨ですが降ってます。地面からの跳ね返りで足元がぬれるかもしれないです。"
        else if rainFall >= 20
          text = "強い雨が降ってます。傘をさしていても濡れるでしょう。"
        else if rainFall >= 30
          text = "激しい雨が降ってます。傘をさしていても濡れるでしょう。"
        else if rainFall >= 50
          text = "非常に激しい雨が降ってます。傘は全く役に立たないでしょう。"
        else if rainFall >= 80
          text = "猛烈な雨です。傘は全く役に立たないでしょう。"



      console.log text


  robot.respond /天気/i, (msg) ->
    getWeatherData()
