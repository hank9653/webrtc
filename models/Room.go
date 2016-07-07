package models

import (
    "github.com/astaxie/beego/orm"
    _ "github.com/go-sql-driver/mysql" // import your required driver
)

// Model Struct
type User struct {
    Id   int
    Name string `orm:"size(100)"`
}

func init() {
    // register model
    orm.RegisterModel(new(User))

    // set default database
    orm.RegisterDataBase("default", "mysql", "root:1qaz@WSX@/go_test?charset=utf8", 30)
}
