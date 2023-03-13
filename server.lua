RegisterNetEvent('Galaxy_Marihuana_Plantada:SyncPlant')
RegisterNetEvent('Galaxy_Marihuana_Plantada:RemovePlant')

local GMP = Galaxy_Marihuana_Plantada

function GMP:Awake(...)
  while not ESX do 
    Citizen.Wait(0); 
  end

  self:DSP(true);
  self.dS = true
  self:Start()
end

function GMP:DoLogin(src)  
  self:DSP(true);
end

function GMP:DSP(val) self.cS = val; end
function GMP:Start(...)
  self:Update();
end

function GMP:Update(...)
end

function GMP:SyncPlant(plant,delete)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  local identifier = xPlayer.getIdentifier()
  plant["Owner"] = identifier
  if delete then 
    if xPlayer.job.label ~= self.PoliceJobLabel then
      self:RewardPlayer(source, plant)
    end
  end
  self:PlantCheck(identifier,plant,delete) 
  TriggerClientEvent('Galaxy_Marihuana_Plantada:SyncPlant',-1,plant,delete)
end

function GMP:RewardPlayer(source,plant)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if not source or not plant then return; end
  if plant.Gender == "Male" then
    math.random();math.random();math.random();
    local r = math.random(1000,5000)
    if r < 3000 then
      if plant.Quality > 95 then
        xPlayer.addInventoryItem('highgrademaleseed', math.floor( math.random( math.floor(plant.Quality/2), math.floor(plant.Quality*1.5))/10))
      elseif plant.Quality > 80 then
        xPlayer.addInventoryItem('highgrademaleseed', math.floor( math.random( math.floor(plant.Quality/2), math.floor(plant.Quality*1.5))/20)) 
      else
        xPlayer.addInventoryItem('lowgrademaleseed', math.floor( math.random( math.floor(plant.Quality/2), math.floor(plant.Quality))/20))
      end
    else
      if plant.Quality > 95 then
        xPlayer.addInventoryItem('highgrademaleseed', math.floor( math.random( math.floor(plant.Quality/2),math.floor(plant.Quality*1.5))/10))
      elseif plant.Quality > 80 then
        xPlayer.addInventoryItem('highgrademaleseed', math.floor( math.random( math.floor(plant.Quality/2),math.floor(plant.Quality*1.5))/20))
      else
        xPlayer.addInventoryItem('lowgrademaleseed', math.floor( math.random( math.floor(plant.Quality/2),math.floor( plant.Quality ))/20 ))
      end
      xPlayer.addInventoryItem('lowgradefemaleseed', math.floor( math.random( math.floor(plant.Quality/2), math.floor( plant.Quality ))/20 ))
    end
  else
    if plant and plant.Quality and plant.Quality > 80 then
      xPlayer.addInventoryItem('trimmedweed', math.floor( math.random( math.floor(plant.Quality), math.floor(plant.Quality*2) ) ) )
    elseif plant.Quality then
      xPlayer.addInventoryItem('trimmedweed', math.floor( math.random( math.floor(plant.Quality/2), math.floor(plant.Quality) ) ) )
    end
  end
end

function GMP:PlantCheck(identifier, plant, delete)
  if not plant or not identifier then return; end
  local data = MySQL.Sync.fetchAll('SELECT * FROM dopeplants WHERE plantid=@plantid',{['@plantid'] = plant.PlantID})
  if not delete then
    if not data or not data[1] then  
      MySQL.Async.execute('INSERT INTO dopeplants (owner, plantid, plant) VALUES (@owner, @id, @plant)',{['@owner'] = identifier,['@id'] = plant.PlantID, ['@plant'] = json.encode(plant)})
    else
      MySQL.Sync.execute('UPDATE dopeplants SET plant=@plant WHERE plantid=@plantid',{['@plant'] = json.encode(plant),['@plantid'] = plant.PlantID})
    end
  else
    if data and data[1] then
      MySQL.Async.execute('DELETE FROM dopeplants WHERE plantid=@plantid', {['@plantid'] = plant.PlantID})
    end
  end
end

