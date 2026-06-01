/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t2e_acpt_bill
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
create table ${iol_schema}.amls_t2e_acpt_bill_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amls_t2e_acpt_bill;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2e_acpt_bill_op purge;
drop table ${iol_schema}.amls_t2e_acpt_bill_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2e_acpt_bill_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2e_acpt_bill where 0=1;

create table ${iol_schema}.amls_t2e_acpt_bill_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2e_acpt_bill where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2e_acpt_bill_cl(
            acpt_id -- 承兑编号
            ,acct_id -- 账户编号
            ,contract_no -- 合同编号
            ,org_id -- 营业机构
            ,acct_org_id -- 账务机构
            ,subject_id -- 科目编号
            ,bill_seq -- 组内序号
            ,bill_no -- 票据号码
            ,curr_cd -- 币种
            ,bill_amt -- 票面金额
            ,issue_dt -- 出票日期
            ,due_dt -- 到期日期
            ,cust_id -- 出票人客户编号
            ,cust_name -- 出票人客户名称
            ,guar_acct_id -- 保证金账户编号
            ,guar_ratio -- 保证金比例
            ,guar_amt -- 保证金金额
            ,rcv_org_type -- 收款人行号类型
            ,rcv_org_id -- 收款人行号
            ,rcv_org_name -- 收款人行名
            ,rcv_acct_id -- 收款人账户编号
            ,pay_dt -- 付款日期
            ,close_dt -- 核销日期
            ,is_trans -- 是否可转让（参见[字典:AML0095]）
            ,bill_sts -- 票据状态（参见[字典:AML0098]）
            ,bill_opr_id -- 操作员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2e_acpt_bill_op(
            acpt_id -- 承兑编号
            ,acct_id -- 账户编号
            ,contract_no -- 合同编号
            ,org_id -- 营业机构
            ,acct_org_id -- 账务机构
            ,subject_id -- 科目编号
            ,bill_seq -- 组内序号
            ,bill_no -- 票据号码
            ,curr_cd -- 币种
            ,bill_amt -- 票面金额
            ,issue_dt -- 出票日期
            ,due_dt -- 到期日期
            ,cust_id -- 出票人客户编号
            ,cust_name -- 出票人客户名称
            ,guar_acct_id -- 保证金账户编号
            ,guar_ratio -- 保证金比例
            ,guar_amt -- 保证金金额
            ,rcv_org_type -- 收款人行号类型
            ,rcv_org_id -- 收款人行号
            ,rcv_org_name -- 收款人行名
            ,rcv_acct_id -- 收款人账户编号
            ,pay_dt -- 付款日期
            ,close_dt -- 核销日期
            ,is_trans -- 是否可转让（参见[字典:AML0095]）
            ,bill_sts -- 票据状态（参见[字典:AML0098]）
            ,bill_opr_id -- 操作员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acpt_id, o.acpt_id) as acpt_id -- 承兑编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合同编号
    ,nvl(n.org_id, o.org_id) as org_id -- 营业机构
    ,nvl(n.acct_org_id, o.acct_org_id) as acct_org_id -- 账务机构
    ,nvl(n.subject_id, o.subject_id) as subject_id -- 科目编号
    ,nvl(n.bill_seq, o.bill_seq) as bill_seq -- 组内序号
    ,nvl(n.bill_no, o.bill_no) as bill_no -- 票据号码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 票面金额
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 出票日期
    ,nvl(n.due_dt, o.due_dt) as due_dt -- 到期日期
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 出票人客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 出票人客户名称
    ,nvl(n.guar_acct_id, o.guar_acct_id) as guar_acct_id -- 保证金账户编号
    ,nvl(n.guar_ratio, o.guar_ratio) as guar_ratio -- 保证金比例
    ,nvl(n.guar_amt, o.guar_amt) as guar_amt -- 保证金金额
    ,nvl(n.rcv_org_type, o.rcv_org_type) as rcv_org_type -- 收款人行号类型
    ,nvl(n.rcv_org_id, o.rcv_org_id) as rcv_org_id -- 收款人行号
    ,nvl(n.rcv_org_name, o.rcv_org_name) as rcv_org_name -- 收款人行名
    ,nvl(n.rcv_acct_id, o.rcv_acct_id) as rcv_acct_id -- 收款人账户编号
    ,nvl(n.pay_dt, o.pay_dt) as pay_dt -- 付款日期
    ,nvl(n.close_dt, o.close_dt) as close_dt -- 核销日期
    ,nvl(n.is_trans, o.is_trans) as is_trans -- 是否可转让（参见[字典:AML0095]）
    ,nvl(n.bill_sts, o.bill_sts) as bill_sts -- 票据状态（参见[字典:AML0098]）
    ,nvl(n.bill_opr_id, o.bill_opr_id) as bill_opr_id -- 操作员
    ,case when
            n.acpt_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acpt_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acpt_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amls_t2e_acpt_bill_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amls_t2e_acpt_bill where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acpt_id = n.acpt_id
where (
        o.acpt_id is null
    )
    or (
        n.acpt_id is null
    )
    or (
        o.acct_id <> n.acct_id
        or o.contract_no <> n.contract_no
        or o.org_id <> n.org_id
        or o.acct_org_id <> n.acct_org_id
        or o.subject_id <> n.subject_id
        or o.bill_seq <> n.bill_seq
        or o.bill_no <> n.bill_no
        or o.curr_cd <> n.curr_cd
        or o.bill_amt <> n.bill_amt
        or o.issue_dt <> n.issue_dt
        or o.due_dt <> n.due_dt
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.guar_acct_id <> n.guar_acct_id
        or o.guar_ratio <> n.guar_ratio
        or o.guar_amt <> n.guar_amt
        or o.rcv_org_type <> n.rcv_org_type
        or o.rcv_org_id <> n.rcv_org_id
        or o.rcv_org_name <> n.rcv_org_name
        or o.rcv_acct_id <> n.rcv_acct_id
        or o.pay_dt <> n.pay_dt
        or o.close_dt <> n.close_dt
        or o.is_trans <> n.is_trans
        or o.bill_sts <> n.bill_sts
        or o.bill_opr_id <> n.bill_opr_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2e_acpt_bill_cl(
            acpt_id -- 承兑编号
            ,acct_id -- 账户编号
            ,contract_no -- 合同编号
            ,org_id -- 营业机构
            ,acct_org_id -- 账务机构
            ,subject_id -- 科目编号
            ,bill_seq -- 组内序号
            ,bill_no -- 票据号码
            ,curr_cd -- 币种
            ,bill_amt -- 票面金额
            ,issue_dt -- 出票日期
            ,due_dt -- 到期日期
            ,cust_id -- 出票人客户编号
            ,cust_name -- 出票人客户名称
            ,guar_acct_id -- 保证金账户编号
            ,guar_ratio -- 保证金比例
            ,guar_amt -- 保证金金额
            ,rcv_org_type -- 收款人行号类型
            ,rcv_org_id -- 收款人行号
            ,rcv_org_name -- 收款人行名
            ,rcv_acct_id -- 收款人账户编号
            ,pay_dt -- 付款日期
            ,close_dt -- 核销日期
            ,is_trans -- 是否可转让（参见[字典:AML0095]）
            ,bill_sts -- 票据状态（参见[字典:AML0098]）
            ,bill_opr_id -- 操作员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2e_acpt_bill_op(
            acpt_id -- 承兑编号
            ,acct_id -- 账户编号
            ,contract_no -- 合同编号
            ,org_id -- 营业机构
            ,acct_org_id -- 账务机构
            ,subject_id -- 科目编号
            ,bill_seq -- 组内序号
            ,bill_no -- 票据号码
            ,curr_cd -- 币种
            ,bill_amt -- 票面金额
            ,issue_dt -- 出票日期
            ,due_dt -- 到期日期
            ,cust_id -- 出票人客户编号
            ,cust_name -- 出票人客户名称
            ,guar_acct_id -- 保证金账户编号
            ,guar_ratio -- 保证金比例
            ,guar_amt -- 保证金金额
            ,rcv_org_type -- 收款人行号类型
            ,rcv_org_id -- 收款人行号
            ,rcv_org_name -- 收款人行名
            ,rcv_acct_id -- 收款人账户编号
            ,pay_dt -- 付款日期
            ,close_dt -- 核销日期
            ,is_trans -- 是否可转让（参见[字典:AML0095]）
            ,bill_sts -- 票据状态（参见[字典:AML0098]）
            ,bill_opr_id -- 操作员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acpt_id -- 承兑编号
    ,o.acct_id -- 账户编号
    ,o.contract_no -- 合同编号
    ,o.org_id -- 营业机构
    ,o.acct_org_id -- 账务机构
    ,o.subject_id -- 科目编号
    ,o.bill_seq -- 组内序号
    ,o.bill_no -- 票据号码
    ,o.curr_cd -- 币种
    ,o.bill_amt -- 票面金额
    ,o.issue_dt -- 出票日期
    ,o.due_dt -- 到期日期
    ,o.cust_id -- 出票人客户编号
    ,o.cust_name -- 出票人客户名称
    ,o.guar_acct_id -- 保证金账户编号
    ,o.guar_ratio -- 保证金比例
    ,o.guar_amt -- 保证金金额
    ,o.rcv_org_type -- 收款人行号类型
    ,o.rcv_org_id -- 收款人行号
    ,o.rcv_org_name -- 收款人行名
    ,o.rcv_acct_id -- 收款人账户编号
    ,o.pay_dt -- 付款日期
    ,o.close_dt -- 核销日期
    ,o.is_trans -- 是否可转让（参见[字典:AML0095]）
    ,o.bill_sts -- 票据状态（参见[字典:AML0098]）
    ,o.bill_opr_id -- 操作员
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.amls_t2e_acpt_bill_bk o
    left join ${iol_schema}.amls_t2e_acpt_bill_op n
        on
            o.acpt_id = n.acpt_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amls_t2e_acpt_bill_cl d
        on
            o.acpt_id = d.acpt_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.amls_t2e_acpt_bill;

-- 4.2 exchange partition
alter table ${iol_schema}.amls_t2e_acpt_bill exchange partition p_19000101 with table ${iol_schema}.amls_t2e_acpt_bill_cl;
alter table ${iol_schema}.amls_t2e_acpt_bill exchange partition p_20991231 with table ${iol_schema}.amls_t2e_acpt_bill_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t2e_acpt_bill to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2e_acpt_bill_op purge;
drop table ${iol_schema}.amls_t2e_acpt_bill_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amls_t2e_acpt_bill_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t2e_acpt_bill',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
