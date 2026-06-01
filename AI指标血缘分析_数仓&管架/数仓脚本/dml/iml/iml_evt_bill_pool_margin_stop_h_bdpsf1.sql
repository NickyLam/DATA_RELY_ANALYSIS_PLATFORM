/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bill_pool_margin_stop_h_bdpsf1
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
alter table ${iml_schema}.evt_bill_pool_margin_stop_h add partition p_bdpsf1 values ('bdpsf1')(
        subpartition p_bdpsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_bdpsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_pool_margin_stop_h partition for ('bdpsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_tm purge;
drop table ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_op purge;
drop table ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,stop_pay_dtl_id -- 止付明细编号
    ,acct_id -- 账户编号
    ,sub_acct_id -- 子户编号
    ,stop_pay_status_cd -- 止付状态代码
    ,pymc_status_cd -- 备款状态代码
    ,stop_pay_amt -- 止付金额
    ,stop_pay_flow_num -- 止付流水号
    ,solu_pay_flow_num -- 解付流水号
    ,stop_pay_dt -- 止付日期
    ,solu_pay_dt -- 解付日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_pool_margin_stop_h partition for ('bdpsf1')
where 0=1
;

create table ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_pool_margin_stop_h partition for ('bdpsf1') where 0=1;

create table ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_pool_margin_stop_h partition for ('bdpsf1') where 0=1;

-- 3.1 get new data into table
-- bdps_bail_coneal_details-
insert into ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,stop_pay_dtl_id -- 止付明细编号
    ,acct_id -- 账户编号
    ,sub_acct_id -- 子户编号
    ,stop_pay_status_cd -- 止付状态代码
    ,pymc_status_cd -- 备款状态代码
    ,stop_pay_amt -- 止付金额
    ,stop_pay_flow_num -- 止付流水号
    ,solu_pay_flow_num -- 解付流水号
    ,stop_pay_dt -- 止付日期
    ,solu_pay_dt -- 解付日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104028'||TO_CHAR(P1.ID) -- 事件编号
    ,'9999' -- 法人编号
    ,to_char(P1.ID) -- 止付明细编号
    ,P2.BAIL_ACCOUNT -- 账户编号
    ,P2.BAIL_SUB_NO -- 子户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BAIL_CONEAL_STATUS END -- 止付状态代码
    ,nvl(trim(P1.PAR_STATUS),'-') -- 备款状态代码
    ,P1.BAIL_CONEAL_AMOUNT -- 止付金额
    ,P1.CONEAL_NBR -- 止付流水号
    ,P1.UNFREEZE_NBR -- 解付流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.CONEAL_DT) -- 止付日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.UNFREEZE_DT) -- 解付日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdps_bail_coneal_details' -- 源表名称
    ,'bdpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdps_bail_coneal_details p1
    left join ${iol_schema}.bdps_bail_account p2 on p1.BAIL_ACCOUNT_ID=p2.ID
