# Gradle ANTLR PL/SQL Plugin

![Conformance](https://img.shields.io/badge/Conformance-Check--All%20Passing-brightgreen)

[![Release](https://img.shields.io/github/v/release/flowdigger/gradle-antlr-plsql-plugin?sort=semver)](https://central.sonatype.com/search?q=g:org.flowdigger.gradle%20AND%20a:gradle-antlr-plsql-plugin)
[![Maven Central](https://img.shields.io/maven-central/v/org.flowdigger.gradle/gradle-antlr-plsql-plugin?label=Maven%20Central)](https://central.sonatype.com/search?q=g:org.flowdigger.gradle%20AND%20a:gradle-antlr-plsql-plugin)

[![Build and Test](https://github.com/flowdigger/gradle-antlr-plsql-plugin/actions/workflows/ci.yml/badge.svg)](https://github.com/flowdigger/gradle-antlr-plsql-plugin/actions/workflows/ci.yml)
[![JUnit Report](https://img.shields.io/badge/JUnit-Report-blue?logo=githubactions)](https://github.com/flowdigger/gradle-antlr-plsql-plugin/actions/workflows/ci.yml)
[![Coverage CI](https://github.com/flowdigger/gradle-antlr-plsql-plugin/actions/workflows/coverage.yml/badge.svg)](https://github.com/flowdigger/gradle-antlr-plsql-plugin/actions/workflows/coverage.yml)
[![CodeQL](https://github.com/flowdigger/gradle-antlr-plsql-plugin/actions/workflows/codeql.yml/badge.svg)](https://github.com/flowdigger/gradle-antlr-plsql-plugin/actions/workflows/codeql.yml)
[![Dependency Check](https://github.com/flowdigger/gradle-antlr-plsql-plugin/actions/workflows/dependency-check.yml/badge.svg)](https://github.com/flowdigger/gradle-antlr-plsql-plugin/actions/workflows/dependency-check.yml)
[![SpotBugs Security](https://github.com/flowdigger/gradle-antlr-plsql-plugin/actions/workflows/spotbugs-security.yml/badge.svg)](https://github.com/flowdigger/gradle-antlr-plsql-plugin/actions/workflows/spotbugs-security.yml)
[![Checkstyle](https://github.com/flowdigger/gradle-antlr-plsql-plugin/actions/workflows/checkstyle.yml/badge.svg)](https://github.com/flowdigger/gradle-antlr-plsql-plugin/actions/workflows/checkstyle.yml)
[![Dependabot](https://img.shields.io/badge/dependabot-enabled-025E8C?logo=dependabot)](https://github.com/flowdigger/gradle-antlr-plsql-plugin/security/dependabot)
[![Coverage](https://codecov.io/gh/flowdigger/gradle-antlr-plsql-plugin/graph/badge.svg?branch=main)](https://codecov.io/gh/flowdigger/gradle-antlr-plsql-plugin)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Java](https://img.shields.io/badge/java-21+-green.svg)](https://www.oracle.com/java/)
[![Gradle](https://img.shields.io/badge/gradle-9.5+-blue.svg)](https://gradle.org/)

`gradle-antlr-plsql-plugin` provides preconfigured XML AST task support for PL/SQL parsing workflows.

It builds on `name.flowdigger.gradle.antlr` and offers task defaults tailored for `PlSqlLexer`/`PlSqlParser` use cases.

## Position in XIR spine

- **Problem solved**: convert PL/SQL implementation assets into deterministic structural observations.
- **Relation to XIR**: domain-specific observation adapter for derivation pipelines.
- **Why it matters**: feeds lineage and governance workflows with reproducible evidence.

```text
Structured Knowledge -> XIR -> Observation -> Derivation -> Knowledge -> Applications
```

## Use Cases

- Convert large PL/SQL corpora to XML AST for lineage extraction
- Validate parser compatibility in CI against benchmark SQL files
- Run parser checks with sensible defaults and minimal Gradle setup
- Keep conversion as first-class Gradle tasks (repeatable and automatable)

## Install

```groovy
plugins {
    id 'name.flowdigger.gradle.antlr.plsql'
}
```

## What the Plugin Adds

- `XmlAstPlsqlGradleTask` task type
- `plsqlXmlAst` pre-registered task
- Runtime classpath and `classes` dependency wiring when `java` plugin is present

Default task conventions:

- `grammar = plsql`
- `parserClassName = name.flowdigger.parsers.PlSqlParser`
- `lexerClassName = name.flowdigger.parsers.PlSqlLexer`
- `startRule = script`
- `includes = ['**/*.sql', '**/*.pks', '**/*.pkb', '**/*.pls']`

## Quick Start

```groovy
plugins {
    id 'java'
    id 'name.flowdigger.gradle.antlr.plsql' 
}

tasks.named('plsqlXmlAst', name.flowdigger.grammars.plsql.XmlAstPlsqlGradleTask) {
    sourceDirectory.set(layout.projectDirectory.dir('src/test/resources/plsql'))
    destinationDirectory.set(layout.buildDirectory.dir('xmlast-plsql'))
    targetExtension.set('.xml')
    continueOnError.set(true)
}
```

S-expression output variant:

```groovy
tasks.named('plsqlXmlAst', name.flowdigger.gradle.antlr.XmlAstPlsqlGradleTask) {
    targetExtension.set('.xir')
    outputFormat.set('beautified')
}
```

- `targetExtension`: `.xml` (default) or `.xir`
- `outputFormat`: `compact` (default) or `beautified`

Run:

```bash
./gradlew plsqlXmlAst
```

## Benchmark and Profiling

Run repeatable benchmark/profile matrix with JFR capture:

```bash
./scripts/profile-xmlast.sh
```

Fast-mode profiling default disables per-file line-count reread (`enableLineCountMetrics=false`).
Set `DECISION_PROFILING=true` to emit grammar decision hotspots in report.

Guide and tunables: `PERF_PROFILING.md`

## Troubleshooting

- `ClassNotFoundException` for parser/lexer classes:
  - Ensure `compileAntlrSources` ran
  - Ensure runtime classpath includes generated classes
- Parse starts but no output files:
  - Verify `sourceDirectory` and `includes`
  - Set `force = true` for a full pass
- Start rule issues:
  - Confirm parser entry method exists (default is `script`)
