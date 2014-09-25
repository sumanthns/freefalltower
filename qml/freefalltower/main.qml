import QtQuick 2.0
import QtQuick.Controls 1.2

Rectangle {
    width: 1000
    height: 1000

    Text {
        id: status_text
        x: 236
        y: 39
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Welcome to Freefall tower")
        font.pixelSize: 12
    }
    DropArea {
            id : mass_drop_area
            x: 25; y: 298
            clip: true
            width: 100; height: 37
            //onEntered: maincanvas.state = Qt.new_method(1)
            Rectangle {
                x: 0
                y: 0
                anchors.fill: parent
                opacity: 0.5
                border.color: "red"
                visible: parent.containsDrag
            }
            onDropped: {
                status_text.text = qsTr("You have moved a " + drag.source.objectName)
                mass_edit.currentItem = drag.source
                mass_edit.text = drag.source.objectMass
                //mass_edit.objectChanged()
            }

    }
    TextInput {
        id: mass_text
        x: 25
        y: 444
        text: qsTr("Mass :: ")
        font.pixelSize: 12
    }

    TextEdit {
        id: mass_edit
        x: 88
        y: 441
        width: 80
        height: 20
        text: qsTr("0")
        property Image currentItem
        cursorVisible: true
        textFormat: TextEdit.AutoText
        signal objectChanged()
        Rectangle {
            anchors.fill: parent
            opacity: 0.2
            border.color: "red"
        }
        horizontalAlignment: TextEdit.AlignHCenter
        verticalAlignment: TextEdit.AlignVCenter
        font.pixelSize: 12
        onObjectChanged: {
         currentItem.width += 100
        }
        onTextChanged: {
            if (currentItem != null){
                if (currentItem.objectMass != 0 && text > 0){
                    var scaleRatio = text / currentItem.objectMass
                    currentItem.objectMass = text
                    currentItem.objectWidth = scaleRatio * currentItem.objectWidth
                    currentItem.objectHeight = scaleRatio * currentItem.objectHeight

                }
            }
        }

    }


    Image {
        id: scale_object
        x: 25
        y: 335
        width: 100
        height: 100
        source: "scale.png"
    }


    GridView {
        id: objects_grid
        x: 25
        y: 109
        width: 150
        height: 85
        model : Qt.createComponent("objects.qml").createObject(null);
        delegate: Item {
            x: 5
            height: 50
            Column {
                spacing: 5
                Rectangle {
                    width: 40
                    height: 40

                    Image {

                     id : object_image
                     width: init_width
                     height : init_height
                     source : image
                     Drag.source : object_image
                     Drag.active: dragArea.drag.active

                     property string objectName: name
                     property real objectMass : mass
                     property real objectWidth : width
                     property real objectHeight : height
                     property real dropThisMuch : 0
                     signal scale(var changed_mass)
                     MouseArea  {
                       id: dragArea
                       anchors.fill: parent
                       drag.target: parent
                       onClicked:  {
                           status_text.text = "You have selected a " + name
                       }
                       onReleased: {
                           parent.Drag.drop()
                       }
                     }
                     onObjectWidthChanged: {
                      width = objectWidth
                     }
                     onObjectHeightChanged:  {
                      height = objectHeight
                     }
                     onObjectMassChanged:  {
                         if (objectMass != 0) {
                            mass = objectMass
                         }
                     }
                     onActiveFocusChanged: {
                         console.log("Hello")
                     }
                     states: [

                         State {
                             name: "drop"
                             PropertyChanges { target: object_image; y: y + dropThisMuch }
                         }

                    ]
                     transitions: Transition {
                         NumberAnimation { duration: 600; properties: "x,y"; easing.type: Easing.InOutQuad }
                     }

                    }
                    anchors.horizontalCenter: parent.horizontalCenter




                }

                Text {
                    x: 5
                    text: name
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
        cellHeight: 70
        cellWidth: 70
    }

    ListView {
        id: layers_list
        x: 241
        y: 109
        width: 166
        height: 448
        interactive: false

        property real total_height : 100
        model:  Qt.createComponent("layers.qml").createObject(null);
        delegate: Item {
            x: 5
            height: (layers_list.height / layers_list.count)

            Row {
                id: row1
                Rectangle {
                    width: 100
                    height: 5
                    color: "black"
                    property string layerNumber : layer_number
                    property string numberOfLayers : layers_list.count
                    DropArea {
                        width: parent.width
                        height: 40
                        clip : true
                        y : -40

                        Rectangle {
                            x : 0
                            y : 0
                            anchors.fill: parent
                            border.color : "red"
                            opacity: 0.5
                            visible : parent.containsDrag
                        }

                        onDropped: {
                            status_text.text = qsTr("You have moved a " + drag.source.objectName + " On to floor : " + parent.layerNumber )
                            var temp = simulate_button.currentItem
                            temp[Object.keys(temp).length] = drag.source
                            simulate_button.currentItem = temp

                            simulate_button.currentLayer = parent.layerNumber
                        }

                    }
                    Text {
                        x : -60
                        text : (layer_number * (layers_list.total_height / layers_list.count)).toFixed(1) + "m"
                    }
                }
            }
        }
    }

    Rectangle {
        id: fft_table_view
        x: 185
        y: 575
        width: 596
        height: 200

        ListModel {
           id: fft_table_model
        }


        TableView {
            width: 455
            height: 150
            TableViewColumn{ role: "objects"  ; title: "Objects" ; width: 100 }
            TableViewColumn{ role: "mass" ; title: "Mass" ; width: 100 }
            TableViewColumn{ role: "time_taken" ; title: "Time Taken in secs" ; width: 150 }
            TableViewColumn{ role: "medium" ; title: "Medium" ; width: 100 }

           model: fft_table_model
        }

    }




    Rectangle {
        id : simulate_button
        x: 483
        y: 68
        property variant currentItem : []
        property int currentLayer
        width: 85
        height : 25
        border.width: 5
        border.color : "red"
        radius: 10
        Text {
            color: "#000000"
            anchors.centerIn: parent
            font.bold: true
            text : "Simulate !"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log(Object.keys(simulate_button.currentItem))
                for (var i in simulate_button.currentItem) {
                    if (simulate_button.currentItem[i] != null){


                        var current_drop_item = simulate_button.currentItem[i]
                        var height_per_layer = layers_list.height / layers_list.count
                        //simulate_button.currentItem[i].y += (simulate_button.currentLayer) * height_per_layer
                        current_drop_item.state = ""
                        current_drop_item.dropThisMuch = (simulate_button.currentLayer) * height_per_layer
                        current_drop_item.state = "drop"
                        current_drop_item.dropThisMuch = 0

                        fft_table_model.append({ objects: current_drop_item.objectName , mass: current_drop_item.objectMass, time_taken: Math.sqrt(2 * simulate_button.currentLayer * height_per_layer / 9.8).toFixed(2), medium: "Vaccum" })
                    }
                }

                simulate_button.currentItem = []
            }
        }
    }

 }
