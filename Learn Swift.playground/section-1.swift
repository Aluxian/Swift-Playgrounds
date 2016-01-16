import Foundation


// HELPERS
func rand(max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max)))
}


// Challenge 21 – Super-Duper Shopping Cart (Xcode6-Beta5)

/**
R1 – Create a constant array of string literals called “types” with these
values: book, CD, software
**/
// implement code for R1 below
let types: [String] = ["books", "CD", "software"]


/**

R2 – Create a “Customer” struct with a “name” and “email” property
**/
// implement code for R2 below
struct Customer {
    var name: String
    var email: String
}


/**

R3 – Create a “randomCustomer” function that returns a tuple. Add 3

Customer structs to a dictionary using the customer’s name as the key.
This function returns a randomly selected name and email of a Customer
from the dictionary. (Hint: you can use arc4random_uniform to
randomly select a value.)
**/
// implement code for R3 below
var customers: [String: Customer] = [
    "Anna": Customer(name: "Anna", email: "anna@gmail.com"),
    "Alex": Customer(name: "Alex", email: "alex@gmail.com"),
    "Dave": Customer(name: "Dave", email: "dave@gmail.com")
]

func randomCustomer() -> (String, String) {
    let key = [String](customers.keys)[rand(customers.count)]
    let customer = customers[key]!
    return (customer.name, customer.email)
}


/**

R4 – Create a “Product” class with the following properties:
1. id – Int
2. name – String
3. type – Constant, randomly selected value from “types” array
4. price – Double
5. discount – Double
6. saleStatus – String

Create an initializer that set’s the name, price and discount. The
discount should be set to 0 if discount is not passed. Set the
id to a random number between 1 and 10,000.

Create a getter for “saleStatus” that returns the String
“Sorry. This product is not on sale.” if dicsount is 0. Else
return the interpolated string “This product is on sale. It was
[display original price] but with a discount you only pay
[display sale price].”
**/
// implement code for R4 below
class Product {
    var id: Int = rand(10000) + 1
    var name: String
    let type: String = types[rand(types.count)]
    var price: Double
    var discount: Double
    
    init(name: String, price: Double, discount: Double = 0) {
        self.name = name
        self.price = price
        self.discount = discount
    }
    
    func saleStatus() -> String {
        if discount == 0 {
            return "Sorry. This product is not on sale."
        } else {
            return "This product is on sale. It was \(self.price) but with a discount you only pay \(self.price - self.price * self.discount)."
        }
    }
}


/**

R5 – Create an array called “products” with 5 product objects. Their names are
irrelevant but chose different prices. Set the discounts to 0, 0.1, 0.2, 0.3
and 0.4 respectively.

After adding the items to the array, iterate the collection and println the
“saleStatus” for each item.
**/
// implement code for R5 below
var products = [
    Product(name: "Coca Cola", price: 3.99, discount: 0.0),
    Product(name: "Pepsi", price: 2.99, discount: 0.1),
    Product(name: "Pizza", price: 15.99, discount: 0.2),
    Product(name: "Salad", price: 5.99, discount: 0.3),
    Product(name: "Mushrooms", price: 6.99, discount: 0.4)
]

for product in products {
    println(product.saleStatus())
}


/**

R6 – Write a simple “Cart” class using Generics with the following properties:
1. customerName – String
2. customerEmail – String
3. items – any array of any type T
4. itemCount – Int, getter that returns the count of items in “items”.
5. promoCode – Optional String set to nil

Create an initializer that set the customerName and customerEmail.

Implement the following functions:

1. Create an “add” method that appends any type to the “items” array.
2. Create a “clear” method that removes all items from the “items” array.
3. Create a “remove” method that removes an item from the “items” array
based upon its position in the array.
4. Create a “getPromoCodeDisplay” method that returns the String “Your
promo code is [display promoCode].” if promoCode is not nil. Otherwise,
return the String “You do not have a promo code.”.
5. Create a “getCartStatus” method that returns the String “You have no
items in your cart.” if the number of items in the “items” array is 0.
Return the String “You have [display number of items] items in your
cart.” if the number of items in the “items” array is 1, 2 or 3.
For 4+ items in the “items” array, return the String “You are an
awesome customer!!”
**/
// implement code for R6 below
class Cart<T> {
    var customerName: String
    var customerEmail: String
    var items: [T] = [T]()
    var promoCode: String?
    
    init(customerName: String, customerEmail: String) {
        self.customerName = customerName
        self.customerEmail = customerEmail
    }
    
    func itemCount() -> Int {
        return items.count
    }
    
    func add(item: T) {
        items.append(item)
    }
    
    func clear() {
        items.removeAll(keepCapacity: false)
    }
    
    func remove(position: Int) {
        items.removeAtIndex(position)
    }
    
    func getPromoCodeDisplay() -> String {
        if let promoCode = self.promoCode {
            return "Your promo code is \(promoCode)."
        } else {
            return "You do not have a promo code."
        }
    }
    
    func getCartStatus() -> String {
        switch(items.count) {
        case 0:
            return "You have no items in your cart."
        case 1...3:
            return "You have \(items.count) items in your cart."
        default:
            return "You are an awesome customer!!"
        }
    }
}


/**

R7 – Create a “customer” object by calling the “randomCustomer” function.
Create a new “cart” object for type Product with the newly created
“customer” object’s name and email. Printlnt customer’s name. Println the
itemCount (should be 0). Println the getCartStatus which should display
“You have no items in your cart.”
**/
// implement code for R7 below
let (randomName, randomEmail) = randomCustomer()
let customer = Customer(name: randomName, email: randomEmail)
let cart = Cart<Product>(customerName: customer.name, customerEmail: customer.email)

println(cart.customerName)
println(cart.itemCount())
println(cart.getCartStatus())

/**

R8 – iterate the “products” array and add all items from the “products”
array to the cart except for element 3. Println the itemCount (should be 4),
println getStatus() (should display “You are an awesome customer!!”). Assign
the customer a promo code. First, println getPromoCodeDisplay (should
display “You do not have a promo code.”), then set the promoCode to “1234″,
then println the getPromoCodeDisplay again (should display “Your promo code
is 1234.”).
**/
// implement code for R8 below
for (index, product) in enumerate(products) {
    if index != 3 {
        cart.add(product)
    }
}

println(cart.customerName)
println(cart.getCartStatus())
println(cart.getPromoCodeDisplay())

cart.promoCode = "1234"
println(cart.getPromoCodeDisplay())


/**
R9 – Remove the first item from the cart, then println the itemCount (should
be 3) and println the getCartStatus which should display “You have 3 items
in your cart.”
**/
// implement code for R9 below
cart.remove(0)
println(cart.itemCount())
println(cart.getCartStatus())
