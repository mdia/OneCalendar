describe 'google suggest like', ->

  beforeEach ->
    setFixtures '<input type="text" id="suggest" value="a" />'

  it '1. should call function when key press in my marvelous input', ->
    $('#suggest').on 'keyup', ->

    expect($('#suggest')).toHandle 'keyup'

  it '2. should display ul element when user press "a" key', ->
    SUGGEST.suggest()
    $('#suggest').keyup()

    expect($('#suggest + ul > li')).toHaveText("a")

  it '3. should display only one ul element when user press "a" key twice', ->
    SUGGEST.suggest()
    $('#suggest').keyup()
    $('#suggest').keyup()

    expect( '<li>a</li><li>a</li>' ).toEqual( $('#suggest + ul').html() )

  it '4. should delete ul element when marvelous input loose focus', ->
    setFixtures '''
      <input type="text" id="suggest" value="a" />
      <ul><li>a</li></ul>
    '''

    SUGGEST.deleteSuggest()
    $('#suggest').blur()

    expect( $('#suggest + ul').length ).toEqual( 0 )

  it "5. should display links when user write search word", ->
    setFixtures '''
      <input type="text" id="suggest" value="a" />
      <div id="temp"></div>
      <div id="subscription" style="display:none;">
        <a class="ical"></a>
        <a class="gcal"></a>
        <a class="webcal"></a>
      </div>
    '''

    SUGGEST.displaySubscription 'A'

    expectedGoogleCalendarLinkPrefix = "http://www.google.com/calendar/render?cid="
    expectedGoogleCalendarLinkSuffix = "%2Fevents%2FA"
    expectedWebcalLinkPrefix = "webcal://"
    expectedWebcalLinkSuffix = "/events/A"

    expect( $('#subscription').css('display') ).toEqual('block')
    expect( $('#subscription a.ical') ).toHaveAttr('href', '/events/A')
    expect( $('#subscription a.gcal').attr('href') ).toContain(expectedGoogleCalendarLinkPrefix)
    expect( $('#subscription a.gcal').attr('href') ).toContain( expectedGoogleCalendarLinkSuffix )
    expect( $('#subscription a.webcal').attr('href') ).toContain( expectedWebcalLinkPrefix )
    expect( $('#subscription a.webcal').attr('href') ).toContain( expectedWebcalLinkSuffix )

  it "6. if user don't write search should not display links", ->
    setFixtures '''
          <input type="text" id="suggest" value="" />
          <div id="temp"></div>
          <div id="subscription" style="display:none;">
            <a class="ical"></a>
            <a class="gcal"></a>
            <a class="webcal"></a>
          </div>
        '''

    SUGGEST.displaySubscription ''

    expect( $('#subscription').css('display') ).toEqual('none')

  it "7. should add devoxx url in link for devoxx section", ->
    setFixtures '''
      <div id="devoxx">
        <a class="ical"></a>
        <a class="gcal"></a>
        <a class="webcal"></a>
      </div>
    '''

    SUGGEST.loadUrlDevoxxSection()

    expect( $("#devoxx a.gcal").attr("href") ).toContain('%2Fevents%2FDEVOXX')
    expect( $("#devoxx a.webcal").attr("href") ).toContain('/events/DEVOXX')

  it "8. should call rest controller to retrieve preview result when user click on search", ->
    setFixtures '''
            <input type="text" id="suggest" value="a" />
            <div id="temp"></div>
            <div id="subscription">
              <a class="ical"></a>
              <a class="gcal"></a>
              <a class="webcal"></a>
            </div>
          '''
    urlServer = 'http://serveur'
    callbackData = {"key":"value"}

    SUGGEST.retrievePreviewResults url: urlServer

    spyOn(SUGGEST, 'displaySubscription').andCallThrough
    spyOn(SUGGEST, 'displayPreviewResult').andCallThrough

    spyOn($, 'ajax').andCallFake (params) ->
      params.success -> callbackData

    $("#temp").click()

    expect($.ajax).toHaveBeenCalled()
    expect(SUGGEST.displayPreviewResult).toHaveBeenCalled()
    expect(SUGGEST.displaySubscription).toHaveBeenCalledWith('A')

  it "9. should call displayNoResult method when callback is error", ->
    setFixtures '''
            <input type="text" id="suggest" value="a" />
            <div id="temp"></div>
            <div id="subscription">
              <a class="ical"></a>
              <a class="gcal"></a>
              <a class="webcal"></a>
            </div>
          '''

    urlServer = 'http://serveur'
    callbackData = {"key":"value"}

    SUGGEST.retrievePreviewResults url: urlServer

    spyOn(SUGGEST, 'displayNoResult').andCallThrough
    spyOn($, 'ajax').andCallFake (params) ->
      params.error -> ""

    $("#temp").click()

    expect($.ajax).toHaveBeenCalled()
    expect(SUGGEST.displayNoResult).toHaveBeenCalledWith('a')

  it "10. should display preview", ->
    setFixtures '''
          <div id="subscription"">
            <p id="resultSize"></p>
            <p class="preview"></p>
            <p class="preview"></p>
            <p class="preview"></p>
            <a class="ical"></a>
            <a class="gcal"></a>
            <a class="webcal"></a>
          </div>
          <div id="callbackNoResult"></div>
      '''

    callbackResponse = {
    "size":"5",
    "eventList": [
      {"event":{
      "date":"2012-04-19T15:35:00.000+02:00",
      "title":"title 1",
      "location":"location 1"
      }},
      {"event":{
      "date":"2012-04-19T15:35:00.000+02:00",
      "title":"title 2",
      "location":"location 2"
      }},
      {"event":{
      "date":"2012-04-19T15:35:00.000+02:00",
      "title":"title 3",
      "location":"location 3"
      }}
    ]
    }

    SUGGEST.displayPreviewResult callbackResponse

    expect( $('#resultSize') ).toHaveText( "nombre d'évènement(s) trouvé(s): 5" )

    expect( $('#callbackNoResult').css('display') ).toEqual('none')

    previewElement = $( '#subscription .preview' )

    expect( $( previewElement[0] ).text() ).toContain( "title 1")
    expect( $( previewElement[0] ).text() ).toContain( "2012-04-19T15:35:00.000+02:00")
    expect( $( previewElement[0] ).text() ).toContain( "location 1")

    expect( $( previewElement[1] ).text() ).toContain( "title 2")
    expect( $( previewElement[1] ).text() ).toContain( "2012-04-19T15:35:00.000+02:00")
    expect( $( previewElement[1] ).text() ).toContain( "location 2")

    expect( $( previewElement[2] ).text() ).toContain( "title 3")
    expect( $( previewElement[2] ).text() ).toContain( "2012-04-19T15:35:00.000+02:00")
    expect( $( previewElement[2] ).text() ).toContain( "location 3")

  it "11. should display fail", ->
    setFixtures '<div style="display:none;" id="callbackNoResult"></div>'

    SUGGEST.displayNoResult "toto"

    expect( $('#callbackNoResult').css('display') ).toEqual('block')
    expect( $('#callbackNoResult') ).toHaveText( "Le mot clé toto ne donne aucun résultat dans la base OneCalendar" )

  it "12. should hide subscription div", ->
    setFixtures '<div id="subscription"></div>'

    SUGGEST.displayNoResult "toto"
    expect( $('#subscription').css('display') ).toEqual('none')