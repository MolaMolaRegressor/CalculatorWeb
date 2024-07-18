object MainWM: TMainWM
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      Name = 'WebActionItem1'
      PathInfo = '/calculation'
      OnAction = WebModule1WebActionItem1Action
    end>
  Height = 230
  Width = 415
end
