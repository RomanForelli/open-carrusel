import fs from "fs";
import os from "os";
import path from "path";

const COMMON_PATHS = [
  path.join(os.homedir(), ".local/bin/claude"),
  "/usr/local/bin/claude",
  "/opt/homebrew/bin/claude",
  path.join(os.homedir(), ".npm-global/bin/claude"),
];

export function getClaudePath(): string {
  // 1. Environment variable (set by setup script or user)
  if (process.env.CLAUDE_CLI_PATH) {
    return process.env.CLAUDE_CLI_PATH;
  }

  // 2. Check common installation locations
  for (const candidate of COMMON_PATHS) {
    if (fs.existsSync(candidate)) {
      return candidate;
    }
  }

  throw new Error(
    "Claude CLI not found. Install it from https://docs.anthropic.com/en/docs/claude-code or set CLAUDE_CLI_PATH in .env.local"
  );
}

export function isClaudeAvailable(): boolean {
  try {
    getClaudePath();
    return true;
  } catch {
    return false;
  }
}