AND p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BAIL_CONEAL_STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDPS'
        AND R1.SRC_TAB_EN_NAME= 'BDPS_BAIL_CONEAL_DETAILS'
        AND R1.SRC_FIELD_EN_NAME= 'BAIL_CONEAL_STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_BILL_POOL_MARGIN_STOP_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'STOP_PAY_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,stop_pay_dtl_id -- 止付明细编号
    ,acct_id -- 账户编号
    ,sub_acct_id -- 子户编号
    ,stop_pay_status_cd -- 止付状态代码
    ,pymc_status_cd -- 备款状态代码
    ,stop_pay_amt -- 止付金额
    ,stop_pay_flow_num -- 止付流水号
    ,solu_pay_flow_num -- 解付流水号
    ,stop_pay_dt -- 止付日期
    ,solu_pay_dt -- 解付日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,stop_pay_dtl_id -- 止付明细编号
    ,acct_id -- 账户编号
    ,sub_acct_id -- 子户编号
    ,stop_pay_status_cd -- 止付状态代码
    ,pymc_status_cd -- 备款状态代码
    ,stop_pay_amt -- 止付金额
    ,stop_pay_flow_num -- 止付流水号
    ,solu_pay_flow_num -- 解付流水号
    ,stop_pay_dt -- 止付日期
    ,solu_pay_dt -- 解付日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.stop_pay_dtl_id, o.stop_pay_dtl_id) as stop_pay_dtl_id -- 止付明细编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.sub_acct_id, o.sub_acct_id) as sub_acct_id -- 子户编号
    ,nvl(n.stop_pay_status_cd, o.stop_pay_status_cd) as stop_pay_status_cd -- 止付状态代码
    ,nvl(n.pymc_status_cd, o.pymc_status_cd) as pymc_status_cd -- 备款状态代码
    ,nvl(n.stop_pay_amt, o.stop_pay_amt) as stop_pay_amt -- 止付金额
    ,nvl(n.stop_pay_flow_num, o.stop_pay_flow_num) as stop_pay_flow_num -- 止付流水号
    ,nvl(n.solu_pay_flow_num, o.solu_pay_flow_num) as solu_pay_flow_num -- 解付流水号
    ,nvl(n.stop_pay_dt, o.stop_pay_dt) as stop_pay_dt -- 止付日期
    ,nvl(n.solu_pay_dt, o.solu_pay_dt) as solu_pay_dt -- 解付日期
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_tm n
    full join (select * from ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.stop_pay_dtl_id <> n.stop_pay_dtl_id
        or o.acct_id <> n.acct_id
        or o.sub_acct_id <> n.sub_acct_id
        or o.stop_pay_status_cd <> n.stop_pay_status_cd
        or o.pymc_status_cd <> n.pymc_status_cd
        or o.stop_pay_amt <> n.stop_pay_amt
        or o.stop_pay_flow_num <> n.stop_pay_flow_num
        or o.solu_pay_flow_num <> n.solu_pay_flow_num
        or o.stop_pay_dt <> n.stop_pay_dt
        or o.solu_pay_dt <> n.solu_pay_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,stop_pay_dtl_id -- 止付明细编号
    ,acct_id -- 账户编号
    ,sub_acct_id -- 子户编号
    ,stop_pay_status_cd -- 止付状态代码
    ,pymc_status_cd -- 备款状态代码
    ,stop_pay_amt -- 止付金额
    ,stop_pay_flow_num -- 止付流水号
    ,solu_pay_flow_num -- 解付流水号
    ,stop_pay_dt -- 止付日期
    ,solu_pay_dt -- 解付日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,stop_pay_dtl_id -- 止付明细编号
    ,acct_id -- 账户编号
    ,sub_acct_id -- 子户编号
    ,stop_pay_status_cd -- 止付状态代码
    ,pymc_status_cd -- 备款状态代码
    ,stop_pay_amt -- 止付金额
    ,stop_pay_flow_num -- 止付流水号
    ,solu_pay_flow_num -- 解付流水号
    ,stop_pay_dt -- 止付日期
    ,solu_pay_dt -- 解付日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.stop_pay_dtl_id -- 止付明细编号
    ,o.acct_id -- 账户编号
    ,o.sub_acct_id -- 子户编号
    ,o.stop_pay_status_cd -- 止付状态代码
    ,o.pymc_status_cd -- 备款状态代码
    ,o.stop_pay_amt -- 止付金额
    ,o.stop_pay_flow_num -- 止付流水号
    ,o.solu_pay_flow_num -- 解付流水号
    ,o.stop_pay_dt -- 止付日期
    ,o.solu_pay_dt -- 解付日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_bk o
    left join ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_bill_pool_margin_stop_h;
alter table ${iml_schema}.evt_bill_pool_margin_stop_h truncate partition for ('bdpsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.evt_bill_pool_margin_stop_h exchange subpartition p_bdpsf1_19000101 with table ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_cl;
alter table ${iml_schema}.evt_bill_pool_margin_stop_h exchange subpartition p_bdpsf1_20991231 with table ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bill_pool_margin_stop_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_tm purge;
drop table ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_op purge;
drop table ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_bill_pool_margin_stop_h_bdpsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bill_pool_margin_stop_h', partname => 'p_bdpsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
