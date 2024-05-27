-- Lista de visões
SELECT table_schema as name_schema, table_name as object_name, privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'weknow'
union
SELECT routine_schema as name_schema, routine_name as object_name, privilege_type
FROM information_schema.routine_privileges
WHERE grantee = 'weknow'
