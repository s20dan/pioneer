#ifndef _STARSYSTEM_H
#define _STARSYSTEM_H

#include "libs.h"
#include "EquipType.h"
#include "Polit.h"
#include "SysLoc.h"
#include "Serializer.h"
#include <vector>
#include <string>
#include "mylua.h"

struct CustomSBody;
struct CustomSystem;
class SBody;

// doubles: all masses in Kg, all lengths in meters
// fixed: any mad scheme

enum {  ECON_MINING = (1<<0), 
	ECON_AGRICULTURE = (1<<1), 
	ECON_INDUSTRY = (1<<2) };	

class StarSystem;

struct Orbit {
	vector3d OrbitalPosAtTime(double t);
	// 0.0 <= t <= 1.0. Not for finding orbital pos
	vector3d EvenSpacedPosAtTime(double t);
	/* duplicated from SBody... should remove probably */
	double eccentricity;
	double semiMajorAxis;
	/* dup " " --------------------------------------- */
	double period; // seconds
	matrix4x4d rotMatrix;
};

#define SBODYPATHLEN	8

class SBodyPath: public SysLoc {
public:
	SBodyPath();
	SBodyPath(int sectorX, int sectorY, int systemNum);
	SBodyPath(const SBodyPath &p) {
		sectorX = p.sectorX;
		sectorY = p.sectorY;
		systemNum = p.systemNum;
		sbodyId = p.sbodyId;
	}
	Uint32 sbodyId;
	
	void Serialize(Serializer::Writer &wr) const;
	static void Unserialize(Serializer::Reader &rd, SBodyPath *path);
	
	bool operator== (const SBodyPath b) const {
		return (sbodyId == b.sbodyId) && (sectorX == b.sectorX) && (sectorY == b.sectorY) && (systemNum == b.systemNum);
	}
	/** These are for the Lua wrappers -- best not to use them from C++
	 * since they acquire a StarSystem object in a rather sub-optimal way */
	const char *GetBodyName() const;
	Uint32 GetSeed() const;
	int GetType() const;
	int GetSuperType() const;
	SysLoc GetSystem() const { return (SysLoc)*this; }
	int GetNumChildren() const;
	/** Caller owns the returned SBodyPath* */
	SBodyPath *GetParent() const;
	SBodyPath *GetNthChild(int n) const;
private:
	/** Returned SBody only valid pointer for duration described in
	 * StarSystem::GetCached comment */
	const SBody *GetSBody() const;
};

OOLUA_CLASS(SBodyPath): public Proxy_class<SysLoc>
	OOLUA_BASIC
	OOLUA_TYPEDEFS
		OOLUA::Equal_op
	OOLUA_END_TYPES
	OOLUA_ONLY_DEFAULT_CONSTRUCTOR
	OOLUA_BASES_START SysLoc OOLUA_BASES_END
	OOLUA_MEM_FUNC_0_CONST(const char *, GetBodyName)
	OOLUA_MEM_FUNC_0_CONST(Uint32, GetSeed)
	OOLUA_MEM_FUNC_0_CONST(SysLoc, GetSystem);
	OOLUA_MEM_FUNC_0_CONST(lua_out_p<SBodyPath*>, GetParent);
	OOLUA_MEM_FUNC_0_CONST(int, GetNumChildren)
	OOLUA_MEM_FUNC_1_CONST(lua_out_p<SBodyPath*>, GetNthChild, int);
	OOLUA_MEM_FUNC_0_CONST(int, GetType)
	OOLUA_MEM_FUNC_0_CONST(int, GetSuperType)
OOLUA_CLASS_END

class SBody {
public:
	SBody();
	~SBody();
	void PickPlanetType(StarSystem *, MTRand &rand);
	const SBody *FindStarAndTrueOrbitalRange(fixed &orbMin, fixed &orbMax);
	SBody *parent;
	std::vector<SBody*> children;

