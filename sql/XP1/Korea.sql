

--=======================================================================
--=                             SEOWON                                  =
--=======================================================================
-- 04/07/24 Korean rework 
-- +1 for every 2 mines
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement) VALUES
    ('BBG_Mine_Science', 'LOC_DISTRICT_MINE_SCIENCE', 'YIELD_SCIENCE', 1, 2, 'IMPROVEMENT_MINE');
INSERT INTO District_Adjacencies (DistrictType , YieldChangeId) VALUES
    ('DISTRICT_SEOWON', 'BBG_Mine_Science');
-- +1 base adj
UPDATE Adjacency_YieldChanges SET YieldChange=1 WHERE ID='BaseDistrict_Science';
-- Culture bomb
INSERT INTO TraitModifiers (TraitType, ModifierId)
    VALUES ('TRAIT_CIVILIZATION_THREE_KINGDOMS' , 'TRAIT_SEOWON_BOMB');
INSERT INTO Modifiers (ModifierId, ModifierType)
    VALUES ('TRAIT_SEOWON_BOMB', 'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('TRAIT_SEOWON_BOMB', 'DistrictType', 'DISTRICT_SEOWON');
-- Sejong get negative adjency and Theater get and give major adjency to Seowon (no more for Seondeok)
INSERT INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentDistrict)
    VALUES
    ('BBG_Theater_Science' , 'LOC_DISTRICT_SEOWON_THEATER_BONUS' , 'YIELD_SCIENCE' , '2' , '1' , 'DISTRICT_THEATER'),
    ('BBG_Seowon_Culture'  , 'LOC_DISTRICT_THEATER_SEOWON_BONUS' , 'YIELD_CULTURE' , '2' , '1' , 'DISTRICT_SEOWON' );
INSERT INTO District_Adjacencies (DistrictType , YieldChangeId) VALUES
    ('DISTRICT_SEOWON'  , 'BBG_Theater_Science'),
    ('DISTRICT_THEATER' , 'BBG_Seowon_Culture' );
INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId) VALUES
    ('TRAIT_LEADER_HWARANG', 'NegativeDistrict_Science'),
    ('TRAIT_LEADER_HWARANG', 'BBG_Theater_Science'),
    ('TRAIT_LEADER_HWARANG', 'BBG_Seowon_Culture');
INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId)
   SELECT TraitType, 'BBG_Seowon_Culture' FROM CivilizationTraits WHERE CivilizationType != 'CIVILIZATION_KOREA' GROUP BY CivilizationType;
-- +1 for every 2 district / Sejong is excluded in LP/Sejong.sql
INSERT INTO District_Adjacencies (DistrictType, YieldChangeId) VALUES
    ('DISTRICT_SEOWON', 'District_Science');

-- specialists +3 science +1 food
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_SCIENCE' AND DistrictType='DISTRICT_SEOWON';
INSERT INTO District_CitizenYieldChanges (DistrictType, YieldType, YieldChange) VALUES
    ('DISTRICT_SEOWON', 'YIELD_FOOD', 1);

-- 08/01/25 Seowon gets +2 from geothermal
INSERT INTO District_Adjacencies (DistrictType, YieldChangeId) VALUES
    ('DISTRICT_SEOWON', 'Geothermal_Science');
    
--=======================================================================
--=                            SEONDEOK                                 =
--=======================================================================

-- 04/07/24 Korean rework : Seondeok
-- Removed +3% science and culture per gov title
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_HWARANG';
-- Cities with governor get +1 amenity
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_SEONDEOK_AMENITY_WITH_GOV', 'MODIFIER_PLAYER_CITIES_ADJUST_AMENITIES_FROM_GOVERNORS', 'CITY_HAS_GOVERNOR_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_SEONDEOK_AMENITY_WITH_GOV', 'Amount', 1);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_HWARANG', 'BBG_SEONDEOK_AMENITY_WITH_GOV');

