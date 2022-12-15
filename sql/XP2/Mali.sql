UPDATE Units SET Combat=53 WHERE UnitType='UNIT_MALI_MANDEKALU_CAVALRY';

DELETE FROM TraitModifiers WHERE TraitType = 'TRAIT_CIVILIZATION_MALI_GOLD_DESERT' AND ModifierId = 'TRAIT_LESS_UNIT_PRODUCTION';
DELETE FROM TraitModifiers WHERE TraitType = 'TRAIT_CIVILIZATION_MALI_GOLD_DESERT' AND ModifierId = 'TRAIT_LESS_BUILDING_PRODUCTION';

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_MALI_GOLD_DESERT', 'BBG_TRAIT_MALI_LESS_CITY_PRODUCTION'),
    ('TRAIT_CIVILIZATION_MALI_GOLD_DESERT', 'BBG_TRAIT_MALI_LESS_CHOP_PRODUCTION_GIVER'),
    ('TRAIT_CIVILIZATION_MALI_GOLD_DESERT', 'BBG_TRAIT_MALI_NORMAL_WONDER_PRODUCTION'),
    ('TRAIT_CIVILIZATION_MALI_GOLD_DESERT', 'BBG_TRAIT_MALI_NORMAL_DISTRICT_PRODUCTION'),
    ('TRAIT_CIVILIZATION_MALI_GOLD_DESERT', 'BBG_TRAIT_MALI_NORMAL_PROJECT_PRODUCTION');

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_TRAIT_MALI_LESS_CHOP_PRODUCTION_GIVER', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER'),
    ('BBG_TRAIT_MALI_LESS_CHOP_PRODUCTION', 'MODIFIER_CITY_ADJUST_RESOURCE_HARVEST_BONUS'),
    ('BBG_TRAIT_MALI_LESS_CITY_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER'),
    ('BBG_TRAIT_MALI_NORMAL_WONDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_WONDER_PRODUCTION'),
    ('BBG_TRAIT_MALI_NORMAL_DISTRICT_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_ALL_DISTRICTS_PRODUCTION'),
    ('BBG_TRAIT_MALI_NORMAL_PROJECT_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_ALL_PROJECTS_PRODUCTION');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_TRAIT_MALI_LESS_CITY_PRODUCTION', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_TRAIT_MALI_LESS_CITY_PRODUCTION', 'Amount', '-30'),
    ('BBG_TRAIT_MALI_NORMAL_WONDER_PRODUCTION', 'Amount', '43'),
    ('BBG_TRAIT_MALI_NORMAL_DISTRICT_PRODUCTION', 'Amount', '43'),
    ('BBG_TRAIT_MALI_NORMAL_PROJECT_PRODUCTION', 'Amount', '43');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_TRAIT_MALI_LESS_CHOP_PRODUCTION_GIVER', 'ModifierId', 'BBG_TRAIT_MALI_LESS_CHOP_PRODUCTION'),
    ('BBG_TRAIT_MALI_LESS_CHOP_PRODUCTION', 'Amount', '-30');

--15/12/22 Mali mines from 4 base gold to 1 getting +1 at currency, banks and economics
UPDATE ModifierArguments SET Value=1 WHERE ModifierId='TRAIT_MALI_MINES_GOLD' AND Name='Amount';

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('BBG_MINE_AND_CURRENCY', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_MINE_AND_BANKING', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_MINE_AND_ECONOMICS', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('BBG_MINE_AND_CURRENCY', 'REQUIRES_PLOT_HAS_MINE'),
    ('BBG_MINE_AND_CURRENCY', 'BBG_UTILS_PLAYER_HAS_TECH_CURRENCY_REQUIREMENT'),
    ('BBG_MINE_AND_BANKING', 'REQUIRES_PLOT_HAS_MINE'),
    ('BBG_MINE_AND_BANKING', 'BBG_UTILS_PLAYER_HAS_TECH_BANKING_REQUIREMENT'),
    ('BBG_MINE_AND_ECONOMICS', 'REQUIRES_PLOT_HAS_MINE'),
    ('BBG_MINE_AND_ECONOMICS', 'BBG_UTILS_PLAYER_HAS_TECH_ECONOMICS_REQUIREMENT');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_TRAIT_MALI_MINES_GOLD_CURRENCY', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_MINE_AND_CURRENCY'),
    ('BBG_TRAIT_MALI_MINES_GOLD_BANKING', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_MINE_AND_BANKING'),
    ('BBG_TRAIT_MALI_MINES_GOLD_ECONOMICS', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_MINE_AND_ECONOMICS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_TRAIT_MALI_MINES_GOLD_CURRENCY', 'YieldType', 'YIELD_GOLD'),
    ('BBG_TRAIT_MALI_MINES_GOLD_CURRENCY', 'Amount', '1'),
    ('BBG_TRAIT_MALI_MINES_GOLD_BANKING', 'YieldType', 'YIELD_GOLD'),
    ('BBG_TRAIT_MALI_MINES_GOLD_BANKING', 'Amount', '1'),
    ('BBG_TRAIT_MALI_MINES_GOLD_ECONOMICS', 'YieldType', 'YIELD_GOLD'),
    ('BBG_TRAIT_MALI_MINES_GOLD_ECONOMICS', 'Amount', '1');

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_MALI_GOLD_DESERT', 'BBG_TRAIT_MALI_MINES_GOLD_CURRENCY'),
    ('TRAIT_CIVILIZATION_MALI_GOLD_DESERT', 'BBG_TRAIT_MALI_MINES_GOLD_BANKING'),
    ('TRAIT_CIVILIZATION_MALI_GOLD_DESERT', 'BBG_TRAIT_MALI_MINES_GOLD_ECONOMICS');
