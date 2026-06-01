/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_ac_status_info_sum
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
create table ${iol_schema}.ncbs_cl_ac_status_info_sum_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_ac_status_info_sum
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_ac_status_info_sum_op purge;
drop table ${iol_schema}.ncbs_cl_ac_status_info_sum_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_ac_status_info_sum_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_ac_status_info_sum where 0=1;

create table ${iol_schema}.ncbs_cl_ac_status_info_sum_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_ac_status_info_sum where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_ac_status_info_sum_cl(
            acct_status -- 账户状态
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,contract_no -- 合同编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,profit_center -- 利润中心
            ,acct_status_prev -- 账户上一状态
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,sched_mode -- 还款方式
            ,system_id -- 系统id
            ,tran_category -- 交易种类
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,maturity_date -- 到期日期
            ,acct_branch -- 开户机构编号
            ,busi_prod -- 业务产品
            ,contract_amt -- 合同金额
            ,gprd_amt -- 宽限期本金
            ,int_basis_rate -- 基准利率
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,osl_amt -- 客户未到期本金
            ,prd_amt -- 逾期本金
            ,real_rate -- 执行利率
            ,rem_amt -- 剩余本金
            ,cl_acct_change_type -- 贷款分户变更类型
            ,clean_status -- 结清标志
            ,clean_status_upd_date -- 结清状态变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_ac_status_info_sum_op(
            acct_status -- 账户状态
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,contract_no -- 合同编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,profit_center -- 利润中心
            ,acct_status_prev -- 账户上一状态
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,sched_mode -- 还款方式
            ,system_id -- 系统id
            ,tran_category -- 交易种类
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,maturity_date -- 到期日期
            ,acct_branch -- 开户机构编号
            ,busi_prod -- 业务产品
            ,contract_amt -- 合同金额
            ,gprd_amt -- 宽限期本金
            ,int_basis_rate -- 基准利率
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,osl_amt -- 客户未到期本金
            ,prd_amt -- 逾期本金
            ,real_rate -- 执行利率
            ,rem_amt -- 剩余本金
            ,cl_acct_change_type -- 贷款分户变更类型
            ,clean_status -- 结清标志
            ,clean_status_upd_date -- 结清状态变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合同编号
    ,nvl(n.dd_no, o.dd_no) as dd_no -- 发放号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.profit_center, o.profit_center) as profit_center -- 利润中心
    ,nvl(n.acct_status_prev, o.acct_status_prev) as acct_status_prev -- 账户上一状态
    ,nvl(n.cmisloan_no, o.cmisloan_no) as cmisloan_no -- 客户借据编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.sched_mode, o.sched_mode) as sched_mode -- 还款方式
    ,nvl(n.system_id, o.system_id) as system_id -- 系统id
    ,nvl(n.tran_category, o.tran_category) as tran_category -- 交易种类
    ,nvl(n.accounting_status, o.accounting_status) as accounting_status -- 核算状态
    ,nvl(n.accounting_status_prev, o.accounting_status_prev) as accounting_status_prev -- 上次核算状态
    ,nvl(n.accounting_status_upd_date, o.accounting_status_upd_date) as accounting_status_upd_date -- 核算状态变更日期
    ,nvl(n.acct_open_date, o.acct_open_date) as acct_open_date -- 账户开户日期
    ,nvl(n.acct_status_upd_date, o.acct_status_upd_date) as acct_status_upd_date -- 账户状态变更日期
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日期
    ,nvl(n.acct_branch, o.acct_branch) as acct_branch -- 开户机构编号
    ,nvl(n.busi_prod, o.busi_prod) as busi_prod -- 业务产品
    ,nvl(n.contract_amt, o.contract_amt) as contract_amt -- 合同金额
    ,nvl(n.gprd_amt, o.gprd_amt) as gprd_amt -- 宽限期本金
    ,nvl(n.int_basis_rate, o.int_basis_rate) as int_basis_rate -- 基准利率
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.marketing_prod, o.marketing_prod) as marketing_prod -- 营销产品
    ,nvl(n.osl_amt, o.osl_amt) as osl_amt -- 客户未到期本金
    ,nvl(n.prd_amt, o.prd_amt) as prd_amt -- 逾期本金
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率
    ,nvl(n.rem_amt, o.rem_amt) as rem_amt -- 剩余本金
    ,nvl(n.cl_acct_change_type, o.cl_acct_change_type) as cl_acct_change_type -- 贷款分户变更类型
    ,nvl(n.clean_status, o.clean_status) as clean_status -- 结清标志
    ,nvl(n.clean_status_upd_date, o.clean_status_upd_date) as clean_status_upd_date -- 结清状态变更日期
    ,case when
            n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_ac_status_info_sum_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_ac_status_info_sum where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.acct_status <> n.acct_status
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.client_type <> n.client_type
        or o.contract_no <> n.contract_no
        or o.dd_no <> n.dd_no
        or o.profit_center <> n.profit_center
        or o.acct_status_prev <> n.acct_status_prev
        or o.cmisloan_no <> n.cmisloan_no
        or o.company <> n.company
        or o.sched_mode <> n.sched_mode
        or o.system_id <> n.system_id
        or o.tran_category <> n.tran_category
        or o.accounting_status <> n.accounting_status
        or o.accounting_status_prev <> n.accounting_status_prev
        or o.accounting_status_upd_date <> n.accounting_status_upd_date
        or o.acct_open_date <> n.acct_open_date
        or o.acct_status_upd_date <> n.acct_status_upd_date
        or o.maturity_date <> n.maturity_date
        or o.acct_branch <> n.acct_branch
        or o.busi_prod <> n.busi_prod
        or o.contract_amt <> n.contract_amt
        or o.gprd_amt <> n.gprd_amt
        or o.int_basis_rate <> n.int_basis_rate
        or o.loan_no <> n.loan_no
        or o.marketing_prod <> n.marketing_prod
        or o.osl_amt <> n.osl_amt
        or o.prd_amt <> n.prd_amt
        or o.real_rate <> n.real_rate
        or o.rem_amt <> n.rem_amt
        or o.cl_acct_change_type <> n.cl_acct_change_type
        or o.clean_status <> n.clean_status
        or o.clean_status_upd_date <> n.clean_status_upd_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_ac_status_info_sum_cl(
            acct_status -- 账户状态
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,contract_no -- 合同编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,profit_center -- 利润中心
            ,acct_status_prev -- 账户上一状态
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,sched_mode -- 还款方式
            ,system_id -- 系统id
            ,tran_category -- 交易种类
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,maturity_date -- 到期日期
            ,acct_branch -- 开户机构编号
            ,busi_prod -- 业务产品
            ,contract_amt -- 合同金额
            ,gprd_amt -- 宽限期本金
            ,int_basis_rate -- 基准利率
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,osl_amt -- 客户未到期本金
            ,prd_amt -- 逾期本金
            ,real_rate -- 执行利率
            ,rem_amt -- 剩余本金
            ,cl_acct_change_type -- 贷款分户变更类型
            ,clean_status -- 结清标志
            ,clean_status_upd_date -- 结清状态变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_ac_status_info_sum_op(
            acct_status -- 账户状态
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,contract_no -- 合同编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,profit_center -- 利润中心
            ,acct_status_prev -- 账户上一状态
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,sched_mode -- 还款方式
            ,system_id -- 系统id
            ,tran_category -- 交易种类
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,maturity_date -- 到期日期
            ,acct_branch -- 开户机构编号
            ,busi_prod -- 业务产品
            ,contract_amt -- 合同金额
            ,gprd_amt -- 宽限期本金
            ,int_basis_rate -- 基准利率
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,osl_amt -- 客户未到期本金
            ,prd_amt -- 逾期本金
            ,real_rate -- 执行利率
            ,rem_amt -- 剩余本金
            ,cl_acct_change_type -- 贷款分户变更类型
            ,clean_status -- 结清标志
            ,clean_status_upd_date -- 结清状态变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_status -- 账户状态
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.client_type -- 客户类型
    ,o.contract_no -- 合同编号
    ,o.dd_no -- 发放号
    ,o.internal_key -- 账户内部键值
    ,o.profit_center -- 利润中心
    ,o.acct_status_prev -- 账户上一状态
    ,o.cmisloan_no -- 客户借据编号
    ,o.company -- 法人
    ,o.sched_mode -- 还款方式
    ,o.system_id -- 系统id
    ,o.tran_category -- 交易种类
    ,o.accounting_status -- 核算状态
    ,o.accounting_status_prev -- 上次核算状态
    ,o.accounting_status_upd_date -- 核算状态变更日期
    ,o.acct_open_date -- 账户开户日期
    ,o.acct_status_upd_date -- 账户状态变更日期
    ,o.maturity_date -- 到期日期
    ,o.acct_branch -- 开户机构编号
    ,o.busi_prod -- 业务产品
    ,o.contract_amt -- 合同金额
    ,o.gprd_amt -- 宽限期本金
    ,o.int_basis_rate -- 基准利率
    ,o.loan_no -- 贷款号
    ,o.marketing_prod -- 营销产品
    ,o.osl_amt -- 客户未到期本金
    ,o.prd_amt -- 逾期本金
    ,o.real_rate -- 执行利率
    ,o.rem_amt -- 剩余本金
    ,o.cl_acct_change_type -- 贷款分户变更类型
    ,o.clean_status -- 结清标志
    ,o.clean_status_upd_date -- 结清状态变更日期
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
from ${iol_schema}.ncbs_cl_ac_status_info_sum_bk o
    left join ${iol_schema}.ncbs_cl_ac_status_info_sum_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_ac_status_info_sum_cl d
        on
            o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_ac_status_info_sum;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_ac_status_info_sum') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_ac_status_info_sum drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_ac_status_info_sum add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_ac_status_info_sum exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_ac_status_info_sum_cl;
alter table ${iol_schema}.ncbs_cl_ac_status_info_sum exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_ac_status_info_sum_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_ac_status_info_sum to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_ac_status_info_sum_op purge;
drop table ${iol_schema}.ncbs_cl_ac_status_info_sum_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_ac_status_info_sum_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_ac_status_info_sum',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
