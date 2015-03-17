//
//  main.swift
//  tuenti_challenge_2014_2
//
//  Created by cicloon on 13/3/15.
//  Copyright (c) 2015 cicloon. All rights reserved.
//

import Foundation

println("Hello, World!")

println(C_ARGC)

struct Direction{
    var horizontal: Int
    var vertical: Int
    
    mutating func applyDirectionChar(directionChar: Character) -> String{
        
        var circuitChar: String = ""
        circuitChar.append(directionChar)

        switch circuitChar{
        case "/":
            if self.vertical == 1 {
                self.horizontal = -1
                self.vertical = 0
                break
            } else if self.vertical == -1{
                self.horizontal = 1
                self.vertical = 0
                break
            }
            
            if self.horizontal == 1{
                self.horizontal = 0
                self.vertical = -1
                break
            } else if self.horizontal == -1{
                self.horizontal = 0
                self.vertical = 1
                break
            }
            
            if self.horizontal == 0 && self.vertical == 0{
                self.horizontal = 1
            }
            

            
        case "\\":
            if self.vertical == 1 {
                self.horizontal = 1
                self.vertical = 0
                break
            } else if self.vertical == -1{
                self.horizontal = -1
                self.vertical = 0
                break
            }
            if self.horizontal == 1{
                self.horizontal = 0
                self.vertical = 1
                break
            } else if self.horizontal == -1{
                self.horizontal = 0
                self.vertical = -1
                break
            }
        case "#":
            circuitChar = "#"
        default:
            if self.horizontal != 0{
                circuitChar =  "-"
            } else if self.vertical != 0 {
                circuitChar = "|"
            }
        }

        
        return circuitChar
    }
}

struct Position {
    let row: Int
    let column: Int
    
    func newPositionFromDirection(dir: Direction) -> Position{
        let newRow = self.row + dir.vertical
        let newColumn = self.column + dir.horizontal
        return Position(row: newRow, column: newColumn)
    }
}


class Circuit{
    var circuit = [[String]]()
    var minColumns: Int = 0
    
    init(){
        self.circuit = [[String]](count: 1, repeatedValue: [String](count: 1, repeatedValue: String(" ")  )   )
    }
    
    func setPositionWithChar(position: Position, char: String){
        if position.row >= self.circuit.count{
            self.appendRows(position.row - self.circuit.count + 1)
        }

        if position.column >= self.circuit[position.row].count{
            self.appendColumnsToRow( position.column - self.circuit[position.row].count + 1, row: position.row)
        }

        self.circuit[position.row][position.column] = char
    }
    
    func appendRows(numRows: Int){
        for _ in 1...numRows{
            circuit.append( [String](count: minColumns, repeatedValue: String() ) )
        }
    }
    
    func appendColumnsToRow(numColumns: Int, row: Int){
        for _ in 1...numColumns{
            circuit[row].append( String(" ") )
        }
    }
    
    func print(){
        for i in 0...self.circuit.count - 1{
            var rowString = ""
            var row = self.circuit[i]
            for j in 0...self.circuit[i].count - 1{
                rowString += row[j]
            }
            println(rowString)
        }
    }
    
}

func stringLastIndexOf(src: String, target: String) -> String.Index? {
    var position: String.Index? = nil
    var comparingStr: String
    
    for var index = src.endIndex;
        index != src.startIndex && position == nil;
        index = index.predecessor() {
        
            let ch = "\(src[index.predecessor()])"
            if ch == target{
                position = index
            }
    }
    
    return position
}


let bundle = NSBundle.mainBundle()
let path = String.fromCString(C_ARGV[1])
var error: NSError?

var content = String(contentsOfFile: path!, encoding: NSASCIIStringEncoding, error: nil )!


//let rangeOfRightCurves = content.rangeOfString("/", options: NSStringCompareOptions.CaseInsensitiveSearch, range: stringRange, locale: nil)



let lastRightCurveIndex = stringLastIndexOf(content, "/")!

let lastIndex = content.endIndex

let lastRightCurveRange = Range<String.Index>(start: lastRightCurveIndex.predecessor().predecessor(), end: content.endIndex.predecessor() )

let circuit: Circuit = Circuit()


let startString = content.substringWithRange(lastRightCurveRange)
content.removeRange(lastRightCurveRange)

let finalCurves = "\(startString)\(content)".stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: ""))


var currentPosition = Position(row: 0, column: 0)
var currentDirection = Direction(horizontal: 0, vertical: 0)

for char in finalCurves{

    var directionChar = currentDirection.applyDirectionChar(char)
    circuit.setPositionWithChar(currentPosition, char: directionChar)
    currentPosition = currentPosition.newPositionFromDirection(currentDirection)
}


println("The circuit is:")
circuit.print()
    


