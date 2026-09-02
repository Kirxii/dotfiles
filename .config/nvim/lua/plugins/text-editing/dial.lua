return {
	"monaqa/dial.nvim",
	keys = {
		{
			"<c-a>",
			function()
				require("dial.map").manipulate("increment", "normal")
			end,
			mode = "n",
			desc = "Increment (Standard)",
			icon = "󱗋",
		},
		{
			"<c-x>",
			function()
				require("dial.map").manipulate("decrement", "normal")
			end,
			mode = "n",
			desc = "Decrement (Standard)",
			icon = "󱁒",
		},
		{
			"g<c-a>",
			function()
				require("dial.map").manipulate("increment", "gnormal")
			end,
			mode = "n",
			desc = "Increment (Sequential)",
			icon = "",
		},
		{
			"g<c-x>",
			function()
				require("dial.map").manipulate("decrement", "gnormal")
			end,
			mode = "n",
			desc = "Decrement (Sequential)",
			icon = "",
		},
		{
			"<c-a>",
			function()
				require("dial.map").manipulate("increment", "visual")
			end,
			mode = "v",
			desc = "Increment (Standard)",
			icon = "󱗋",
		},
		{
			"<c-x>",
			function()
				require("dial.map").manipulate("decrement", "visual")
			end,
			mode = "v",
			desc = "Decrement (Standard)",
			icon = "󱁒",
		},
		{
			"g<c-a>",
			function()
				require("dial.map").manipulate("increment", "gvisual")
			end,
			mode = "v",
			desc = "Increment (Sequential)",
			icon = "",
		},
		{
			"g<c-x>",
			function()
				require("dial.map").manipulate("decrement", "gvisual")
			end,
			mode = "v",
			desc = "Decrement (Sequential)",
			icon = "",
		},
	},
}
