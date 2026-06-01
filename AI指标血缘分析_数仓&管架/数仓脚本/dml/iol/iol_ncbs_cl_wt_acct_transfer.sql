/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_wt_acct_transfer
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
create table ${iol_schema}.ncbs_cl_wt_acct_transfer_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_wt_acct_transfer
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_wt_acct_transfer_op purge;
drop table ${iol_schema}.ncbs_cl_wt_acct_transfer_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_wt_acct_transfer_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_wt_acct_transfer where 0=1;

create table ${iol_schema}.ncbs_cl_wt_acct_transfer_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_wt_acct_transfer where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_wt_acct_transfer_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,batch_seq_no -- 批次明细序号
            ,company -- 法人
            ,status -- 状态
            ,status_desc -- 描述信息
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,settle_wtr_acct_ccy -- 委托存款账户币种
            ,settle_wtr_acct_seq_no -- 委托存款账户序列号
            ,settle_wtr_base_acct_no -- 贷款委托账号
            ,settle_wtr_prod_type -- 贷款委托存款账户类型
            ,settle_wts_acct_ccy -- 委托结算账户币种
            ,settle_wts_acct_seq_no -- 委托结算账户序列号
            ,settle_wts_base_acct_no -- 委托结算账户账号
            ,settle_wts_prod_type -- 委托结算账户类型
            ,transfer_amount -- 转账金额
            ,remark -- 备注
            ,res_seq_no -- 限制编号
            ,wt_tran_deal_flow -- 委托转账处理方式（1-解限,2-转账）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_wt_acct_transfer_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,batch_seq_no -- 批次明细序号
            ,company -- 法人
            ,status -- 状态
            ,status_desc -- 描述信息
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,settle_wtr_acct_ccy -- 委托存款账户币种
            ,settle_wtr_acct_seq_no -- 委托存款账户序列号
            ,settle_wtr_base_acct_no -- 贷款委托账号
            ,settle_wtr_prod_type -- 贷款委托存款账户类型
            ,settle_wts_acct_ccy -- 委托结算账户币种
            ,settle_wts_acct_seq_no -- 委托结算账户序列号
            ,settle_wts_base_acct_no -- 委托结算账户账号
            ,settle_wts_prod_type -- 委托结算账户类型
            ,transfer_amount -- 转账金额
            ,remark -- 备注
            ,res_seq_no -- 限制编号
            ,wt_tran_deal_flow -- 委托转账处理方式（1-解限,2-转账）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.dd_no, o.dd_no) as dd_no -- 发放号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.batch_seq_no, o.batch_seq_no) as batch_seq_no -- 批次明细序号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.status_desc, o.status_desc) as status_desc -- 描述信息
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.settle_wtr_acct_ccy, o.settle_wtr_acct_ccy) as settle_wtr_acct_ccy -- 委托存款账户币种
    ,nvl(n.settle_wtr_acct_seq_no, o.settle_wtr_acct_seq_no) as settle_wtr_acct_seq_no -- 委托存款账户序列号
    ,nvl(n.settle_wtr_base_acct_no, o.settle_wtr_base_acct_no) as settle_wtr_base_acct_no -- 贷款委托账号
    ,nvl(n.settle_wtr_prod_type, o.settle_wtr_prod_type) as settle_wtr_prod_type -- 贷款委托存款账户类型
    ,nvl(n.settle_wts_acct_ccy, o.settle_wts_acct_ccy) as settle_wts_acct_ccy -- 委托结算账户币种
    ,nvl(n.settle_wts_acct_seq_no, o.settle_wts_acct_seq_no) as settle_wts_acct_seq_no -- 委托结算账户序列号
    ,nvl(n.settle_wts_base_acct_no, o.settle_wts_base_acct_no) as settle_wts_base_acct_no -- 委托结算账户账号
    ,nvl(n.settle_wts_prod_type, o.settle_wts_prod_type) as settle_wts_prod_type -- 委托结算账户类型
    ,nvl(n.transfer_amount, o.transfer_amount) as transfer_amount -- 转账金额
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.wt_tran_deal_flow, o.wt_tran_deal_flow) as wt_tran_deal_flow -- 委托转账处理方式（1-解限,2-转账）
    ,case when
            n.batch_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.batch_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.batch_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_wt_acct_transfer_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_wt_acct_transfer where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.batch_seq_no = n.batch_seq_no
