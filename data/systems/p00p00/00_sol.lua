local s = CustomSystem:new('Sol', { Body.Type.STAR_G })
	:govtype(Polit.GovType.EARTHDEMOC)
	:short_desc('The historical birthplace of humankind')
	:long_desc([[Sol is a fine joint]])

local sol = CustomSBody:new('Sol', Body.Type.STAR_G)
	:radius(f(1,1))
	:mass(f(1,1))
	:temp(5700)

local mercury = CustomSBody:new('Mercury', Body.Type.PLANET_TERRESTRIAL)
	:radius(f(38,100))
	:mass(f(55,1000))
	:temp(340)
	:semi_major_axis(f(387,1000))
	:eccentricity(f(205,1000))
	:inclination(math.deg2rad(7.0))
	:rotation_period(f(59,1))
	:axial_tilt(math.fixed.deg2rad(f(1,100)))
	:metallicity(f(9,10))
	:volcanicity(f(1,2))
	:atmos_density(f(0,1))
	:atmos_oxidizing(f(0,1))
	:ocean_cover(f(0,1))
	:ice_cover(f(2,100))
	:life(f(0,1))

local venus = CustomSBody:new('Venus', Body.Type.PLANET_TERRESTRIAL)
	:radius(f(95,100))
	:mass(f(815,1000))
	:temp(735)
	:semi_major_axis(f(723,1000))
	:eccentricity(f(7,1000))
	:inclination(math.deg2rad(3.39))
	:rotation_period(f(243,1))
	:axial_tilt(math.fixed.deg2rad(f(26,10)))
	:metallicity(f(1,2))
	:volcanicity(f(8,10))
	:atmos_density(f(93,1))
	:atmos_oxidizing(f(1,1))
	:ocean_cover(f(0,1))
	:ice_cover(f(0,1))
	:life(f(0,1))

local earth = CustomSBody:new('Earth', Body.Type.PLANET_TERRESTRIAL)
	:radius(f(1,1))
	:mass(f(1,1))
	:temp(288)
	:semi_major_axis(f(1,1))
	:eccentricity(f(167,10000))
	:rotation_period(f(1,1))
	:axial_tilt(math.fixed.deg2rad(f(2344,100)))
	:height_map('earth.hmap')
	:metallicity(f(1,2))
	:volcanicity(f(1,10))
	:atmos_density(f(1,1))
	:atmos_oxidizing(f(8,10))
	:ocean_cover(f(7,10))
	:ice_cover(f(7,10))
	:life(f(9,10))

local earth_starports = {
	CustomSBody:new('Shanghai', Body.Type.STARPORT_SURFACE)
		:latitude(math.deg2rad(31))
		:longitude(math.deg2rad(-121)),
	CustomSBody:new('Mexico City', Body.Type.STARPORT_SURFACE)
		:latitude(math.deg2rad(19))
		:longitude(math.deg2rad(99)),
	CustomSBody:new('London', Body.Type.STARPORT_SURFACE)
		:latitude(math.deg2rad(51))
		:longitude(0),
	CustomSBody:new('Moscow', Body.Type.STARPORT_SURFACE)
		:latitude(math.deg2rad(55))
		:longitude(math.deg2rad(-37.5)),
	CustomSBody:new('Brasilia', Body.Type.STARPORT_SURFACE)
		:latitude(math.deg2rad(-15.5))
		:longitude(math.deg2rad(48)),
	CustomSBody:new('Los Angeles', Body.Type.STARPORT_SURFACE)
		:latitude(math.deg2rad(34))
		:longitude(math.deg2rad(118)),
	CustomSBody:new('Gates Spaceport', Body.Type.STARPORT_ORBITAL)
		:semi_major_axis(f(100,100000))
		:rotation_period(f(1,24*60*3)),
}

local moon = {
	CustomSBody:new('Moon', Body.Type.PLANET_TERRESTRIAL)
		:seed(191080)
		:radius(f(273,1000))
		:mass(f(12,1000))
		:temp(220)
		:semi_major_axis(f(257,100000))
		:eccentricity(f(549,10000))
		:inclination(math.deg2rad(5.145))
		:rotation_period(f(273,10))
		:axial_tilt(math.fixed.deg2rad(f(668,100)))
		:volcanicity(f(0,1)),
	{
		CustomSBody:new('Lunar City', Body.Type.STARPORT_SURFACE)
			:latitude(math.deg2rad(19))
			:longitude(math.deg2rad(99)),
	},
}

