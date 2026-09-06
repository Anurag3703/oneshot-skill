#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');

const homedir = os.homedir();
const packageRoot = path.resolve(__dirname, '..');
const skillName = 'contextual-prompt-generator';

const targetDirs = [
  path.join(homedir, '.copilot', 'skills', skillName),
  path.join(homedir, '.github', 'skills', skillName)
];

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

console.log(`\n🚀 [BTI-Skill] Installing Copilot Skill: ${skillName}...`);

for (const dest of targetDirs) {
  try {
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
    console.warn(`Warning: Could not write to ${dest}:`, err.message);
  }
}

console.log('\n✅ Installation complete!');
console.log('👉 Open a new Copilot Chat session in VS Code to use it.\n');
