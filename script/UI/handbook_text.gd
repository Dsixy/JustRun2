extends RefCounted
class_name HandbookText

## 图鉴等级描述：已合成到的等级才显示真实文案，其余为 ？？？
static func copy_string_array(source: Array) -> Array[String]:
	var result: Array[String] = []
	for item in source:
		result.append(String(item))
	return result

static func format_weapon_levels(descriptions: Array, max_level: int) -> String:
	var lines: PackedStringArray = []
	var level_labels := ["基础", "1级", "2级", "3级", "4级"]
	for i in range(5):
		var label: String = level_labels[i]
		if max_level >= i and i < descriptions.size() and str(descriptions[i]) != "":
			lines.append("%s：%s" % [label, descriptions[i]])
		else:
			lines.append("%s：？？？" % label)
	return "\n".join(lines)
