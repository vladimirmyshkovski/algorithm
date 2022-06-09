module product

import order { Order }

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
	mut total_hours := product.hours
	return total_hours
}
