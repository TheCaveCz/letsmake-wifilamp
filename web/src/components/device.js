var request = require('superagent');

export default class Device {
	constructor(url, user, pass) {
		this.url = url
		this.user = user
		this.pass = pass
	}

	load(url, params) {
		let req = request(params ? 'POST' : 'GET', this.url + url)
			.auth(this.user, this.pass)

		if (params) {
			req = req.type('form').send(params)
		}

		return req.then(response => {
			if (response.status === 401) {
				throw new Error("Invalid username or password")
			} else if (response.status === 404) {
				throw new Error("File not found")
			} else if (!response.ok) {
				throw new Error("Response not ok")
			} else if (response.body.error) {
				throw new Error(response.body.error)
			}
			return Promise.resolve(response.body)
		})
	}

	loadStatus(result) {
		this.load('api/statusShort').then(json => {
			if (result) result(json)
		}).catch(e => console.log(e))
	}

	setColor(color, time) {
		const {r, g, b} = color
		this.load('api/color', {r, g, b, time: time || 500})
	}

	setOn(on, time) {
		this.load('api/on', {on: on ? 1 : 0, time: time || 500})
	}

}
