import {h, Component} from 'preact'
import {Link} from 'preact-router'
import style from './style.less'

const Header = () =>
	<header class={style.header}>
		<h1><span>WiFi Lamp</span></h1>
		<nav>
			<Link href="/">Home</Link>
			<Link href="/settings">Settings</Link>
		</nav>
	</header>

export default Header