local mars = CustomSBody:new('Mars', Body.Type.PLANET_TERRESTRIAL)
	:seed(3)
	:radius(f(533,1000))
	:mass(f(107,1000))
	:temp(278)
	:semi_major_axis(f(152,100))
	:eccentricity(f(933,10000))
	:inclination(math.deg2rad(1.85))
	:rotation_period(f(1027,1000))
	:axial_tilt(math.fixed.deg2rad(f(2519,100)))
	-- XXX composition copied from earth until there's a way to indicate terraformed
	:metallicity(f(4,5))
	:volcanicity(f(2,10))
	:atmos_density(f(3,5))
	:atmos_oxidizing(f(8,10))
	:ocean_cover(f(3,10))
	:ice_cover(f(9,10))
	:life(f(45,100))

local mars_starports = {
	CustomSBody:new('Cydonia', Body.Type.STARPORT_SURFACE)
		:latitude(math.deg2rad(-29))
		:longitude(math.deg2rad(124)),
	CustomSBody:new('Olympus Mons', Body.Type.STARPORT_SURFACE)
		:latitude(math.deg2rad(30))
		:longitude(math.deg2rad(-37)),
	CustomSBody:new('Mars High', Body.Type.STARPORT_ORBITAL)
		:semi_major_axis(f(5068,100000000))
		:rotation_period(f(11,24)),
}

local mars_moons = {
	CustomSBody:new('Phobos', Body.Type.PLANET_ASTEROID)
		:radius(f(21,10000))
		:mass(f(18,100000))
		:temp(233)
		:semi_major_axis(f(6268,100000000))
		:eccentricity(f(151,10000))
		:inclination(math.deg2rad(1.093))
		:rotation_period(f(11,24))
		:metallicity(f(4,5))
		:volcanicity(f(3,4)),
	{
		CustomSBody:new('Phobos Base', Body.Type.STARPORT_SURFACE)
			:latitude(math.deg2rad(5))
			:longitude(math.deg2rad(-5)),
	},
	CustomSBody:new('Deimos', Body.Type.PLANET_ASTEROID)
		:radius(f(12,10000))
		:mass(f(25,1000000))
		:temp(233)
		:semi_major_axis(f(1568,10000000))
		:eccentricity(f(2,10000))
		:inclination(math.deg2rad(0.93))
		:rotation_period(f(30,24))
		:metallicity(f(2,5))
		:volcanicity(f(0,1)),
	{
		CustomSBody:new('Tomm\'s Sanctuary', Body.Type.STARPORT_SURFACE),
	},
}

local jupiter = CustomSBody:new('Jupiter', Body.Type.PLANET_GAS_GIANT)
	:seed(3)
	:radius(f(11,1))
	:mass(f(3178,10))
	:temp(165)
	:semi_major_axis(f(5204,1000))
	:eccentricity(f(488,10000))
	:inclination(math.deg2rad(1.305))
	:rotation_period(f(4,10))
	:axial_tilt(math.fixed.deg2rad(f(313,100)))

