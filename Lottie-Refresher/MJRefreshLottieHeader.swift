//
//  MJRefreshLottieHeader.swift
//  Adorbee
//
//  Created by amovision on 2025/7/3.
//

import MJRefresh
import Lottie

class MJRefreshLottieHeader: MJRefreshStateHeader {
  
  private lazy var lottieView = {
    let v = LottieAnimationView()
    v.frame = CGRectMake(0, 0, mj_h, mj_h)
    addSubview(v)
    return v
  }()
  
  var animationResources: [MJRefreshState: String]! {
    didSet {
      animations = animationResources.compactMapValues {
        LottieAnimation.named($0)
      }
      lottieView.animation = animations[.pulling]
    }
  }
  
  private var animations = [MJRefreshState: LottieAnimation]()
  
  override func prepare() {
    super.prepare()
    stateLabel?.isHidden = true
    lastUpdatedTimeLabel?.isHidden = true
  }
  
  override var pullingPercent: CGFloat {
    didSet {
      super.pullingPercent = pullingPercent
      guard state == .idle else { return }
      lottieView.currentFrame = pullingPercent * (lottieView.animation?.endFrame ?? 0)
    }
  }
  
  override var state: MJRefreshState {
    didSet {
      guard state != oldValue else { return }
      super.state = state
      switch state {
      case .idle:
        lottieView.animation = animations[.pulling]
      case .refreshing:
        lottieView.animation = animations[.refreshing]
        lottieView.loopMode = .loop
        lottieView.play()
      default:
        break
      }
    }
  }
  
  override func placeSubviews() {
    super.placeSubviews()
    lottieView.center = CGPoint(x: mj_w * 0.5, y: mj_h * 0.5 + 10)
  }
  
  override func endRefreshing() {
    if state == .idle {
      super.endRefreshing();return
    }
    lottieView.stop()
    lottieView.animation = animations[.idle]
    let duration = lottieView.animation?.duration ?? 0
    DispatchQueue.main.asyncAfter(deadline: .now() + duration+0.1) {
      super.endRefreshing()
    }
    lottieView.loopMode = .playOnce
    lottieView.play()
  }
  
}
