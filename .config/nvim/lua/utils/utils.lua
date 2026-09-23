---@diagnostic disable: unused-function
local M = {}

--- Validates a variable against a spec.
---
--- specs annotation for optional simple type:
--- `[1]`: boolean : Whether the variable/field is optional
--- `[2]`: string|function->string : The type to check the variable/field
---
--- ### Usage example
--- ```lua
--- local specs_1 = "number"
--- local specs_2 = { true, "function" }
--- local specs_3 = { }
--- ```
--- @param var any The variable to type check.
--- @param specs any that
--- @return nil
function M.check_type(var, specs)
	-- Unwrap function specs until type of `specs` isn't "function"
	while type(specs) == "function" do
		specs = specs()
	end

	-- Handle symble type checking
	if type(specs) == "string" then
		if type(var) ~= specs then
			error(string.format("Type mismatch: expected %s, got %s", specs, type(var)), 2)
		end
		return
	end

	-- Handle more complex table type
	if type(specs) == "table" then
		-- Check if a value at index 1 and whether it is a boolean
		-- If it is one, then it will be treated as the is optional flag
		local is_optional = type(specs[1]) == "boolean" and specs[1] or false

		-- Handle nil/missing variable case
		if var == nil then
			if is_optional then
				return
			end
			error("Type mismatch: expected non-nil value", 2)
		end

		-- Determine schema mode based on index 2 or key-value mappings
		local schema = specs[2] or specs

		-- Case A: Tuple/Array spec where index 2 is a string type (e.g., {"string", true})
		if type(schema) == "string" then
			if type(var) ~= schema then
				error(string.format("Type mismatch: expected %s, got %s", schema, type(var)), 2)
			end
			return
		end

		-- Case B: Key-value table structure check with recursive nested specs
		if type(schema) == "table" then
			if type(var) ~= "table" then
				error(string.format("Type mismatch: expected table, got %s", type(var)), 2)
			end

			for key, field_spec in pairs(schema) do
				-- Skip the optional flag key if present in specs[1]
				if key ~= 1 then
					local status, err = pcall(M.check_type, var[key], field_spec)
					if not status then
						-- Re-throw error at call site with exact missing/invalid field key info
						error(string.format("Invalid key '%s': %s", tostring(key), err), 2)
					end
				end
			end
			return
		end
	end

	error("Invalid spec definition", 2)
end

return M

---@alias Specs string
---|function
---|{ [1]: boolean, [2]: string }
---|{ [1]: boolean, [string]: Specs }
