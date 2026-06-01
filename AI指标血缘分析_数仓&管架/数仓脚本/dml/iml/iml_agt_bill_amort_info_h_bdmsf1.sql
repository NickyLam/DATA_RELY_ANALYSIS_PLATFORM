/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_amort_info_h_bdmsf1
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
alter table ${iml_schema}.agt_bill_amort_info_h add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_amort_info_h_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_amort_info_h partition for ('bdmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_bill_amort_info_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_amort_info_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_bill_amort_info_h_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_amort_info_h_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    amort_id -- 摊销编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,flow_tab_curr_seq_num -- 流水表当前序号
    ,provi_type_cd -- 计提类型代码
    ,provi_ped_cd -- 计提周期代码
    ,plan_pd -- 计划期次
    ,provi_dt -- 计提日期
    ,last_provi_dt -- 上次计提日期
    ,next_provi_dt -- 下次计提日期
    ,carr_dt -- 结转日期
    ,provi_org_id -- 计提机构编号
    ,provi_int_tot -- 计提利息总额
    ,day_amort_lmt -- 日摊销额
    ,provi_int_bal -- 计提利息余额
    ,bus_type_cd -- 业务类型代码
    ,status_cd -- 状态代码
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_amort_info_h partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_bill_amort_info_h_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_amort_info_h partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_bill_amort_info_h_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_amort_info_h partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_tla_lnpreintr-
insert into ${iml_schema}.agt_bill_amort_info_h_bdmsf1_tm(
    amort_id -- 摊销编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,flow_tab_curr_seq_num -- 流水表当前序号
    ,provi_type_cd -- 计提类型代码
    ,provi_ped_cd -- 计提周期代码
    ,plan_pd -- 计划期次
    ,provi_dt -- 计提日期
    ,last_provi_dt -- 上次计提日期
    ,next_provi_dt -- 下次计提日期
    ,carr_dt -- 结转日期
    ,provi_org_id -- 计提机构编号
    ,provi_int_tot -- 计提利息总额
    ,day_amort_lmt -- 日摊销额
    ,provi_int_bal -- 计提利息余额
    ,bus_type_cd -- 业务类型代码
    ,status_cd -- 状态代码
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    TO_CHAR(P1.ID) -- 摊销编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.DRAFTID) -- 票据编号
    ,P1.LNPRVSEQ -- 流水表当前序号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.LNPRVTYPE END -- 计提类型代码
    ,P1.LNPRVUNIT -- 计提周期代码
    ,P1.PLANPERI -- 计划期次
    ,P1.PRVDT -- 计提日期
    ,P1.LSTDT -- 上次计提日期
    ,P1.NXTDT -- 下次计提日期
    ,P1.OVERDT -- 结转日期
    ,P1.BRCD -- 计提机构编号
    ,P1.PRVINTAMT -- 计提利息总额
    ,P1.PRVDAYAMT -- 日摊销额
    ,P1.PRVINTBAL -- 计提利息余额
    ,NVL(TRIM(P1.BUSSTYPE),'0') -- 业务类型代码
    ,P1.STATUS -- 状态代码
    ,P1.DBSUBJ -- 借方科目编号
    ,P1.CRSUBJ -- 贷方科目编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_tla_lnpreintr' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_tla_lnpreintr p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.LNPRVTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_TLA_LNPREINTR'
        AND R1.SRC_FIELD_EN_NAME= 'LNPRVTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_BILL_AMORT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PROVI_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_bill_amort_info_h_bdmsf1_cl(
            amort_id -- 摊销编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,flow_tab_curr_seq_num -- 流水表当前序号
    ,provi_type_cd -- 计提类型代码
    ,provi_ped_cd -- 计提周期代码
    ,plan_pd -- 计划期次
    ,provi_dt -- 计提日期
    ,last_provi_dt -- 上次计提日期
    ,next_provi_dt -- 下次计提日期
    ,carr_dt -- 结转日期
    ,provi_org_id -- 计提机构编号
    ,provi_int_tot -- 计提利息总额
    ,day_amort_lmt -- 日摊销额
    ,provi_int_bal -- 计提利息余额
    ,bus_type_cd -- 业务类型代码
    ,status_cd -- 状态代码
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bill_amort_info_h_bdmsf1_op(
            amort_id -- 摊销编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,flow_tab_curr_seq_num -- 流水表当前序号
    ,provi_type_cd -- 计提类型代码
    ,provi_ped_cd -- 计提周期代码
    ,plan_pd -- 计划期次
    ,provi_dt -- 计提日期
    ,last_provi_dt -- 上次计提日期
    ,next_provi_dt -- 下次计提日期
    ,carr_dt -- 结转日期
    ,provi_org_id -- 计提机构编号
    ,provi_int_tot -- 计提利息总额
    ,day_amort_lmt -- 日摊销额
    ,provi_int_bal -- 计提利息余额
    ,bus_type_cd -- 业务类型代码
    ,status_cd -- 状态代码
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amort_id, o.amort_id) as amort_id -- 摊销编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.flow_tab_curr_seq_num, o.flow_tab_curr_seq_num) as flow_tab_curr_seq_num -- 流水表当前序号
    ,nvl(n.provi_type_cd, o.provi_type_cd) as provi_type_cd -- 计提类型代码
    ,nvl(n.provi_ped_cd, o.provi_ped_cd) as provi_ped_cd -- 计提周期代码
    ,nvl(n.plan_pd, o.plan_pd) as plan_pd -- 计划期次
    ,nvl(n.provi_dt, o.provi_dt) as provi_dt -- 计提日期
    ,nvl(n.last_provi_dt, o.last_provi_dt) as last_provi_dt -- 上次计提日期
    ,nvl(n.next_provi_dt, o.next_provi_dt) as next_provi_dt -- 下次计提日期
    ,nvl(n.carr_dt, o.carr_dt) as carr_dt -- 结转日期
    ,nvl(n.provi_org_id, o.provi_org_id) as provi_org_id -- 计提机构编号
    ,nvl(n.provi_int_tot, o.provi_int_tot) as provi_int_tot -- 计提利息总额
    ,nvl(n.day_amort_lmt, o.day_amort_lmt) as day_amort_lmt -- 日摊销额
    ,nvl(n.provi_int_bal, o.provi_int_bal) as provi_int_bal -- 计提利息余额
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.dr_subj_id, o.dr_subj_id) as dr_subj_id -- 借方科目编号
    ,nvl(n.cr_subj_id, o.cr_subj_id) as cr_subj_id -- 贷方科目编号
    ,case when
            n.amort_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.amort_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.amort_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_amort_info_h_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_bill_amort_info_h_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.amort_id = n.amort_id
            and o.lp_id = n.lp_id
