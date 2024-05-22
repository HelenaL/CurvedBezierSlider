# CurvedBezierSlider
![48_ios_apple_icon](https://github.com/HelenaL/WeatherMeApp_iOS/assets/5014495/936236cb-445f-4430-ac97-3c367f1bacf4) ![48_swift_icon-3](https://github.com/HelenaL/WeatherMeApp_iOS/assets/5014495/3d35e284-a9e7-4851-9601-9439c26c41f3)

<div style="display: flex; justify-content: center;">
  <img src="https://github.com/HelenaL/CurvedBezierSlider/assets/5014495/530967d8-dc6b-4d5d-894d-a3ddeaebec2b" width="28%" alt="example 1" style="margin-right: 200px;"/>
  <img src="https://github.com/HelenaL/CurvedBezierSlider/assets/5014495/79bf9adb-d83f-473f-936e-d51f3e24d23e" width="28%" alt="example 2" style="margin-right: 100px;"/>
</div>

### Slider properies

| Name         | Type    | Default | Description |
| ------------ | ------- | ------- | ----------- |
| value | Double | `0.0` | Current value of a slider. This value will be pinned to min/max. |
| minimumValue | Double | `0.0` | The minimum value of the slider. The current value may change if outside new min value. |
| maximumValue | Double | `1.0` | The maximum value of the slider. The current value may change if outside new max value. |
| isFlipped | Bool | `false` | A Boolean value that determines whether the view is flipped. Set the derection of the curve - up or down. |
| strokeMaxColor | UIColor | `UIColor.darkGray` | Color used to tint the maximum track of the slider path. |
| strokeMinColor | UIColor | `UIColor.darkGray` | Color used to tint the minimum track of the slider path. |
| pathAdapter | Int | 0 | Style of the slider path. There is three possible style: 0 - semiCircle, 1 - almostCircle(~3/4), 2 - crescentCircle. |

### Thumb properies
| Name         | Type    | Default | Description |
| ------------ | ------- | ------- | ----------- |
| thumbImage | UIImage? | - | The thumb image being used to render the slider. |
| thumbColor | UIColor | `UIColor.white` | The color used to tint the default thumb images. |

### Scale properies
| Name         | Type    | Default | Description |
| ------------ | ------- | ------- | ----------- |
| scaleIsHidden | Bool | `false` | A Boolean value that determines whether scale should be hidden. |
| scaleColor | UIColor | `UIColor.lightGray` | Color used to tint the scale. |
