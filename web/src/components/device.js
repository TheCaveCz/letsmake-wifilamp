export default class Device {
	constructor(url, user, pass) {
		this.url = url
		this.user = user
		this.pass = pass
	}

	load(url, params) {
		const headers = new Headers()
		headers.append('Authorization','Basic '+btoa(this.user + ':' + this.pass))

		var info = {
			cache: 'no-cache',
			headers: headers	
		}

		if (params) {
			const body = new URLSearchParams()
			for (let key in params) {
				if (params.hasOwnProperty(key)) {
					body.append(key, params[key])
				}
			}
			
			info.body = body
			info.method = 'POST'
			headers.append('Content-Type','application/x-www-form-urlencoded')
		}

		return fetch(this.url + url, info)
			.then(response => {
				if (response.status == 401) {
					throw new Error("Invalid username or password")
				} else if (response.status == 404) {
					throw new Error("File not found")
				}
				return response.json()
			})
			.then(json => {
				if (json.error) {
					throw new Error(json.error)
				}
				return Promise.resolve(json)
			})
	}

	loadStatus(result) {
		this.load('api/statusShort').then(json => {
			if (result) result(json)
		}).catch(e => console.log(e))
	}

	setColor(color, time) {
		this.load('api/color', {r: color.r, g:color.g, b:color.b, time:time || 1000})
	}

}
