import UIKit

class CircularProgressView: UIView {
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    
    var progressColor: UIColor = .systemGreen
    var trackColor: UIColor = .systemGray5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    // 1. Setup layers once (empty)
    private func setupLayers() {
        // Track (Gray)
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 4 // Make it thinner looks nicer
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)
        
        // Progress (Green)
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 4
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }
    
    // 2. THIS IS THE FIX: Update paths whenever the layout changes
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Now we know the REAL size of the view
        let centerPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let circleRadius = (min(bounds.width, bounds.height) - trackLayer.lineWidth) / 2
        
        let circlePath = UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circlePath.cgPath
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.frame = bounds
        
        progressLayer.path = circlePath.cgPath
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.frame = bounds
    }
    
    func setProgress(to value: Float, animated: Bool = true) {
        let clampedValue = max(0, min(value, 1))
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 1.0
            animation.fromValue = 0
            animation.toValue = clampedValue
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            progressLayer.strokeEnd = CGFloat(clampedValue)
            progressLayer.add(animation, forKey: "animateCircle")
        } else {
            progressLayer.strokeEnd = CGFloat(clampedValue)
        }
    }
}
