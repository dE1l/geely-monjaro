@echo off
chcp 1251
SET defaultLocation=c:\platform-tools-monjaro
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
cls
tasklist /nh /fi "imagename eq adb.exe" | find /i "adb.exe" > nul || adb start-server
echo -------------------------------------------------
echo Ожидание подключения устройства
echo 1. Включите режим ADB 
echo    Для машины ОД в номеронабирателе в ГУ набрать #*32279
echo    Для прошитого Китая в номеронабирателе в ГУ набрать *1220*
echo    В открывшемся инженерном меню выбрать четвертый пункт снизу и в нем выключить верхнюю галку и включить нижнюю галку.
echo    После всех манипуляций нижнюю галку необходимо выключить.
echo 2. Подключите провод к ГУ
echo 3. Если устройство не определяется - попробуйте установить драйвер из папки C:\Platform-Tools-Monjaro\Drivers
echo -------------------------------------------------
adb wait-for-device
echo -------------------------------------------------
adb devices
echo. 
:menu
echo.
echo -------------------------------------------------
echo Всё, что Вы делаете со своим автомобилем, Вы делаете на свой страх и риск. Никто кроме Вас не несет никакой ответственности за все действия.
echo                  .
echo Выберите действие:
echo 1. Установка AutoKit 2022.11.15.1535 (работают кнопки управления музыкой, возможны прерывания звука по беспроводному Аndroid Аuto)
echo 2. Установка AutoKit 2023.03.20.1121 (не работают кнопки управления музыкой, есть настройка задержки media - исправляет прерывания звука)
echo 3. Установка Macrodroid + ADB хак write_secure + ADB хак accessibility_services + MD Helper
echo 4. Установка собственных приложений из папки APK (скопируйте необходимые приложения в эту папку)
echo 5. Carbit хак (отключение на телефоне запроса на трансляцию). Делается на телефоне: подключите телефон, а не автомобиль к компьютеру
echo 6. Отключение проверки доступности интернет соединения (отключение Captive Portal)
echo 7. Включение проверки доступности интернет соединения (Captive Portal через серверы Яндекс)
echo 8. ADB хак accessibility_services (для приложений по списку Сергея Bloodyrus)
echo 9. Установка Галереи и Обоев
echo 10. Включение модуля WiFi в ГУ
echo 11. Установка USBGPS4Droid для GPS свистка (нужно только для машин ОД)
echo 12. Запустить ADB shell (ввод собственных команд в ГУ через ADB)
echo 0. Выход
echo -------------------------------------------------
set "opt=x"
set /p opt=Введите номер действия:
:correctOption
if %opt%==1 goto installAutoKit2022
if %opt%==2 goto installAutoKit2023
if %opt%==3 goto Macrodroid
if %opt%==4 goto UserApk
if %opt%==5 goto CarbitHack
if %opt%==6 goto CaptivNull
if %opt%==7 goto CaptivYandex
if %opt%==8 goto MacrodroidAccess
if %opt%==9 goto Gallery
if %opt%==10 goto WIFI
if %opt%==11 goto GNSS
if %opt%==12 goto ADBShell
if %opt%==0 goto processHalt
echo.
echo.
echo Неправильный ввод!
set /p opt=Пожалуйста выберите один из вариантов:
goto correctOption

:changeLocation
echo.
echo.
echo Укажите папку с приложениями.
set /p defaultLocation=^>

:installAutoKit2022
if not EXIST "%defaultLocation%\AK2022\*.apk" ( 
echo.
echo Папка не содержит приложений.
goto changeLocation
)
echo Устанавливаю приложения...
echo.
for /f "delims=|" %%i in ('dir /b "%defaultLocation%\AK2022\*.apk"') do (
    echo -------------------------
	echo Установка %%~ni
	adb install -r "%defaultLocation%\AK2022\%%i"
)
echo.
echo.
echo Поздравляю, приложения установлены.
goto menu