	/** XXX Keep in sync with data/pimodule.lua
	  * Hence the redundant numbers */
	enum BodyType {
		TYPE_GRAVPOINT = 0,
		TYPE_BROWN_DWARF = 1,
		TYPE_STAR_M = 2,
		TYPE_STAR_K = 3,
		TYPE_STAR_G = 4,
		TYPE_STAR_F = 5,
		TYPE_STAR_A = 6,
		TYPE_STAR_B = 7,
		TYPE_STAR_O = 8,
		TYPE_STAR_M_GIANT = 9,
		TYPE_WHITE_DWARF = 10,
		TYPE_PLANET_GAS_GIANT = 11,
		TYPE_PLANET_ASTEROID = 12,
		TYPE_PLANET_TERRESTRIAL = 13,
		TYPE_STARPORT_ORBITAL = 14,
		TYPE_STARPORT_SURFACE = 15,
		TYPE_MIN = TYPE_BROWN_DWARF,
		TYPE_MAX = TYPE_STARPORT_SURFACE,
		TYPE_STAR_MIN = TYPE_BROWN_DWARF,
		TYPE_STAR_MAX = TYPE_WHITE_DWARF
		// XXX need larger atmosphereless thing
	};
	
	/** XXX Keep in sync with data/pimodule.lua
	  * Hence the redundant numbers */
	enum BodySuperType {
		SUPERTYPE_NONE = 0,
		SUPERTYPE_STAR = 1,
		SUPERTYPE_ROCKY_PLANET = 2,
		SUPERTYPE_GAS_GIANT = 3,
		SUPERTYPE_STARPORT = 4
	};

	std::string GetAstroDescription();
	const char *GetIcon();
	BodySuperType GetSuperType() const;
	double GetRadius() const {
		if (GetSuperType() <= SUPERTYPE_STAR)
			return radius.ToDouble() * SOL_RADIUS;
		else
			return radius.ToDouble() * EARTH_RADIUS;
	}
	double GetMass() const {
		if (GetSuperType() <= SUPERTYPE_STAR)
			return mass.ToDouble() * SOL_MASS;
		else
			return mass.ToDouble() * EARTH_MASS;
	}
	fixed GetMassInEarths() const {
		if (GetSuperType() <= SUPERTYPE_STAR)
			return mass * 332998;
		else
			return mass;
	}
	// returned in seconds
	double GetRotationPeriod() const {
		return rotationPeriod.ToDouble()*60*60*24;
	}
	fixed CalcHillRadius() const;

	double GetMaxChildOrbitalDistance() const;
	void PopulateStage1(StarSystem *system, fixed &outTotalPop);
	void PopulateAddStations(StarSystem *system);

	Uint32 id; // index into starsystem->m_bodies
	int tmp;
	Orbit orbit;
	Uint32 seed; // Planet.cpp can use to generate terrain
	std::string name;
	fixed radius; 
	fixed mass; // earth masses if planet, solar masses if star
	fixed orbMin, orbMax; // periapsism, apoapsis in AUs
	fixed rotationPeriod; // in days
	fixed humanActivity; // 0 - 1
	fixed semiMajorAxis; // in AUs
	fixed eccentricity;
	fixed axialTilt; // in radians
	int averageTemp;
	BodyType type;

	/* composition */
	fixed m_metallicity; // (crust) 0.0 = light (Al, SiO2, etc), 1.0 = heavy (Fe, heavy metals)
	fixed m_oreAbundance; // ore decided in metallicity, this decides quantity of said ore. 0= marginal, 1= abundant
	fixed m_volatileGas; // 1.0 = earth atmosphere density
	fixed m_volatileLiquid; // 1.0 = 100% ocean cover (earth = 70%)
	fixed m_volatileIces; // 1.0 = 100% ice cover (earth = 3%)
	fixed m_volcanicity; // 0 = none, 1.0 = fucking volcanic
	fixed m_atmosOxidizing; // 0.0 = reducing (H2, NH3, etc), 1.0 = oxidising (CO2, O2, etc)
	fixed m_life; // 0.0 = dead, 1.0 = teeming
	
