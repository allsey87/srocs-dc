package.path = package.path .. ';Tools/?.lua'
package.path = package.path .. ';AppNode/?.lua'
print(package.path)
DebugMSG = require('DebugMessage')
-- require('Debugger')

if api == nil then api = require('BuilderBotAPI') end
if app == nil then app = require('ApplicationNode') end
if rules == nil then rules = require(robot.params.rules) end
local bt = require('luabt')

vel = 0.015
function get_backup_time()
    if robot.rangefinders['underneath'].proximity <
        api.parameters.proximity_touch_tolerance then
        backup_dist = 0.1
    else
        backup_dist = 0.12
    end
    return backup_dist / vel
end
DebugMSG.enable()

--[[ This function is executed every time you press the 'execute' button ]]
function init() reset() end

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
            -- prepare, lift to 0.13
            {
                type = 'selector',
                children = {
                    -- if lift reach position(0.13), return true, stop selector
                    function()
                        if robot.lift_system.position > 0.13 -
                            api.parameters.lift_system_position_tolerance and
                            robot.lift_system.position < 0.13 +
                            api.parameters.lift_system_position_tolerance then
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
            }, {
                type = 'sequence*',
                children = {
                    {
                        -- Approach Wall
                        type = "sequence*",
                        children = {
                            function()
                                distance_threshold = 0.03
                                if (robot.rangefinders['1'].proximity <
                                    distance_threshold or
                                    robot.rangefinders['12'].proximity <
                                    distance_threshold) then
                                    api.move(0, 0)
                                    print("stopped")
                                    return false, true
                                else
                                    api.move(3 * vel, 3 * vel)
                                    print("moving forward")
                                    return true
                                end
                            end, function()
                                print("reached wall")
                                return false, true
                            end
                        }
                    }, {
                        -- Correct Orientation
                        type = "sequence*",
                        children = {
                            function()
                                distance_threshold = 0.01
                                tolerance = 0.0005
                                if (robot.rangefinders['1'].proximity <
                                    distance_threshold and
                                    robot.rangefinders['12'].proximity <
                                    distance_threshold) then
                                    api.move(0, 0)
                                    return false, true
                                else
                                    error =
                                        (robot.rangefinders['1'].proximity -
                                            robot.rangefinders['12'].proximity)
                                    if math.abs(error) < tolerance then
                                        api.move(vel, vel)
                                        return true
                                    else
                                        api.move(-1 * error, error)
                                        return true
                                    end

                                end
                            end, -- backup 
                            {
                                type = "selector*",
                                children = {
                                    {
                                        type = "sequence*",
                                        children = {
                                            function()
                                                if robot.rangefinders['underneath']
                                                    .proximity >
                                                    api.parameters
                                                        .proximity_touch_tolerance then
                                                    return false, true
                                                else
                                                    return false, false

                                                end
                                            end, app.create_timer_node(
                                                {
                                                    time = 0.12 / vel,
                                                    func = function()
                                                        print("Backing up")
                                                        api.move(-1 * vel,
                                                                 -1 * vel)
                                                        return true
                                                    end
                                                })
                                        }
                                    }, {
                                        type = "sequence*",
                                        children = {
                                            function()
                                                if robot.rangefinders['underneath']
                                                    .proximity <=
                                                    api.parameters
                                                        .proximity_touch_tolerance then
                                                    return false, true
                                                else
                                                    return false, false

                                                end
                                            end, app.create_timer_node(
                                                {
                                                    time = 0.1 / vel,
                                                    func = function()
                                                        print("Backing up")
                                                        api.move(-1 * vel,
                                                                 -1 * vel)
                                                        return true
                                                    end
                                                })
                                        }
                                    }
                                }
                            }, function()
                                distance_threshold = 0.04
                                if (robot.rangefinders['3'].proximity <
                                    distance_threshold and
                                    robot.rangefinders['4'].proximity <
                                    distance_threshold) then
                                    api.move(0, 0)
                                    print("stopped")
                                    return false, true
                                else
                                    api.move(0, vel)
                                    print("turn")
                                    return true
                                end
                            end, function()
                                print("orientation corrected")
                                return false, true
                            end
                        }
                    },
                    { -- Follow Wall Complex and Exit on Requited Light Conditions (robot in center)
                        type = "selector",
                        children = {
                            function()

                                light_diff =
                                    robot.rangefinders['1'].illuminance -
                                        robot.rangefinders['6'].illuminance
                                dist_diff =
                                    robot.rangefinders['3'].proximity -
                                        robot.rangefinders['4'].proximity
                                light_threshold = 0.015
                                distance_threshold = 0.05
                                print(light_diff)
                                if math.abs(light_diff) < light_threshold and
                                    math.abs(dist_diff) < 0.01 and
                                    robot.rangefinders['3'].proximity <
                                    distance_threshold and
                                    robot.rangefinders['4'].proximity <
                                    distance_threshold and
                                    robot.rangefinders['1'].proximity >
                                    distance_threshold and
                                    robot.rangefinders['12'].proximity >
                                    distance_threshold and
                                    robot.rangefinders['6'].proximity >
                                    distance_threshold and
                                    robot.rangefinders['7'].proximity >
                                    distance_threshold and
                                    robot.rangefinders['2'].proximity >
                                    distance_threshold and
                                    robot.rangefinders['5'].proximity >
                                    distance_threshold then
                                    print(
                                        "In Center, Exit ********************************************")
                                    print(
                                        "In Center, Exit ********************************************")
                                    print(
                                        "In Center, Exit ********************************************")
                                    -- return false, true
                                    -- This return is to exist wall following, it is commented now so that the robot does not leave wall
                                end

                            end, { -- Follow wall complex
                                type = "selector",
                                children = {
                                    -- wall infornt handling
                                    {
                                        type = "negate",
                                        children = {
                                            {
                                                type = "selector*",
                                                children = {
                                                    -- Wall infornt condition
                                                    function()
                                                        distance_threshold =
                                                            0.02
                                                        if (robot.rangefinders['1']
                                                            .proximity <
                                                            distance_threshold or
                                                            robot.rangefinders['12']
                                                                .proximity <
                                                            distance_threshold) then
                                                            api.move(0, 0)
                                                            print("wall infront")
                                                            return false, false
                                                        else
                                                            return false, true
                                                        end
                                                    end, -- Switch Wall
                                                    {
                                                        -- Correct Orientation
                                                        type = "sequence*",
                                                        children = {
                                                            function()
                                                                distance_threshold =
                                                                    0.01
                                                                tolerance =
                                                                    0.0005
                                                                if (robot.rangefinders['1']
                                                                    .proximity <
                                                                    distance_threshold and
                                                                    robot.rangefinders['12']
                                                                        .proximity <
                                                                    distance_threshold) then
                                                                    api.move(0,
                                                                             0)
                                                                    return
                                                                        false,
                                                                        true
                                                                else
                                                                    error =
                                                                        (robot.rangefinders['1']
                                                                            .proximity -
                                                                            robot.rangefinders['12']
                                                                                .proximity)
                                                                    if math.abs(
                                                                        error) <
                                                                        tolerance then
                                                                        api.move(
                                                                            vel,
                                                                            vel)
                                                                        return
                                                                            true
                                                                    else
                                                                        api.move(
                                                                            -1 *
                                                                                error,
                                                                            error)
                                                                        return
                                                                            true
                                                                    end

                                                                end
                                                            end, -- backup 8 cm
                                                            app.create_timer_node(
                                                                {
                                                                    time = 0.12 /
                                                                        vel,
                                                                    func = function()
                                                                        print(
                                                                            "Backing up")
                                                                        api.move(
                                                                            -1 *
                                                                                vel,
                                                                            -1 *
                                                                                vel)
                                                                        return
                                                                            true
                                                                    end
                                                                }), -- turn
                                                            app.create_timer_node(
                                                                {
                                                                    time = 0.14 /
                                                                        vel,
                                                                    func = function()
                                                                        print(
                                                                            "Backing up")
                                                                        api.move(
                                                                            0,
                                                                            vel)
                                                                        return
                                                                            true
                                                                    end
                                                                }), function()
                                                                distance_threshold =
                                                                    0.04
                                                                if (robot.rangefinders['3']
                                                                    .proximity <
                                                                    distance_threshold and
                                                                    robot.rangefinders['4']
                                                                        .proximity <
                                                                    distance_threshold) then
                                                                    api.move(0,
                                                                             0)
                                                                    print(
                                                                        "stopped")
                                                                    return
                                                                        false,
                                                                        true
                                                                else
                                                                    api.move(0,
                                                                             vel)
                                                                    print("turn")
                                                                    return true
                                                                end
                                                            end, function()
                                                                print(
                                                                    "orientation corrected")
                                                                return false,
                                                                       true
                                                            end
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }, -- Follow Single Wall
                                    function()
                                        error =
                                            robot.rangefinders['3'].proximity -
                                                robot.rangefinders['4']
                                                    .proximity
                                        tolerance = 0.002
                                        required_dist = 0.04

                                        dir_correct =
                                            0.2 *
                                                (robot.rangefinders['3']
                                                    .proximity - required_dist)
                                        api.move(
                                            3 *
                                                (error + 0.8 * vel + dir_correct),
                                            3 *
                                                (-1 * error + 0.8 * vel - 1 *
                                                    dir_correct))

                                        return true
                                    end

                                }
                            }
                        }
                    }
                    ------------------ END of Wall following -------------
                    , -- backup 11 cm
                    {
                        type = "selector*",
                        children = {
                            {
                                type = "sequence*",
                                children = {
                                    function()
                                        if robot.rangefinders['underneath']
                                            .proximity >
                                            api.parameters
                                                .proximity_touch_tolerance then
                                            return false, true
                                        else
                                            return false, false

                                        end
                                    end, app.create_timer_node(
                                        {
                                            time = 0.101 / vel,
                                            func = function()
                                                print("Backing up")
                                                api.move(-1 * vel, -1 * vel)
                                                return true
                                            end
                                        })
                                }
                            }, {
                                type = "sequence*",
                                children = {
                                    function()
                                        if robot.rangefinders['underneath']
                                            .proximity <=
                                            api.parameters
                                                .proximity_touch_tolerance then
                                            return false, true
                                        else
                                            return false, false

                                        end
                                    end, app.create_timer_node(
                                        {
                                            time = 0.1 / vel,
                                            func = function()
                                                print("Backing up")
                                                api.move(-1 * vel, -1 * vel)
                                                return true
                                            end
                                        })
                                }
                            }
                        }
                    }, -- Turn To Face Structure
                    {
                        type = "selector*",
                        children = {
                            {
                                type = "sequence*",
                                children = {
                                    function()
                                        if robot.rangefinders['underneath']
                                            .proximity >
                                            api.parameters
                                                .proximity_touch_tolerance then
                                            return false, true
                                        else
                                            return false, false

                                        end
                                    end, app.create_timer_node(
                                        {
                                            time = 0.195 / vel,
                                            func = function()
                                                print("Turn fixed")
                                                api.move(0, vel)
                                                return true
                                            end
                                        })
                                }
                            }, {
                                type = "sequence*",
                                children = {
                                    function()
                                        if robot.rangefinders['underneath']
                                            .proximity <=
                                            api.parameters
                                                .proximity_touch_tolerance then
                                            return false, true
                                        else
                                            return false, false

                                        end
                                    end, app.create_timer_node(
                                        {
                                            time = 0.17 / vel,
                                            func = function()
                                                print("Turn fixed")
                                                api.move(0, vel)
                                                return true
                                            end
                                        })
                                }
                            }
                        }
                    }, -- Leave Wall To Get Correct Light Readings
                    app.create_timer_node(
                        {
                            time = 0.22 / vel,
                            func = function()
                                print("Move Forward Fixed")
                                api.move(vel, vel)
                                return true
                            end
                        }), {
                        -- Approach Structure until obstacle or target detected
                        type = "selector",
                        children = {
                            -- Check For Obstacle
                            function()
                                distance_threshold = 0.05
                                if (robot.rangefinders['1'].proximity <
                                    distance_threshold or
                                    robot.rangefinders['12'].proximity <
                                    distance_threshold or
                                    robot.rangefinders['2'].proximity <
                                    distance_threshold or
                                    robot.rangefinders['11'].proximity <
                                    distance_threshold) then
                                    api.move(0, 0)
                                    return false, true
                                else
                                    return false, false
                                end
                            end, -- Check For Pickup/Place
                            {
                                type = "selector",
                                children = {
                                    {
                                        type = "sequence",
                                        children = {
                                            -- Check Robot Pickup 
                                            function()
                                                if robot.rangefinders['underneath']
                                                    .proximity >
                                                    api.parameters
                                                        .proximity_touch_tolerance then
                                                    return false, true
                                                else
                                                    return false, false
                                                end
                                            end,
                                            app.create_process_rules_node(rules,
                                                                          'pickup',
                                                                          BTDATA.target)
                                        }
                                    }, {
                                        type = "sequence",
                                        children = {
                                            -- Check Robot Place 
                                            function()
                                                if robot.rangefinders['underneath']
                                                    .proximity <
                                                    api.parameters
                                                        .proximity_touch_tolerance then
                                                    return false, true
                                                else
                                                    return false, false
                                                end
                                            end,
                                            app.create_process_rules_node(rules,
                                                                          'place',
                                                                          BTDATA.target)
                                        }
                                    }
                                }
                            }, {
                                -- Approach Structure
                                -- Follow The Lights
                                type = "selector",
                                children = {
                                    {
                                        type = "sequence",
                                        children = {
                                            function()
                                                if robot.rangefinders['6']
                                                    .illuminance < 0.4 then
                                                    print("Analyzing")
                                                    return false, true
                                                else
                                                    return false, false
                                                end
                                            end, function()
                                                light_diff =
                                                    robot.rangefinders['5']
                                                        .illuminance -
                                                        robot.rangefinders['8']
                                                            .illuminance
                                                print("5:",
                                                      robot.rangefinders['5']
                                                          .illuminance)
                                                print("8:",
                                                      robot.rangefinders['8']
                                                          .illuminance)
                                                correction = 0
                                                if math.abs(light_diff) > 0.001 then
                                                    if light_diff < 0 then
                                                        correction = 0.001
                                                    else
                                                        correction = -0.001
                                                    end
                                                end
                                                api.move(vel - correction,
                                                         vel + correction)
                                                print("Following, Source Black")
                                                return true
                                            end
                                        }
                                    }, {
                                        type = "sequence",
                                        children = {
                                            function()
                                                if robot.rangefinders['6']
                                                    .illuminance > 0.4 then
                                                    print("Analyzing")
                                                    return false, true
                                                else
                                                    return false, false
                                                end
                                            end, function()
                                                light_diff =
                                                    robot.rangefinders['1']
                                                        .illuminance -
                                                        robot.rangefinders['12']
                                                            .illuminance
                                                print("1:",
                                                      robot.rangefinders['1']
                                                          .illuminance)
                                                print("12:",
                                                      robot.rangefinders['12']
                                                          .illuminance)
                                                correction = 0
                                                if math.abs(light_diff) > 0.001 then
                                                    if light_diff < 0 then
                                                        correction = 0.001
                                                    else
                                                        correction = -0.001
                                                    end
                                                end
                                                api.move(vel - correction,
                                                         vel + correction)
                                                print("Following, Source Yellow")
                                                return true
                                            end
                                        }
                                    }

                                }
                            }
                        }

                    }, {
                        type = "selector*",
                        children = {
                            -- Case Of Obstacle
                            function()
                                distance_threshold = 0.05
                                if (robot.rangefinders['1'].proximity <
                                    distance_threshold or
                                    robot.rangefinders['12'].proximity <
                                    distance_threshold or
                                    robot.rangefinders['2'].proximity <
                                    distance_threshold or
                                    robot.rangefinders['11'].proximity <
                                    distance_threshold) then
                                    api.move(0, 0)
                                    return false, true
                                else
                                    return false, false
                                end
                            end, -- Case of Pickup
                            {
                                type = "sequence*",
                                children = {
                                    function()
                                        if robot.rangefinders['underneath']
                                            .proximity >
                                            api.parameters
                                                .proximity_touch_tolerance then
                                            print("pickup routine")
                                            return false, true
                                        else
                                            return false, false
                                        end
                                    end,
                                    app.create_process_rules_node(rules,
                                                                  'pickup',
                                                                  BTDATA.target),
                                    -- approach
                                    app.create_curved_approach_block_node(
                                        BTDATA.target, 0.2), -- pickup 
                                    app.create_pickup_block_node(BTDATA.target,
                                                                 0.205)

                                }
                            }, -- Case of Place
                            {
                                type = "sequence*",
                                children = {
                                    function()
                                        if robot.rangefinders['underneath']
                                            .proximity <
                                            api.parameters
                                                .proximity_touch_tolerance then
                                            print("place routine")
                                            return false, true
                                        else
                                            return false, false
                                        end
                                    end,
                                    app.create_process_rules_node(rules,
                                                                  'place',
                                                                  BTDATA.target),
                                    -- approach
                                    app.create_curved_approach_block_node(
                                        BTDATA.target, 0.2), -- place 
                                    app.create_place_block_node(BTDATA.target,
                                                                0.201)
                                }
                            }, function()
                                return false, true
                            end
                        }
                    }, {
                        -- Turn Away From Structure
                        type = "sequence*",
                        children = {
                            -- Back up fixed
                            app.create_timer_node(
                                {
                                    time = 0.2 / vel,
                                    func = function()
                                        print("Backing up")
                                        api.move(-1 * vel, -1 * vel)
                                        return true
                                    end
                                }), app.create_timer_node(
                                {
                                    time = 0.35 / vel,
                                    func = function()
                                        print("Turn fixed")
                                        api.move(vel, 0)
                                        return true
                                    end
                                })
                        }
                    }, function()
                        print("finished")
                        api.move(0, 0)
                        return false, false
                    end

                }
            }, app.create_process_rules_node(rules, 'pickup', BTDATA.target),
            -- app.create_process_rules_node(rules, 'place', BTDATA.target),
            function()
                if BTDATA.target == nil then
                    -- pprint.pprint('target: ', 'nil')
                    return false, false
                else
                    -- pprint.pprint('target: ', BTDATA.target)
                    return false, true
                end
            end
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
