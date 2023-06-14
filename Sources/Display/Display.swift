//
//  Display.swift
//  Display
//
//  Created by Yoshimasa Niwa on 6/13/23.
//

import Foundation
import CoreGraphics

public struct Display {
    public struct Bounds: Equatable {
        public struct Origin: Equatable {
            public var x: Int32
            public var y: Int32

            public init(x: Int32, y: Int32) {
                self.x = x
                self.y = y
            }

            init(point: CGPoint) {
                self.x = Int32(point.x)
                self.y = Int32(point.y)
            }
        }

        public var origin: Origin
        public var width: Int32
        public var height: Int32

        public init(origin: Origin, width: Int32, height: Int32) {
            self.origin = origin
            self.width = width
            self.height = height
        }

        init(rect: CGRect) {
            self.origin = Origin(point: rect.origin)
            self.width = Int32(rect.width)
            self.height = Int32(rect.height)
        }
    }

    public var identifier: CGDirectDisplayID
    public var isPrimary: Bool
    public var bounds: Bounds

    init(identifier: CGDirectDisplayID, isPrimary: Bool) {
        self.identifier = identifier
        self.isPrimary = isPrimary
        self.bounds = Bounds(rect: CGDisplayBounds(identifier))
    }
}

public struct DisplaySet {
    public static var active: DisplaySet {
        var displayCount = CGDisplayCount(0)
        CGGetActiveDisplayList(0, nil, &displayCount)

        var displayIDs = [CGDirectDisplayID](repeating: 0, count: Int(displayCount))
        CGGetActiveDisplayList(displayCount, &displayIDs, nil)

        let displays = displayIDs.enumerated().map { index, displayID in
            Display(identifier: displayID, isPrimary: index == 0)
        }
        return DisplaySet(displays: displays)
    }

    public var displays: [Display]

    public var primaryDisplay: Display? {
        displays.first { display in
            display.isPrimary
        }
    }

    public func update(with block: (Display) -> Display?) {
        var config: CGDisplayConfigRef?
        CGBeginDisplayConfiguration(&config)

        var isUpdated = false
        for display in displays {
            guard let updatedDisplay = block(display) else {
                // No update.
                continue
            }

            if updatedDisplay.identifier != display.identifier {
                // Unintentional update.
                continue
            }

            // This is currently only supported update.
            if updatedDisplay.bounds.origin != display.bounds.origin {
                CGConfigureDisplayOrigin(
                    config,
                    updatedDisplay.identifier,
                    updatedDisplay.bounds.origin.x,
                    updatedDisplay.bounds.origin.y
                )
                isUpdated = true
            }
        }

        if isUpdated {
            CGCompleteDisplayConfiguration(config, .permanently)
        } else {
            CGCancelDisplayConfiguration(config)
        }
    }
}
