# ADR-0002 · SQLite local con Drift como fuente de verdad

- **Estado:** aceptado
- **Fecha:** 2026-11-14

## Contexto

Requisito no funcional: funcionar sin conexión, con lectura rápida y escrituras transaccionales. El usuario no debe crear cuenta ni sincronizar datos.

## Decisión

Usar SQLite embebido mediante Drift. Una sola base `kipu_budget.sqlite` en el directorio de soporte de la app. El acceso se abre en un isolate de fondo (`NativeDatabase.createInBackground`).

Cada conexión activa `PRAGMA foreign_keys = ON` y `busy_timeout` en `beforeOpen`, porque SQLite desactiva las claves foráneas por conexión. El esquema se versiona con `schemaVersion` y `MigrationStrategy`; las migraciones se añaden como pasos idempotentes.

## Consecuencias

- Consultas reactivas: la UI escucha streams y se actualiza sin refresco manual.
- Los reportes usan SQL de solo lectura, sin abrir conexiones propias.
- Cualquier cambio de esquema exige migración versionada y prueba de esquema.
- El respaldo es un archivo SQLite portable; no hay formato propietario.
