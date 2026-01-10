// ECalendar.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: control

    implicitWidth: 300
    implicitHeight: 360

    color: "lightsteelblue"

    property date from: new Date(d.displayDate.getFullYear() - 100, 0, 1)
    property date to: new Date(d.displayDate.getFullYear() + 100, 11, 31)

    QtObject {
        id: d
        property date displayDate: {
            if (control.current) {
                return control.current;
            }
            return new Date();
        }
        property date toDay: new Date()
        property int pageIndex: 0
        signal nextButton
        signal previousButton
        property point yearRing: Qt.point(0, 0)
    }

    CalendarModel {
        id: calender_model
        from: control.from
        to: control.to
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            RowLayout {
                anchors.fill: parent
                spacing: 10
                Item {
                    Layout.leftMargin: parent.spacing
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Button {
                        width: parent.width
                        anchors.centerIn: parent
                        contentItem: Text {
                            // text: d.displayDate.toLocaleString(FluApp.locale, "MMMM yyyy")
                            text: Qt.formatDate(d.displayDate, "MMMM yyyy")
                            verticalAlignment: Text.AlignVCenter
                        }
                        visible: d.pageIndex === 0
                        onClicked: {
                            d.pageIndex = 1;
                        }
                    }
                    Button {
                        width: parent.width
                        anchors.centerIn: parent
                        contentItem: Text {
                            // text: d.displayDate.toLocaleString(FluApp.locale, "yyyy")
                            text: Qt.formatDate(d.displayDate, "yyyy")
                            verticalAlignment: Text.AlignVCenter
                        }
                        visible: d.pageIndex === 1
                        onClicked: {
                            d.pageIndex = 2;
                        }
                    }
                    Button {
                        width: parent.width
                        anchors.centerIn: parent
                        contentItem: Text {
                            text: "%1-%2".arg(d.yearRing.x).arg(d.yearRing.y)
                            verticalAlignment: Text.AlignVCenter
                            color: Qt.rgba(153 / 255, 153 / 255, 153 / 255, 1)
                        }
                        visible: d.pageIndex === 2
                        onClicked: {
                            d.pageIndex = 0;
                        }
                    }
                }
                Button {
                    id: icon_up
                    implicitWidth: 30
                    implicitHeight: 30
                    onClicked: {
                        d.previousButton();
                    }

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("<")
                        rotation: 90
                        font.bold: true
                    }
                }
                Button {
                    id: icon_down
                    implicitWidth: 30
                    implicitHeight: 30
                    Layout.rightMargin: parent.spacing
                    onClicked: {
                        d.nextButton();
                    }
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("<")
                        rotation: -90
                        font.bold: true
                    }
                }
            }
            // FluDivider{
            // width: parent.width
            // height: 1
            // anchors.bottom: parent.bottom
            // }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            StackView {
                id: stack_view
                anchors.fill: parent
                replaceEnter: Transition {
                    OpacityAnimator {
                        from: 0
                        to: 1
                        duration: 83
                    }
                    ScaleAnimator {
                        from: 0.5
                        to: 1
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }
                replaceExit: Transition {
                    OpacityAnimator {
                        from: 1
                        to: 0
                        duration: 83
                    }
                    ScaleAnimator {
                        from: 1.0
                        to: 0.5
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }

                Connections {
                    target: d
                    function onPageIndexChanged() {
                        if (d.pageIndex === 0) {
                            stack_view.replace(com_page_one);
                        }
                        if (d.pageIndex === 1) {
                            stack_view.replace(com_page_two);
                        }
                        if (d.pageIndex === 2) {
                            stack_view.replace(com_page_three);
                        }
                    }
                }
            }
        }
    }

    Component {
        id: com_page_three
        GridView {
            id: grid_view
            cellHeight: 75
            cellWidth: 75
            clip: true
            boundsBehavior: GridView.StopAtBounds
            ScrollBar.vertical: ScrollBar {}
            model: {
                var fromYear = calender_model.from.getFullYear();
                var toYear = calender_model.to.getFullYear();
                return toYear - fromYear + 1;
            }
            highlightRangeMode: GridView.StrictlyEnforceRange
            onCurrentIndexChanged: {
                var year = currentIndex + calender_model.from.getFullYear();
                var start = Math.ceil(year / 10) * 10;
                var end = start + 10;
                d.yearRing = Qt.point(start, end);
            }
            highlightMoveDuration: 100
            Component.onCompleted: {
                grid_view.highlightMoveDuration = 0;
                currentIndex = d.displayDate.getFullYear() - calender_model.from.getFullYear();
                timer_delay.restart();
            }

            Connections {
                target: d
                function onNextButton() {
                    grid_view.currentIndex = Math.min(grid_view.currentIndex + 16, grid_view.count - 1);
                }
                function onPreviousButton() {
                    grid_view.currentIndex = Math.max(grid_view.currentIndex - 16, 0);
                }
            }
            Timer {
                id: timer_delay
                interval: 100
                onTriggered: {
                    grid_view.highlightMoveDuration = 100;
                }
            }
            currentIndex: -1
            delegate: Item {
                property int year: calender_model.from.getFullYear() + modelData
                property bool toYear: year === d.toDay.getFullYear()
                implicitHeight: 75
                implicitWidth: 75

                Button {
                    id: control_delegate
                    width: 60
                    height: 60

                    background: Item {}

                    Rectangle {
                        width: 48
                        height: 48
                        radius: width / 2
                        color: {
                            if (toYear) {
                                if (control_delegate.pressed) {
                                    return Qt.lighter("#0066b4", 1.2);
                                }
                                if (control_delegate.hovered) {
                                    return Qt.lighter("#0066b4", 1.1);
                                }
                                return "#0066b4";
                            } else {
                                if (control_delegate.pressed) {
                                    return Qt.rgba(0, 0, 0, 0.06);
                                }
                                if (control_delegate.hovered) {
                                    return Qt.rgba(0, 0, 0, 0.03);
                                }
                                return Qt.rgba(0, 0, 0, 0);
                            }
                        }
                        anchors.centerIn: parent
                    }
                    Text {
                        text: year
                        anchors.centerIn: parent
                        opacity: {
                            if (year >= d.yearRing.x && year <= d.yearRing.y) {
                                return 1;
                            }
                            if (control_delegate.hovered) {
                                return 1;
                            }
                            return 0.3;
                        }
                        color: {
                            if (toYear) {
                                return "#ffffff";
                            }
                            if (control_delegate.pressed) {
                                return Qt.rgba(151 / 255, 149 / 255, 146 / 255, 1);
                            }
                            if (control_delegate.hovered) {
                                return Qt.rgba(121 / 255, 119 / 255, 117 / 255, 1);
                            }
                            return Qt.rgba(17 / 255, 16 / 255, 15 / 255, 1);
                        }
                    }
                }
            }
        }
    }
}
