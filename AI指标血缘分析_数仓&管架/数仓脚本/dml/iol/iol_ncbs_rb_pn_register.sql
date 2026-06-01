/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_pn_register
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
create table ${iol_schema}.ncbs_rb_pn_register_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_pn_register
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_pn_register_op purge;
drop table ${iol_schema}.ncbs_rb_pn_register_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pn_register_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_pn_register where 0=1;

create table ${iol_schema}.ncbs_rb_pn_register_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_pn_register where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_pn_register_cl(
            client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,remark -- 备注
            ,bill_apply_no -- 本票申请书号码
            ,bill_apply_prefix -- 本票申请书前缀
            ,bill_apply_type -- 本票申请书类型
            ,bill_no -- 票据号码
            ,bill_pswd -- 票据密押
            ,bill_status -- 票据状态
            ,bill_type -- 票据种类
            ,company -- 法人
            ,medium_no -- 介质号码
            ,payer_tele -- 收款人联系电话
            ,payment_type -- 兑付方式
            ,serial_no -- 支付流水号
            ,tranfer_cash_flag -- 现转标识
            ,bill_apply_date -- 本票申请书日期
            ,bill_sign_date -- 票据登记日期
            ,last_tran_date -- 最后交易日期
            ,payment_date -- 兑付日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,bill_sign_branch -- 票据签发机构
            ,bill_sign_user_id -- 签发柜员
            ,bill_tran_amt -- 出票金额
            ,payee_acct_ccy -- 收款人账户币种
            ,payee_acct_name -- 收款人名称
            ,payee_acct_seq_no -- 收款人账户序列号
            ,payee_base_acct_no -- 收款人账号
            ,payee_prod_type -- 收款人账户产品类型
            ,payer_acct_ccy -- 付款账户币种
            ,payer_acct_name -- 付款人账户名称
            ,payer_acct_seq_no -- 付款人账户序号
            ,payer_bank_code -- 付款人账户机构
            ,payer_bank_name -- 出票行名称
            ,payer_base_acct_no -- 付款人账号
            ,payer_document_id -- 付款人证件号码
            ,payer_document_type -- 付款人证件类型
            ,payer_prod_type -- 付款人账户产品类型
            ,payment_bank_no -- 兑付行行号
            ,refuse_reason -- 拒绝原因
            ,sign_ccy -- 签发币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_pn_register_op(
            client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,remark -- 备注
            ,bill_apply_no -- 本票申请书号码
            ,bill_apply_prefix -- 本票申请书前缀
            ,bill_apply_type -- 本票申请书类型
            ,bill_no -- 票据号码
            ,bill_pswd -- 票据密押
            ,bill_status -- 票据状态
            ,bill_type -- 票据种类
            ,company -- 法人
            ,medium_no -- 介质号码
            ,payer_tele -- 收款人联系电话
            ,payment_type -- 兑付方式
            ,serial_no -- 支付流水号
            ,tranfer_cash_flag -- 现转标识
            ,bill_apply_date -- 本票申请书日期
            ,bill_sign_date -- 票据登记日期
            ,last_tran_date -- 最后交易日期
            ,payment_date -- 兑付日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,bill_sign_branch -- 票据签发机构
            ,bill_sign_user_id -- 签发柜员
            ,bill_tran_amt -- 出票金额
            ,payee_acct_ccy -- 收款人账户币种
            ,payee_acct_name -- 收款人名称
            ,payee_acct_seq_no -- 收款人账户序列号
            ,payee_base_acct_no -- 收款人账号
            ,payee_prod_type -- 收款人账户产品类型
            ,payer_acct_ccy -- 付款账户币种
            ,payer_acct_name -- 付款人账户名称
            ,payer_acct_seq_no -- 付款人账户序号
            ,payer_bank_code -- 付款人账户机构
            ,payer_bank_name -- 出票行名称
            ,payer_base_acct_no -- 付款人账号
            ,payer_document_id -- 付款人证件号码
            ,payer_document_type -- 付款人证件类型
            ,payer_prod_type -- 付款人账户产品类型
            ,payment_bank_no -- 兑付行行号
            ,refuse_reason -- 拒绝原因
            ,sign_ccy -- 签发币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.bill_apply_no, o.bill_apply_no) as bill_apply_no -- 本票申请书号码
    ,nvl(n.bill_apply_prefix, o.bill_apply_prefix) as bill_apply_prefix -- 本票申请书前缀
    ,nvl(n.bill_apply_type, o.bill_apply_type) as bill_apply_type -- 本票申请书类型
    ,nvl(n.bill_no, o.bill_no) as bill_no -- 票据号码
    ,nvl(n.bill_pswd, o.bill_pswd) as bill_pswd -- 票据密押
    ,nvl(n.bill_status, o.bill_status) as bill_status -- 票据状态
    ,nvl(n.bill_type, o.bill_type) as bill_type -- 票据种类
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.medium_no, o.medium_no) as medium_no -- 介质号码
    ,nvl(n.payer_tele, o.payer_tele) as payer_tele -- 收款人联系电话
    ,nvl(n.payment_type, o.payment_type) as payment_type -- 兑付方式
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 支付流水号
    ,nvl(n.tranfer_cash_flag, o.tranfer_cash_flag) as tranfer_cash_flag -- 现转标识
    ,nvl(n.bill_apply_date, o.bill_apply_date) as bill_apply_date -- 本票申请书日期
    ,nvl(n.bill_sign_date, o.bill_sign_date) as bill_sign_date -- 票据登记日期
    ,nvl(n.last_tran_date, o.last_tran_date) as last_tran_date -- 最后交易日期
    ,nvl(n.payment_date, o.payment_date) as payment_date -- 兑付日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.bill_sign_branch, o.bill_sign_branch) as bill_sign_branch -- 票据签发机构
    ,nvl(n.bill_sign_user_id, o.bill_sign_user_id) as bill_sign_user_id -- 签发柜员
    ,nvl(n.bill_tran_amt, o.bill_tran_amt) as bill_tran_amt -- 出票金额
    ,nvl(n.payee_acct_ccy, o.payee_acct_ccy) as payee_acct_ccy -- 收款人账户币种
    ,nvl(n.payee_acct_name, o.payee_acct_name) as payee_acct_name -- 收款人名称
    ,nvl(n.payee_acct_seq_no, o.payee_acct_seq_no) as payee_acct_seq_no -- 收款人账户序列号
    ,nvl(n.payee_base_acct_no, o.payee_base_acct_no) as payee_base_acct_no -- 收款人账号
    ,nvl(n.payee_prod_type, o.payee_prod_type) as payee_prod_type -- 收款人账户产品类型
    ,nvl(n.payer_acct_ccy, o.payer_acct_ccy) as payer_acct_ccy -- 付款账户币种
    ,nvl(n.payer_acct_name, o.payer_acct_name) as payer_acct_name -- 付款人账户名称
    ,nvl(n.payer_acct_seq_no, o.payer_acct_seq_no) as payer_acct_seq_no -- 付款人账户序号
    ,nvl(n.payer_bank_code, o.payer_bank_code) as payer_bank_code -- 付款人账户机构
    ,nvl(n.payer_bank_name, o.payer_bank_name) as payer_bank_name -- 出票行名称
    ,nvl(n.payer_base_acct_no, o.payer_base_acct_no) as payer_base_acct_no -- 付款人账号
    ,nvl(n.payer_document_id, o.payer_document_id) as payer_document_id -- 付款人证件号码
    ,nvl(n.payer_document_type, o.payer_document_type) as payer_document_type -- 付款人证件类型
    ,nvl(n.payer_prod_type, o.payer_prod_type) as payer_prod_type -- 付款人账户产品类型
    ,nvl(n.payment_bank_no, o.payment_bank_no) as payment_bank_no -- 兑付行行号
    ,nvl(n.refuse_reason, o.refuse_reason) as refuse_reason -- 拒绝原因
    ,nvl(n.sign_ccy, o.sign_ccy) as sign_ccy -- 签发币种
    ,case when
            n.serial_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serial_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serial_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_pn_register_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_pn_register where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serial_no = n.serial_no
