/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_online_pay_order
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
create table ${iol_schema}.amss_online_pay_order_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_online_pay_order
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_online_pay_order_op purge;
drop table ${iol_schema}.amss_online_pay_order_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_online_pay_order_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_online_pay_order where 0=1;

create table ${iol_schema}.amss_online_pay_order_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_online_pay_order where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_online_pay_order_cl(
            online_pay_order_id -- 网联代付订单表主键
            ,ori_trx_seq -- PPP交易流水号
            ,order_num -- 订单号
            ,mgmt_platf_chn -- 平台渠道号
            ,sign_num -- 协议编号
            ,txn_amt -- 订单金额
            ,txn_status -- 交易状态（0交易失败，1交易成功，2交易未明，3未支付）
            ,txn_time -- 交易时间
            ,payer_acct -- 支付，付款人账号）
            ,payer_name -- 支付，付款人名称）
            ,payer_acct_typ -- 支付，付款人账户类型（DEBIT个人银行借记账户
            ,payer_acct_bcs_typ -- 支付，付款人账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
            ,rcv_acct -- 收款方银行账号
            ,rcv_acct_name -- 收款方账户名称
            ,rcv_acct_typ -- 收款方账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
            ,rcv_acct_bcs_typ -- 收款方账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
            ,create_time -- 创建时间
            ,create_emp -- 创建者
            ,create_user -- 创建人id
            ,update_time -- 更新时间
            ,update_user -- 更新者id
            ,update_emp -- 更新者
            ,physics_flag -- 物理标识，默认1正常，2删除
            ,resp_msg -- PPP返回信息
            ,ori_trx_dt -- 
            ,post_msg -- 附言
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_online_pay_order_op(
            online_pay_order_id -- 网联代付订单表主键
            ,ori_trx_seq -- PPP交易流水号
            ,order_num -- 订单号
            ,mgmt_platf_chn -- 平台渠道号
            ,sign_num -- 协议编号
            ,txn_amt -- 订单金额
            ,txn_status -- 交易状态（0交易失败，1交易成功，2交易未明，3未支付）
            ,txn_time -- 交易时间
            ,payer_acct -- 支付，付款人账号）
            ,payer_name -- 支付，付款人名称）
            ,payer_acct_typ -- 支付，付款人账户类型（DEBIT个人银行借记账户
            ,payer_acct_bcs_typ -- 支付，付款人账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
            ,rcv_acct -- 收款方银行账号
            ,rcv_acct_name -- 收款方账户名称
            ,rcv_acct_typ -- 收款方账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
            ,rcv_acct_bcs_typ -- 收款方账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
            ,create_time -- 创建时间
            ,create_emp -- 创建者
            ,create_user -- 创建人id
            ,update_time -- 更新时间
            ,update_user -- 更新者id
            ,update_emp -- 更新者
            ,physics_flag -- 物理标识，默认1正常，2删除
            ,resp_msg -- PPP返回信息
            ,ori_trx_dt -- 
            ,post_msg -- 附言
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.online_pay_order_id, o.online_pay_order_id) as online_pay_order_id -- 网联代付订单表主键
    ,nvl(n.ori_trx_seq, o.ori_trx_seq) as ori_trx_seq -- PPP交易流水号
    ,nvl(n.order_num, o.order_num) as order_num -- 订单号
    ,nvl(n.mgmt_platf_chn, o.mgmt_platf_chn) as mgmt_platf_chn -- 平台渠道号
    ,nvl(n.sign_num, o.sign_num) as sign_num -- 协议编号
    ,nvl(n.txn_amt, o.txn_amt) as txn_amt -- 订单金额
    ,nvl(n.txn_status, o.txn_status) as txn_status -- 交易状态（0交易失败，1交易成功，2交易未明，3未支付）
    ,nvl(n.txn_time, o.txn_time) as txn_time -- 交易时间
    ,nvl(n.payer_acct, o.payer_acct) as payer_acct -- 支付，付款人账号）
    ,nvl(n.payer_name, o.payer_name) as payer_name -- 支付，付款人名称）
    ,nvl(n.payer_acct_typ, o.payer_acct_typ) as payer_acct_typ -- 支付，付款人账户类型（DEBIT个人银行借记账户
    ,nvl(n.payer_acct_bcs_typ, o.payer_acct_bcs_typ) as payer_acct_bcs_typ -- 支付，付款人账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
    ,nvl(n.rcv_acct, o.rcv_acct) as rcv_acct -- 收款方银行账号
    ,nvl(n.rcv_acct_name, o.rcv_acct_name) as rcv_acct_name -- 收款方账户名称
    ,nvl(n.rcv_acct_typ, o.rcv_acct_typ) as rcv_acct_typ -- 收款方账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
    ,nvl(n.rcv_acct_bcs_typ, o.rcv_acct_bcs_typ) as rcv_acct_bcs_typ -- 收款方账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建者
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人id
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新者id
    ,nvl(n.update_emp, o.update_emp) as update_emp -- 更新者
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理标识，默认1正常，2删除
    ,nvl(n.resp_msg, o.resp_msg) as resp_msg -- PPP返回信息
    ,nvl(n.ori_trx_dt, o.ori_trx_dt) as ori_trx_dt -- 
    ,nvl(n.post_msg, o.post_msg) as post_msg -- 附言
    ,case when
            n.online_pay_order_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.online_pay_order_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.online_pay_order_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_online_pay_order_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_online_pay_order where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.online_pay_order_id = n.online_pay_order_id
where (
        o.online_pay_order_id is null
    )
    or (
        n.online_pay_order_id is null
    )
    or (
        o.ori_trx_seq <> n.ori_trx_seq
        or o.order_num <> n.order_num
        or o.mgmt_platf_chn <> n.mgmt_platf_chn
        or o.sign_num <> n.sign_num
        or o.txn_amt <> n.txn_amt
        or o.txn_status <> n.txn_status
        or o.txn_time <> n.txn_time
        or o.payer_acct <> n.payer_acct
        or o.payer_name <> n.payer_name
        or o.payer_acct_typ <> n.payer_acct_typ
        or o.payer_acct_bcs_typ <> n.payer_acct_bcs_typ
        or o.rcv_acct <> n.rcv_acct
        or o.rcv_acct_name <> n.rcv_acct_name
        or o.rcv_acct_typ <> n.rcv_acct_typ
        or o.rcv_acct_bcs_typ <> n.rcv_acct_bcs_typ
        or o.create_time <> n.create_time
        or o.create_emp <> n.create_emp
        or o.create_user <> n.create_user
        or o.update_time <> n.update_time
        or o.update_user <> n.update_user
        or o.update_emp <> n.update_emp
        or o.physics_flag <> n.physics_flag
        or o.resp_msg <> n.resp_msg
        or o.ori_trx_dt <> n.ori_trx_dt
        or o.post_msg <> n.post_msg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_online_pay_order_cl(
            online_pay_order_id -- 网联代付订单表主键
            ,ori_trx_seq -- PPP交易流水号
            ,order_num -- 订单号
            ,mgmt_platf_chn -- 平台渠道号
            ,sign_num -- 协议编号
            ,txn_amt -- 订单金额
            ,txn_status -- 交易状态（0交易失败，1交易成功，2交易未明，3未支付）
            ,txn_time -- 交易时间
            ,payer_acct -- 支付，付款人账号）
            ,payer_name -- 支付，付款人名称）
            ,payer_acct_typ -- 支付，付款人账户类型（DEBIT个人银行借记账户
            ,payer_acct_bcs_typ -- 支付，付款人账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
            ,rcv_acct -- 收款方银行账号
            ,rcv_acct_name -- 收款方账户名称
            ,rcv_acct_typ -- 收款方账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
            ,rcv_acct_bcs_typ -- 收款方账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
            ,create_time -- 创建时间
            ,create_emp -- 创建者
            ,create_user -- 创建人id
            ,update_time -- 更新时间
            ,update_user -- 更新者id
            ,update_emp -- 更新者
            ,physics_flag -- 物理标识，默认1正常，2删除
            ,resp_msg -- PPP返回信息
            ,ori_trx_dt -- 
            ,post_msg -- 附言
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_online_pay_order_op(
            online_pay_order_id -- 网联代付订单表主键
            ,ori_trx_seq -- PPP交易流水号
            ,order_num -- 订单号
            ,mgmt_platf_chn -- 平台渠道号
            ,sign_num -- 协议编号
            ,txn_amt -- 订单金额
            ,txn_status -- 交易状态（0交易失败，1交易成功，2交易未明，3未支付）
            ,txn_time -- 交易时间
            ,payer_acct -- 支付，付款人账号）
            ,payer_name -- 支付，付款人名称）
            ,payer_acct_typ -- 支付，付款人账户类型（DEBIT个人银行借记账户
            ,payer_acct_bcs_typ -- 支付，付款人账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
            ,rcv_acct -- 收款方银行账号
            ,rcv_acct_name -- 收款方账户名称
            ,rcv_acct_typ -- 收款方账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
            ,rcv_acct_bcs_typ -- 收款方账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
            ,create_time -- 创建时间
            ,create_emp -- 创建者
            ,create_user -- 创建人id
            ,update_time -- 更新时间
            ,update_user -- 更新者id
            ,update_emp -- 更新者
            ,physics_flag -- 物理标识，默认1正常，2删除
            ,resp_msg -- PPP返回信息
            ,ori_trx_dt -- 
            ,post_msg -- 附言
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.online_pay_order_id -- 网联代付订单表主键
    ,o.ori_trx_seq -- PPP交易流水号
    ,o.order_num -- 订单号
    ,o.mgmt_platf_chn -- 平台渠道号
    ,o.sign_num -- 协议编号
    ,o.txn_amt -- 订单金额
    ,o.txn_status -- 交易状态（0交易失败，1交易成功，2交易未明，3未支付）
    ,o.txn_time -- 交易时间
    ,o.payer_acct -- 支付，付款人账号）
    ,o.payer_name -- 支付，付款人名称）
    ,o.payer_acct_typ -- 支付，付款人账户类型（DEBIT个人银行借记账户
    ,o.payer_acct_bcs_typ -- 支付，付款人账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
    ,o.rcv_acct -- 收款方银行账号
    ,o.rcv_acct_name -- 收款方账户名称
    ,o.rcv_acct_typ -- 收款方账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
    ,o.rcv_acct_bcs_typ -- 收款方账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
    ,o.create_time -- 创建时间
    ,o.create_emp -- 创建者
    ,o.create_user -- 创建人id
    ,o.update_time -- 更新时间
    ,o.update_user -- 更新者id
    ,o.update_emp -- 更新者
    ,o.physics_flag -- 物理标识，默认1正常，2删除
    ,o.resp_msg -- PPP返回信息
    ,o.ori_trx_dt -- 
    ,o.post_msg -- 附言
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
from ${iol_schema}.amss_online_pay_order_bk o
    left join ${iol_schema}.amss_online_pay_order_op n
        on
            o.online_pay_order_id = n.online_pay_order_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_online_pay_order_cl d
        on
            o.online_pay_order_id = d.online_pay_order_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_online_pay_order;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_online_pay_order') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_online_pay_order drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_online_pay_order add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_online_pay_order exchange partition p_${batch_date} with table ${iol_schema}.amss_online_pay_order_cl;
alter table ${iol_schema}.amss_online_pay_order exchange partition p_20991231 with table ${iol_schema}.amss_online_pay_order_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_online_pay_order to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_online_pay_order_op purge;
drop table ${iol_schema}.amss_online_pay_order_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_online_pay_order_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_online_pay_order',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
