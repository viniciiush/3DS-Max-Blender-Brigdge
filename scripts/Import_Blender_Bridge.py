import os
import bpy

def get_user ():
    user_dir = os.path.expanduser("~")
    return user_dir

bpy.ops.import_scene.fbx(filepath= get_user()+"\\Documents\\blenderBridgeScripts\\temp\\temp.fbx")

def export (context):
   bpy.ops.export_scene.fbx(filepath= get_user()+"\\Documents\\blenderBridgeScripts\\temp\\temp.fbx",bake_anim=False)
   bpy.ops.wm.quit_blender()

class ExportFunction(bpy.types.Operator):
    """Export The Object"""
    bl_idname = "myops.export_scene"
    bl_label = "Bridge to Max"

    def execute (self, context):
        export (context)
        return {'FINISHED'}

def register():
    bpy.utils.register_class(ExportFunction)

def unregister():
    bpy.utils.unregister_class(ExportFunction)

register()




class ExportMeshLabel(bpy.types.Panel):
    """creates a custom panel"""
    bl_label = "Export back to Max"
    bl_idname = "OBJECT_PT_Bridge"
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'
    bl_category = "Max Bridge"

    def draw(self, context):
        layout = self.layout

        obj = context.object

        row = layout.row()
        row.label(text="Max Bridge", icon='WORLD_DATA')
        
        row = layout.row()
        row.operator("myops.export_scene")


def register():
    bpy.utils.register_class(ExportMeshLabel)


def unregister():
    bpy.utils.unregister_class(ExportMeshLabel)



register()
