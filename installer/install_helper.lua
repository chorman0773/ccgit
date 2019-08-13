
local args = {...};

local ccgit_command;

if __ccgit_path then
  ccgit_command = __ccgit_path.__ccgit_invoke;
elseif fs.exists("/__ccgit_path") then
  os.loadAPI("/__ccgit_path");
  ccgit_command = __ccgit_path.__ccgit_invoke;
else
  ccgit_command = "./ccgit_minimal.lua";
end

local installRoot = args[0];
local repositoryURL = args[1];
local branch = args[2]; 
local bootstrap = args[3]=="true";
local installStartupPaths = args[4]=="true";

local actualInstallDir = bootstrap and fs.combine(shell.dir(),"tmp-ccgit") or installRoot;

shell.run(ccgit_command,"clone","--recurse-submodules","-b",branch,"--single-branch",repositoryURL,actualInstallDir);


if bootstrap then
  if fs.exists(fs.combine(actualInstallDir,"cmd/ccgit")) then
    --this is the actual program, and a not an api branch,  
    ccgit_command = fs.combine(actualInstallDir,"cmd/ccgit");
    actualInstallDir = installRoot;
    shell.run(ccgit_command,"clone","--recurse-submodules","-b",branch,"--single-branch",repositoryURL,actualInstallDir);
    shell.run(fs.combine(actualInstallDir,"bootstrap/bootstrap1.lua"),repositoryURL,branch,installRoot);
    --Run the bootstrapper 
  else
    --do something fancier to bootstrap.
    --Thankfully the correct bootstrapping programs will be available.
    --Can't require, as I don't want to heck up require paths
    local clone = dofile(fs.combine(actualInstallDir,"lib/clone_cmd"));
    assert(clone.init(installRoot):setBranch(branch):singleBranch():recurseSubmodules():setRepositoryURL(repositoryURL):run());
    shell.run(fs.combine(installRoot,"bootstrap/bootstrap1.lua"),repositoryURL,branch,installRoot);
  end
end

if installStartupPaths then
  shell.run(fs.combine(installRoot,"install/after_install.lua"));
end
