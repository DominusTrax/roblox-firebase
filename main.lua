--[[
    This was all made by MXKhronos on ROBLOX. I just made this work for many other exploits.
    All credits go to him.
--]]
local FirebaseService = {};

-- Basic Information
local HttpService = game:GetService("HttpService")
local URL = _G.FirebaseURL
local Token = _G.FirebaseToken

function FirebaseService:GetFirebase(name, database)

    -- Basic Auth
    database = URL
    local databaseName = database..HttpService:UrlEncode(name);
    local authentication = ".json?auth="..Token;

    local Firebase = {};

    -- Gets the Database
    function Firebase.GetDatastore()
        return databaseName;
    end

    function Firebase:GetAsync(directory)
        local data = nil;

        local getTick = tick();

        local tries = 0; repeat until pcall(function() tries = tries +1;
            data = HttpService:GetAsync(databaseName..HttpService:UrlEncode(directory and "/"..directory or "")..authentication, true);
        end) or tries > 2;
        if type(data) == "string" then
            if data:sub(1,1) == '"' then
                return data:sub(2, data:len()-1);
            elseif data:len() <= 0 then
                return nil;
            end
        end
    return tonumber(data) or data ~= "null" and data or nil;
end

-- Sets Your Values and Such
function Firebase:SetAsync(directory, value, header)
    if value == "[]" then self:RemoveAsync(directory); return end;
    header = header or {["X-HTTP-Method-Override"]="PUT"};
    local replyJson = "";
    if type(value) == "string" and value:len() >= 1 and value:sub(1,1) ~= "{" and value:sub(1,1) ~= "[" then
        value = '"'..value..'"';
    end
    local success, errorMessage = pcall(function()
        replyJson = HttpService:PostAsync(databaseName..HttpService:UrlEncode(directory and "/"..directory or "")..authentication, value, Enum.HttpContentType.ApplicationUrlEncoded, false, header);
    end);
    if not success then
        warn("FirebaseService>> [ERROR] "..errorMessage);
        pcall(function()
            replyJson = HttpService:JSONDecode(replyJson or "[]");
        end)
    end
end

function Firebase:RemoveAsync(directory)
    self:SetAsync(directory, "", {["X-HTTP-Method-Override"]="DELETE"});
end

function Firebase:UpdateAsync(directory, callback)
    local data = self:GetAsync(directory);
    local callbackData = callback(data);
    if callbackData then
        self:SetAsync(directory, callbackData);
    end
end

    return Firebase;
end

return FirebaseService;
