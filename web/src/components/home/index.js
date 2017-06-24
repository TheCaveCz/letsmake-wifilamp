import { h, Component } from 'preact'
import style from './style.less'
import MyColorPicker from './../picker'

export default class Home extends Component {
	state = {
		color: {r:0,g:0,b:0},
		on: false
	}

	componentDidMount() {
		this.timer = setInterval(this.refreshStatus, 3000)
		this.refreshStatus()
	}

	componentWillUnmount() {
		clearInterval(this.timer)
	}

	refreshStatus = () => {
		this.props.device.loadStatus(status => this.setState({
			color: {
				r: status.r,
				g: status.g,
				b: status.b
			},
			on: status.on
		}))
	}

	handleChange = color => {
		this.props.device.setColor(color.rgb)
		this.setState({color: {r:color.rgb.r, g:color.rgb.g, b:color.rgb.b}})
	}

	shouldComponentUpdate(nextProps, nextState) {
		return nextState.color.r != this.state.color.r || nextState.color.g != this.state.color.g || nextState.color.b != this.state.color.b || nextState.on != this.state.on
	}

	render() {
		console.log(this.state)
		return (
			<div class={style.home}>
				<MyColorPicker onChangeComplete={ this.handleChange } color={ this.state.color } />
			</div>
		)
	}
}
