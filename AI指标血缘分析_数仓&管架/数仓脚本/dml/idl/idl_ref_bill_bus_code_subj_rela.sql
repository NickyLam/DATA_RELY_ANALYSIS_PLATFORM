/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ref_bill_bus_code_subj_rela
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
--alter table ${idl_schema}.ref_bill_bus_code_subj_rela drop partition p_${last_date};
alter table ${idl_schema}.ref_bill_bus_code_subj_rela drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ref_bill_bus_code_subj_rela add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ref_bill_bus_code_subj_rela (
    etl_dt  -- 数据日期
    ,subj_id  -- 科目编号
    ,subj_name  -- 科目名称
    ,bus_code  -- 业务编码
    ,amt_type_cd  -- 金额类型代码
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.subj_name,chr(13),''),chr(10),'')  -- 科目名称
    ,replace(replace(t1.bus_code,chr(13),''),chr(10),'')  -- 业务编码
    ,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'')  -- 金额类型代码
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
from ${iml_schema}.ref_bill_bus_code_subj_rela t1    --票据业务编码和科目关系
where etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ref_bill_bus_code_subj_rela',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);