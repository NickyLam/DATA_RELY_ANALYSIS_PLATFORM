/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ajb_crdt_appl_myjbi2
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
drop table ${iml_schema}.agt_ajb_crdt_appl_myjbi2_tm purge;
alter table ${iml_schema}.agt_ajb_crdt_appl add partition p_myjbi2 values ('myjbi2')(
        subpartition p_myjbi2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ajb_crdt_appl modify partition p_myjbi2
    add subpartition p_myjbi2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ajb_crdt_appl_myjbi2_tm
compress ${option_switch} for query high
as
select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,appl_dt -- 申请日期
    ,apv_status_cd -- 审批状态代码
    ,crdt_lmt -- 授信额度
    ,risk_rating -- 风险评级
    ,solv_rating -- 偿债能力评级
    ,cust_id -- 客户编号
    ,apved_dt -- 审批通过日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ajb_crdt_appl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- rcrs_myjb_iqp_loan_app-
insert into ${iml_schema}.agt_ajb_crdt_appl_myjbi2_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,appl_dt -- 申请日期
    ,apv_status_cd -- 审批状态代码
    ,crdt_lmt -- 授信额度
    ,risk_rating -- 风险评级
    ,solv_rating -- 偿债能力评级
    ,cust_id -- 客户编号
    ,apved_dt -- 审批通过日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '203002'||P1.SERNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERNO -- 授信申请编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLY_DATE) -- 申请日期
    ,P1.APPROVE_STATUS -- 审批状态代码
    ,P1.APPLY_AMOUNT -- 授信额度
    ,P1.RISK_RATING -- 风险评级
    ,P1.SOLVENCY_RATINGS -- 偿债能力评级
    ,P1.CUS_ID -- 客户编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.LAST_ADVICE_DATE) -- 审批通过日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_myjb_iqp_loan_app' -- 源表名称
    ,'myjbi2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_myjb_iqp_loan_app p1
where  1 = 1 
    and P1.etl_dt=to_date('${batch_date}','yyyy-mm-dd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.agt_ajb_crdt_appl truncate subpartition p_myjbi2_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_ajb_crdt_appl exchange subpartition p_myjbi2_${batch_date} with table ${iml_schema}.agt_ajb_crdt_appl_myjbi2_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ajb_crdt_appl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_ajb_crdt_appl_myjbi2_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ajb_crdt_appl', partname => 'p_myjbi2_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);