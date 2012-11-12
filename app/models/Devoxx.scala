package models

import org.codehaus.jackson.annotate._

case class DevoxxTag(name: String)

case class DevoxxSpeakers(speakerUri: String, speaker: String)

@JsonIgnoreProperties(ignoreUnknown = true)
case class DevoxxPresentation(tags: Seq[DevoxxTag], summary: String, id: Long,
                              speakerUri: String, title: String, speaker: String,
                              track: String, experience: String, speakers: Seq[DevoxxSpeakers],
                              room: Option[String])


@JsonIgnoreProperties(ignoreUnknown = true)
case class DevoxxSchedule(id: Option[Long], partnerSlot: Option[Boolean], fromTime: Option[String], code: Option[String],
                          note: Option[String], toTime: Option[String], kind: Option[String], room: Option[String],
                          presentationUri: Option[String], speaker: Option[String], title: Option[String],
                          speakerUri: Option[String]
                             )

@JsonIgnoreProperties(ignoreUnknown = true)
case class DevoxxEvents(to:String, id:Long, enabled:Boolean, location:String, description:String, name:String, from:String)