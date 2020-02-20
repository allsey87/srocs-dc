-- just as a reminder {black = 0, pink = 1, orange = 2, green = 3, blue = 4}
local rules = {}
rules.list = {
    {
        ----------------pickup rules--------------------------
        -- considering seeing two blocks
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 2},
            {index = vector3(1, 0, 0), type = 2}
        },
        light_axis = "Y",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, {
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 2},
            {index = vector3(1, 0, 0), type = 4}
        },
        light_axis = "Y",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, {
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 2},
            {index = vector3(0, 1, 0), type = 2}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, {
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 2},
            {index = vector3(0, -1, 0), type = 2}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, -- considering seeing three blocks, these rules would probably never get approved since the block on the edge is the unsafe target
    {
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 2},
            {index = vector3(0, 1, 0), type = 2},
            {index = vector3(0, 2, 0), type = 4}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, {
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 2},
            {index = vector3(0, -1, 0), type = 2},
            {index = vector3(0, -2, 0), type = 4}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, {
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 2},
            {index = vector3(1, 0, 0), type = 2},
            {index = vector3(2, 0, 0), type = 4}
        },
        light_axis = "Y",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }
    --------------------------------------------------------
    
  
}
rules.selection_method = 'nearest_win'
return rules