:installAutoKit2023
if not EXIST "%defaultLocation%\AK2023\*.apk" ( 
echo.
echo Папка не содержит приложений.
goto changeLocation
)
echo Устанавливаю приложения...
echo.
for /f "delims=|" %%i in ('dir /b "%defaultLocation%\AK2023\*.apk"') do (
    echo -------------------------
	echo Установка %%~ni
	adb install -r "%defaultLocation%\AK2023\%%i"
)
echo.
echo.
echo Поздравляю, приложения установлены.
goto menu


:Macrodroid
if not EXIST "%defaultLocation%\MD\*.apk" ( 
echo.
echo Папка не содержит приложений.
goto changeLocation
)
echo Устанавливаю приложения...
echo.
for /f "delims=|" %%i in ('dir /b "%defaultLocation%\MD\*.apk"') do (
    echo -------------------------
	echo Установка %%~ni
	adb install -r "%defaultLocation%\MD\%%i"
)
echo.
echo.
echo Поздравляю, приложения установлены.
echo.
echo Устанавливаю хак...
	
	adb shell pm grant com.arlosoft.macrodroid android.permission.WRITE_SECURE_SETTINGS
	adb shell pm grant com.arlosoft.macrodroid android.permission.CHANGE_CONFIGURATION
	adb shell pm grant com.arlosoft.macrodroid android.permission.READ_LOGS
	adb shell pm grant com.arlosoft.macrodroid android.permission.SET_VOLUME_KEY_LONG_PRESS_LISTENER
	adb shell pm grant com.arlosoft.macrodroid android.permission.DUMP
	adb shell pm grant com.arlosoft.macrodroid.helper android.permission.WRITE_SECURE_SETTINGS	
	
adb shell settings put secure enabled_accessibility_services com.arlosoft.macrodroid/com.arlosoft.macrodroid.triggers.services.MacroDroidAccessibilityServiceJellyBean:com.arlosoft.macrodroid/com.arlosoft.macrodroid.triggers.services.VolumeButtonAccessibilityService:com.arlosoft.macrodroid/com.arlosoft.macrodroid.action.services.UIInteractionAccessibilityService:com.arlosoft.macrodroid/com.arlosoft.macrodroid.triggers.services.FingerprintAccessibilityService
	
echo.
echo Поздравляю, хак установлен.
echo.
echo Устанавливаю хак accessibility_services...
goto menu

:MacrodroidAccess
echo.
echo Устанавливаю хак accessibility_services...

adb shell settings put secure enabled_accessibility_services com.ecarx.systemui.plugin/com.ecarx.systemui.plugin.navigationbar.AppWatcherService:ecarx.xsf.gestureservice/ecarx.xsf.gestureservice.appservice.AppWatcherService:com.ecarx.xiaoka/com.ecarx.xiaoka.service.XKAppWatcherService:ecarx.xsf.mediacenter/ecarx.xsf.mediacenter.media.MediaWindowStateService:ecarx.launcher3/ecarx.multiwindow.data.monitor.AppWatcherService:com.ecarx.xcmascot/com.ecarx.mascot.service.XCAppWatcherService:com.arlosoft.macrodroid/com.arlosoft.macrodroid.action.services.UIInteractionAccessibilityService:com.arlosoft.macrodroid/.action.services.UIInteractionAccessibilityService:com.arlosoft.macrodroid/.triggers.services.VolumeButtonAccessibilityService:com.arlosoft.macrodroid/.triggers.services.FingerprintAccessibilityService:com.github.ericytsang.multiwindow.app.android/com.github.ericytsang.multiwindow.app.android.service.AppService:com.farmerbb.taskbar/com.farmerbb.taskbar.service.PowerMenuService:com.ajv.multiwindow/com.ajv.multiwindow.Services.AccessibilityService:nu.nav.bar/nu.nav.bar.service.NavigationBarService:ace.jun.simplecontrol/ace.jun.simplecontrol.service.AccService:com.ivianuu.oneplusgestures/com.ivianuu.vivid.accessibility.VividAccessibilityService

