#!/bin/bash

# Network AI Platform - Project Setup Script
# Run this script to create the complete directory structure

echo "🚀 Setting up Network AI Platform project structure..."

# Create main project directory
mkdir -p network-ai-platform
cd network-ai-platform

# Create all directories
echo "📁 Creating directory structure..."

# API layer
mkdir -p api

# Configuration parsing
mkdir -p config_parser/templates

# Network modeling
mkdir -p network_model

# AI engine
mkdir -p ai_engine

# Database
mkdir -p database/migrations/versions

# Services
mkdir -p services

# Utilities
mkdir -p utils

# Tests
mkdir -p tests/{fixtures/{sample_configs,expected_outputs},integration}

# Frontend (optional)
mkdir -p frontend/{src/{components,services,hooks,styles},public}

# Documentation
mkdir -p docs/{architecture,examples,screenshots}

# Scripts
mkdir -p scripts

# Data storage
mkdir -p data/{uploads,exports,backups,logs}

# Templates
mkdir -p templates/{config_templates,email_templates,report_templates}

# Deployment
mkdir -p deployment/{kubernetes,terraform,nginx}

# VS Code settings (optional)
mkdir -p .vscode

echo "📝 Creating __init__.py files..."

# Create __init__.py files for Python packages
touch api/__init__.py
touch config_parser/__init__.py
touch network_model/__init__.py
touch ai_engine/__init__.py
touch database/__init__.py
touch services/__init__.py
touch utils/__init__.py
touch tests/__init__.py

echo "⚙️ Creating configuration files..."

# Create .env.example
cat > .env.example << 'EOF'
# Database Configuration
DATABASE_URL=sqlite:///./network_ai_platform.db
# For PostgreSQL: postgresql://username:password@localhost:5432/network_ai_platform

# AI Configuration
OPENAI_API_KEY=your-openai-api-key-here
# ANTHROPIC_API_KEY=your-anthropic-api-key-here  # Alternative to OpenAI

# Security
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Application Settings
DEBUG=True
LOG_LEVEL=INFO
MAX_UPLOAD_SIZE=10485760  # 10MB

# Network Settings
SNMP_COMMUNITY=public
DEFAULT_USERNAME=admin
DEFAULT_PASSWORD=admin

# Redis (for background tasks - optional)
REDIS_URL=redis://localhost:6379/0
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
pip-wheel-metadata/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual Environment
venv/
env/
ENV/
env.bak/
venv.bak/

# Environment Variables
.env
.env.local
.env.production

# Database
*.db
*.sqlite
*.sqlite3

# Logs
logs/
*.log

