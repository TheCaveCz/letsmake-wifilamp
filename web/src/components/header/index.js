import { h, Component } from 'preact'
import { Link } from 'preact-router'
import style from './style.less'


const HeaderLink = ({ title, url, selected }) => (
  <Link href={url} class={selected === url ? style.active : ''}>{title}</Link>
)

export default class Header extends Component {
  render = ({ selected }) => (
    <header className={style.header}>
      <h1><span>WiFi Lamp</span></h1>
      <nav>
        <HeaderLink title="Home" url="/" selected={selected}/>
        <HeaderLink title="Settings" url="/settings" selected={selected}/>
        <HeaderLink title="WiFi" url="/settings/connect" selected={selected}/>
      </nav>
    </header>
  )
}

