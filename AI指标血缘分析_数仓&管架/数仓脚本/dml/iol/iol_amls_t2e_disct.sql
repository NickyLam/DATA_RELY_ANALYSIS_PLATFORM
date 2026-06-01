/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t2e_disct
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
create table ${iol_schema}.amls_t2e_disct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amls_t2e_disct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2e_disct_op purge;
drop table ${iol_schema}.amls_t2e_disct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2e_disct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2e_disct where 0=1;

create table ${iol_schema}.amls_t2e_disct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2e_disct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2e_disct_cl(
            dct_id -- 贴现编号
            ,trans_id -- 业务标识号
            ,acct_id -- 贴现账号
            ,dct_dt -- 贴现日期
            ,contract_id -- 主合同号
            ,org_id -- 营业机构
            ,acct_org_id -- 账务机构号
            ,subject_id -- 科目编号
            ,dct_day -- 贴现天数
            ,dct_amt -- 贴现金额
            ,dct_int -- 贴现利息
            ,cust_id -- 持票（贴现）人客户号
            ,cust_name -- 持票（贴现）人客户名称
            ,cust_acct_id -- 持票（贴现）人结算账号
            ,agent_cert_type -- 贴现委托人证件/证明文件类型
            ,agent_cert_no -- 贴现委托人证件号码
            ,agent_name -- 贴现委托人姓名
            ,bill_type -- 票据种类（参见[字典:aml0094]）
            ,bill_seq -- 承兑汇票组内序号
            ,bill_no -- 票据号码
            ,curr_cd -- 票据币种
            ,bill_amt -- 票面金额
            ,bill_bal -- 票面余额
            ,issue_dt -- 票据签发日
            ,due_dt -- 票据到期日
            ,transfer_ind -- 是否可转让（参见[字典:aml0095]）
            ,issue_cust_id -- 出票人客户号
            ,issue_cust_name -- 出票人名称
            ,issue_org_type -- 出票人行号类型
            ,issue_org_id -- 出票人开户行行号
            ,issue_org_name -- 出票人开户行行名
            ,issue_acct_id -- 出票人开户行账号
            ,rcv_cust_id -- 收款人客户号
            ,rcv_cust_name -- 收款人名称
            ,rcv_org_type -- 收款人行号类型
            ,rcv_org_id -- 收款人开户行行号
            ,rcv_org_name -- 收款人开户行行名
            ,rcv_acct_id -- 收款人开户行账号
            ,acpt_org_type -- 承兑行类型（参见[字典:aml0096]）
            ,acpt_org_id -- 承兑行行号
            ,acpt_org_name -- 承兑行行名
            ,bill_sts -- 贴现状态（参见[字典:aml0097]）
            ,bill_opr_id -- 操作柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2e_disct_op(
            dct_id -- 贴现编号
            ,trans_id -- 业务标识号
            ,acct_id -- 贴现账号
            ,dct_dt -- 贴现日期
            ,contract_id -- 主合同号
            ,org_id -- 营业机构
            ,acct_org_id -- 账务机构号
            ,subject_id -- 科目编号
            ,dct_day -- 贴现天数
            ,dct_amt -- 贴现金额
            ,dct_int -- 贴现利息
            ,cust_id -- 持票（贴现）人客户号
            ,cust_name -- 持票（贴现）人客户名称
            ,cust_acct_id -- 持票（贴现）人结算账号
            ,agent_cert_type -- 贴现委托人证件/证明文件类型
            ,agent_cert_no -- 贴现委托人证件号码
            ,agent_name -- 贴现委托人姓名
            ,bill_type -- 票据种类（参见[字典:aml0094]）
            ,bill_seq -- 承兑汇票组内序号
            ,bill_no -- 票据号码
            ,curr_cd -- 票据币种
            ,bill_amt -- 票面金额
            ,bill_bal -- 票面余额
            ,issue_dt -- 票据签发日
            ,due_dt -- 票据到期日
            ,transfer_ind -- 是否可转让（参见[字典:aml0095]）
            ,issue_cust_id -- 出票人客户号
            ,issue_cust_name -- 出票人名称
            ,issue_org_type -- 出票人行号类型
            ,issue_org_id -- 出票人开户行行号
            ,issue_org_name -- 出票人开户行行名
            ,issue_acct_id -- 出票人开户行账号
            ,rcv_cust_id -- 收款人客户号
            ,rcv_cust_name -- 收款人名称
            ,rcv_org_type -- 收款人行号类型
            ,rcv_org_id -- 收款人开户行行号
            ,rcv_org_name -- 收款人开户行行名
            ,rcv_acct_id -- 收款人开户行账号
            ,acpt_org_type -- 承兑行类型（参见[字典:aml0096]）
            ,acpt_org_id -- 承兑行行号
            ,acpt_org_name -- 承兑行行名
            ,bill_sts -- 贴现状态（参见[字典:aml0097]）
            ,bill_opr_id -- 操作柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.dct_id, o.dct_id) as dct_id -- 贴现编号
    ,nvl(n.trans_id, o.trans_id) as trans_id -- 业务标识号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 贴现账号
    ,nvl(n.dct_dt, o.dct_dt) as dct_dt -- 贴现日期
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 主合同号
    ,nvl(n.org_id, o.org_id) as org_id -- 营业机构
    ,nvl(n.acct_org_id, o.acct_org_id) as acct_org_id -- 账务机构号
    ,nvl(n.subject_id, o.subject_id) as subject_id -- 科目编号
    ,nvl(n.dct_day, o.dct_day) as dct_day -- 贴现天数
    ,nvl(n.dct_amt, o.dct_amt) as dct_amt -- 贴现金额
    ,nvl(n.dct_int, o.dct_int) as dct_int -- 贴现利息
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 持票（贴现）人客户号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 持票（贴现）人客户名称
    ,nvl(n.cust_acct_id, o.cust_acct_id) as cust_acct_id -- 持票（贴现）人结算账号
    ,nvl(n.agent_cert_type, o.agent_cert_type) as agent_cert_type -- 贴现委托人证件/证明文件类型
    ,nvl(n.agent_cert_no, o.agent_cert_no) as agent_cert_no -- 贴现委托人证件号码
    ,nvl(n.agent_name, o.agent_name) as agent_name -- 贴现委托人姓名
    ,nvl(n.bill_type, o.bill_type) as bill_type -- 票据种类（参见[字典:aml0094]）
    ,nvl(n.bill_seq, o.bill_seq) as bill_seq -- 承兑汇票组内序号
    ,nvl(n.bill_no, o.bill_no) as bill_no -- 票据号码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 票据币种
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 票面金额
    ,nvl(n.bill_bal, o.bill_bal) as bill_bal -- 票面余额
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 票据签发日
    ,nvl(n.due_dt, o.due_dt) as due_dt -- 票据到期日
    ,nvl(n.transfer_ind, o.transfer_ind) as transfer_ind -- 是否可转让（参见[字典:aml0095]）
    ,nvl(n.issue_cust_id, o.issue_cust_id) as issue_cust_id -- 出票人客户号
    ,nvl(n.issue_cust_name, o.issue_cust_name) as issue_cust_name -- 出票人名称
    ,nvl(n.issue_org_type, o.issue_org_type) as issue_org_type -- 出票人行号类型
    ,nvl(n.issue_org_id, o.issue_org_id) as issue_org_id -- 出票人开户行行号
    ,nvl(n.issue_org_name, o.issue_org_name) as issue_org_name -- 出票人开户行行名
    ,nvl(n.issue_acct_id, o.issue_acct_id) as issue_acct_id -- 出票人开户行账号
    ,nvl(n.rcv_cust_id, o.rcv_cust_id) as rcv_cust_id -- 收款人客户号
    ,nvl(n.rcv_cust_name, o.rcv_cust_name) as rcv_cust_name -- 收款人名称
    ,nvl(n.rcv_org_type, o.rcv_org_type) as rcv_org_type -- 收款人行号类型
    ,nvl(n.rcv_org_id, o.rcv_org_id) as rcv_org_id -- 收款人开户行行号
    ,nvl(n.rcv_org_name, o.rcv_org_name) as rcv_org_name -- 收款人开户行行名
    ,nvl(n.rcv_acct_id, o.rcv_acct_id) as rcv_acct_id -- 收款人开户行账号
    ,nvl(n.acpt_org_type, o.acpt_org_type) as acpt_org_type -- 承兑行类型（参见[字典:aml0096]）
    ,nvl(n.acpt_org_id, o.acpt_org_id) as acpt_org_id -- 承兑行行号
    ,nvl(n.acpt_org_name, o.acpt_org_name) as acpt_org_name -- 承兑行行名
    ,nvl(n.bill_sts, o.bill_sts) as bill_sts -- 贴现状态（参见[字典:aml0097]）
    ,nvl(n.bill_opr_id, o.bill_opr_id) as bill_opr_id -- 操作柜员
    ,case when
            n.dct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.dct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.dct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amls_t2e_disct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amls_t2e_disct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.dct_id = n.dct_id
where (
        o.dct_id is null
    )
    or (
        n.dct_id is null
    )
    or (
        o.trans_id <> n.trans_id
        or o.acct_id <> n.acct_id
        or o.dct_dt <> n.dct_dt
        or o.contract_id <> n.contract_id
        or o.org_id <> n.org_id
        or o.acct_org_id <> n.acct_org_id
        or o.subject_id <> n.subject_id
        or o.dct_day <> n.dct_day
        or o.dct_amt <> n.dct_amt
        or o.dct_int <> n.dct_int
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cust_acct_id <> n.cust_acct_id
        or o.agent_cert_type <> n.agent_cert_type
        or o.agent_cert_no <> n.agent_cert_no
        or o.agent_name <> n.agent_name
        or o.bill_type <> n.bill_type
        or o.bill_seq <> n.bill_seq
        or o.bill_no <> n.bill_no
        or o.curr_cd <> n.curr_cd
        or o.bill_amt <> n.bill_amt
        or o.bill_bal <> n.bill_bal
        or o.issue_dt <> n.issue_dt
        or o.due_dt <> n.due_dt
        or o.transfer_ind <> n.transfer_ind
        or o.issue_cust_id <> n.issue_cust_id
        or o.issue_cust_name <> n.issue_cust_name
        or o.issue_org_type <> n.issue_org_type
        or o.issue_org_id <> n.issue_org_id
        or o.issue_org_name <> n.issue_org_name
        or o.issue_acct_id <> n.issue_acct_id
        or o.rcv_cust_id <> n.rcv_cust_id
        or o.rcv_cust_name <> n.rcv_cust_name
        or o.rcv_org_type <> n.rcv_org_type
        or o.rcv_org_id <> n.rcv_org_id
        or o.rcv_org_name <> n.rcv_org_name
        or o.rcv_acct_id <> n.rcv_acct_id
        or o.acpt_org_type <> n.acpt_org_type
        or o.acpt_org_id <> n.acpt_org_id
        or o.acpt_org_name <> n.acpt_org_name
        or o.bill_sts <> n.bill_sts
        or o.bill_opr_id <> n.bill_opr_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2e_disct_cl(
            dct_id -- 贴现编号
            ,trans_id -- 业务标识号
            ,acct_id -- 贴现账号
            ,dct_dt -- 贴现日期
            ,contract_id -- 主合同号
            ,org_id -- 营业机构
            ,acct_org_id -- 账务机构号
            ,subject_id -- 科目编号
            ,dct_day -- 贴现天数
            ,dct_amt -- 贴现金额
            ,dct_int -- 贴现利息
            ,cust_id -- 持票（贴现）人客户号
            ,cust_name -- 持票（贴现）人客户名称
            ,cust_acct_id -- 持票（贴现）人结算账号
            ,agent_cert_type -- 贴现委托人证件/证明文件类型
            ,agent_cert_no -- 贴现委托人证件号码
            ,agent_name -- 贴现委托人姓名
            ,bill_type -- 票据种类（参见[字典:aml0094]）
            ,bill_seq -- 承兑汇票组内序号
            ,bill_no -- 票据号码
            ,curr_cd -- 票据币种
            ,bill_amt -- 票面金额
            ,bill_bal -- 票面余额
            ,issue_dt -- 票据签发日
            ,due_dt -- 票据到期日
            ,transfer_ind -- 是否可转让（参见[字典:aml0095]）
            ,issue_cust_id -- 出票人客户号
            ,issue_cust_name -- 出票人名称
            ,issue_org_type -- 出票人行号类型
            ,issue_org_id -- 出票人开户行行号
            ,issue_org_name -- 出票人开户行行名
            ,issue_acct_id -- 出票人开户行账号
            ,rcv_cust_id -- 收款人客户号
            ,rcv_cust_name -- 收款人名称
            ,rcv_org_type -- 收款人行号类型
            ,rcv_org_id -- 收款人开户行行号
            ,rcv_org_name -- 收款人开户行行名
            ,rcv_acct_id -- 收款人开户行账号
            ,acpt_org_type -- 承兑行类型（参见[字典:aml0096]）
            ,acpt_org_id -- 承兑行行号
            ,acpt_org_name -- 承兑行行名
            ,bill_sts -- 贴现状态（参见[字典:aml0097]）
            ,bill_opr_id -- 操作柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2e_disct_op(
            dct_id -- 贴现编号
            ,trans_id -- 业务标识号
            ,acct_id -- 贴现账号
            ,dct_dt -- 贴现日期
            ,contract_id -- 主合同号
            ,org_id -- 营业机构
            ,acct_org_id -- 账务机构号
            ,subject_id -- 科目编号
            ,dct_day -- 贴现天数
            ,dct_amt -- 贴现金额
            ,dct_int -- 贴现利息
            ,cust_id -- 持票（贴现）人客户号
            ,cust_name -- 持票（贴现）人客户名称
            ,cust_acct_id -- 持票（贴现）人结算账号
            ,agent_cert_type -- 贴现委托人证件/证明文件类型
            ,agent_cert_no -- 贴现委托人证件号码
            ,agent_name -- 贴现委托人姓名
            ,bill_type -- 票据种类（参见[字典:aml0094]）
            ,bill_seq -- 承兑汇票组内序号
            ,bill_no -- 票据号码
            ,curr_cd -- 票据币种
            ,bill_amt -- 票面金额
            ,bill_bal -- 票面余额
            ,issue_dt -- 票据签发日
            ,due_dt -- 票据到期日
            ,transfer_ind -- 是否可转让（参见[字典:aml0095]）
            ,issue_cust_id -- 出票人客户号
            ,issue_cust_name -- 出票人名称
            ,issue_org_type -- 出票人行号类型
            ,issue_org_id -- 出票人开户行行号
            ,issue_org_name -- 出票人开户行行名
            ,issue_acct_id -- 出票人开户行账号
            ,rcv_cust_id -- 收款人客户号
            ,rcv_cust_name -- 收款人名称
            ,rcv_org_type -- 收款人行号类型
            ,rcv_org_id -- 收款人开户行行号
            ,rcv_org_name -- 收款人开户行行名
            ,rcv_acct_id -- 收款人开户行账号
            ,acpt_org_type -- 承兑行类型（参见[字典:aml0096]）
            ,acpt_org_id -- 承兑行行号
            ,acpt_org_name -- 承兑行行名
            ,bill_sts -- 贴现状态（参见[字典:aml0097]）
            ,bill_opr_id -- 操作柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.dct_id -- 贴现编号
    ,o.trans_id -- 业务标识号
    ,o.acct_id -- 贴现账号
    ,o.dct_dt -- 贴现日期
    ,o.contract_id -- 主合同号
    ,o.org_id -- 营业机构
    ,o.acct_org_id -- 账务机构号
    ,o.subject_id -- 科目编号
    ,o.dct_day -- 贴现天数
    ,o.dct_amt -- 贴现金额
    ,o.dct_int -- 贴现利息
    ,o.cust_id -- 持票（贴现）人客户号
    ,o.cust_name -- 持票（贴现）人客户名称
    ,o.cust_acct_id -- 持票（贴现）人结算账号
    ,o.agent_cert_type -- 贴现委托人证件/证明文件类型
    ,o.agent_cert_no -- 贴现委托人证件号码
    ,o.agent_name -- 贴现委托人姓名
    ,o.bill_type -- 票据种类（参见[字典:aml0094]）
    ,o.bill_seq -- 承兑汇票组内序号
    ,o.bill_no -- 票据号码
    ,o.curr_cd -- 票据币种
    ,o.bill_amt -- 票面金额
    ,o.bill_bal -- 票面余额
    ,o.issue_dt -- 票据签发日
    ,o.due_dt -- 票据到期日
    ,o.transfer_ind -- 是否可转让（参见[字典:aml0095]）
    ,o.issue_cust_id -- 出票人客户号
    ,o.issue_cust_name -- 出票人名称
    ,o.issue_org_type -- 出票人行号类型
    ,o.issue_org_id -- 出票人开户行行号
    ,o.issue_org_name -- 出票人开户行行名
    ,o.issue_acct_id -- 出票人开户行账号
    ,o.rcv_cust_id -- 收款人客户号
    ,o.rcv_cust_name -- 收款人名称
    ,o.rcv_org_type -- 收款人行号类型
    ,o.rcv_org_id -- 收款人开户行行号
    ,o.rcv_org_name -- 收款人开户行行名
    ,o.rcv_acct_id -- 收款人开户行账号
    ,o.acpt_org_type -- 承兑行类型（参见[字典:aml0096]）
    ,o.acpt_org_id -- 承兑行行号
    ,o.acpt_org_name -- 承兑行行名
    ,o.bill_sts -- 贴现状态（参见[字典:aml0097]）
    ,o.bill_opr_id -- 操作柜员
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
from ${iol_schema}.amls_t2e_disct_bk o
    left join ${iol_schema}.amls_t2e_disct_op n
        on
            o.dct_id = n.dct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amls_t2e_disct_cl d
        on
            o.dct_id = d.dct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amls_t2e_disct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amls_t2e_disct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amls_t2e_disct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amls_t2e_disct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amls_t2e_disct exchange partition p_${batch_date} with table ${iol_schema}.amls_t2e_disct_cl;
alter table ${iol_schema}.amls_t2e_disct exchange partition p_20991231 with table ${iol_schema}.amls_t2e_disct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t2e_disct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2e_disct_op purge;
drop table ${iol_schema}.amls_t2e_disct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amls_t2e_disct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t2e_disct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
