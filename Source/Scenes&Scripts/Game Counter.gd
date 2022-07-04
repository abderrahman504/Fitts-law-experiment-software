extends Label

func update_text():
	text = "Tests: " + str((get_parent().gameRectSettings.size() - get_parent().rectSettingsCopy.size()))+"/"+str(get_parent().gameRectSettings.size());
