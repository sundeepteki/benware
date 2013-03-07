classdef zBus < handle
    
    properties
        handle = [];
    end
    
    methods
        function obj = zBus()
            obj.handle = actxcontrol('ZBUS.x',[1 1 1 1]);
            if obj.handle.ConnectZBUS('GB') == 0
                errorBeep(['Cannot connect to zBUS on GB']);
            end
        end
        
        function trigger(obj)
            obj.handle.zBusTrigA(0,0,5);
        end
    end
end
