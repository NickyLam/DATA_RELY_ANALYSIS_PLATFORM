/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_fund_direction_details
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
create table ${iol_schema}.ncbs_rb_fund_direction_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_fund_direction_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_fund_direction_details_op purge;
drop table ${iol_schema}.ncbs_rb_fund_direction_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_fund_direction_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_fund_direction_details where 0=1;

create table ${iol_schema}.ncbs_rb_fund_direction_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_fund_direction_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_fund_direction_details_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,company -- 法人
            ,fund_source -- 资金来源
            ,reg_type -- 登记类型
            ,seq_no -- 序号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,agent_name -- 办理人姓名
            ,bab_internal_base_acct_no -- 内部账户账号
            ,fund_to_acct_no -- 资金去向账号
            ,fund_acct_purpose -- 账户资金用途
            ,fund_from_acct_no -- 资金来源账号
            ,fund_from_bank_no -- 资金来源支付行号
            ,fund_from_name -- 资金来源户名
            ,fund_to_bank_no -- 资金去向支付行号
            ,fund_to_name -- 资金去向户名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_fund_direction_details_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,company -- 法人
            ,fund_source -- 资金来源
            ,reg_type -- 登记类型
            ,seq_no -- 序号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,agent_name -- 办理人姓名
            ,bab_internal_base_acct_no -- 内部账户账号
            ,fund_to_acct_no -- 资金去向账号
            ,fund_acct_purpose -- 账户资金用途
            ,fund_from_acct_no -- 资金来源账号
            ,fund_from_bank_no -- 资金来源支付行号
            ,fund_from_name -- 资金来源户名
            ,fund_to_bank_no -- 资金去向支付行号
            ,fund_to_name -- 资金去向户名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.fund_source, o.fund_source) as fund_source -- 资金来源
    ,nvl(n.reg_type, o.reg_type) as reg_type -- 登记类型
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.agent_name, o.agent_name) as agent_name -- 办理人姓名
    ,nvl(n.bab_internal_base_acct_no, o.bab_internal_base_acct_no) as bab_internal_base_acct_no -- 内部账户账号
    ,nvl(n.fund_to_acct_no, o.fund_to_acct_no) as fund_to_acct_no -- 资金去向账号
    ,nvl(n.fund_acct_purpose, o.fund_acct_purpose) as fund_acct_purpose -- 账户资金用途
    ,nvl(n.fund_from_acct_no, o.fund_from_acct_no) as fund_from_acct_no -- 资金来源账号
    ,nvl(n.fund_from_bank_no, o.fund_from_bank_no) as fund_from_bank_no -- 资金来源支付行号
    ,nvl(n.fund_from_name, o.fund_from_name) as fund_from_name -- 资金来源户名
    ,nvl(n.fund_to_bank_no, o.fund_to_bank_no) as fund_to_bank_no -- 资金去向支付行号
    ,nvl(n.fund_to_name, o.fund_to_name) as fund_to_name -- 资金去向户名
    ,case when
            n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_fund_direction_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_fund_direction_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.prod_type <> n.prod_type
        or o.company <> n.company
        or o.fund_source <> n.fund_source
        or o.reg_type <> n.reg_type
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.agent_name <> n.agent_name
        or o.bab_internal_base_acct_no <> n.bab_internal_base_acct_no
        or o.fund_to_acct_no <> n.fund_to_acct_no
        or o.fund_acct_purpose <> n.fund_acct_purpose
        or o.fund_from_acct_no <> n.fund_from_acct_no
        or o.fund_from_bank_no <> n.fund_from_bank_no
        or o.fund_from_name <> n.fund_from_name
        or o.fund_to_bank_no <> n.fund_to_bank_no
        or o.fund_to_name <> n.fund_to_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_fund_direction_details_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,company -- 法人
            ,fund_source -- 资金来源
            ,reg_type -- 登记类型
            ,seq_no -- 序号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,agent_name -- 办理人姓名
            ,bab_internal_base_acct_no -- 内部账户账号
            ,fund_to_acct_no -- 资金去向账号
            ,fund_acct_purpose -- 账户资金用途
            ,fund_from_acct_no -- 资金来源账号
            ,fund_from_bank_no -- 资金来源支付行号
            ,fund_from_name -- 资金来源户名
            ,fund_to_bank_no -- 资金去向支付行号
            ,fund_to_name -- 资金去向户名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_fund_direction_details_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,company -- 法人
            ,fund_source -- 资金来源
            ,reg_type -- 登记类型
            ,seq_no -- 序号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,agent_name -- 办理人姓名
            ,bab_internal_base_acct_no -- 内部账户账号
            ,fund_to_acct_no -- 资金去向账号
            ,fund_acct_purpose -- 账户资金用途
            ,fund_from_acct_no -- 资金来源账号
            ,fund_from_bank_no -- 资金来源支付行号
            ,fund_from_name -- 资金来源户名
            ,fund_to_bank_no -- 资金去向支付行号
            ,fund_to_name -- 资金去向户名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.prod_type -- 产品编号
    ,o.company -- 法人
    ,o.fund_source -- 资金来源
    ,o.reg_type -- 登记类型
    ,o.seq_no -- 序号
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.agent_name -- 办理人姓名
    ,o.bab_internal_base_acct_no -- 内部账户账号
    ,o.fund_to_acct_no -- 资金去向账号
    ,o.fund_acct_purpose -- 账户资金用途
    ,o.fund_from_acct_no -- 资金来源账号
    ,o.fund_from_bank_no -- 资金来源支付行号
    ,o.fund_from_name -- 资金来源户名
    ,o.fund_to_bank_no -- 资金去向支付行号
    ,o.fund_to_name -- 资金去向户名
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
from ${iol_schema}.ncbs_rb_fund_direction_details_bk o
    left join ${iol_schema}.ncbs_rb_fund_direction_details_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_fund_direction_details_cl d
        on
            o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_fund_direction_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_fund_direction_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_fund_direction_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_fund_direction_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_fund_direction_details exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_fund_direction_details_cl;
alter table ${iol_schema}.ncbs_rb_fund_direction_details exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_fund_direction_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_fund_direction_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_fund_direction_details_op purge;
drop table ${iol_schema}.ncbs_rb_fund_direction_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_fund_direction_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_fund_direction_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
