# Claude Code --glm 모드 전환 설정

Claude Code에서 `--glm` 플래그 하나로 Anthropic 구독과 z.ai API를 쉽게 전환할 수 있습니다.

## 설치 방법

### macOS / Linux

#### zsh 사용자 (macOS 기본)

```bash
# 1. 설정 파일 열기
nano ~/.zshrc

# 2. claude-glm-zshrc.sh 내용을 맨 아래에 붙여넣기

# 3. API 키 수정
# ZAI_API_KEY="여기에_z.ai_API_키_입력" 부분을 실제 키로 변경

# 4. 저장 후 적용
source ~/.zshrc
```

#### bash 사용자 (Linux 기본)

```bash
# 1. 설정 파일 열기
nano ~/.bashrc

# 2. claude-glm-bashrc.sh 내용을 맨 아래에 붙여넣기

# 3. API 키 수정
# ZAI_API_KEY="여기에_z.ai_API_키_입력" 부분을 실제 키로 변경

# 4. 저장 후 적용
source ~/.bashrc
```

---

### Windows (PowerShell)

#### 원클릭 자동 설치 (권장)

```powershell
# 방법 1: 스크립트 실행 시 API 키 입력
.\install-claude-glm.ps1

# 방법 2: 명령행에서 API 키 직접 지정
.\install-claude-glm.ps1 -ApiKey "여러분의_z.ai_API_키"
```

**설치 스크립트가 자동으로 수행하는 작업:**
1. PowerShell 실행 정책 설정 (RemoteSigned)
2. Claude Code 설치 확인
3. API 키 입력 및 저장
4. 기존 claude 파일 백업 (claude-orig.ps1, claude-orig.cmd)
5. PowerShell 프로필 자동 생성 및 설정

**실행 정책 오류가 발생하면:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**설치 완료 후:**
- PowerShell을 닫고 새로 열어야 적용됩니다
- 새 PowerShell에서 `claude-status` 명령어로 설치 확인

#### 수동 설치 (자동 설치가 안 될 경우)

```powershell
# 1. PowerShell 프로필 열기
notepad $PROFILE

# 프로필이 없다면 먼저 생성
if (!(Test-Path -Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force }

# 2. 아래 내용을 프로필에 붙여넣기
# (install-claude-glm.ps1의 92-132줄 참조)

# 3. $env:ZAI_API_KEY 부분을 실제 API 키로 변경

# 4. 저장 후 적용
. $PROFILE
```

---

## 사용법

| 명령어 | 모드 | 플랫폼 |
|--------|------|--------|
| `claude` | Anthropic 구독 모드 | 모두 |
| `claude --glm` | z.ai API 모드 | 모두 |
| `claude-status` | 사용법 확인 | 모두 |

### 추가 옵션 사용

`--glm` 플래그 뒤에 원하는 옵션을 추가할 수 있습니다:

```bash
# 모델 지정
claude --glm --model claude-sonnet-4-5-20250929

# 대화 재개
claude --glm --resume

# 기타 모든 claude 옵션 사용 가능
claude --glm [옵션들...]
```

---

## 파일 구성

```
dist/
├── claude-glm-zshrc.sh       # macOS/zsh용
├── claude-glm-bashrc.sh      # Linux/bash용
├── install-claude-glm.ps1    # Windows 원클릭 설치 스크립트
└── README.md                 # 설치 가이드
```

---

## 플랫폼별 비교

| 항목 | macOS | Linux | Windows |
|------|-------|-------|---------|
| 설치 방식 | 수동 설정 | 수동 설정 | 원클릭 자동 설치 |
| 설정 파일 | `~/.zshrc` | `~/.bashrc` | `$PROFILE` (자동 생성) |
| 적용 명령 | `source ~/.zshrc` | `source ~/.bashrc` | PowerShell 재시작 |
| 모드 전환 | `claude --glm` | `claude --glm` | `claude --glm` |

---

## 동작 원리

### macOS/Linux
1. `claude` 함수가 원래 claude 명령어를 래핑
2. 첫 번째 인자가 `--glm`인지 확인
3. `--glm`이면 z.ai API 환경변수로 실행
4. 아니면 기본 Anthropic 구독으로 실행

### Windows
1. 기존 `claude.ps1`/`claude.cmd`를 `claude-orig.ps1`/`claude-orig.cmd`로 백업
2. PowerShell 프로필에 새 `claude` 함수 생성
3. `--glm` 플래그에 따라 API 엔드포인트 전환

```
claude 입력 → --glm 플래그?
                ├─ Yes → z.ai API 모드
                └─ No  → Anthropic 구독 모드
```

---

## 문제 해결

### Windows: PowerShell 실행 정책 오류

```
이 시스템에서 스크립트를 실행할 수 없으므로...
```

해결:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### claude 명령어를 찾을 수 없음

Claude Code가 설치되어 있고 PATH에 추가되어 있는지 확인하세요.

```powershell
# Windows
where.exe claude

# macOS/Linux
which claude
```

Claude Code 설치:
```bash
npm install -g @anthropic-ai/claude-code
```

### Windows: 설치 후 적용되지 않음

- PowerShell을 완전히 닫고 새로 열어주세요
- 새 PowerShell에서 `claude-status` 실행하여 확인
- 그래도 안 되면: `. $PROFILE` 실행

### API 키가 올바르지 않음

- z.ai 대시보드에서 API 키를 다시 확인하세요
- API 키에 공백이나 따옴표가 포함되어 있지 않은지 확인하세요
