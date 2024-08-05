

abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppChangeIndexState extends AppStates {}

class AppCreateDatabaseState extends AppStates {}
class AppInsertDatabaseState extends AppStates {}
class AppGetDatabaseState extends AppStates {}
class AppDeleteDatabase extends AppStates {}
class AppUpdateDatabase extends AppStates {}
class AppGetSalesByDateState extends AppStates {}