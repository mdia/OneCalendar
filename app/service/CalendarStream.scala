/*
 * This file is part of OneCalendar.
 *
 * OneCalendar is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * OneCalendar is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OneCalendar.  If not, see <http://www.gnu.org/licenses/>.
 */

package service

import models.Event
import dao.configuration.injection.MongoConfiguration

class CalendarStream {

    def search(tags: List[String])(implicit dbConfig: MongoConfiguration): List[Event] = {
        if (tags.size > 0) {
            dao.EventDao.findByTag(tags)
        } else {
            dao.EventDao.findAll()
        }
    }
}