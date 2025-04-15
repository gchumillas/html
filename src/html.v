module html

import js.dom

pub type Component = fn () &Element

const document = dom.document

pub fn get_element_by_id(id string) ?&Element {
	native_element := document.getElementById(id.str)?

	return &Element{
		native_element: native_element
	}
}

pub fn create_element(params struct {
pub:
	tag_name string
	children []&Element
}) &Element {
	mut target := document.createElement(params.tag_name.str)

	for elem in params.children {
		target.appendChild(elem.native_element)
	}

	return &Element{
		native_element: target
	}
}

/*
This module defines the `Element` struct and its associated methods for interacting with HTML elements in a V program.
*/

pub struct Element {
mut:
	native_element JS.HTMLElement
}

pub fn (target &Element) add_event_listener(event string, cb fn ()) {
	target.native_element.addEventListener(
		event.str,
		fn [cb] (_ JS.Event) { cb() },
		JS.EventListenerOptions{}
	)
}

pub fn (target &Element) render(comp Component) {
	target.native_element.appendChild(comp().native_element)
}

pub fn (mut target Element) append_child(el &Element) {
	target.native_element.appendChild(el.native_element)
}

pub fn (target &Element) get_inner_text() string {
	return string(target.native_element.innerText)
}

pub fn (mut target Element) set_inner_text(text string) {
	target.native_element.innerText = text.str
}