-- +20% yields to Seowon buildings for each governor title in the city
-- 07/24 to 40%
-- 04/08/24 to 30%
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_CITY_HAS_1_GOV_TITLE', 'REQUIREMENT_CITY_HAS_GOVERNOR_WITH_X_TITLES'),
    ('BBG_REQUIRES_CITY_HAS_2_GOV_TITLE', 'REQUIREMENT_CITY_HAS_GOVERNOR_WITH_X_TITLES'),
    ('BBG_REQUIRES_CITY_HAS_3_GOV_TITLE', 'REQUIREMENT_CITY_HAS_GOVERNOR_WITH_X_TITLES'),
    ('BBG_REQUIRES_CITY_HAS_4_GOV_TITLE', 'REQUIREMENT_CITY_HAS_GOVERNOR_WITH_X_TITLES'),
    ('BBG_REQUIRES_CITY_HAS_5_GOV_TITLE', 'REQUIREMENT_CITY_HAS_GOVERNOR_WITH_X_TITLES'),
    ('BBG_REQUIRES_CITY_HAS_6_GOV_TITLE', 'REQUIREMENT_CITY_HAS_GOVERNOR_WITH_X_TITLES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_CITY_HAS_1_GOV_TITLE', 'Amount', 1),
    ('BBG_REQUIRES_CITY_HAS_2_GOV_TITLE', 'Amount', 2),
    ('BBG_REQUIRES_CITY_HAS_3_GOV_TITLE', 'Amount', 3),
    ('BBG_REQUIRES_CITY_HAS_4_GOV_TITLE', 'Amount', 4),
    ('BBG_REQUIRES_CITY_HAS_5_GOV_TITLE', 'Amount', 5),
    ('BBG_REQUIRES_CITY_HAS_6_GOV_TITLE', 'Amount', 6),
    ('BBG_REQUIRES_CITY_HAS_1_GOV_TITLE', 'Established', 1),
    ('BBG_REQUIRES_CITY_HAS_2_GOV_TITLE', 'Established', 1),
    ('BBG_REQUIRES_CITY_HAS_3_GOV_TITLE', 'Established', 1),
    ('BBG_REQUIRES_CITY_HAS_4_GOV_TITLE', 'Established', 1),
    ('BBG_REQUIRES_CITY_HAS_5_GOV_TITLE', 'Established', 1),
    ('BBG_REQUIRES_CITY_HAS_6_GOV_TITLE', 'Established', 1);
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_REQUIRES_CITY_HAS_1_GOV_TITLE_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_REQUIRES_CITY_HAS_2_GOV_TITLE_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_REQUIRES_CITY_HAS_3_GOV_TITLE_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_REQUIRES_CITY_HAS_4_GOV_TITLE_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_REQUIRES_CITY_HAS_5_GOV_TITLE_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_REQUIRES_CITY_HAS_6_GOV_TITLE_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_REQUIRES_CITY_HAS_1_GOV_TITLE_REQSET', 'BBG_REQUIRES_CITY_HAS_1_GOV_TITLE'),
    ('BBG_REQUIRES_CITY_HAS_2_GOV_TITLE_REQSET', 'BBG_REQUIRES_CITY_HAS_2_GOV_TITLE'),
    ('BBG_REQUIRES_CITY_HAS_3_GOV_TITLE_REQSET', 'BBG_REQUIRES_CITY_HAS_3_GOV_TITLE'),
    ('BBG_REQUIRES_CITY_HAS_4_GOV_TITLE_REQSET', 'BBG_REQUIRES_CITY_HAS_4_GOV_TITLE'),
    ('BBG_REQUIRES_CITY_HAS_5_GOV_TITLE_REQSET', 'BBG_REQUIRES_CITY_HAS_5_GOV_TITLE'),
    ('BBG_REQUIRES_CITY_HAS_6_GOV_TITLE_REQSET', 'BBG_REQUIRES_CITY_HAS_6_GOV_TITLE');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_1_GOV_TITLE', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT', 'BBG_REQUIRES_CITY_HAS_1_GOV_TITLE_REQSET'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_2_GOV_TITLE', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT', 'BBG_REQUIRES_CITY_HAS_2_GOV_TITLE_REQSET'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_3_GOV_TITLE', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT', 'BBG_REQUIRES_CITY_HAS_3_GOV_TITLE_REQSET'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_4_GOV_TITLE', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT', 'BBG_REQUIRES_CITY_HAS_4_GOV_TITLE_REQSET'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_5_GOV_TITLE', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT', 'BBG_REQUIRES_CITY_HAS_5_GOV_TITLE_REQSET'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_6_GOV_TITLE', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT', 'BBG_REQUIRES_CITY_HAS_6_GOV_TITLE_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_1_GOV_TITLE', 'DistrictType', 'DISTRICT_CAMPUS'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_1_GOV_TITLE', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_1_GOV_TITLE', 'Amount', 30),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_2_GOV_TITLE', 'DistrictType', 'DISTRICT_CAMPUS'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_2_GOV_TITLE', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_2_GOV_TITLE', 'Amount', 30),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_3_GOV_TITLE', 'DistrictType', 'DISTRICT_CAMPUS'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_3_GOV_TITLE', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_3_GOV_TITLE', 'Amount', 30),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_4_GOV_TITLE', 'DistrictType', 'DISTRICT_CAMPUS'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_4_GOV_TITLE', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_4_GOV_TITLE', 'Amount', 30),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_5_GOV_TITLE', 'DistrictType', 'DISTRICT_CAMPUS'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_5_GOV_TITLE', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_5_GOV_TITLE', 'Amount', 30),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_6_GOV_TITLE', 'DistrictType', 'DISTRICT_CAMPUS'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_6_GOV_TITLE', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_6_GOV_TITLE', 'Amount', 30);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_HWARANG', 'BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_1_GOV_TITLE'),
    ('TRAIT_LEADER_HWARANG', 'BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_2_GOV_TITLE'),
    ('TRAIT_LEADER_HWARANG', 'BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_3_GOV_TITLE'),
    ('TRAIT_LEADER_HWARANG', 'BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_4_GOV_TITLE'),
    ('TRAIT_LEADER_HWARANG', 'BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_5_GOV_TITLE'),
    ('TRAIT_LEADER_HWARANG', 'BBG_SEONDEOK_YIELD_SEOWON_BUILDING_FOR_6_GOV_TITLE');

