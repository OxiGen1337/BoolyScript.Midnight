local filesys = require("BoolyScript/util/file_system")

local paths = {}
paths.files = {}
paths.folders = {}
paths.logs = {}

-- TODO:fix path
paths.folders.main = filesys.getInitScriptPath() .. "\\BoolyScript"
paths.folders.user = paths.folders.main .. '\\user'
paths.folders.dumps = paths.folders.main .. '\\dumps'
paths.folders.loadouts = paths.folders.user .. '\\loadouts'
paths.folders.translations = paths.folders.user .. '\\translations'
paths.folders.outfits = paths.folders.user .. '\\outfits'
paths.folders.chat_spammer = paths.folders.user.. '\\chat_spammer'
paths.folders.logs = paths.folders.user .. '\\logs'
paths.folders.imgs = paths.folders.main .. '\\img'

paths.logs.chat = paths.folders.logs .. '\\' .. 'Chat.log'
paths.logs.weapons = paths.folders.logs .. '\\' .. 'Weapons.log'
paths.logs.warnScreens = paths.folders.logs .. '\\' .. 'Warning Screens.log'
paths.logs.netEvents = paths.folders.logs .. '\\' .. 'Network Events.log'
paths.logs.scriptEvents = paths.folders.logs .. '\\' .. 'Script Events.log'

paths.files.weapons = paths.folders.dumps .. '\\' .. 'weapons.json'
paths.files.weaponHashes = paths.folders.dumps .. '\\' .. 'WeaponList.json'

paths.files.config = paths.folders.user .. '\\config.json'

paths.files.imgs = {}
paths.files.imgs.header = paths.folders.imgs .. "\\header.png"
paths.files.imgs.bg = paths.folders.imgs .. "\\background.png"
paths.files.imgs.selected = paths.folders.imgs .. "\\selected.png"
paths.files.imgs.footer = paths.folders.imgs .. "\\footer.png"
paths.files.imgs.hintBox = paths.folders.imgs .. "\\description.png"
paths.files.imgs.footerArrows = paths.folders.imgs .. "\\footer_arrows.png"
paths.files.imgs.toggleOn = paths.folders.imgs .. "\\toggle_on.png"
paths.files.imgs.toggleOff = paths.folders.imgs .. "\\toggle_off.png"
paths.files.imgs.sub = paths.folders.imgs .. "\\sub.png"

return paths