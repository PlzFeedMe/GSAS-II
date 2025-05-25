@echo off
REM ============================================================================
REM  GSAS-II Launcher Batch Script (venv in root)
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
SET "VENV_NAME=g2env" REM Common default, change if yours is different (e.g., g2env)

REM --- END OF USER CONFIGURATION ---

ECHO Starting GSAS-II...
ECHO GSAS-II Directory: %GSAS_DIR%


REM --- Activate Python venv Environment (assumed in GSAS_DIR) ---
CALL g2env\Scripts\activate

REM --- (Optional) Check Python Version ---
ECHO Verifying Python installation in environment:
python --version
pip --version

REM --- (Note on Requirements) ---
ECHO.
ECHO NOTE: This script assumes Python dependencies for GSAS-II
ECHO have already been installed in the activated environment.
ECHO To install/update dependencies, do it manually using
ECHO 'pip install ...' in your activated environment.
ECHO.

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

REM Deactivate environment (usually not strictly necessary as script ends,
REM but good practice if the command window were to remain open for other tasks)
REM 'deactivate' command should be available if venv was activated:
REM CALL deactivate

ECHO.
ECHO Script finished. Press any key to exit.
PAUSE
EXIT /B 0
