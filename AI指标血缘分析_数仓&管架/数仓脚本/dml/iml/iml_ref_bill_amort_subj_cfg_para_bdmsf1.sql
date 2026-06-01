/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_bill_amort_subj_cfg_para_bdmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_bill_amort_subj_cfg_para add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_bill_amort_subj_cfg_para partition for ('bdmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_tm purge;
drop table ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_op purge;
drop table ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    cfg_id -- 配置编号
    ,bill_type_cd -- 票据类型代码
    ,bus_type_cd -- 业务类型代码
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
    ,ext_dr_subj_id -- 外部借方科目编号
    ,ext_cr_subj_id -- 外部贷方科目编号
    ,subj_name -- 科目名称
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_bill_amort_subj_cfg_para partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_bill_amort_subj_cfg_para partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_bill_amort_subj_cfg_para partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_tla_lnpreintr_subj-
insert into ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_tm(
    cfg_id -- 配置编号
    ,bill_type_cd -- 票据类型代码
    ,bus_type_cd -- 业务类型代码
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
    ,ext_dr_subj_id -- 外部借方科目编号
    ,ext_cr_subj_id -- 外部贷方科目编号
    ,subj_name -- 科目名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    TO_CHAR(P1.ID) -- 配置编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DRAFT_TYPE END -- 票据类型代码
    ,NVL(TRIM(P1.BUSS_TYPE),'0') -- 业务类型代码
    ,P1.DBSUBJ -- 借方科目编号
    ,P1.CRSUBJ -- 贷方科目编号
    ,P1.OUTDBSUBJ -- 外部借方科目编号
    ,P1.OUTCRSUBJ -- 外部贷方科目编号
    ,P1.MISC -- 科目名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_tla_lnpreintr_subj' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_tla_lnpreintr_subj p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DRAFT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_TLA_LNPREINTR_SUBJ'
        AND R1.SRC_FIELD_EN_NAME= 'DRAFT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'REF_BILL_AMORT_SUBJ_CFG_PARA'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_cl(
            cfg_id -- 配置编号
    ,bill_type_cd -- 票据类型代码
    ,bus_type_cd -- 业务类型代码
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
    ,ext_dr_subj_id -- 外部借方科目编号
    ,ext_cr_subj_id -- 外部贷方科目编号
    ,subj_name -- 科目名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_op(
            cfg_id -- 配置编号
    ,bill_type_cd -- 票据类型代码
    ,bus_type_cd -- 业务类型代码
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
    ,ext_dr_subj_id -- 外部借方科目编号
    ,ext_cr_subj_id -- 外部贷方科目编号
    ,subj_name -- 科目名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cfg_id, o.cfg_id) as cfg_id -- 配置编号
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.dr_subj_id, o.dr_subj_id) as dr_subj_id -- 借方科目编号
    ,nvl(n.cr_subj_id, o.cr_subj_id) as cr_subj_id -- 贷方科目编号
    ,nvl(n.ext_dr_subj_id, o.ext_dr_subj_id) as ext_dr_subj_id -- 外部借方科目编号
    ,nvl(n.ext_cr_subj_id, o.ext_cr_subj_id) as ext_cr_subj_id -- 外部贷方科目编号
    ,nvl(n.subj_name, o.subj_name) as subj_name -- 科目名称
    ,case when
            n.cfg_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cfg_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cfg_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_tm n
    full join (select * from ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.cfg_id = n.cfg_id
where (
        o.cfg_id is null
    )
    or (
        n.cfg_id is null
    )
    or (
        o.bill_type_cd <> n.bill_type_cd
        or o.bus_type_cd <> n.bus_type_cd
        or o.dr_subj_id <> n.dr_subj_id
        or o.cr_subj_id <> n.cr_subj_id
        or o.ext_dr_subj_id <> n.ext_dr_subj_id
        or o.ext_cr_subj_id <> n.ext_cr_subj_id
        or o.subj_name <> n.subj_name
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_cl(
            cfg_id -- 配置编号
    ,bill_type_cd -- 票据类型代码
    ,bus_type_cd -- 业务类型代码
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
    ,ext_dr_subj_id -- 外部借方科目编号
    ,ext_cr_subj_id -- 外部贷方科目编号
    ,subj_name -- 科目名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_op(
            cfg_id -- 配置编号
    ,bill_type_cd -- 票据类型代码
    ,bus_type_cd -- 业务类型代码
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
    ,ext_dr_subj_id -- 外部借方科目编号
    ,ext_cr_subj_id -- 外部贷方科目编号
    ,subj_name -- 科目名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cfg_id -- 配置编号
    ,o.bill_type_cd -- 票据类型代码
    ,o.bus_type_cd -- 业务类型代码
    ,o.dr_subj_id -- 借方科目编号
    ,o.cr_subj_id -- 贷方科目编号
    ,o.ext_dr_subj_id -- 外部借方科目编号
    ,o.ext_cr_subj_id -- 外部贷方科目编号
    ,o.subj_name -- 科目名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_bk o
    left join ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_op n
        on
            o.cfg_id = n.cfg_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_cl d
        on
            o.cfg_id = d.cfg_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_bill_amort_subj_cfg_para;
alter table ${iml_schema}.ref_bill_amort_subj_cfg_para truncate partition for ('bdmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_bill_amort_subj_cfg_para exchange subpartition p_bdmsf1_19000101 with table ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_cl;
alter table ${iml_schema}.ref_bill_amort_subj_cfg_para exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_bill_amort_subj_cfg_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_tm purge;
drop table ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_op purge;
drop table ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_bill_amort_subj_cfg_para_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_bill_amort_subj_cfg_para', partname => 'p_bdmsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
