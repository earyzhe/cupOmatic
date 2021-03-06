//
//  RoundOneViewController.swift
//  CupOmatic v2
//
//  Created by Andrew Johnson on 05.11.17.
//  Copyright © 2017 Rinson. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class RoundViewController {

    
    var dataBase = [[String]]()
    var minutes = ["0"]
    var minutesLabel = ["min"]
    var seconds = ["0"]
    var secondsLabel = ["sec"]
    var mins = 0
    var secs = 0
    var roundTimeSeconds = 0
    var selection: String = ""
    var minutesResult = 0
    var secondsResult = 0
    var navigationItemTitle = String()
    var round = String()
    var alarmTimeSetting = Int()
    var alarmSelection = Int()
    let listOfCodes = [1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1034, 1035, 1036, 1050, 1051, 1052, 1053, 1054, 1055, 1057, 1070, 1071, 1072, 1073, 1074, 1075, 1100, 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1114, 1115, 1116, 1117, 1118, 1150, 1151, 1152, 1153, 1154, 1200, 1201, 1202, 1203, 1204, 1205, 1206, 1207, 1208, 1209, 1210, 1211, 1254, 1255, 1256, 1257, 1258, 1259, 1300, 1301, 1302, 1303, 1304, 1305, 1306, 1307, 1308, 1309, 1310, 1311, 1312, 1313, 1314, 1315, 1320, 1321, 1322, 1323, 1324, 1325, 1326, 1327, 1328, 1329, 1330, 1331, 1332, 1333, 1334, 1335, 1336, 1350, 1351, 4095]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataBase.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataBase[component].count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataBase[component][row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(component)
        print(row)

        switch (component) {
        case 0:
            minutesResult = Int(dataBase[component][row])!
            print(minutesResult)

        case 2:
            secondsResult = Int(dataBase[component][row])!
            print(secondsResult)

        default:break

        }
        roundTimeSeconds = (minutesResult * 60) + secondsResult
        UserDefaults.standard.set(minutesResult, forKey: "round\(round)MinutesResultSave")
        UserDefaults.standard.set(secondsResult, forKey: "round\(round)ResultSave")
        UserDefaults.standard.set(roundTimeSeconds, forKey: "round\(round)SettingSave")
    }




    init(roundNumber: String, navigationItemTitle: String, viewController: ViewController, delegate: UIPickerViewDelegate, dataSource:UIPickerViewDataSource) {
        self.round = roundNumber
        self.navigationItemTitle = navigationItemTitle
    }


    func count() {

        var i = 0
        while (i < 59) {

            i += 1
            minutes.append(String(i))
            seconds.append(String(i))
        }
    }

    func updatePickerView(){

        dataBase.append(minutes)
        dataBase.append(minutesLabel)
        dataBase.append(seconds)
        dataBase.append(secondsLabel)
    }



}

