import vweb
import vweb.sse
import sqlite
import time
import rand
import json

pub struct App {
	vweb.Context
pub mut:
	db sqlite.DB
}

fn main() {
	mut app := App{
		db: sqlite.connect(':memory:') or { panic(err) }
	}
	sql app.db {
		create table Product
		create table Order
		create table User
	}
	vweb.run(app, 8080)
}

pub fn (mut app App) index() vweb.Result {
	title := 'SSE Example'
	return $vweb.html()
}

fn get_data() {
	return {
		"products_count": "$products_count",
	}
}

fn (mut app App) sse() vweb.Result {
	mut session := sse.new_connection(app.conn)
	// NB: you can setup session.write_timeout and session.headers here
	session.start() or { return app.server_error(501) }
	session.send_message(data: 'ok') or { return app.server_error(501) }
	order := Order{}
	for {
		products_count := sql app.db {
			select count from Product 
		}
		product := Product{
			hours: 10
			products: ''
			order: order
		}
		sql app.db {
			insert product into Product 
		}
		data := json.encode({
			"time": time.now().str(),
			"random_id": rand.ulid(),
			"products_count": "$products_count",
		})
		session.send_message(event: 'ping', data: data) or { return app.server_error(501) }
		println('> sent event: $data')
		time.sleep(1 * time.second)
	}
	return app.server_error(501)
}

['/products']
fn (mut app App) products() vweb.Result {
	products := app.find_all_products()
	return app.json(products)
}

['/products/:id']
fn (mut app App) product_by_id(id int) vweb.Result {
	product := app.find_product_by_id(id)
	return app.json(product)
}

['/orders']
fn (mut app App) orders() vweb.Result {
	orders := app.find_all_orders()
	return app.json(orders)
}

['/orders/:id']
fn (mut app App) order_by_id(id int) vweb.Result {
	order := app.find_order_by_id(id)
	return app.json(order)
}

['/users']
fn (mut app App) users() vweb.Result {
	users := app.find_all_users()
	return app.json(users)
}

['/users/:username']
fn (mut app App) user_by_username(username string) vweb.Result {
	users := app.find_users_by_username(username)
	return app.json(users)
}

['/users/:id']
fn (mut app App) user_by_id(id int) vweb.Result {
	user := app.find_user_by_id(id)
	return app.json(user)
}
