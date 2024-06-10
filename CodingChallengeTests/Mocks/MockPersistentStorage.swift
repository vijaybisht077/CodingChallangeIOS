//
//  MockPersistentStorage.swift
//  CodingChallengeTests
//
//  Created by vijaybisht on 10/06/24.
//

import Foundation
import CoreData

class MockPersistentStorage: PersistentStorageProtocol {
    var context: NSManagedObjectContext
    
    init() {
        let model = MockPersistentStorage.createTestManagedObjectModel()
        let container = NSPersistentContainer(name: "TestContainer", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        self.context = container.viewContext
    }
    
    var saveContextCalled = false
    
    func saveContext() {
        saveContextCalled = true
    }
    
    private static func createTestManagedObjectModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let postEntity = NSEntityDescription()
        postEntity.name = "CDPost"
        postEntity.managedObjectClassName = NSStringFromClass(CDPost.self)

        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .integer16AttributeType
        idAttribute.isOptional = false

        let userIdAttribute = NSAttributeDescription()
        userIdAttribute.name = "userId"
        userIdAttribute.attributeType = .integer16AttributeType
        userIdAttribute.isOptional = false

        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = true

        let bodyAttribute = NSAttributeDescription()
        bodyAttribute.name = "body"
        bodyAttribute.attributeType = .stringAttributeType
        bodyAttribute.isOptional = true

        postEntity.properties = [idAttribute, userIdAttribute, titleAttribute, bodyAttribute]
        model.entities = [postEntity]

        return model
    }
}
