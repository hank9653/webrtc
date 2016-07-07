package controllers

import (
    "fmt"
    "github.com/astaxie/beego/orm"
	"github.com/astaxie/beego"
	"webrtc/models"
)

type RoomController struct {
	beego.Controller
}

func (c *RoomController) Get() {
	 o := orm.NewOrm()

    user := models.User{Name: "slene"}

    // insert
    id, err := o.Insert(&user)
    fmt.Printf("ID: %d, ERR: %v\n", id, err)

    // update
    user.Name = "astaxie"
    num, err := o.Update(&user)
    fmt.Printf("NUM: %d, ERR: %v\n", num, err)

    // read one
    u := models.User{Id: user.Id}
    err = o.Read(&u)
    fmt.Printf("ERR: %v\n", err)

    // delete
    num, err = o.Delete(&u)
    fmt.Printf("NUM: %d, ERR: %v\n", num, err)

	c.Data["room_link"] = "beego.me"
	c.TplName = "test.tpl"
}
