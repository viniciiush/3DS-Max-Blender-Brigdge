
    /*
            EXPORT AND IMPORT SCENE FOR BLENDER BRIDGE
    ---------instructions : select the wish mesh and click on button, so the blender is open, 
    use the same button for import the same mesh after used the blender bridge button-----------
                        VERSION 1.3
                CREATED BY VINICIUS HORAGUTI
    */
    
    
        obj_temp = #()

		fn get_bridge_dir = (
		    Os = python.import "os";
            user_dir = Os.path.expanduser("~")
            if not doesFileExist (user_dir + "/Documents/blenderBridgeScripts/temp") do makeDir (user_dir + "/Documents/blenderBridgeScripts/temp")

            return (user_dir + "/Documents/blenderBridgeScripts")
		)

        fn regroup_correct = (
            local groups_active = for h in helpers where not isgrouphead h collect(h)
			local grouphead = #()			
			for gp in groups_active do(
				group gp.children	
				delete gp
			)
        )

        fn prepare_mesh_before_return nodes = (
            for obj in nodes do (
                obj.name = (obj.name + "_temp")
                append obj_temp obj
            )
        )

        fn apply_mat_after_import = (
			importedObj = selection as array
            for obj in importedObj do (
				local old_obj = (getnodebyname (obj.name + "_temp") exact:true)
				if old_obj != undefined do (
				    obj.mat = old_obj.mat
                	obj.pos = old_obj.pos
                	delete old_obj
				)
            )
        )

        fn bridge_handler bridge_dir = (
			local models_inpath = getFiles (bridge_dir + "/temp/*.fbx")
			
            if models_inpath.count != 0 then (
                importfile models_inpath[1] #noPrompt
                deleteFile models_inpath[1]
				
                apply_mat_after_import()
                regroup_correct()
            )
            else (
                local selected_meshs = for i in selection collect i
                if selected_meshs.count != 0 then (				
                    exportfile (bridge_dir + @"/temp/temp.fbx") #noPrompt selectedOnly:true
                    local blender_base_path = bridge_dir + "/resources/Blender_Bridge.blend"
                    shelllaunch blender_base_path ""
                    prepare_mesh_before_return selected_meshs
                    
                ) 
                else (
                    messageBox "Voce deve selecionar algo"
                )
                
            )
        )
        
        fn init = (
            local bridge_dir = get_bridge_dir()
            bridge_handler (bridge_dir)
        )
        
        init ()

	