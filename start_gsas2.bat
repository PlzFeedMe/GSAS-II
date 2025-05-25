@echo off
REM ============================================================================
REM  GSAS-II Launcher Batch Script (venv in root with dependency check)
REM
REM  Instructions:
REM  1. Save this file as "start_gsas2.bat" (or any name with .bat extension)
REM     in the root directory of your GSAS-II clone.
REM  2. IMPORTANT: Edit the GSAS_DIR variable if this script is NOT
REM     in the GSAS-II root directory.
REM  3. Set your VENV_NAME if it's different from "venv".
REM ============================================================================

REM --- USER CONFIGURATION - EDIT THESE VALUES ---

REM 1. Set the FULL path to your cloned GSAS-II repository directory.
REM    If this .bat file is IN the GSAS-II root, you can use %~dp0
REM    which expands to the drive and path of the batch file.
SET "GSAS_DIR=%~dp0"
REM    Alternatively, set the full path manually if the .bat file is elsewhere:
REM SET "GSAS_DIR=C:\path\to\your\GSAS-II"

REM 2. Set the name of your venv folder (assumed to be in GSAS_DIR)
SET "VENV_NAME=venv" REM Common default, change if yours is different (e.g., g2env)

REM --- END OF USER CONFIGURATION ---

ECHO Starting GSAS-II...
ECHO GSAS-II Directory: %GSAS_DIR%


ECHO Activating venv environment
CALL g2env\Scripts\activate

REM --- Check and Install Dependencies ---
ECHO.
ECHO Checking for required Python libraries...
SET "CORE_LIBS=numpy wxpython scipy matplotlib pyopengl pillow h5py imageio requests gitpython PyCifRW pybaselines xmltodict seekpath"
SET "ALL_LIBS_OK=TRUE"
SET "PIP_INSTALL_CMD=pip install --disable-pip-version-check --no-python-version-warning"

FOR %%L IN (%CORE_LIBS%) DO (
    ECHO Checking for %%L...
    pip show %%L > nul 2>&1
    IF ERRORLEVEL 1 (
        ECHO   %%L not found. Attempting to install...
        %PIP_INSTALL_CMD% %%L
        IF ERRORLEVEL 1 (
            ECHO   ERROR: Failed to install %%L. GSAS-II might not function correctly.
            ECHO   Please try installing it manually in the '%VENV_NAME%' environment: %PIP_INSTALL_CMD% %%L
            SET "ALL_LIBS_OK=FALSE"
            REM You might want to PAUSE and EXIT here if a critical library fails, e.g.:
            REM PAUSE
            REM EXIT /B 1
        ) ELSE (
            ECHO   %%L installed successfully.
        )
    ) ELSE (
        ECHO   %%L is already installed.
    )
)

IF "%ALL_LIBS_OK%"=="FALSE" (
    ECHO.
    ECHO WARNING: Some Python libraries could not be installed automatically.
    ECHO GSAS-II might not run correctly or may be missing functionality.
    ECHO Please review the messages above and install any missing packages manually.
    PAUSE
    REM Decide if you want to exit or attempt to run GSAS-II anyway
    REM EXIT /B 1
) ELSE (
    ECHO.
    ECHO All core Python libraries appear to be available or installed.
)
ECHO.
REM --- End of Check and Install Dependencies ---

REM --- Navigate to GSAS-II directory (if not already there) ---
ECHO Changing directory to "%GSAS_DIR%"
PUSHD "%GSAS_DIR%"
IF ERRORLEVEL 1 (
    ECHO ERROR: Failed to change directory to "%GSAS_DIR%".
    ECHO Please check the GSAS_DIR path.
    PAUSE
    EXIT /B 1
)

REM --- (Optional) Check Python Version ---
ECHO Verifying Python installation in environment:
python --version
pip --version

REM --- Run GSAS-II ---
ECHO Launching GSAS-II (GSASII\G2.py)...
IF EXIST "GSASII\G2.py" (
    python GSASII\G2.py
) ELSE (
    ECHO ERROR: GSASII\G2.py not found in "%GSAS_DIR%".
    ECHO Please ensure GSAS_DIR is set correctly and GSAS-II is properly cloned.
    PAUSE
    EXIT /B 1
)

REM --- Cleanup (Optional) ---
ECHO GSAS-II finished or window closed.
POPD

ECHO.
ECHO Script finished. Press any key to exit.
PAUSE
EXIT /B 0
