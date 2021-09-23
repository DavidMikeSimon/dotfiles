--------
-- PTT
--------

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

-- Let's use right-shift as a Zoom PTT key.
-- Can't use hotkey.bind to just watch modifier changes, so we use eventtap directly
zoomRightShiftPttListener = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
  if (event:getKeyCode() == hs.keycodes.map['rightshift']) then
    if (event:getFlags()['shift']) then
      pttDown()
    else
      pttUp()
    end
  end
end)
zoomRightShiftPttListener:start()

hs.hotkey.bind('', 'pad1', disconnect)

--------
-- Window switching
--------

screenWindowFilters = {}
previewSequences = {}
log = hs.logger.new("WAT")
hs.window.animationDuration = 0

function resetPreviewSequences()
  for k in pairs(previewSequences) do
    previewSequences[k] = nil
  end
end

altReleaseListener = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
  if (not event:getFlags()['alt']) then
    resetPreviewSequences()
  end
end)
altReleaseListener:start()

function focusMonitorFn(idx)
  return function()
    local screen = hs.screen.find({x=idx, y=0})
    if not screen then
      return
    end
    local screenId = screen:id()

    local wf = screenWindowFilters[screenId]
    if wf == nil then
      wf = hs.window.filter.new(nil):setScreens(screenId)
      screenWindowFilters[screenId] = wf
    end
    local windows = wf:getWindows()

    local focusedWindow = hs.window.focusedWindow()
    local focusedWindowId = focusedWindow and focusedWindow:id()

    local previewSequence = previewSequences[screenId]
    local focusSequenceId = previewSequence and hs.fnutils.indexOf(previewSequence, focusedWindowId)
    -- Recalculate sequence if focus changes screens, so that we jump to most recently focused window on that screen
    if previewSequence == nil or focusSequenceId == nil then
      previewSequence = hs.fnutils.map(windows, function (w) return w:id() end)
      previewSequences[screenId] = previewSequence
      focusSequenceId = hs.fnutils.indexOf(previewSequence, focusedWindowId)
    end

    if focusSequenceId == nil or focusSequenceId == #previewSequence then
      focusSequenceId = 0
    end
    local targetWindowId = previewSequence[focusSequenceId + 1]
    local targetWindow = hs.fnutils.find(windows, function (w) return w:id() == targetWindowId end)
    if targetWindow == nil then
      targetWindow = windows[1]
    end

    if targetWindow then
      targetWindow:focus()
    end
  end
end

hs.hotkey.bind('alt', "'", focusMonitorFn(0))
hs.hotkey.bind('alt', ',', focusMonitorFn(1))
hs.hotkey.bind('alt', '.', focusMonitorFn(2))

-- FIXME Can't seem to escape Zoom window
-- FIXME When one app has windows on two screens, this doesn't work properly
-- FIXME Send mouse?
