//
//  MockHelper.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 20/04/22.
//

import Foundation

class Helper {
    static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJjbGltYXgtbXF0dC1hcGkiLCJsb2dnaW4iOnsidXNlcklkIjoxMjI5MCwiaWQiOiJ6ZW5vcHJvbWF4IiwibWFjIjoiMDA6MWQ6OTQ6MTI6NDc6YzEiLCJtYXN0ZXIiOjEsImFnZW50IjpmYWxzZSwiaGEiOmZhbHNlLCJ4bWxWZXJzaW9uIjozLCJpc0luc3RhbGxlciI6ZmFsc2V9LCJpYXQiOjE2NTAzNjg0Nzl9.1wGfjbVSfAQtNcC2ZTNtinx1L_OyL_6Z1Y1oCi3jZtY"
    
    // MARK: - Login
    
    static func loginJSONWithValidData(result: Bool) -> Data {
        let data = """
            {
              "data" : {
                "mac" : "00:1d:94:12:47:c1",
                "id" : "zenopromax",
                        },
              "panelCode" : "",
              "result" : \(result),
              "message" : "OK!",
              "token" : "\(Helper.token)",
              "code" : "000"
            }
            """.data(using: .utf8)!
        return data
    }
    
    static func loginJSONWithNotValidData(result: Bool) -> Data {
        let data = """
            {
              "data" : "",
              "panelCode" : "",
              "result" : \(result),
              "message" : "OK!",
              "token" : "\(Helper.token)",
              "code" : "000"
            }
            """.data(using: .utf8)!

        return data
    }
    
    // MARK: - Get Panel Mode
    
    static func getPanelModeJSONWithValidData(result: Bool, isBurglar: Bool = true) -> Data {
        let data = """
        {
          "data" : [
            {
              "area_name" : "",
              "area" : "1",
              "mode" : "home_2",
              "burglar" : \(isBurglar)
            }
          ],
          "message" : "OK!",
          "panelCode" : "",
          "result" : \(result),
          "code" : "000",
          "token" : "\(Helper.token)"
        }
        """.data(using: .utf8)!
        return data
    }

    static func getPanelModeJSONWithInvalidData(result: Bool) -> Data {
        let data = """
        {
          "data" : "",
          "message" : "OK!",
          "panelCode" : "",
          "result" : \(result),
          "code" : "000",
          "token" : "\(Helper.token)"
        }
        """.data(using: .utf8)!
        return data
    }

    // MARK: - Set Panel Mode
    
    static func setPanelModeJSONWithBypass1() -> Data {
        let data = """
        {
          "panelCode" : "",
          "code" : "000",
          "message" : "OK!",
          "result" : true,
          "data" : "",
          "token" : "\(Helper.token)"
        }
        """.data(using: .utf8)!
        return data
    }
    
    static func setPanelModeJSONWithBypass0() -> Data {
        let data = """
        {
          "token" : "",
          "message" : "a=0&z=0&c=6;a=0&z=0&c=8;a=0&z=0&c=2;a=1&z=2&c=14",
          "result" : false,
          "data" : [
            {
              "fault" : "Batteria assente o scarica"
            },
            {
              "fault" : "No SIM Card"
            },
            {
              "fault" : "No Segnale GSM"
            },
            {
              "fault" : "Tamper",
              "area" : "1",
              "zone" : "2",
              "device_id" : "RF:065bfd10",
              "type_no" : "4",
              "type" : "device_type.door_contact",
              "name" : "Bagno1"
            }
          ],
          "code" : "996",
          "panelCode" : "29"
        }
        """.data(using: .utf8)!
        return data
    }
    
    // MARK: - Get Panel Device