# IDE
.vscode/settings.json
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Uploads
data/uploads/*
!data/uploads/.gitkeep

# Backups
data/backups/*
!data/backups/.gitkeep

# Node.js (for frontend)
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.npm
.yarn-integrity

# Frontend build
frontend/dist/
frontend/build/

# Testing
.pytest_cache/
.coverage
htmlcov/
.tox/

# Jupyter Notebooks
.ipynb_checkpoints

# Documentation builds
docs/_build/

# Temporary files
*.tmp
*.temp
EOF

# Create basic config.py
cat > config.py << 'EOF'
#!/usr/bin/env python3
"""
Configuration settings for Network AI Platform
"""

import os
from pydantic_settings import BaseSettings
from typing import Optional, List

class Settings(BaseSettings):
    """Application settings"""
    
    # Database
    database_url: str = "sqlite:///./network_ai_platform.db"
    
    # AI Configuration
    openai_api_key: Optional[str] = None
    anthropic_api_key: Optional[str] = None
    
    # Security
    secret_key: str = "change-this-in-production"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    
    # Application
    debug: bool = True
    log_level: str = "INFO"
    max_upload_size: int = 10 * 1024 * 1024  # 10MB
    
    # CORS
    allowed_origins: List[str] = [
        "http://localhost:3000",
        "http://localhost:5173",
        "http://127.0.0.1:3000",
        "http://127.0.0.1:5173"
    ]
    
    # Network defaults
    snmp_community: str = "public"
    default_username: str = "admin"
    default_password: str = "admin"
    
    # Redis (optional)
    redis_url: Optional[str] = None
    
    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"

# Global settings instance
settings = Settings()
EOF

# Create basic Dockerfile
cat > Dockerfile << 'EOF'
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create non-root user
RUN useradd --create-home --shell /bin/bash app
RUN chown -R app:app /app
USER app

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

# Run application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF

# Create docker-compose.yml for development
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://postgres:password@db:5432/network_ai_platform
      - REDIS_URL=redis://redis:6379/0
    volumes:
      - ./data:/app/data
      - ./logs:/app/logs
    depends_on:
      - db
      - redis
    restart: unless-stopped

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: network_ai_platform
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    restart: unless-stopped

  # Optional: PostgreSQL admin interface
  pgadmin:
    image: dpage/pgadmin4
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@example.com
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "5050:80"
    depends_on:
      - db
    restart: unless-stopped

volumes:
  postgres_data:
EOF

# Create placeholder files to preserve directory structure
echo "📄 Creating placeholder files..."
touch data/uploads/.gitkeep
touch data/exports/.gitkeep
touch data/backups/.gitkeep
touch data/logs/.gitkeep

# Create basic README
cat > README.md << 'EOF'
# Network AI Platform

AI-powered network analysis and automation platform for Cisco networks.

## Features

- 🔍 **Intelligent Config Parsing**: Parse Cisco IOS/IOS-XE/NX-OS configurations using TextFSM
- 🤖 **AI-Powered Analysis**: Natural language queries about network infrastructure
- 🗺️ **Network Topology**: Automatic topology discovery and visualization
- ⚙️ **Config Generation**: AI-generated configuration changes and recommendations
- 📊 **Network Insights**: Best practices analysis and optimization recommendations

## Quick Start

1. **Clone and setup**:
   ```bash
   git clone <your-repo>
   cd network-ai-platform
   python -m venv venv
   source venv/bin/activate  # or `venv\Scripts\activate` on Windows
   pip install -r requirements.txt
   ```

2. **Configure environment**:
   ```bash
   cp .env.example .env
   # Edit .env with your settings (especially OPENAI_API_KEY)
   ```

3. **Initialize database**:
   ```bash
   python database/database.py init
   ```

4. **Run the application**:
   ```bash
   uvicorn main:app --reload
   ```

5. **Access the API**:
   - Interactive docs: http://localhost:8000/docs
   - Alternative docs: http://localhost:8000/redoc

## Usage

### Upload Configuration
```bash
curl -X POST "http://localhost:8000/api/v1/upload-config" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@your-config.txt"
```

### Query Network
```bash
curl -X POST "http://localhost:8000/api/v1/query" \
  -H "Content-Type: application/json" \
  -d '{"query": "Show me all devices in VLAN 100"}'
```

## Development

Run tests:
```bash
pytest
```

Run with Docker:
```bash
docker-compose up --build
```

## License

MIT License
EOF

# Create basic pytest.ini
cat > pytest.ini << 'EOF'
[tool:pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = 
    -v
    --tb=short
    --strict-markers
    --disable-warnings
    --cov=.
    --cov-report=term-missing
    --cov-report=html:htmlcov
    --cov-fail-under=80

markers =
    slow: marks tests as slow (deselect with '-m "not slow"')
    integration: marks tests as integration tests
    unit: marks tests as unit tests
EOF

echo "✨ Project structure created successfully!"
echo ""
echo "📋 Next steps:"
echo "1. cd network-ai-platform"
echo "2. python -m venv venv"
echo "3. source venv/bin/activate  (or venv\\Scripts\\activate on Windows)"
echo "4. pip install -r requirements.txt"
echo "5. cp .env.example .env"
echo "6. Edit .env with your settings"
echo "7. python database/database.py init"
echo "8. uvicorn main:app --reload"
echo ""
echo "🎉 Your Network AI Platform is ready to go!"
