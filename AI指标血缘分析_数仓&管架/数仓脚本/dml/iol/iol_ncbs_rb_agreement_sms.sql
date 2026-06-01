/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_sms
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
create table ${iol_schema}.ncbs_rb_agreement_sms_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_agreement_sms
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_sms_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_sms_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_sms_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_sms where 0=1;

create table ${iol_schema}.ncbs_rb_agreement_sms_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_sms where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_sms_cl(
            client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,agreement_id -- 协议编号
            ,agreement_level -- 签约级别
            ,company -- 法人
            ,contact_tel -- 客户联系电话
            ,fee_type -- 费率类型
            ,gender_flag -- 适用性别
            ,position -- 职位
            ,take_sign_flag -- 最小金额发送短信标志
            ,sms_open_flag -- 短信开通三位标识符
            ,document_expiry_date -- 证件失效日期
            ,next_charge_date -- 下一收费日期
            ,tran_timestamp -- 交易时间戳
            ,cash_min_amt -- 短信发送最小现金金额
            ,ch_client_name -- 客户中文名称
            ,charge_day -- 收费日
            ,charge_period_freq -- 收费频率
            ,charge_to_base_acct_no -- 收费账号
            ,fee_amt -- 费用金额
            ,take_in_sign_cash -- 转入最小金额（现金）
            ,take_out_sign -- 转出最小金额（转账）
            ,take_out_sign_cash -- 转出最小金额（现金）
            ,tran_min_amt -- 短信发送最小转账金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_sms_op(
            client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,agreement_id -- 协议编号
            ,agreement_level -- 签约级别
            ,company -- 法人
            ,contact_tel -- 客户联系电话
            ,fee_type -- 费率类型
            ,gender_flag -- 适用性别
            ,position -- 职位
            ,take_sign_flag -- 最小金额发送短信标志
            ,sms_open_flag -- 短信开通三位标识符
            ,document_expiry_date -- 证件失效日期
            ,next_charge_date -- 下一收费日期
            ,tran_timestamp -- 交易时间戳
            ,cash_min_amt -- 短信发送最小现金金额
            ,ch_client_name -- 客户中文名称
            ,charge_day -- 收费日
            ,charge_period_freq -- 收费频率
            ,charge_to_base_acct_no -- 收费账号
            ,fee_amt -- 费用金额
            ,take_in_sign_cash -- 转入最小金额（现金）
            ,take_out_sign -- 转出最小金额（转账）
            ,take_out_sign_cash -- 转出最小金额（现金）
            ,tran_min_amt -- 短信发送最小转账金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.agreement_level, o.agreement_level) as agreement_level -- 签约级别
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.contact_tel, o.contact_tel) as contact_tel -- 客户联系电话
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费率类型
    ,nvl(n.gender_flag, o.gender_flag) as gender_flag -- 适用性别
    ,nvl(n.position, o.position) as position -- 职位
    ,nvl(n.take_sign_flag, o.take_sign_flag) as take_sign_flag -- 最小金额发送短信标志
    ,nvl(n.sms_open_flag, o.sms_open_flag) as sms_open_flag -- 短信开通三位标识符
    ,nvl(n.document_expiry_date, o.document_expiry_date) as document_expiry_date -- 证件失效日期
    ,nvl(n.next_charge_date, o.next_charge_date) as next_charge_date -- 下一收费日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.cash_min_amt, o.cash_min_amt) as cash_min_amt -- 短信发送最小现金金额
    ,nvl(n.ch_client_name, o.ch_client_name) as ch_client_name -- 客户中文名称
    ,nvl(n.charge_day, o.charge_day) as charge_day -- 收费日
    ,nvl(n.charge_period_freq, o.charge_period_freq) as charge_period_freq -- 收费频率
    ,nvl(n.charge_to_base_acct_no, o.charge_to_base_acct_no) as charge_to_base_acct_no -- 收费账号
    ,nvl(n.fee_amt, o.fee_amt) as fee_amt -- 费用金额
    ,nvl(n.take_in_sign_cash, o.take_in_sign_cash) as take_in_sign_cash -- 转入最小金额（现金）
    ,nvl(n.take_out_sign, o.take_out_sign) as take_out_sign -- 转出最小金额（转账）
    ,nvl(n.take_out_sign_cash, o.take_out_sign_cash) as take_out_sign_cash -- 转出最小金额（现金）
    ,nvl(n.tran_min_amt, o.tran_min_amt) as tran_min_amt -- 短信发送最小转账金额
    ,case when
            n.agreement_id is null
            and n.contact_tel is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agreement_id is null
            and n.contact_tel is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agreement_id is null
            and n.contact_tel is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_agreement_sms_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_agreement_sms where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agreement_id = n.agreement_id
            and o.contact_tel = n.contact_tel