    static func getPanelDeviceJSONWithDevicesPresent() -> Data {
        let data = """
        {
          "panelCode" : "",
          "message" : "OK!",
          "token" : "\(Helper.token)",
          "code" : "000",
          "result" : true,
          "data" : [
            {
              "group_id" : "",
              "stwo_way_on" : "0",
              "status_pm2_5_aqi" : "",
              "sresp_mode_1" : "0",
              "no" : "1",
              "tamper_bypass" : "",
              "status_temp_format" : "C",
              "thermo_mode" : "",
              "stype_set_unset" : "0",
              "status_total_energy" : "",
              "trigger_by_zone" : [

              ],
              "device_id2" : "",
              "tag" : "",
              "mac" : "00:1d:94:12:47:c1",
              "sresp_arm" : "0",
              "xml_version" : "3",
              "status_aqs_country_code" : "TW",
              "schar_set_unset" : "0",
              "device_group" : "000",
              "schar_whole_area" : "0",
              "scond_bypass" : "0",
              "status_power" : "",
              "cap" : "",
              "status1" : "",
              "device_id" : "RF:06bf3c00",
              "sresp_button_3" : "",
              "ble_pulse" : "",
              "thermo_schd_setting" : "",
              "schar_latch_rpt" : "1",
              "sresp_exit_3" : "0",
              "bind_device_tag" : "",
              "type_no" : "31",
              "thermo_setpoint_away" : "",
              "bypass" : "0",
              "sresp_home" : "0",
              "rssi" : "-1",
              "sresp_entry_4" : "0",
              "sresp_disarm" : "0",
              "thermo_c_setpoint_away" : "",
              "sresp_switch_off" : "0",
              "thermo_remote" : "",
              "thermo_offset" : "",
              "sresp_exit_1" : "0",
              "sresp_medical" : "7",
              "status_open" : [

              ],
              "sresp_tag_disarm" : "",
              "dahua" : {

              },
              "name" : "",
              "area_name" : "",
              "room_name" : "",
              "thermo_setpoint_energy" : "",
              "thermo_setpoint" : "",
              "status_pm2_5_ug_m3_level" : "",
              "sresp_entry_3" : "0",
              "status_motion" : "",
              "sresp_mode_4" : "0",
              "status_dim_level" : "",
              "sresp_switch_on" : "0",
              "sresp_button_2" : "",
              "status_temp" : "",
              "device_category" : "All",
              "hikvision" : {

              },
              "status_humi" : "",
              "is_cloud_registered" : "0",
              "sresp_trigger" : "0",
              "status_lux" : "",
              "sresp_entry_2" : "0",
              "sresp_mode_2" : "0",
              "sresp_fire" : "12",
              "group_name" : "",
              "sresp_panic" : "10",
              "status_switch" : "device_status.off",
              "ver" : "",
              "area" : "1",
              "sresp_mode_0" : "0",
              "sresp_entry_1" : "0",
              "status_pm2_5_ug_m3" : "",
              "sresp_button_1" : "",
              "attr" : "",
              "xdl_no" : "166",
              "sresp_exit_4" : "0",
              "sresp_entry_0" : "0",
              "mpid" : "",
              "schar_final_door" : "",
              "sresp_24hr" : "0",
              "thermo_fan_mode" : "",
              "status_co2" : "",
              "sresp_emergency" : "11",
              "xcmd_switch_on_pd" : "0",
              "stwo_way_on_cb" : "",
              "status_hue" : "",
              "ble_systolic" : "",
              "status_fault" : [

              ],
              "sresp_exit_2" : "0",
              "schar_always_on" : "0",
              "temp_bypass" : "0",
              "extension" : "",
              "latch" : "1",
              "st" : "0x0",
              "type" : "device_type.remote_controller",
              "schar_24hr" : "0",
              "su" : "0",
              "sresp_restore" : "0",
              "sresp_exit_0" : "0",
              "room_id" : "",
              "saanet_device" : "",
              "attrExtra" : "",
              "record_time" : "",
              "sresp_mode_3" : "0",
              "status_saturation" : "",
              "sresp_button_4" : "",
              "thermo_c_setpoint" : "",
              "status_co2_level" : "",
              "ble_daisolic" : "",
              "saanet_status" : "",
              "home_arm" : "0"
            },
            {
              "group_id" : "",
              "stwo_way_on" : "0",
              "status_pm2_5_aqi" : "",
              "sresp_mode_1" : "5",
              "no" : "2",
              "tamper_bypass" : "",
              "status_temp_format" : "C",
              "thermo_mode" : "",
              "stype_set_unset" : "0",
              "status_total_energy" : "",
              "trigger_by_zone" : [

              ],
              "device_id2" : "",
              "tag" : "",
              "mac" : "00:1d:94:12:47:c1",
              "sresp_arm" : "0",
              "xml_version" : "3",
              "status_aqs_country_code" : "TW",
              "schar_set_unset" : "0",
              "device_group" : "000",
              "schar_whole_area" : "0",
              "scond_bypass" : "0",
              "status_power" : "",
              "cap" : "",
              "status1" : "device_status.dc_close",
              "device_id" : "RF:065bfd10",
              "sresp_button_3" : "",
              "ble_pulse" : "",
              "thermo_schd_setting" : "",
              "schar_latch_rpt" : "1",
              "sresp_exit_3" : "0",
              "bind_device_tag" : "",
              "type_no" : "4",
              "thermo_setpoint_away" : "",
              "bypass" : "0",
              "sresp_home" : "0",
              "rssi" : "9",
              "sresp_entry_4" : "0",
              "sresp_disarm" : "0",
              "thermo_c_setpoint_away" : "",
              "sresp_switch_off" : "0",
              "thermo_remote" : "",
              "thermo_offset" : "",
              "sresp_exit_1" : "0",
              "sresp_medical" : "7",
              "status_open" : [
                "device_status.dc_close"
              ],
              "sresp_tag_disarm" : "",
              "dahua" : {

              },
              "name" : "Bagno1",
              "area_name" : "",
              "room_name" : "",
              "thermo_setpoint_energy" : "",
              "thermo_setpoint" : "",
              "status_pm2_5_ug_m3_level" : "",
              "sresp_entry_3" : "0",
              "status_motion" : "",
              "sresp_mode_4" : "0",
              "status_dim_level" : "",
              "sresp_switch_on" : "0",
              "sresp_button_2" : "",
              "status_temp" : "",
              "device_category" : "All",
              "hikvision" : {

              },
              "status_humi" : "",
              "is_cloud_registered" : "0",
              "sresp_trigger" : "0",
              "status_lux" : "",
              "sresp_entry_2" : "5",
              "sresp_mode_2" : "5",
              "sresp_fire" : "12",
              "group_name" : "",
              "sresp_panic" : "10",
              "status_switch" : "device_status.off",
              "ver" : "",
              "area" : "1",
              "sresp_mode_0" : "3",
              "sresp_entry_1" : "5",
              "status_pm2_5_ug_m3" : "",
              "sresp_button_1" : "",
              "attr" : "device_attribute.null",
              "xdl_no" : "167",
              "sresp_exit_4" : "0",
              "sresp_entry_0" : "3",
              "mpid" : "",
              "schar_final_door" : "",
              "sresp_24hr" : "0",
              "thermo_fan_mode" : "",
              "status_co2" : "",
              "sresp_emergency" : "11",
              "xcmd_switch_on_pd" : "0",
              "stwo_way_on_cb" : "",
              "status_hue" : "",
              "ble_systolic" : "",
              "status_fault" : [

              ],
              "sresp_exit_2" : "0",
              "schar_always_on" : "0",
              "temp_bypass" : "0",
              "extension" : {
                "dc" : {
                  "sattr_count_1" : "",
                  "sattr_count_7" : "",
                  "sattr_sche_t_6" : "",
                  "sattr_count_6" : "",
                  "sattr_sche_t_3" : "",
                  "sattr_sche_f_5" : "",
                  "sattr_count_5" : "",
                  "sattr_sche_f_2" : "",
                  "sattr_sche_t_5" : "",
                  "sattr_sche_f_7" : "",
                  "sattr_zone_delay" : "",
                  "sattr_count_4" : "",
                  "sattr_sche_t_2" : "",
                  "sattr_sche_f_4" : "",
                  "sattr_count_3" : "",
                  "sattr_sche_f_1" : "",
                  "sattr_sche_t_7" : "",
                  "sattr_zone" : "",
                  "sattr_count_2" : "",
                  "sattr_sche_t_4" : "",
                  "sattr_sche_f_6" : "",
                  "sattr_sche_t_1" : "",
                  "sattr_sche_f_3" : ""
                }
              },
              "latch" : "1",
              "st" : "0x0",
              "type" : "device_type.door_contact",
              "schar_24hr" : "0",
              "su" : "1",
              "sresp_restore" : "0",
              "sresp_exit_0" : "0",
              "room_id" : "",
              "saanet_device" : "",
              "record_time" : "",
              "sresp_mode_3" : "0",
              "status_saturation" : "",
              "sresp_button_4" : "",
              "thermo_c_setpoint" : "",
              "status_co2_level" : "",
              "ble_daisolic" : "",
              "saanet_status" : "",
              "home_arm" : ""
            },
            {
              "group_id" : "",
              "stwo_way_on" : "0",
              "status_pm2_5_aqi" : "",
              "sresp_mode_1" : "5",
              "no" : "3",
              "tamper_bypass" : "",
              "status_temp_format" : "C",
              "thermo_mode" : "",
              "stype_set_unset" : "0",
              "status_total_energy" : "",
              "trigger_by_zone" : [

              ],
              "device_id2" : "",
              "tag" : "",
              "mac" : "00:1d:94:12:47:c1",
              "sresp_arm" : "0",
              "xml_version" : "3",
              "status_aqs_country_code" : "TW",
              "schar_set_unset" : "0",
              "device_group" : "000",
              "schar_whole_area" : "0",
              "scond_bypass" : "0",
              "status_power" : "",
              "cap" : "",
              "status1" : "",
              "device_id" : "RF:06409730",
              "sresp_button_3" : "",
              "ble_pulse" : "",
              "thermo_schd_setting" : "",
              "schar_latch_rpt" : "0",
              "sresp_exit_3" : "0",
              "bind_device_tag" : "",
              "type_no" : "9",
              "thermo_setpoint_away" : "",
              "bypass" : "0",
              "sresp_home" : "0",
              "rssi" : "9",
              "sresp_entry_4" : "0",
              "sresp_disarm" : "0",
              "thermo_c_setpoint_away" : "",
              "sresp_switch_off" : "0",
              "thermo_remote" : "",
              "thermo_offset" : "",
              "sresp_exit_1" : "0",
              "sresp_medical" : "7",
              "status_open" : [

              ],
              "sresp_tag_disarm" : "",
              "dahua" : {

              },
              "name" : "Cam.letto",
              "area_name" : "",
              "room_name" : "",
              "thermo_setpoint_energy" : "",
              "thermo_setpoint" : "",
              "status_pm2_5_ug_m3_level" : "",
              "sresp_entry_3" : "0",
              "status_motion" : "1",
              "sresp_mode_4" : "0",
              "status_dim_level" : "",
              "sresp_switch_on" : "0",
              "sresp_button_2" : "",
              "status_temp" : "",
              "device_category" : "All",
              "hikvision" : {

              },
              "status_humi" : "",
              "is_cloud_registered" : "0",
              "sresp_trigger" : "0",
              "status_lux" : "",
              "sresp_entry_2" : "0",
              "sresp_mode_2" : "0",
              "sresp_fire" : "12",
              "group_name" : "",
              "sresp_panic" : "10",
              "status_switch" : "device_status.off",
              "ver" : "",
              "area" : "1",
              "sresp_mode_0" : "0",
              "sresp_entry_1" : "5",
              "status_pm2_5_ug_m3" : "",
              "sresp_button_1" : "",
              "attr" : "device_attribute.null",
              "xdl_no" : "168",
              "sresp_exit_4" : "0",
              "sresp_entry_0" : "0",
              "mpid" : "",
              "schar_final_door" : "",
              "sresp_24hr" : "0",
              "thermo_fan_mode" : "",
              "status_co2" : "",
              "sresp_emergency" : "11",
              "xcmd_switch_on_pd" : "0",
              "stwo_way_on_cb" : "",
              "status_hue" : "",
              "ble_systolic" : "",
              "status_fault" : [

              ],
              "sresp_exit_2" : "0",
              "schar_always_on" : "0",
              "temp_bypass" : "0",
              "extension" : {
                "ir" : {
                  "sattr_count_1" : "",
                  "sattr_count_7" : "",
                  "sattr_sche_t_6" : "",
                  "sattr_count_6" : "",
                  "sattr_sche_t_3" : "",
                  "sattr_sche_f_5" : "",
                  "sattr_count_5" : "",
                  "sattr_sche_f_2" : "",
                  "sattr_sche_t_5" : "",
                  "sattr_sche_f_7" : "",
                  "sattr_zone_delay" : "",
                  "sattr_count_4" : "",
                  "sattr_sche_t_2" : "",
                  "sattr_sche_f_4" : "",
                  "sattr_count_3" : "",
                  "sattr_sche_f_1" : "",
                  "sattr_sche_t_7" : "",
                  "sattr_zone" : "",
                  "sattr_count_2" : "",
                  "sattr_sche_t_4" : "",
                  "sattr_sche_f_6" : "",
                  "sattr_sche_t_1" : "",
                  "sattr_sche_f_3" : ""
                }
              },
              "latch" : "0",
              "st" : "0x0",
              "type" : "device_type.pir",
              "schar_24hr" : "0",
              "su" : "1",
              "sresp_restore" : "0",
              "sresp_exit_0" : "0",
              "room_id" : "",
              "saanet_device" : "",
              "record_time" : "",
              "sresp_mode_3" : "5",
              "status_saturation" : "",
              "sresp_button_4" : "",
              "thermo_c_setpoint" : "",
              "status_co2_level" : "",
              "ble_daisolic" : "",
              "saanet_status" : "",
              "home_arm" : ""
            }
          ]
        }
        """.data(using: .utf8)!
        return data
    }

