//
//  Command.swift
//  DisplayAlignment
//
//  Created by Yoshimasa Niwa on 6/13/23.
//

import ArgumentParser
import CoreGraphics
import Display
import Foundation

@main
struct Command: ParsableCommand {
    static var configuration = CommandConfiguration(
        subcommands: [
            List.self,
            Position.self,
            Align.self
        ]
    )

    private struct List: ParsableCommand {
        func run() {
            let activeDisplaySet = DisplaySet.active

            let displays = activeDisplaySet.displays.sorted { lhs, rhs in
                lhs.identifier < rhs.identifier
            }

            for display in displays {
                let line = String(
                    format: "%@ id: %2d, position: (x: %5d, y: %5d), size: (width: %5d, height: %5d)",
                    display.isPrimary ? "*" : " ",
                    display.identifier,
                    display.bounds.origin.x, display.bounds.origin.y,
                    display.bounds.width, display.bounds.height
                )
                print(line)
            }
        }
    }

    private struct Position: ParsableCommand {
        @Option(name: [.short, .customLong("id")], help: "Display ID")
        private var identifier: CGDirectDisplayID

        @Option(name: .short, help: "Horizontal position of Display")
        private var x: Int32?

        @Option(name: .short, help: "Vertical position of Display")
        private var y: Int32?

        func run() {
            let activeDisplaySet = DisplaySet.active

            guard activeDisplaySet.displays.count > 1 else {
                // There is only one display, positioning is not possible.
                return
            }

            activeDisplaySet.update { display in
                guard display.identifier == identifier else {
                    return nil
                }

                var updatedDisplay = display
                if let x = x {
                    updatedDisplay.bounds.origin.x = x
                }
                if let y = y {
                    updatedDisplay.bounds.origin.y = y
                }

                return updatedDisplay
            }
        }
    }

    private struct Align: ParsableCommand {
        private enum Alignment: String, CaseIterable, ExpressibleByArgument {
            // Vertical
            case top
            case middle
            case bottom

            // Horizontal
            case leading
            case center
            case trailing
        }

        @Argument(help: "Alignment of displays")
        private var alignment: Alignment

        func run() {
            let activeDisplaySet = DisplaySet.active

            guard activeDisplaySet.displays.count > 1 else {
                // There is only one display, positioning is not possible.
                return
            }

            guard let primaryDisplay = activeDisplaySet.primaryDisplay else {
                // Should not reach here.
                return
            }

            switch alignment {
            case .top:
                activeDisplaySet.update { display in
                    var updatedDisplay = display
                    updatedDisplay.bounds.origin.y = primaryDisplay.bounds.origin.y
                    return updatedDisplay
                }
            case .middle:
                activeDisplaySet.update { display in
                    var updatedDisplay = display
                    updatedDisplay.bounds.origin.y = primaryDisplay.bounds.origin.y + Int32(Float(primaryDisplay.bounds.height - display.bounds.height) * 0.5)
                    return updatedDisplay
                }
            case .bottom:
                activeDisplaySet.update { display in
                    var updatedDisplay = display
                    updatedDisplay.bounds.origin.y = primaryDisplay.bounds.origin.y + (primaryDisplay.bounds.height - display.bounds.height)
                    return updatedDisplay
                }
            case .leading:
                activeDisplaySet.update { display in
                    var updatedDisplay = display
                    updatedDisplay.bounds.origin.x = primaryDisplay.bounds.origin.x
                    return updatedDisplay
                }
            case .center:
                activeDisplaySet.update { display in
                    var updatedDisplay = display
                    updatedDisplay.bounds.origin.x = primaryDisplay.bounds.origin.x + Int32(Float(primaryDisplay.bounds.width - display.bounds.width) * 0.5)
                    return updatedDisplay
                }
            case .trailing:
                activeDisplaySet.update { display in
                    var updatedDisplay = display
                    updatedDisplay.bounds.origin.x = primaryDisplay.bounds.origin.x + (primaryDisplay.bounds.width - display.bounds.width)
                    return updatedDisplay
                }
            }
        }
    }
}
