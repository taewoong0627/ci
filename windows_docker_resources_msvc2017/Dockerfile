# escape=`

# Indicates that the windows image will be used as the base image.
FROM mcr.microsoft.com/windows:1809

# UAC needs to be disabled on host machine for installs to run smoothly
# reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f

# Files to download
ADD `
    # .NET Framework SDK `
    https://go.microsoft.com/fwlink/?linkid=2088517 `
    `
    # Visual Studio Community `
    https://aka.ms/vs/15/release/vs_Community.exe `
    `
    # Custom choco packages `
    https://github.com/ros2/choco-packages/releases/download/2019-10-24/asio.1.12.1.nupkg `
    https://github.com/ros2/choco-packages/releases/download/2019-10-24/cunit.2.1.3.nupkg `
    https://github.com/ros2/choco-packages/releases/download/2019-10-24/eigen.3.3.4.nupkg `
    https://github.com/ros2/choco-packages/releases/download/2019-10-24/log4cxx.0.10.0.nupkg `
    https://github.com/ros2/choco-packages/releases/download/2019-10-24/tinyxml-usestl.2.6.2.nupkg `
    https://github.com/ros2/choco-packages/releases/download/2019-10-24/tinyxml2.6.0.0.nupkg `
    `
    # For extracting .7z files `
    https://www.7-zip.org/a/7z1900-x64.exe `
    `
    # xmllint files`
    https://www.zlatkovic.com/pub/libxml/64bit/libxml2-2.9.3-win32-x86_64.7z `
    https://www.zlatkovic.com/pub/libxml/64bit/zlib-1.2.8-win32-x86_64.7z `
    https://www.zlatkovic.com/pub/libxml/64bit/iconv-1.14-win32-x86_64.7z `
    `
    # OpenCV `
    https://github.com/ros2/ros2/releases/download/opencv-archives/opencv-3.4.6-vc15.VS2017.zip `
    # Qt5 online installer`
    http://download.qt.io/official_releases/online_installers/qt-unified-windows-x86-online.exe `
    `
    # Download Destination `
    C:\TEMP\

# OpenSSL. Downloading separately because hyperlink changes regularly. Renaming it to something fixed
ADD https://slproweb.com/download/Win64OpenSSL-1_0_2u.exe C:\TEMP\Win64OpenSSL.exe

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Install .NET Framework SDK
RUN C:\TEMP\ndp48-devpack-enu.exe /install /quiet

RUN C:\TEMP\vs_Community.exe --quiet --wait --norestart --includeRecommended `
  --add Microsoft.VisualStudio.Workload.NativeDesktop `
  # 3010 is an acceptable exit code, but it will confuse docker `
  || IF "%ERRORLEVEL%"=="3010" EXIT 0

# Install Qt5 with automated install script
COPY qt-installer.qs C:\TEMP\
RUN C:\TEMP\qt-unified-windows-x86-online.exe --verbose --script C:\TEMP\qt-installer.qs
RUN setx -m Qt5_DIR C:\Qt\5.12.6\msvc2017_64

# Install Chocolatey by powershell script
RUN powershell -noexit "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

# choco installs
RUN choco install -y python --version 3.7.5
RUN choco install -y cmake curl git KB3035131 KB3033929 KB2919442 vcredist2013 vcredist140 cppcheck
RUN choco install -y -s C:\TEMP asio cunit eigen tinyxml-usestl tinyxml2 log4cxx
RUN choco install -y patch

RUN C:\TEMP\Win64OpenSSL.exe /VERYSILENT

# Pip installs
RUN python -m pip install -U pip
RUN pip install -U catkin_pkg colcon-common-extensions coverage cryptography empy ifcfg lark-parser lxml mock `
                   netifaces numpy opencv-python pydot pytest pytest-mock pyparsing PyQt5 pyyaml setuptools vcstool
RUN pip install -U flake8 flake8-blind-except flake8-builtins flake8-class-newline flake8-comprehensions `
                   flake8-deprecated flake8-docstrings flake8-import-order flake8-quotes mypy pep8 pydocstyle

# Install xmllint
RUN C:\TEMP\7z1900-x64.exe /S /D="C:\Program Files\7-zip"
RUN setx PATH "%PATH%;C:\Program Files\7-zip"

# 7z.exe command line usage https://sevenzip.osdn.jp/chm/cmdline/commands/extract.htm
RUN 7z.exe x C:\TEMP\libxml2-2.9.3-win32-x86_64.7z -aoa -oC:\xmllint
RUN 7z.exe x C:\TEMP\zlib-1.2.8-win32-x86_64.7z -aoa -oC:\xmllint
RUN 7z.exe x C:\TEMP\iconv-1.14-win32-x86_64.7z -aoa -oC:\xmllint
RUN 7z.exe x C:\TEMP\opencv-3.4.6-vc15.VS2017.zip -aoa -oC:\

# Environment setup
RUN setx -m OPENSSL_CONF C:\OpenSSL-Win64\bin\openssl.cfg
RUN setx -m OpenCV_DIR C:\opencv
RUN setx PATH "%PATH%;C:\Program Files\Git\cmd;C:\Program Files\CMake\bin;C:\OpenSSL-Win64\bin\;C:\xmllint\bin;"C:\opencv\x64\vc15\bin"

# If an admin user is needed
# RUN net user /add custom-admin
# RUN net localgroup Administrators custom-admin /add
# USER custom-admin

RUN git clone https://github.com/ros2/ci C:\ci
WORKDIR C:\ci

# Set CI_ARGS to:
# --force-ansi-color --ignore-rmw rmw_connext_cpp rmw_connext_dynamic_cpp rmw_cyclonedds_cpp rmw_fastrtps_dynamic_cpp rmw_opensplice_cpp --repo-file-url https://raw.githubusercontent.com/ros2/ros2/master/ros2.repos --colcon-mixin-url https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml --cmake-build-type Release --visual-studio-version 2019 --build-args --packages-up-to osrf_testing_tools_cpp --event-handlers console_cohesion+ console_package_list+ --cmake-args -DINSTALL_EXAMPLES=OFF -DSECURITY=ON --test-args --packages-select osrf_testing_tools_cpp --event-handlers console_direct+ --executor sequential --retest-until-pass 10
CMD ["C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Community\\VC\\Auxiliary\\Build\\vcvarsall.bat", "x86_amd64", "&&", "C:\\Python37\\python.exe", "run_ros2_batch.py", "%CI_ARGS%"]