-- 04/07/24 Cities with no gov get -10% yields after Feudalism
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_CITY_FOUNDED_AND_NO_GOV_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_CITY_FOUNDED_AND_NO_GOV_REQSET', 'REQUIRES_NOT_CITY_HAS_GOV'),
    ('BBG_CITY_FOUNDED_AND_NO_GOV_REQSET', 'REQUIRES_CITY_WAS_FOUNDED');
INSERT INTO Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) VALUES
    ('BBG_SEONDEOK_MINUS_AFTER_FEUDALISM_SEOWON_NO_GOV', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER_GRANCOLOMBIA_MAYA', 'BBG_UTILS_PLAYER_HAS_CIVIC_FEUDALISM_REQSET', 'BBG_CITY_FOUNDED_AND_NO_GOV_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_SEONDEOK_MINUS_AFTER_FEUDALISM_SEOWON_NO_GOV', 'YieldType', 'YIELD_PRODUCTION, YIELD_FOOD, YIELD_SCIENCE, YIELD_CULTURE, YIELD_GOLD, YIELD_FAITH'),
    ('BBG_SEONDEOK_MINUS_AFTER_FEUDALISM_SEOWON_NO_GOV', 'Amount', '-10, -10, -10, -10, -10, -10');
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_HWARANG', 'BBG_SEONDEOK_MINUS_AFTER_FEUDALISM_SEOWON_NO_GOV');
    
-- 10/07/24 Feudalism grant a gov title
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_SEONDEOK_GOV_TITLE_FEUDALISM', 'MODIFIER_PLAYER_ADJUST_GOVERNOR_POINTS', 'BBG_UTILS_PLAYER_HAS_CIVIC_FEUDALISM_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_SEONDEOK_GOV_TITLE_FEUDALISM', 'Delta', 1);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_HWARANG', 'BBG_SEONDEOK_GOV_TITLE_FEUDALISM');
