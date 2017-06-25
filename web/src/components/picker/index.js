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
	handleClick = e =>{
		this.props.onClick(this.props.color, e)
	}

	render() {
		return (<div class={style.swatch} style={ {'background-color':this.props.color} } onClick={this.handleClick} ></div>)
	}
}

class MyColorPicker extends Component {

	render() {
		const colors = ['#B80000', '#DB3E00', '#FCCB00', '#008B02', '#006B76', '#1273DE', '#004DCF', '#5300EB', '#EB9694', '#FAD0C3', '#FEF3BD', '#C1E1C5', '#BEDADC', '#C4DEF6', '#BED3F3', '#D4C4FB'];

		return (
			<div class={style.myPicker}>
				<div class={style.swatchList}>
				{ map(colors, (c) => (
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