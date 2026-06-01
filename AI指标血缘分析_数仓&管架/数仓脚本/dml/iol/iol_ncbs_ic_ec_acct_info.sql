/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_ic_ec_acct_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_ic_ec_acct_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_ic_ec_acct_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_ic_ec_acct_info_op purge;
drop table ${iol_schema}.ncbs_ic_ec_acct_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_ic_ec_acct_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_ic_ec_acct_info where 0=1;

create table ${iol_schema}.ncbs_ic_ec_acct_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_ic_ec_acct_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_ic_ec_acct_info_cl(
            card_no -- 卡号
            ,ic_card_seq -- 卡序列号
            ,ic_aid -- 应用标识符
            ,ec_acct_stat -- 电子现金账户状态
            ,ec_acct_ccy -- 电子现金账户币种
            ,ic_act_bal -- 电子现金账户余额
            ,ec_bal_top_limit -- 电子现金余额上限
            ,ec_tran_limit -- 电子现金单笔交易限额
            ,ic_app_start_date -- 应用生效日期
            ,ic_app_end_date -- 应用失效日期
            ,open_date -- 电子现金账户开户日期
            ,acct_name -- 账户名称
            ,open_org_id -- 开户机构
            ,aggr_amt -- 累计圈存金额
            ,acct_close_date -- 电子现金账户销户日期
            ,close_seq_num -- 销户流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_ic_ec_acct_info_op(
            card_no -- 卡号
            ,ic_card_seq -- 卡序列号
            ,ic_aid -- 应用标识符
            ,ec_acct_stat -- 电子现金账户状态
            ,ec_acct_ccy -- 电子现金账户币种
            ,ic_act_bal -- 电子现金账户余额
            ,ec_bal_top_limit -- 电子现金余额上限
            ,ec_tran_limit -- 电子现金单笔交易限额
            ,ic_app_start_date -- 应用生效日期
            ,ic_app_end_date -- 应用失效日期
            ,open_date -- 电子现金账户开户日期
            ,acct_name -- 账户名称
            ,open_org_id -- 开户机构
            ,aggr_amt -- 累计圈存金额
            ,acct_close_date -- 电子现金账户销户日期
            ,close_seq_num -- 销户流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.ic_card_seq, o.ic_card_seq) as ic_card_seq -- 卡序列号
    ,nvl(n.ic_aid, o.ic_aid) as ic_aid -- 应用标识符
    ,nvl(n.ec_acct_stat, o.ec_acct_stat) as ec_acct_stat -- 电子现金账户状态
    ,nvl(n.ec_acct_ccy, o.ec_acct_ccy) as ec_acct_ccy -- 电子现金账户币种
    ,nvl(n.ic_act_bal, o.ic_act_bal) as ic_act_bal -- 电子现金账户余额
    ,nvl(n.ec_bal_top_limit, o.ec_bal_top_limit) as ec_bal_top_limit -- 电子现金余额上限
    ,nvl(n.ec_tran_limit, o.ec_tran_limit) as ec_tran_limit -- 电子现金单笔交易限额
    ,nvl(n.ic_app_start_date, o.ic_app_start_date) as ic_app_start_date -- 应用生效日期
    ,nvl(n.ic_app_end_date, o.ic_app_end_date) as ic_app_end_date -- 应用失效日期
    ,nvl(n.open_date, o.open_date) as open_date -- 电子现金账户开户日期
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.open_org_id, o.open_org_id) as open_org_id -- 开户机构
    ,nvl(n.aggr_amt, o.aggr_amt) as aggr_amt -- 累计圈存金额
    ,nvl(n.acct_close_date, o.acct_close_date) as acct_close_date -- 电子现金账户销户日期
    ,nvl(n.close_seq_num, o.close_seq_num) as close_seq_num -- 销户流水号
    ,case when
            n.card_no is null
            and n.ic_card_seq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.card_no is null
            and n.ic_card_seq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.card_no is null
            and n.ic_card_seq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_ic_ec_acct_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_ic_ec_acct_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.card_no = n.card_no
            and o.ic_card_seq = n.ic_card_seq
