/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_xdb
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_rb_agreement_xdb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_agreement_xdb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_xdb_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_xdb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_xdb_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ncbs_rb_agreement_xdb where 0=1;

create table ${iol_schema}.ncbs_rb_agreement_xdb_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ncbs_rb_agreement_xdb where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.ncbs_rb_agreement_xdb_op(
        acct_seq_no -- 账户子账号
        ,base_acct_no -- 交易账号/卡号
        ,client_no -- 客户编号
        ,internal_key -- 账户内部键值
        ,prod_type -- 产品编号
        ,user_id -- 交易柜员编号
        ,term -- 存期
        ,term_type -- 期限单位
        ,agreement_id -- 协议编号
        ,agreement_status -- 协议状态
        ,auto_sign -- 是否自动续约
        ,company -- 法人
        ,print_flag -- 打印标识
        ,seq_no -- 序号
        ,source_type -- 渠道编号
        ,cancel_date -- 取消日期
        ,end_date -- 结束日期
        ,start_date -- 开始日期
        ,tran_date -- 交易日期
        ,tran_timestamp -- 交易时间戳
        ,acct_ccy -- 账户币种
        ,cancel_user_id -- 取消柜员
        ,keep_amt -- 产品留存金额
        ,sign_amt -- 签约金额
        ,xdb_prod_type -- 协定宝产品类型
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.acct_seq_no -- 账户子账号
    ,n.base_acct_no -- 交易账号/卡号
    ,n.client_no -- 客户编号
    ,n.internal_key -- 账户内部键值
    ,n.prod_type -- 产品编号
    ,n.user_id -- 交易柜员编号
    ,n.term -- 存期
    ,n.term_type -- 期限单位
    ,n.agreement_id -- 协议编号
    ,n.agreement_status -- 协议状态
    ,n.auto_sign -- 是否自动续约
    ,n.company -- 法人
    ,n.print_flag -- 打印标识
    ,n.seq_no -- 序号
    ,n.source_type -- 渠道编号
    ,n.cancel_date -- 取消日期
    ,n.end_date -- 结束日期
    ,n.start_date -- 开始日期
    ,n.tran_date -- 交易日期
    ,n.tran_timestamp -- 交易时间戳
    ,n.acct_ccy -- 账户币种
    ,n.cancel_user_id -- 取消柜员
    ,n.keep_amt -- 产品留存金额
    ,n.sign_amt -- 签约金额
    ,n.xdb_prod_type -- 协定宝产品类型
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_agreement_xdb_bk o
    right join (select * from ${itl_schema}.ncbs_rb_agreement_xdb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.prod_type <> n.prod_type
        or o.user_id <> n.user_id
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.agreement_id <> n.agreement_id
        or o.agreement_status <> n.agreement_status
        or o.auto_sign <> n.auto_sign
        or o.company <> n.company
        or o.print_flag <> n.print_flag
        or o.seq_no <> n.seq_no
        or o.source_type <> n.source_type
        or o.cancel_date <> n.cancel_date
        or o.end_date <> n.end_date
        or o.start_date <> n.start_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.cancel_user_id <> n.cancel_user_id
        or o.keep_amt <> n.keep_amt
        or o.sign_amt <> n.sign_amt
        or o.xdb_prod_type <> n.xdb_prod_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_xdb_cl(
            acct_seq_no -- 账户子账号
        ,base_acct_no -- 交易账号/卡号
        ,client_no -- 客户编号
        ,internal_key -- 账户内部键值
        ,prod_type -- 产品编号
        ,user_id -- 交易柜员编号
        ,term -- 存期
        ,term_type -- 期限单位
        ,agreement_id -- 协议编号
        ,agreement_status -- 协议状态
        ,auto_sign -- 是否自动续约
        ,company -- 法人
        ,print_flag -- 打印标识
        ,seq_no -- 序号
        ,source_type -- 渠道编号
        ,cancel_date -- 取消日期
        ,end_date -- 结束日期
        ,start_date -- 开始日期
        ,tran_date -- 交易日期
        ,tran_timestamp -- 交易时间戳
        ,acct_ccy -- 账户币种
        ,cancel_user_id -- 取消柜员
        ,keep_amt -- 产品留存金额
        ,sign_amt -- 签约金额
        ,xdb_prod_type -- 协定宝产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_xdb_op(
            acct_seq_no -- 账户子账号
        ,base_acct_no -- 交易账号/卡号
        ,client_no -- 客户编号
        ,internal_key -- 账户内部键值
        ,prod_type -- 产品编号
        ,user_id -- 交易柜员编号
        ,term -- 存期
        ,term_type -- 期限单位
        ,agreement_id -- 协议编号
        ,agreement_status -- 协议状态
        ,auto_sign -- 是否自动续约
        ,company -- 法人
        ,print_flag -- 打印标识
        ,seq_no -- 序号
        ,source_type -- 渠道编号
        ,cancel_date -- 取消日期
        ,end_date -- 结束日期
        ,start_date -- 开始日期
        ,tran_date -- 交易日期
        ,tran_timestamp -- 交易时间戳
        ,acct_ccy -- 账户币种
        ,cancel_user_id -- 取消柜员
        ,keep_amt -- 产品留存金额
        ,sign_amt -- 签约金额
        ,xdb_prod_type -- 协定宝产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.agreement_id -- 协议编号
    ,o.agreement_status -- 协议状态
    ,o.auto_sign -- 是否自动续约
    ,o.company -- 法人
    ,o.print_flag -- 打印标识
    ,o.seq_no -- 序号
    ,o.source_type -- 渠道编号
    ,o.cancel_date -- 取消日期
    ,o.end_date -- 结束日期
    ,o.start_date -- 开始日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.cancel_user_id -- 取消柜员
    ,o.keep_amt -- 产品留存金额
    ,o.sign_amt -- 签约金额
    ,o.xdb_prod_type -- 协定宝产品类型
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_agreement_xdb_bk o
    left join ${iol_schema}.ncbs_rb_agreement_xdb_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_agreement_xdb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_agreement_xdb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_agreement_xdb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_agreement_xdb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_agreement_xdb exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agreement_xdb_cl;
alter table ${iol_schema}.ncbs_rb_agreement_xdb exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_agreement_xdb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agreement_xdb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_xdb_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_xdb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_agreement_xdb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agreement_xdb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
