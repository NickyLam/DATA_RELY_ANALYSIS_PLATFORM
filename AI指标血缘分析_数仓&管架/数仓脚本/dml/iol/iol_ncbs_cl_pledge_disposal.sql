/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_pledge_disposal
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
create table ${iol_schema}.ncbs_cl_pledge_disposal_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_pledge_disposal
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_pledge_disposal_op purge;
drop table ${iol_schema}.ncbs_cl_pledge_disposal_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_pledge_disposal_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_pledge_disposal where 0=1;

create table ${iol_schema}.ncbs_cl_pledge_disposal_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_pledge_disposal where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_pledge_disposal_cl(
            branch -- 机构编号
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,disposal_cd_seq_no -- 处置存单序号
            ,disposal_seq_no -- 处置序号
            ,dispose_acct_no -- 处置入账账号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,compensate_amt -- 保函冻结金额
            ,disposal_cd_ccy -- 处置存单币种
            ,disposal_cd_prod_type -- 处置存单产品类型
            ,dispose_account_amt -- 处置入账金额
            ,dispose_after_bal -- 处置后账户余额
            ,dispose_amount -- 处置金额
            ,dispose_cd_acct_no -- 处置存单编号
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_pledge_disposal_op(
            branch -- 机构编号
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,disposal_cd_seq_no -- 处置存单序号
            ,disposal_seq_no -- 处置序号
            ,dispose_acct_no -- 处置入账账号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,compensate_amt -- 保函冻结金额
            ,disposal_cd_ccy -- 处置存单币种
            ,disposal_cd_prod_type -- 处置存单产品类型
            ,dispose_account_amt -- 处置入账金额
            ,dispose_after_bal -- 处置后账户余额
            ,dispose_amount -- 处置金额
            ,dispose_cd_acct_no -- 处置存单编号
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.disposal_cd_seq_no, o.disposal_cd_seq_no) as disposal_cd_seq_no -- 处置存单序号
    ,nvl(n.disposal_seq_no, o.disposal_seq_no) as disposal_seq_no -- 处置序号
    ,nvl(n.dispose_acct_no, o.dispose_acct_no) as dispose_acct_no -- 处置入账账号
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.compensate_amt, o.compensate_amt) as compensate_amt -- 保函冻结金额
    ,nvl(n.disposal_cd_ccy, o.disposal_cd_ccy) as disposal_cd_ccy -- 处置存单币种
    ,nvl(n.disposal_cd_prod_type, o.disposal_cd_prod_type) as disposal_cd_prod_type -- 处置存单产品类型
    ,nvl(n.dispose_account_amt, o.dispose_account_amt) as dispose_account_amt -- 处置入账金额
    ,nvl(n.dispose_after_bal, o.dispose_after_bal) as dispose_after_bal -- 处置后账户余额
    ,nvl(n.dispose_amount, o.dispose_amount) as dispose_amount -- 处置金额
    ,nvl(n.dispose_cd_acct_no, o.dispose_cd_acct_no) as dispose_cd_acct_no -- 处置存单编号
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,case when
            n.disposal_cd_seq_no is null
            and n.disposal_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.disposal_cd_seq_no is null
            and n.disposal_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.disposal_cd_seq_no is null
            and n.disposal_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_pledge_disposal_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_pledge_disposal where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.disposal_cd_seq_no = n.disposal_cd_seq_no
            and o.disposal_seq_no = n.disposal_seq_no
where (
        o.disposal_cd_seq_no is null
        and o.disposal_seq_no is null
    )
    or (
        n.disposal_cd_seq_no is null
        and n.disposal_seq_no is null
    )
    or (
        o.branch <> n.branch
        or o.client_no <> n.client_no
        or o.reference <> n.reference
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.dispose_acct_no <> n.dispose_acct_no
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.compensate_amt <> n.compensate_amt
        or o.disposal_cd_ccy <> n.disposal_cd_ccy
        or o.disposal_cd_prod_type <> n.disposal_cd_prod_type
        or o.dispose_account_amt <> n.dispose_account_amt
        or o.dispose_after_bal <> n.dispose_after_bal
        or o.dispose_amount <> n.dispose_amount
        or o.dispose_cd_acct_no <> n.dispose_cd_acct_no
        or o.loan_no <> n.loan_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_pledge_disposal_cl(
            branch -- 机构编号
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,disposal_cd_seq_no -- 处置存单序号
            ,disposal_seq_no -- 处置序号
            ,dispose_acct_no -- 处置入账账号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,compensate_amt -- 保函冻结金额
            ,disposal_cd_ccy -- 处置存单币种
            ,disposal_cd_prod_type -- 处置存单产品类型
            ,dispose_account_amt -- 处置入账金额
            ,dispose_after_bal -- 处置后账户余额
            ,dispose_amount -- 处置金额
            ,dispose_cd_acct_no -- 处置存单编号
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_pledge_disposal_op(
            branch -- 机构编号
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,disposal_cd_seq_no -- 处置存单序号
            ,disposal_seq_no -- 处置序号
            ,dispose_acct_no -- 处置入账账号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,compensate_amt -- 保函冻结金额
            ,disposal_cd_ccy -- 处置存单币种
            ,disposal_cd_prod_type -- 处置存单产品类型
            ,dispose_account_amt -- 处置入账金额
            ,dispose_after_bal -- 处置后账户余额
            ,dispose_amount -- 处置金额
            ,dispose_cd_acct_no -- 处置存单编号
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.client_no -- 客户编号
    ,o.reference -- 交易参考号
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.disposal_cd_seq_no -- 处置存单序号
    ,o.disposal_seq_no -- 处置序号
    ,o.dispose_acct_no -- 处置入账账号
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.compensate_amt -- 保函冻结金额
    ,o.disposal_cd_ccy -- 处置存单币种
    ,o.disposal_cd_prod_type -- 处置存单产品类型
    ,o.dispose_account_amt -- 处置入账金额
    ,o.dispose_after_bal -- 处置后账户余额
    ,o.dispose_amount -- 处置金额
    ,o.dispose_cd_acct_no -- 处置存单编号
    ,o.loan_no -- 贷款号
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
from ${iol_schema}.ncbs_cl_pledge_disposal_bk o
    left join ${iol_schema}.ncbs_cl_pledge_disposal_op n
        on
            o.disposal_cd_seq_no = n.disposal_cd_seq_no
            and o.disposal_seq_no = n.disposal_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_pledge_disposal_cl d
        on
            o.disposal_cd_seq_no = d.disposal_cd_seq_no
            and o.disposal_seq_no = d.disposal_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_pledge_disposal;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_pledge_disposal') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_pledge_disposal drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_pledge_disposal add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_pledge_disposal exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_pledge_disposal_cl;
alter table ${iol_schema}.ncbs_cl_pledge_disposal exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_pledge_disposal_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_pledge_disposal to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_pledge_disposal_op purge;
drop table ${iol_schema}.ncbs_cl_pledge_disposal_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_pledge_disposal_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_pledge_disposal',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