where (
        o.card_no is null
        and o.ic_card_seq is null
    )
    or (
        n.card_no is null
        and n.ic_card_seq is null
    )
    or (
        o.ic_aid <> n.ic_aid
        or o.ec_acct_stat <> n.ec_acct_stat
        or o.ec_acct_ccy <> n.ec_acct_ccy
        or o.ic_act_bal <> n.ic_act_bal
        or o.ec_bal_top_limit <> n.ec_bal_top_limit
        or o.ec_tran_limit <> n.ec_tran_limit
        or o.ic_app_start_date <> n.ic_app_start_date
        or o.ic_app_end_date <> n.ic_app_end_date
        or o.open_date <> n.open_date
        or o.acct_name <> n.acct_name
        or o.open_org_id <> n.open_org_id
        or o.aggr_amt <> n.aggr_amt
        or o.acct_close_date <> n.acct_close_date
        or o.close_seq_num <> n.close_seq_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_ic_ec_acct_info_cl(
            card_no -- 卡号
            ,ic_card_seq -- 卡序列号
            ,ic_aid -- 应用标识符
            ,ec_acct_stat -- 电子现金账户状态
            ,ec_acct_ccy -- 电子现金账户币种
            ,ic_act_bal -- 电子现金账户余额
            ,ec_bal_top_limit -- 电子现金余额上限
            ,ec_tran_limit -- 电子现金单笔交易限额
            ,ic_app_start_date -- 应用生效日期
            ,ic_app_end_date -- 应用失效日期
            ,open_date -- 电子现金账户开户日期
            ,acct_name -- 账户名称
            ,open_org_id -- 开户机构
            ,aggr_amt -- 累计圈存金额
            ,acct_close_date -- 电子现金账户销户日期
            ,close_seq_num -- 销户流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_ic_ec_acct_info_op(
            card_no -- 卡号
            ,ic_card_seq -- 卡序列号
            ,ic_aid -- 应用标识符
            ,ec_acct_stat -- 电子现金账户状态
            ,ec_acct_ccy -- 电子现金账户币种
            ,ic_act_bal -- 电子现金账户余额
            ,ec_bal_top_limit -- 电子现金余额上限
            ,ec_tran_limit -- 电子现金单笔交易限额
            ,ic_app_start_date -- 应用生效日期
            ,ic_app_end_date -- 应用失效日期
            ,open_date -- 电子现金账户开户日期
            ,acct_name -- 账户名称
            ,open_org_id -- 开户机构
            ,aggr_amt -- 累计圈存金额
            ,acct_close_date -- 电子现金账户销户日期
            ,close_seq_num -- 销户流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.card_no -- 卡号
    ,o.ic_card_seq -- 卡序列号
    ,o.ic_aid -- 应用标识符
    ,o.ec_acct_stat -- 电子现金账户状态
    ,o.ec_acct_ccy -- 电子现金账户币种
    ,o.ic_act_bal -- 电子现金账户余额
    ,o.ec_bal_top_limit -- 电子现金余额上限
    ,o.ec_tran_limit -- 电子现金单笔交易限额
    ,o.ic_app_start_date -- 应用生效日期
    ,o.ic_app_end_date -- 应用失效日期
    ,o.open_date -- 电子现金账户开户日期
    ,o.acct_name -- 账户名称
    ,o.open_org_id -- 开户机构
    ,o.aggr_amt -- 累计圈存金额
    ,o.acct_close_date -- 电子现金账户销户日期
    ,o.close_seq_num -- 销户流水号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_ic_ec_acct_info_bk o
    left join ${iol_schema}.ncbs_ic_ec_acct_info_op n
        on
            o.card_no = n.card_no
            and o.ic_card_seq = n.ic_card_seq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_ic_ec_acct_info_cl d
        on
            o.card_no = d.card_no
            and o.ic_card_seq = d.ic_card_seq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_ic_ec_acct_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_ic_ec_acct_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_ic_ec_acct_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_ic_ec_acct_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_ic_ec_acct_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_ic_ec_acct_info_cl;
alter table ${iol_schema}.ncbs_ic_ec_acct_info exchange partition p_20991231 with table ${iol_schema}.ncbs_ic_ec_acct_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_ic_ec_acct_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_ic_ec_acct_info_op purge;
drop table ${iol_schema}.ncbs_ic_ec_acct_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_ic_ec_acct_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_ic_ec_acct_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