local jupiter_moons = {
	CustomSBody:new('Io', Body.Type.PLANET_TERRESTRIAL)
		:radius(f(286,1000))
		:mass(f(15,1000))
		:temp(130)
		:semi_major_axis(f(282,100000))
		:eccentricity(f(41,10000))
		:inclination(math.deg2rad(2.21))
		:rotation_period(f(177,100))
		:metallicity(f(7,10))
		:volcanicity(f(1,1))
		:atmos_density(f(1,10))
		:atmos_oxidizing(f(8,10))
		:ocean_cover(f(0,1))
		:ice_cover(f(1,1000))
		:life(f(0,1)),
	{
		CustomSBody:new('Dante\'s Base', Body.Type.STARPORT_SURFACE)
			:latitude(math.deg2rad(-0.5))
			:longitude(math.deg2rad(26.2)),
	},
	CustomSBody:new('Europa', Body.Type.PLANET_TERRESTRIAL)
		:seed(5)
		:radius(f(245,1000))
		:mass(f(8,1000))
		:temp(102)
		:semi_major_axis(f(441,100000))
		:eccentricity(f(9,1000))
		:rotation_period(f(355,100))
		:ocean_cover(f(1,2))
		:atmos_density(f(1,12))
		:volcanicity(f(0,1)),
	{
		CustomSBody:new('Clarke\'s Station', Body.Type.STARPORT_ORBITAL)
			:semi_major_axis(f(12,500000))
			:rotation_period(f(1,24*60*3)),
	},
	CustomSBody:new('Ganymede', Body.Type.PLANET_TERRESTRIAL)
		:radius(f(413,1000))
		:mass(f(25,1000))
		:temp(110)
		:semi_major_axis(f(72,10000))
		:eccentricity(f(13,10000))
		:inclination(math.deg2rad(0.2))
		:atmos_density(f(1,14))
		:rotation_period(f(72,10)),
	{
		CustomSBody:new('Enki Catena', Body.Type.STARPORT_SURFACE)
			:latitude(math.deg2rad(84))
			:longitude(math.deg2rad(96)),
	},
	CustomSBody:new('Callisto', Body.Type.PLANET_TERRESTRIAL)
		:radius(f(378,1000))
		:mass(f(18,1000))
		:temp(134)
		:semi_major_axis(f(126,10000))
		:eccentricity(f(74,10000))
		:inclination(math.deg2rad(0.192))
		:rotation_period(f(167,10)),
	CustomSBody:new('Discovery Base', Body.Type.STARPORT_ORBITAL)
		:semi_major_axis(f(7,1000))
		:rotation_period(f(11,1)),
}

local saturn = CustomSBody:new('Saturn', Body.Type.PLANET_GAS_GIANT)
	:radius(f(9,1))
	:mass(f(95152,1000))
	:temp(134)
	:semi_major_axis(f(9582,1000))
	:eccentricity(f(557,10000))
	:inclination(math.deg2rad(2.485))
	:rotation_period(f(4,10))
	:axial_tilt(math.fixed.deg2rad(f(2673,100)))

local saturn_moons = {
	CustomSBody:new('Titan', Body.Type.PLANET_TERRESTRIAL)
		:radius(f(400,1000))
		:mass(f(225,10000))
		:temp(94)
		:semi_major_axis(f(82,10000))
		:eccentricity(f(288,10000))
		:inclination(math.deg2rad(0.34854))
		:atmos_density(f(10,1))
		:rotation_period(f(15945,1000)),
	{
		CustomSBody:new('Oasis City', Body.Type.STARPORT_SURFACE)
			:latitude(math.deg2rad(18.4))
			:longitude(math.deg2rad(196)),
		CustomSBody:new('Port Makenzie', Body.Type.STARPORT_SURFACE)
			:latitude(math.deg2rad(1))
			:longitude(math.deg2rad(14)),
		CustomSBody:new('Daniel\'s Haven', Body.Type.STARPORT_ORBITAL)
			:semi_major_axis(f(12,500000))
			:eccentricity(f(50,1000))
			:rotation_period(f(11,9)),
	},
	CustomSBody:new('Rhea', Body.Type.PLANET_TERRESTRIAL)
		:radius(f(12,100))
		:mass(f(39,10000))
		:temp(81)
		:semi_major_axis(f(441,100000))
		:eccentricity(f(126,100000))
		:inclination(math.deg2rad(0.345))
		:rotation_period(f(452,100))
		:atmos_density(f(1,10)),
	CustomSBody:new('Iapetus', Body.Type.PLANET_TERRESTRIAL)
		:radius(f(1155,10000))
		:mass(f(3,10000))
		:temp(115)
		:semi_major_axis(f(238,10000))
		:eccentricity(f(29,1000))
		:inclination(math.deg2rad(15.47))
		:rotation_period(f(7932,100)),
	CustomSBody:new('Dione', Body.Type.PLANET_TERRESTRIAL)
		:radius(f(881,10000))
		:mass(f(328,1000000))
		:temp(87)
		:semi_major_axis(f(252,100000))
		:eccentricity(f(22,10000))
		:inclination(math.deg2rad(0.019))
		:rotation_period(f(2737,1000)),
}

local uranus = CustomSBody:new('Uranus', Body.Type.PLANET_GAS_GIANT)
	:radius(f(4,1))
	:mass(f(145,10))
	:temp(76)
	:semi_major_axis(f(19229,1000))
	:eccentricity(f(444,10000))
	:inclination(math.deg2rad(0.772))
	:rotation_period(f(7,10))
	:axial_tilt(math.fixed.deg2rad(f(9777,100)))

