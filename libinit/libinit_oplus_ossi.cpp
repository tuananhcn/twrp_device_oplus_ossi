/*
 * Copyright (C) 2022-2026 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#include <android-base/logging.h>
#include <android-base/parseint.h>
#include <android-base/properties.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include <fs_mgr.h>
#include <unordered_map>

using android::base::GetProperty;
// using android::base::ParseInt;
using android::fs_mgr::GetKernelCmdline;

const std::unordered_map<int, std::string> kRegionSuffixMap = {
    {27,    "IN"},
    {55,    "RU"},
    {68,    "EEA"},
    {151,   ""},    // CN
    {161,   "NA"},
    {167,   ""},    // GLO
    {0,     ""},    // Default
};

struct ModelInfo {
    const char* brand;              // ro.product.brand
    const char* device;             // ro.product.device
    const char* manufacturer;       // ro.product.manufacturer
    const char* model;              // ro.product.model
    const char* base_name;          // ro.product.name  w/o region suffix
    const char* twversion;          // ro.twrp.device_version
};

const std::unordered_map<int, ModelInfo> kModelInfoMap = {
    // OnePlus 11 (CN)
    // {22811, {"OnePlus", "OP591BL1",  "OnePlus", "PHB110",  "PHB110",  "OnePlus_11_CN"}},
    // OnePlus 11 (IN/GLO) - CPH2447 India, CPH2449 Global
    // {22861, {"OnePlus", "OP594DL1",  "OnePlus", "CPH2449", "CPH2449", "OnePlus_11"}},
    // OnePlus Ace 2 Pro (CN)
    {22851, {"OnePlus", "OP5943L1",  "OnePlus", "PJA110",  "PJA110",  "OnePlus_Ace2_Pro"}},
    // OnePlus Ace 3 (CN)
    // {23801, {"OnePlus", "OP5CF9L1",  "OnePlus", "PJE110",  "PJE110",  "OnePlus_Ace3"}},
    // OnePlus 12R (IN/GLO) - CPH2585 India, CPH2609 Global
    // {23861, {"OnePlus", "OP5D35L1",  "OnePlus", "CPH2609", "CPH2609", "OnePlus_12R"}},
    // OnePlus Open (GLO)
    // {22899, {"OnePlus", "OP5973L1",  "OnePlus", "CPH2551", "CPH2551", "OnePlus_Open"}},
    // OPPO Find X6 Pro (CN)
    // {21131, {"OPPO",    "OP528BL1",  "OPPO",    "PGEM10",  "PGEM10",  "OPPO_Find_X6_Pro"}},
    // OPPO Find N3 (CN)
    // {22003, {"OPPO",    "OP55F3L1",  "OPPO",    "PHN110",  "PHN110",  "OPPO_Find_N3"}},
    // realme GT5 150W (CN)
    // {22635, {"realme",  "RE5C33",    "realme",  "RMX3820", "RMX3820", "Realme_GT5_150W"}},
    // realme GT5 240W (CN)
    // {23603, {"realme",  "RE5C33",    "realme",  "RMX3823", "RMX3823", "Realme_GT5_240W"}},
    // Default fallback: OnePlus Ace 2 Pro (PJA110)
    {0,     {"OnePlus", "OP5943L1",  "OnePlus", "PJA110",  "PJA110",  "OnePlus_Ace2_Pro"}},
};

/*
 * SetProperty does not allow updating read only properties and as a result
 * does not work for our use case. Write "OverrideProperty" to do practically
 * the same thing as "SetProperty" without this restriction.
 */
void OverrideProperty(const char* name, const char* value) {
    if (!name || !value) return;
    size_t valuelen = strlen(value);

    prop_info* pi = (prop_info*)__system_property_find(name);
    if (pi != nullptr) {
        __system_property_update(pi, value, valuelen);
    } else {
        __system_property_add(name, strlen(name), value, valuelen);
    }
}

void SetupModelProperties(const ModelInfo& info, const std::string& region) {
    std::string name = std::string(info.base_name) + region;
    struct PropPair {
        const char* key;
        const char* value;
    } props[] = {
        {"ro.product.brand",            info.brand},
        {"ro.product.device",           info.device},
        {"ro.product.manufacturer",     info.manufacturer},
        {"ro.product.model",            info.model},
        {"ro.product.name",             name.c_str()},
        {"ro.twrp.device_version",      info.twversion},
        {"ro.build.date.utc",           "0"},
    };
    for (const auto& p : props) {
        OverrideProperty(p.key, p.value);
    }
}

void vendor_load_properties() {
    std::string buf = "0";
    GetKernelCmdline("oplus_region", &buf);

    int region = 0;
    try {
        region = std::stoi(buf);
    } catch (...) {
        region = 0;
    }

    auto region_suffix_iter = kRegionSuffixMap.find(region);
    if (region_suffix_iter == kRegionSuffixMap.end()) {
        region_suffix_iter = kRegionSuffixMap.find(0);
    }
    std::string region_suffix = (region_suffix_iter != kRegionSuffixMap.end()) ? region_suffix_iter->second : "";

    std::string prjname_str = GetProperty("ro.boot.prjname", "22851");
    int prjname = 22851;
    try {
        prjname = std::stoi(prjname_str);
    } catch (...) {
        prjname = 22851;
    }

    auto model_info = kModelInfoMap.find(prjname);
    if (model_info == kModelInfoMap.end()) {
        model_info = kModelInfoMap.find(22851);
    }
    if (model_info == kModelInfoMap.end()) {
        model_info = kModelInfoMap.find(0);
    }

    if (model_info != kModelInfoMap.end()) {
        SetupModelProperties(model_info->second, region_suffix);
    }

    // Default safe props
    OverrideProperty("twrp.se.no_sb", "false");
}
