import { h, Component } from 'preact'
import style from './style.less'
import WiFiList from './../wifilist'
import { Link } from 'preact-router'

export default class Connect extends Component {
  state = {
    valid: false,
    password: '',
    loading: false,
    reboot: false,
    afterReboot: false,
  }


  handleConnect = formEvent => {
    formEvent.preventDefault()
    
    if (!this.state.valid) { return }

    this.setState({ loading: true })
    this.props.device.saveWifi(this.props.ssid, this.state.password, error => {
      this.setState({ loading: false, reboot: !error })
    })
  }

  handleReboot = () => {
    this.setState({ loading: true })
    this.props.device.reboot(error => {
      this.setState({ loading: false, afterReboot: !error })
    })
  }

  handlePassword = event => {
    const password = event.target.value
    this.setState({ valid: password.length > 0 && password.length <= 32, password })
  }

  render = ({ ssid, device }, { loading, valid, reboot, afterReboot }) => {
    if (afterReboot) {
      return (
        <div className={style.connect}>
          <h2>Connect to new WiFi</h2>
          <p>Device is rebooting right now. It will probably have new IP address so you should <strong>close this page</strong>.</p>
        </div>
      )
    }

    if (reboot) {
      return (
        <div className={style.connect}>
          <h2>Connect to new WiFi</h2>
          <p>Connection information for network <strong>{ ssid }</strong> was saved. Reboot the device to connect to new network.</p>
          <p>
            <button onClick={this.handleReboot} disabled={loading}>Reboot!</button>
          </p>
        </div>
      )
    }

    if (ssid) {
      return (
        <div className={style.connect}>
          <h2>Connect to new WiFi</h2>
          <p>You are connecting to network <strong>{ ssid }</strong>. Please enter password.</p>
          <form onSubmit={this.handleConnect}>
            <p><input type="password" placeholder="WiFi password" onInput={this.handlePassword}/></p>
            <p>
              <input type="submit" value="Connect!" disabled={loading || !valid}/>
            </p>
          </form>
          <p><Link href="/settings/connect">Back</Link></p>
        </div>
      )
    }

    return (
      <div className={style.connect}>
        <h2>WiFi connection</h2>
        <WiFiList device={device}/>
      </div>
    )
  }
}
