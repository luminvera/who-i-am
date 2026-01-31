#!/bin/bash
# Initialize Z.AI as default model if not already configured

CONFIG_FILE="/data/.openclaw/openclaw.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found, creating with Z.AI defaults"
  mkdir -p "$(dirname "$CONFIG_FILE")"
  cat > "$CONFIG_FILE" << 'EOF'
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "zai/glm-4.7"
      },
      "models": {
        "zai/glm-4.7": {}
      }
    }
  }
}
EOF
else
  echo "Checking if Z.AI is configured as default model..."
  # Check if zai/glm-4.7 is already configured
  if ! grep -q '"zai/glm-4.7"' "$CONFIG_FILE"; then
    echo "Adding Z.AI to existing config..."
    # Use node to safely merge the config
    node -e "
      const fs = require('fs');
      const config = JSON.parse(fs.readFileSync('$CONFIG_FILE', 'utf8'));
      config.agents = config.agents || {};
      config.agents.defaults = config.agents.defaults || {};
      config.agents.defaults.model = config.agents.defaults.model || {};
      config.agents.defaults.model.primary = 'zai/glm-4.7';
      config.agents.defaults.models = config.agents.defaults.models || {};
      config.agents.defaults.models['zai/glm-4.7'] = config.agents.defaults.models['zai/glm-4.7'] || {};
      fs.writeFileSync('$CONFIG_FILE', JSON.stringify(config, null, 2) + '\n');
    "
  else
    echo "Z.AI already configured"
  fi
fi

echo "Config setup complete"
