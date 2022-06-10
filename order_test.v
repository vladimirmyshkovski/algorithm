module main

fn test_new_order() {
	user := User{
		id: 0
		username: 'fakeusername'
	}
	order := Order{
		id: 1
		user: user
		quantity: 1
	}
}
