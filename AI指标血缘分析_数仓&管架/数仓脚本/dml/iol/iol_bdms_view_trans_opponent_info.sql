/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_view_trans_opponent_info
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
create table ${iol_schema}.bdms_view_trans_opponent_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_view_trans_opponent_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_view_trans_opponent_info_op purge;
drop table ${iol_schema}.bdms_view_trans_opponent_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_view_trans_opponent_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_view_trans_opponent_info where 0=1;

create table ${iol_schema}.bdms_view_trans_opponent_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_view_trans_opponent_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_view_trans_opponent_info_cl(
            bsnssq -- 全局流水号
            ,transq -- 交易流水号
            ,serino -- 序列号
            ,cust_acct -- 交易对手账号
            ,cust_name -- 交易对手名称
            ,cust_bank_no -- 交易对手行号
            ,cust_bank_name -- 交易对手行名
            ,province_no -- 对手银行所在地行政区划
            ,province_name -- 区域名称
            ,cert_id -- 交易对手证件类型
            ,cert_type -- 交易对手证件号码
            ,social_credit_no -- 统一社会信用代码
            ,txn_bank_type -- 交易对手行号类型
            ,evetdn -- 借贷方向
            ,iscustacct -- 是否客户账务标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_view_trans_opponent_info_op(
            bsnssq -- 全局流水号
            ,transq -- 交易流水号
            ,serino -- 序列号
            ,cust_acct -- 交易对手账号
            ,cust_name -- 交易对手名称
            ,cust_bank_no -- 交易对手行号
            ,cust_bank_name -- 交易对手行名
            ,province_no -- 对手银行所在地行政区划
            ,province_name -- 区域名称
            ,cert_id -- 交易对手证件类型
            ,cert_type -- 交易对手证件号码
            ,social_credit_no -- 统一社会信用代码
            ,txn_bank_type -- 交易对手行号类型
            ,evetdn -- 借贷方向
            ,iscustacct -- 是否客户账务标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bsnssq, o.bsnssq) as bsnssq -- 全局流水号
    ,nvl(n.transq, o.transq) as transq -- 交易流水号
    ,nvl(n.serino, o.serino) as serino -- 序列号
    ,nvl(n.cust_acct, o.cust_acct) as cust_acct -- 交易对手账号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 交易对手名称
    ,nvl(n.cust_bank_no, o.cust_bank_no) as cust_bank_no -- 交易对手行号
    ,nvl(n.cust_bank_name, o.cust_bank_name) as cust_bank_name -- 交易对手行名
    ,nvl(n.province_no, o.province_no) as province_no -- 对手银行所在地行政区划
    ,nvl(n.province_name, o.province_name) as province_name -- 区域名称
    ,nvl(n.cert_id, o.cert_id) as cert_id -- 交易对手证件类型
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 交易对手证件号码
    ,nvl(n.social_credit_no, o.social_credit_no) as social_credit_no -- 统一社会信用代码
    ,nvl(n.txn_bank_type, o.txn_bank_type) as txn_bank_type -- 交易对手行号类型
    ,nvl(n.evetdn, o.evetdn) as evetdn -- 借贷方向
    ,nvl(n.iscustacct, o.iscustacct) as iscustacct -- 是否客户账务标识
    ,case when
            n.bsnssq is null
            and n.transq is null
            and n.serino is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bsnssq is null
            and n.transq is null
            and n.serino is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bsnssq is null
            and n.transq is null
            and n.serino is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_view_trans_opponent_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_view_trans_opponent_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bsnssq = n.bsnssq
            and o.transq = n.transq
            and o.serino = n.serino
where (
        o.bsnssq is null
        and o.transq is null
        and o.serino is null
    )
    or (
        n.bsnssq is null
        and n.transq is null
        and n.serino is null
    )
    or (
        o.cust_acct <> n.cust_acct
        or o.cust_name <> n.cust_name
        or o.cust_bank_no <> n.cust_bank_no
        or o.cust_bank_name <> n.cust_bank_name
        or o.province_no <> n.province_no
        or o.province_name <> n.province_name
        or o.cert_id <> n.cert_id
        or o.cert_type <> n.cert_type
        or o.social_credit_no <> n.social_credit_no
        or o.txn_bank_type <> n.txn_bank_type
        or o.evetdn <> n.evetdn
        or o.iscustacct <> n.iscustacct
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_view_trans_opponent_info_cl(
            bsnssq -- 全局流水号
            ,transq -- 交易流水号
            ,serino -- 序列号
            ,cust_acct -- 交易对手账号
            ,cust_name -- 交易对手名称
            ,cust_bank_no -- 交易对手行号
            ,cust_bank_name -- 交易对手行名
            ,province_no -- 对手银行所在地行政区划
            ,province_name -- 区域名称
            ,cert_id -- 交易对手证件类型
            ,cert_type -- 交易对手证件号码
            ,social_credit_no -- 统一社会信用代码
            ,txn_bank_type -- 交易对手行号类型
            ,evetdn -- 借贷方向
            ,iscustacct -- 是否客户账务标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_view_trans_opponent_info_op(
            bsnssq -- 全局流水号
            ,transq -- 交易流水号
            ,serino -- 序列号
            ,cust_acct -- 交易对手账号
            ,cust_name -- 交易对手名称
            ,cust_bank_no -- 交易对手行号
            ,cust_bank_name -- 交易对手行名
            ,province_no -- 对手银行所在地行政区划
            ,province_name -- 区域名称
            ,cert_id -- 交易对手证件类型
            ,cert_type -- 交易对手证件号码
            ,social_credit_no -- 统一社会信用代码
            ,txn_bank_type -- 交易对手行号类型
            ,evetdn -- 借贷方向
            ,iscustacct -- 是否客户账务标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bsnssq -- 全局流水号
    ,o.transq -- 交易流水号
    ,o.serino -- 序列号
    ,o.cust_acct -- 交易对手账号
    ,o.cust_name -- 交易对手名称
    ,o.cust_bank_no -- 交易对手行号
    ,o.cust_bank_name -- 交易对手行名
    ,o.province_no -- 对手银行所在地行政区划
    ,o.province_name -- 区域名称
    ,o.cert_id -- 交易对手证件类型
    ,o.cert_type -- 交易对手证件号码
    ,o.social_credit_no -- 统一社会信用代码
    ,o.txn_bank_type -- 交易对手行号类型
    ,o.evetdn -- 借贷方向
    ,o.iscustacct -- 是否客户账务标识
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
from ${iol_schema}.bdms_view_trans_opponent_info_bk o
    left join ${iol_schema}.bdms_view_trans_opponent_info_op n
        on
            o.bsnssq = n.bsnssq
            and o.transq = n.transq
            and o.serino = n.serino
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_view_trans_opponent_info_cl d
        on
            o.bsnssq = d.bsnssq
            and o.transq = d.transq
            and o.serino = d.serino
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_view_trans_opponent_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_view_trans_opponent_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_view_trans_opponent_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_view_trans_opponent_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_view_trans_opponent_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_view_trans_opponent_info_cl;
alter table ${iol_schema}.bdms_view_trans_opponent_info exchange partition p_20991231 with table ${iol_schema}.bdms_view_trans_opponent_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_view_trans_opponent_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_view_trans_opponent_info_op purge;
drop table ${iol_schema}.bdms_view_trans_opponent_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_view_trans_opponent_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_view_trans_opponent_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
