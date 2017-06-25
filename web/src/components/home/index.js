import { h, Component } from 'preact'
import style from './style.less'
import MyColorPicker from './../picker'
import OnOff from './../onoff'

export default class Home extends Component {
	static defaultProps = {
		refreshInterval: 5000
	}
	state = {
		color: {r:0,g:0,b:0},
		on: false
	}

	componentDidMount() {
		this.refreshStatus()
	}

	componentWillUnmount() {
		clearTimeout(this.timer)
	}

	refreshStatus = () => {
		this.props.device.loadStatus(status => {
			this.setState({
				color: {
					r: status.r,
					g: status.g,
					b: status.b
				},
				on: status.on
			})

			this.timer = setTimeout(this.refreshStatus, this.props.refreshInterval)
		})
	}

	handleColor = color => {
		this.props.device.setColor(color.rgb)
		this.setState({color: {r:color.rgb.r, g:color.rgb.g, b:color.rgb.b}})
	}

	handleOnOff = on => {
		this.props.device.setOn(on)
		this.setState({ on })
	}

	shouldComponentUpdate(nextProps, nextState) {
		return nextState.color.r != this.state.color.r || nextState.color.g != this.state.color.g || nextState.color.b != this.state.color.b || nextState.on != this.state.on
	}

	render() {
		console.log(this.state)
		return (
			<div class={style.home}>
				<OnOff onChange={ this.handleOnOff } on={this.state.on}/>
				<MyColorPicker onChangeComplete={ this.handleColor } color={ this.state.color } />
			</div>
		)
	}
}
