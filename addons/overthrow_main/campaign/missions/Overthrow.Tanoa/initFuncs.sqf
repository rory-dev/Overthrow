//Helper functions
totalCarry = compileFinal preProcessFileLineNumbers "funcs\totalCarry.sqf";
searchStock = compileFinal preProcessFileLineNumbers "funcs\searchStock.sqf";
dumpStuff = compileFinal preProcessFileLineNumbers "funcs\dumpStuff.sqf";
takeStuff = compileFinal preProcessFileLineNumbers "funcs\takeStuff.sqf";
progressBar = compileFinal preProcessFileLineNumbers "funcs\progressBar.sqf";
revealToNATO = compileFinal preProcessFileLineNumbers "funcs\revealToNATO.sqf";
revealToCRIM = compileFinal preProcessFileLineNumbers "funcs\revealToCRIM.sqf";

intelEvent = compileFinal preProcessFileLineNumbers "funcs\intelEvent.sqf";
intelLevel = compileFinal preProcessFileLineNumbers "funcs\intelLevel.sqf";
playerDecision = compileFinal preProcessFileLineNumbers "funcs\playerDecision.sqf";

//UI
buildMenu = compileFinal preProcessFileLineNumbers "UI\buildMenu.sqf";
manageRecruits = compileFinal preProcessFileLineNumbers "UI\manageRecruits.sqf";
characterSheet = compileFinal preProcessFileLineNumbers "UI\characterSheet.sqf";
buyVehicleDialog = compileFinal preProcessFileLineNumbers "UI\buyVehicleDialog.sqf";
gunDealerDialog = compileFinal preProcessFileLineNumbers "UI\gunDealerDialog.sqf";

template_playerDesk = [] call compileFinal preProcessFileLineNumbers "templates\playerdesk.sqf";
template_checkpoint = [] call compileFinal preProcessFileLineNumbers "templates\NATOcheckpoint.sqf";

[] call compileFinal preProcessFileLineNumbers "funcs\dict.sqf";

//Events
illegalContainerOpened = compileFinal preProcessFileLineNumbers "events\illegalContainerOpened.sqf";

//Insertion
reGarrisonTown = compileFinal preProcessFileLineNumbers "spawners\insertion\reGarrisonTown.sqf";
sendCrims = compileFinal preProcessFileLineNumbers "spawners\insertion\sendCrims.sqf";
newLeader = compileFinal preProcessFileLineNumbers "spawners\insertion\newLeader.sqf";

//Local interactions
initObjectLocal = compileFinal preProcessFileLineNumbers "interaction\initObjectLocal.sqf";
initStaticMGLocal = compileFinal preProcessFileLineNumbers "interaction\initStaticMGLocal.sqf";

//Actions
leaseBuilding = compileFinal preProcessFileLineNumbers "actions\leaseBuilding.sqf";
recruitSoldier = compileFinal preProcessFileLineNumbers "actions\recruitSoldier.sqf";
recruitSquad = compileFinal preProcessFileLineNumbers "actions\recruitSquad.sqf";
setHome = compileFinal preProcessFileLineNumbers "actions\setHome.sqf";
import = compileFinal preProcessFileLineNumbers "actions\import.sqf";
restoreLoadout = compileFinal preProcessFileLineNumbers "actions\restoreLoadout.sqf";
removeLoadout = compileFinal preProcessFileLineNumbers "actions\removeLoadout.sqf";


//Modes
placementMode = compileFinal preProcessFileLineNumbers "actions\placementMode.sqf";

//Wanted System
unitSeen = compileFinal preProcessFileLineNumbers "funcs\unitSeen.sqf";
unitSeenCRIM = compileFinal preProcessFileLineNumbers "funcs\unitSeenCRIM.sqf";
unitSeenNATO = compileFinal preProcessFileLineNumbers "funcs\unitSeenNATO.sqf";
unitSeenAny = compileFinal preProcessFileLineNumbers "funcs\unitSeenAny.sqf";
wantedSystem = compileFinal preProcessFileLineNumbers "wantedSystem.sqf";

//Other Systems
perkSystem = compileFinal preProcessFileLineNumbers "perkSystem.sqf";
statsSystem = compileFinal preProcessFileLineNumbers "stats.sqf";
intelSystem = compileFinal preProcessFileLineNumbers "intelSystem.sqf";

