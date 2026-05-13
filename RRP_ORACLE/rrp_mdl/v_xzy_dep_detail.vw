CREATE OR REPLACE FORCE VIEW RRP_MDL.V_XZY_DEP_DETAIL AS
SELECT
    p.owner AS object_owner,                    -- 对象用户（存储过程所属用户）
    p.object_name AS object_name,               -- 对象名（存储过程名）
    p.object_type AS object_type,               -- 对象类型（PROCEDURE、FUNCTION、PACKAGE等）
    d.referenced_type AS dependency_type,       -- 依赖类型（表、视图、存储过程等）
    d.referenced_owner AS referenced_owner,     -- 依赖用户（依赖对象所属用户）
    d.referenced_name AS referenced_name,       -- 依赖对象名称
    tc.column_name AS column_name,              -- 依赖对象字段（表字段名）
    tc.data_type AS data_type,                  -- 字段数据类型
    tc.data_length AS data_length,              -- 字段数据长度
    tc.data_precision AS data_precision,        -- 字段数据精度（数字类型）
    tc.data_scale AS data_scale,                -- 字段小数位数（数字类型）
    tc.nullable AS nullable,                    -- 是否可为空（Y/N）
    tc.column_id AS column_position,            -- 字段在表中的位置
    'TABLE_COLUMN' AS record_type               -- 记录类型标识
FROM
    all_objects p
    JOIN all_dependencies d ON p.owner = d.owner AND p.object_name = d.name
    JOIN all_tab_columns tc ON d.referenced_owner = tc.owner
                           AND d.referenced_name = tc.table_name
WHERE
    p.object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY')
    AND D.referenced_owner NOT IN ('SYS')
    AND d.referenced_type IN ('TABLE', 'VIEW')
    -- 指定用户
    AND p.owner in ('RRP_MDL','RRP_IND','RRP_IMAS','RRP_BFD','RRP_EAST',
                             'RRP_DIIS','RRP_CRRS','RRP_CAP','RRP_BSSDEV',
                             'RRP_YBT','RRP_MRPT')

UNION ALL

-- 查询非表字段依赖（其他类型的依赖对象）
SELECT
    p.owner AS object_owner,                    -- 对象用户（存储过程所属用户）
    p.object_name AS object_name,               -- 对象名（存储过程名）
    p.object_type AS object_type,               -- 对象类型（PROCEDURE、FUNCTION、PACKAGE等）
    d.referenced_type AS dependency_type,       -- 依赖类型（表、视图、存储过程等）
    d.referenced_owner AS referenced_owner,     -- 依赖用户（依赖对象所属用户）
    d.referenced_name AS referenced_name,       -- 依赖对象名称
    NULL AS column_name,                        -- 依赖对象字段（非表依赖为空）
    NULL AS data_type,                          -- 字段数据类型（非表依赖为空）
    NULL AS data_length,                        -- 字段数据长度（非表依赖为空）
    NULL AS data_precision,                     -- 字段数据精度（非表依赖为空）
    NULL AS data_scale,                         -- 字段小数位数（非表依赖为空）
    NULL AS nullable,                           -- 是否可为空（非表依赖为空）
    NULL AS column_position,                    -- 字段在表中的位置（非表依赖为空）
    'OBJECT_ONLY' AS record_type                -- 记录类型标识
FROM
    all_objects p
    JOIN all_dependencies d ON p.owner = d.owner AND p.object_name = d.name
WHERE
    p.object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY')
    AND D.referenced_owner NOT IN ('SYS')
    AND d.referenced_type NOT IN ('TABLE', 'VIEW')
    -- 指定用户
    AND p.owner in ('RRP_MDL','RRP_IND','RRP_IMAS','RRP_BFD','RRP_EAST',
                             'RRP_DIIS','RRP_CRRS','RRP_CAP','RRP_BSSDEV',
                             'RRP_YBT','RRP_MRPT')
ORDER BY
    object_owner,
    object_name,
    dependency_type,
    referenced_name,
    column_position
;

