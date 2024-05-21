import XCTest
@testable import CurvedBezierSlider

final class CurvedBezierSliderTests: XCTestCase {

    var testSliderView = CurvedBezierSlider()
    var testPathView = PathView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        testSliderView = CurvedBezierSlider()
    }
    
    func testAngleToRadians() throws {
        let angleZero: CGFloat = 0.0
        let angleHalf: CGFloat = 180.0
        
        XCTAssertEqual(angleZero.toRadians(), angleZero * CGFloat(Double.pi) / 180.0)
        XCTAssertEqual(angleHalf.toRadians(), angleHalf * CGFloat(Double.pi) / 180.0)
    }
    
    func testPinnedMaximumValue() throws {
        testSliderView.minimumValue = 0
        testSliderView.maximumValue = 2
        testSliderView.value = 3
        
        XCTAssertEqual(testSliderView.maximumValue, testSliderView.value)
    }
    
    func testPinnedMinimumValue() throws {
        testSliderView.minimumValue = 5
        testSliderView.maximumValue = 10
        testSliderView.value = 1
        
        XCTAssertEqual(testSliderView.minimumValue, testSliderView.value)
    }
    
    func testValueToPercentCalculations() throws {
        testSliderView.minimumValue = 0
        testSliderView.maximumValue = 10
        testSliderView.value = 5
        
        let scaledValue = testPathView.getScaledValueToPercent(value: testSliderView.value,
                                                                          minValue: testSliderView.minimumValue,
                                                                          maxValue: testSliderView.maximumValue)
        XCTAssertEqual(scaledValue, 0.5)
    }
    
    func testValueFromPercentCalculations() throws {
        testSliderView.minimumValue = 0
        testSliderView.maximumValue = 10
        let percent = 0.5
        
        let scaledValue = testPathView.getScaledValueFromPercent(percent: percent,
                                                                          minValue: testSliderView.minimumValue,
                                                                          maxValue: testSliderView.maximumValue)
        XCTAssertEqual(scaledValue, 5.0)
    }
    
    func testGetPersentForAngle() throws {
        let sliderPath = SemiCirclePath(bounds: CGRect(x: 0, y: 0, width: 100, height: 100), strokeWidth: 4, isFlipped: true)
        
        XCTAssertEqual(sliderPath.getPercentForAngel(angle: 0), 1.0)
    }
    
}
