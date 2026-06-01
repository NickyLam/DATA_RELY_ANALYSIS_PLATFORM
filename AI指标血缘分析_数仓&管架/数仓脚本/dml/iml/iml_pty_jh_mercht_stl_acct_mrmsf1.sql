/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_jh_mercht_stl_acct_mrmsf1
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
alter table ${iml_schema}.pty_jh_mercht_stl_acct add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mrmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_jh_mercht_stl_acct partition for ('mrmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_tm purge;
drop table ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_op purge;
drop table ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_tm nologging
compress ${option_switch} for query high
as select
    mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,agency_id -- 代理商编号
    ,clear_way_cd -- 清算方式代码
    ,clear_ped_cd -- 清算周期代码
    ,open_bank_no -- 开户行行号
    ,open_bank_name -- 开户行名称
    ,acct_name -- 账户名称
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,open_acct_acct_addr -- 开户账户地址
    ,t1_fee_rat -- T1费率
    ,d0_fee_rat -- D0费率
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_jh_mercht_stl_acct partition for ('mrmsf1')
where 0=1
;

create table ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_jh_mercht_stl_acct partition for ('mrmsf1') where 0=1;

create table ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_jh_mercht_stl_acct partition for ('mrmsf1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_jh_mcht_settle_inf-
insert into ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_tm(
    mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,agency_id -- 代理商编号
    ,clear_way_cd -- 清算方式代码
    ,clear_ped_cd -- 清算周期代码
    ,open_bank_no -- 开户行行号
    ,open_bank_name -- 开户行名称
    ,acct_name -- 账户名称
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,open_acct_acct_addr -- 开户账户地址
    ,t1_fee_rat -- T1费率
    ,d0_fee_rat -- D0费率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.MCHT_NO -- 商户编号
    ,'9999' -- 法人编号
    ,P1.AGENT_CD -- 代理商编号
    ,NVL(TRIM(P1.SETTLE_MODE),'-') -- 清算方式代码
    ,NVL(TRIM(P1.SETTLE_TYPE),'9') -- 清算周期代码
    ,P1.SETTLE_BANK_NO -- 开户行行号
    ,P1.SETTLE_BANK_NM -- 开户行名称
    ,P1.SETTLE_ACCT_NM -- 账户名称
    ,P1.SETTLE_ACCT -- 账户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.ACCT_TYPE END -- 账户类型代码
    ,P1.OPEN_ACCT_ADDR -- 开户账户地址
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.T0_ALGO_ID, '[0-9.]+')),0)) -- T1费率
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.T1_ALGO_ID, '[0-9.]+')),0)) -- D0费率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_jh_mcht_settle_inf' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_jh_mcht_settle_inf p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ACCT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_JH_MCHT_SETTLE_INF'
        AND R1.SRC_FIELD_EN_NAME= 'ACCT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_JH_MERCHT_STL_ACCT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ACCT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_cl(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,agency_id -- 代理商编号
    ,clear_way_cd -- 清算方式代码
    ,clear_ped_cd -- 清算周期代码
    ,open_bank_no -- 开户行行号
    ,open_bank_name -- 开户行名称
    ,acct_name -- 账户名称
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,open_acct_acct_addr -- 开户账户地址
    ,t1_fee_rat -- T1费率
    ,d0_fee_rat -- D0费率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_op(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,agency_id -- 代理商编号
    ,clear_way_cd -- 清算方式代码
    ,clear_ped_cd -- 清算周期代码
    ,open_bank_no -- 开户行行号
    ,open_bank_name -- 开户行名称
    ,acct_name -- 账户名称
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,open_acct_acct_addr -- 开户账户地址
    ,t1_fee_rat -- T1费率
    ,d0_fee_rat -- D0费率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.agency_id, o.agency_id) as agency_id -- 代理商编号
    ,nvl(n.clear_way_cd, o.clear_way_cd) as clear_way_cd -- 清算方式代码
    ,nvl(n.clear_ped_cd, o.clear_ped_cd) as clear_ped_cd -- 清算周期代码
    ,nvl(n.open_bank_no, o.open_bank_no) as open_bank_no -- 开户行行号
    ,nvl(n.open_bank_name, o.open_bank_name) as open_bank_name -- 开户行名称
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.open_acct_acct_addr, o.open_acct_acct_addr) as open_acct_acct_addr -- 开户账户地址
    ,nvl(n.t1_fee_rat, o.t1_fee_rat) as t1_fee_rat -- T1费率
    ,nvl(n.d0_fee_rat, o.d0_fee_rat) as d0_fee_rat -- D0费率
    ,case when
            n.mercht_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mercht_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mercht_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_tm n
    full join (select * from ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.mercht_id = n.mercht_id
            and o.lp_id = n.lp_id
where (
        o.mercht_id is null
        and o.lp_id is null
    )
    or (
        n.mercht_id is null
        and n.lp_id is null
    )
    or (
        o.agency_id <> n.agency_id
        or o.clear_way_cd <> n.clear_way_cd
        or o.clear_ped_cd <> n.clear_ped_cd
        or o.open_bank_no <> n.open_bank_no
        or o.open_bank_name <> n.open_bank_name
        or o.acct_name <> n.acct_name
        or o.acct_id <> n.acct_id
        or o.acct_type_cd <> n.acct_type_cd
        or o.open_acct_acct_addr <> n.open_acct_acct_addr
        or o.t1_fee_rat <> n.t1_fee_rat
        or o.d0_fee_rat <> n.d0_fee_rat
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_cl(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,agency_id -- 代理商编号
    ,clear_way_cd -- 清算方式代码
    ,clear_ped_cd -- 清算周期代码
    ,open_bank_no -- 开户行行号
    ,open_bank_name -- 开户行名称
    ,acct_name -- 账户名称
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,open_acct_acct_addr -- 开户账户地址
    ,t1_fee_rat -- T1费率
    ,d0_fee_rat -- D0费率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_op(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,agency_id -- 代理商编号
    ,clear_way_cd -- 清算方式代码
    ,clear_ped_cd -- 清算周期代码
    ,open_bank_no -- 开户行行号
    ,open_bank_name -- 开户行名称
    ,acct_name -- 账户名称
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,open_acct_acct_addr -- 开户账户地址
    ,t1_fee_rat -- T1费率
    ,d0_fee_rat -- D0费率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mercht_id -- 商户编号
    ,o.lp_id -- 法人编号
    ,o.agency_id -- 代理商编号
    ,o.clear_way_cd -- 清算方式代码
    ,o.clear_ped_cd -- 清算周期代码
    ,o.open_bank_no -- 开户行行号
    ,o.open_bank_name -- 开户行名称
    ,o.acct_name -- 账户名称
    ,o.acct_id -- 账户编号
    ,o.acct_type_cd -- 账户类型代码
    ,o.open_acct_acct_addr -- 开户账户地址
    ,o.t1_fee_rat -- T1费率
    ,o.d0_fee_rat -- D0费率
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_bk o
    left join ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_op n
        on
            o.mercht_id = n.mercht_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_cl d
        on
            o.mercht_id = d.mercht_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_jh_mercht_stl_acct;
alter table ${iml_schema}.pty_jh_mercht_stl_acct truncate partition for ('mrmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.pty_jh_mercht_stl_acct exchange subpartition p_mrmsf1_19000101 with table ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_cl;
alter table ${iml_schema}.pty_jh_mercht_stl_acct exchange subpartition p_mrmsf1_20991231 with table ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_jh_mercht_stl_acct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_tm purge;
drop table ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_op purge;
drop table ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_jh_mercht_stl_acct_mrmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_jh_mercht_stl_acct', partname => 'p_mrmsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
