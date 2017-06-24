import { h, Component } from 'preact'
import style from './style.less'
import { CustomPicker } from 'react-color'
import { Saturation, Hue } from 'react-color/lib/components/common'
import HuePointer from 'react-color/lib/components/hue/HuePointer'

class MyColorPicker extends Component {

	render() {
		return (
			<div>
				<div class={style.picker}>Testing
					<Saturation {...this.props} onChange={ this.props.onChange } pointer={HuePointer} />
				</div>
				<div class={style.picker2}>Testing
					<Hue {...this.props} onChange={ this.props.onChange } pointer={HuePointer} />
				</div>
			</div>
		)
	}
}

export default CustomPicker(MyColorPicker);