CronJob = require('cron').CronJob

module.exports =  (robot) ->

  # 雨の強さについては気象庁のWEBサイト参考
  # http://www.jma.go.jp/jma/kishou/know/yougo_hp/amehyo.html

  yahooAppId = "dj0zaiZpPVo2OE0zSkxjb2lzcyZzPWNvbnN1bWVyc2VjcmV0Jng9OWU-"
  location =
    lat: "35.65532"
    lon: "139.69378"
  yahooApiUrl = "http://weather.olp.yahooapis.jp/v1/place?coordinates=#{location.lon},#{location.lat}&appid=#{yahooAppId}&output=json"

  livedoorCityCode = "130010"
  livedooeApiUrl = "http://weather.livedoor.com/forecast/webservice/json/v1?city=#{livedoorCityCode}"

  getWeatherData = () ->
    new Promise (resolve, reject) ->

      request = robot.http(yahooApiUrl).get()
      request (err, res, body) ->
        json = JSON.parse body
        weather = json.Feature[0].Property.WeatherList.Weather
        rainFall = weather[0].Rainfall

        if err
          text = "現在の天気データを取得できませんでした。"
          reject text
          return

        if !rainFall
          text = "雨は降ってません。"
        else
          if rainFall > 0 and rainFall < 1
            text = "霧雨です。傘は必要ないかもしれないです。"
          else if rainFall >= 1 and rainFall < 3
            text = "弱い雨が降ってます。念のため傘はあったほうがよいと思います。"
          else if rainFall >= 3 and rainFall < 5
            text = "弱い雨が降ってます。傘は必要だと思われます。"
          else if rainFall >= 5 and rainFall < 10
            text = "雨が降ってます。傘は必要です。"
          else if rainFall >= 10 and rainFall < 20
            text = "やや強い雨ですが降ってます。地面からの跳ね返りで足元がぬれるかもしれないです。"
          else if rainFall >= 20 and rainFall < 30
            text = "強い雨が降ってます。傘をさしていても濡れるでしょう。"
          else if rainFall >= 30 and rainFall < 50
            text = "激しい雨が降ってます。傘をさしていても濡れるでしょう。"
          else if rainFall >= 50 and rainFall < 80
            text = "非常に激しい雨が降ってます。傘は全く役に立たないでしょう。"
          else if rainFall >= 80
            text = "猛烈な雨です。傘は全く役に立たないでしょう。"

        console.log rainFall
        resolve "現在ファーストプレイス周辺は#{text}"

  getTommorowData = () ->
    new Promise (resolve, reject) ->

      request = robot.http(livedooeApiUrl).get()

      request (err, res, body) ->

        if err
          text = "明日の天気データを取得できませんでした。"
          reject text
          return

        json = JSON.parse(body)
        tomorrowData = json.forecasts[1]
        text = "明日の東京の天気は#{tomorrowData.telop}、最低気温は#{tomorrowData.temperature.min.celsius}℃、最高気温は#{tomorrowData.temperature.max.celsius}℃でしょう。"

        resolve text

  getRespondText = (callback) ->
    Promise.all([getWeatherData(), getTommorowData()])
    .then((result) ->
      text = "#{result[0]}\n#{result[1]}"
      callback(text)
    )

  robot.hear /天気教えて/i, (msg) ->
    getRespondText((text) ->
      msg.send text
    )




  new CronJob '0 0 19 * * 1-5', () =>
    getRespondText((text) ->
      robot.send {room: "blog_reblog"} , "定時になりました。\n#{text}"
      # console.log text
    )
  , null, true, "Asia/Tokyo"
