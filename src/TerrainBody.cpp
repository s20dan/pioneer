#include "TerrainBody.h"
#include "GeoSphere.h"
#include "Pi.h"
#include "render/Render.h"
#include "WorldView.h"
#include "Frame.h"

TerrainBody::TerrainBody(SBody *sbody) :
	Body(), 
	m_sbody(0), 
	m_pos(vector3d(0,0,0)), 
	m_mass(0), 
	m_geosphere(0)
{
	InitTerrainBody(sbody);
}

TerrainBody::TerrainBody() :
	Body(), 
	m_sbody(0), 
	m_pos(vector3d(0,0,0)), 
	m_mass(0), 
	m_geosphere(0)
{
}

TerrainBody::~TerrainBody()
{
	if (m_geosphere)
		delete m_geosphere;
}


void TerrainBody::InitTerrainBody(SBody *sbody)
{
	assert(!m_sbody);
	m_sbody = sbody;
	m_mass = m_sbody->GetMass();
	if (!m_geosphere)
		m_geosphere = new GeoSphere(sbody);
}

void TerrainBody::Save(Serializer::Writer &wr)
{
	Body::Save(wr);
	wr.Vector3d(m_pos);
	wr.Int32(Serializer::LookupSystemBody(m_sbody));
}

void TerrainBody::Load(Serializer::Reader &rd)
{
	Body::Load(rd);
	m_pos = rd.Vector3d();
	SBody *sbody = Serializer::LookupSystemBody(rd.Int32());
	InitTerrainBody(sbody);
}

double TerrainBody::GetBoundingRadius() const
{
	// needs to include all terrain so culling works {in the future},
	// and size of rotating frame is correct
	return m_sbody->GetRadius() * (1.1+m_geosphere->GetMaxFeatureHeight());
}

void TerrainBody::Render(const vector3d &viewCoords, const matrix4x4d &viewTransform)
{
	matrix4x4d ftran = viewTransform;
	vector3d fpos = viewCoords;
	double rad = m_sbody->GetRadius();

	float znear, zfar;
	Pi::worldView->GetNearFarClipPlane(&znear, &zfar);

	double len = fpos.Length();
	int shrink = 0;
	double scale = 1.0f;

	double dist_to_horizon;
	for (;;) {
		if (len < rad) break;		// player inside radius case
		dist_to_horizon = sqrt(len*len - rad*rad);

		if (dist_to_horizon < zfar*0.5) break;

		rad *= 0.25;
		fpos = 0.25*fpos;
		len *= 0.25;
		scale *= 4.0f;
		shrink++;
	}
	//if (GetLabel() == "Earth") printf("Horizon %fkm, shrink %d\n", dist_to_horizon*0.001, shrink);

	glPushMatrix();		// initial matrix is actually identity after a long chain of wtf
//	glTranslatef(float(fpos.x), float(fpos.y), float(fpos.z));
	glColor3f(1,1,1);

	{
		vector3d campos = fpos;
		ftran.ClearToRotOnly();
		campos = ftran.InverseOf() * campos;
		glMultMatrixd(&ftran[0]);
		glEnable(GL_NORMALIZE);
		glScaled(rad, rad, rad);			// rad = real_rad / scale
		campos = campos * (1.0/rad);		// position of camera relative to planet "model"

		// translation not applied until patch render to fix jitter
		m_geosphere->Render(-campos, m_sbody->GetRadius(), scale);
		glTranslated(campos.x, campos.y, campos.z);

		//if (m_sbody->GetSuperType() == SBody::SUPERTYPE_GAS_GIANT) DrawGasGiantRings();
		
		//if (!Render::AreShadersEnabled()) DrawAtmosphere(campos);
		
		glDisable(GL_NORMALIZE);
		
		// if not using shader then z-buffer precision is hopeless and
		// we can't place objects on the terrain without awful z artifacts
		if (shrink || !Render::AreShadersEnabled()) {
			glClear(GL_DEPTH_BUFFER_BIT);
		}
	}
	glPopMatrix();
}

void TerrainBody::SetFrame(Frame *f)
{
	if (GetFrame()) {
		GetFrame()->SetPlanetGeom(0, 0);
	}
	Body::SetFrame(f);
	if (f) {
		GetFrame()->SetPlanetGeom(0, 0);
	}
}

double TerrainBody::GetTerrainHeight(const vector3d pos_) const
{
	double radius = m_sbody->GetRadius();
	if (m_geosphere) {
		return radius * (1.0 + m_geosphere->GetHeight(pos_));
	} else {
		assert(0);
		return radius;
	}
}

bool TerrainBody::IsSuperType(SBody::BodySuperType t) const
{
	if (!m_sbody) return false;
	else return m_sbody->GetSuperType() == t;
}