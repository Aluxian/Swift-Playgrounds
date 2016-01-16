//Problem
//
//Cindy loves cookies! In fact, the only thing she eats are cookies. To be exact, she only eats one cookie in the evening each day. Each morning Cindy's parents give her an allowance of x dollars. Each cookie costs y dollars. Let's follow Cinty for z days and see how she eats. We'll label the days 1 through z. On the morning of day 1, Cindy has no cookies and no money.
//
//A typical day is as follows:
//
//- Cindy's parents give her an allowance in the morning
//- At noon Cindy is hungry and looks to see if she has some cookies. If she has no cookies, she uses all of her allowance to purchase any many cookies as possible. If she has some cookes she does nothing.
//- In the evening Cindy eats one of her cookies that were purchased with her allowance.
//
//For the given x, y, and z, calculate how much of her allowance Cindy has left at the end of day z. We are not concerned with the fact that she may or may not have any cookies left.
//
//Given multiple queries (x, y, z), you must process all of them. To be exact, you are given Int arrays X, Y, and Z, each with Q elements. For each valid index, you must answer the query with x=X[index], y=Y[index], and z=Z[index]. Return an array of Int with Q elements: the answers to the queries, in the same order.
//
//Constraints
//
//-    The number of queries will be between 1 and 100, inclusive.
//-    X, Y, Z will contain same number of elements.
//-    Each element of X, Y and Z will be between 1 and 1,000,000,000, inclusive.
//-    For each valid i, Y[i] <= X[i].
//
//
//Examples 1:
//
//[5]
//[3]
//[3]
//
//Returns: [6]
//
//There is only one query. In this query, Cindy receives 5 dollars each day, a cookie costs 3 dollars, and there are 3 days. The entire process will look as follows:
//Day 1 morning: Cindy receives 5 dollars. She now has 5 dollars and 0 cookies.
//Day 1 noon: Cindy has no cookies, so she buys one. She now has 2 dollars and 1 cookie.
//Day 1 evening: Cindy eats a cookie. She now has 2 dollars and 0 cookies.
//Day 2 morning: Cindy receives 5 dollars. She now has 7 dollars and 0 cookies.
//Day 2 noon: Cindy has no cookies, so she buys two. She now has 1 dollar and 2 cookies.
//Day 2 evening: Cindy eats a cookie. She now has 1 dollar and 1 cookie.
//Day 3 morning: Cindy receives 5 dollars. She now has 6 dollars and 1 cookie.
//Day 3 noon: Cindy still has some cookies, so she does nothing. She still has 6 dollars and 1 cookie.
//Day 3 evening: Cindy eats a cookie. She now has 6 dollars and 0 cookies.
//Hence, at the end of day 3 Cindy will have 6 dollars.
//
//Example 2:
//
//[5,5,5,5,5]
//[3,3,3,3,3]
//[1,2,3,4,5]
//
//Returns: [2, 1, 6, 2, 7 ]
//
//Example 3:
//
//[1_000_000_000,1000000000,1000000000,1000000000,1000000000]
//[1,2,3,999999998,999999999]
//[342_568_368,560496730,586947396,386937583,609483745]
//
// Days when she buys cookies
//
// [1]
// [1B]
//
// [X,   (1 + X/2 - 1) * X + R,       ((1 + 500M + ((1 + 500M - 1) * X + R) / 2) - (SPENT LAST BUYING DAY)) * X + R,
// [1,   1 + X/2,                      1 + 500M + ((1 + 500M - 1) * X + R) / 2,
// [X/2, ((1 + X/2 - 1) * X + R) / 2,                         (((1 + 500M + ((1 + 500M - 1) * X + R) / 2) - (SPENT LAST BUYING DAY)) * X + R) / 2,
//
// 
// MONEY:           X           (D - P.D) * X + P.R
// DAY:             1           P.D + P.C
// COOKIES BOUGHT:  M / 2       M / 2
// REMAINDER:       M % price   M % price
//
// DAY:             1
//
//
//
//Returns:
//[342568367000000000, 60496729000000000, 253614062000000001, 773875166, 609483745 ]

class CookieGobbler {
    func determine(x: [Int], y: [Int], z: [Int]) -> [Int] {
        let q = x.count
        var result = [Int]()
        
        for queryIndex in 0...(q-1) {
            
            let allowance = Double(x[queryIndex])
            let price = Double(y[queryIndex])
            let targetDay = Double(z[queryIndex])
            
            //var money = days * allowance
            //var cookies = days
            
            var maxI = 50
            
            var money = [Double](count: maxI, repeatedValue: 0)
            var day = [Double](count: maxI, repeatedValue: 0)
            var cookies = [Double](count: maxI, repeatedValue: 0)
            var remainder = [Double](count: maxI, repeatedValue: 0)
            
            money[0] = allowance
            day[0] = 1
            cookies[0] = (money[0] - (money[0] % price)) / price
            remainder[0] = money[0] % price
            
            for i in 1...(maxI-1) {
                day[i] = day[i-1] + cookies[i-1]
                money[i] = (day[i] - day[i-1]) * allowance + remainder[i-1]
                cookies[i] = (money[i] - (money[i] % price)) / price
                remainder[i] = money[i] % price
                
                if day[i] > targetDay {
                    println(money[i])
                    println(money[i] - (day[i] - targetDay) * allowance)
                    println(i)
                    println(day[i])
                    println(targetDay)
                    result.append(Int(money[i] - (day[i] - targetDay) * allowance))
                    break
                }
            }
            
            money
            day
            cookies
            remainder
            
        }
        
        return result
    }
    
    func determine2(x: [Int], y: [Int], z: [Int]) -> [Int] {
        let q = x.count
        var result = [Int]()
        
        for queryIndex in 0...(q-1) {
            
            let allowance = x[queryIndex]
            let price = y[queryIndex]
            let days = z[queryIndex]
            
            var money: Int = 0
            var cookies: Int = 0
            
            for day in 1...days {
                // Morning
                money += allowance
                
                // Noon
                if cookies == 0 {
                    cookies += (money - (money % price)) / price
                    money = money % price
                }
                
                // Evening
                cookies--
            }
            
            result.append(money)
            
        }
        
        return result
    }
}

let cookieGobbler = CookieGobbler()

cookieGobbler.determine([5], y: [3], z: [3])
cookieGobbler.determine([5,5,5,5,5], y: [3,3,3,3,3], z: [1,2,3,4,5])
cookieGobbler.determine([1000000000,1000000000,1000000000,1000000000,1000000000], y: [1,2,3,999999998,999999999], z: [342568368,560496730,586947396,386937583,609483745])







