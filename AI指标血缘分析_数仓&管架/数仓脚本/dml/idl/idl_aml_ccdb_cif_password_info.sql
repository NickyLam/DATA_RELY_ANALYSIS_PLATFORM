/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_ccdb_cif_password_info
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
alter table ${idl_schema}.aml_ccdb_cif_password_info drop partition p_${last_date};
alter table ${idl_schema}.aml_ccdb_cif_password_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_ccdb_cif_password_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_ccdb_cif_password_info (
    etl_dt  -- 数据日期
    ,id  -- 流水号
    ,customer_no  -- 客户号
    ,business_type  -- 业务类型
    ,password_type  -- 密码类型
    ,status  -- 状态
    ,update_date  -- 更新日期
    ,version  -- 版本号
    ,card_no  -- 账号
    ,password  -- 密码（密文）
    ,from_channel  -- 请求渠道
    ,verify_error_num  -- 验证错误次数
    ,verify_record_date  -- 验证日期
    ,start_dt  -- 开始日期
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,t1.id  -- 流水号
    ,replace(replace(t1.customer_no,chr(13),''),chr(10),'')  -- 客户号
    ,replace(replace(t1.business_type,chr(13),''),chr(10),'')  -- 业务类型
    ,replace(replace(t1.password_type,chr(13),''),chr(10),'')  -- 密码类型
    ,replace(replace(t1.status,chr(13),''),chr(10),'')  -- 状态
    ,t1.update_date  -- 更新日期
    ,t1.version  -- 版本号
    ,replace(replace(t1.card_no,chr(13),''),chr(10),'')  -- 账号
    ,replace(replace(t1.password,chr(13),''),chr(10),'')  -- 密码（密文）
    ,replace(replace(t1.from_channel,chr(13),''),chr(10),'')  -- 请求渠道
    ,t1.verify_error_num  -- 验证错误次数
    ,t1.verify_record_date  -- 验证日期
    ,t1.start_dt  -- 开始日期
    ,t1.end_dt  -- 结束日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ccdb_cif_password_info t1    --客户查询密码管理
where t1.start_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_ccdb_cif_password_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);