/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_collat_tbl
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
create table ${iol_schema}.ncbs_cl_collat_tbl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_collat_tbl
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_collat_tbl_op purge;
drop table ${iol_schema}.ncbs_cl_collat_tbl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_collat_tbl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_collat_tbl where 0=1;

create table ${iol_schema}.ncbs_cl_collat_tbl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_collat_tbl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_collat_tbl_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,dd_no -- 发放号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,voucher_no -- 凭证号码
            ,coll_ref -- 贷款抵押品编号
            ,collat_name -- 抵押品名称
            ,collat_type -- 抵押品种类
            ,company -- 法人
            ,inner_flag -- 是否本行
            ,narrative -- 摘要
            ,owner -- 抵质押人名称
            ,owner_no -- 权利人客户编号
            ,restraint_seq_no -- 冻结编号
            ,source_type -- 渠道编号
            ,verify_flag -- 是否核实后禁止
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,collat_value -- 押品账面价值
            ,loan_no -- 贷款号
            ,collat_status -- 抵押品状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_collat_tbl_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,dd_no -- 发放号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,voucher_no -- 凭证号码
            ,coll_ref -- 贷款抵押品编号
            ,collat_name -- 抵押品名称
            ,collat_type -- 抵押品种类
            ,company -- 法人
            ,inner_flag -- 是否本行
            ,narrative -- 摘要
            ,owner -- 抵质押人名称
            ,owner_no -- 权利人客户编号
            ,restraint_seq_no -- 冻结编号
            ,source_type -- 渠道编号
            ,verify_flag -- 是否核实后禁止
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,collat_value -- 押品账面价值
            ,loan_no -- 贷款号
            ,collat_status -- 抵押品状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合同编号
    ,nvl(n.dd_no, o.dd_no) as dd_no -- 发放号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.voucher_no, o.voucher_no) as voucher_no -- 凭证号码
    ,nvl(n.coll_ref, o.coll_ref) as coll_ref -- 贷款抵押品编号
    ,nvl(n.collat_name, o.collat_name) as collat_name -- 抵押品名称
    ,nvl(n.collat_type, o.collat_type) as collat_type -- 抵押品种类
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.inner_flag, o.inner_flag) as inner_flag -- 是否本行
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.owner, o.owner) as owner -- 抵质押人名称
    ,nvl(n.owner_no, o.owner_no) as owner_no -- 权利人客户编号
    ,nvl(n.restraint_seq_no, o.restraint_seq_no) as restraint_seq_no -- 冻结编号
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.verify_flag, o.verify_flag) as verify_flag -- 是否核实后禁止
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.collat_value, o.collat_value) as collat_value -- 押品账面价值
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.collat_status, o.collat_status) as collat_status -- 抵押品状态
    ,case when
            n.coll_ref is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.coll_ref is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.coll_ref is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_collat_tbl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_collat_tbl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.coll_ref = n.coll_ref
where (
        o.coll_ref is null
    )
    or (
        n.coll_ref is null
    )
    or (
        o.branch <> n.branch
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.contract_no <> n.contract_no
        or o.dd_no <> n.dd_no
        or o.prod_type <> n.prod_type
        or o.user_id <> n.user_id
        or o.voucher_no <> n.voucher_no
        or o.collat_name <> n.collat_name
        or o.collat_type <> n.collat_type
        or o.company <> n.company
        or o.inner_flag <> n.inner_flag
        or o.narrative <> n.narrative
        or o.owner <> n.owner
        or o.owner_no <> n.owner_no
        or o.restraint_seq_no <> n.restraint_seq_no
        or o.source_type <> n.source_type
        or o.verify_flag <> n.verify_flag
        or o.end_date <> n.end_date
        or o.last_change_date <> n.last_change_date
        or o.start_date <> n.start_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.appr_user_id <> n.appr_user_id
        or o.auth_user_id <> n.auth_user_id
        or o.collat_value <> n.collat_value
        or o.loan_no <> n.loan_no
        or o.collat_status <> n.collat_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_collat_tbl_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,dd_no -- 发放号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,voucher_no -- 凭证号码
            ,coll_ref -- 贷款抵押品编号
            ,collat_name -- 抵押品名称
            ,collat_type -- 抵押品种类
            ,company -- 法人
            ,inner_flag -- 是否本行
            ,narrative -- 摘要
            ,owner -- 抵质押人名称
            ,owner_no -- 权利人客户编号
            ,restraint_seq_no -- 冻结编号
            ,source_type -- 渠道编号
            ,verify_flag -- 是否核实后禁止
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,collat_value -- 押品账面价值
            ,loan_no -- 贷款号
            ,collat_status -- 抵押品状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_collat_tbl_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,dd_no -- 发放号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,voucher_no -- 凭证号码
            ,coll_ref -- 贷款抵押品编号
            ,collat_name -- 抵押品名称
            ,collat_type -- 抵押品种类
            ,company -- 法人
            ,inner_flag -- 是否本行
            ,narrative -- 摘要
            ,owner -- 抵质押人名称
            ,owner_no -- 权利人客户编号
            ,restraint_seq_no -- 冻结编号
            ,source_type -- 渠道编号
            ,verify_flag -- 是否核实后禁止
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,collat_value -- 押品账面价值
            ,loan_no -- 贷款号
            ,collat_status -- 抵押品状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.contract_no -- 合同编号
    ,o.dd_no -- 发放号
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.voucher_no -- 凭证号码
    ,o.coll_ref -- 贷款抵押品编号
    ,o.collat_name -- 抵押品名称
    ,o.collat_type -- 抵押品种类
    ,o.company -- 法人
    ,o.inner_flag -- 是否本行
    ,o.narrative -- 摘要
    ,o.owner -- 抵质押人名称
    ,o.owner_no -- 权利人客户编号
    ,o.restraint_seq_no -- 冻结编号
    ,o.source_type -- 渠道编号
    ,o.verify_flag -- 是否核实后禁止
    ,o.end_date -- 结束日期
    ,o.last_change_date -- 最后修改日期
    ,o.start_date -- 开始日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.appr_user_id -- 复核柜员
    ,o.auth_user_id -- 授权柜员
    ,o.collat_value -- 押品账面价值
    ,o.loan_no -- 贷款号
    ,o.collat_status -- 抵押品状态
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
from ${iol_schema}.ncbs_cl_collat_tbl_bk o
    left join ${iol_schema}.ncbs_cl_collat_tbl_op n
        on
            o.coll_ref = n.coll_ref
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_collat_tbl_cl d
        on
            o.coll_ref = d.coll_ref
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_collat_tbl;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_collat_tbl') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_collat_tbl drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_collat_tbl add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_collat_tbl exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_collat_tbl_cl;
alter table ${iol_schema}.ncbs_cl_collat_tbl exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_collat_tbl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_collat_tbl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_collat_tbl_op purge;
drop table ${iol_schema}.ncbs_cl_collat_tbl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_collat_tbl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_collat_tbl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
