/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_osbs_ats_securitymobile
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_osbs_ats_securitymobile drop partition p_${last_date};
alter table ${idl_schema}.aml_osbs_ats_securitymobile drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_osbs_ats_securitymobile add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_osbs_ats_securitymobile partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,asm_cstno  -- 统一客户号
    ,asm_userno  -- 用户顺序号
    ,asm_mobile  -- 安全手机号
    ,asm_create_date  -- 创建日期
    ,asm_update_date  -- 最后修改日期
    ,asm_state  -- 状态
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.asm_cstno,chr(13),''),chr(10),'')  -- 统一客户号
    ,replace(replace(t1.asm_userno,chr(13),''),chr(10),'')  -- 用户顺序号
    ,replace(replace(t1.asm_mobile,chr(13),''),chr(10),'')  -- 安全手机号
    ,replace(replace(t1.asm_create_date,chr(13),''),chr(10),'')  -- 创建日期
    ,replace(replace(t1.asm_update_date,chr(13),''),chr(10),'')  -- 最后修改日期
    ,replace(replace(t1.asm_state,chr(13),''),chr(10),'')  -- 状态
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.osbs_ats_securitymobile t1    --安全手机号表
where t1.etl_dt= to_date('${batch_date}','yyyymmdd')  ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_osbs_ats_securitymobile',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);