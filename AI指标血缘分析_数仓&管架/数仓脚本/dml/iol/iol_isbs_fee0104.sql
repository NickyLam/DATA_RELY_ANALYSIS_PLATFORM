/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_fee0104
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
create table ${iol_schema}.isbs_fee0104_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_fee0104
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fee0104_op purge;
drop table ${iol_schema}.isbs_fee0104_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fee0104_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fee0104 where 0=1;

create table ${iol_schema}.isbs_fee0104_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fee0104 where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fee0104_cl(
            inr -- 主键
            ,trninr -- TRN主键
            ,credattim -- 创建时间
            ,seq -- 序号
            ,client_no -- 客户号
            ,fee_type -- 汇率类别
            ,fee_ccy -- 帐户动作收用币种
            ,fee_amt -- 账户动作收用金额
            ,fee_charge_method -- 服务手续费收取方式
            ,charge_mode -- 收取标志
            ,charge_to_base_acct_no -- 收取账号
            ,charge_to_acct_seq_no -- 收取账号序号
            ,withdrawal_type -- 支取方式码
            ,effect_date -- 生效日期
            ,amort_start -- 摊销起始日期
            ,amort_end -- 摊销截止日期
            ,feecod -- 交易类别
            ,ownkey -- 业务编号
            ,othcli -- 外层客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fee0104_op(
            inr -- 主键
            ,trninr -- TRN主键
            ,credattim -- 创建时间
            ,seq -- 序号
            ,client_no -- 客户号
            ,fee_type -- 汇率类别
            ,fee_ccy -- 帐户动作收用币种
            ,fee_amt -- 账户动作收用金额
            ,fee_charge_method -- 服务手续费收取方式
            ,charge_mode -- 收取标志
            ,charge_to_base_acct_no -- 收取账号
            ,charge_to_acct_seq_no -- 收取账号序号
            ,withdrawal_type -- 支取方式码
            ,effect_date -- 生效日期
            ,amort_start -- 摊销起始日期
            ,amort_end -- 摊销截止日期
            ,feecod -- 交易类别
            ,ownkey -- 业务编号
            ,othcli -- 外层客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 主键
    ,nvl(n.trninr, o.trninr) as trninr -- TRN主键
    ,nvl(n.credattim, o.credattim) as credattim -- 创建时间
    ,nvl(n.seq, o.seq) as seq -- 序号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户号
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 汇率类别
    ,nvl(n.fee_ccy, o.fee_ccy) as fee_ccy -- 帐户动作收用币种
    ,nvl(n.fee_amt, o.fee_amt) as fee_amt -- 账户动作收用金额
    ,nvl(n.fee_charge_method, o.fee_charge_method) as fee_charge_method -- 服务手续费收取方式
    ,nvl(n.charge_mode, o.charge_mode) as charge_mode -- 收取标志
    ,nvl(n.charge_to_base_acct_no, o.charge_to_base_acct_no) as charge_to_base_acct_no -- 收取账号
    ,nvl(n.charge_to_acct_seq_no, o.charge_to_acct_seq_no) as charge_to_acct_seq_no -- 收取账号序号
    ,nvl(n.withdrawal_type, o.withdrawal_type) as withdrawal_type -- 支取方式码
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 生效日期
    ,nvl(n.amort_start, o.amort_start) as amort_start -- 摊销起始日期
    ,nvl(n.amort_end, o.amort_end) as amort_end -- 摊销截止日期
    ,nvl(n.feecod, o.feecod) as feecod -- 交易类别
    ,nvl(n.ownkey, o.ownkey) as ownkey -- 业务编号
    ,nvl(n.othcli, o.othcli) as othcli -- 外层客户号
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_fee0104_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_fee0104 where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.trninr <> n.trninr
        or o.credattim <> n.credattim
        or o.seq <> n.seq
        or o.client_no <> n.client_no
        or o.fee_type <> n.fee_type
        or o.fee_ccy <> n.fee_ccy
        or o.fee_amt <> n.fee_amt
        or o.fee_charge_method <> n.fee_charge_method
        or o.charge_mode <> n.charge_mode
        or o.charge_to_base_acct_no <> n.charge_to_base_acct_no
        or o.charge_to_acct_seq_no <> n.charge_to_acct_seq_no
        or o.withdrawal_type <> n.withdrawal_type
        or o.effect_date <> n.effect_date
        or o.amort_start <> n.amort_start
        or o.amort_end <> n.amort_end
        or o.feecod <> n.feecod
        or o.ownkey <> n.ownkey
        or o.othcli <> n.othcli
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fee0104_cl(
            inr -- 主键
            ,trninr -- TRN主键
            ,credattim -- 创建时间
            ,seq -- 序号
            ,client_no -- 客户号
            ,fee_type -- 汇率类别
            ,fee_ccy -- 帐户动作收用币种
            ,fee_amt -- 账户动作收用金额
            ,fee_charge_method -- 服务手续费收取方式
            ,charge_mode -- 收取标志
            ,charge_to_base_acct_no -- 收取账号
            ,charge_to_acct_seq_no -- 收取账号序号
            ,withdrawal_type -- 支取方式码
            ,effect_date -- 生效日期
            ,amort_start -- 摊销起始日期
            ,amort_end -- 摊销截止日期
            ,feecod -- 交易类别
            ,ownkey -- 业务编号
            ,othcli -- 外层客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fee0104_op(
            inr -- 主键
            ,trninr -- TRN主键
            ,credattim -- 创建时间
            ,seq -- 序号
            ,client_no -- 客户号
            ,fee_type -- 汇率类别
            ,fee_ccy -- 帐户动作收用币种
            ,fee_amt -- 账户动作收用金额
            ,fee_charge_method -- 服务手续费收取方式
            ,charge_mode -- 收取标志
            ,charge_to_base_acct_no -- 收取账号
            ,charge_to_acct_seq_no -- 收取账号序号
            ,withdrawal_type -- 支取方式码
            ,effect_date -- 生效日期
            ,amort_start -- 摊销起始日期
            ,amort_end -- 摊销截止日期
            ,feecod -- 交易类别
            ,ownkey -- 业务编号
            ,othcli -- 外层客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 主键
    ,o.trninr -- TRN主键
    ,o.credattim -- 创建时间
    ,o.seq -- 序号
    ,o.client_no -- 客户号
    ,o.fee_type -- 汇率类别
    ,o.fee_ccy -- 帐户动作收用币种
    ,o.fee_amt -- 账户动作收用金额
    ,o.fee_charge_method -- 服务手续费收取方式
    ,o.charge_mode -- 收取标志
    ,o.charge_to_base_acct_no -- 收取账号
    ,o.charge_to_acct_seq_no -- 收取账号序号
    ,o.withdrawal_type -- 支取方式码
    ,o.effect_date -- 生效日期
    ,o.amort_start -- 摊销起始日期
    ,o.amort_end -- 摊销截止日期
    ,o.feecod -- 交易类别
    ,o.ownkey -- 业务编号
    ,o.othcli -- 外层客户号
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
from ${iol_schema}.isbs_fee0104_bk o
    left join ${iol_schema}.isbs_fee0104_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_fee0104_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.isbs_fee0104;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_fee0104') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_fee0104 drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_fee0104 add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_fee0104 exchange partition p_${batch_date} with table ${iol_schema}.isbs_fee0104_cl;
alter table ${iol_schema}.isbs_fee0104 exchange partition p_20991231 with table ${iol_schema}.isbs_fee0104_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_fee0104 to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fee0104_op purge;
drop table ${iol_schema}.isbs_fee0104_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_fee0104_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_fee0104',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
