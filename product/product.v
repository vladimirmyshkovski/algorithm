module product

import order { Order }
// import sqlite

[table: 'products']
pub struct Product {
	id    int    [primary; sql: serial]
	hash  string
	order Order
mut:
	products []string
	hours    int
}

pub fn (product Product) calculate_total_hours() int {
	total_hours := product.hours
	/*
	db := sqlite.connect('database') or { panic('fuck') }
	hours := sql db { select hours from Product }
	for i in 0 .. hours.len {
		total_hours += hours[i]
	}
	*/
	return total_hours
}
