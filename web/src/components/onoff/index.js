import { h, Component } from 'preact'
import style from './style.less'

export default class OnOff extends Component {
	render() {
		return (<div class={style.container}>
			<div class={style.on + (this.props.on ? ' '+style.active:'')} onClick={()=>this.props.onChange(true)}>ON</div>
			<div class={style.off + (!this.props.on ? ' '+style.active:'')} onClick={()=>this.props.onChange(false)}>OFF</div>
			<div style={{clear:'both'}}></div>
		</div>)
	}
}