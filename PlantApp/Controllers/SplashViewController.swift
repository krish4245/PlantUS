import UIKit

final class SplashViewController: UIViewController {

    // connect this label in storyboard (centered label)
    @IBOutlet weak var logoLabel: UILabel?

    // ========== Config ==========
    private let fullText: String = "Plant"              // text to type
    private let typingInterval: TimeInterval = 0.18     // seconds per character
    private let pauseAfterTyping: TimeInterval = 0.20
    private let loadingDuration: TimeInterval = 1.0     // how long the circular loader runs
    private let fadeDuration: TimeInterval = 0.22
    private let mainStoryboardID: String = "MainTabBarController" // set this on your real root
    // ============================

    private var typingTimer: Timer?
    private var currentIndex: Int = 0

    // Loading UI layers / views
    private var circleLayer: CAShapeLayer?
    private var bgCircleLayer: CAShapeLayer?
    private var leafImageView: UIImageView?
    private var loaderContainer: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        logoLabel?.text = ""
        logoLabel?.alpha = 1.0
        view.alpha = 1.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTyping()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidateTypingTimer()
        removeLoadingUI()
    }

    // MARK: - Typing

    private func startTyping() {
        invalidateTypingTimer()
        currentIndex = 0
        logoLabel?.text = ""
        typingTimer = Timer.scheduledTimer(withTimeInterval: typingInterval, repeats: true) { [weak self] _ in
            self?.typeNextCharacter()
        }
    }

    private func invalidateTypingTimer() {
        typingTimer?.invalidate()
        typingTimer = nil
    }

    private func typeNextCharacter() {
        guard currentIndex < fullText.count else {
            invalidateTypingTimer()
            DispatchQueue.main.asyncAfter(deadline: .now() + pauseAfterTyping) { [weak self] in
                self?.startLeafCircleLoading()
            }
            return
        }

        let nextIndex = fullText.index(fullText.startIndex, offsetBy: currentIndex)
        let nextChar = String(fullText[nextIndex])
        logoLabel?.text = (logoLabel?.text ?? "") + nextChar
        currentIndex += 1
    }

    // MARK: - Loading UI (green filled circle + leaf rolling)

    private func startLeafCircleLoading() {
        // show the loader under the label (or below it)
        showLeafLoadingUI()

        // start animations (stroke anim + leaf along path)
        startCircleFillAnimation(duration: loadingDuration)
    }

    private func showLeafLoadingUI() {
        guard loaderContainer == nil, let label = logoLabel else { return }

        // container to hold loader layers and leaf image
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        view.addSubview(container)

        // place container below label
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            container.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 14),
            container.widthAnchor.constraint(equalToConstant: 64),
            container.heightAnchor.constraint(equalToConstant: 64)
        ])

        loaderContainer = container

        // Create circular path
        let size = CGSize(width: 64, height: 64)
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let radius = min(size.width, size.height) / 2.0 - 6.0
        let startAngle = -CGFloat.pi / 2.0
        let endAngle = startAngle + 2.0 * CGFloat.pi
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)

        // Background track circle (light green)
        let bg = CAShapeLayer()
        bg.path = circlePath.cgPath
        bg.strokeColor = UIColor.systemGreen.withAlphaComponent(0.20).cgColor
        bg.fillColor = UIColor.clear.cgColor
        bg.lineWidth = 6.0
        bg.lineCap = .round
        bg.frame = CGRect(origin: .zero, size: size)
        container.layer.addSublayer(bg)
        bgCircleLayer = bg

        // Foreground stroke circle (animates strokeEnd)
        let stroke = CAShapeLayer()
        stroke.path = circlePath.cgPath
        stroke.strokeColor = UIColor.systemGreen.cgColor   // solid green stroke
        stroke.fillColor = UIColor.clear.cgColor
        stroke.lineWidth = 6.0
        stroke.lineCap = .round
        stroke.strokeEnd = 0.0
        stroke.frame = CGRect(origin: .zero, size: size)
        container.layer.addSublayer(stroke)
        circleLayer = stroke

        // Leaf image - placed initially at start of arc.
        let leafSize: CGFloat = 22.0
        let leaf = UIImageView(image: UIImage(named: "leaf"))
        leaf.contentMode = .scaleAspectFit
        leaf.frame = CGRect(x: 0, y: 0, width: leafSize, height: leafSize)
        // position at arc start (convert arc point)
        let startPoint = CGPoint(x: center.x + radius * cos(startAngle), y: center.y + radius * sin(startAngle))
        leaf.center = startPoint
        
        container.addSubview(leaf)
        leafImageView = leaf
    }

    private func startCircleFillAnimation(duration: TimeInterval) {
        guard let stroke = circleLayer,
              let container = loaderContainer,
              let label = logoLabel else {
            // fallback: perform simple fade
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.animateFadeAndPresentMain()
            }
            return
        }

        // Create strokeEnd animation (progress visually)
        let strokeAnim = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnim.fromValue = 0.0
        strokeAnim.toValue = 1.0
        strokeAnim.duration = duration
        strokeAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeAnim.fillMode = .forwards
        strokeAnim.isRemovedOnCompletion = false

        // Create leaf path animation (leaf travels around the same circular path)
        // Build the UIBezierPath with global coordinates relative to container's superlayer (container)
        let size = container.bounds.size
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let radius = min(size.width, size.height) / 2.0 - 6.0
        let startAngle = -CGFloat.pi / 2.0
        let endAngle = startAngle + 2.0 * CGFloat.pi
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        let leafAnim = CAKeyframeAnimation(keyPath: "position")
        leafAnim.path = path.cgPath
        leafAnim.duration = duration
        leafAnim.calculationMode = .paced
        leafAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        // rotate leaf to path direction
        leafAnim.rotationMode = .rotateAuto

        // Group transaction to detect completion
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            guard let self = self else { return }
            // fill the circle with green (small animation) to indicate completion
            self.fillCircleThenFinish()
        }

        stroke.add(strokeAnim, forKey: "strokeEnd")
        if let leaf = leafImageView {
            leaf.layer.add(leafAnim, forKey: "leafRoll")
        }

        CATransaction.commit()
    }

    private func fillCircleThenFinish() {
        // Animate a quick fill color for the stroke circle (so it looks "fully covered")
        guard let stroke = circleLayer else {
            // fallback
            animateFadeAndPresentMain()
            return
        }

        // Add a fill layer under stroke to animate fill
        let fillAnim = CABasicAnimation(keyPath: "fillColor")
        fillAnim.fromValue = UIColor.clear.cgColor
        fillAnim.toValue = UIColor.systemGreen.cgColor
        fillAnim.duration = 0.18
        fillAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        fillAnim.fillMode = .forwards
        fillAnim.isRemovedOnCompletion = false

        stroke.add(fillAnim, forKey: "fillColorAnim")
        // also set the final value so the model layer reflects it
        stroke.fillColor = UIColor.systemGreen.cgColor

        // small delay to let the fill be visible, then transition
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) { [weak self] in
            self?.animateFadeAndPresentMain()
        }
    }

    private func removeLoadingUI() {
        // clean layers and views
        circleLayer?.removeAllAnimations()
        circleLayer?.removeFromSuperlayer()
        circleLayer = nil

        bgCircleLayer?.removeAllAnimations()
        bgCircleLayer?.removeFromSuperlayer()
        bgCircleLayer = nil

        leafImageView?.layer.removeAllAnimations()
        leafImageView?.removeFromSuperview()
        leafImageView = nil

        loaderContainer?.removeFromSuperview()
        loaderContainer = nil
    }

    // MARK: - Transition

    private func animateFadeAndPresentMain() {
        // fade out splash view (label + loader) then present main without animation to avoid flashes
        UIView.animate(withDuration: fadeDuration, animations: {
            self.logoLabel?.alpha = 0.0
            self.loaderContainer?.alpha = 0.0
            self.view.alpha = 0.0
        }, completion: { _ in
            self.presentMainFullScreen()
        })
    }

    private func presentMainFullScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // instantiate the controller by ID (preferred)
        let mainRoot: UIViewController?
        if let vc = storyboard.instantiateViewController(withIdentifier: mainStoryboardID) as? UITabBarController {
            mainRoot = vc
        } else {
            mainRoot = storyboard.instantiateInitialViewController()
        }

        guard let root = mainRoot else {
            print("❌ Splash: could not instantiate main root. Check storyboard ID '\(mainStoryboardID)'.")
            return
        }

        // ensure background matches to avoid any flash
        root.loadViewIfNeeded()
        if root.view.backgroundColor == nil {
            root.view.backgroundColor = .systemBackground
        }

        root.modalPresentationStyle = .fullScreen
        // present without animation (we already did the fade)
        self.present(root, animated: false) {
            // cleanup splash resources
            self.removeLoadingUI()
        }
    }
}
