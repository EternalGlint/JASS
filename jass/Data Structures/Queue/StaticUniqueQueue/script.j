library StaticUniqueQueue /* v1.0.0.4
************************************************************************************
*
*   */uses/*
*   
*       */ ErrorMessage /*         hiveworkshop.com/forums/submissions-414/snippet-error-message-239210/
*
************************************************************************************
*
*   module StaticUniqueQueue
*
*       Description
*       -------------------------
*
*           Node Properties:
*
*               Unique
*               Allocated
*               Not 0
*
*       Fields
*       -------------------------
*
*           readonly static integer sentinel
*
*           readonly static thistype first
*           readonly thistype next
*
*       Methods
*       -------------------------
*
*           static method enqueue takes thistype node returns nothing
*           static method pop takes nothing returns nothing
*
*           static method clear takes nothing returns nothing
*
*           debug static method calculateMemoryUsage takes nothing returns integer
*           debug static method getAllocatedMemoryAsString takes nothing returns string
*
************************************************************************************/
    module StaticUniqueQueue
        debug private boolean isNode
    
        private static thistype last = 0
        
        private thistype _next
        method operator next takes nothing returns thistype
            debug call ThrowError(this == 0,    "StaticUniqueQueue", "next", "thistype", 0, "Attempted To Go Out Of Bounds.")
            debug call ThrowError(not isNode,   "StaticUniqueQueue", "next", "thistype", 0, "Attempted To Read Rogue Node.")
            return _next
        endmethod
        
        static method operator first takes nothing returns thistype
            return thistype(0)._next
        endmethod
        
        static method operator sentinel takes nothing returns integer
            return 0
        endmethod
        
        static method enqueue takes thistype node returns nothing
            debug call ThrowError(node == 0,    "StaticUniqueQueue", "enqueue", "thistype", 0, "Attempted To Enqueue Null Node.")
            debug call ThrowError(node.isNode,  "StaticUniqueQueue", "enqueue", "thistype", 0, "Attempted To Enqueue Owned Node (" + I2S(node) + ").")
            
            debug set node.isNode = true
        
            set last._next = node
            set last = node
            set node._next = 0
        endmethod
        static method pop takes nothing returns nothing
            debug call ThrowWarning(thistype(0)._next == 0, "StaticUniqueQueue", "pop", "thistype", 0, "Popping Empty Queue.")
            
            debug set thistype(0)._next.isNode = false
        
            set thistype(0)._next = thistype(0)._next._next
            if (thistype(0)._next == 0) then
                set last = 0
            endif
        endmethod
        static method clear takes nothing returns nothing
            debug local thistype node = thistype(0)._next
        
            static if DEBUG_MODE then
                loop
                    exitwhen node == 0
                    set node.isNode = false
                    set node = node._next
                endloop
            endif
        
            set last = 0
            set thistype(0)._next = 0
        endmethod
        
        static if DEBUG_MODE then
            static method calculateMemoryUsage takes nothing returns integer
                local thistype start = 1
                local thistype end = 8191
                local integer count = 0
                
                loop
                    exitwhen integer(start) > integer(end)
                    if (integer(start) + 500 > integer(end)) then
                        return count + checkRegion(start, end)
                    else
                        set count = count + checkRegion(start, start + 500)
                        set start = start + 501
                    endif
                endloop
                
                return count
            endmethod
              
            private static method checkRegion takes thistype start, thistype end returns integer
                local integer count = 0
            
                loop
                    exitwhen integer(start) > integer(end)
                    if (start.isNode) then
                        set count = count + 1
                    endif
                    set start = start + 1
                endloop
                
                return count
            endmethod
            
            static method getAllocatedMemoryAsString takes nothing returns string
                local thistype start = 1
                local thistype end = 8191
                local string memory = null
                
                loop
                    exitwhen integer(start) > integer(end)
                    if (integer(start) + 500 > integer(end)) then
                        if (memory != null) then
                            set memory = memory + ", "
                        endif
                        set memory = memory + checkRegion2(start, end)
                        set start = end + 1
                    else
                        if (memory != null) then
                            set memory = memory + ", "
                        endif
                        set memory = memory + checkRegion2(start, start + 500)
                        set start = start + 501
                    endif
                endloop
                
                return memory
            endmethod
              
            private static method checkRegion2 takes thistype start, thistype end returns string
                local string memory = null
            
                loop
                    exitwhen integer(start) > integer(end)
                    if (start.isNode) then
                        if (memory == null) then
                            set memory = I2S(start)
                        else
                            set memory = memory + ", " + I2S(start) + "N"
                        endif
                    endif
                    set start = start + 1
                endloop
                
                return memory
            endmethod
        endif
    endmodule
endlibrary