import {h, Component} from 'preact'
import style from './style.less'

export default class OnOff extends Component {
	handleOn = () => {
		this.props.onChange(true)
	}

	handleOff = () => {
		this.props.onChange(false)
	}

	render = ({on}, {}) =>
		<div class={style.container}>
			<button class={style.on + (on ? ' ' + style.active : '')} onClick={this.handleOn}>ON</button>
			<button class={style.off + (!on ? ' ' + style.active : '')} onClick={this.handleOff}>OFF</button>
			<div style={{clear: 'both'}}/>
		</div>

}
