module user

pub struct User {
	id       int    [primary; sql: serial] // a field named `id` of integer type must be the first field	
	username string
}
