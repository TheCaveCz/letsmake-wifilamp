var request = require('superagent');

export default class Device {
	constructor(url, user, pass) {
		this.url = url
		this.user = user
		this.pass = pass
	}

	load(url, params, callback) {
		if (typeof params === 'function') {
			callback = params
			params = undefined
		}
		if (!callback) callback = () => {}

		let req = request(params ? 'POST' : 'GET', this.url + url)
			.auth(this.user, this.pass).timeout({ response: 3000, deadline: 8000 })

		if (params) {
			req = req.type('form').send(params)
		}

		req.then(response => {
			callback(undefined, response.body)

		}, e => {
			if (e.status === 401) {
				callback("Invalid username or password")
				if (this.onAuthError) this.onAuthError(e)
			} else {
				if (e.response && e.response.body && e.response.body.error) {
					e = e.response.body.error
				}
				callback(""+e)
				if (this.onError) this.onError(e)
			}
		})
	}

	tryLogin(user,pass,result) {
		request('GET', this.url + 'api/statusShort').auth(user, pass).timeout({ response: 3000, deadline: 8000 }).then(response => {
			this.user = user
			this.pass = pass
			result({login:true})
		}, e => {
			result(e.status === 401 ? {login:false} : {error:e})
		})
	}

	loadStatus(result) {
		this.load('api/statusShort', result)
	}

	loadFullStatus(result) {
		this.load('api/status', result);
	}

	loadNetworks(result) {
		this.load('api/scan', result);
	}

	scanNetworks(result) {
		this.load('api/scan', {scan: true}, result);
	}

	saveConfig(params, result) {
		const { pass, r, g, b, on, button } = params
		this.load('api/config', { pass, r, g, b, on, button }, result);
	}

	saveWifi(ssid, pass, result) {
		this.load('api/wifi', { ssid, pass }, result);
	}

	reboot(result) {
		this.load('api/reboot', { reboot: true }, result);
	}


	setColor(color, time, result) {
		const {r, g, b} = color
		this.load('api/color', {r, g, b, time: time || 500}, result);
	}

	setOn(on, time, result) {
		this.load('api/on', {on: on ? 1 : 0, time: time || 500}, result);
	}

}
