//
//  ContentView.swift
//  iBeacon
//
//  Created by 山河絵利奈 on 2024/08/23.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()
   
    var body: some View {
        VStack {
            Text("ビーコン探知")
                .padding()
            Text("現在の緯度：\(locationManager.location.coordinate.latitude.magnitude)")
            Text("現在の経度：\(locationManager.location.coordinate.longitude.magnitude)")
            if(locationManager.beacons.isEmpty){
                Text("ビーコンが見つかりません").padding()
            }else {
                Text("ビーコンを発見しました")
            }
            List(locationManager.beacons, id: \.self.uuid) { beacon in
                Text("推定距離：\(beacon.proximity.rawValue)")
                Text("信号強度：\(beacon.rssi)")
                Text("信頼度：\(beacon.accuracy)")
                Text("UUID：\(beacon.uuid)")
                Text("major：\(beacon.major)")
                Text("minor：\(beacon.minor)")
            }
            Button(action: {
                locationManager.startMonitoring()
            }) {
                 Text("サーチ開始")
               }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