//Key handler
keyHandler = compileFinal preProcessFileLineNumbers "keyHandler.sqf";
menuHandler = {};

//Credit to John681611: http://www.armaholic.com/page.php?id=25720
mpAddEventHand = {
private["_obj","_type","_code"];
_obj = _this select 0;
_type = _this select 1;
_code = _this select 2;
_add = _obj addEventHandler [_type,_code];
};
mpRemoveEventHand = {
private["_obj","_type","_index"];
_obj = _this select 0;
_type = _this select 1;
_index = _this select 2;
_obj removeEventHandler [_type, _index];
};
AUG_GetIn = {
	_aug = (_this select 0) getVariable["AUG_Attached",false];
	if((count (crew _aug)) > 0) exitWith {hint 'Weapon must be empty to mount';};
	(_this select 1) moveInGunner _aug;
};
AUG_UpdateState = {
	//Update Action
	[(_this select 0),((_this select 0) getVariable "AUG_Act")] call BIS_fnc_holdActionRemove;
 	_ls = [ (_this select 0),(_this select 1),
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",
				"speed _target <= 1 AND speed _target >= -1 AND _target distance _this < 5 AND vehicle _this == _this AND ( typeNAME (_target getVariable 'AUG_Attached') != 'BOOL' OR typeNAME (_target getVariable 'AUG_Local') != 'BOOL')",
				"true",
					(_this select 1),"Acts_carFixingWheel"] remoteExec ["playMoveNow",(_this select 1),false]
					,{},
					{[(_this select 1),""] remoteExec ["switchMove",(_this select 1),false];[(_this select 0)] Call AUG_Action;},
					[{[(_this select 1),""] remoteExec ["switchMove",(_this select 1),false];},[],13,1.5,false,false] Call BIS_fnc_holdActionAdd;
	(_this select 0) setVariable ["AUG_Act",_ls,false];

};
AUG_UpdateGetInState = {
	//Update Action
	(_this select 0) setUserActionText [(_this select 0) getVariable ["AUG_Act_GetIn",""],(_this select 1),(_this select 2)];
};
AUG_Action = {
	_veh = (_this select 0);
	if( typeNAME(_veh getVariable["AUG_Attached",false]) == "OBJECT")  then {
		[_veh,(_this select 1)] call AUG_Detach;
	}else{
		[_veh,(_this select 1)] call AUG_Attach;

	}
};
AUG_AddAction = {
	// mp issues may occure
	_ls = [ (_this select 0),"","","","speed _target <= 1 AND speed _target >= -1 AND _target distance _this < 5  AND vehicle _this == _this AND ( typeNAME (_target getVariable 'AUG_Attached') != 'BOOL' OR typeNAME (_target getVariable 'AUG_Local') != 'BOOL')","true",{},{},{},{},[],13,nil,false,false] call BIS_fnc_holdActionAdd;
	_vls = (_this select 0) addAction ["", {[(_this select 0),(_this select 1)] spawn AUG_GetIn;},[],5.5,true,true,"","typeNAME (_target getVariable 'AUG_Attached') != 'BOOL' AND _target distance _this < 5"];
	(_this select 0) setVariable ["AUG_Act",_ls,false];
	(_this select 0) setVariable ["AUG_Act_GetIn",_vls,false];
	(_this select 0) setVariable["AUG_Attached",false,true];
	(_this select 0) setVariable["AUG_Local",false,true];
};

mpSetDir = {
	params ["_obj","_dir"];
	if !(isNil "_dir") then {
		_obj setDir _dir;
	};
};

structureInit = {
	private _veh = _this select 0;
	private _pos = _this select 1;
	private _code = compileFinal preProcessFileLineNumbers (_this select 2);
	[_pos,_veh] spawn _code;
};

blackFaded = {
	_txt = format ["<t size='0.5' color='#000000'>Please wait... %1</t>",_this];
    [_txt, 0, 0.2, 30, 0, 0, 2] spawn bis_fnc_dynamicText;
};

canDrive = {
	((_this getHitPointDamage "HitLFWheel") < 1) and
	((_this getHitPointDamage "HitLF2Wheel") < 1) and
	((_this getHitPointDamage "HitRFWheel") < 1) and
	((_this getHitPointDamage "HitRF2Wheel") < 1) and
	((_this getHitPointDamage "HitFuel") < 1) and
	((_this getHitPointDamage "HitEngine") < 1)
};

