/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_trade_draft
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
create table ${iol_schema}.bdms_bms_trade_draft_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_trade_draft
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_trade_draft_op purge;
drop table ${iol_schema}.bdms_bms_trade_draft_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_trade_draft_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_trade_draft where 0=1;

create table ${iol_schema}.bdms_bms_trade_draft_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_trade_draft where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_trade_draft_cl(
            trade_draft_id -- 记账票据信息表ID
            ,top_branch_no -- 所属总行机构号
            ,trans_branch_no -- 交易机构号
            ,trade_no -- 记账交易号
            ,trade_attr_str -- 交易属性字符串
            ,product_no -- 产品号
            ,in_product_no -- 买入时产品号
            ,contract_id -- 协议ID
            ,protocol_no -- 协议号
            ,detail_id -- 业务明细ID
            ,draft_id -- 票据ID
            ,draft_number -- 票据号
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,payment_date -- 计息到期日
            ,payment_days -- 计息天数
            ,interest -- 利息
            ,adjust_interest -- 调整后利息
            ,draft_amount -- 票面金额
            ,payer_amount -- 买方付息金额
            ,real_amount -- 实收金额
            ,pay_amount -- 实付金额
            ,charge -- 手续费
            ,expenses -- 工本费
            ,amount_reserve1 -- 扩展金额1
            ,amount_reserve2 -- 扩展金额2
            ,amount_reserve3 -- 扩展金额3
            ,request_no -- 交易请求号
            ,trade_seq_no -- 交易流水号
            ,recode -- 接口返回码
            ,restatus -- 接口返回类型： SUCCESS 成功 FAIL 失败 PROCESS 处理中
            ,remessage -- 接口消息
            ,status -- 记账状态： 0 记账失败 1 记账成功 2 记账处理中 3 冲正处理中 4 冲正成功 5 冲正失败
            ,create_time -- 创建时间
            ,update_time -- 创建时间
            ,last_upd_oper_no -- 最后修改操作员号
            ,draft_reserve1 -- 备注1
            ,draft_reserve2 -- 备注2
            ,draft_reserve3 -- 备注3
            ,acct_date -- 会计日期
            ,trans_id -- 登记中心TRANS_ID
            ,bank_seq_no -- 银行核心记账流水号
            ,acct_branch_no -- 账务机构号
            ,bms_draft_id -- 原票据系统的登记中心ID
            ,cd_range -- 子票区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,org_draft_id -- 原始票据ID
            ,split_draft_id -- 实际拆前票据ID
            ,src_type -- 
            ,maturity_date -- 
            ,settle_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_trade_draft_op(
            trade_draft_id -- 记账票据信息表ID
            ,top_branch_no -- 所属总行机构号
            ,trans_branch_no -- 交易机构号
            ,trade_no -- 记账交易号
            ,trade_attr_str -- 交易属性字符串
            ,product_no -- 产品号
            ,in_product_no -- 买入时产品号
            ,contract_id -- 协议ID
            ,protocol_no -- 协议号
            ,detail_id -- 业务明细ID
            ,draft_id -- 票据ID
            ,draft_number -- 票据号
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,payment_date -- 计息到期日
            ,payment_days -- 计息天数
            ,interest -- 利息
            ,adjust_interest -- 调整后利息
            ,draft_amount -- 票面金额
            ,payer_amount -- 买方付息金额
            ,real_amount -- 实收金额
            ,pay_amount -- 实付金额
            ,charge -- 手续费
            ,expenses -- 工本费
            ,amount_reserve1 -- 扩展金额1
            ,amount_reserve2 -- 扩展金额2
            ,amount_reserve3 -- 扩展金额3
            ,request_no -- 交易请求号
            ,trade_seq_no -- 交易流水号
            ,recode -- 接口返回码
            ,restatus -- 接口返回类型： SUCCESS 成功 FAIL 失败 PROCESS 处理中
            ,remessage -- 接口消息
            ,status -- 记账状态： 0 记账失败 1 记账成功 2 记账处理中 3 冲正处理中 4 冲正成功 5 冲正失败
            ,create_time -- 创建时间
            ,update_time -- 创建时间
            ,last_upd_oper_no -- 最后修改操作员号
            ,draft_reserve1 -- 备注1
            ,draft_reserve2 -- 备注2
            ,draft_reserve3 -- 备注3
            ,acct_date -- 会计日期
            ,trans_id -- 登记中心TRANS_ID
            ,bank_seq_no -- 银行核心记账流水号
            ,acct_branch_no -- 账务机构号
            ,bms_draft_id -- 原票据系统的登记中心ID
            ,cd_range -- 子票区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,org_draft_id -- 原始票据ID
            ,split_draft_id -- 实际拆前票据ID
            ,src_type -- 
            ,maturity_date -- 
            ,settle_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trade_draft_id, o.trade_draft_id) as trade_draft_id -- 记账票据信息表ID
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 所属总行机构号
    ,nvl(n.trans_branch_no, o.trans_branch_no) as trans_branch_no -- 交易机构号
    ,nvl(n.trade_no, o.trade_no) as trade_no -- 记账交易号
    ,nvl(n.trade_attr_str, o.trade_attr_str) as trade_attr_str -- 交易属性字符串
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.in_product_no, o.in_product_no) as in_product_no -- 买入时产品号
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 协议ID
    ,nvl(n.protocol_no, o.protocol_no) as protocol_no -- 协议号
    ,nvl(n.detail_id, o.detail_id) as detail_id -- 业务明细ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： 1 银票 2 商票
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据属性： 1 纸票 2 电票
    ,nvl(n.payment_date, o.payment_date) as payment_date -- 计息到期日
    ,nvl(n.payment_days, o.payment_days) as payment_days -- 计息天数
    ,nvl(n.interest, o.interest) as interest -- 利息
    ,nvl(n.adjust_interest, o.adjust_interest) as adjust_interest -- 调整后利息
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票面金额
    ,nvl(n.payer_amount, o.payer_amount) as payer_amount -- 买方付息金额
    ,nvl(n.real_amount, o.real_amount) as real_amount -- 实收金额
    ,nvl(n.pay_amount, o.pay_amount) as pay_amount -- 实付金额
    ,nvl(n.charge, o.charge) as charge -- 手续费
    ,nvl(n.expenses, o.expenses) as expenses -- 工本费
    ,nvl(n.amount_reserve1, o.amount_reserve1) as amount_reserve1 -- 扩展金额1
    ,nvl(n.amount_reserve2, o.amount_reserve2) as amount_reserve2 -- 扩展金额2
    ,nvl(n.amount_reserve3, o.amount_reserve3) as amount_reserve3 -- 扩展金额3
    ,nvl(n.request_no, o.request_no) as request_no -- 交易请求号
    ,nvl(n.trade_seq_no, o.trade_seq_no) as trade_seq_no -- 交易流水号
    ,nvl(n.recode, o.recode) as recode -- 接口返回码
    ,nvl(n.restatus, o.restatus) as restatus -- 接口返回类型： SUCCESS 成功 FAIL 失败 PROCESS 处理中
    ,nvl(n.remessage, o.remessage) as remessage -- 接口消息
    ,nvl(n.status, o.status) as status -- 记账状态： 0 记账失败 1 记账成功 2 记账处理中 3 冲正处理中 4 冲正成功 5 冲正失败
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 创建时间
    ,nvl(n.last_upd_oper_no, o.last_upd_oper_no) as last_upd_oper_no -- 最后修改操作员号
    ,nvl(n.draft_reserve1, o.draft_reserve1) as draft_reserve1 -- 备注1
    ,nvl(n.draft_reserve2, o.draft_reserve2) as draft_reserve2 -- 备注2
    ,nvl(n.draft_reserve3, o.draft_reserve3) as draft_reserve3 -- 备注3
    ,nvl(n.acct_date, o.acct_date) as acct_date -- 会计日期
    ,nvl(n.trans_id, o.trans_id) as trans_id -- 登记中心TRANS_ID
    ,nvl(n.bank_seq_no, o.bank_seq_no) as bank_seq_no -- 银行核心记账流水号
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 账务机构号
    ,nvl(n.bms_draft_id, o.bms_draft_id) as bms_draft_id -- 原票据系统的登记中心ID
    ,nvl(n.cd_range, o.cd_range) as cd_range -- 子票区间
    ,nvl(n.cd_split, o.cd_split) as cd_split -- 是否允许分包流转： 0 否 1 是
    ,nvl(n.org_draft_id, o.org_draft_id) as org_draft_id -- 原始票据ID
    ,nvl(n.split_draft_id, o.split_draft_id) as split_draft_id -- 实际拆前票据ID
    ,nvl(n.src_type, o.src_type) as src_type -- 
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 
    ,case when
            n.trade_draft_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trade_draft_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trade_draft_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_bms_trade_draft_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_trade_draft where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trade_draft_id = n.trade_draft_id
