# NMS Mod Builder (BASH version)

This BASH script allows you to build mods for No Man's Sky in a simple way.

You don't need to know how to code or something, you only need to make definition files.

### Requeriments:

- xmlstarlet
- psarc.exe
- [MBINCompiler](https://github.com/monkeyman192/MBINCompiler)
- wine

### Instalation:

Copy this files/folders into NMSModBuilder.sh folder:

- psarc.exe 
- MBINCompiler/ folder
- \*.pak that you need use as input

### Usage:

    ./NMSModBuilder.sh <definition_file>

### Definition File Example (Single MOD):

<pre style="background-color: rgb(230, 230, 230);">

    # Define Inputs and Output

    !inputPakFile NMSARC.globals.pak
    !outputPakFile SplinterGU_StackX100.pak
    !mbinFile GCGAMEPLAYGLOBALS.GLOBAL.MBIN

    # Stack Limit High x100

    cd /DifficultyConfig/InventoryStackLimitsOptionData/High

    SubstanceStackLimit=999999
    ProductStackLimit=999999

    cd /DifficultyConfig/InventoryStackLimitsOptionData/High/MaxSubstanceStackSizes

    Default=999999
    Personal=999999
    PersonalCargo=999999
    Ship=999999
    ShipCargo=999999
    Freighter=999999
    FreighterCargo=999999
    Vehicle=999999
    Chest=999999
    BaseCapsule=999999
    MaintenanceObject=999999
    UIPopup=999999

    cd /DifficultyConfig/InventoryStackLimitsOptionData/High/MaxProductStackSizes

    Default=500
    Personal=1000
    PersonalCargo=1000
    Ship=1000
    ShipCargo=1000
    Freighter=2000
    FreighterCargo=2000
    Vehicle=1000
    Chest=2000
    BaseCapsule=10000
    MaintenanceObject=1000
    UIPopup=100

    # Stack Limit Normal x100

    cd /DifficultyConfig/InventoryStackLimitsOptionData/Normal

    SubstanceStackLimit=999999
    ProductStackLimit=999999

    cd /DifficultyConfig/InventoryStackLimitsOptionData/Normal/MaxSubstanceStackSizes

    Default=50000
    Personal=50000
    PersonalCargo=50000
    Ship=100000
    ShipCargo=100000
    Freighter=200000
    FreighterCargo=200000
    Vehicle=100000
    Chest=100000
    BaseCapsule=200000
    MaintenanceObject=25000
    UIPopup=25000

    cd /DifficultyConfig/InventoryStackLimitsOptionData/Normal/MaxProductStackSizes

    Default=500
    Personal=1000
    PersonalCargo=1000
    Ship=1000
    ShipCargo=1000
    Freighter=1000
    FreighterCargo=2000
    Vehicle=1000
    Chest=2000
    BaseCapsule=10000
    MaintenanceObject=1000
    UIPopup=100

    # Stack Limit Low x100

    cd /DifficultyConfig/InventoryStackLimitsOptionData/Low

    SubstanceStackLimit=999999
    ProductStackLimit=999999

    cd /DifficultyConfig/InventoryStackLimitsOptionData/Low/MaxSubstanceStackSizes

    Default=15000
    Personal=30000
    PersonalCargo=30000
    Ship=30000
    ShipCargo=75000
    Freighter=75000
    FreighterCargo=75000
    Vehicle=30000
    Chest=75000
    BaseCapsule=125000
    MaintenanceObject=15000
    UIPopup=15000

    cd /DifficultyConfig/InventoryStackLimitsOptionData/Low/MaxProductStackSizes

    Default=300
    Personal=300
    PersonalCargo=500
    Ship=300
    ShipCargo=500
    Freighter=500
    FreighterCargo=1000
    Vehicle=300
    Chest=1000
    BaseCapsule=5000
    MaintenanceObject=500
    UIPopup=100

</pre>

### Full command:

    $ ./NMSModBuilder.sh SplinterGU_StackX100.def

---

### Definition File Example (Multiple MODs):

<pre style="background-color: rgb(230, 230, 230);">

    # Define Inputs and Output

    !inputPakFile NMSARC.globals.pak
    !outputPakFile SplinterGU_StackX100.pak
    !mbinFile GCGAMEPLAYGLOBALS.GLOBAL.MBIN

    # Stack Limit High x100

    cd /DifficultyConfig/InventoryStackLimitsOptionData/High

    SubstanceStackLimit=999999
    ProductStackLimit=999999

    cd /DifficultyConfig/InventoryStackLimitsOptionData/High/MaxSubstanceStackSizes

    Default=999999
    Personal=999999
    PersonalCargo=999999
    Ship=999999
    ShipCargo=999999
    Freighter=999999
    FreighterCargo=999999
    Vehicle=999999
    Chest=999999
    BaseCapsule=999999
    MaintenanceObject=999999
    UIPopup=999999

    cd /DifficultyConfig/InventoryStackLimitsOptionData/High/MaxProductStackSizes

    Default=500
    Personal=1000
    PersonalCargo=1000
    Ship=1000
    ShipCargo=1000
    Freighter=2000
    FreighterCargo=2000
    Vehicle=1000
    Chest=2000
    BaseCapsule=10000
    MaintenanceObject=1000
    UIPopup=100

    # Stack Limit Normal x100

    cd /DifficultyConfig/InventoryStackLimitsOptionData/Normal

    SubstanceStackLimit=999999
    ProductStackLimit=999999

    cd /DifficultyConfig/InventoryStackLimitsOptionData/Normal/MaxSubstanceStackSizes

    Default=50000
    Personal=50000
    PersonalCargo=50000
    Ship=100000
    ShipCargo=100000
    Freighter=200000
    FreighterCargo=200000
    Vehicle=100000
    Chest=100000
    BaseCapsule=200000
    MaintenanceObject=25000
    UIPopup=25000

    cd /DifficultyConfig/InventoryStackLimitsOptionData/Normal/MaxProductStackSizes

    Default=500
    Personal=1000
    PersonalCargo=1000
    Ship=1000
    ShipCargo=1000
    Freighter=1000
    FreighterCargo=2000
    Vehicle=1000
    Chest=2000
    BaseCapsule=10000
    MaintenanceObject=1000
    UIPopup=100

    # Stack Limit Low x100

    cd /DifficultyConfig/InventoryStackLimitsOptionData/Low

    SubstanceStackLimit=999999
    ProductStackLimit=999999

    cd /DifficultyConfig/InventoryStackLimitsOptionData/Low/MaxSubstanceStackSizes

    Default=15000
    Personal=30000
    PersonalCargo=30000
    Ship=30000
    ShipCargo=75000
    Freighter=75000
    FreighterCargo=75000
    Vehicle=30000
    Chest=75000
    BaseCapsule=125000
    MaintenanceObject=15000
    UIPopup=15000

    cd /DifficultyConfig/InventoryStackLimitsOptionData/Low/MaxProductStackSizes

    Default=300
    Personal=300
    PersonalCargo=500
    Ship=300
    ShipCargo=500
    Freighter=500
    FreighterCargo=1000
    Vehicle=300
    Chest=1000
    BaseCapsule=5000
    MaintenanceObject=500
    UIPopup=100


    !inputPakFile NMSARC.globals.pak
    !outputPakFile SplinterGU_InstantScan.pak
    !mbinFile GCGAMEPLAYGLOBALS.GLOBAL.MBIN

    # Instant Scan

    cd /

    BinocTimeBeforeScan=0
    BinocMinScanTime=0
    BinocScanTime=0
    BinocCreatureScanTime=0

</pre>

### Full command:

    $ ./NMSModBuilder.sh SplinterGU_MultipleMods.def
    
---

### Contact:

- Send me an email at [splintergu@gmail.com](splintergu@gmail.com) or [juanjoseponteprino@gmail.com](juanjoseponteprino@gmail.com)
