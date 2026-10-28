# CyberShield: Safe Link Analyzer & Isolated Virtual Browser

[![Engine Version](https://img.shields.io/badge/engine-v2.4.0--forensic-cyan.svg)](https://github.com)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/tests-24%20passed-emerald.svg)](backend/tests)
[![Security Policy](https://img.shields.io/badge/SSRF--Guard-active-purple.svg)](docs/THREAT_MODEL.md)

**CyberShield** is a cybersecurity platform designed for digital forensic investigators, security analysts, and law enforcement personnel to safely investigate suspicious URLs, analyze phishing indicators, and inspect active websites within a disposable, isolated virtual browsing environment.

---

## Key Capabilities

1. **Safe Link Analyzer (Zero-Execution Pre-flight)**:
   - Evaluates URLs without visiting or loading remote content on the host device.
   - Detects IDN Homograph & Punycode attacks (e.g. Cyrillic lookalikes `xn--pple-43d.com`).
   - Identifies Public Tunnel and Localhost exposure services (`ngrok`, `Cloudflare Tunnel`, `localhost.run`, `LocalTunnel`, `Serveo`, `Pinggy`).
   - Detects direct IP-based URLs, unusual ports (e.g. 8080, 8443), plaintext HTTP, URL shorteners, and credential parameters.
   - Transparent 0–100 risk score with category breakdown and MITRE ATT&CK mappings.

2. **Isolated Virtual Browser Workspace**:
   - Streams rendered viewport screencasts so remote JavaScript NEVER executes on the user's computer.
   - Strictly blocks downloads, extension installs, clipboard access, and local filesystem writing.
   - Enforces anti-SSRF boundaries: blocks loopback (`127.0.0.1`), RFC1918 private subnets, cloud metadata (`169.254.169.254`), and unauthorized internal ports.
   - Egress gateway routing conceals the investigator's residential IP from destination servers.
   - Disposable session lifecycle with instant container scrubbing upon investigation completion.

3. **Synthetic Persona & Safe Credential Guard**:
   - Prevents analysts from entering real passwords into suspicious forms.
   - Provides 1-click synthetic test personas (fake email, test password, testnet card number) to safely trigger phishing form behaviors.

4. **Digital Forensics Mode & Chain of Custody**:
   - Assigns unique immutable investigation IDs (e.g. `CS-20261028-XXXXXXXX`).
   - Computes tamper-evident SHA-256 evidence integrity hashes.
   - Sanitizes and redacts passwords, session tokens, and auth headers from logs.
   - One-click export of JSON evidence packages and printable forensic reports.

---

## Project Structure

```text
cybershield/
├── .env.example                     # Environment configuration template
├── .gitignore
├── docker-compose.yml               # Multi-container local orchestration
├── Dockerfile.backend               # Hardened Python 3.11 backend container
├── Dockerfile.frontend              # Multi-stage Node/Nginx frontend container
├── Dockerfile.isolated-browser      # Hardened Chromium headless container
├── README.md
├── docs/
│   ├── ARCHITECTURE.md              # System diagrams & data flows
│   ├── THREAT_MODEL.md              # MITRE ATT&CK & dual-use tunnel guidance
│   └── FORENSIC_CHAIN_OF_CUSTODY.md # ISO/IEC 27037 evidence sealing
├── backend/
│   ├── requirements.txt
│   ├── pytest.ini
│   ├── app/
│   │   ├── main.py                  # FastAPI application entrypoint
│   │   ├── config.py                # Pydantic settings & environment
│   │   ├── database.py              # SQLite & PostgreSQL engine
│   │   ├── seed_data.py             # Preloaded synthetic forensic test samples
│   │   ├── models/                  # SQLAlchemy ORM models
│   │   │   ├── investigation.py
│   │   │   ├── forensic_artifact.py
│   │   │   └── audit_log.py
│   │   ├── schemas/                 # Pydantic request/response schemas
│   │   │   ├── analysis.py
│   │   │   ├── browser.py
│   │   │   └── forensics.py
│   │   ├── services/                # Core forensic engines
│   │   │   ├── ssrf_guard.py        # Anti-SSRF & DNS rebinding blocker
│   │   │   ├── safe_url_parser.py   # In-memory non-invasive URL parser
│   │   │   ├── tunnel_detector.py   # Public ingress tunnel signatures
│   │   │   ├── homograph_detector.py# IDN Punycode & glyph confusable analyzer
│   │   │   ├── dns_analyzer.py      # DNS records & IP metadata
│   │   │   ├── tls_analyzer.py      # TLS certificate & fingerprinting
│   │   │   ├── threat_intel.py      # Safe Browsing & threat intelligence
│   │   │   ├── risk_scorer.py       # Transparent 0-100 scoring engine
│   │   │   ├── isolated_browser.py  # Virtual browser & screencast streaming
│   │   │   └── report_exporter.py   # Evidence hashing & HTML reports
│   │   └── api/                     # REST API routers
│   └── tests/                       # Unit & integration test suite (24 tests)
└── frontend/
    ├── package.json
    ├── vite.config.ts
    ├── tailwind.config.js
    └── src/
        ├── App.tsx                  # Main cybersecurity dashboard
        ├── types/                   # TypeScript interfaces
        ├── services/api.ts          # Backend API client
        ├── constants/sampleUrls.ts  # 1-click forensic sample test cases
        └── components/              # Tactical dark-theme components
```

---

## Setup & Execution Guide

### Option 1: Native Local Run (Zero External Services Needed)

CyberShield is configured to run out-of-the-box using built-in SQLite, requiring no external databases or Docker containers.

#### On Windows (PowerShell):

```powershell
# 1. Navigate to backend directory
cd backend

# 2. Install Python dependencies
pip install -r requirements.txt

# 3. Run backend unit tests to verify security controls
python -m pytest

# 4. Start the FastAPI backend server (Port 8000)
uvicorn app.main:app --reload --port 8000

# 5. In a separate terminal, navigate to frontend directory
cd ..\frontend

# 6. Start the Vite React development server (Port 5173)
npm run dev
```

Open your browser to: **`http://localhost:5173`**

---

#### On Linux / macOS (Bash):

```bash
# 1. Navigate to backend directory
cd backend

# 2. Create virtual environment & install requirements
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# 3. Run test suite
python -m pytest

# 4. Start the backend server
uvicorn app.main:app --reload --port 8000

# 5. In a separate terminal, start frontend
cd ../frontend
npm run dev
```

---

### Option 2: Docker Compose Orchestration

To run CyberShield with a dedicated PostgreSQL database and isolated browser container:

```bash
# Copy environment template
cp .env.example .env

# Build and start all services in isolated containers
docker-compose up --build -d

# Verify running services
docker-compose ps
```

- **Frontend Dashboard**: `http://localhost:3000`
- **FastAPI Documentation**: `http://localhost:8000/docs`
- **PostgreSQL Database**: `localhost:5432`

---

## Test Samples for Verification

CyberShield includes 6 preloaded synthetic forensic test samples selectable directly from the dashboard:

| Sample Name | Target URL | Expected Risk | Key Indicators Tested |
| :--- | :--- | :--- | :--- |
| **Ngrok Credential Harvester** | `https://security-verify-account.ngrok-free.app/login` | **CRITICAL (88)** | Ngrok ingress, base64 tracking token, redirect parameter, active threat intel match. |
| **Cloudflare Tunnel M365 Spoof** | `https://m365-password-reset.trycloudflare.com` | **CRITICAL (85)** | Quick Tunnel detection, brand subdomain masquerade under trycloudflare root. |
| **Homograph Punycode Apple Lure** | `https://xn--pple-43d.com/secure-signin` | **CRITICAL (92)** | Punycode decoding, Cyrillic lookalike glyph `\u0430` (U+0430) impersonating `apple.com`. |
| **Raw IP Unencrypted Portal** | `http://198.51.100.45:8080/portal/auth` | **HIGH (75)** | Direct IPv4 address, unencrypted HTTP, non-standard port 8080. |
| **Developer Webhook Tunnel (Dual-Use)** | `https://dev-webhook-test.ngrok.app` | **MEDIUM (35)** | Validates dual-use nuance: tunnel identified without false-positive phishing escalation. |
| **Benign Official Repository** | `https://github.com/security` | **LOW (5)** | Established domain, valid TLS 1.3 DigiCert certificate, clean threat reputation. |

---

## Security & Forensic Policy Notices

> [!IMPORTANT]
> **Virtual Isolation Limits**: Isolated browser streaming shields your local machine from client-side exploit code, zero-days, and drive-by malware. However, remote browser isolation cannot guarantee protection if genuine passwords or credit card details are entered into the viewport. Always use the **Synthetic Persona Generator** for form interaction.

> [!NOTE]
> **Residential IP Protection**: Isolated traffic exits through configured proxy gateways (`194.135.211.89`). Destination servers do not receive your residential IP. However, the upstream gateway provider observes traffic; CyberShield does not claim absolute untraceable anonymity.

> [!WARNING]
> **Dual-Use Infrastructure**: Legitimate software engineers frequently use public tunneling services (e.g. ngrok, Cloudflare Tunnel) for webhooks and staging. Tunnel provider detection is an infrastructure risk factor, never conclusive proof of malicious intent.

---

## License

CyberShield is distributed under the MIT License for educational, defensive, and authorized digital forensics research.
