module main

[table: 'users']
pub struct User {
	id       int    [primary; sql: serial]
	username string
}

pub fn (app &App) find_all_users() []User {
	return sql app.db {
		select from User
	}
}

pub fn (app &App) find_user_by_id(id int) User {
	return sql app.db {
		select from User where id == id
	}
}

pub fn (app &App) find_users_by_username(username string) []User {
	return sql app.db {
		select from User where username == username
	}
}
