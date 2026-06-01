/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_appr_letter
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
create table ${iol_schema}.ncbs_rb_appr_letter_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_appr_letter
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_appr_letter_op purge;
drop table ${iol_schema}.ncbs_rb_appr_letter_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_appr_letter_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_appr_letter where 0=1;

create table ${iol_schema}.ncbs_rb_appr_letter_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_appr_letter where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_appr_letter_cl(
            client_no -- 客户编号
            ,user_id -- 交易柜员编号
            ,acct_type_desc -- 账户类型描述
            ,appr_acct_ind -- 核准账户要项
            ,appr_letter_no -- 核准件编号
            ,appr_type -- 核准件类型
            ,company -- 法人
            ,expend_scope -- 支出范围
            ,fund_purpose -- 资金用途
            ,fund_source -- 资金来源
            ,income_scope -- 收入范围
            ,narrative -- 摘要
            ,maturity_date -- 到期日期
            ,open_date -- 开立日期
            ,tran_timestamp -- 交易时间戳
            ,capital_amt -- 核准件开立金额
            ,tran_branch -- 核心交易机构编号
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_appr_letter_op(
            client_no -- 客户编号
            ,user_id -- 交易柜员编号
            ,acct_type_desc -- 账户类型描述
            ,appr_acct_ind -- 核准账户要项
            ,appr_letter_no -- 核准件编号
            ,appr_type -- 核准件类型
            ,company -- 法人
            ,expend_scope -- 支出范围
            ,fund_purpose -- 资金用途
            ,fund_source -- 资金来源
            ,income_scope -- 收入范围
            ,narrative -- 摘要
            ,maturity_date -- 到期日期
            ,open_date -- 开立日期
            ,tran_timestamp -- 交易时间戳
            ,capital_amt -- 核准件开立金额
            ,tran_branch -- 核心交易机构编号
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.acct_type_desc, o.acct_type_desc) as acct_type_desc -- 账户类型描述
    ,nvl(n.appr_acct_ind, o.appr_acct_ind) as appr_acct_ind -- 核准账户要项
    ,nvl(n.appr_letter_no, o.appr_letter_no) as appr_letter_no -- 核准件编号
    ,nvl(n.appr_type, o.appr_type) as appr_type -- 核准件类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.expend_scope, o.expend_scope) as expend_scope -- 支出范围
    ,nvl(n.fund_purpose, o.fund_purpose) as fund_purpose -- 资金用途
    ,nvl(n.fund_source, o.fund_source) as fund_source -- 资金来源
    ,nvl(n.income_scope, o.income_scope) as income_scope -- 收入范围
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日期
    ,nvl(n.open_date, o.open_date) as open_date -- 开立日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.capital_amt, o.capital_amt) as capital_amt -- 核准件开立金额
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.appr_letter_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appr_letter_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appr_letter_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_appr_letter_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_appr_letter where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.appr_letter_no = n.appr_letter_no
where (
        o.appr_letter_no is null
    )
    or (
        n.appr_letter_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.user_id <> n.user_id
        or o.acct_type_desc <> n.acct_type_desc
        or o.appr_acct_ind <> n.appr_acct_ind
        or o.appr_type <> n.appr_type
        or o.company <> n.company
        or o.expend_scope <> n.expend_scope
        or o.fund_purpose <> n.fund_purpose
        or o.fund_source <> n.fund_source
        or o.income_scope <> n.income_scope
        or o.narrative <> n.narrative
        or o.maturity_date <> n.maturity_date
        or o.open_date <> n.open_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.capital_amt <> n.capital_amt
        or o.tran_branch <> n.tran_branch
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_appr_letter_cl(
            client_no -- 客户编号
            ,user_id -- 交易柜员编号
            ,acct_type_desc -- 账户类型描述
            ,appr_acct_ind -- 核准账户要项
            ,appr_letter_no -- 核准件编号
            ,appr_type -- 核准件类型
            ,company -- 法人
            ,expend_scope -- 支出范围
            ,fund_purpose -- 资金用途
            ,fund_source -- 资金来源
            ,income_scope -- 收入范围
            ,narrative -- 摘要
            ,maturity_date -- 到期日期
            ,open_date -- 开立日期
            ,tran_timestamp -- 交易时间戳
            ,capital_amt -- 核准件开立金额
            ,tran_branch -- 核心交易机构编号
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_appr_letter_op(
            client_no -- 客户编号
            ,user_id -- 交易柜员编号
            ,acct_type_desc -- 账户类型描述
            ,appr_acct_ind -- 核准账户要项
            ,appr_letter_no -- 核准件编号
            ,appr_type -- 核准件类型
            ,company -- 法人
            ,expend_scope -- 支出范围
            ,fund_purpose -- 资金用途
            ,fund_source -- 资金来源
            ,income_scope -- 收入范围
            ,narrative -- 摘要
            ,maturity_date -- 到期日期
            ,open_date -- 开立日期
            ,tran_timestamp -- 交易时间戳
            ,capital_amt -- 核准件开立金额
            ,tran_branch -- 核心交易机构编号
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.user_id -- 交易柜员编号
    ,o.acct_type_desc -- 账户类型描述
    ,o.appr_acct_ind -- 核准账户要项
    ,o.appr_letter_no -- 核准件编号
    ,o.appr_type -- 核准件类型
    ,o.company -- 法人
    ,o.expend_scope -- 支出范围
    ,o.fund_purpose -- 资金用途
    ,o.fund_source -- 资金来源
    ,o.income_scope -- 收入范围
    ,o.narrative -- 摘要
    ,o.maturity_date -- 到期日期
    ,o.open_date -- 开立日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.capital_amt -- 核准件开立金额
    ,o.tran_branch -- 核心交易机构编号
    ,o.remark -- 备注
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
from ${iol_schema}.ncbs_rb_appr_letter_bk o
    left join ${iol_schema}.ncbs_rb_appr_letter_op n
        on
            o.appr_letter_no = n.appr_letter_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_appr_letter_cl d
        on
            o.appr_letter_no = d.appr_letter_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_appr_letter;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_appr_letter') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_appr_letter drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_appr_letter add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_appr_letter exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_appr_letter_cl;
alter table ${iol_schema}.ncbs_rb_appr_letter exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_appr_letter_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_appr_letter to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_appr_letter_op purge;
drop table ${iol_schema}.ncbs_rb_appr_letter_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_appr_letter_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_appr_letter',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
