extends Sprite2D

var shader_offset : float = 0.0

func create_offset():
	if texture:
		var image = texture.get_image()
		var width = image.get_width()
		var height = image.get_height()
		for y in range(height-1):
			for x in range(0,width):
				var pixel_color = image.get_pixel(x,y)
				if pixel_color.a > 0.0:
					shader_offset = y
		material.set_shader_parameter('offset',height-shader_offset)

func _ready(): create_offset()
func _on_texture_changed(): create_offset()
