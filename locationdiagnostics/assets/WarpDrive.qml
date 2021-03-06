/* Copyright (c) 2012 Research In Motion Limited.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/import bb.cascades 1.0

Container {
    id: root

    property int frequency: 0

    signal frequencyChanged(int frequency)

    // The compass
    Container {
        horizontalAlignment: HorizontalAlignment.Fill

        layout: DockLayout {}

        ImageView {
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Top

            imageSource: "asset:///images/compass_base.png"
        }

        ImageView {
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Top

            imageSource: "asset:///images/compass_pointer.png"
            animations: [
                FadeTransition {
                    id: fadeout
                    fromOpacity: 1
                    toOpacity: .5
                    duration: root.frequency + 200
                    onEnded: {
                        fadein.play();
                    }
                },
                FadeTransition {
                    id: fadein
                    duration: fadeout.duration
                    fromOpacity: .5
                    toOpacity: 1
                    onEnded: {
                        rotate.play();
                    }
                },
                RotateTransition {
                    id: rotate
                    fromAngleZ: 0
                    toAngleZ: 360
                    easingCurve: StockCurve.CubicOut
                    duration: fadeout.duration
                    onEnded: {
                        fadeout.play();
                    }
                }
            ]
        }

        onCreationCompleted: {
            fadeout.play();

            // The animation speed at start up should be taken from the stored value of the slider.
            fadeout.duration = root.frequency + 200;
        }
    }

    Label {
        horizontalAlignment: HorizontalAlignment.Center

        text: (root.frequency == 0 ? qsTr ("Frequency") : qsTr ("Frequency: %1s").arg(root.frequency))
        textStyle {
            base: SystemDefaults.TextStyles.BodyText
            fontWeight: FontWeight.Bold
        }
    }

    Slider {
        horizontalAlignment: HorizontalAlignment.Center

        fromValue: 1
        toValue: 500
        value: root.frequency

        onValueChanged: {
            root.frequencyChanged(Math.floor(value))
        }
    }
}
