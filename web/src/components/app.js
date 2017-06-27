import {h, Component} from 'preact'
import {Router} from 'preact-router'

import Header from './header'
import Home from './home'
import Settings from './settings'
import Device from './device.js'

const ENV = process.env.NODE_ENV || 'development'

export default class App extends Component {
	constructor(props) {
		super()

		this.state = {
			device: new Device(ENV === 'production' ? '/' : 'http://192.168.85.219/', 'admin', 'wifilamp')
		}
	}

	handleRoute = e => {
		this.currentUrl = e.url
	};

	render({}, {device}) {
		return (
			<div id="app">
				<Header />
				<Router onChange={this.handleRoute}>
					<Home path="/" device={ device }/>
					<Settings path="/settings/" user="me" device={ device }/>
				</Router>
			</div>
		)
	}
}
