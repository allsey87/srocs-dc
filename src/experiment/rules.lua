-- just as a reminder {black = 0, pink = 1, orange = 2, green = 3, blue = 4}
local rules = {}
rules.list = {
    ----------------pickup rules--------------------------
    -- considering seeing two blocks
    {
        rule_id = 1,
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(1, 0, 0), type = 3}
        },
        light_axis = "Y",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, {
        rule_id = 2,
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(0, -1, 0), type = 3}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, {
        rule_id = 3,
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
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
        rule_id = 4,
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(0, -1, 0), type = 4}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, {
        rule_id = 5,
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(1, 0, 0), type = 4},
            {index = vector3(1, 1, 0), type = 4}
        },
        light_axis = "Y",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, {
        rule_id = 6,
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(1, 0, 0), type = 4},
            {index = vector3(1, -1, 0), type = 3}
        },
        light_axis = "Y",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, {
        rule_id = 7,
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(1, 1, 0), type = 3},
            {index = vector3(1, -1, 0), type = 3},
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
        rule_id = 8,
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(1, -1, 0), type = 3},
            {index = vector3(0, -1, 0), type = 4}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, {
        rule_id = 9,
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(0, 1, 0), type = 3}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, {
        rule_id = 10,
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(0, 1, 0), type = 4}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, {
        rule_id = 11,
        rule_type = 'pickup',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(1, 1, 0), type = 3},
            {index = vector3(0, 1, 0), type = 4}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(0, 0, 0),
            type = 1
        },
        generate_orientations = false
    }, --------------------------------------------------------
    -------------------placing rules------------------------
    {
        rule_id = 12,
        rule_type = 'place',
        structure = {
            {index = vector3(0, 0, 0), type = 4},
            {index = vector3(0, 1, 0), type = 3},
            {index = vector3(0, -1, 0), type = 3}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(1, 0, 0),
            type = 3
        },
        generate_orientations = false
    }, {
        rule_id = 13,
        rule_type = 'place',
        structure = {
            {index = vector3(0, 0, 0), type = 4},
            {index = vector3(1, 0, 0), type = 3}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(1, 0, 0),
            type = 3
        },
        generate_orientations = false
    }, {
        rule_id = 14,
        rule_type = 'place',
        structure = {
            {index = vector3(0, 0, 0), type = 4},
            {index = vector3(0, -1, 0), type = 3}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(1, 0, 0),
            type = 3
        },
        generate_orientations = false
    }, {
        rule_id = 15,
        rule_type = 'place',
        structure = {
            {index = vector3(0, 0, 0), type = 4},
            {index = vector3(0, -1, 0), type = 3},
            {index = vector3(1, 0, 0), type = 3}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(1, 0, 0),
            type = 3
        },
        generate_orientations = false
    }, {
        rule_id = 16,
        rule_type = 'place',
        structure = {
            {index = vector3(0, 0, 0), type = 4},
            {index = vector3(0, -1, 0), type = 3},
            {index = vector3(0, 1, 0), type = 3},
            {index = vector3(1, 0, 0), type = 3}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(1, 0, 0),
            type = 3
        },
        generate_orientations = false
    }, {
        rule_id = 17,
        rule_type = 'place',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(1, -1, 0), type = 3},
            {index = vector3(1, 1, 0), type = 3},
            {index = vector3(1, 0, 0), type = 4}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(1, 0, 0),
            type = 3
        },
        generate_orientations = false
    }, {
        rule_id = 18,
        rule_type = 'place',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(1, -1, 0), type = 3},
            {index = vector3(1, 0, 0), type = 4}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(1, 0, 0),
            type = 3
        },
        generate_orientations = false
    }, {
        rule_id = 19,
        rule_type = 'place',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(1, 1, 0), type = 3},
            {index = vector3(1, 0, 0), type = 4}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(1, 0, 0),
            type = 3
        },
        generate_orientations = false
    }, {
        rule_id = 20,
        rule_type = 'place',
        structure = {
            {index = vector3(0, 0, 0), type = 3},
            {index = vector3(1, 0, 0), type = 4}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(1, 0, 0),
            type = 3
        },
        generate_orientations = false
    }, {
        rule_id = 21,
        rule_type = 'place',
        structure = {
            {index = vector3(0, 0, 0), type = 4},
            {index = vector3(1, 0, 0), type = 3}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(1, 0, 0),
            type = 3
        },
        generate_orientations = false
    }, {
        rule_id = 22,
        rule_type = 'place',
        structure = {
            {index = vector3(0, 0, 0), type = 4},
            {index = vector3(1, 0, 0), type = 3},
            {index = vector3(0, 1, 0), type = 3}
        },
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(1, 0, 0),
            type = 3
        },
        generate_orientations = false
    }, {
        rule_id = 23,
        rule_type = 'place',
        structure = {{index = vector3(0, 0, 0), type = 4}},
        light_axis = "X",
        target = {
            reference_index = vector3(0, 0, 0),
            offset_from_reference = vector3(1, 0, 0),
            type = 3
        },
        generate_orientations = false
    }
}
rules.selection_method = 'nearest_win'
return rules
