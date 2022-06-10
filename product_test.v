module main

import json

fn new_product() Product {
	order := Order{}
	product := Product{
		hours: 0
		products: ''
		order: order
	}
	return product
}

fn test_new_product() {
	order := Order{}
	generic_product := Product{
		hours: 10
		products: ''
		order: order
	}
	product := Product{
		hours: 10
		products: json.encode([generic_product])
		order: order
	}
	assert product.calculate_total_hours() == 20
}
