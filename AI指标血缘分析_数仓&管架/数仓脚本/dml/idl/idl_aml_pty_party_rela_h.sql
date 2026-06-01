/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_pty_party_rela_h
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
alter table ${idl_schema}.aml_pty_party_rela_h drop partition p_${last_date};
alter table ${idl_schema}.aml_pty_party_rela_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_pty_party_rela_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_pty_party_rela_h partition for (to_date('${batch_date}','yyyymmdd')) (
    party_id  -- 当事人编号
    ,lp_id  -- 法人编号
    ,party_rela_type_cd  -- 当事人关系类型代码
    ,seq_num  -- 序号
    ,start_dt  -- 开始日期
    ,rela_party_id  -- 关联当事人编号
    ,valid_flg  -- 有效标志
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,src_table_name  -- 源表名称
    ,job_cd  -- 任务代码
    ,etl_dt  -- 数据日期
    ,etl_timestamp  -- 数据处理时间
)
select
    replace(replace(t1.party_id,chr(13),''),chr(10),'')  -- 当事人编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.party_rela_type_cd,chr(13),''),chr(10),'')  -- 当事人关系类型代码
    ,replace(replace(t1.seq_num,chr(13),''),chr(10),'')  -- 序号
    ,t1.start_dt  -- 开始日期
    ,replace(replace(t1.rela_party_id,chr(13),''),chr(10),'')  -- 关联当事人编号
    ,replace(replace(t1.valid_flg,chr(13),''),chr(10),'')  -- 有效标志
    ,t1.end_dt  -- 结束日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.src_table_name,chr(13),''),chr(10),'')  -- 源表名称
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,t1.etl_timestamp  -- 数据处理时间
from ${iml_schema}.pty_party_rela_h t1    --当事人关系历史
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_pty_party_rela_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);