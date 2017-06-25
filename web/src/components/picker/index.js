import { h, Component } from 'preact'
import style from './style.less'
import { CustomPicker } from 'react-color'
import { Saturation, Hue, Swatch } from 'react-color/lib/components/common'
import map from 'lodash/map'

class MySatPointer extends Component {
	render() {
		return (<div class={style.satPointer}></div>)
	}
}

class MyHuePointer extends Component {
	render() {
		return (<div class={style.huePointer}></div>)
	}
}

class MySwatch extends Component {
	handleClick = e => {
		this.props.onClick(this.props.color, e)
	}

	render() {
		return (<div class={style.swatch} style={ {'background-color':this.props.color} } onClick={this.handleClick} ></div>)
	}
}

class MyColorPicker extends Component {
	static defaultProps = {
		colors: ['#FF6900', '#FCB900', '#7BDCB5', '#00D084', '#8ED1FC', '#0693E3', '#ABB8C3', '#EB144C', '#F78DA7', '#9900EF', '#FFFFFF', '#808080']
	}

	render() {
		return (
			<div class={style.myPicker}>
				<div class={style.swatchList}>
				{ map(this.props.colors, (c) => (
					<MySwatch color={ c } onClick={ this.props.onChange }/>
				)) }
					<div class={style.clear} />
				</div>
				<div class={style.satPicker}>
					<Saturation {...this.props} onChange={ this.props.onChange } pointer={MySatPointer} />
				</div>
				<div class={style.huePicker}>
					<Hue {...this.props} onChange={ this.props.onChange } pointer={MyHuePointer} />
				</div>
			</div>
		)
	}
}

export default CustomPicker(MyColorPicker);