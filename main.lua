local FirebaseService = {};

-- Basic Information
local URL = _G.FirebaseURL
local Token = _G.FirebaseToken

function FirebaseService:GetFirebase(name, database)
    database = database
    local databaseName = database..HttpService:UrlEncode(name);
    local authentication = ".json?auth="..authenticationToken;
end