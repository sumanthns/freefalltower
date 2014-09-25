import QtQuick 2.0

ListModel {
    id : object_list

    ListElement {
        name: "Golf Ball"
        image: "golf-ball.jpg"
        mass : 100
        init_width : 40
        init_height : 40
    }

    ListElement {
        name: "Cotton Ball"
        image : "cotton-ball.jpg"
        mass : 200
        init_width : 40
        init_height : 40
    }
    ListElement {
        name: "Iron Ball"
        image : "iron-ball.jpg"
        mass : 300
        init_width : 40
        init_height : 40
    }
    ListElement {
        name: "Foot Ball"
        image : "football.jpg"
        mass : 300
        init_width : 40
        init_height : 40
    }
}