adb shell pm grant com.ivianuu.immersivemodemanager android.permission.WRITE_SECURE_SETTINGS

echo.
echo Поздравляю, хак установлен.
goto menu

:UserApk
if not EXIST "%defaultLocation%\APK\*.apk" ( 
echo.
echo Папка не содержит приложений.
goto changeLocation
)
echo Устанавливаю приложения...
echo.
for /f "delims=|" %%i in ('dir /b "%defaultLocation%\APK\*.apk"') do (
    echo -------------------------
	echo Установка %%~ni
	adb install -r "%defaultLocation%\APK\%%i"
)
echo.
echo.
echo Поздравляю, приложения установлены.
echo.
goto menu

:CarbitHack
echo.
echo Устанавливаю хак...
adb shell appops set net.easyconn.carman.wws PROJECT_MEDIA allow

echo.
echo Поздравляю, хак установлен.
goto menu

:CaptivNull
echo.
echo Отключаю проверку...
adb shell settings put global captive_portal_mode 0

echo.
echo Перезагрузите головное устройство.
goto menu

:CaptivYandex
echo.
echo Включаю проверку через серверы яндекс...
adb shell settings put global captive_portal_fallback_url http://api.browser.yandex.ru/generate_204
adb shell settings put global captive_portal_http_url http://api.browser.yandex.ru/generate_204
adb shell settings put global captive_portal_https_url https://api.browser.yandex.ru/generate_204
adb shell settings put global captive_portal_other_fallback_urls http://www.google.com/generate_204

echo.
echo Перезагрузите головное устройство.
goto menu

:Gallery
if not EXIST "%defaultLocation%\FotoGallery\*.apk" ( 
echo.
echo Папка не содержит приложений.
goto changeLocation
)
echo Устанавливаю Галерею...
echo.
for /f "delims=|" %%i in ('dir /b "%defaultLocation%\FotoGallery\*.apk"') do (
    echo -------------------------
	echo Установка %%~ni
	adb install -r "%defaultLocation%\FotoGallery\%%i"
)
echo.
echo.
echo Устанавливаю Обои...
adb push WallpaperBloody /storage/emulated/0
echo.
echo.
echo Поздравляю, Галерея и Обои установлены.
goto menu

:WIFI
echo.
echo Включаю WiFi...
adb root
adb remount
adb shell setprop persist.service.wifi.ipcp false

if not EXIST "%defaultLocation%\WiFi\*.apk" ( 
echo.
echo Папка не содержит приложений.
goto changeLocation
)
echo Устанавливаю WiFi Manager...
echo.
for /f "delims=|" %%i in ('dir /b "%defaultLocation%\WiFi\*.apk"') do (
    echo -------------------------
	echo Установка %%~ni
	adb install -r "%defaultLocation%\WiFi\%%i"
)
echo.

echo.
echo Перезагрузите головное устройство.
goto menu

:ADBShell
echo .
echo Для выхода введите exit
echo .
echo .

adb root
adb shell

echo.
goto menu

:GNSS
if not EXIST "%defaultLocation%\GNSS\*.apk" ( 
echo.
echo Папка не содержит приложений.
goto changeLocation
)
echo Устанавливаю USBGPS4Droid...
echo.
for /f "delims=|" %%i in ('dir /b "%defaultLocation%\GNSS\*.apk"') do (
    echo -------------------------
	echo Установка %%~ni
	adb install -r "%defaultLocation%\GNSS\%%i"
)

adb shell appops set org.broeuschmeul.android.gps.usb.provider android:mock_location allow

adb shell settings put secure enabled_accessibility_services org.broeuschmeul.android.gps.usb.provider/org.broeuschmeul.android.gps.usb.provider.service.BootService

echo.
echo.
echo Поздравляю, GNSS Commander установлен.
goto menu

echo.
echo Перезагрузите головное устройство.
goto menu

:processHalt
echo.
echo.
echo Процесс прерван.

:processComplete
adb kill-server
echo.
pause
exit
:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof

