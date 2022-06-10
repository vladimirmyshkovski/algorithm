module main

import json

[table: 'products']
pub struct Product {
	id    int    [primary; sql: serial]
	hash  string
	order Order
mut:
	products string // Stringify JSON
	hours    int
}

pub fn (product Product) calculate_total_hours() int {
	mut total_hours := product.hours
	products := json.decode([]Product, product.products) or { panic('Fuck!') }
	for i in 0 .. products.len {
		p := products[i]
		total_hours += p.hours
	}
	return total_hours
}

pub fn (product Product) encode() string {
	return json.encode(product)
}

pub fn (app &App) find_all_products() []Product {
	return sql app.db {
		select from Product
	}
}

pub fn (app &App) find_product_by_id(id int) Product {
	return sql app.db {
		select from Product where id == id
	}
}

pub fn (app &App) get_products_count() int {
	return sql app.db {
		select count from Product
	}
}
