struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    let validCurrencies = ["USD", "GBP", "EUR", "CAN"]

    public init(amount: Int, currency: String) {
        if !validCurrencies.contains(currency) {
            print("Invalid currency")
        }
        self.amount = amount
        self.currency = currency
    }
    
    func convert(_ convert: String) -> Money{
        //Convert from currency to USD
        let currencies = ["USD": 1.0, "GBP": 2.0, "EUR": 1.0/1.5, "CAN": 1.0/1.25]
        let usdValue = (currencies[self.currency] ?? 0) * Double(self.amount)
        
        let fromUSD = ["USD": 1.0, "GBP": 0.5, "EUR": 1.5, "CAN": 1.25]
        
        let finalAmount = Double(usdValue) * (fromUSD[convert] ?? 1.0)
        return Money(amount: Int(finalAmount), currency: convert)
    }

    func add(_ money: Money) -> Money{
        let convertedSelf = self.convert(money.currency)
        let newAmount = convertedSelf.amount + money.amount
        return Money(amount: newAmount, currency: money.currency)
    }
    
    func subtract(_ money: Money) -> Money{
        let convertedSelf = self.convert(money.currency)
        let newAmount = convertedSelf.amount - money.amount
        return Money(amount: newAmount, currency: money.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title: String
    var type: JobType
    
    public init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let wage):
            return Int(wage * Double(hours))
        case .Salary(let salary):
            return Int(salary)
        }
    }
    
    func raise(byAmount: Double) {
        switch type {
        case .Hourly(let wage):
            type = .Hourly(wage + byAmount)
        case .Salary(let salary):
            type = .Salary(UInt(Double(salary) + byAmount))
        }
    }
    
    func raise(byPercent: Double) {
        switch type {
        case .Hourly(let wage):
            let raise = wage * byPercent
            type = .Hourly(wage + raise)
        case .Salary(let salary):
            let raise = Double(salary) * byPercent
            type = .Salary(UInt(Double(salary) + raise))
        }
    }
}

    
    ////////////////////////////////////
    // Person
    //
    public class Person {
        var firstName: String
        var lastName: String
        var age: Int
        private var _job: Job?
        private var _spouse: Person?
        
        var job: Job? {
            get {
                return _job
            }
            set {
                if age >= 16 {
                    _job = newValue
                }
            }
        }
        
        var spouse: Person? {
            get {
                return _spouse
            }
            set {
                if age >= 18 {
                    _spouse = newValue
                }
            }
        }
        
        init(firstName: String, lastName: String, age: Int) {
            self.firstName = firstName
            self.lastName = lastName
            self.age = age
            self.job = nil
            self.spouse = nil
        }
        
        func toString() -> String {
            return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job?.title ?? "nil") spouse:\(spouse?.firstName ?? "nil")]"
        }
    }
    
    ////////////////////////////////////
    // Family
    //
    public class Family {
        var members: [Person]
        
        init(spouse1: Person, spouse2: Person) {
            self.members = []
            if spouse1.spouse == nil && spouse2.spouse == nil {
                // Check both are adults (at least 18 years old)
                if spouse1.age >= 18 && spouse2.age >= 18 {
                    spouse1.spouse = spouse2
                    spouse2.spouse = spouse1
                    
                    self.members.append(spouse1)
                    self.members.append(spouse2)
                }
            }
        }
        
        func haveChild(_ child: Person) -> Bool {
            if members[0].age > 21 || members[1].age > 21 {
                members.append(child)
                return true
            }
            return false
        }
        
        func householdIncome() -> Int {
            var income = 0
            
            members.forEach { member in
                if(member.job != nil){
                    income += (member.job?.calculateIncome(2000))!
                }
            }
            return income
        }
        
    }