local uranus_moons = {
	CustomSBody:new('Titania', Body.Type.PLANET_TERRESTRIAL)
		:radius(f(1235,10000))
		:mass(f(5908,10000000))
		:temp(70)
		:semi_major_axis(f(2913,1000000))
		:eccentricity(f(11,10000))
		:inclination(math.deg2rad(0.34))
		:rotation_period(f(87,10))
		:atmos_density(f(1,10)),
	CustomSBody:new('Oberon', Body.Type.PLANET_TERRESTRIAL)
		:radius(f(1194,10000))
		:mass(f(5046,10000000))
		:temp(75)
		:semi_major_axis(f(39,10000))
		:eccentricity(f(14,10000))
		:inclination(math.deg2rad(0.058))
		:rotation_period(f(135,10)),
	CustomSBody:new('Umbriel', Body.Type.PLANET_TERRESTRIAL)
		:radius(f(92,1000))
		:mass(f(2,10000))
		:temp(75)
		:semi_major_axis(f(178,100000))
		:eccentricity(f(39,10000))
		:inclination(math.deg2rad(0.128))
		:rotation_period(f(4144,1000)),
	CustomSBody:new('Ariel', Body.Type.PLANET_TERRESTRIAL)
		:radius(f(908,10000))
		:mass(f(226,1000000))
		:temp(60)
		:semi_major_axis(f(1277,1000000))
		:eccentricity(f(12,10000))
		:inclination(math.deg2rad(0.26))
		:rotation_period(f(252,100)),
}

local neptune = CustomSBody:new('Neptune', Body.Type.PLANET_GAS_GIANT)
	:radius(f(38,10))
	:mass(f(17147,100))
	:temp(72)
	:semi_major_axis(f(30104,1000))
	:eccentricity(f(112,10000))
	:inclination(math.deg2rad(1.768))
	:rotation_period(f(75,100))
	:axial_tilt(math.fixed.deg2rad(f(2832,100)))

local neptune_moons = {
	CustomSBody:new('Triton', Body.Type.PLANET_TERRESTRIAL)
		:radius(f(2122,10000))
		:mass(f(359,100000))
		:temp(38)
		:semi_major_axis(f(2371,100000))
		:eccentricity(f(16,1000000))
		:inclination(math.deg2rad(156.885))
		:rotation_period(f(141,24))
		:atmos_density(f(1,10)),
	{
		CustomSBody:new('Poseidon Station', Body.Type.STARPORT_ORBITAL)
			:semi_major_axis(f(12,500000))
			:rotation_period(f(11,7)),
	},
	CustomSBody:new('Nereid', Body.Type.PLANET_ASTEROID)
		:mass(f(519,1000))
		:temp(50)
		:semi_major_axis(f(3685,100000))
		:eccentricity(f(75,100))
		:inclination(math.deg2rad(32.55))
		:rotation_period(f(115,240)),
	CustomSBody:new('Proteus', Body.Type.PLANET_ASTEROID)
		:radius(f(310,10000))
		:mass(f(710,1000))
		:temp(51)
		:semi_major_axis(f(786,1000000))
		:eccentricity(f(53,100000))
		:inclination(math.deg2rad(0.524))
		:rotation_period(f(1122,1000)),
}

local pluto = CustomSBody:new('Pluto', Body.Type.PLANET_TERRESTRIAL)
	:radius(f(18,100))
	:mass(f(21,10000))
	:temp(44)
	:semi_major_axis(f(394,10))
	:eccentricity(f(249,1000))
	:inclination(math.deg2rad(11.88))
	:rotation_period(f(153,24))
	:axial_tilt(math.fixed.deg2rad(f(296,10)))

local pluto_starports = {
	CustomSBody:new('Pluto Research Base', Body.Type.STARPORT_SURFACE)
		:latitude(math.deg2rad(84))
		:longitude(math.deg2rad(96)),
}

s:bodies(sol, {
	mercury,
	venus,
	earth,
		earth_starports,
		moon,
	mars,
		mars_starports,
		mars_moons,
	jupiter,
		jupiter_moons,
	saturn,
		saturn_moons,
	uranus,
		uranus_moons,
	neptune,
		neptune_moons,
	pluto,
		pluto_starports,
})

s:add_to_sector(0,0,v(0.5,0.5,0))
