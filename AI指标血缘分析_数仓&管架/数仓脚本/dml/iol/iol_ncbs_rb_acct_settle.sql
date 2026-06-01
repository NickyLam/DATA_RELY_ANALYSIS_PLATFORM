/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_settle
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
create table ${iol_schema}.ncbs_rb_acct_settle_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_acct_settle
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_settle_op purge;
drop table ${iol_schema}.ncbs_rb_acct_settle_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_settle_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_settle where 0=1;

create table ${iol_schema}.ncbs_rb_acct_settle_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_settle where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_settle_cl(
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,auto_blocking -- 自动锁定标志
            ,bank_in_out -- 是否行内行外
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,event_type -- 事件类型
            ,freeze_type -- 受托人账户冻结方式
            ,pay_rec_ind -- 收付款标志
            ,priority -- 优先级
            ,res_seq_no -- 限制编号
            ,self_support_flag -- 是否自营
            ,settle_acct_class -- 结算账户分类
            ,settle_bank_flag -- 资金转移账户银行标识
            ,settle_method -- 结算方法
            ,settle_mobile_phone -- 绑定账户手机号码
            ,settle_no -- 结算编号
            ,settle_weight -- 结算权重
            ,trusted_pay_no -- 受托支付编号
            ,xrate_id -- 汇兑方式
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,payee_bank_code -- 收款人开户行行号
            ,payee_bank_name -- 收款行名称
            ,profit_ratio -- 分润比例
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_internal_key -- 结算账户标志符
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_bank_name -- 清算账号开户行行名
            ,settle_base_acct_no -- 结算账号
            ,settle_branch -- 清算机构
            ,settle_ccy -- 结算币种
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,settle_xrate -- 结算汇率
            ,bind_acct_branch -- 开户银行金融机构编码
            ,create_date -- 创建日期|创建日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_settle_op(
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,auto_blocking -- 自动锁定标志
            ,bank_in_out -- 是否行内行外
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,event_type -- 事件类型
            ,freeze_type -- 受托人账户冻结方式
            ,pay_rec_ind -- 收付款标志
            ,priority -- 优先级
            ,res_seq_no -- 限制编号
            ,self_support_flag -- 是否自营
            ,settle_acct_class -- 结算账户分类
            ,settle_bank_flag -- 资金转移账户银行标识
            ,settle_method -- 结算方法
            ,settle_mobile_phone -- 绑定账户手机号码
            ,settle_no -- 结算编号
            ,settle_weight -- 结算权重
            ,trusted_pay_no -- 受托支付编号
            ,xrate_id -- 汇兑方式
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,payee_bank_code -- 收款人开户行行号
            ,payee_bank_name -- 收款行名称
            ,profit_ratio -- 分润比例
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_internal_key -- 结算账户标志符
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_bank_name -- 清算账号开户行行名
            ,settle_base_acct_no -- 结算账号
            ,settle_branch -- 清算机构
            ,settle_ccy -- 结算币种
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,settle_xrate -- 结算汇率
            ,bind_acct_branch -- 开户银行金融机构编码
            ,create_date -- 创建日期|创建日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amt_type, o.amt_type) as amt_type -- 金额类型
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.auto_blocking, o.auto_blocking) as auto_blocking -- 自动锁定标志
    ,nvl(n.bank_in_out, o.bank_in_out) as bank_in_out -- 是否行内行外
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.dac_value, o.dac_value) as dac_value -- dac值防篡改加密
    ,nvl(n.event_type, o.event_type) as event_type -- 事件类型
    ,nvl(n.freeze_type, o.freeze_type) as freeze_type -- 受托人账户冻结方式
    ,nvl(n.pay_rec_ind, o.pay_rec_ind) as pay_rec_ind -- 收付款标志
    ,nvl(n.priority, o.priority) as priority -- 优先级
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.self_support_flag, o.self_support_flag) as self_support_flag -- 是否自营
    ,nvl(n.settle_acct_class, o.settle_acct_class) as settle_acct_class -- 结算账户分类
    ,nvl(n.settle_bank_flag, o.settle_bank_flag) as settle_bank_flag -- 资金转移账户银行标识
    ,nvl(n.settle_method, o.settle_method) as settle_method -- 结算方法
    ,nvl(n.settle_mobile_phone, o.settle_mobile_phone) as settle_mobile_phone -- 绑定账户手机号码
    ,nvl(n.settle_no, o.settle_no) as settle_no -- 结算编号
    ,nvl(n.settle_weight, o.settle_weight) as settle_weight -- 结算权重
    ,nvl(n.trusted_pay_no, o.trusted_pay_no) as trusted_pay_no -- 受托支付编号
    ,nvl(n.xrate_id, o.xrate_id) as xrate_id -- 汇兑方式
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.payee_bank_code, o.payee_bank_code) as payee_bank_code -- 收款人开户行行号
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 收款行名称
    ,nvl(n.profit_ratio, o.profit_ratio) as profit_ratio -- 分润比例
    ,nvl(n.settle_acct_ccy, o.settle_acct_ccy) as settle_acct_ccy -- 结算账户币种
    ,nvl(n.settle_acct_internal_key, o.settle_acct_internal_key) as settle_acct_internal_key -- 结算账户标志符
    ,nvl(n.settle_acct_name, o.settle_acct_name) as settle_acct_name -- 结算账户户名
    ,nvl(n.settle_acct_seq_no, o.settle_acct_seq_no) as settle_acct_seq_no -- 结算账户序号
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.settle_bank_name, o.settle_bank_name) as settle_bank_name -- 清算账号开户行行名
    ,nvl(n.settle_base_acct_no, o.settle_base_acct_no) as settle_base_acct_no -- 结算账号
    ,nvl(n.settle_branch, o.settle_branch) as settle_branch -- 清算机构
    ,nvl(n.settle_ccy, o.settle_ccy) as settle_ccy -- 结算币种
    ,nvl(n.settle_client, o.settle_client) as settle_client -- 结算客户号
    ,nvl(n.settle_prod_type, o.settle_prod_type) as settle_prod_type -- 结算账户产品类型
    ,nvl(n.settle_xrate, o.settle_xrate) as settle_xrate -- 结算汇率
    ,nvl(n.bind_acct_branch, o.bind_acct_branch) as bind_acct_branch -- 开户银行金融机构编码
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期|创建日期
    ,case when
            n.client_no is null
            and n.internal_key is null
            and n.settle_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.client_no is null
            and n.internal_key is null
            and n.settle_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.client_no is null
            and n.internal_key is null
            and n.settle_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_acct_settle_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_acct_settle where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.client_no = n.client_no
            and o.internal_key = n.internal_key
            and o.settle_no = n.settle_no
