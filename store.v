module main

pub struct Store {
mut:
	products []Product
}

pub fn (store &Store) validate_product(product Product) bool {
	return true
}

pub fn (mut store Store) add(product Product) {
	if store.validate_product(product) {
		store.products << product
	} else {
		panic('Fuck')
	}
}
