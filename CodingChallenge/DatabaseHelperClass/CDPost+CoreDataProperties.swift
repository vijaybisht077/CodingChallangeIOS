//
//  CDPost+CoreDataProperties.swift
//  CodingChallenge
//
//  Created by vijaybisht on 10/06/24.
//
//

import Foundation
import CoreData


extension CDPost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPost> {
        return NSFetchRequest<CDPost>(entityName: "CDPost")
    }

    @NSManaged public var body: String?
    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var userId: Int16

}

extension CDPost : Identifiable {

}
