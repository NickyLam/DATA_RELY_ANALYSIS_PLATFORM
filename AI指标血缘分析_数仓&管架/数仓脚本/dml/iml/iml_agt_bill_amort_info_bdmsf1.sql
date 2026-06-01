/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_amort_info_bdmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_bill_amort_info_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_amort_info_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bill_amort_info add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bill_amort_info modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_amort_info_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_amort_info partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_amort_info_bdmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,amort_id -- 摊销编号
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
from ${iml_schema}.agt_bill_amort_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bill_amort_info_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bill_amort_info partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_tla_lnpreintr-
insert into ${iml_schema}.agt_bill_amort_info_bdmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,amort_id -- 摊销编号
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
    '223105'||TO_CHAR(P1.ID) -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.ID) -- 摊销编号
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
        AND R1.TARGET_TAB_EN_NAME= 'AGT_BILL_AMORT_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PROVI_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_bill_amort_info_bdmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,amort_id -- 摊销编号
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
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.amort_id, o.amort_id) as amort_id -- 摊销编号
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
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.amort_id <> n.amort_id
                or o.bill_id <> n.bill_id
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
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_amort_info_bdmsf1_tm n
    full join ${iml_schema}.agt_bill_amort_info_bdmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bill_amort_info truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bill_amort_info exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_bill_amort_info_bdmsf1_ex;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_amort_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bill_amort_info_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_amort_info_bdmsf1_ex purge;
drop table ${iml_schema}.agt_bill_amort_info_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_amort_info', partname => 'p_bdmsf1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);