//
//  Utils.swift
//  VeriVoice
//
//  Created by Raza Ali on 27/06/2020.
//  Copyright © 2020 Raza Ali. All rights reserved.
//

import Foundation

class AppUtils {
   
 class func savetoUserDefaults(value: String, key: String) {
      let def = UserDefaults.standard
      def.setValue(value, forKey: key)
      def.synchronize()
  }

  class func savetoUserDefaultsInt(value: Int, key: String) {
      let def = UserDefaults.standard
      def.setValue(value, forKey: key)
      def.synchronize()
  }
  class func getValueFromUserDefaults(key: String) -> String? {
      let def = UserDefaults.standard
      return def.object(forKey: key) as? String
  }

  class func getValueFromUserDefaultsInt(key: String) -> Int? {
      let def = UserDefaults.standard
      return def.integer(forKey: key)
  }
  class func removeValueFromUserDefaults(Key: String) {
      let def = UserDefaults.standard
      def.removeObject(forKey: Key)
      def.synchronize()
  }
}
