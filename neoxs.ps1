function setConfig($name, $value) {
    
    [Environment]::SetEnvironmentVariable($name, $value) 
}

function loop($command, $files) {
    foreach($file in $files) {
        Invoke-Expression -Command "$command $file"
    }
} 

function pygrep($pattern){
    
    grep *.py $pattern
}

function find($directory, $pattern) {
    Get-ChildItem $directory -recurse -name $pattern
}

function grep($file_pattern, $pattern) {
    Get-ChildItem -Recurse $file_pattern | Select-String -Pattern $pattern -CaseSensitive
}

function mk_import() {
    set_tools $TOOLS
    set_rom $ROM
    set_hal $HAL
    set_regmap $ASIC
    set_settings $SETTINGS
}

$project_root = 'C:\Users\swambecq.COCHLEAR\Perforce\CBE160413001\P8931_NEO_XS'
 
function setroot() {
    $project_root = Get-Location
    echo $project_root
    mk_import
}


function get_path($project, $version, $loc = '20_Design') {
    Push-Location
    $current = Get-Location
    Set-Location $project_root
    $proj = Get-ChildItem $loc/$project/*/$version
    Pop-Location
    return $proj.FullName
}

function set_hal($version) {
    $env:NEOXS_HAL_PATH = (get_path 'HAL' $version) + '\' + 'Common'
    echo ("NEOXS_HAL_PATH = " + $env:NEOXS_HAL_PATH)
}

function set_regmap($version) {
    $env:NEO_LSI_REGMAP_PATH = (get_path 'ASIC\Register_map' $version) + '\Neo_LSI_RegisterMap_Top.xml'
    echo ("NEO_LSI_REGMAP_PATH = " + $env:NEO_LSI_REGMAP_PATH)
}

function set_settings($version) {
    $env:NEOXS_SETTINGS_PATH = (get_path 'ASIC\Recommended_settings' $version) + '\Recommended_application_settings.xlsx'
    echo ("NEOXS_SETTINGS_PATH = " + $env:NEOXS_SETTINGS_PATH)
}

function set_rom($version) {
    $env:NEOXS_ROM_PATH = (get_path 'ROM' $version)
    echo ("NEOXS_ROM_PATH = " + $env:NEOXS_ROM_PATH)
}

function set_tools($version) {
    $env:NEOXS_TOOLBOX_PATH = (get_path 'Tools' $version) + '\Toolbox'
    echo ("NEOXS_TOOLBOX_PATH = " + $env:NEOXS_TOOLBOX_PATH)
}


echo "Configuring Environment"

$compiler_path = "C:\Keil\C251\BIN"
$dsp_tools_path = "C:\Program Files (x86)\Cochlear\Neo DSP Tools"
$python_path = "C:\Python27"
$mingw_path = "C:\MinGW\bin"
$sep = ";"

$env:Path = $env:Path + $sep + $compiler_path + $sep + $dsp_tools_path + $sep + $python_path + $sep + $mingw_path

echo ("C251 = " + $compiler_path)
echo ("DSP = " + $dsp_tools_path)
echo ("Python = " + $python_path)

echo "Configure NEO-XS Projects"
echo ""

$TOOLS    = '0.8.x'
$ROM      = '0.2.1.0'
$ASIC     = '2.2.0'
$SETTINGS = '2.0.0'
$HAL      = '0.4.X'

echo "Configuring platform"
$env:NEO_PORT = 4
$env:FPGA_PORT = 3
$env:STRATIX_FPGA_PORT = $env.FPGA_PORT
$env:NEOXS_PLATFORM = "asic"
$env:SUPPLY_METHOD = "GFT"
$env:ToolsRequirementsPath = $project_root + '\40_Verification\Reporting\NEO-XS_Toolbox_Requirements.xlsx'

echo "Configuring SQLite"
$env:SQLITE_DB_PATH = ""

cd $project_root


function prompt {
    Push-Location
    $current = Get-Location
    Set-Location $project_root
    $result = Resolve-Path -Relative $current
    Pop-Location
    "$result > "	
}


$host.enternestedprompt()