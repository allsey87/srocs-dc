package.path = package.path .. ';Tools/?.lua'
package.path = package.path .. ';AppNode/?.lua'
DebugMSG = require('DebugMessage')
-- require('Debugger')

if api == nil then api = require('BuilderBotAPI') end
if app == nil then app = require('ApplicationNode') end
if rules == nil then rules = require(robot.params.rules) end
local bt = require('luabt')

DebugMSG.enable()

--[[ This function is executed every time you press the 'execute' button ]]
function init() reset() end

function match_light_source(actual_lights, rule_light)
    result = false
    for i, actual_light in pairs(actual_lights) do
        if actual_light == rule_light then result = true end
    end

    return result
end

--[[ This function is executed every time you press the 'reset'
     button in the GUI. It is supposed to restore the state
     of the controller to whatever it was right after init() was
     called. The state of sensors and actuators is reset
     automatically by ARGoS. ]]
function reset()
    local BTDATA = {target = {}}
    -- bt init ---
    local bt_node = {
        type = 'sequence*',
        children = {
            {
                type = 'sequence*',
                children = {
                    -- prepare, lift to 0.13
                    {
                        type = 'selector',
                        children = {
                            -- if lift reach position(0.13), return true, stop selector
                            function()
                                if robot.lift_system.position > 0.13 -
                                    api.parameters
                                        .lift_system_position_tolerance and
                                    robot.lift_system.position < 0.13 +
                                    api.parameters
                                        .lift_system_position_tolerance then
                                    DebugMSG('lift_in position')
                                    return false, true
                                else
                                    DebugMSG('lift_not in position')
                                    return false, false
                                end
                            end, -- set position(0.13)
                            function()
                                robot.lift_system.set_position(0.13)
                                return true -- always running
                            end
                        }
                    }
                }
            }, {
                type = 'selector',
                children = {
                    -- If light is at your left, then move forward
                    {
                        type = 'sequence',
                        children = {
                            -- Check light on (left or (left and front)) ONLY
                            function()

                                res_left =
                                    match_light_source(api.light_source, "left")
                                res_front =
                                    match_light_source(api.light_source, "front")
                                res_back =
                                    match_light_source(api.light_source, "back")
                                res_right =
                                    match_light_source(api.light_source, "right")

                                if (res_left == true and res_back == false and
                                    res_right == false) then
                                    DebugMSG('Light on left detected')
                                    return false, true
                                else
                                    DebugMSG('No light on left detected')
                                    return false, false
                                end
                            end, -- Move forward
                            function()
                                DebugMSG('Moving forward')
                                api.move(0.005, 0.005)
                                return false, true
                            end

                        }
                    }, -- If light is not on your left, then turn left
                    function()
                        DebugMSG('Turn left')
                        api.move(-0.005, 0.005)
                        return false, true
                    end
                }
            }

        }
    }
    behaviour = bt.create(bt_node)
    -- robot init ---
    robot.camera_system.enable()
end
local STATE = 'prepare'

--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
    DebugMSG('-------- step begins ---------')
    robot.wifi.tx_data({robot.id})
    api.process()
    behaviour()
end

--[[ This function is executed only once, when the robot is removed
     from the simulation ]]
function destroy()
    -- put your code here
end