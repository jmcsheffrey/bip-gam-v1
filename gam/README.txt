GAM (http://www.ditoweb.com/dito-gam) should reside here, in a directory named 
"gam".  All other source files should look for GAM at that location.  

Activated versions of GAM _MUST NOT_ be stored in GIT for security reasons.
The .gitignore file is set to ignore the ./gam/ directory.  Please download GAM
and appropriate auth files manually.

To setup GAM on your workstation/server, at least for this project, below are 
basic steps.  
  01.  Grab all the (appropriate) files of this repository.
  02.  Download & extract GAM.
  03.  Create project at https://console.developers.google.com/.
  04.  Enable appropriate APIs (see below).
  05.  Download client_secrets.json file to correct location.
  06.  Run "python gam.py info domain".
  07.  Choose appropriate scopes.
  08.  Authorize in appropriate method (local browser or "nobrowser.txt").
  09.  Run "./test.py" (unless creating a test user is not appropriate).
  10.  Verify that user crashtestdummy@domain.org & alias of idontwearseatbelts
       were created.
Additional help can be found at:
  https://github.com/jay0lee/GAM/wiki

NOTES for step #04:
  Current APIs in use are:
    [[??? need to list them once things are working ???]]