where (
        o.agreement_id is null
        and o.contact_tel is null
    )
    or (
        n.agreement_id is null
        and n.contact_tel is null
    )
    or (
        o.client_no <> n.client_no
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.internal_key <> n.internal_key
        or o.agreement_level <> n.agreement_level
        or o.company <> n.company
        or o.fee_type <> n.fee_type
        or o.gender_flag <> n.gender_flag
        or o.position <> n.position
        or o.take_sign_flag <> n.take_sign_flag
        or o.sms_open_flag <> n.sms_open_flag
        or o.document_expiry_date <> n.document_expiry_date
        or o.next_charge_date <> n.next_charge_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.cash_min_amt <> n.cash_min_amt
        or o.ch_client_name <> n.ch_client_name
        or o.charge_day <> n.charge_day
        or o.charge_period_freq <> n.charge_period_freq
        or o.charge_to_base_acct_no <> n.charge_to_base_acct_no
        or o.fee_amt <> n.fee_amt
        or o.take_in_sign_cash <> n.take_in_sign_cash
        or o.take_out_sign <> n.take_out_sign
        or o.take_out_sign_cash <> n.take_out_sign_cash
        or o.tran_min_amt <> n.tran_min_amt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_sms_cl(
            client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,agreement_id -- 协议编号
            ,agreement_level -- 签约级别
            ,company -- 法人
            ,contact_tel -- 客户联系电话
            ,fee_type -- 费率类型
            ,gender_flag -- 适用性别
            ,position -- 职位
            ,take_sign_flag -- 最小金额发送短信标志
            ,sms_open_flag -- 短信开通三位标识符
            ,document_expiry_date -- 证件失效日期
            ,next_charge_date -- 下一收费日期
            ,tran_timestamp -- 交易时间戳
            ,cash_min_amt -- 短信发送最小现金金额
            ,ch_client_name -- 客户中文名称
            ,charge_day -- 收费日
            ,charge_period_freq -- 收费频率
            ,charge_to_base_acct_no -- 收费账号
            ,fee_amt -- 费用金额
            ,take_in_sign_cash -- 转入最小金额（现金）
            ,take_out_sign -- 转出最小金额（转账）
            ,take_out_sign_cash -- 转出最小金额（现金）
            ,tran_min_amt -- 短信发送最小转账金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_sms_op(
            client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,agreement_id -- 协议编号
            ,agreement_level -- 签约级别
            ,company -- 法人
            ,contact_tel -- 客户联系电话
            ,fee_type -- 费率类型
            ,gender_flag -- 适用性别
            ,position -- 职位
            ,take_sign_flag -- 最小金额发送短信标志
            ,sms_open_flag -- 短信开通三位标识符
            ,document_expiry_date -- 证件失效日期
            ,next_charge_date -- 下一收费日期
            ,tran_timestamp -- 交易时间戳
            ,cash_min_amt -- 短信发送最小现金金额
            ,ch_client_name -- 客户中文名称
            ,charge_day -- 收费日
            ,charge_period_freq -- 收费频率
            ,charge_to_base_acct_no -- 收费账号
            ,fee_amt -- 费用金额
            ,take_in_sign_cash -- 转入最小金额（现金）
            ,take_out_sign -- 转出最小金额（转账）
            ,take_out_sign_cash -- 转出最小金额（现金）
            ,tran_min_amt -- 短信发送最小转账金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.internal_key -- 账户内部键值
    ,o.agreement_id -- 协议编号
    ,o.agreement_level -- 签约级别
    ,o.company -- 法人
    ,o.contact_tel -- 客户联系电话
    ,o.fee_type -- 费率类型
    ,o.gender_flag -- 适用性别
    ,o.position -- 职位
    ,o.take_sign_flag -- 最小金额发送短信标志
    ,o.sms_open_flag -- 短信开通三位标识符
    ,o.document_expiry_date -- 证件失效日期
    ,o.next_charge_date -- 下一收费日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.cash_min_amt -- 短信发送最小现金金额
    ,o.ch_client_name -- 客户中文名称
    ,o.charge_day -- 收费日
    ,o.charge_period_freq -- 收费频率
    ,o.charge_to_base_acct_no -- 收费账号
    ,o.fee_amt -- 费用金额
    ,o.take_in_sign_cash -- 转入最小金额（现金）
    ,o.take_out_sign -- 转出最小金额（转账）
    ,o.take_out_sign_cash -- 转出最小金额（现金）
    ,o.tran_min_amt -- 短信发送最小转账金额
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
from ${iol_schema}.ncbs_rb_agreement_sms_bk o
    left join ${iol_schema}.ncbs_rb_agreement_sms_op n
        on
            o.agreement_id = n.agreement_id
            and o.contact_tel = n.contact_tel
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_agreement_sms_cl d
        on
            o.agreement_id = d.agreement_id
            and o.contact_tel = d.contact_tel
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_agreement_sms;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_agreement_sms') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_agreement_sms drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_agreement_sms add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_agreement_sms exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agreement_sms_cl;
alter table ${iol_schema}.ncbs_rb_agreement_sms exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_agreement_sms_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agreement_sms to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_sms_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_sms_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_agreement_sms_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agreement_sms',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
