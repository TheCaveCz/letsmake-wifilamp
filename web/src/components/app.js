import {h, Component} from 'preact'
import {Router} from 'preact-router'

import Header from './header'
import Home from './home'
import Settings from './settings'
import Connect from './connect'
import Device from './device.js'

const ENV = process.env.NODE_ENV || 'development'

export default class App extends Component {
	state = {
		device: new Device(ENV === 'production' ? '/' : 'http://192.168.85.219/', 'admin', 'wifilamp'),
		currentUrl: '/'
	}

	handleRoute = e => {
		this.setState({ currentUrl: e.url })
	}

	render = ({}, {device, currentUrl}) =>
		<div id="app">
			<Header selected={ currentUrl }/>
			<Router onChange={this.handleRoute}>
				<Home path="/" device={ device }/>
				<Settings path="/settings/" device={ device }/>
				<Connect path="/settings/connect" device={ device } />
			</Router>
		</div>
}