where (
        o.trade_draft_id is null
    )
    or (
        n.trade_draft_id is null
    )
    or (
        o.top_branch_no <> n.top_branch_no
        or o.trans_branch_no <> n.trans_branch_no
        or o.trade_no <> n.trade_no
        or o.trade_attr_str <> n.trade_attr_str
        or o.product_no <> n.product_no
        or o.in_product_no <> n.in_product_no
        or o.contract_id <> n.contract_id
        or o.protocol_no <> n.protocol_no
        or o.detail_id <> n.detail_id
        or o.draft_id <> n.draft_id
        or o.draft_number <> n.draft_number
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.payment_date <> n.payment_date
        or o.payment_days <> n.payment_days
        or o.interest <> n.interest
        or o.adjust_interest <> n.adjust_interest
        or o.draft_amount <> n.draft_amount
        or o.payer_amount <> n.payer_amount
        or o.real_amount <> n.real_amount
        or o.pay_amount <> n.pay_amount
        or o.charge <> n.charge
        or o.expenses <> n.expenses
        or o.amount_reserve1 <> n.amount_reserve1
        or o.amount_reserve2 <> n.amount_reserve2
        or o.amount_reserve3 <> n.amount_reserve3
        or o.request_no <> n.request_no
        or o.trade_seq_no <> n.trade_seq_no
        or o.recode <> n.recode
        or o.restatus <> n.restatus
        or o.remessage <> n.remessage
        or o.status <> n.status
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.last_upd_oper_no <> n.last_upd_oper_no
        or o.draft_reserve1 <> n.draft_reserve1
        or o.draft_reserve2 <> n.draft_reserve2
        or o.draft_reserve3 <> n.draft_reserve3
        or o.acct_date <> n.acct_date
        or o.trans_id <> n.trans_id
        or o.bank_seq_no <> n.bank_seq_no
        or o.acct_branch_no <> n.acct_branch_no
        or o.bms_draft_id <> n.bms_draft_id
        or o.cd_range <> n.cd_range
        or o.cd_split <> n.cd_split
        or o.org_draft_id <> n.org_draft_id
        or o.split_draft_id <> n.split_draft_id
        or o.src_type <> n.src_type
        or o.maturity_date <> n.maturity_date
        or o.settle_status <> n.settle_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_trade_draft_cl(
            trade_draft_id -- 记账票据信息表ID
            ,top_branch_no -- 所属总行机构号
            ,trans_branch_no -- 交易机构号
            ,trade_no -- 记账交易号
            ,trade_attr_str -- 交易属性字符串
            ,product_no -- 产品号
            ,in_product_no -- 买入时产品号
            ,contract_id -- 协议ID
            ,protocol_no -- 协议号
            ,detail_id -- 业务明细ID
            ,draft_id -- 票据ID
            ,draft_number -- 票据号
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,payment_date -- 计息到期日
            ,payment_days -- 计息天数
            ,interest -- 利息
            ,adjust_interest -- 调整后利息
            ,draft_amount -- 票面金额
            ,payer_amount -- 买方付息金额
            ,real_amount -- 实收金额
            ,pay_amount -- 实付金额
            ,charge -- 手续费
            ,expenses -- 工本费
            ,amount_reserve1 -- 扩展金额1
            ,amount_reserve2 -- 扩展金额2
            ,amount_reserve3 -- 扩展金额3
            ,request_no -- 交易请求号
            ,trade_seq_no -- 交易流水号
            ,recode -- 接口返回码
            ,restatus -- 接口返回类型： SUCCESS 成功 FAIL 失败 PROCESS 处理中
            ,remessage -- 接口消息
            ,status -- 记账状态： 0 记账失败 1 记账成功 2 记账处理中 3 冲正处理中 4 冲正成功 5 冲正失败
            ,create_time -- 创建时间
            ,update_time -- 创建时间
            ,last_upd_oper_no -- 最后修改操作员号
            ,draft_reserve1 -- 备注1
            ,draft_reserve2 -- 备注2
            ,draft_reserve3 -- 备注3
            ,acct_date -- 会计日期
            ,trans_id -- 登记中心TRANS_ID
            ,bank_seq_no -- 银行核心记账流水号
            ,acct_branch_no -- 账务机构号
            ,bms_draft_id -- 原票据系统的登记中心ID
            ,cd_range -- 子票区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,org_draft_id -- 原始票据ID
            ,split_draft_id -- 实际拆前票据ID
            ,src_type -- 
            ,maturity_date -- 
            ,settle_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_trade_draft_op(
            trade_draft_id -- 记账票据信息表ID
            ,top_branch_no -- 所属总行机构号
            ,trans_branch_no -- 交易机构号
            ,trade_no -- 记账交易号
            ,trade_attr_str -- 交易属性字符串
            ,product_no -- 产品号
            ,in_product_no -- 买入时产品号
            ,contract_id -- 协议ID
            ,protocol_no -- 协议号
            ,detail_id -- 业务明细ID
            ,draft_id -- 票据ID
            ,draft_number -- 票据号
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,payment_date -- 计息到期日
            ,payment_days -- 计息天数
            ,interest -- 利息
            ,adjust_interest -- 调整后利息
            ,draft_amount -- 票面金额
            ,payer_amount -- 买方付息金额
            ,real_amount -- 实收金额
            ,pay_amount -- 实付金额
            ,charge -- 手续费
            ,expenses -- 工本费
            ,amount_reserve1 -- 扩展金额1
            ,amount_reserve2 -- 扩展金额2
            ,amount_reserve3 -- 扩展金额3
            ,request_no -- 交易请求号
            ,trade_seq_no -- 交易流水号
            ,recode -- 接口返回码
            ,restatus -- 接口返回类型： SUCCESS 成功 FAIL 失败 PROCESS 处理中
            ,remessage -- 接口消息
            ,status -- 记账状态： 0 记账失败 1 记账成功 2 记账处理中 3 冲正处理中 4 冲正成功 5 冲正失败
            ,create_time -- 创建时间
            ,update_time -- 创建时间
            ,last_upd_oper_no -- 最后修改操作员号
            ,draft_reserve1 -- 备注1
            ,draft_reserve2 -- 备注2
            ,draft_reserve3 -- 备注3
            ,acct_date -- 会计日期
            ,trans_id -- 登记中心TRANS_ID
            ,bank_seq_no -- 银行核心记账流水号
            ,acct_branch_no -- 账务机构号
            ,bms_draft_id -- 原票据系统的登记中心ID
            ,cd_range -- 子票区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,org_draft_id -- 原始票据ID
            ,split_draft_id -- 实际拆前票据ID
            ,src_type -- 
            ,maturity_date -- 
            ,settle_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trade_draft_id -- 记账票据信息表ID
    ,o.top_branch_no -- 所属总行机构号
    ,o.trans_branch_no -- 交易机构号
    ,o.trade_no -- 记账交易号
    ,o.trade_attr_str -- 交易属性字符串
    ,o.product_no -- 产品号
    ,o.in_product_no -- 买入时产品号
    ,o.contract_id -- 协议ID
    ,o.protocol_no -- 协议号
    ,o.detail_id -- 业务明细ID
    ,o.draft_id -- 票据ID
    ,o.draft_number -- 票据号
    ,o.draft_type -- 票据类型： 1 银票 2 商票
    ,o.draft_attr -- 票据属性： 1 纸票 2 电票
    ,o.payment_date -- 计息到期日
    ,o.payment_days -- 计息天数
    ,o.interest -- 利息
    ,o.adjust_interest -- 调整后利息
    ,o.draft_amount -- 票面金额
    ,o.payer_amount -- 买方付息金额
    ,o.real_amount -- 实收金额
    ,o.pay_amount -- 实付金额
    ,o.charge -- 手续费
    ,o.expenses -- 工本费
    ,o.amount_reserve1 -- 扩展金额1
    ,o.amount_reserve2 -- 扩展金额2
    ,o.amount_reserve3 -- 扩展金额3
    ,o.request_no -- 交易请求号
    ,o.trade_seq_no -- 交易流水号
    ,o.recode -- 接口返回码
    ,o.restatus -- 接口返回类型： SUCCESS 成功 FAIL 失败 PROCESS 处理中
    ,o.remessage -- 接口消息
    ,o.status -- 记账状态： 0 记账失败 1 记账成功 2 记账处理中 3 冲正处理中 4 冲正成功 5 冲正失败
    ,o.create_time -- 创建时间
    ,o.update_time -- 创建时间
    ,o.last_upd_oper_no -- 最后修改操作员号
    ,o.draft_reserve1 -- 备注1
    ,o.draft_reserve2 -- 备注2
    ,o.draft_reserve3 -- 备注3
    ,o.acct_date -- 会计日期
    ,o.trans_id -- 登记中心TRANS_ID
    ,o.bank_seq_no -- 银行核心记账流水号
    ,o.acct_branch_no -- 账务机构号
    ,o.bms_draft_id -- 原票据系统的登记中心ID
    ,o.cd_range -- 子票区间
    ,o.cd_split -- 是否允许分包流转： 0 否 1 是
    ,o.org_draft_id -- 原始票据ID
    ,o.split_draft_id -- 实际拆前票据ID
    ,o.src_type -- 
    ,o.maturity_date -- 
    ,o.settle_status -- 
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
from ${iol_schema}.bdms_bms_trade_draft_bk o
    left join ${iol_schema}.bdms_bms_trade_draft_op n
        on
            o.trade_draft_id = n.trade_draft_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_trade_draft_cl d
        on
            o.trade_draft_id = d.trade_draft_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_bms_trade_draft;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_trade_draft') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_trade_draft drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_trade_draft add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_trade_draft exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_trade_draft_cl;
alter table ${iol_schema}.bdms_bms_trade_draft exchange partition p_20991231 with table ${iol_schema}.bdms_bms_trade_draft_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_trade_draft to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_trade_draft_op purge;
drop table ${iol_schema}.bdms_bms_trade_draft_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_trade_draft_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_trade_draft',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
