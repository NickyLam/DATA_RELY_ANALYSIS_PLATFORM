 /*
Purpose:    用户角色分配
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_sys_user_role
CreateDate: 20201118
Logs:
   20201118 xwy 新建脚本
*/

set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

--%904总监室
--800984 湛江业务工作组，放到分行行领导用户角色
--以下人员剔除：    11130001刘炽峰
--                  00050638林贞谋
--             
--%903 行长室
--800918计划财务部
--805905、805906深圳分行行长室2、深圳分行行长室3


--删除角色'220','221','222'的用户
DELETE FROM SYS_USER_ROLE WHERE ROLE_ID IN ('120','121','122');
COMMIT;

--离职用户删除角色 20220222
delete sys_user_role
 where user_id in (select t2.user_id
                     from mtl_pty_emply t1
                    inner join sys_user t2 on t1.emply_id = t2.remark
                    where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                          and emply_status_cd = '2' --离职
                          and id_mark <> 'D'); 

COMMIT;
       
--用户分配角色'220','221','222'
INSERT INTO SYS_USER_ROLE
SELECT T2.USER_ID AS USER_ID--用户ID
      ,'120'      AS ROLE_ID--角色ID
FROM MTL_PTY_EMPLY T1--分配总行行领导用户角色（不含总监室800904）
LEFT JOIN SYS_USER T2
ON T1.EMPLY_ID=T2.REMARK
WHERE  T1.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
    AND T1.ID_MARK <> 'D'
    AND T1.EMPLY_STATUS_CD <> '2'
    AND T1.BELONG_DEPT_ID  = '800903'   
UNION ALL
SELECT T2.USER_ID AS USER_ID--用户ID
      ,'121'      AS ROLE_ID--角色ID
FROM MTL_PTY_EMPLY T1--分配分行分行行领导、湛江业务工作组、分行总监室用户角色
LEFT JOIN SYS_USER T2
ON T1.EMPLY_ID=T2.REMARK
WHERE  T1.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
    AND T1.ID_MARK <> 'D'
    AND T1.EMPLY_STATUS_CD <> '2'
    AND ((T1.BELONG_DEPT_ID  = '800984' AND T1.EMPLY_ID in( '01060172','00110829')) -- 湛江业务工作组暂时固定人员1128
    OR T1.BELONG_DEPT_ID LIKE '%903' 
    and T1.BELONG_DEPT_ID <> '800903' 
    OR T1.BELONG_DEPT_ID IN('805905','805906')
    OR T1.BELONG_DEPT_ID LIKE '%904' 
    and T1.BELONG_DEPT_ID <> '800904'
    )
UNION ALL
SELECT T2.USER_ID AS USER_ID--用户ID
      ,'122'      AS ROLE_ID--角色ID
FROM MTL_PTY_EMPLY T1--分配计财部（总行）用户角色
LEFT JOIN SYS_USER T2
ON T1.EMPLY_ID=T2.REMARK
WHERE  T1.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
    AND T1.ID_MARK <> 'D'
    AND T1.EMPLY_STATUS_CD <> '2'
    AND T1.BELONG_DEPT_ID  = '800918';
COMMIT ;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'sys_user_role', degree => 8, cascade => true);