    static func getPanelDeviceJSONWithoutDevices() -> Data {
        let data = """
        {
          "panelCode" : "",
          "message" : "OK!",
          "token" : "\(Helper.token)",
          "code" : "000",
          "result" : true,
          "data" : ""
        }
        """.data(using: .utf8)!
        return data
    }
    
    // MARK: - Get Event
    
    static func getEventJSONWithEvents() -> Data {
        let data = """
        {
          "token" : "\(Helper.token)",
          "data" : [
            {
              "id" : "22664665",
              "event_type" : "1401",
              "error_trans" : "",
              "read" : false,
              "user_trans" : "user",
              "cid_source" : "USER",
              "capture_id" : "",
              "area" : "1",
              "type" : "mode_type.disarm",
              "time" : "2022/04/20 11:49:07",
              "longitude" : "",
              "is_alarm" : false,
              "latitude" : "",
              "cid_trans" : "Disattivazione remota",
              "area_trans" : "",
              "base_id" : ""
            },
            {
              "id" : "22664655",
              "event_type" : "3401",
              "error_trans" : "",
              "read" : false,
              "user_trans" : "user",
              "cid_source" : "USER",
              "capture_id" : "",
              "area" : "1",
              "type" : "mode_type.arm",
              "time" : "2022/04/20 11:48:53",
              "longitude" : "",
              "is_alarm" : false,
              "latitude" : "",
              "cid_trans" : "Attivazione remota",
              "area_trans" : "",
              "base_id" : ""
            }
          ],
          "message" : "OK!",
          "result" : true,
          "code" : "000",
          "panelCode" : ""
        }
        """.data(using: .utf8)!
        return data
    }

