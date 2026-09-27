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
	Type.PEPPER:"pepper",
	Type.SILK:"soie",
	Type.IVORY:"ivoire",
	Type.COTON:"cotons",
	Type.GEMS:"gemmes",
	Type.SPICE:"epices",
	Type.ANIMALS:"chevaux",
	Type.PORCELAIN:"porcelaine",
	Type.SLAVES:"esclaves"}

const prices_old : Array[float] = [1, 20, 4, 0.2, 0.5, 0, 20, 100]
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
