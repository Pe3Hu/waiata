extends MarginContainer


var song = null
var type = null
var segments = []


func set_attributes(input_: Dictionary) -> void:
	song = input_.song
	init_segments()


func init_segments() -> void:
	type = Global.arr.arrangement[1]
	var options = {}
	options["Y"] = []
	options["Z"] = []
	var types = {}
	var triples = []
	var n = 4
	
	for _type in type:
		if !options.has(_type):
			options[_type] = []
			types[_type] = 1
		else:
			types[_type] += 1
	
	for _type in options:
		for title in Global.dict.segment.types[_type]:
			for _i in Global.dict.segment.title[title].limit:
				options[_type].append(title)
	
	segments.append(options["Y"].pick_random())
	
	for _i in n:
		var flag = true
		var titles = {}
		var indexs = {}
		
		while flag:
			flag = false
			titles = {}
			indexs = {}
			
			for _type in types:
				titles[_type] = options[_type].pick_random()
				indexs[_type] = 0
			
			if triples.has(titles):
				flag = true
			
			if !flag:
				for _j in titles.keys().size():
					var _l = (_j + 1) % titles.keys().size()
					var a = titles[titles.keys()[_j]]
					var b = titles[titles.keys()[_l]]
					
					if a == b:
						flag = true
						break
		
		for _j in titles.keys().size():
			for _type in types:
				options[_type].erase(titles[titles.keys()[_j]])
		
		triples.append(titles)
		print(_i, titles)
		
		for _type in type:
			var title = titles[_type]
			
			if indexs[_type] > 0:
				title = title + " " + str(indexs[_type])
			
			indexs[_type] += 1
			segments.append(title)
			
			#print([_type, title])
	
	segments.append(options["Z"].pick_random())
	print(options)
	print(segments)
