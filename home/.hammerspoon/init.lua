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