setupKeyHandler = {
    waitUntil {!(isnull (findDisplay 46))};
    sleep 1;
    (findDisplay 46) displayAddEventHandler ["KeyDown",keyHandler];
};

assignedKey = {
	(cba_keybinding_keynames) getVariable [str ((actionKeys _this) select 0),""];
};

influence = {
	if!(hasInterface) exitWith {};
    _totalrep = (player getVariable ["influence",0])+_this;
    player setVariable ["influence",_totalrep,true];
	_plusmin = "";
    if(_this > 0) then {
        _plusmin = "+";
    };
	if(_this != 0) then {
        format["%1%2 Influence",_plusmin,_this] call OT_fnc_notifyMinor;
    };
};

influenceSilent = {
	if!(hasInterface) exitWith {};
    _totalrep = (player getVariable ["influence",0])+_this;
    player setVariable ["influence",_totalrep,true];
};

stopAndFace = {
	(_this select 0) disableAI "PATH";
	(group (_this select 0)) setFormDir (_this select 1);
	(_this select 0) spawn {
		_ti = 0;
		waitUntil {sleep 1;_ti = _ti + 1;(!(_this getVariable["OT_talking",false]) and isNull (findDisplay 8001) and isNull (findDisplay 8002)) or _ti > 20};
		_this remoteExec ['restartAI',2];
	};
};

restartAI = {
	_this enableAI "PATH";
};

rewardMoney = {
	_who = _this select 0;
	_amount = _this select 1;
	if(isPlayer _who) then {
		[_amount] remoteExec ["money",_who,false];
	}else{
		if((side _who) == resistance) then {
			//we spread it amongst everyone
			_perPlayer = round(_amount / count([] call CBA_fnc_players));
			if(_perPlayer > 0) then {
				{
					[_perPlayer] remoteExec ["money",_x,false];
				}foreach([] call CBA_fnc_players);
			};
		};
	};
};

money = {
	if!(hasInterface) exitWith {};
    _amount = _this select 0;
    _rep = (player getVariable ["money",0])+_amount;
    if(_rep < 0) then {
        _rep = 0;
    };
    player setVariable ["money",_rep,true];
    playSound "3DEN_notificationDefault";
    _plusmin = "";
    if(_amount > 0) then {
        _plusmin = "+";
    };
	if(count _this > 1) then {
		format["%3: %1$%2",_plusmin,[_amount, 1, 0, true] call CBA_fnc_formatNumber,_this select 1] call OT_fnc_notifyMinor;
	}else{
		format["%1$%2",_plusmin,[_amount, 1, 0, true] call CBA_fnc_formatNumber] call OT_fnc_notifyMinor;
	};
};

stability = {
    _town = _this select 0;
	if !(_town in OT_allTowns) exitWith{};

    _townmrk = format["%1-abandon",_town];
    _stability = (server getVariable [format["stability%1",_town],0])+(_this select 1);
    if(_stability < 0) then {_stability = 0};
	if(_stability > 100) then {_stability = 100};
    server setVariable [format["stability%1",_town],_stability,true];

    _abandoned = server getVariable "NATOabandoned";
    if(_town in _abandoned) then {
        _townmrk setMarkerAlpha 1;
    }else{
        _townmrk setMarkerAlpha 0;
    };

	_garrison = server getVariable [format['police%1',_town],0];
	if(_garrison > 0) then {
		_townmrk setMarkerType "OT_Police";
	}else{
		_townmrk setMarkerType "OT_Anarchy";
	};

    //update the markers
    if(_stability < 50) then {
		if(_town in _abandoned) then {
        	_town setMarkerColor "ColorRed";
		}else{
			_town setMarkerColor "ColorYellow";
		};
        _town setMarkerAlpha 1.0 - (_stability / 50);
        _townmrk setMarkerColor "ColorOPFOR";
    }else{
        _townmrk setMarkerColor "ColorGUER";
        if(_town in _abandoned) then {
            _town setMarkerAlpha ((_stability - 50) / 100);
            _town setMarkerColor "ColorGUER";
        }else{
            _town setMarkerAlpha 0;
        };
    };
	if !(_town in _abandoned) then {
		_townmrk setMarkerAlpha 0;
		_townmrk setMarkerAlphaLocal 0;
	};
};

[] execVM "funcs\info.sqf";
