# 국내 주식 관심종목 앱

이든크루 Flutter 신입 개발자 과제 — **과제 1** 구현 프로젝트입니다.

Naver 금융 API 4개를 연동해 관심종목·검색·종목상세 화면을 Flutter로 구현했습니다.

---

## 실행 방법

### Flutter 버전

- **Flutter 3.41.7** (stable)
- **Dart 3.11.5**

### 실행 명령

```bash
flutter pub get
flutter run
```

정적 분석:

```bash
flutter analyze
```

테스트 (선택):

```bash
flutter test
```

### 확인한 플랫폼과 기기

- **Android** — 실기기 / 에뮬레이터에서 확인
- Chrome(웹)은 **동작하지 않음** — Naver API CORS 제한

### 폰트 처리 방식

- 스타터에 포함된 **Noto Sans KR** 로컬 폰트를 그대로 사용
- `pubspec.yaml`에 Regular / Medium / Bold 등록, `AppTheme.dark`에서 `NotoSansKR` family 적용
- `google_fonts` 등 다른 방식으로 변경하지 않음

---

## 구현 범위

### 과제 1 — 필수 항목

| 화면 | 상태 |
| --- | --- |
| `01 · 관심` — 목록, 정렬, 새로고침, 스켈레톤, 빈 상태 | ✅ |
| `02 · 검색` — 검색, 하이라이트, 관심 토글, 토스트, 빈/결과없음 상태 | ✅ |
| `03 · 종목상세` — 헤더, 현재가, 기간 탭, 차트, 요약 카드, 일별 시세 | ✅ |
| 관심 상태 3화면 동기화 | ✅ |
| Naver API 4개 연동 (검색 / 실시간 / 메타 / 일별 HTML) | ✅ |
| 디자인 토큰 사용 (`context.colors`, `context.dimens`) | ✅ |
| `flutter analyze` 통과 | ✅ |

### 과제 1 — 남은 항목

- 없음 (필수 항목 기준)

### 추가로 구현한 선택 항목

- 없음

### 테스트

- `test/widget_test.dart` — 앱 시작 시 다크 테마 + 관심 빈 상태 렌더링 확인
- 실행 결과:

```text
flutter test
00:01 +1: All tests passed!
```

---

## 기술 선택과 이유

### 상태관리 — Riverpod

- 전역 `favoritesProvider`로 3화면 관심 상태를 한곳에서 관리
- `AsyncNotifier` / `FutureProvider`로 로딩·에러·데이터 상태를 UI에서 `when()`으로 처리
- 컴파일 타임 안전성과 provider 간 의존(`ref.watch`)이 명확함

### 폴더 구조 — Clean Architecture (UseCase 없음)

```text
lib/
  core/           URL, 에러, 포맷 유틸
  domain/         Entity, Repository 인터페이스
  data/           DTO, DataSource, Repository 구현
  presentation/   Screen, Widget, Provider
  theme/          디자인 토큰 (스타터 제공)
```

- **Provider → Repository → DataSource** 흐름
- UseCase 계층은 과제 규모 대비 보일러플레이트만 늘어난다고 판단해 생략
- UI는 Naver를 모름 — `StockRepository` 추상 인터페이스만 의존

### 주요 패키지

| 패키지 | 용도 |
| --- | --- |
| `flutter_riverpod` | 상태관리 |
| `http` | Naver API HTTP 요청 |
| `charset` | 일별 시세 HTML EUC-KR 디코딩 |
| `html` | 일별 시세 HTML 파싱 |

### 차트 처리 방식

- **CustomPainter** (`CandlestickChart`)로 직접 구현
- 외부 차트 패키지 없이 `chartLineUp` / `chartLineDown` 토큰 색상을 정확히 맞춤
- 캔들 두께·간격 등 렌더링 디테일은 시안과 다를 수 있으나, 과제에서 허용하는 범위

### 디자인 토큰 추가

- 스타터 제공 토큰만 사용, **추가 토큰 없음**
- hex 직접 사용 없이 `context.colors.*`, `context.dimens.*`만 참조

---

## 직접 판단한 부분과 이유

### 토스트 노출 시간과 사라지는 방식

- **2초 후 자동 dismiss** (`FavoriteToast`, `Duration(seconds: 2)`)
- Figma에 시간 미정 → 일반적인 UX 기준 적용
- 새 토스트가 뜨면 이전 OverlayEntry를 제거해 중복 방지
- 등장/퇴장 애니메이션 없음 (선택 항목)

### 로딩 / 네트워크 에러 / 긴 종목명 오버플로

| 상황 | 처리 |
| --- | --- |
| 로딩 | `CircularProgressIndicator` (목록 전체) |
| 네트워크 에러 | `"시세를 불러오지 못했습니다"` / `"종목 정보를 불러오지 못했습니다"` 문구 |
| 시세 미수신 행 | `SkeletonBox` (`feedbackSkeleton` 토큰) |
| 긴 종목명 | `maxLines: 1`, `overflow: TextOverflow.ellipsis` |

### 시세를 못 받은 행 — 정렬 처리

- `현재가순` / `등락률순` 정렬 시 **가격 없는 행은 목록 맨 아래**로 배치
- Figma에 정의 없음 → 데이터 없는 항목을 상단에 두면 사용자 혼란 가능성이 높다고 판단

### Figma와 다르게 구현한 부분

| 항목 | 구현 | 이유 |
| --- | --- | --- |
| 요약 카드 그리드 | `Wrap` 레이아웃 | `GridView` 고정 `childAspectRatio`에서 1px overflow 발생 |
| 차트 렌더링 | CustomPainter | 패키지 의존 없이 토큰 색상 제어 |
| DEBUG 배너 | `debugShowCheckedModeBanner: false` | 실제 앱 UI 확인용 |

---

## 막혔던 지점과 접근 방법

### 1. 일별 시세 HTML 한글 깨짐

- **문제:** UTF-8로 디코딩하면 한글이 깨짐
- **해결:** `charset` 패키지의 `eucKr.decode(response.bodyBytes)` 사용

### 2. 실시간 시세 API 인코딩

- **문제:** JSON 응답도 EUC-KR 인코딩
- **해결:** `bodyBytes` + `eucKr.decode` 후 `jsonDecode`

### 3. Flutter `Element` vs HTML `Element` 이름 충돌

- **문제:** `html` 패키지와 Flutter 위젯 `Element` 충돌
- **해결:** `import 'package:html/dom.dart' as dom;` 후 `dom.Element` 사용

### 4. 차트 기간 전환 시 페이지 재요청

- **문제:** 1개월 → 1년 전환 시 이미 받은 페이지를 다시 요청
- **해결:** `dailyPriceCacheProvider` + `getDailyPricesForPages()`에서 `Map<int, List<DailyPrice>>` 캐시 재사용

### 5. 요약 카드 bottom overflow

- **문제:** `GridView` `childAspectRatio: 2.4`가 콘텐츠보다 1px 짧음
- **해결:** `LayoutBuilder` + `Wrap`으로 콘텐츠 높이에 맞게 배치

---

## 과제 2 (Lucy Studio)

- **상태:** 미구현
- **제출물:** `cloneProject/assets` 압축 파일 (Lucy Studio `targetAlert` 페이지)

---

## 참고 문서

- [`docs/ASSIGNMENT.md`](docs/ASSIGNMENT.md) — 과제 요구사항 원본
- [`docs/NAVER_API.md`](docs/NAVER_API.md) — Naver API 연동 가이드
- [`lib/theme/README.md`](lib/theme/README.md) — Figma ↔ Dart 토큰 대응표
