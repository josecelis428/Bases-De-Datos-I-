# Tarea 4 — Red Social Estudiantil Pascualina

## Estructura
- `diccionarios/diccionario-generico/diccionario_generico.xlsx`: modelo lógico genérico.
- `diccionarios/diccionario-sgbd-1-postgresql/diccionario_fisico_postgresql.xlsx`: diccionario físico PostgreSQL.
- `diccionarios/diccionario-sgbd-2-mysql/diccionario_fisico_mysql.xlsx`: diccionario físico MySQL.
- `diccionarios/diccionario-sgbd-3-sql-server/diccionario_fisico_sql_server.xlsx`: diccionario físico SQL Server.
- `diccionarios/diccionarios_tarea4.xlsx`: libro consolidado para consulta rápida.
- `ddl/postgresql.sql`, `ddl/mysql.sql`, `ddl/sql_server.sql`: scripts DDL separados por motor.
- `ddl/pruebas_postgresql.sql`, `ddl/pruebas_mysql.sql`, `ddl/pruebas_sql_server.sql`: scripts de pruebas de ejemplo por motor.
- `informe/informe_tecnico_tarea4.docx` y `.pdf`: informe editable y PDF.
- `evidencias/`: guía para las capturas reales.
- `video/guion_sustentacion_tarea4.docx`: guion de video y `ENLACE_VIDEO.txt` pendiente.

## Modelo y criterios
Se conservan las diez tablas y las trece claves foráneas de la propuesta. Se priorizan los tamaños y restricciones explícitos en el informe PDF de Tarea 3 cuando diferían del script/Excel posterior. Se corrigió la referencia `estudiante_evento.id_evento -> evento.id_evento`. `datos_extra` se representa con JSONB en PostgreSQL, JSON en MySQL y NVARCHAR(MAX) validado con ISJSON en SQL Server (versiones indicadas en los scripts).

## Antes de publicar como entrega final
1. Ejecutar cada DDL en su motor y guardar capturas reales.
2. Ejecutar pruebas válidas y negativas y documentar los resultados observados.
3. Revisar que las versiones de motor coincidan con los comentarios de los scripts.
4. Completar conclusiones individuales según el trabajo real de cada integrante.
5. Pegar el enlace real de YouTube en `video/ENLACE_VIDEO.txt`.
6. No afirmar que un motor fue ejecutado si no hay evidencia.
