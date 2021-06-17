function withZoomApp(fun)
  local app = hs.application.get("zoom.us")
  if (app ~= nil) then
    fun(app)
  end
end

function pttDown()
  hs.alert("DOWN")
  withZoomApp(function(app)
    hs.eventtap.event.newKeyEvent("space", true):post(app)
  end)
end

function pttUp()
  hs.alert("UP")
  withZoomApp(function(app)
    hs.eventtap.event.newKeyEvent("space", false):post(app)
  end)
end

function disconnect()
  withZoomApp(function(app)
    return app:selectMenuItem({"zoom.us", "Quit Zoom"})
  end)
end

hs.hotkey.bind('', 'padenter', pttDown, pttUp)
hs.hotkey.bind('', 'pad1', disconnect)

-- Also let's use right-shift as a Zoom PTT key.
-- Can't use hotkey.bind to just watch modifier changes, so we use eventtap directly
zoomRightShiftPttListener = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
  local flags = event:getFlags()
	if (event:getKeyCode() == hs.keycodes.map['rightshift']) then
    if (event:getFlags()['shift']) then
      pttDown()
    else
      pttUp()
    end
  end
end)
zoomRightShiftPttListener:start()

screenSwitchers = {}
log = hs.logger.new("WAT")
hs.window.animationDuration = 0
hs.window.switcher.ui.showThumbnails = false
hs.window.switcher.ui.showSelectedThumbnail = false

function focusMonitorFn(idx)
  return function()
    local screen = hs.screen.allScreens()[idx]
    if screen then
      local screenId = screen:id()
      switcher = screenSwitchers[screenId]
      if switcher == nil then
        wf = hs.window.filter.new(nil):setScreens(screenId)
        switcher = hs.window.switcher.new(wf)
        screenSwitchers[screenId] = switcher
      end
      switcher:next()
    end
  end
end

hs.hotkey.bind('alt', "'", focusMonitorFn(1))
hs.hotkey.bind('alt', ',', focusMonitorFn(2))
hs.hotkey.bind('alt', '.', focusMonitorFn(3))
