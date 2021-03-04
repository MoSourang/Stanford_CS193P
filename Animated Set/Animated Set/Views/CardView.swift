//
//  CardView.swift
//  Graphical Set
//
//  Created by Mouhamed Sourang on 1/20/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardIsSelected))
        self.addGestureRecognizer(tap)
        self.layer.needsDisplayOnBoundsChange = true
        
    }
    
    @objc func cardIsSelected() {
        cardViewDelegate?.cardWasSelected(at: buttonIndex)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8.0
    }
    
    private var tapCount = 0
    var buttonIndex: Int!
    var isCardSelected = false
    var cardViewDelegate: didTouchCard?
    var originalFrame: CGRect!
    
    var card: SetCard!
    
    var cardIsFaceUp: Bool! {
        didSet {
            if cardIsFaceUp {
                guard card != nil else {return}
                numberOfShape = card.number
                typeOfShape = card.shape
                fillcolor =  card.color
                strokeColor = card.shadding
            } else {
                numberOfShape = .none
                typeOfShape  = .none
                fillcolor = .none
                strokeColor = .none
            }
            
        }
    }
    
    
    var numberOfShape: SetCard.Number! { didSet { setNeedsDisplay() }}
    var typeOfShape: SetCard.Shape!  { didSet { setNeedsDisplay()}}
    var fillcolor: SetCard.Color! {didSet {setNeedsDisplay()}}
    var strokeColor:  SetCard.Shadding! {didSet {setNeedsDisplay()}}
    
    private var fill:  UIColor!
    private var stroke: UIColor!
    
    
    private var drawBounds: CGRect {
        return self.bounds.offsetBy(dx: 20.0, dy: 20.0)
    }
    
    private lazy var midHeight = drawBounds.size.height / 2
    private lazy var midWidth = drawBounds.size.width / 2
    private lazy var radius = drawBounds.size.width / 8
    private lazy var diameter = radius * 2
    private var path: UIBezierPath!
    
    internal override func draw(_ rect: CGRect) {
        
        switch fillcolor {
        case .featureOne:
            fill = UIColor.green
            stroke = UIColor.green
        case .featureTwo:
            fill = UIColor.red
            stroke = UIColor.red
        case .featureThree:
            fill = UIColor.purple
            stroke = UIColor.purple
        case .none:
            return
        }
        
        switch strokeColor {
        case .featureOne:
            stroke = nil
        case .featureTwo:
            fill = nil
        case .featureThree:
            fill = fill.withAlphaComponent(CGFloat(0.20))
            stroke = nil
        case .none:
            return
        }
        
        switch typeOfShape {
        case .featureOne:
            drawPathForTriangles(numberOfPaths: numberOfShape, with: fill, and: stroke)
        case .featureTwo:
            drawPathForCircles(numberOfPaths: numberOfShape, with: fill, and: stroke)
        case .featureThree:
            drawPathForSquares(numberOfPaths: numberOfShape, with: fill, and: stroke)
        case .none:
            return
        }
    }
    
    func drawPathForCircles(numberOfPaths: SetCard.Number, with fillColor: UIColor?, and strokeColor: UIColor?) {
        guard let centers = calculateCircleCenter(numberOfPaths: numberOfShape) else {return}
        let radius = drawBounds.size.width / 7
        for center in centers {
            path = UIBezierPath()
            path.lineWidth = 2.0
            path.addArc(withCenter: center, radius: radius , startAngle: CGFloat(0.0).toRadian(), endAngle: CGFloat(360.0).toRadian(), clockwise: true)
            if let fillColor = fillColor {fillColor.setFill() ; path.fill()}
            if let strokeColor = strokeColor {strokeColor.setStroke() ; path.stroke()}
        }
    }
    
    func drawPathForSquares(numberOfPaths: SetCard.Number, with fillColor: UIColor?, and strokeColor: UIColor?) {
        guard  let origines = calculateSquareOrigine(numberOfPaths: numberOfPaths) else {return}
        for origine in origines {
            path = UIBezierPath()
            path.lineWidth = 2.0
            path.move(to: origine)
            path.addLine(to: CGPoint(x: path.currentPoint.x + diameter, y: path.currentPoint.y))
            path.addLine(to: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y + diameter))
            path.addLine(to: CGPoint(x: path.currentPoint.x - diameter, y: path.currentPoint.y))
            path.close()
            if let fillColor = fillColor {fillColor.setFill() ; path.fill()}
            if let strokeColor = strokeColor {strokeColor.setStroke() ; path.stroke()}
        }
    }
    
    func drawPathForTriangles(numberOfPaths: SetCard.Number, with fillColor: UIColor?, and strokeColor: UIColor?) {
        guard  let origines = calculateTriangleOrigine(numberOfPaths: numberOfPaths) else {return}
        for origine in origines {
            path = UIBezierPath()
            path.lineWidth = 2.0
            path.move(to: origine)
            path.move(to: origine)
            path.addLine(to: CGPoint(x: path.currentPoint.x + radius, y: path.currentPoint.y + diameter))
            path.addLine(to: CGPoint(x: path.currentPoint.x  - diameter , y: path.currentPoint.y))
            path.close()
            if let fillColor = fillColor {fillColor.setFill() ; path.fill()}
            if let strokeColor = strokeColor {strokeColor.setStroke() ; path.stroke()}
        }
    }
    
    func calculateTriangleOrigine(numberOfPaths: SetCard.Number) -> [CGPoint]? {
        let firstTriangleOrigine: CGPoint!
        let secondTriangleOrigine : CGPoint!
        let thirdTriangleOrigine : CGPoint!
        let triangleOrigineDistane = (radius * 2) + Draw.distance
        var triangleOrigines = [CGPoint]()
        
        switch numberOfPaths {
        case .featureOne:
            firstTriangleOrigine = CGPoint(x: midWidth, y: midHeight - radius)
            triangleOrigines.append(firstTriangleOrigine)
        case .featureTwo:
            firstTriangleOrigine = CGPoint(x: midWidth - triangleOrigineDistane / 2, y: midHeight - radius)
            secondTriangleOrigine = CGPoint(x: firstTriangleOrigine.x + diameter + Draw.distance, y: firstTriangleOrigine.y)
            triangleOrigines = [firstTriangleOrigine , secondTriangleOrigine]
        case .featureThree:
            firstTriangleOrigine = CGPoint(x: midWidth - (diameter + Draw.distance)  , y: midHeight - radius)
            secondTriangleOrigine = CGPoint(x: firstTriangleOrigine.x + diameter + Draw.distance, y: firstTriangleOrigine.y)
            thirdTriangleOrigine = CGPoint(x: secondTriangleOrigine.x + diameter + Draw.distance, y: firstTriangleOrigine.y)
            triangleOrigines = [firstTriangleOrigine , secondTriangleOrigine , thirdTriangleOrigine]
        }
        return  triangleOrigines
    }
    
    func calculateCircleCenter(numberOfPaths: SetCard.Number) -> [CGPoint]? {
        let firstCircleCenter: CGPoint!
        let secondCircleCenter : CGPoint!
        let thirdCircleCenter : CGPoint!
        var circleCenters  = [CGPoint]()
        switch numberOfPaths {
        case .featureOne:
            firstCircleCenter = CGPoint(x: midWidth, y: midHeight)
            circleCenters.append(firstCircleCenter)
        case .featureTwo:
            firstCircleCenter = CGPoint(x: midWidth - (radius + Draw.distance), y: midHeight )
            secondCircleCenter = CGPoint(x: midWidth + (radius + Draw.distance), y: drawBounds.size.height / 2 )
            circleCenters  = [firstCircleCenter , secondCircleCenter ]
        case .featureThree:
            firstCircleCenter = CGPoint(x: midWidth - (diameter + Draw.distance) , y: midHeight)
            secondCircleCenter = CGPoint(x: firstCircleCenter.x + diameter + Draw.distance , y:firstCircleCenter.y )
            thirdCircleCenter = CGPoint(x: secondCircleCenter.x + diameter + Draw.distance, y: firstCircleCenter.y)
            circleCenters  = [firstCircleCenter , secondCircleCenter , thirdCircleCenter]
        }
        return circleCenters
    }
    
    func calculateSquareOrigine(numberOfPaths: SetCard.Number) -> [CGPoint]? {
        let firstSqureOrigine: CGPoint!
        let secondSqureOrigine: CGPoint!
        let thirdSqureOrigine: CGPoint!
        var squareOrigines  = [CGPoint]()
        
        switch numberOfPaths {
        case .featureOne:
            firstSqureOrigine = CGPoint(x: midWidth - radius, y: midHeight - radius)
            squareOrigines.append(firstSqureOrigine)
        case .featureTwo:
            firstSqureOrigine = CGPoint(x: midWidth - (diameter + Draw.distance), y: midHeight - radius)
            secondSqureOrigine = CGPoint(x: firstSqureOrigine.x + (diameter + Draw.distance), y: firstSqureOrigine.y)
            squareOrigines = [firstSqureOrigine, secondSqureOrigine]
        case .featureThree:
            firstSqureOrigine = CGPoint(x: midWidth - (radius * 3 + Draw.distance), y: midHeight - radius)
            secondSqureOrigine = CGPoint(x: firstSqureOrigine.x + (diameter + Draw.distance), y: firstSqureOrigine.y)
            thirdSqureOrigine = CGPoint(x: secondSqureOrigine.x + (diameter + Draw.distance), y: secondSqureOrigine.y)
            squareOrigines = [firstSqureOrigine, secondSqureOrigine, thirdSqureOrigine]
        }
        return squareOrigines
    }
}


protocol didTouchCard {
    func cardWasSelected(at cardindex: Int)
}

extension CardView {
    struct Draw {
        static let distance = CGFloat(4.0)
    }
}

extension CGFloat {
    func toRadian() -> CGFloat {
        return self * CGFloat(Double.pi) / 180
    }
}
