import { h, Component } from 'preact'
import style from './style.less'
import { Link } from 'preact-router'

const RSSI = ({ rssi }) => (
  <i className={style.rssi}>
    <svg width="20" height="20" viewBox="0 0 512 512">
      <path className={rssi > -60 ? 'rssi-on' : 'rssi-off'} d="M233.5 70.4c93.7-6.7 189.6 28.3 256.5 94.4 8.8 9 7.6 24.8-1.6 33.1 -8.5 10-25.5 10.2-34.3 0.4 -57.2-55.1-138-84.9-217.3-79 -65.9 4.2-129.7 32.6-177.6 78.1 -4.3 4.3-9.7 7.9-15.9 8.2 -15.7 1.8-30.2-14.5-26.8-29.9 1-5.5 4.5-10.1 8.5-13.7C81 108.4 156.2 75.5 233.5 70.4z"/>
      <path className={rssi > -80 ? 'rssi-on' : 'rssi-off'} d="M231.2 162.3c71.8-7.8 146.4 18.7 197.2 70 7.9 9.1 7 23.9-1.9 32.1 -8 9.8-24.3 11-33.4 2 -32.5-32.1-76.5-52.4-122.1-55.8 -55.4-4.6-112 16.4-151.4 55.4 -9.1 9.6-26 8.5-34.2-1.7 -8.8-8.3-9.6-23.6-1.1-32.4C123.4 192.8 176.2 167.9 231.2 162.3z"/>
      <path className={rssi > -90 ? 'rssi-on' : 'rssi-off'} d="M241.8 253c45.3-4.5 92.2 12.9 123.7 45.7 8.6 9 7.6 24.5-1.5 32.8 -8.3 10-24.8 10.6-33.8 1.3 -17.8-18.2-42.4-29.8-67.9-31.2 -28.9-2.1-58.2 9.4-78.7 29.7 -5.1 5.7-12.6 9.2-20.2 8.3 -17.8-1.2-30.2-25.1-17.9-39.3C170.3 273.2 205.5 256.6 241.8 253z"/>
      <path className="rssi-on" d="M248.8 337.7c29.2-4.9 58.8 19.2 59.8 48.8 2.7 29-22.9 56.6-52.1 56 -26.2 0.9-50.5-20.8-52.8-46.9C200 368.2 221.4 340.8 248.8 337.7z"/>
    </svg>
  </i>
)


export default class WiFiList extends Component {
  static defaultProps = {
    refreshInterval: 2500,
  }

  state = {
    inprogress: true,
    networks: [],
    current: '',
  }

  componentDidMount() {
    this.refreshNetworks()
  }

  componentWillUnmount() {
    this.resetTimer()
  }

  resetTimer = () => {
    if (this.timer) {
      clearTimeout(this.timer)
      this.timer = false
    }
  }

  refreshNetworks = () => {
    this.resetTimer()
    this.props.device.loadNetworks(this.handleScanResult)
  }

  handleRefreshNow = () => {
    this.resetTimer()
    this.props.device.scanNetworks(this.handleScanResult)
  }

  handleScanResult = (error, result) => {
    if (error) {
      this.setState({ inprogress: false})
      return
    }

    const { inprogress, current } = result

    if (inprogress) {
      this.setState({ inprogress, current })
      this.timer = setTimeout(this.refreshNetworks, this.props.refreshInterval)
    } else {
      const networkNames = {}
      const networks = (result.networks || []).sort((a, b) => b.rssi - a.rssi).filter(item => {
        return networkNames.hasOwnProperty(item.ssid) ? false : (networkNames[item.ssid] = true)
      })
      this.setState({ inprogress, current, networks })
    }
  }

  render = (_, { inprogress, networks, current }) => (
    <div>
      { current && <p>Current WiFi network: <strong>{current}</strong></p> }
      { networks && networks.length > 0 &&
        <table>
          <tr>
            <th colSpan="2">Available networks</th>
          </tr>
          {networks.map(network => (
            <tr className={current === network.ssid ? style.current : ''}>
              <td><RSSI rssi={network.rssi}/>{network.ssid}</td>
              <td><Link href={`/settings/connect?ssid=${network.ssid}`}>Connect</Link></td>
            </tr>
          ))}
        </table>
      }
      <p className={style.scan}>
        {inprogress ? 'Scanning for networks...' : <button onClick={this.handleRefreshNow}>Scan for networks</button> }
      </p>
    </div>
  )
}
