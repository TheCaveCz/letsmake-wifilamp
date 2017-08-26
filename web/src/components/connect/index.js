import {h, Component} from 'preact'
import style from './style.less'
import WiFiList from './../wifilist'

export default class Home extends Component {

	handleConnect = () => {
		
	}

	render = ({ ssid, device }) =>
	<div class={style.connect}>
		{ ssid ? 
			<div>
				<h2>Connect to new WiFi</h2>
				<p>You are connecting to network <strong>{ ssid }</strong>. Please enter password.</p>
				<p><input type='password' placeholder='WiFi password' /></p>
				<p><button onClick={this.handleConnect}>Connect!</button></p>
			</div>
			:
			<div>
				<h2>WiFi connection</h2>
				<WiFiList device={device} />
			</div>
		}
	</div>
}