where (
        o.batch_seq_no is null
    )
    or (
        n.batch_seq_no is null
    )
    or (
        o.branch <> n.branch
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.dd_no <> n.dd_no
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.reference <> n.reference
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.status <> n.status
        or o.status_desc <> n.status_desc
        or o.last_change_date <> n.last_change_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.last_change_user_id <> n.last_change_user_id
        or o.loan_no <> n.loan_no
        or o.settle_wtr_acct_ccy <> n.settle_wtr_acct_ccy
        or o.settle_wtr_acct_seq_no <> n.settle_wtr_acct_seq_no
        or o.settle_wtr_base_acct_no <> n.settle_wtr_base_acct_no
        or o.settle_wtr_prod_type <> n.settle_wtr_prod_type
        or o.settle_wts_acct_ccy <> n.settle_wts_acct_ccy
        or o.settle_wts_acct_seq_no <> n.settle_wts_acct_seq_no
        or o.settle_wts_base_acct_no <> n.settle_wts_base_acct_no
        or o.settle_wts_prod_type <> n.settle_wts_prod_type
        or o.transfer_amount <> n.transfer_amount
        or o.remark <> n.remark
        or o.res_seq_no <> n.res_seq_no
        or o.wt_tran_deal_flow <> n.wt_tran_deal_flow
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_wt_acct_transfer_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,batch_seq_no -- 批次明细序号
            ,company -- 法人
            ,status -- 状态
            ,status_desc -- 描述信息
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,settle_wtr_acct_ccy -- 委托存款账户币种
            ,settle_wtr_acct_seq_no -- 委托存款账户序列号
            ,settle_wtr_base_acct_no -- 贷款委托账号
            ,settle_wtr_prod_type -- 贷款委托存款账户类型
            ,settle_wts_acct_ccy -- 委托结算账户币种
            ,settle_wts_acct_seq_no -- 委托结算账户序列号
            ,settle_wts_base_acct_no -- 委托结算账户账号
            ,settle_wts_prod_type -- 委托结算账户类型
            ,transfer_amount -- 转账金额
            ,remark -- 备注
            ,res_seq_no -- 限制编号
            ,wt_tran_deal_flow -- 委托转账处理方式（1-解限,2-转账）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_wt_acct_transfer_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,batch_seq_no -- 批次明细序号
            ,company -- 法人
            ,status -- 状态
            ,status_desc -- 描述信息
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,settle_wtr_acct_ccy -- 委托存款账户币种
            ,settle_wtr_acct_seq_no -- 委托存款账户序列号
            ,settle_wtr_base_acct_no -- 贷款委托账号
            ,settle_wtr_prod_type -- 贷款委托存款账户类型
            ,settle_wts_acct_ccy -- 委托结算账户币种
            ,settle_wts_acct_seq_no -- 委托结算账户序列号
            ,settle_wts_base_acct_no -- 委托结算账户账号
            ,settle_wts_prod_type -- 委托结算账户类型
            ,transfer_amount -- 转账金额
            ,remark -- 备注
            ,res_seq_no -- 限制编号
            ,wt_tran_deal_flow -- 委托转账处理方式（1-解限,2-转账）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.dd_no -- 发放号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.reference -- 交易参考号
    ,o.user_id -- 交易柜员编号
    ,o.batch_seq_no -- 批次明细序号
    ,o.company -- 法人
    ,o.status -- 状态
    ,o.status_desc -- 描述信息
    ,o.last_change_date -- 最后修改日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.last_change_user_id -- 最后修改柜员
    ,o.loan_no -- 贷款号
    ,o.settle_wtr_acct_ccy -- 委托存款账户币种
    ,o.settle_wtr_acct_seq_no -- 委托存款账户序列号
    ,o.settle_wtr_base_acct_no -- 贷款委托账号
    ,o.settle_wtr_prod_type -- 贷款委托存款账户类型
    ,o.settle_wts_acct_ccy -- 委托结算账户币种
    ,o.settle_wts_acct_seq_no -- 委托结算账户序列号
    ,o.settle_wts_base_acct_no -- 委托结算账户账号
    ,o.settle_wts_prod_type -- 委托结算账户类型
    ,o.transfer_amount -- 转账金额
    ,o.remark -- 备注
    ,o.res_seq_no -- 限制编号
    ,o.wt_tran_deal_flow -- 委托转账处理方式（1-解限,2-转账）
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
from ${iol_schema}.ncbs_cl_wt_acct_transfer_bk o
    left join ${iol_schema}.ncbs_cl_wt_acct_transfer_op n
        on
            o.batch_seq_no = n.batch_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_wt_acct_transfer_cl d
        on
            o.batch_seq_no = d.batch_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_wt_acct_transfer;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_wt_acct_transfer') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_wt_acct_transfer drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_wt_acct_transfer add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_wt_acct_transfer exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_wt_acct_transfer_cl;
alter table ${iol_schema}.ncbs_cl_wt_acct_transfer exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_wt_acct_transfer_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_wt_acct_transfer to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_wt_acct_transfer_op purge;
drop table ${iol_schema}.ncbs_cl_wt_acct_transfer_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_wt_acct_transfer_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_wt_acct_transfer',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
