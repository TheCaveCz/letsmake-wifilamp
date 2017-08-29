const request = require('superagent')

export default class Device {
  constructor(url, user, pass) {
    this.url = url
    this.user = user
    this.pass = pass
    this.onError = null
    this.onAuthError = null
  }

  load(url, params, callback) {
    if (typeof params === 'function') {
      callback = params
      params = undefined
    }
    if (!callback) {
      callback = () => {
      }
    }

    let req = request(params ? 'POST' : 'GET', this.url + url).auth(this.user, this.pass).timeout({ response: 6000, deadline: 12000 })

    if (params) {
      req = req.type('form').send(params)
    }

    req.then(response => {
      callback(undefined, response.body)
    }, error => {
      if (error.status === 401) {
        callback('Invalid username or password')
        if (this.onAuthError) { this.onAuthError(error) }
      } else {
        if (error.response && error.response.body && error.response.body.error) {
          error = error.response.body.error
        }
        callback(`${error}`)
        if (this.onError) { this.onError(error) }
      }
    })
  }

  tryLogin(user, pass, result) {
    request('GET', `${this.url}api/statusShort`).auth(user, pass).timeout({
      response: 3000,
      deadline: 8000,
    }).then(() => {
      this.user = user
      this.pass = pass
      result({ login: true })
    }, error => {
      result(error.status === 401 ? { login: false } : { error })
    })
  }

  loadStatus(result) {
    this.load('api/statusShort', result)
  }

  loadFullStatus(result) {
    this.load('api/status', result)
  }

  loadNetworks(result) {
    this.load('api/scan', result)
  }

  scanNetworks(result) {
    this.load('api/scan', { scan: true }, result)
  }

  saveConfig(params, result) {
    const { pass, r, g, b, on, button } = params
    this.load('api/config', { pass, r, g, b, on, button }, result)
  }

  saveWifi(ssid, pass, result) {
    this.load('api/wifi', { ssid, pass }, result)
  }

  reboot(result) {
    this.load('api/reboot', { reboot: true }, result)
  }


  setColor(color, time, result) {
    const { r, g, b } = color
    this.load('api/color', { r, g, b, time: time || 500 }, result)
  }

  setOn(on, time, result) {
    this.load('api/on', { on: on ? 1 : 0, time: time || 500 }, result)
  }
}
