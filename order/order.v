module order

import user { User }

[table: 'orders']
pub struct Order {
	id       int  [primary; sql: serial] // a field named `id` of integer type must be the first field	
	user     User [null]
	quantity int  [null]
}
