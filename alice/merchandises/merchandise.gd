class_name Merchandise

enum Type {	GOLD=0,
			SILK=1,
			IVORY=2,
			COTON=3,
			SPICE=4,
			ANIMALS=5,
			SLAVES=6,
			PEPPER=7,
			GEMS=8,
			PORCELAIN=9}

const names : Dictionary[Type,String] = {
	Type.GOLD:"or",
	Type.PEPPER:"unités de poivre",
	Type.SILK:"unités de soie",
	Type.IVORY:"unité d'ivoire",
	Type.COTON:"unité de cotons",
	Type.GEMS:"gemmes",
	Type.SPICE:"unités d'épices",
	Type.ANIMALS:"chevaux",
	Type.PORCELAIN:"porcelaine",
	Type.SLAVES:"esclaves"}

const prices : Dictionary[Type,float] = {
	Type.GOLD:1,
	Type.SILK:4,
	Type.IVORY:0.2,
	Type.COTON:0.5,
	Type.SPICE:20,
	Type.ANIMALS:100,
	Type.SLAVES:4,
	Type.PEPPER:20
}
