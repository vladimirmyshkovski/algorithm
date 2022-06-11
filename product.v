module main

import vweb
import json
// import crypto.aes
// import crypto.rand
import crypto.sha256
import time

pub enum ProductPurpose {
	production
	consume
}

pub enum ProductClass {
	a
	b
	c
}

pub struct Product {
	hash      string
	timestamp i64
	work      Work
	purpose   ProductPurpose
	class     ProductClass
mut:
	product_hashes []string
}

pub fn (product Product) encode() string {
	return json.encode(product)
}

pub fn (app &App) find_all_products() []Product {
	return store.products
}

pub fn (app &App) find_product_by_hash(hash string) Product {
	for index in 0 .. store.products.len {
		product := store.products[index] or { panic('Not found') }
		if product.hash == hash {
			return product
		}
	}
	panic('Not found')
}

pub fn (app &App) get_products_count() int {
	return store.products.len
}

pub fn (app &App) get_hours_by_product_hash(hash string) int {
	mut hours := 0
	product := app.find_product_by_hash(hash)
	hours += product.work.hours
	for i in 0 .. product.product_hashes.len {
		product_hash := product.product_hashes[i]
		child_product := app.find_product_by_hash(product_hash)
		hours += child_product.work.hours
	}
	return hours
}

['/products']
fn (mut app App) products() vweb.Result {
	mut data := Product{
		product_hashes: []
		work: Work{
			signature: 'fake_signature'
			hours: 10
		}
		purpose: ProductPurpose.consume
		class: ProductClass.b
		timestamp: time.now().unix
	}
	product_without_hash := json.decode(Product, data.encode()) or { panic('Invalid data') }
	println(time.now())
	product := Product{
		work: product_without_hash.work
		purpose: product_without_hash.purpose
		class: product_without_hash.class
		product_hashes: product_without_hash.product_hashes
		timestamp: product_without_hash.timestamp
		hash: sha256.sum(product_without_hash.encode().bytes()).hex()
	}
	store.products << product
	products := app.find_all_products()
	return app.json(products)
}

['/products'; post]
fn (mut app App) create_product(data string) vweb.Result {
	product_without_hash := json.decode(Product, data) or { panic('Invalid data') }
	product := Product{
		work: product_without_hash.work
		purpose: product_without_hash.purpose
		class: product_without_hash.class
		product_hashes: product_without_hash.product_hashes
		timestamp: product_without_hash.timestamp
		hash: sha256.sum(product_without_hash.encode().bytes()).hex()
	}
	store.products << product
	/*
	mut data := ProductWithoutHash{
		product_hashes: []
		work: Work{
			signature: 'fake_signature'
			hours: 10
		}
		purpose: ProductPurpose.consume
		class: ProductClass.b
	}
	product_without_hash := json.decode(ProductWithoutHash, data) or { panic('Invalid data') }
	key := rand.bytes(32) or { panic('Fuck') }
	cipher := aes.new_cipher(key)
	mut hash := []u8{len: aes.block_size}
	cipher.encrypt(mut hash, product_without_hash.encode().bytes())
	product := Product{
		work: product_without_hash.work
		purpose: product_without_hash.purpose
		class: product_without_hash.class
		product_hashes: product_without_hash.product_hashes
		hash: '{$hash.bytestr()}'
		// key: '{$key.bytestr()}'
	}
	store.products << product
	*/
	return app.json(product)
}

['/products/:hash']
fn (mut app App) product_by_id(hash string) vweb.Result {
	product := app.find_product_by_hash(hash)
	return app.json(product)
}

['/products/:hash/total_hours']
fn (mut app App) total_hours(hash string) vweb.Result {
	product := app.find_product_by_hash(hash)
	return app.json(product)
}