	/* economy type stuff */
	fixed m_population;
	fixed m_agricultural;

	const char *heightMapFilename;

private:
};

class StarSystem {
public:
	friend class SBody;
	StarSystem() { rootBody = 0; }
	StarSystem(int sector_x, int sector_y, int system_idx);
	~StarSystem();
	/** Holding pointers to StarSystem returned by this is not safe between
	 * calls to ShrinkCache() (done at end of Pi main loop)
	 */
	static StarSystem *GetCached(const SysLoc &s);
	static void ShrinkCache();

	const std::string &GetName() const { return m_name; }
	void GetPathOf(const SBody *body, SBodyPath *path) const;
	SBody *GetBodyByPath(const SBodyPath *path) const;
	static void Serialize(Serializer::Writer &wr, StarSystem *);
	static StarSystem *Unserialize(Serializer::Reader &rd);
	void Dump();
	bool IsSystem(int sector_x, int sector_y, int system_idx);
	int SectorX() const { return m_loc.sectorX; }
	int SectorY() const { return m_loc.sectorY; }
	int SystemIdx() const { return m_loc.systemNum; }
	const SysLoc &GetLocation() const { return m_loc; }
	void GetPos(int *sec_x, int *sec_y, int *sys_idx) const {
		*sec_x = m_loc.sectorX; *sec_y = m_loc.sectorY; *sys_idx = m_loc.systemNum;
	}
	const char *GetShortDescription() const { return m_shortDesc.c_str(); }
	const char *GetLongDescription() const { return m_longDesc.c_str(); }
	int GetNumStars() const { return m_numStars; }
	bool GetRandomStarport(MTRand &rand, SBodyPath *outDest) const;
	bool GetRandomStarportNearButNotIn(MTRand &rand, SBodyPath *outDest) const;
	const SysPolit &GetSysPolit() const { return m_polit; }

	static float starColors[][3];
	static float starRealColors[][3];
	static double starLuminosities[];
	static fixed starMetallicities[];

	struct BodyStats {

	};

	SBody *rootBody;
	std::vector<SBody*> m_spaceStations;
	// index into this will be the SBody ID used by SBodyPath
	std::vector<SBody*> m_bodies;
	
	fixed m_metallicity;
	fixed m_oreAbundance;
	fixed m_industrial;
	fixed m_agricultural;

	fixed m_humanProx;
	fixed m_totalPop;
	// percent price alteration
	int m_tradeLevel[Equip::TYPE_MAX];
	int m_econType;
	int m_techlevel; /* 0-5 like in EquipType.h */
	int m_seed;

	bool m_unexplored;
	
	int GetCommodityBasePriceModPercent(int t) {
		return m_tradeLevel[t];
	}
private:
	SBody *NewBody() {
		SBody *body = new SBody;
		body->id = m_bodies.size();
		m_bodies.push_back(body);
		return body;
	}
	void MakeShortDescription(MTRand &rand);
	void MakePlanetsAround(SBody *primary, MTRand &rand);
	void MakeRandomStar(SBody *sbody, MTRand &rand);
	void MakeStarOfType(SBody *sbody, SBody::BodyType type, MTRand &rand);
	void MakeStarOfTypeLighterThan(SBody *sbody, SBody::BodyType type, fixed maxMass, MTRand &rand);
	void MakeBinaryPair(SBody *a, SBody *b, fixed minDist, MTRand &rand);
	void CustomGetKidsOf(SBody *parent, const std::list<CustomSBody> *children, int *outHumanInfestedness, MTRand &rand);
	void GenerateFromCustom(const CustomSystem *, MTRand &rand);
	void Populate(bool addSpaceStations);

	SysLoc m_loc;
	int m_numStars;
	std::string m_name;
	std::string m_shortDesc, m_longDesc;
	SysPolit m_polit;
};
	
#endif /* _STARSYSTEM_H */