function GMP:GetLoginData(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  local data = MySQL.Sync.fetchAll('SELECT * FROM dopeplants WHERE owner=@owner',{['@owner'] = xPlayer.identifier})
  if not data or not data[1] then return false; end
  local aTab = {}
  for k = 1,#data,1 do
    local v = data[k]
    if v and v.plant then
      local data = json.decode(v.plant)
      table.insert(aTab,data)
    end
  end
  return aTab
end

function GMP:ItemTemplate()
  return {
       ["Type"] = "Water",
    ["Quality"] = 0.0,
  }
end

function GMP:PlantTemplate()
  return {
   ["Gender"] = "Female",
  ["Quality"] = 0.0,
   ["Growth"] = 0.0,
    ["Water"] = 20.0,
     ["Food"] = 20.0,
    ["Stage"] = 1,
  ["PlantID"] = math.random(math.random(999999,9999999),math.random(99999999,999999999))
  }
end

ESX.RegisterServerCallback('Galaxy_Marihuana_Plantada:GetLoginData', function(source,cb) cb(GMP:GetLoginData(source)); end)
ESX.RegisterServerCallback('Galaxy_Marihuana_Plantada:GetStartData', function(source,cb) while not GMP.dS do Citizen.Wait(0); end; cb(GMP.cS); end)
AddEventHandler('Galaxy_Marihuana_Plantada:SyncPlant', function(plant,delete) GMP:SyncPlant(plant,delete); end)
AddEventHandler('playerConnected', function(...) GMP:DoLogin(source); end)
Citizen.CreateThread(function(...) GMP:Awake(...); end)

-- Maintenance Items
ESX.RegisterUsableItem('wateringcan', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('wateringcan').count > 0 then 
    xPlayer.removeInventoryItem('wateringcan', 1)

    local template = GMP:ItemTemplate()
    template.Type = "Water"
    template.Quality = 0.1

    TriggerClientEvent('Galaxy_Marihuana_Plantada:UseItem',source,template)
  end
end)

ESX.RegisterUsableItem('purifiedwater', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('purifiedwater').count > 0 then 
    xPlayer.removeInventoryItem('purifiedwater', 1)

    local template = GMP:ItemTemplate()
    template.Type = "Water"
    template.Quality = 0.2

    TriggerClientEvent('Galaxy_Marihuana_Plantada:UseItem',source,template)
  end
end)

ESX.RegisterUsableItem('lowgradefert', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('lowgradefert').count > 0 then 
    xPlayer.removeInventoryItem('lowgradefert', 1)

    local template = GMP:ItemTemplate()
    template.Type = "Food"
    template.Quality = 0.1

    TriggerClientEvent('Galaxy_Marihuana_Plantada:UseItem',source,template)
  end
end)

ESX.RegisterUsableItem('highgradefert', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('highgradefert').count > 0 then 
    xPlayer.removeInventoryItem('highgradefert', 1)

    local template = GMP:ItemTemplate()
    template.Type = "Food"
    template.Quality = 0.2

    TriggerClientEvent('Galaxy_Marihuana_Plantada:UseItem',source,template)
  end
end)

-- Seed Items
ESX.RegisterUsableItem('lowgrademaleseed', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('lowgrademaleseed').count > 0 and xPlayer.getInventoryItem('plantpot').count > 0 then 
    xPlayer.removeInventoryItem('lowgrademaleseed', 1)
    xPlayer.removeInventoryItem('plantpot', 1)

    local template = GMP:PlantTemplate()
    template.Gender = "Male"
    template.Quality = math.random(1,100)/10
    template.Food =  math.random(100,200)/10
    template.Water = math.random(100,200)/10

    TriggerClientEvent('Galaxy_Marihuana_Plantada:UseSeed',source,template)
  end
end)

ESX.RegisterUsableItem('highgrademaleseed', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('highgrademaleseed').count > 0 and xPlayer.getInventoryItem('plantpot').count > 0 then
    xPlayer.removeInventoryItem('highgrademaleseed', 1)
    xPlayer.removeInventoryItem('plantpot', 1)

    local template = GMP:PlantTemplate()
    template.Gender = "Male"
    template.Quality = 0.2
    template.Quality = math.random(200,500)/10
    template.Food =  math.random(200,400)/10
    template.Water = math.random(200,400)/10

    TriggerClientEvent('Galaxy_Marihuana_Plantada:UseSeed',source,template)
  end
end)

ESX.RegisterUsableItem('lowgradefemaleseed', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('lowgradefemaleseed').count > 0 and xPlayer.getInventoryItem('plantpot').count > 0 then
    xPlayer.removeInventoryItem('lowgradefemaleseed', 1)
    xPlayer.removeInventoryItem('plantpot', 1)

    local template = GMP:PlantTemplate()
    template.Gender = "Female"
    template.Quality = 0.1
    template.Quality = math.random(1,100)/10
    template.Food =  math.random(100,200)/10
    template.Water = math.random(100,200)/10

    TriggerClientEvent('Galaxy_Marihuana_Plantada:UseSeed',source,template)
  end
end)

ESX.RegisterUsableItem('dopebag', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  local canUse = false
  local msg = ''
  if xPlayer.getInventoryItem('trimmedweed').count >= GMP.WeedPerBag and xPlayer.getInventoryItem('drugscales').count > 0 then
    xPlayer.removeInventoryItem('dopebag', 5) --- bolsas ziplock
    xPlayer.removeInventoryItem('trimmedweed', GMP.WeedPerBag) --- cogollos
    xPlayer.addInventoryItem('1gmarihuana', 5) --- marihuana embolsada
    canUse = true
    msg = "Pones "..GMP.WeedPerBag.." De Cogollos en la bolsa ziplock"
  elseif xPlayer.getInventoryItem('trimmedweed').count > 0 then
    msg = "Necesitas una balanza para pesar la bolsa correctamente."
  else
    msg = "No tienes suficiente hierba recortada para hacer esto."
  end
  TriggerClientEvent('Galaxy_Marihuana_Plantada:UseBag', source, canUse, msg)
  ExecuteCommand('do Empaqueta 1 bolsa de marihuana')
end)

ESX.RegisterUsableItem('highgradefemaleseed', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('highgradefemaleseed').count > 0 and xPlayer.getInventoryItem('plantpot').count > 0 then
    xPlayer.removeInventoryItem('highgradefemaleseed', 1)
    xPlayer.removeInventoryItem('plantpot', 1)

    local template = GMP:PlantTemplate()
    template.Gender = "Female"
    template.Quality = 0.2
    template.Quality = math.random(200,500)/10
    template.Food =  math.random(200,400)/10
    template.Water = math.random(200,400)/10

    TriggerClientEvent('Galaxy_Marihuana_Plantada:UseSeed',source,template)
  end
end)