where (
        o.amort_id is null
        and o.lp_id is null
    )
    or (
        n.amort_id is null
        and n.lp_id is null
    )
    or (
        o.bill_id <> n.bill_id
        or o.flow_tab_curr_seq_num <> n.flow_tab_curr_seq_num
        or o.provi_type_cd <> n.provi_type_cd
        or o.provi_ped_cd <> n.provi_ped_cd
        or o.plan_pd <> n.plan_pd
        or o.provi_dt <> n.provi_dt
        or o.last_provi_dt <> n.last_provi_dt
        or o.next_provi_dt <> n.next_provi_dt
        or o.carr_dt <> n.carr_dt
        or o.provi_org_id <> n.provi_org_id
        or o.provi_int_tot <> n.provi_int_tot
        or o.day_amort_lmt <> n.day_amort_lmt
        or o.provi_int_bal <> n.provi_int_bal
        or o.bus_type_cd <> n.bus_type_cd
        or o.status_cd <> n.status_cd
        or o.dr_subj_id <> n.dr_subj_id
        or o.cr_subj_id <> n.cr_subj_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_bill_amort_info_h_bdmsf1_cl(
            amort_id -- 摊销编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,flow_tab_curr_seq_num -- 流水表当前序号
    ,provi_type_cd -- 计提类型代码
    ,provi_ped_cd -- 计提周期代码
    ,plan_pd -- 计划期次
    ,provi_dt -- 计提日期
    ,last_provi_dt -- 上次计提日期
    ,next_provi_dt -- 下次计提日期
    ,carr_dt -- 结转日期
    ,provi_org_id -- 计提机构编号
    ,provi_int_tot -- 计提利息总额
    ,day_amort_lmt -- 日摊销额
    ,provi_int_bal -- 计提利息余额
    ,bus_type_cd -- 业务类型代码
    ,status_cd -- 状态代码
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bill_amort_info_h_bdmsf1_op(
            amort_id -- 摊销编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,flow_tab_curr_seq_num -- 流水表当前序号
    ,provi_type_cd -- 计提类型代码
    ,provi_ped_cd -- 计提周期代码
    ,plan_pd -- 计划期次
    ,provi_dt -- 计提日期
    ,last_provi_dt -- 上次计提日期
    ,next_provi_dt -- 下次计提日期
    ,carr_dt -- 结转日期
    ,provi_org_id -- 计提机构编号
    ,provi_int_tot -- 计提利息总额
    ,day_amort_lmt -- 日摊销额
    ,provi_int_bal -- 计提利息余额
    ,bus_type_cd -- 业务类型代码
    ,status_cd -- 状态代码
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amort_id -- 摊销编号
    ,o.lp_id -- 法人编号
    ,o.bill_id -- 票据编号
    ,o.flow_tab_curr_seq_num -- 流水表当前序号
    ,o.provi_type_cd -- 计提类型代码
    ,o.provi_ped_cd -- 计提周期代码
    ,o.plan_pd -- 计划期次
    ,o.provi_dt -- 计提日期
    ,o.last_provi_dt -- 上次计提日期
    ,o.next_provi_dt -- 下次计提日期
    ,o.carr_dt -- 结转日期
    ,o.provi_org_id -- 计提机构编号
    ,o.provi_int_tot -- 计提利息总额
    ,o.day_amort_lmt -- 日摊销额
    ,o.provi_int_bal -- 计提利息余额
    ,o.bus_type_cd -- 业务类型代码
    ,o.status_cd -- 状态代码
    ,o.dr_subj_id -- 借方科目编号
    ,o.cr_subj_id -- 贷方科目编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_amort_info_h_bdmsf1_bk o
    left join ${iml_schema}.agt_bill_amort_info_h_bdmsf1_op n
        on
            o.amort_id = n.amort_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_bill_amort_info_h_bdmsf1_cl d
        on
            o.amort_id = d.amort_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_bill_amort_info_h;
alter table ${iml_schema}.agt_bill_amort_info_h truncate partition for ('bdmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_bill_amort_info_h exchange subpartition p_bdmsf1_19000101 with table ${iml_schema}.agt_bill_amort_info_h_bdmsf1_cl;
alter table ${iml_schema}.agt_bill_amort_info_h exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_bill_amort_info_h_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_amort_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_bill_amort_info_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_amort_info_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_bill_amort_info_h_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_bill_amort_info_h_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_amort_info_h', partname => 'p_bdmsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
