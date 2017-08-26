import {h, Component} from 'preact'
import style from './style.less'
import MyColorPicker from './../picker'
import OnOff from './../onoff'

export default class Home extends Component {
	static defaultProps = {
		refreshInterval: 5000
	}

	state = {
		color: {r: 0, g: 0, b: 0},
		on: false
	}

	componentDidMount() {
		this.refreshStatus()
	}

	shouldComponentUpdate(nextProps, nextState) {
		return nextState.color.r !== this.state.color.r
			|| nextState.color.g !== this.state.color.g
			|| nextState.color.b !== this.state.color.b
			|| nextState.on !== this.state.on
	}

	componentWillUnmount() {
		clearTimeout(this.timer)
	}

	refreshStatus = () => {
		this.props.device.loadStatus(status => {
			const {r, g, b} = status

			this.setState({
				color: {r, g, b},
				on: status.on
			})

			this.timer = setTimeout(this.refreshStatus, this.props.refreshInterval)
		})
	}

	handleColor = newColor => {
		const { r, g, b } = newColor.rgb
		const color = { r, g, b }

		this.props.device.setColor(color)
		this.setState({ color })
	}

	handleOnOff = on => {
		this.props.device.setOn(on)
		this.setState({ on })
	}

	render = ({}, {on, color}) =>
		<div class={style.home}>
			<OnOff onChange={this.handleOnOff} on={ on }/>
			<MyColorPicker onChangeComplete={this.handleColor} color={ color }/>
		</div>
		
}
