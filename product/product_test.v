import order { Order }
import product { Product }

fn new_product() Product {
	order := Order{}
	product := Product{
		hours: 0
		products: []
		order: order
	}
	return product
}

fn test_new_product() {
	product := new_product()
	assert product.calculate_total_hours() == 0
}
