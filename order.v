module main

[table: 'orders']
pub struct Order {
	id       int  [primary; sql: serial]
	user     User [null]
	quantity int  [null]
}

pub fn (app &App) find_all_orders() []Order {
	return sql app.db {
		select from Order
	}
}

pub fn (app &App) find_order_by_id(id int) Order {
	return sql app.db {
		select from Order where id == id
	}
}