    static func getEventJSONWithoutEvents() -> Data {
        let data = """
        {
          "token" : "\(Helper.token)",
          "data" : "",
          "message" : "OK!",
          "result" : true,
          "code" : "000",
          "panelCode" : ""
        }
        """.data(using: .utf8)!
        return data
    }
    
    // MARK: - Get Fault Dashboard
    
    static func getFaultDashboardWithFaults() -> Data {
        let data = """
        {
          "result" : true,
          "code" : "000",
          "data" : {
            "panel" : {
              "detail" : [
                "Batteria assente o scarica",
                "No SIM Card",
                "No Segnale GSM"
              ],
              "fault_quantity" : "3"
            },
            "device" : {
              "detail" : [
                "Tamper: 1"
              ],
              "fault_quantity" : "1",
              "total" : "3"
            },
            "dc" : {
              "detail" : [

              ],
              "fault_quantity" : "0",
              "total" : "1"
            }
          },
          "panelCode" : "",
          "message" : "OK!",
          "token" : "\(Helper.token)"
        }
        """.data(using: .utf8)!
        return data
    }

    static func getFaultDashboardWithoutFaults() -> Data {
        let data = """
        {
          "result" : true,
          "code" : "000",
          "data" : {
            "panel" : {
              "detail" : [],
              "fault_quantity" : "0"
            },
            "device" : {
              "detail" : [],
              "fault_quantity" : "",
              "total" : "3"
            },
            "dc" : {
              "detail" : [],
              "fault_quantity" : "0",
              "total" : "1"
            }
          },
          "panelCode" : "",
          "message" : "OK!",
          "token" : "\(Helper.token)"
        }
        """.data(using: .utf8)!
        return data
    }
}
