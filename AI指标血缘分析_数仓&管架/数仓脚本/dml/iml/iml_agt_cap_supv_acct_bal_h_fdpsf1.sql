/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cap_supv_acct_bal_h_fdpsf1
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
alter table ${iml_schema}.agt_cap_supv_acct_bal_h add partition p_fdpsf1 values ('fdpsf1')(
        subpartition p_fdpsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_fdpsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cap_supv_acct_bal_h partition for ('fdpsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_tm purge;
drop table ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_op purge;
drop table ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,vtual_acct_id -- 虚拟账户编号
    ,actl_bal -- 实际余额
    ,aval_bal -- 可用余额
    ,comm_fee_bal -- 手续费余额
    ,int -- 利息
    ,cust_tot_bal -- 客户总余额
    ,offs_bal -- 轧差余额
    ,mdl_stl_bal -- 中间结算余额
    ,ret_my_bal -- 返现余额
    ,guar_bal -- 担保余额
    ,ld_actl_bal -- 上日实际余额
    ,ld_aval_bal -- 上日可用余额
    ,ld_comm_fee_bal -- 上日手续费余额
    ,ld_int -- 上日利息
    ,ld_cust_tot_bal -- 上日客户总余额
    ,ld_offs_bal -- 上日轧差余额
    ,ld_mdl_stl_bal -- 上日中间结算余额
    ,ld_ret_my_bal -- 上日返现余额
    ,ld_guar_bal -- 上日担保余额
    ,acct_status_cd -- 账户状态代码
    ,open_tm -- 开户时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cap_supv_acct_bal_h partition for ('fdpsf1')
where 0=1
;

create table ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cap_supv_acct_bal_h partition for ('fdpsf1') where 0=1;

create table ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cap_supv_acct_bal_h partition for ('fdpsf1') where 0=1;

-- 3.1 get new data into table
-- fdps_fdp_account-1
insert into ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,vtual_acct_id -- 虚拟账户编号
    ,actl_bal -- 实际余额
    ,aval_bal -- 可用余额
    ,comm_fee_bal -- 手续费余额
    ,int -- 利息
    ,cust_tot_bal -- 客户总余额
    ,offs_bal -- 轧差余额
    ,mdl_stl_bal -- 中间结算余额
    ,ret_my_bal -- 返现余额
    ,guar_bal -- 担保余额
    ,ld_actl_bal -- 上日实际余额
    ,ld_aval_bal -- 上日可用余额
    ,ld_comm_fee_bal -- 上日手续费余额
    ,ld_int -- 上日利息
    ,ld_cust_tot_bal -- 上日客户总余额
    ,ld_offs_bal -- 上日轧差余额
    ,ld_mdl_stl_bal -- 上日中间结算余额
    ,ld_ret_my_bal -- 上日返现余额
    ,ld_guar_bal -- 上日担保余额
    ,acct_status_cd -- 账户状态代码
    ,open_tm -- 开户时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '100140'||P1.FDP_ACCOUNT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ACCOUNT_NO -- 虚拟账户编号
    ,P1.ACTUAL_BALANCE -- 实际余额
    ,P1.AVAILABLE_BALANCE -- 可用余额
    ,P1.FEE_BALANCE -- 手续费余额
    ,P1.INTEREST_BALANCE -- 利息
    ,P1.ALLOW_BALANCE -- 客户总余额
    ,P1.OFFSET_BALANCE -- 轧差余额
    ,P1.SETTLE_BALANCE -- 中间结算余额
    ,P1.CASH_BALANCE -- 返现余额
    ,P1.GUARANT_BALANCE -- 担保余额
    ,P1.YES_ACTUAL_BALANCE -- 上日实际余额
    ,P1.YES_AVAILABLE_BALANCE -- 上日可用余额
    ,P1.YES_FEE_BALANCE -- 上日手续费余额
    ,P1.YES_INTEREST_BALANCE -- 上日利息
    ,P1.YES_ALLOW_BALANCE -- 上日客户总余额
    ,P1.YES_OFFSET_BALANCE -- 上日轧差余额
    ,P1.YES_SETTLE_BALANCE -- 上日中间结算余额
    ,P1.YES_CASH_BALANCE -- 上日返现余额
    ,P1.YES_GUARANT_BALANCE -- 上日担保余额
    ,NVL(TRIM(P1.ACCOUNT_STATUS),'-') -- 账户状态代码
    ,P1.CREATED_STAMP -- 开户时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fdps_fdp_account' -- 源表名称
    ,'fdpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fdps_fdp_account p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,vtual_acct_id -- 虚拟账户编号
    ,actl_bal -- 实际余额
    ,aval_bal -- 可用余额
    ,comm_fee_bal -- 手续费余额
    ,int -- 利息
    ,cust_tot_bal -- 客户总余额
    ,offs_bal -- 轧差余额
    ,mdl_stl_bal -- 中间结算余额
    ,ret_my_bal -- 返现余额
    ,guar_bal -- 担保余额
    ,ld_actl_bal -- 上日实际余额
    ,ld_aval_bal -- 上日可用余额
    ,ld_comm_fee_bal -- 上日手续费余额
    ,ld_int -- 上日利息
    ,ld_cust_tot_bal -- 上日客户总余额
    ,ld_offs_bal -- 上日轧差余额
    ,ld_mdl_stl_bal -- 上日中间结算余额
    ,ld_ret_my_bal -- 上日返现余额
    ,ld_guar_bal -- 上日担保余额
    ,acct_status_cd -- 账户状态代码
    ,open_tm -- 开户时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,vtual_acct_id -- 虚拟账户编号
    ,actl_bal -- 实际余额
    ,aval_bal -- 可用余额
    ,comm_fee_bal -- 手续费余额
    ,int -- 利息
    ,cust_tot_bal -- 客户总余额
    ,offs_bal -- 轧差余额
    ,mdl_stl_bal -- 中间结算余额
    ,ret_my_bal -- 返现余额
    ,guar_bal -- 担保余额
    ,ld_actl_bal -- 上日实际余额
    ,ld_aval_bal -- 上日可用余额
    ,ld_comm_fee_bal -- 上日手续费余额
    ,ld_int -- 上日利息
    ,ld_cust_tot_bal -- 上日客户总余额
    ,ld_offs_bal -- 上日轧差余额
    ,ld_mdl_stl_bal -- 上日中间结算余额
    ,ld_ret_my_bal -- 上日返现余额
    ,ld_guar_bal -- 上日担保余额
    ,acct_status_cd -- 账户状态代码
    ,open_tm -- 开户时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.vtual_acct_id, o.vtual_acct_id) as vtual_acct_id -- 虚拟账户编号
    ,nvl(n.actl_bal, o.actl_bal) as actl_bal -- 实际余额
    ,nvl(n.aval_bal, o.aval_bal) as aval_bal -- 可用余额
    ,nvl(n.comm_fee_bal, o.comm_fee_bal) as comm_fee_bal -- 手续费余额
    ,nvl(n.int, o.int) as int -- 利息
    ,nvl(n.cust_tot_bal, o.cust_tot_bal) as cust_tot_bal -- 客户总余额
    ,nvl(n.offs_bal, o.offs_bal) as offs_bal -- 轧差余额
    ,nvl(n.mdl_stl_bal, o.mdl_stl_bal) as mdl_stl_bal -- 中间结算余额
    ,nvl(n.ret_my_bal, o.ret_my_bal) as ret_my_bal -- 返现余额
    ,nvl(n.guar_bal, o.guar_bal) as guar_bal -- 担保余额
    ,nvl(n.ld_actl_bal, o.ld_actl_bal) as ld_actl_bal -- 上日实际余额
    ,nvl(n.ld_aval_bal, o.ld_aval_bal) as ld_aval_bal -- 上日可用余额
    ,nvl(n.ld_comm_fee_bal, o.ld_comm_fee_bal) as ld_comm_fee_bal -- 上日手续费余额
    ,nvl(n.ld_int, o.ld_int) as ld_int -- 上日利息
    ,nvl(n.ld_cust_tot_bal, o.ld_cust_tot_bal) as ld_cust_tot_bal -- 上日客户总余额
    ,nvl(n.ld_offs_bal, o.ld_offs_bal) as ld_offs_bal -- 上日轧差余额
    ,nvl(n.ld_mdl_stl_bal, o.ld_mdl_stl_bal) as ld_mdl_stl_bal -- 上日中间结算余额
    ,nvl(n.ld_ret_my_bal, o.ld_ret_my_bal) as ld_ret_my_bal -- 上日返现余额
    ,nvl(n.ld_guar_bal, o.ld_guar_bal) as ld_guar_bal -- 上日担保余额
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.open_tm, o.open_tm) as open_tm -- 开户时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_tm n
    full join (select * from ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.vtual_acct_id <> n.vtual_acct_id
        or o.actl_bal <> n.actl_bal
        or o.aval_bal <> n.aval_bal
        or o.comm_fee_bal <> n.comm_fee_bal
        or o.int <> n.int
        or o.cust_tot_bal <> n.cust_tot_bal
        or o.offs_bal <> n.offs_bal
        or o.mdl_stl_bal <> n.mdl_stl_bal
        or o.ret_my_bal <> n.ret_my_bal
        or o.guar_bal <> n.guar_bal
        or o.ld_actl_bal <> n.ld_actl_bal
        or o.ld_aval_bal <> n.ld_aval_bal
        or o.ld_comm_fee_bal <> n.ld_comm_fee_bal
        or o.ld_int <> n.ld_int
        or o.ld_cust_tot_bal <> n.ld_cust_tot_bal
        or o.ld_offs_bal <> n.ld_offs_bal
        or o.ld_mdl_stl_bal <> n.ld_mdl_stl_bal
        or o.ld_ret_my_bal <> n.ld_ret_my_bal
        or o.ld_guar_bal <> n.ld_guar_bal
        or o.acct_status_cd <> n.acct_status_cd
        or o.open_tm <> n.open_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,vtual_acct_id -- 虚拟账户编号
    ,actl_bal -- 实际余额
    ,aval_bal -- 可用余额
    ,comm_fee_bal -- 手续费余额
    ,int -- 利息
    ,cust_tot_bal -- 客户总余额
    ,offs_bal -- 轧差余额
    ,mdl_stl_bal -- 中间结算余额
    ,ret_my_bal -- 返现余额
    ,guar_bal -- 担保余额
    ,ld_actl_bal -- 上日实际余额
    ,ld_aval_bal -- 上日可用余额
    ,ld_comm_fee_bal -- 上日手续费余额
    ,ld_int -- 上日利息
    ,ld_cust_tot_bal -- 上日客户总余额
    ,ld_offs_bal -- 上日轧差余额
    ,ld_mdl_stl_bal -- 上日中间结算余额
    ,ld_ret_my_bal -- 上日返现余额
    ,ld_guar_bal -- 上日担保余额
    ,acct_status_cd -- 账户状态代码
    ,open_tm -- 开户时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,vtual_acct_id -- 虚拟账户编号
    ,actl_bal -- 实际余额
    ,aval_bal -- 可用余额
    ,comm_fee_bal -- 手续费余额
    ,int -- 利息
    ,cust_tot_bal -- 客户总余额
    ,offs_bal -- 轧差余额
    ,mdl_stl_bal -- 中间结算余额
    ,ret_my_bal -- 返现余额
    ,guar_bal -- 担保余额
    ,ld_actl_bal -- 上日实际余额
    ,ld_aval_bal -- 上日可用余额
    ,ld_comm_fee_bal -- 上日手续费余额
    ,ld_int -- 上日利息
    ,ld_cust_tot_bal -- 上日客户总余额
    ,ld_offs_bal -- 上日轧差余额
    ,ld_mdl_stl_bal -- 上日中间结算余额
    ,ld_ret_my_bal -- 上日返现余额
    ,ld_guar_bal -- 上日担保余额
    ,acct_status_cd -- 账户状态代码
    ,open_tm -- 开户时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.vtual_acct_id -- 虚拟账户编号
    ,o.actl_bal -- 实际余额
    ,o.aval_bal -- 可用余额
    ,o.comm_fee_bal -- 手续费余额
    ,o.int -- 利息
    ,o.cust_tot_bal -- 客户总余额
    ,o.offs_bal -- 轧差余额
    ,o.mdl_stl_bal -- 中间结算余额
    ,o.ret_my_bal -- 返现余额
    ,o.guar_bal -- 担保余额
    ,o.ld_actl_bal -- 上日实际余额
    ,o.ld_aval_bal -- 上日可用余额
    ,o.ld_comm_fee_bal -- 上日手续费余额
    ,o.ld_int -- 上日利息
    ,o.ld_cust_tot_bal -- 上日客户总余额
    ,o.ld_offs_bal -- 上日轧差余额
    ,o.ld_mdl_stl_bal -- 上日中间结算余额
    ,o.ld_ret_my_bal -- 上日返现余额
    ,o.ld_guar_bal -- 上日担保余额
    ,o.acct_status_cd -- 账户状态代码
    ,o.open_tm -- 开户时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_bk o
    left join ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_cap_supv_acct_bal_h;
alter table ${iml_schema}.agt_cap_supv_acct_bal_h truncate partition for ('fdpsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_cap_supv_acct_bal_h exchange subpartition p_fdpsf1_19000101 with table ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_cl;
alter table ${iml_schema}.agt_cap_supv_acct_bal_h exchange subpartition p_fdpsf1_20991231 with table ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cap_supv_acct_bal_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_tm purge;
drop table ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_op purge;
drop table ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cap_supv_acct_bal_h_fdpsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cap_supv_acct_bal_h', partname => 'p_fdpsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
