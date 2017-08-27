import {h, Component} from 'preact'
import style from './style.less'
import WiFiList from './../wifilist'
import {Link} from 'preact-router'


export default class Home extends Component {
	state = {
		valid: false,
		password: "",
		loading: false,
		reboot: false,
		afterReboot: false
	}


	handleConnect = e => {
		e.preventDefault()
		if (!this.state.valid) return;

		this.setState({ loading: true })
		this.props.device.saveWifi(this.props.ssid, this.state.password, error => {
			this.setState({ loading: false, reboot: error ? false:true })
		})
	}

	handleReboot = e => {
		e.preventDefault()
		this.setState({ loading: true })
		this.props.device.reboot(error => {
			this.setState({ loading: false, afterReboot: error ? false:true })
		})
	}

	handlePassword = txt => {
		const password = txt.target.value
		this.setState({ valid: password.length>0 && password.length<=32, password})
	}

	render = ({ ssid, device }, { loading, valid, reboot, afterReboot }) =>
		ssid ? reboot ? afterReboot ?
			<div class={style.connect}>
				<h2>Connect to new WiFi</h2>
				<p>Device is rebooting right now. It will probably have new IP address so you should <strong>close this page</strong>.</p>
			</div>
			:
			<div class={style.connect}>
				<h2>Connect to new WiFi</h2>
				<p>Connection information for network <strong>{ ssid }</strong> was saved. Reboot the device to connect to new network.</p>
				<p><button onClick={this.handleReboot} disabled={loading}>Reboot!</button></p>
			</div>
			:
			<div class={style.connect}>
				<h2>Connect to new WiFi</h2>
				<p>You are connecting to network <strong>{ ssid }</strong>. Please enter password.</p>
				<p><input type='password' placeholder='WiFi password' oninput={this.handlePassword} /></p>
				<p><button onClick={this.handleConnect} disabled={loading || !valid}>Connect!</button></p>
				<p><Link href='/settings/connect'>Back</Link> </p>
			</div>
			:
			<div class={style.connect}>
				<h2>WiFi connection</h2>
				<WiFiList device={device} />
			</div>

}