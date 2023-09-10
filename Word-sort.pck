GDPC                 �                                                                         X   res://.godot/exported/133200997/export-66e982d58024e76ec97054cc08e1a482-defaultTheme.res�      S      g
LH��x��5z�>��    X   res://.godot/exported/133200997/export-7688c27b7e32c87cb4439b49990e96c2-outlinePanel.res�)      �      �{��^?b��5����C	    T   res://.godot/exported/133200997/export-e66311c87c39ec8c25379305b5ae724b-control.scn �            �
jR��9�[��%��    P   res://.godot/exported/133200997/export-f0a4ea32b72b64218d23e48a955cbc61-test.scn/      �      R�UH (�s���o!ω    ,   res://.godot/global_script_class_cache.cfg  �8             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex       �      �Yz=������������       res://.godot/uid_cache.bin  `<      �       ��Z�$_p[�	��j%       res://Control.gd        �      �H��ze5��2�d���       res://control.tscn.remap�6      d       e��G,(�9k2��p�        res://defaultTheme.tres.remap   07      i       �)��n�U�Bc�ۗ�       res://icon.svg  �8      �      C��=U���^Qu��U3       res://icon.svg.import    )      �       2���^��-/䞦��        res://outlinePanel.tres.remap   �7      i       T�����Q�Z�o��9       res://project.binary =      �      ?����Y�dtK5��-       res://test.gd   �-      e      �_�¥W��gW�.�S�       res://test.tscn.remap   8      a       �ڡ�$��h��h���    extends Control

@onready var areaContainer := $AreaContainer
@onready var containerColl :CollisionShape2D= areaContainer.get_child(0)

@onready var correctWordLabel :Label= $CorrectWords

@onready var defaultTheme :Theme= load("res://defaultTheme.tres")
@onready var outlinePanel :StyleBoxFlat= load("res://outlinePanel.tres")

var targetWord : Array = ["SATU", "SAPI", "SAPU", "BATU"]
var correctWord : Array = []
var map_x: int = 3
var map_y: int = 3
var button_size: int = 100
var shuffledWord : String = ""
var letterAreas : Array
var pickedIndices : Array
var pickedLetter : Array

func _ready():
	containerColl.shape.size = Vector2(map_x*button_size, map_y*button_size)
	
	var start_location = containerColl.position-(containerColl.shape.size/2.0)+Vector2(button_size/2.0, button_size/2.0)
	$ResultLabel.size = Vector2($ResultLabel.size.x, map_y*button_size)
	$ResultLabel.position = Vector2(start_location.x-(button_size/2.0), start_location.y+(map_y*button_size)-(button_size/2.0))
	
	$TargetLabel.text = " ".join(targetWord)
	shuffledWord = shuffleString(targetWord)
	
	for letter in shuffledWord:
		var area: Area2D = Area2D.new()
		var label: Label = Label.new()
		var panel: Panel = Panel.new()
		panel.size = Vector2(button_size, button_size)
		panel.position -= Vector2(button_size/2.0, button_size/2.0)
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.set("theme_override_styles/panel", outlinePanel) 
		label.size = Vector2(button_size, button_size)
		label.position -= Vector2(button_size/2.0, button_size/2.0)
		label.text = letter
		label.theme = defaultTheme
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		var collisionShape = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(button_size, button_size)
		collisionShape.shape = shape
		
		area.add_child(panel)
		area.add_child(label)
		area.add_child(collisionShape)
		areaContainer.add_child(area)
		letterAreas.append(area)

		area.set_process_input(true)
		area.input_event.connect(self._on_Area_input_event.bind(letterAreas.size()-1), 0)
		
	var loc = start_location
	for i in range(letterAreas.size()):
		var area:Area2D = letterAreas[i]
		area.position = loc
		loc.x += button_size
		if (i+1) % map_x == 0:
			loc.y += button_size
			loc.x = start_location.x

func _on_Area_input_event(_viewport, event: InputEvent, _shape_idx, area_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var clickedArea : Area2D = letterAreas[area_idx]
		var label = clickedArea.get_child(1)  # Assuming the label is the first child
		var clickedLetter = label.text
		
		if clickedLetter == "*":
			return
		
		if area_idx not in pickedIndices:
			clickedArea.modulate = Color(1, 0, 0, 1)
			pickedIndices.append(area_idx)
			pickedLetter.append(clickedLetter)
		else:
			if pickedIndices[pickedIndices.size()-1] == area_idx:
				clickedArea.modulate = Color(1, 1, 1, 1)
				var pickedIndex = pickedIndices.find(area_idx)
				pickedIndices.remove_at(pickedIndex)
				pickedLetter.remove_at(pickedIndex)
		
		var result = "".join(pickedLetter)
		$ResultLabel.text = result
		if result in targetWord:
			if result not in correctWord:
				correctWord.append(result)
			for area in letterAreas:
				area.modulate = Color(1, 1, 1, 1)
			pickedIndices = []
			pickedLetter = []
			correctWordLabel.text = "Correct Answer : "+", ".join(correctWord)
		
		

func _exit_tree():
	areaContainer.queue_free()	

# Custom shuffle function for strings
func shuffleString(targets: Array) -> String:
	var stringData :String= "".join(targets)
	var maps = []
	for character in stringData:
		maps.append(character)
		
	maps = array_unique(maps)
	for n in (map_x*map_y)-len(maps):
		maps.append("*")
	
	maps.shuffle()
	return "".join(maps)

func array_unique(array: Array) -> Array:
	var unique: Array = []

	for item in array:
		if not unique.has(item):
			unique.append(item)

	return unique
ަ��n�Ov��RSRC                    PackedScene            ��������                                            	      resource_local_to_scene    resource_name    blend_mode    light_mode    particles_animation    script    custom_solver_bias    size 	   _bundled       Script    res://Control.gd ��������   Theme    res://defaultTheme.tres ��O�(Q   !   local://CanvasItemMaterial_rf7hf �         local://RectangleShape2D_4g5i1          local://PackedScene_mrt1h 8         CanvasItemMaterial             RectangleShape2D       
    @TD  ~C         PackedScene          	         names "   #      Control    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    mouse_filter    script 
   ColorRect 
   Narrative    anchor_top    offset_left    offset_top    offset_right    offset_bottom    theme $   theme_override_font_sizes/font_size    text    horizontal_alignment    vertical_alignment    autowrap_mode    Label    ResultLabel    TargetLabel    pivot_offset !   theme_override_colors/font_color    CorrectWords    AreaContainer    Area2D    Coll 	   material 	   position    shape    CollisionShape2D    	   variants                         �?                                  ?     �A    ���     ��     ��                  �  Lihatlah anak-anak, disana ada 3 anak ayam yang sedang makan. Namun karena terlalu asik, mereka terpisah dengan induknya.. kasihan sekali yaa, bagaimana perasaan anak-anak jika jauh dengan Ibu? Pasti sedih sekali yaa.. ayo kita bantu cari induknya. Coba cari jalan dengan menyusun kata bermakna. Namun anak-anak harus berhati-hati dengan penghalang jalan yang tidak bisa dilewati. Ayoo mulai mencari jalan.. kalian pasti bisa!             >D     D    �yD     D     �A     D     pB    �D
     �A  �A   ��U?��U?��U?  �?     �A     �C     D          
     D  �C               node_count             nodes     �   ��������        ����                                                                	   	   ����                                                            
   ����                                          	      
                                                                            ����                                                         ����	                                                                           ����                                                         ����               "      ����                !                conn_count              conns               node_paths              editable_instances              version             RSRC��P@�#�RSRC                    Theme            ��������                                                  resource_local_to_scene    resource_name    default_base_scale    default_font    default_font_size    Label/colors/font_color    script           local://Theme_wemcc !         Theme                        �?      RSRC���8���;h�hƂGST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح����mow�*��f�&��Cp�ȑD_��ٮ}�)� C+���UE��tlp�V/<p��ҕ�ig���E�W�����Sթ�� ӗ�A~@2�E�G"���~ ��5tQ#�+�@.ݡ�i۳�3�5�l��^c��=�x�Н&rA��a�lN��TgK㼧�)݉J�N���I�9��R���$`��[���=i�QgK�4c��%�*�D#I-�<�)&a��J�� ���d+�-Ֆ
��Ζ���Ut��(Q�h:�K��xZ�-��b��ٞ%+�]�p�yFV�F'����kd�^���:[Z��/��ʡy�����EJo�񷰼s�ɿ�A���N�O��Y��D��8�c)���TZ6�7m�A��\oE�hZ�{YJ�)u\a{W��>�?�]���+T�<o�{dU�`��5�Hf1�ۗ�j�b�2�,%85�G.�A�J�"���i��e)!	�Z؊U�u�X��j�c�_�r�`֩A�O��X5��F+YNL��A��ƩƗp��ױب���>J�[a|	�J��;�ʴb���F�^�PT�s�)+Xe)qL^wS�`�)%��9�x��bZ��y
Y4�F����$G�$�Rz����[���lu�ie)qN��K�<)�:�,�=�ۼ�R����x��5�'+X�OV�<���F[�g=w[-�A�����v����$+��Ҳ�i����*���	�e͙�Y���:5FM{6�����d)锵Z�*ʹ�v�U+�9�\���������P�e-��Eb)j�y��RwJ�6��Mrd\�pyYJ���t�mMO�'a8�R4��̍ﾒX��R�Vsb|q�id)	�ݛ��GR��$p�����Y��$r�J��^hi�̃�ūu'2+��s�rp�&��U��Pf��+�7�:w��|��EUe�`����$G�C�q�ō&1ŎG�s� Dq�Q�{�p��x���|��S%��<
\�n���9�X�_�y���6]���մ�Ŝt�q�<�RW����A �y��ػ����������p�7�l���?�:������*.ո;i��5�	 Ύ�ș`D*�JZA����V^���%�~������1�#�a'a*�;Qa�y�b��[��'[�"a���H�$��4� ���	j�ô7�xS�@�W�@ ��DF"���X����4g��'4��F�@ ����ܿ� ���e�~�U�T#�x��)vr#�Q��?���2��]i�{8>9^[�� �4�2{�F'&����|���|�.�?��Ȩ"�� 3Tp��93/Dp>ϙ�@�B�\���E��#��YA 7 `�2"���%�c�YM: ��S���"�+ P�9=+D�%�i �3� �G�vs�D ?&"� !�3nEФ��?Q��@D �Z4�]�~D �������6�	q�\.[[7����!��P�=��J��H�*]_��q�s��s��V�=w�� ��9wr��(Z����)'�IH����t�'0��y�luG�9@��UDV�W ��0ݙe)i e��.�� ����<����	�}m֛�������L ,6�  �x����~Tg����&c�U��` ���iڛu����<���?" �-��s[�!}����W�_�J���f����+^*����n�;�SSyp��c��6��e�G���;3Z�A�3�t��i�9b�Pg�����^����t����x��)O��Q�My95�G���;w9�n��$�z[������<w�#�)+��"������" U~}����O��[��|��]q;�lzt�;��Ȱ:��7�������E��*��oh�z���N<_�>���>>��|O�׷_L��/������զ9̳���{���z~����Ŀ?� �.݌��?�N����|��ZgO�o�����9��!�
Ƽ�}S߫˓���:����q�;i��i�]�t� G��Q0�_î!�w��?-��0_�|��nk�S�0l�>=]�e9�G��v��J[=Y9b�3�mE�X�X�-A��fV�2K�jS0"��2!��7��؀�3���3�\�+2�Z`��T	�hI-��N�2���A��M�@�jl����	���5�a�Y�6-o���������x}�}t��Zgs>1)���mQ?����vbZR����m���C��C�{�3o��=}b"/�|���o��?_^�_�+��,���5�U��� 4��]>	@Cl5���w��_$�c��V��sr*5 5��I��9��
�hJV�!�jk�A�=ٞ7���9<T�gť�o�٣����������l��Y�:���}�G�R}Ο����������r!Nϊ�C�;m7�dg����Ez���S%��8��)2Kͪ�6̰�5�/Ӥ�ag�1���,9Pu�]o�Q��{��;�J?<�Yo^_��~��.�>�����]����>߿Y�_�,�U_��o�~��[?n�=��Wg����>���������}y��N�m	n���Kro�䨯rJ���.u�e���-K��䐖��Y�['��N��p������r�Εܪ�x]���j1=^�wʩ4�,���!�&;ج��j�e��EcL���b�_��E�ϕ�u�$�Y��Lj��*���٢Z�y�F��m�p�
�Rw�����,Y�/q��h�M!���,V� �g��Y�J��
.��e�h#�m�d���Y�h�������k�c�q��ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[  �˕Y��s�[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://dmjxfirra0udk"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 ����ª+s��z;�'RSRC                    StyleBoxFlat            ��������                                                  resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script           local://StyleBoxFlat_bx6la          StyleBoxFlat          ��r?��r?��r?  �?	         
                                 ���=���=���=  �?                                          RSRCB#U�s�extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_container_input_event(viewport, event, shape_idx):
	print(event)
	pass # Replace with function body.
�g�����%rRSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    default_base_scale    default_font    default_font_size    Label/colors/font_color    script    blend_mode    light_mode    particles_animation    custom_solver_bias    size 	   _bundled       Script    res://test.gd ��������      local://Theme_70ru8 -      !   local://CanvasItemMaterial_wripq [         local://RectangleShape2D_jx6vh ~         local://PackedScene_b1dth �         Theme                        �?         CanvasItemMaterial             RectangleShape2D       
    @TD  �C         PackedScene          	         names "         Control    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    mouse_filter    script    ResultLabel    offset_left    offset_top    offset_right    offset_bottom    theme    Label    TargetLabel    pivot_offset $   theme_override_font_sizes/font_size    AreaContainer    Area2D    Coll 	   material 	   position    shape    CollisionShape2D    _on_area_container_input_event    input_event    	   variants                        �?                           �D     B    ��D     �B                A     D     @B    �D
     �A  �A         
     D  �C               node_count             nodes     S   ��������        ����                                                                   	   ����         
                     	      
                     ����         
                                                      ����                     ����                               conn_count             conns                                      node_paths              editable_instances              version             RSRC�[remap]

path="res://.godot/exported/133200997/export-e66311c87c39ec8c25379305b5ae724b-control.scn"
�w)����X�j�[remap]

path="res://.godot/exported/133200997/export-66e982d58024e76ec97054cc08e1a482-defaultTheme.res"
A]5ܗu[remap]

path="res://.godot/exported/133200997/export-7688c27b7e32c87cb4439b49990e96c2-outlinePanel.res"
a�0n-�[remap]

path="res://.godot/exported/133200997/export-f0a4ea32b72b64218d23e48a955cbc61-test.scn"
5�I�/��Q�@F��list=Array[Dictionary]([])
���<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
��sb�c6C{   �6�$ޤw   res://control.tscnh,r��#Ro   res://icon.svg����`GL   res://test.tscn��O�(Q   res://defaultTheme.tresXJ�9PUg   res://Panel.tresXJ�9PUg   res://outlinePanel.tres�$��u��ECFG      application/config/name      	   Word-sort      application/run/main_scene         res://control.tscn     application/config/features(   "         4.1    GL Compatibility       application/config/icon         res://icon.svg  #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility���2��