import vweb
import order { Order }
import product { Product }
import sqlite

pub struct App {
	vweb.Context
}

['/products']
fn (mut app App) products() vweb.Result {
	db := sqlite.connect('database') or { panic('fuck') }
	products := sql db {
		select from Product
	}
	return app.json(products)
}

['/products/:id']
fn (mut app App) products_by_id(id int) vweb.Result {
	db := sqlite.connect('database') or { panic('fuck') }
	product := sql db {
		select from Product where id == id
	}
	return app.json(product)
}

['/orders']
fn (mut app App) orders() vweb.Result {
	order := Order{}
	return app.json([order])
}

['/orders/:id']
fn (mut app App) orders_by_id(id int) vweb.Result {
	order := Order{}
	return app.json(order)
}

fn main() {
	db := sqlite.connect('database') or { panic('fuck') }
	sql db {
		create table Product
	}
	vweb.run(&App{}, 8080)
}
