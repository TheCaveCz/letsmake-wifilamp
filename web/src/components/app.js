import {h, Component} from 'preact'
import {Router, route} from 'preact-router'

import Header from './header'
import Home from './home'
import Settings from './settings'
import Connect from './connect'
import Login from './login'
import Device from './device.js'

const ENV = process.env.NODE_ENV || 'development'
const defaultDevice = new Device(ENV === 'production' ? '/' : 'http://192.168.85.219/', 'admin', '')

export default class App extends Component {
	state = {
		device: defaultDevice,
		currentUrl: '/',
		lastError: ''
	}

	componentDidMount() {
		this.state.device.onAuthError = () => {
			route("/login")
		}
		this.state.device.onError = e => {
			console.log("App level handle error", e)
			this.setState({lastError: '' + e})
		}
	}

	handleLogin = () => {
		route("/")
	}

	handleRoute = e => {
		this.setState({currentUrl: e.url})
	}

	handleDismissError = e => {
		e.preventDefault()
		this.setState({lastError: ''})
	}

	render = ({}, {device, currentUrl, lastError}) =>
		<div id="app">
			<Header selected={currentUrl}/>
			{lastError ? <div class="stickyErrors">
				<p>{lastError}<a href="#" onClick={this.handleDismissError}>Dismiss</a></p>
			</div> : ''}
			<Router onChange={this.handleRoute}>
				<Home path="/" device={device}/>
				<Settings path="/settings" device={device}/>
				<Connect path="/settings/connect" device={device}/>
				<Login path="/login" device={device} onLogin={this.handleLogin}/>
			</Router>
		</div>
}
