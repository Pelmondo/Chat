//
//  MessageSR+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 20/11/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//
//

import Foundation
import CoreData


extension MessageSR {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageSR> {
        return NSFetchRequest<MessageSR>(entityName: "MessageSR")
    }

    @NSManaged public var user: Bool
    @NSManaged public var text: String?
    @NSManaged public var isIncoming: Bool
    @NSManaged public var date: NSDate?

}
