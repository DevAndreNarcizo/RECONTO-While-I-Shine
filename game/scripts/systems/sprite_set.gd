class_name SpriteSet
## Carrega e CACHEIA conjuntos de 8 rotações do PixelLab
## (pasta com east.png, south-east.png, ... north-east.png).
## Octantes indexados por ângulo: leste = 0, sentido horário (y para baixo).

const DIRS := [
	"east", "south-east", "south", "south-west",
	"west", "north-west", "north", "north-east",
]
const SOUTH := 2  # índice do octante "olhando para baixo" (pose padrão)

static var _cache: Dictionary = {}

## Retorna Array de 8 Texture2D (ou [] se a pasta não existir).
static func load_set(base_dir: String) -> Array:
	if base_dir.is_empty():
		return []
	if _cache.has(base_dir):
		return _cache[base_dir]
	var textures: Array = []
	for d in DIRS:
		var path := "%s/%s.png" % [base_dir, d]
		if not ResourceLoader.exists(path):
			_cache[base_dir] = []
			return []
		textures.push_back(load(path))
	_cache[base_dir] = textures
	return textures

static func octant(dir: Vector2) -> int:
	return wrapi(roundi(dir.angle() / (TAU / 8.0)), 0, 8)
