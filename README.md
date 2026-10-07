# GlassesGPT — Ray-Ban Meta Gen 2 → ChatGPT

Цель проекта: hands-free сценарий на iPhone:

**“Hey Meta” → запуск приложения → речь с Ray-Ban → ChatGPT → голосовой ответ в очки.**

## Сборка без собственного Mac

Репозиторий настроен на GitHub Actions с macOS runner. Workflow генерирует Xcode-проект через XcodeGen и пытается собрать unsigned IPA для физического iPhone.

## Важно

- iPhone всё равно используется как посредник для Ray-Ban Meta Gen 2.
- Первичная регистрация/разрешения потребуют действий на телефоне.
- Voice Invocations и Speech в Meta Wearables Device Access Toolkit могут использовать experimental API.
- Для собственного приложения ChatGPT Plus не заменяет OpenAI API-доступ.
- OpenAI API key нельзя хранить в iOS-приложении; позже подключим backend.

## Следующая цель

Сначала добиться успешной облачной сборки и проверить:
1. подключение Meta Wearables SDK;
2. регистрацию приложения;
3. voice invocation;
4. получение транскрипции;
5. аудио-ответ в Ray-Ban.

После этого подключим OpenAI.
