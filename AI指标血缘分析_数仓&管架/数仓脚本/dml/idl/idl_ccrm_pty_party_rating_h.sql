/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ccrm_pty_party_rating_h
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
alter table ${idl_schema}.ccrm_pty_party_rating_h drop partition p_${last_date};
alter table ${idl_schema}.ccrm_pty_party_rating_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ccrm_pty_party_rating_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ccrm_pty_party_rating_h (
    etl_dt  -- 数据日期
    ,party_id  -- 当事人编号
    ,lp_id  -- 法人编号
    ,sorc_sys_cd  -- 源系统代码
    ,party_rating_type_cd  -- 当事人评级类型代码
    ,seq_num  -- 序号
    ,start_dt  -- 开始日期
    ,rating_org_id  -- 评级机构编号
    ,rating_org_name  -- 评级机构名称
    ,rating_dt  -- 评级日期
    ,rating_score_val  -- 评级分值
    ,rating_effect_dt  -- 评级生效日期
    ,rating_invalid_dt  -- 评级失效日期
    ,rating_result_cd  -- 评级结果代码
    ,irs_task_flow_num  -- 内评系统任务流水号
    ,rating_level_cd  -- 评级等级代码
    ,lmt  -- 限额
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.party_id,chr(13),''),chr(10),'')  -- 当事人编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'')  -- 源系统代码
    ,replace(replace(t1.party_rating_type_cd,chr(13),''),chr(10),'')  -- 当事人评级类型代码
    ,replace(replace(t1.seq_num,chr(13),''),chr(10),'')  -- 序号
    ,t1.start_dt  -- 开始日期
    ,replace(replace(t1.rating_org_id,chr(13),''),chr(10),'')  -- 评级机构编号
    ,replace(replace(t1.rating_org_name,chr(13),''),chr(10),'')  -- 评级机构名称
    ,t1.rating_dt  -- 评级日期
    ,t1.rating_score_val  -- 评级分值
    ,t1.rating_effect_dt  -- 评级生效日期
    ,t1.rating_invalid_dt  -- 评级失效日期
    ,replace(replace(t1.rating_result_cd,chr(13),''),chr(10),'')  -- 评级结果代码
    ,replace(replace(t1.irs_task_flow_num,chr(13),''),chr(10),'')  -- 内评系统任务流水号
    ,replace(replace(t1.rating_level_cd,chr(13),''),chr(10),'')  -- 评级等级代码
    ,t1.lmt  -- 限额
    ,t1.end_dt  -- 结束日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.pty_party_rating_h t1    --当事人评级历史
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ccrm_pty_party_rating_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);