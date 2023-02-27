//
//  ChartVC.swift
//  AME_Boss_App
//
//  Created by MOHAMMED ABDUL BASITHK on 15/02/22.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//

import UIKit
import Charts

class ChartVC: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var myChart: PieChartView!
    
    var titleString : String = ""
    
    var stringArray = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira"]
    var numberArray : [Double] = [6, 8, 26, 30, 8, 10]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeChart(dataPoints: stringArray, values: numberArray.map{ Double($0) })
        self.headingLabel.text = titleString
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        var total : Double = 0
        
        for item in numberArray {
            total = total + item
        }
        
        for i in 0..<dataPoints.count {
            var myDouble : Double = (values[i] / total) * 100
            myDouble = myDouble.roundToDecimal(2)
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i] + " (\(myDouble) %)", data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        pieChartDataSet.drawValuesEnabled = false
        myChart.legend.horizontalAlignment = .center
        myChart.drawEntryLabelsEnabled = false
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        myChart.data = pieChartData
        myChart.usePercentValuesEnabled = true
        myChart.legend.orientation = .vertical
        myChart.legend.horizontalAlignment = .left
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
