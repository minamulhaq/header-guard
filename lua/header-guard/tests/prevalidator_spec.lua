---@diagnostic disable: undefined-global

local prevalidator = require("header-guard.pre_validator")

local eq = assert.are.same
local home = os.getenv("HOME")
local tmp_file = home .. "/tmp/header_guard_test.h"

describe("pre_validator.get_validation", function()
    before_each(function()
        print("Creating file: " .. tmp_file)
        local f = io.open(tmp_file, "w")
        if f then
            f:write("")
            f:close()
        end
    end)

    after_each(function()
        print("Removing file: " .. tmp_file)
        os.remove(tmp_file)
    end)

    it("Handle empty file", function()
        local f = io.open(tmp_file, "w")
        if f then
            f:write("")
            f:close()
        end
        eq(true, prevalidator.run_prevalidation(tmp_file))
    end)
end)
