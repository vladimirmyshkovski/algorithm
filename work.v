module main

import vweb
import json

pub struct Work {
	id        int
	signature string
	hours     int
}

pub fn (work Work) encode() string {
	return json.encode(work)
}

pub fn (app &App) find_work_by_signature(signature string) Work {
	// return sql app.db {
	// select from Work where signature == signature
	// }
	for index in 0 .. store.products.len {
		product := store.products[index]
		work := product.work
		if work.signature == signature {
			work
		}
	}
	panic('Fuck')
}

['/works/:signature']
fn (mut app App) works(signature string) vweb.Result {
	work := app.find_work_by_signature(signature)
	return app.json(work)
}
