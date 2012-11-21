package controllers

import play.api.mvc._

object Features extends Controller {
    def index = Action {
        Ok(views.html.features())
    }
    
}
