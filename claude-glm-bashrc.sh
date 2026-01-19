# ============================================================
# Claude Code --glm 모드 전환 설정
# ============================================================
# 사용법:
#   1. 이 내용을 ~/.bashrc 파일 맨 아래에 추가
#   2. source ~/.bashrc 실행
#   3. claude (Anthropic 구독) 또는 claude --glm (z.ai API) 사용
# ============================================================

# z.ai API 설정
export ZAI_API_KEY="여기에_z.ai_API_키_입력"
export ZAI_BASE_URL="https://api.z.ai/api/anthropic"

# claude 명령어 래핑 함수
claude() {
    if [ "$1" = "--glm" ]; then
        shift
        echo "🔷 z.ai GLM 모드로 Claude Code 실행"
        ANTHROPIC_API_KEY="$ZAI_API_KEY" \
        ANTHROPIC_BASE_URL="$ZAI_BASE_URL" \
        command claude "$@"
    else
        echo "🟢 Anthropic 구독 모드로 Claude Code 실행"
        command claude "$@"
    fi
}

# 사용법 확인 함수
claude-status() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Claude Code 모드 전환 사용법"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  claude          → Anthropic 구독 모드"
    echo "  claude --glm    → z.ai API 모드"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "  추가 옵션 예시:"
    echo "  claude --glm --model claude-sonnet-4-5-20250929"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}
