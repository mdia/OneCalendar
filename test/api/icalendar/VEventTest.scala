package api.icalendar

import org.scalatest.FunSuite
import org.scalatest.matchers.ShouldMatchers
import net.fortuna.ical4j.model.property._
import java.net.URI
import org.joda.time.DateTime

class VEventTest extends FunSuite with ShouldMatchers {

    test("should have empty VEvent case class encapsulate VEVENT specification in ICalendar") {
        val vEvent = new VEvent( new net.fortuna.ical4j.model.component.VEvent() )
        vEvent.uid should be(None)
        vEvent.summary should be(None)
        vEvent.startDate should be(None)
        vEvent.endDate should be(None)
        vEvent.location should be(None)
        vEvent.url should be(None)
        vEvent.description should be(None)
    }

    test("should have VEvent case class encapsulate VEVENT specification in ICalendar") {
        val vEvent = new VEvent(getVEvent())
        
        vEvent.uid should be (Option("123"))
        vEvent.summary should be (Option("title"))
        vEvent.startDate should be (Option(new DateTime(123000L)))  //TODO fix milliseconds problem
        vEvent.endDate should be (Option(new DateTime(456000L)))    //TODO fix milliseconds problem
        vEvent.location should be (Option("location"))
        vEvent.url should be (Option("url"))
        vEvent.description should be (Option("description"))
    }

    test("require vevent not null") {
        val exception = evaluating {
            new VEvent(null)
        } should produce[IllegalArgumentException]

        exception.getMessage should include ("VEvent should not be null")
    }

    test("define equals method") {
        new VEvent(getVEvent()) should equal (new VEvent(getVEvent()))
        new VEvent(getVEvent(uid = false)) should not equal(new VEvent(getVEvent(uid = false)))
        new VEvent(getVEvent()) should not equal ("")
    }

    test("compagnon object should build VEvent from map") {
        val vEvent = VEvent(
            uid = "123",
            summary = "title",
            description = "description",
            location = "location",
            url = "url",
            startDate = new DateTime(123456L),
            endDate = new DateTime(456457L)
        )

        val expected = new VEvent(getVEvent())

        vEvent should be (expected) // Not sufficient because we need test mapping

        vEvent.description should be (expected.description)
        vEvent.uid         should be (expected.uid        )
        vEvent.summary     should be (expected.summary    )
        vEvent.location    should be (expected.location   )
        vEvent.url         should be (expected.url        )
        vEvent.startDate   should be (expected.startDate  )
        vEvent.endDate     should be (expected.endDate    )
    }
    
    test("compagnon object should build VEvent even if some properties were not set") {
        val vEvent = VEvent( uid = "123" )
        
        vEvent.uid         should be (Option("123"))
        vEvent.description should be (None)
        vEvent.summary     should be (None)
        vEvent.location    should be (None)
        vEvent.url         should be (None)
        vEvent.startDate   should be (None)
        vEvent.endDate     should be (None)
    }
    
    private def getVEvent(uid: Boolean = true): net.fortuna.ical4j.model.component.VEvent = {
        val vevent = new net.fortuna.ical4j.model.component.VEvent()

        if(uid) vevent.getProperties.add(new Uid("123"))

        vevent.getProperties.add( new DtStart( new net.fortuna.ical4j.model.DateTime(123456L) ) )
        vevent.getProperties.add( new DtEnd( new net.fortuna.ical4j.model.DateTime(456457L) ) )

        vevent.getProperties.add(new Summary("title"))
        vevent.getProperties.add(new Description("description"))
        vevent.getProperties.add(new Location("location"))
        vevent.getProperties.add(new Url(new URI("url")))

        vevent
    }
}