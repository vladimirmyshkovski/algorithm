module product

import order { Order }

[table: 'products']
pub struct Product {
	id    int    [primary; sql: serial] // a field named `id` of integer type must be the first field	
	hash  string
	order Order
mut:
	products []string
	hours int
}

pub fn (product Product) calculate_total_hours() int {
	mut total_hours := product.hours
	/*
	for i := 0; i < product.products.len; i++ {
		total_hours += product.products[i].hours
	}
	*/
	return total_hours
}
