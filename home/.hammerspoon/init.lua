function withZoomApp(fun)
  local app = hs.application.get("zoom.us")
  if (app ~= nil) then
    fun(app)
  end
end

function pttDown()
  withZoomApp(function(app)
    hs.eventtap.event.newKeyEvent("space", true):post(app)
  end)
end

function pttUp()
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

screenWindowFilters = {}
log = hs.logger.new("WAT")
hs.window.animationDuration = 0

function focusMonitorFn(idx)
  return function()
    local screen = hs.screen.allScreens()[idx]
    if screen then
      local screenId = screen:id()
      local wf = screenWindowFilters[screenId]
      if wf == nil then
        wf = hs.window.filter.new(nil):setScreens(screenId)
        screenWindowFilters[screenId] = wf
      end
      local windows = wf:getWindows()
      local focusedWindow = hs.window.focusedWindow()
      local focusedWindowId = focusedWindow and focusedWindow:id()
      local window = hs.fnutils.find(windows, function (w) return w:id() ~= focusedWindowId end)
      if window then
        window:focus()
      end
    end
  end
end

hs.hotkey.bind('alt', "'", focusMonitorFn(1))
hs.hotkey.bind('alt', ',', focusMonitorFn(2))
hs.hotkey.bind('alt', '.', focusMonitorFn(3))
