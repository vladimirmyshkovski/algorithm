module main

import vweb
import vweb.sse
import json
import time

pub struct Data {
	products_count int
	hours_count    int
}

pub struct App {
	vweb.Context
}

fn main() {
	mut app := App{}
	vweb.run(app, 8080)
}

pub fn (mut app App) index() vweb.Result {
	title := 'SSE Example'
	return $vweb.html()
}

pub fn (mut app App) get_data() Data {
	return Data{
		products_count: app.get_products_count()
		hours_count: 0
	}
}

fn (mut app App) sse() vweb.Result {
	mut session := sse.new_connection(app.conn)
	session.start() or { return app.server_error(501) }
	session.send_message(data: 'ok') or { return app.server_error(501) }
	for {
		data := json.encode(app.get_data())
		session.send_message(event: 'ping', data: data) or { return app.server_error(501) }
		println('> sent event: $data')
		time.sleep(1 * time.second)
	}
	return app.server_error(501)
}
