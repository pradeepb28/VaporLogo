import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
//    router.get { req in
//        return "It works!!!"
//    }
//
//    // Basic "Hello, world!" example
//    router.get("hello") { req in
//        return "Hello, world!"
//    }
//
//    // Example of configuring a controller
//    let todoController = TodoController()
//    router.get("todos", use: todoController.index)
//    router.post("todos", use: todoController.create)
//    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    // return string
    router.get { req in
        return "Hello"
    }
    
    // pass path and return integer
    router.get("hello") { req in
        return 100
    }
    
    //pass nested path
    router.get("hello", "world") { req in
        return "Hello / world"
    }
    
    //pass path w. dynamic value
    router.get("hello", Int.parameter) { req -> String in
        let id = try req.parameters.next(Int.self)
        return "hello / \(id)"
    }
    
    //return Logo model
    router.get("logo", String.parameter) { req -> Logo in
        let domain = try req.parameters.next(String.self)
        return Logo.init(name: domain)
    }
    
    //return view by passing Dictionary
    router.get("logoLeaf", String.parameter) { req -> Future<View> in
        let domain = ["domain": try req.parameters.next(String.self)]
        return try req.view().render("Logo", domain)
    }
    
    //return view by passing Logo model
    router.get("logoLeaf1", String.parameter) { req -> Future<View> in
        let domain = try req.parameters.next(String.self)
        let logo = Logo.init(name: domain)
        
        return try req.view().render("Logo", logo)
    }
    
    //redirecting to other url
    router.get("redirect", String.parameter) { req -> Response in
        let name = try req.parameters.next(String.self)
        return req.redirect(to: "https://autocomplete.clearbit.com/v1/companies/suggest?query=\(name)")
    }
    

    //request third party API data
    router.get("company", String.parameter) { req -> Future<[Company]> in
        
        let name = try req.parameters.next(String.self)
        let client = try req.make(Client.self)
       
        return client.get("https://autocomplete.clearbit.com/v1/companies/suggest?query=\(name)").flatMap(to: [Company].self, { (response) in

            guard let _ = response.http.body.data else { throw Abort.init(.internalServerError)}
            
            return try response.content.decode([Company].self)
        })
    }
    
    //show third party API data in View
    router.get("companyView", String.parameter) { req -> Future<View> in
        
        let name = try req.parameters.next(String.self)
        let client = try req.make(Client.self)
        
        let companyResponse: Future<[Company]> =
            client.get("https://autocomplete.clearbit.com/v1/companies/suggest?query=\(name)").flatMap(to: [Company].self, { (response) in
            
            guard let _ = response.http.body.data else { throw Abort.init(.internalServerError)}
            
            return try response.content.decode([Company].self)
        })
        
        return try req.view().render("Company", ["companies": companyResponse.map {$0}])
    }

}


















//https://github.com/vapor/vapor/blob/master/Sources/Development/main.swift


//func search(query: String, location: FoursquareLocation) throws -> Future<[FoursquareResponse]> {
//    guard let endpoint = self.searchEndpoint(query: query, location: location) else { throw Abort(.internalServerError) }
//
//    let client = try self.request.make(Client.self)
//
//    return client.get(endpoint).map(to: [FoursquareResponse].self, { response in
//        guard let data = response.http.body.data else { throw Abort(.internalServerError) }
//        return try FoursquareClient.decoder.decode([FoursquareResponse].self, from: data)
//    })


//struct Todo: Content {
//    var id: Int?
//    var title: String
//    var done: Bool
//
//    init(id: Int? = nil, title: String, done: Bool) {
//        self.id = id
//        self.title = title
//        self.done = done
//    }
//}
//
//extension Todo {
//    /// define all json-keys (most of the time same as stored properties)
//    enum CodingKeys: String, CodingKey {
//        case id
//        case title
//        case done
//    }
//
//    convenience init(from decoder: Decoder) throws {
//        /// pass in the CodingKeys with your cases
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let id = container.decodeIfPresent(Int.self, forKey: CodingKeys.id)
//        let title = container.decode(String.self, forKey: CodingKeys.title)
//        let done = container.decode(Bool.self, forKey: CodingKeys.done)
//
//        /// initialize your struct
//        try self.init(id: id, title: title, done: done)
//    }
//}
