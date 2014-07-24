import UnityEngine

class God():

	static Inst as God:
	""" Calls upon God """
		get:
			God() unless _instance
			return _instance
	static _instance as God

	Hermes:
	""" The messenger """
		get:
			return _hermes
	_hermes as Messenger
	
	Core:
	""" The core """
		get:
			return _core
		set:
			assert not _core
			_core = value
	_core as Transform

	Ground:
	""" The ground """
		get:
			return _ground
		set:
			assert not _ground
			_ground = value
	_ground as Transform

	GroundLevel:
	""" The ground plane """
		get:
			return _groundLevel
		set:
			assert not _groundLevel
			_groundLevel = value
	_groundLevel as Transform

	FlightLevel:
	""" The flight plane """
		get:
			return _flightLevel
		set:
			assert not _flightLevel
			_flightLevel = value
	_flightLevel as Transform

	Player:
	""" The Player's copter """
		get:
			return _player
		set:
			//assert not _player
			_player = value
	_player as Transform

	private def constructor ():
	""" Wakes up God """
	
		Debug.Log("Beware, I live!")
		_instance = self
		_hermes = Messenger()
