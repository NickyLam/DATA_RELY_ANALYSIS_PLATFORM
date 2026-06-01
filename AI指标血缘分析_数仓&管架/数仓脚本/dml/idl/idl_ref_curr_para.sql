/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ref_curr_para
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
--alter table ${idl_schema}.ref_curr_para drop partition p_${last_date};
alter table ${idl_schema}.ref_curr_para drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ref_curr_para add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ref_curr_para (
    etl_dt  -- 数据日期
    ,curr_cd  -- 币种代码
    ,curr_name  -- 币种名称
    ,curr_en_abbr  -- 币种英文简称
    ,curr_sign_cd  -- 币种符号代码
    ,start_use_flg  -- 启用标志
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.curr_name,chr(13),''),chr(10),'')  -- 币种名称
    ,replace(replace(t1.curr_en_abbr,chr(13),''),chr(10),'')  -- 币种英文简称
    ,replace(replace(t1.curr_sign_cd,chr(13),''),chr(10),'')  -- 币种符号代码
    ,replace(replace(t1.start_use_flg,chr(13),''),chr(10),'')  -- 启用标志
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.ref_curr_para t1    --币种参数表
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ref_curr_para',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);