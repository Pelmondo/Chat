//
//  UserSE+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 20/11/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//
//

import Foundation
import CoreData


extension UserSE {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSE> {
        return NSFetchRequest<UserSE>(entityName: "UserSE")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var lastMessage: String?
    @NSManaged public var messages: String?
    @NSManaged public var isOnline: Bool

}
