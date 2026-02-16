# Kiro Agent Hooks for test-provisioning

이 디렉토리에는 test-provisioning 레포를 위한 자동화된 PR 생성 Hook들이 있습니다.

## 사용 가능한 Hook들

### 1. `/create-pr` - 완전 자동화 PR 생성
- **파일**: `create-pr.yaml`
- **기능**: 
  - 자동 브랜치 생성 (타임스탬프 기반)
  - 변경사항 분석 및 커밋 메시지 자동 생성
  - 상세한 PR Description 생성
  - 파일 변경 유형별 분류 (추가/수정/삭제)
  - Terraform 변경사항 특별 처리

### 2. `/qpr` - 빠른 PR 생성
- **파일**: `quick-pr.yaml`
- **기능**:
  - 간단하고 빠른 PR 생성
  - 최소한의 설정으로 즉시 실행
  - 기본적인 커밋 메시지와 PR 설명

### 3. `/tfpr` - Terraform 전용 PR
- **파일**: `terraform-pr.yaml`
- **기능**:
  - Terraform 파일 변경사항만 감지
  - Terraform plan 실행 결과 포함
  - 인프라 변경사항에 특화된 PR 템플릿
  - 자동 라벨링 (terraform, infrastructure)

## 사용법

1. **Command Palette 사용**:
   - `Cmd+Shift+P` → "Run Agent Hook" 검색
   - 원하는 Hook 선택

2. **터미널에서 직접 실행**:
   ```bash
   /create-pr  # 완전 자동화 버전
   /qpr        # 빠른 버전
   /tfpr       # Terraform 전용
   ```

## 필요 조건

- GitHub CLI (`gh`) 설치 및 인증 완료
- Git 설정 완료
- 적절한 브랜치 권한

## 커스터마이징

각 Hook 파일을 수정하여 다음을 조정할 수 있습니다:
- 브랜치 명명 규칙
- 커밋 메시지 템플릿
- PR Description 형식
- 자동 리뷰어 할당
- 라벨 설정

## 문제 해결

- **GitHub CLI 인증 오류**: `gh auth login` 실행
- **브랜치 권한 오류**: 레포 권한 확인
- **Terraform plan 실패**: 해당 디렉토리의 Terraform 설정 확인