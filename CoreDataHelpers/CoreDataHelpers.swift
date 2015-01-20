//
//  CoreDataHelpers.swift
//  CoreDataHelpers
//
//  Created by Tim Schmitz on 1/16/15.
//  Copyright (c) 2015 Tap and Tonic. All rights reserved.
//

import Foundation
import CoreData

public extension NSManagedObjectContext {
	public func entitiesMatchingPredicate(predicate: NSPredicate, entityName: String) -> [NSManagedObject] {
		let fetchRequest = NSFetchRequest(entityName: entityName)
		fetchRequest.predicate = predicate
		
		var error: NSError?
		if let results = self.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject] {
			return results
		} else {
			return []
		}
	}
	
	public func findFirstOfEntity(entityName: String, predicate: NSPredicate) -> NSManagedObject? {
		let fetchRequest = NSFetchRequest(entityName: entityName)
		fetchRequest.fetchLimit = 1
		fetchRequest.predicate = predicate
		
		var error: NSError?
		if let results = self.executeFetchRequest(fetchRequest, error: &error) {
			return results.first as? NSManagedObject
		} else {
			return nil
		}
	}
	
	public func findFirstOfEntity(entityName: String, key: String, value: AnyObject) -> NSManagedObject? {
		let predicate = NSPredicate(format: "%K = %@", argumentArray: [key, value])
		return self.findFirstOfEntity(entityName, predicate: predicate)
	}
	
	public func deleteAllOfEntity(entityName: String) -> NSError? {
		var fetchRequest = NSFetchRequest(entityName: entityName)
		fetchRequest.includesPropertyValues = false
		fetchRequest.returnsObjectsAsFaults = true
		
		var error: NSError?
		let results = self.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]
		for object in results {
			self.deleteObject(object)
		}
		
		return error
	}
	
	public func managedObjectWithID(managedObjectID: NSManagedObjectID) -> NSManagedObject? {
		var error: NSError?
		return self.existingObjectWithID(managedObjectID, error: &error)
	}
}