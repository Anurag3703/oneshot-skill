#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');
const childProcess = require('child_process');

const homedir = os.homedir();
const packageRoot = path.resolve(__dirname, '..');
const defaultSkill = 'contextual-prompt-generator';

const skillDirs = [
  path.join(homedir, '.copilot', 'skills'),
  path.join(homedir, '.github', 'skills')
];

function showHelp() {
  console.log(`
⚡ oneshot-skill - Copilot Skill Manager

Usage:
  npx oneshot-skill                    Install / update the One-Shot skill (default)
  npx oneshot-skill list               List all installed Copilot skills
  npx oneshot-skill remove [name]      Remove a specific skill (default: oneshot)
  npx oneshot-skill remove-all         Remove ALL installed Copilot skills
  npx oneshot-skill update             Update installed skill to latest
  npx oneshot-skill help               Show this help message

Examples:
  npx oneshot-skill
  npx oneshot-skill list
  npx oneshot-skill remove oneshot
  npx oneshot-skill remove-all
`);
}

function copyFolderSync(from, to) {
  if (!fs.existsSync(from)) return;
  fs.mkdirSync(to, { recursive: true });
  for (const element of fs.readdirSync(from)) {
    const srcPath = path.join(from, element);
    const destPath = path.join(to, element);
    const stat = fs.lstatSync(srcPath);
    if (stat.isDirectory()) {
      if (element === 'node_modules' || element === '.git') continue;
      copyFolderSync(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

function installSkill() {
  console.log(`\n🚀 [oneshot-skill] Installing Copilot Skill: ${defaultSkill}...`);
  for (const parentDir of skillDirs) {
    try {
      const dest = path.join(parentDir, defaultSkill);
      fs.mkdirSync(dest, { recursive: true });
      fs.copyFileSync(path.join(packageRoot, 'SKILL.md'), path.join(dest, 'SKILL.md'));
      if (fs.existsSync(path.join(packageRoot, 'README.md'))) {
        fs.copyFileSync(path.join(packageRoot, 'README.md'), path.join(dest, 'README.md'));
      }
      if (fs.existsSync(path.join(packageRoot, 'references'))) {
        copyFolderSync(path.join(packageRoot, 'references'), path.join(dest, 'references'));
      }
      console.log(`✓ Copied to ${dest}`);
    } catch (err) {
      console.warn(`Warning: Could not write to ${parentDir}:`, err.message);
    }
  }
  installProjectInstructions();
  console.log('\n✅ Installation complete!');
  console.log('👉 Open a new Copilot Chat session in VS Code to use it.\n');
}

function installProjectInstructions() {
  let projectRoot;
  try {
    projectRoot = childProcess.execFileSync('git', ['rev-parse', '--show-toplevel'], {
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'ignore']
    }).trim();
  } catch {
    return;
  }

  const source = path.join(packageRoot, '.github', 'copilot-instructions.md');
  if (!fs.existsSync(source)) return;

  const destinationDir = path.join(projectRoot, '.github');
  const destination = path.join(destinationDir, 'copilot-instructions.md');
  fs.mkdirSync(destinationDir, { recursive: true });
  if (!fs.existsSync(destination)) {
    fs.copyFileSync(source, destination);
    console.log(`✓ Added project routing instructions to ${destination}`);
  } else {
    console.log(`✓ Project routing instructions already present at ${destination}`);
  }
}

function listSkills() {
  console.log('\n==> 📋 Installed Copilot Skills:');
  const copilotDir = skillDirs[0];
  let found = 0;
  if (fs.existsSync(copilotDir)) {
    const items = fs.readdirSync(copilotDir);
    for (const item of items) {
      const itemPath = path.join(copilotDir, item);
      if (fs.statSync(itemPath).isDirectory() && fs.existsSync(path.join(itemPath, 'SKILL.md'))) {
        console.log(`  • ${item}`);
        found++;
      }
    }
  }
  if (found === 0) {
    console.log('  (No skills currently installed)');
  }
  console.log('');
}

function normalizeName(name) {
  if (!name || name === 'oneshot' || name === 'one-shot' || name === 'prompt') {
    return defaultSkill;
  }
  return name;
}

function removeSkill(targetName) {
  const target = normalizeName(targetName);
  console.log(`\n==> 🗑️  Removing '${target}' from Copilot skills...`);
  for (const parentDir of skillDirs) {
    const targetPath = path.join(parentDir, target);
    if (fs.existsSync(targetPath)) {
      fs.rmSync(targetPath, { recursive: true, force: true });
      console.log(`✓ Removed ${targetPath}`);
    }
  }
  console.log('✅ Skill removed.\n');
}

function removeAllSkills() {
  console.log('\n==> ⚠️  Removing ALL installed skills from Copilot...');
  let count = 0;
  for (const parentDir of skillDirs) {
    if (fs.existsSync(parentDir)) {
      const items = fs.readdirSync(parentDir);
      for (const item of items) {
        const itemPath = path.join(parentDir, item);
        if (fs.statSync(itemPath).isDirectory()) {
          fs.rmSync(itemPath, { recursive: true, force: true });
          count++;
        }
      }
    }
  }
  console.log(`✅ All skills removed (${count} items cleaned).`);
  console.log('👉 Restart/reload Copilot Chat.\n');
}

// CLI Arg Router
const args = process.argv.slice(2);
const command = (args[0] || '').toLowerCase();

switch (command) {
  case '':
  case 'install':
    installSkill();
    break;
  case 'list':
  case 'ls':
    listSkills();
    break;
  case 'remove':
  case 'rm':
  case 'uninstall':
    removeSkill(args[1]);
    break;
  case 'remove-all':
  case 'rm-all':
  case 'clear-all':
  case 'uninstall-all':
    removeAllSkills();
    break;
  case 'update':
  case 'upgrade':
    console.log('\n==> 🔄 Updating skill to latest...');
    installSkill();
    break;
  case 'help':
  case '-h':
  case '--help':
    showHelp();
    break;
  default:
    showHelp();
    break;
}
