----- CUSTOM ------
enlistments = {}
i = 0
for dir in io.popen([[dir "C:\TFS\" /b /ad]]):lines() do 
    enlistments[i] = dir
    i = i + 1
end
enlistments_parser = clink.arg.new_parser()
enlistments_parser:set_arguments(
    { enlistments }
)
clink.arg.register_parser("enlistment", enlistments_parser)
clink.arg.register_parser("e", enlistments_parser)

