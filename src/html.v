module html

import js.dom

const document = dom.document

pub fn get_element_by_id(id string) ?Element {
	native_element := document.getElementById(id.str)?

	return Element{
		native_element: native_element
	}
}

pub type ChildrenParam = string | Element | []Element

pub struct CreateElementProps {
pub:
	tag_name string
	children ?ChildrenParam
pub mut:
	id         ?string
	class_name ?string
}

pub fn create_element(params CreateElementProps) Element {
	mut target := document.createElement(params.tag_name.str)

	// attributes
	if params.id != none {
		target.id = params.id.str
	}
	if params.class_name != none {
		target.className = params.class_name.str
	}

	children := params.children
	if children != none {
		match children {
			string {
				target.innerText = children.str
			}
			Element {
				target.appendChild(children.native_element)
			}
			[]Element {
				for elem in children {
					target.appendChild(elem.native_element)
				}
			}
		}
	}

	return Element{
		native_element: target
	}
}

pub struct Element {
mut:
	native_element JS.HTMLElement
}

pub fn (target Element) add_event_listener(event string, cb fn ()) {
	target.native_element.addEventListener(event.str, fn [cb] (_ JS.Event) {
		cb()
	}, JS.EventListenerOptions{})
}

pub fn (mut target Element) append_child(el Element) {
	target.native_element.appendChild(el.native_element)
}

pub fn (target Element) get_inner_text() string {
	return string(target.native_element.innerText)
}

pub fn (mut target Element) set_inner_text(text string) {
	target.native_element.innerText = text.str
}
