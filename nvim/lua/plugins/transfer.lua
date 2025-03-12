return {
  {
    "coffebar/transfer.nvim",
    lazy = true,
    cmd = {
      "TransferInit",
      "DiffRemote",
      "TransferUpload",
      "TransferDownload",
      "TransferDirDiff",
      "TransferRepeat",
    },
    opts = {},
    keys = {
      {
        "<leader>tu",
        function()
          require("transfer.transfer").upload_file()
        end,
        desc = "Upload file",
      },
    },
  },
}
