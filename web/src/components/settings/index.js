import { h, Component } from 'preact'
import style from './style.less'
import MyColorPicker from './../picker'
import OnOff from './../onoff'


const DeviceInfo = ({chipid,fwVersion,uptime,connection}, {}) => <table>
	<tr><th>Chip ID</th><td>{ chipid }</td></tr>
	<tr><th>Firmware version</th><td>{ fwVersion }</td></tr>
	<tr><th>Uptime</th><td>{ uptime } s</td></tr>
	<tr><th>Current SSID</th><td>{ connection && connection.ssid }</td></tr> 
	<tr><th>AP mode</th><td>{ connection && connection.ap ? 'yes':'no' }</td></tr> 
	<tr><th>MAC address</th><td>{connection && connection.mac}</td></tr>
</table>


class AdminPass extends Component {
	state = {
		password1: "",
		password2: "",
		valid: true
	}

	handleChange1 = txt => {
		this.setState({ password1: txt.target.value })
		this.fireChange()
	}

	handleChange2 = txt => {
		this.setState({ password2: txt.target.value })
		this.fireChange()
	}

	fireChange = () => {
		const l = this.state.password1.length
		const valid = this.state.password1 === this.state.password2 && ((l >= 4 && l <= 64) || l == 0)
		this.setState({ valid })
		this.props.onChange(valid, valid ? this.state.password1 : '')
	}

	render = ({}, {valid, password1}) => 
		<div>
			<p><input type='password' placeholder='Enter admin password' maxlength='64' oninput={this.handleChange1} /></p>
			<p><input type='password' placeholder='Verify admin password' maxlength='64' oninput={this.handleChange2} /></p>
			{ valid ? (password1.length ? <p class={style.success}>Password is verified and will be changed on save.</p>:'') : <p class={style.error}>Password must have between 4 and 64 characters and must match.</p> }
		</div>
}


export default class Settings extends Component {
	state = {
		defaultColor: {r: 255, g: 255, b: 255},
		defaultOn: true,
		buttonEnabled: true,
		connection: {},
		info: {
			chipid: 0,
			fwVersion: "",
			uptime: 0
		},
		password: {
			valid: true,
			value: ""
		},

		changed: false,
		loading: false,
	};

	componentDidMount() {
		this.setState({ changed: false, loading: true })
		this.props.device.loadFullStatus(this.processStatus)
	}

	processStatus = status => {
		const { chipid, fwVersion, uptime, buttonEnabled } = status

		const def = status['default']
		const { r, g, b } = def
		const defaultOn = def.on

		const { ssid, mac, ap } = status.connection
		const connection = { mac, ap, ssid }

		this.setState({ defaultOn, defaultColor: {r, g, b}, buttonEnabled, connection, info: {chipid, fwVersion, uptime}, loading: false, changed: false})
	}

	handleDefaultColor = newColor => {
		const { r, g, b } = newColor.rgb
		const defaultColor = { r, g, b }

		this.setState({ defaultColor, changed: true })
	}

	handleDefaultOn = defaultOn => {
		this.setState({ defaultOn, changed: true })
	}

	handleButtonEnabled = buttonEnabled => {
		this.setState({ buttonEnabled, changed: true })
	}

	handlePassword = (valid, value) => {
		this.setState({ password: { valid, value }, changed: true })
	}

	handleSave = e => {
		e.preventDefault()

		if (this.state.loading) return

		const params = {
			pass: "",
			r: this.state.defaultColor.r,
			g: this.state.defaultColor.g,
			b: this.state.defaultColor.b,
			on: this.state.defaultOn ? 1:0,
			button: this.state.buttonEnabled ? 1:0
		}

		this.setState({ loading: true })
		this.props.device.saveConfig(params, this.processStatus)
	}
	
	render = ({ }, {defaultOn, defaultColor, buttonEnabled, info, connection, changed, password, loading}) =>
		<div class={style.settings}>
			<h2>State after power-on</h2>
			<OnOff onChange={this.handleDefaultOn} on={defaultOn}/>
			<MyColorPicker onChangeComplete={this.handleDefaultColor} color={defaultColor}/>

			<h2>Touch button enabled</h2>
			<OnOff onChange={this.handleButtonEnabled} on={buttonEnabled}/>

			<h2>Admin password</h2>
			<AdminPass onChange={this.handlePassword} />

			<h2>Device info</h2>
			<DeviceInfo {...info} connection={ connection } />

			{changed ? <button onClick={this.handleSave} disabled={ !password.valid || loading } class={style.saveButton}>Save changes</button> : '' }
		</div>

}
