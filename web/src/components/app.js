import { h, Component } from 'preact'
import { Router, route } from 'preact-router'

import Header from './header'
import Home from './home'
import Settings from './settings'
import Connect from './connect'
import Login from './login'
import Device from './device'

const ENV = process.env.NODE_ENV || 'development'
const defaultDevice = new Device(ENV === 'production' ? '/' : 'http://192.168.85.219/', 'admin', '')

export default class App extends Component {
  state = {
    device: defaultDevice,
    currentUrl: '/',
    lastError: '',
  }

  componentDidMount() {
    const device = this.state.device

    device.onAuthError = () => {
      route('/login')
    }
    device.onError = error => {
      console.log('App level handle error', error)
      this.setState({ lastError: `${error}` })
    }
  }

  handleLogin = () => {
    route('/')
  }

  handleRoute = event => {
    this.setState({ currentUrl: event.url })
  }

  handleDismissError = event => {
    event.preventDefault()
    this.setState({ lastError: '' })
  }

  render = (_, { device, currentUrl, lastError }) => (
    <div id="app">
      <Header selected={currentUrl}/>
      {lastError && <div className="stickyErrors"><p>{lastError}<a href="#" onClick={this.handleDismissError}>Dismiss</a></p></div>}
      <Router onChange={this.handleRoute}>
        <Home path="/" device={device}/>
        <Settings path="/settings" device={device}/>
        <Connect path="/settings/connect" device={device}/>
        <Login path="/login" device={device} onLogin={this.handleLogin}/>
      </Router>
    </div>
  )
}
