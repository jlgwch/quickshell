import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    width: 300
    height: label.height
    radius: 4
    color: "#595e64"
    clip: true

    // 可配置参数
    property int scrollSpeed: 60 // 像素/秒
    property int edgePause: 600 // 两端停顿
    property bool autoStart: true
    property alias text: label.text // 暴露文本
    property alias font: label.font
    property alias textColor: label.color
    property alias backgroundColor: root.color
    readonly property alias textWidth: label.width

    // 内部 Text 组件
    Text {
        id: label
        text: "这是 Qt6 的文本滚动示例，文本超过宽度时会自动左右滚动。"
        font.pixelSize: 16
        color: "white"
        anchors.verticalCenter: parent.verticalCenter
        wrapMode: Text.NoWrap
        elide: Text.ElideNone
        x: 0
        onTextChanged: x = 0
    }

    // 判断是否需要滚动
    property bool overflow: label.contentWidth > root.width
    property real scrollDistance: overflow ? (label.contentWidth - root.width) : 0
    property int scrollDuration: overflow ? Math.round(Math.abs(scrollDistance) / scrollSpeed * 1000) : 0

    // 动画：左右往返
    SequentialAnimation {
        id: scrollAnim
        running: overflow && autoStart
        loops: Animation.Infinite

        PauseAnimation {
            duration: edgePause
        }

        NumberAnimation {
            target: label
            property: "x"
            to: -scrollDistance
            duration: scrollDuration
            easing.type: Easing.Linear
        }

        PauseAnimation {
            duration: edgePause
        }

        NumberAnimation {
            target: label
            property: "x"
            to: 0
            duration: scrollDuration
            easing.type: Easing.Linear
        }
    }

    // 文本变化时重新启动动画
    onOverflowChanged: {
        scrollAnim.running = false;
        scrollAnim.running = overflow && autoStart;
    }

    Connections {
        target: label
        function onContentWidthChanged() {
            scrollAnim.running = false;
            scrollAnim.running = overflow && autoStart;
        }
    }
}
