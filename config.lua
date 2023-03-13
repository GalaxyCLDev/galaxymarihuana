Galaxy_Marihuana_Plantada = {}
local GMP = Galaxy_Marihuana_Plantada
ESX = exports["es_extended"]:getSharedObject()

ESX = exports["es_extended"]:getSharedObject()

GMP.FoodDrainSpeed      = 0.0200
GMP.WaterDrainSpeed     = 0.0200
GMP.QualityDrainSpeed   = 0.0050

GMP.GrowthGainSpeed     = 0.0810
GMP.QualityGainSpeed    = 0.0100

GMP.SyncDist = 50.0
GMP.InteractDist = 2.5
GMP.PoliceJobLabel = "LSPD"
GMP.WeedPerBag = 8
GMP.JointsPerBag = 10
GMP.BagsPerPapers = 1

GMP.PlantTemplate = {
   ["Gender"] = "Female",
  ["Quality"] = 0.0,
   ["Growth"] = 0.0,
    ["Water"] = 20.0,
     ["Food"] = 20.0,
    ["Stage"] = 1,
}

GMP.ItemTemplate = {
     ["Type"] = "Water",
  ["Quality"] = 0.0,
}

GMP.Objects = {
  [1] = "bkr_prop_weed_01_small_01c",
  [2] = "bkr_prop_weed_01_small_01b",
  [3] = "bkr_prop_weed_01_small_01a",
  [4] = "bkr_prop_weed_med_01a",
  [5] = "bkr_prop_weed_med_01b",
  [6] = "bkr_prop_weed_lrg_01a",
  [7] = "bkr_prop_weed_lrg_01b",
}