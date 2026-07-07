return {
  ["raspi5"] = {
    host = "localhost",
    user = "sarv-pi",
    port = 2222, -- or whatever your ssh port is
    mappings = {
      {
        ["local"] = "/Users/derickmathews/Developer/UCSC/Research/SARV/raspi-5",
        ["remote"] = "/home/sarv-pi",
      },
    },
  },
}
