setlocal enabledelayedexpansion
echo "Name","AppID","Version","Homepage","FileName","Hash","PackageUrl1","RefererUrl1","PackageUrl2"
for %%G in ("%_bucket_dir%\*.csv") do (
  call "%~dp0_get_app_info.cmd" %%~nG || exit /b 1
  echo "!_app_name!","!_app_appid!","!_app_version!","!_app_homepage!","!_app_filename!","!_app_hash!","!_app_package_url_1!","!_app_referer_url_1!","!_app_package_url_2!"
)
endlocal
