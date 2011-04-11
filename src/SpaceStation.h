#ifndef _SPACESTATION_H
#define _SPACESTATION_H

#include "libs.h"
#include "ModelBody.h"
#include "ShipType.h"
#include "MarketAgent.h"
#include "ShipFlavour.h"
#include "Quaternion.h"
#include "Serializer.h"

#define MAX_DOCKING_PORTS	4

class CollMeshSet;
class Ship;
class Mission;
class CityOnPlanet;

struct SpaceStationType {
	LmrModel *model;
	const char *modelName;
	float angVel;
	enum DOCKMETHOD { SURFACE, ORBITAL } dockMethod;
	int numDockingPorts;
	int numDockingStages;
	int numUndockStages;
	double *dockAnimStageDuration;
	double *undockAnimStageDuration;
	bool dockOneAtATimePlease;
	
	struct positionOrient_t {
		vector3d pos;
		vector3d xaxis;
		vector3d yaxis;
	};

	void _ReadStageDurations(const char *key, int *outNumStages, double **durationArray);
	// read from lua model definition
	void ReadStageDurations();
	bool GetShipApproachWaypoints(int port, int stage, positionOrient_t &outPosOrient) const;
	/** when ship is on rails it returns true and fills outPosOrient.
	 * when ship has been released (or docked) it returns false.
	 * Note station animations may continue for any number of stages after
	 * ship has been released and is under player control again */
	bool GetDockAnimPositionOrient(int port, int stage, double t, const vector3d &from, positionOrient_t &outPosOrient, const Ship *ship) const;
};

/**
 * Bulletin board advert
 */
class BBAdvert {
public:
	const std::string &GetBulletinBoardText() const { return m_description; }
	const std::string &GetModule() const { return m_luaMod; }
	int GetLuaRef() const { return m_luaRef; }
	BBAdvert(const std::string &luaMod, int luaRef, const std::string &desc);
	void Save(Serializer::Writer &wr);
	static BBAdvert Load(Serializer::Reader &rd);
	bool Is(const std::string &modName, int modRef) {
		return (m_luaMod == modName) && (m_luaRef == modRef);
	}
	friend struct SortBB;
	struct SortBB {
		bool operator() (const BBAdvert &lhs, const BBAdvert &rhs) const {
			return lhs.m_sortOrder > rhs.m_sortOrder;
		}
	};
private:
	double m_sortOrder;
	std::string m_luaMod;
	int m_luaRef;
	/**
	 * This text appears in the bulletin board listing
	 */
	std::string m_description;
};

class SBody;

class SpaceStation: public ModelBody, public MarketAgent {
public:
	OBJDEF(SpaceStation, ModelBody, SPACESTATION);
	static void Init();
	enum TYPE { JJHOOP, GROUND_FLAVOURED, TYPE_MAX };
	// Should point to SBody in Pi::currentSystem
	SpaceStation(const SBody *);
	SpaceStation() {}
	virtual ~SpaceStation();
	virtual double GetBoundingRadius() const;
	virtual bool OnCollision(Object *b, Uint32 flags, double relVel);
	virtual void Render(const vector3d &viewCoords, const matrix4x4d &viewTransform);
	/** You should call Ship::Undock() rather than this.
	 * Returns true on success, false if permission denied */
	bool LaunchShip(Ship *ship, int port);
	void OrientDockedShip(Ship *ship, int port) const;
	bool GetDockingClearance(Ship *s, std::string &outMsg);
	virtual void TimeStepUpdate(const float timeStep);
	bool IsGroundStation() const;
	float GetDesiredAngVel() const;
	void AddEquipmentStock(Equip::Type t, int num) { m_equipmentStock[t] += num; }
	/* MarketAgent stuff */
	int GetStock(Equip::Type t) const { return m_equipmentStock[t]; }
	Sint64 GetPrice(Equip::Type t) const;
	bool CanBuy(Equip::Type t, bool verbose) const;
	bool CanSell(Equip::Type t, bool verbose) const;
	bool DoesSell(Equip::Type t) const;
	virtual const SBody *GetSBody() const { return m_sbody; }
	void ReplaceShipOnSale(int idx, const ShipFlavour *with);
	std::vector<ShipFlavour> &GetShipsOnSale() { return m_shipsOnSale; }
	std::vector<BBAdvert> &GetBBAdverts() { return m_bbadverts; }
	// does not dealloc
	bool BBRemoveAdvert(const std::string &modName, int modRef);
	void BBAddAdvert(const BBAdvert &a);
	virtual void PostLoadFixup();
	virtual void NotifyDeleted(const Body* const deletedBody);
	int GetFreeDockingPort(); // returns -1 if none free
	int GetMyDockingPort(const Ship *s) const {
		for (int i=0; i<MAX_DOCKING_PORTS; i++) {
			if (s == m_shipDocking[i].ship) return i;
		}
		return -1;
	}
	void SetDocked(Ship *ship, int port);
	const SpaceStationType *GetSpaceStationType() const { return m_type; }
	sigc::signal<void> onShipsForSaleChanged;
	sigc::signal<void, BBAdvert*> onBulletinBoardAdvertDeleted;
	sigc::signal<void> onBulletinBoardChanged;

	bool AllocateStaticSlot(int& slot);

protected:
	virtual void Save(Serializer::Writer &wr);
	virtual void Load(Serializer::Reader &rd);
	/* MarketAgent stuff */
	void Bought(Equip::Type t);
	void Sold(Equip::Type t);
private:
	void DoDockingAnimation(const double timeStep);
	void DoLawAndOrder();

	/* Stage 0 means docking port empty
	 * Stage 1 means docking clearance granted to ->ship
	 * Stage 2 to m_type->numDockingStages is docking animation
	 * Stage m_type->numDockingStages+1 means ship is docked
	 * Stage -1 to -m_type->numUndockStages is undocking animation
	 */
	struct shipDocking_t {
		Ship *ship;
		int stage;
		vector3d fromPos; // in station model coords
		Quaterniond fromRot;
		double stagePos; // 0 -> 1.0
	};
	shipDocking_t m_shipDocking[MAX_DOCKING_PORTS];

	double m_openAnimState[MAX_DOCKING_PORTS];
	double m_dockAnimState[MAX_DOCKING_PORTS];

	void InitStation();
	void PositionDockedShip(Ship *ship, int port);
	void UpdateShipyard();
	void UpdateBB();
	const SpaceStationType *m_type;
	const SBody *m_sbody;
	int m_equipmentStock[Equip::TYPE_MAX];
	std::vector<ShipFlavour> m_shipsOnSale;
	std::vector<BBAdvert> m_bbadverts;
	double m_lastUpdatedShipyard;
	CityOnPlanet *m_adjacentCity;
	int m_numPoliceDocked;
	bool m_staticSlot[4];
};

#endif /* _SPACESTATION_H */
