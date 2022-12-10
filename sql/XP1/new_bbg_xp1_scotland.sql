-- Created by iElden

--==================
-- Scotland
--==================
-- Highlander gets +10 combat strength (defense)
UPDATE Units SET Combat=65, RangedCombat=70 WHERE UnitType='UNIT_SCOTTISH_HIGHLANDER';

-- Change Bannockburn to +1 movement for recon and civilian units
Delete From TraitModifiers where ModifierId in (
	'TRAIT_LIBERATION_WAR_PRODUCTION',
	'TRAIT_LIBERATION_WAR_MOVEMENT',
	'TRAIT_LIBERATION_WAR_PREREQ_OVERRIDE'
);

INSERT INTO Types(Type, Kind) VALUES
    ('TRAIT_BANNOCKBURN_EXTRA_MOVEMENT', 'KIND_ABILITY');
INSERT INTO TypeTags(Type, Tag) VALUES
    ('TRAIT_BANNOCKBURN_EXTRA_MOVEMENT', 'CLASS_RECON');
    ('TRAIT_BANNOCKBURN_EXTRA_MOVEMENT', 'CLASS_LANDCIVILIAN');
INSERT INTO UnitAbilities(UnitAbilityType, Name, Description, Inactive) VALUES
    ('TRAIT_BANNOCKBURN_EXTRA_MOVEMENT', 'TRAIT_BANNOCKBURN_EXTRA_MOVEMENT_NAME', 'TRAIT_BANNOCKBURN_EXTRA_MOVEMENT_DESC', 1);
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('TRAIT_BANNOCKBURN_EXTRA_MOVEMENT', 'TRAIT_BANNOCKBURN_EXTRA_MOVEMENT_MODIFIER');
INSERT INTO Modifiers(ModifierId, ModifierType, Permanent) VALUES
    ('RECON_AND_CIVILIAN_EXTRA_MOVEMENT', 'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS', 0),
    ('TRAIT_BANNOCKBURN_EXTRA_MOVEMENT_MODIFIER', 'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT', 1);
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('RECON_AND_CIVILIAN_EXTRA_MOVEMENT', 'AbilityType', 'TRAIT_BANNOCKBURN_EXTRA_MOVEMENT'),
    ('TRAIT_BANNOCKBURN_EXTRA_MOVEMENT_MODIFIER', 'Amount', '1');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_BANNOCKBURN', 'RECON_AND_CIVILIAN_EXTRA_MOVEMENT');

--============================
-- Golf Course Related Changes
--============================

-- Golf Course moved to Games and Recreation
UPDATE Improvements SET PrereqCivic='CIVIC_GAMES_RECREATION' WHERE ImprovementType='IMPROVEMENT_GOLF_COURSE';
-- Golf Course base yields are 1 Culture and 2 Gold... +1 to each if next to City Center
UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_GOLF_COURSE' AND YieldType='YIELD_CULTURE';
-- Golf Course extra housing moved to Urbanization
UPDATE RequirementArguments SET Value='CIVIC_URBANIZATION' WHERE RequirementId='REQUIRES_PLAYER_HAS_GLOBALIZATION' AND Name='CivicType';
INSERT OR IGNORE INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentDistrict)
	VALUES ('BBG_GOLFCOURSE_CITYCENTERADJACENCY_GOLD' , 'Placeholder' , 'YIELD_GOLD' , 1 , 1 , 'DISTRICT_CITY_CENTER');
INSERT OR IGNORE INTO Improvement_Adjacencies (ImprovementType , YieldChangeId)
	VALUES ('IMPROVEMENT_GOLF_COURSE' , 'BBG_GOLFCOURSE_CITYCENTERADJACENCY_GOLD');
-- Golf Course gets extra yields a bit earlier
INSERT OR IGNORE INTO Improvement_BonusYieldChanges (Id , ImprovementType , YieldType , BonusYieldChange , PrereqCivic)
	VALUES ('204' , 'IMPROVEMENT_GOLF_COURSE' , 'YIELD_GOLD' , '1' , 'CIVIC_THE_ENLIGHTENMENT');
INSERT OR IGNORE INTO Improvement_BonusYieldChanges (Id , ImprovementType , YieldType , BonusYieldChange , PrereqCivic)
	VALUES ('205' , 'IMPROVEMENT_GOLF_COURSE' , 'YIELD_CULTURE' , '1' , 'CIVIC_THE_ENLIGHTENMENT');
-- golf Course +1 amentity Base
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='GOLFCOURSE_AMENITIES' AND Name='Amount';
-- Golf Course +1 amentity if next to an entertainment complex
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_GOLF_COURSE_AMENITIES_ENTERTAINMENT_COMPLEX_MODIFIER', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_AMENITY', 'BBG_NEXT_TO_ENTERTAINMENT_COMPLEX_REQUIREMENTS');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_GOLF_COURSE_AMENITIES_ENTERTAINMENT_COMPLEX_MODIFIER', 'Amount', '1');
INSERT OR IGNORE INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
	('BBG_NEXT_TO_ENTERTAINMENT_COMPLEX_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
	('BBG_NEXT_TO_ENTERTAINMENT_COMPLEX_REQUIREMENTS', 'BBG_NEXT_TO_ENTERTAINMENT_COMPLEX_REQUIREMENT');
INSERT OR IGNORE INTO Requirements(RequirementId , RequirementType) VALUES
	('BBG_NEXT_TO_ENTERTAINMENT_COMPLEX_REQUIREMENT' , 'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments(RequirementId , Name, Value) VALUES
	('BBG_NEXT_TO_ENTERTAINMENT_COMPLEX_REQUIREMENT' , 'DistrictType', 'DISTRICT_ENTERTAINMENT_COMPLEX');
INSERT INTO ImprovementModifiers(ImprovementType, ModifierId) VALUES
    ('IMPROVEMENT_GOLF_COURSE', 'BBG_GOLF_COURSE_AMENITIES_ENTERTAINMENT_COMPLEX_MODIFIER');
-- Golf Course +1 additional amentity once Guilds is unlocked 
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('GOLF_COURSE_AMENTITY_AT_GUILDS', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_AMENITY', 'PLAYER_HAS_GUILDS_REQUIREMENTS');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('GOLF_COURSE_AMENTITY_AT_GUILDS', 'Amount', '1');
INSERT INTO ImprovementModifiers(ImprovementType, ModifierId) VALUES
    ('IMPROVEMENT_GOLF_COURSE', 'GOLF_COURSE_AMENTITY_AT_GUILDS');
-- Firaxis bugfix: Golf course have 2 modifiers : GOLFCOURSE_AMENITIES and GOLFCOURSE_AMENITY.
DELETE FROM ImprovementModifiers WHERE ImprovementType='IMPROVEMENT_GOLF_COURSE' AND ModifierId='GOLFCOURSE_AMENITY';