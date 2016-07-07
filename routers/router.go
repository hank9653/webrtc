package routers

import (
	"webrtc/controllers"
	"github.com/astaxie/beego"
)

func init() {
    beego.Router("/", &controllers.MainController{})
    beego.Router("/Room", &controllers.RoomController{})
    beego.Router("/Test", &controllers.TestController{})
}
