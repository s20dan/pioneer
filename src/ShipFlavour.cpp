#include "libs.h"
#include "utils.h"
#include "ShipType.h"
#include "ShipFlavour.h"
#include "Pi.h"
#include "Serializer.h"
#include "LmrModel.h"

ShipFlavour::ShipFlavour()
{
	memset(this, 0, sizeof(ShipFlavour));
}

void ShipFlavour::MakeRandomColor(LmrMaterial &m)
{
	memset(&m, 0, sizeof(LmrMaterial));
	float r = Pi::rng.Double();
	float g = Pi::rng.Double();
	float b = Pi::rng.Double();

	float invmax = 1.0f / MAX(r, MAX(g, b));

	r *= invmax;
	g *= invmax;
	b *= invmax;

	m.diffuse[0] = 0.5f * r;
	m.diffuse[1] = 0.5f * g;
	m.diffuse[2] = 0.5f * b;
	m.diffuse[3] = 1.0f;
	m.specular[0] = r;
	m.specular[1] = g;
	m.specular[2] = b;
	m.shininess = 50.0f + (float)Pi::rng.Double()*50.0f;
}

ShipFlavour::ShipFlavour(ShipType::Type type)
{
	this->type = type;
	snprintf(regid, sizeof(regid), "%c%c-%04d",
		'A' + Pi::rng.Int32(26),
		'A' + Pi::rng.Int32(26),
		Pi::rng.Int32(10000));
	price = ShipType::types[type].baseprice;
	price = price + Pi::rng.Int32(price)/64;

	MakeRandomColor(primaryColor);
	MakeRandomColor(secondaryColor);
}

void ShipFlavour::MakeTrulyRandom(ShipFlavour &v)
{
	v = ShipFlavour(static_cast<ShipType::Type>(Pi::rng.Int32(ShipType::END)));
}

void ShipFlavour::ApplyTo(LmrObjParams *p) const
{
	memset(p->argStrings[0], 0, sizeof(p->argStrings[0]));
	strncpy(p->argStrings[0], regid, sizeof(p->argStrings[0]));
	p->pMat[0] = primaryColor;
	p->pMat[1] = secondaryColor;
}

void ShipFlavour::Save()
{
	using namespace Serializer::Write;
	wr_int((int)type);
	wr_int(price);
	wr_string(regid);
}

void ShipFlavour::Load()
{
	using namespace Serializer::Read;
	type = static_cast<ShipType::Type>(rd_int());
	price = rd_int();
	rd_cstring2(regid, sizeof(regid));
}