where (
        o.serial_no is null
    )
    or (
        n.serial_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.doc_type <> n.doc_type
        or o.remark <> n.remark
        or o.bill_apply_no <> n.bill_apply_no
        or o.bill_apply_prefix <> n.bill_apply_prefix
        or o.bill_apply_type <> n.bill_apply_type
        or o.bill_no <> n.bill_no
        or o.bill_pswd <> n.bill_pswd
        or o.bill_status <> n.bill_status
        or o.bill_type <> n.bill_type
        or o.company <> n.company
        or o.medium_no <> n.medium_no
        or o.payer_tele <> n.payer_tele
        or o.payment_type <> n.payment_type
        or o.tranfer_cash_flag <> n.tranfer_cash_flag
        or o.bill_apply_date <> n.bill_apply_date
        or o.bill_sign_date <> n.bill_sign_date
        or o.last_tran_date <> n.last_tran_date
        or o.payment_date <> n.payment_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.appr_user_id <> n.appr_user_id
        or o.auth_user_id <> n.auth_user_id
        or o.bill_sign_branch <> n.bill_sign_branch
        or o.bill_sign_user_id <> n.bill_sign_user_id
        or o.bill_tran_amt <> n.bill_tran_amt
        or o.payee_acct_ccy <> n.payee_acct_ccy
        or o.payee_acct_name <> n.payee_acct_name
        or o.payee_acct_seq_no <> n.payee_acct_seq_no
        or o.payee_base_acct_no <> n.payee_base_acct_no
        or o.payee_prod_type <> n.payee_prod_type
        or o.payer_acct_ccy <> n.payer_acct_ccy
        or o.payer_acct_name <> n.payer_acct_name
        or o.payer_acct_seq_no <> n.payer_acct_seq_no
        or o.payer_bank_code <> n.payer_bank_code
        or o.payer_bank_name <> n.payer_bank_name
        or o.payer_base_acct_no <> n.payer_base_acct_no
        or o.payer_document_id <> n.payer_document_id
        or o.payer_document_type <> n.payer_document_type
        or o.payer_prod_type <> n.payer_prod_type
        or o.payment_bank_no <> n.payment_bank_no
        or o.refuse_reason <> n.refuse_reason
        or o.sign_ccy <> n.sign_ccy
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_pn_register_cl(
            client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,remark -- 备注
            ,bill_apply_no -- 本票申请书号码
            ,bill_apply_prefix -- 本票申请书前缀
            ,bill_apply_type -- 本票申请书类型
            ,bill_no -- 票据号码
            ,bill_pswd -- 票据密押
            ,bill_status -- 票据状态
            ,bill_type -- 票据种类
            ,company -- 法人
            ,medium_no -- 介质号码
            ,payer_tele -- 收款人联系电话
            ,payment_type -- 兑付方式
            ,serial_no -- 支付流水号
            ,tranfer_cash_flag -- 现转标识
            ,bill_apply_date -- 本票申请书日期
            ,bill_sign_date -- 票据登记日期
            ,last_tran_date -- 最后交易日期
            ,payment_date -- 兑付日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,bill_sign_branch -- 票据签发机构
            ,bill_sign_user_id -- 签发柜员
            ,bill_tran_amt -- 出票金额
            ,payee_acct_ccy -- 收款人账户币种
            ,payee_acct_name -- 收款人名称
            ,payee_acct_seq_no -- 收款人账户序列号
            ,payee_base_acct_no -- 收款人账号
            ,payee_prod_type -- 收款人账户产品类型
            ,payer_acct_ccy -- 付款账户币种
            ,payer_acct_name -- 付款人账户名称
            ,payer_acct_seq_no -- 付款人账户序号
            ,payer_bank_code -- 付款人账户机构
            ,payer_bank_name -- 出票行名称
            ,payer_base_acct_no -- 付款人账号
            ,payer_document_id -- 付款人证件号码
            ,payer_document_type -- 付款人证件类型
            ,payer_prod_type -- 付款人账户产品类型
            ,payment_bank_no -- 兑付行行号
            ,refuse_reason -- 拒绝原因
            ,sign_ccy -- 签发币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_pn_register_op(
            client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,remark -- 备注
            ,bill_apply_no -- 本票申请书号码
            ,bill_apply_prefix -- 本票申请书前缀
            ,bill_apply_type -- 本票申请书类型
            ,bill_no -- 票据号码
            ,bill_pswd -- 票据密押
            ,bill_status -- 票据状态
            ,bill_type -- 票据种类
            ,company -- 法人
            ,medium_no -- 介质号码
            ,payer_tele -- 收款人联系电话
            ,payment_type -- 兑付方式
            ,serial_no -- 支付流水号
            ,tranfer_cash_flag -- 现转标识
            ,bill_apply_date -- 本票申请书日期
            ,bill_sign_date -- 票据登记日期
            ,last_tran_date -- 最后交易日期
            ,payment_date -- 兑付日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,bill_sign_branch -- 票据签发机构
            ,bill_sign_user_id -- 签发柜员
            ,bill_tran_amt -- 出票金额
            ,payee_acct_ccy -- 收款人账户币种
            ,payee_acct_name -- 收款人名称
            ,payee_acct_seq_no -- 收款人账户序列号
            ,payee_base_acct_no -- 收款人账号
            ,payee_prod_type -- 收款人账户产品类型
            ,payer_acct_ccy -- 付款账户币种
            ,payer_acct_name -- 付款人账户名称
            ,payer_acct_seq_no -- 付款人账户序号
            ,payer_bank_code -- 付款人账户机构
            ,payer_bank_name -- 出票行名称
            ,payer_base_acct_no -- 付款人账号
            ,payer_document_id -- 付款人证件号码
            ,payer_document_type -- 付款人证件类型
            ,payer_prod_type -- 付款人账户产品类型
            ,payment_bank_no -- 兑付行行号
            ,refuse_reason -- 拒绝原因
            ,sign_ccy -- 签发币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.doc_type -- 凭证类型
    ,o.remark -- 备注
    ,o.bill_apply_no -- 本票申请书号码
    ,o.bill_apply_prefix -- 本票申请书前缀
    ,o.bill_apply_type -- 本票申请书类型
    ,o.bill_no -- 票据号码
    ,o.bill_pswd -- 票据密押
    ,o.bill_status -- 票据状态
    ,o.bill_type -- 票据种类
    ,o.company -- 法人
    ,o.medium_no -- 介质号码
    ,o.payer_tele -- 收款人联系电话
    ,o.payment_type -- 兑付方式
    ,o.serial_no -- 支付流水号
    ,o.tranfer_cash_flag -- 现转标识
    ,o.bill_apply_date -- 本票申请书日期
    ,o.bill_sign_date -- 票据登记日期
    ,o.last_tran_date -- 最后交易日期
    ,o.payment_date -- 兑付日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.appr_user_id -- 复核柜员
    ,o.auth_user_id -- 授权柜员
    ,o.bill_sign_branch -- 票据签发机构
    ,o.bill_sign_user_id -- 签发柜员
    ,o.bill_tran_amt -- 出票金额
    ,o.payee_acct_ccy -- 收款人账户币种
    ,o.payee_acct_name -- 收款人名称
    ,o.payee_acct_seq_no -- 收款人账户序列号
    ,o.payee_base_acct_no -- 收款人账号
    ,o.payee_prod_type -- 收款人账户产品类型
    ,o.payer_acct_ccy -- 付款账户币种
    ,o.payer_acct_name -- 付款人账户名称
    ,o.payer_acct_seq_no -- 付款人账户序号
    ,o.payer_bank_code -- 付款人账户机构
    ,o.payer_bank_name -- 出票行名称
    ,o.payer_base_acct_no -- 付款人账号
    ,o.payer_document_id -- 付款人证件号码
    ,o.payer_document_type -- 付款人证件类型
    ,o.payer_prod_type -- 付款人账户产品类型
    ,o.payment_bank_no -- 兑付行行号
    ,o.refuse_reason -- 拒绝原因
    ,o.sign_ccy -- 签发币种
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
from ${iol_schema}.ncbs_rb_pn_register_bk o
    left join ${iol_schema}.ncbs_rb_pn_register_op n
        on
            o.serial_no = n.serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_pn_register_cl d
        on
            o.serial_no = d.serial_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_pn_register;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_pn_register') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_pn_register drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_pn_register add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_pn_register exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_pn_register_cl;
alter table ${iol_schema}.ncbs_rb_pn_register exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_pn_register_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_pn_register to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_pn_register_op purge;
drop table ${iol_schema}.ncbs_rb_pn_register_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_pn_register_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_pn_register',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
