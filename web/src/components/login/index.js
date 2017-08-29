import { h, Component } from 'preact'
import style from './style.less'

export default class Login extends Component {
  state = {
    user: '',
    pass: '',
    loading: false,
    message: '',
  }

  handleUserInput = txt => {
    this.setState({ user: txt.target.value })
  }

  handlePassInput = txt => {
    this.setState({ pass: txt.target.value })
  }

  handleLogin = () => {
    this.setState({ loading: true })
    this.props.device.tryLogin(this.state.user, this.state.pass, result => {
      this.setState({ loading: false })

      if (result.login === true) {
        this.props.onLogin()
      } else if (result.login === false) {
        this.setState({ message: 'Invalid username or password', pass: '' })
      } else if (result.error) {
        this.setState({ message: String(result.error) })
      }
    })
  }

  render = (_, { loading, message, user, pass }) => (
    <div className={style.login}>
      <h2>Login</h2>
      { message && <p className={style.error}>{message}</p> }

      <p><input autoComplete="off" autoCorrect="off" autoCapitalize="off" spellCheck="false" type="text" placeholder="Username" onInput={this.handleUserInput} value={user}/></p>
      <p><input type="password" placeholder="Password" onInput={this.handlePassInput} value={pass}/></p>
      <p>
        <button onClick={this.handleLogin} disabled={loading}>Login</button>
      </p>
    </div>
  )
}