where (
        o.client_no is null
        and o.internal_key is null
        and o.settle_no is null
    )
    or (
        n.client_no is null
        and n.internal_key is null
        and n.settle_no is null
    )
    or (
        o.amt_type <> n.amt_type
        or o.reference <> n.reference
        or o.tran_type <> n.tran_type
        or o.user_id <> n.user_id
        or o.auto_blocking <> n.auto_blocking
        or o.bank_in_out <> n.bank_in_out
        or o.company <> n.company
        or o.dac_value <> n.dac_value
        or o.event_type <> n.event_type
        or o.freeze_type <> n.freeze_type
        or o.pay_rec_ind <> n.pay_rec_ind
        or o.priority <> n.priority
        or o.res_seq_no <> n.res_seq_no
        or o.self_support_flag <> n.self_support_flag
        or o.settle_acct_class <> n.settle_acct_class
        or o.settle_bank_flag <> n.settle_bank_flag
        or o.settle_method <> n.settle_method
        or o.settle_mobile_phone <> n.settle_mobile_phone
        or o.settle_weight <> n.settle_weight
        or o.trusted_pay_no <> n.trusted_pay_no
        or o.xrate_id <> n.xrate_id
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.last_change_user_id <> n.last_change_user_id
        or o.payee_bank_code <> n.payee_bank_code
        or o.payee_bank_name <> n.payee_bank_name
        or o.profit_ratio <> n.profit_ratio
        or o.settle_acct_ccy <> n.settle_acct_ccy
        or o.settle_acct_internal_key <> n.settle_acct_internal_key
        or o.settle_acct_name <> n.settle_acct_name
        or o.settle_acct_seq_no <> n.settle_acct_seq_no
        or o.settle_amt <> n.settle_amt
        or o.settle_bank_name <> n.settle_bank_name
        or o.settle_base_acct_no <> n.settle_base_acct_no
        or o.settle_branch <> n.settle_branch
        or o.settle_ccy <> n.settle_ccy
        or o.settle_client <> n.settle_client
        or o.settle_prod_type <> n.settle_prod_type
        or o.settle_xrate <> n.settle_xrate
        or o.bind_acct_branch <> n.bind_acct_branch
        or o.create_date <> n.create_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_settle_cl(
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,auto_blocking -- 自动锁定标志
            ,bank_in_out -- 是否行内行外
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,event_type -- 事件类型
            ,freeze_type -- 受托人账户冻结方式
            ,pay_rec_ind -- 收付款标志
            ,priority -- 优先级
            ,res_seq_no -- 限制编号
            ,self_support_flag -- 是否自营
            ,settle_acct_class -- 结算账户分类
            ,settle_bank_flag -- 资金转移账户银行标识
            ,settle_method -- 结算方法
            ,settle_mobile_phone -- 绑定账户手机号码
            ,settle_no -- 结算编号
            ,settle_weight -- 结算权重
            ,trusted_pay_no -- 受托支付编号
            ,xrate_id -- 汇兑方式
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,payee_bank_code -- 收款人开户行行号
            ,payee_bank_name -- 收款行名称
            ,profit_ratio -- 分润比例
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_internal_key -- 结算账户标志符
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_bank_name -- 清算账号开户行行名
            ,settle_base_acct_no -- 结算账号
            ,settle_branch -- 清算机构
            ,settle_ccy -- 结算币种
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,settle_xrate -- 结算汇率
            ,bind_acct_branch -- 开户银行金融机构编码
            ,create_date -- 创建日期|创建日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_settle_op(
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,auto_blocking -- 自动锁定标志
            ,bank_in_out -- 是否行内行外
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,event_type -- 事件类型
            ,freeze_type -- 受托人账户冻结方式
            ,pay_rec_ind -- 收付款标志
            ,priority -- 优先级
            ,res_seq_no -- 限制编号
            ,self_support_flag -- 是否自营
            ,settle_acct_class -- 结算账户分类
            ,settle_bank_flag -- 资金转移账户银行标识
            ,settle_method -- 结算方法
            ,settle_mobile_phone -- 绑定账户手机号码
            ,settle_no -- 结算编号
            ,settle_weight -- 结算权重
            ,trusted_pay_no -- 受托支付编号
            ,xrate_id -- 汇兑方式
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,payee_bank_code -- 收款人开户行行号
            ,payee_bank_name -- 收款行名称
            ,profit_ratio -- 分润比例
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_internal_key -- 结算账户标志符
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_bank_name -- 清算账号开户行行名
            ,settle_base_acct_no -- 结算账号
            ,settle_branch -- 清算机构
            ,settle_ccy -- 结算币种
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,settle_xrate -- 结算汇率
            ,bind_acct_branch -- 开户银行金融机构编码
            ,create_date -- 创建日期|创建日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amt_type -- 金额类型
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.reference -- 交易参考号
    ,o.tran_type -- 交易类型
    ,o.user_id -- 交易柜员编号
    ,o.auto_blocking -- 自动锁定标志
    ,o.bank_in_out -- 是否行内行外
    ,o.company -- 法人
    ,o.dac_value -- dac值防篡改加密
    ,o.event_type -- 事件类型
    ,o.freeze_type -- 受托人账户冻结方式
    ,o.pay_rec_ind -- 收付款标志
    ,o.priority -- 优先级
    ,o.res_seq_no -- 限制编号
    ,o.self_support_flag -- 是否自营
    ,o.settle_acct_class -- 结算账户分类
    ,o.settle_bank_flag -- 资金转移账户银行标识
    ,o.settle_method -- 结算方法
    ,o.settle_mobile_phone -- 绑定账户手机号码
    ,o.settle_no -- 结算编号
    ,o.settle_weight -- 结算权重
    ,o.trusted_pay_no -- 受托支付编号
    ,o.xrate_id -- 汇兑方式
    ,o.last_change_date -- 最后修改日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.last_change_user_id -- 最后修改柜员
    ,o.payee_bank_code -- 收款人开户行行号
    ,o.payee_bank_name -- 收款行名称
    ,o.profit_ratio -- 分润比例
    ,o.settle_acct_ccy -- 结算账户币种
    ,o.settle_acct_internal_key -- 结算账户标志符
    ,o.settle_acct_name -- 结算账户户名
    ,o.settle_acct_seq_no -- 结算账户序号
    ,o.settle_amt -- 结算金额
    ,o.settle_bank_name -- 清算账号开户行行名
    ,o.settle_base_acct_no -- 结算账号
    ,o.settle_branch -- 清算机构
    ,o.settle_ccy -- 结算币种
    ,o.settle_client -- 结算客户号
    ,o.settle_prod_type -- 结算账户产品类型
    ,o.settle_xrate -- 结算汇率
    ,o.bind_acct_branch -- 开户银行金融机构编码
    ,o.create_date -- 创建日期|创建日期
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
from ${iol_schema}.ncbs_rb_acct_settle_bk o
    left join ${iol_schema}.ncbs_rb_acct_settle_op n
        on
            o.client_no = n.client_no
            and o.internal_key = n.internal_key
            and o.settle_no = n.settle_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_acct_settle_cl d
        on
            o.client_no = d.client_no
            and o.internal_key = d.internal_key
            and o.settle_no = d.settle_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_acct_settle;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_acct_settle') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_acct_settle drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_acct_settle add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_acct_settle exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_settle_cl;
alter table ${iol_schema}.ncbs_rb_acct_settle exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_acct_settle_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_settle to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_settle_op purge;
drop table ${iol_schema}.ncbs_rb_acct_settle_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_acct_settle_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_settle',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
