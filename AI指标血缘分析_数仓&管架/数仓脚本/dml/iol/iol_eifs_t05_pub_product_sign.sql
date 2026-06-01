/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t05_pub_product_sign
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
create table ${iol_schema}.eifs_t05_pub_product_sign_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t05_pub_product_sign
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t05_pub_product_sign_op purge;
drop table ${iol_schema}.eifs_t05_pub_product_sign_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t05_pub_product_sign_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t05_pub_product_sign where 0=1;

create table ${iol_schema}.eifs_t05_pub_product_sign_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t05_pub_product_sign where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t05_pub_product_sign_cl(
            sign_contract_id -- 签约id
            ,agreement_id -- 签约编号
            ,agreement_item_seq_id -- 协议项编号
            ,taxpayers_no -- 纳税人编号
            ,cust_type_cd -- 客户类型
            ,account_name -- 户名
            ,suffix -- 后缀
            ,sign_id -- 协议书编号
            ,sp_id -- 第三方机构代码
            ,sp_name -- 第三方机构代码名称
            ,sp_sign_id -- 第三方机构协议号
            ,txn_limit_single -- 单笔交易限额
            ,txn_credit_smy -- 累计发生额
            ,day_limit -- 客户日累计限额
            ,day_actual_amount -- 客户日累计实际金额
            ,day_txn_limit_frequency -- 当日交易发起频率上限
            ,day_txn_actual_frequency -- 当日交易发起实际频率
            ,cup_txn_date -- 银联交易日期
            ,month_limit -- 月累计限额
            ,account_id -- 账户标志号
            ,act_char -- 账户性质
            ,curr_cd -- 币种
            ,last_business_no -- 上一次业务编号
            ,last_business_amount -- 上一次业务金额
            ,last_business_name -- 上一次业务名称
            ,cust_financial_type -- 客户理财类型
            ,last_evaluate_bank -- 上一次评估银行
            ,evaluate_time -- 评估时间
            ,work_unit -- 工作单位
            ,cash_trans_cd -- 钞汇标志
            ,sign_amt -- 客户签约金额
            ,settle_act -- 业务结算账号
            ,sign_speic_payment_acct -- 签约指定还款账号
            ,sign_speic_payment_item -- 签约指定还款名称
            ,sp_fund_act -- 第三方资金账号
            ,sp_entrust_act -- 第三方托管账号
            ,sign_control_ind -- 签约服务控制码
            ,txn_limit -- 交易限额
            ,sign_face -- 面签标志
            ,year_limit -- 年累计限额
            ,txn_times_limit -- 交易笔数限额
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t05_pub_product_sign_op(
            sign_contract_id -- 签约id
            ,agreement_id -- 签约编号
            ,agreement_item_seq_id -- 协议项编号
            ,taxpayers_no -- 纳税人编号
            ,cust_type_cd -- 客户类型
            ,account_name -- 户名
            ,suffix -- 后缀
            ,sign_id -- 协议书编号
            ,sp_id -- 第三方机构代码
            ,sp_name -- 第三方机构代码名称
            ,sp_sign_id -- 第三方机构协议号
            ,txn_limit_single -- 单笔交易限额
            ,txn_credit_smy -- 累计发生额
            ,day_limit -- 客户日累计限额
            ,day_actual_amount -- 客户日累计实际金额
            ,day_txn_limit_frequency -- 当日交易发起频率上限
            ,day_txn_actual_frequency -- 当日交易发起实际频率
            ,cup_txn_date -- 银联交易日期
            ,month_limit -- 月累计限额
            ,account_id -- 账户标志号
            ,act_char -- 账户性质
            ,curr_cd -- 币种
            ,last_business_no -- 上一次业务编号
            ,last_business_amount -- 上一次业务金额
            ,last_business_name -- 上一次业务名称
            ,cust_financial_type -- 客户理财类型
            ,last_evaluate_bank -- 上一次评估银行
            ,evaluate_time -- 评估时间
            ,work_unit -- 工作单位
            ,cash_trans_cd -- 钞汇标志
            ,sign_amt -- 客户签约金额
            ,settle_act -- 业务结算账号
            ,sign_speic_payment_acct -- 签约指定还款账号
            ,sign_speic_payment_item -- 签约指定还款名称
            ,sp_fund_act -- 第三方资金账号
            ,sp_entrust_act -- 第三方托管账号
            ,sign_control_ind -- 签约服务控制码
            ,txn_limit -- 交易限额
            ,sign_face -- 面签标志
            ,year_limit -- 年累计限额
            ,txn_times_limit -- 交易笔数限额
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sign_contract_id, o.sign_contract_id) as sign_contract_id -- 签约id
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 签约编号
    ,nvl(n.agreement_item_seq_id, o.agreement_item_seq_id) as agreement_item_seq_id -- 协议项编号
    ,nvl(n.taxpayers_no, o.taxpayers_no) as taxpayers_no -- 纳税人编号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型
    ,nvl(n.account_name, o.account_name) as account_name -- 户名
    ,nvl(n.suffix, o.suffix) as suffix -- 后缀
    ,nvl(n.sign_id, o.sign_id) as sign_id -- 协议书编号
    ,nvl(n.sp_id, o.sp_id) as sp_id -- 第三方机构代码
    ,nvl(n.sp_name, o.sp_name) as sp_name -- 第三方机构代码名称
    ,nvl(n.sp_sign_id, o.sp_sign_id) as sp_sign_id -- 第三方机构协议号
    ,nvl(n.txn_limit_single, o.txn_limit_single) as txn_limit_single -- 单笔交易限额
    ,nvl(n.txn_credit_smy, o.txn_credit_smy) as txn_credit_smy -- 累计发生额
    ,nvl(n.day_limit, o.day_limit) as day_limit -- 客户日累计限额
    ,nvl(n.day_actual_amount, o.day_actual_amount) as day_actual_amount -- 客户日累计实际金额
    ,nvl(n.day_txn_limit_frequency, o.day_txn_limit_frequency) as day_txn_limit_frequency -- 当日交易发起频率上限
    ,nvl(n.day_txn_actual_frequency, o.day_txn_actual_frequency) as day_txn_actual_frequency -- 当日交易发起实际频率
    ,nvl(n.cup_txn_date, o.cup_txn_date) as cup_txn_date -- 银联交易日期
    ,nvl(n.month_limit, o.month_limit) as month_limit -- 月累计限额
    ,nvl(n.account_id, o.account_id) as account_id -- 账户标志号
    ,nvl(n.act_char, o.act_char) as act_char -- 账户性质
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种
    ,nvl(n.last_business_no, o.last_business_no) as last_business_no -- 上一次业务编号
    ,nvl(n.last_business_amount, o.last_business_amount) as last_business_amount -- 上一次业务金额
    ,nvl(n.last_business_name, o.last_business_name) as last_business_name -- 上一次业务名称
    ,nvl(n.cust_financial_type, o.cust_financial_type) as cust_financial_type -- 客户理财类型
    ,nvl(n.last_evaluate_bank, o.last_evaluate_bank) as last_evaluate_bank -- 上一次评估银行
    ,nvl(n.evaluate_time, o.evaluate_time) as evaluate_time -- 评估时间
    ,nvl(n.work_unit, o.work_unit) as work_unit -- 工作单位
    ,nvl(n.cash_trans_cd, o.cash_trans_cd) as cash_trans_cd -- 钞汇标志
    ,nvl(n.sign_amt, o.sign_amt) as sign_amt -- 客户签约金额
    ,nvl(n.settle_act, o.settle_act) as settle_act -- 业务结算账号
    ,nvl(n.sign_speic_payment_acct, o.sign_speic_payment_acct) as sign_speic_payment_acct -- 签约指定还款账号
    ,nvl(n.sign_speic_payment_item, o.sign_speic_payment_item) as sign_speic_payment_item -- 签约指定还款名称
    ,nvl(n.sp_fund_act, o.sp_fund_act) as sp_fund_act -- 第三方资金账号
    ,nvl(n.sp_entrust_act, o.sp_entrust_act) as sp_entrust_act -- 第三方托管账号
    ,nvl(n.sign_control_ind, o.sign_control_ind) as sign_control_ind -- 签约服务控制码
    ,nvl(n.txn_limit, o.txn_limit) as txn_limit -- 交易限额
    ,nvl(n.sign_face, o.sign_face) as sign_face -- 面签标志
    ,nvl(n.year_limit, o.year_limit) as year_limit -- 年累计限额
    ,nvl(n.txn_times_limit, o.txn_times_limit) as txn_times_limit -- 交易笔数限额
    ,nvl(n.create_te, o.create_te) as create_te -- 创建柜员
    ,nvl(n.create_org, o.create_org) as create_org -- 创建机构号
    ,nvl(n.init_system_id, o.init_system_id) as init_system_id -- 创建渠道
    ,nvl(n.init_created_ts, o.init_created_ts) as init_created_ts -- 源系统创建时间
    ,nvl(n.created_ts, o.created_ts) as created_ts -- 进入ecif的时间
    ,nvl(n.updated_ts, o.updated_ts) as updated_ts -- 在ecif中失效的时间
    ,nvl(n.last_updated_te, o.last_updated_te) as last_updated_te -- 最新更新柜员
    ,nvl(n.last_updated_org, o.last_updated_org) as last_updated_org -- 最新更新机构号
    ,nvl(n.last_system_id, o.last_system_id) as last_system_id -- 最新更新渠道
    ,nvl(n.last_updated_ts, o.last_updated_ts) as last_updated_ts -- 最新更新时间
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号
    ,case when
            n.sign_contract_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sign_contract_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sign_contract_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t05_pub_product_sign_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t05_pub_product_sign where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sign_contract_id = n.sign_contract_id
where (
        o.sign_contract_id is null
    )
    or (
        n.sign_contract_id is null
    )
    or (
        o.agreement_id <> n.agreement_id
        or o.agreement_item_seq_id <> n.agreement_item_seq_id
        or o.taxpayers_no <> n.taxpayers_no
        or o.cust_type_cd <> n.cust_type_cd
        or o.account_name <> n.account_name
        or o.suffix <> n.suffix
        or o.sign_id <> n.sign_id
        or o.sp_id <> n.sp_id
        or o.sp_name <> n.sp_name
        or o.sp_sign_id <> n.sp_sign_id
        or o.txn_limit_single <> n.txn_limit_single
        or o.txn_credit_smy <> n.txn_credit_smy
        or o.day_limit <> n.day_limit
        or o.day_actual_amount <> n.day_actual_amount
        or o.day_txn_limit_frequency <> n.day_txn_limit_frequency
        or o.day_txn_actual_frequency <> n.day_txn_actual_frequency
        or o.cup_txn_date <> n.cup_txn_date
        or o.month_limit <> n.month_limit
        or o.account_id <> n.account_id
        or o.act_char <> n.act_char
        or o.curr_cd <> n.curr_cd
        or o.last_business_no <> n.last_business_no
        or o.last_business_amount <> n.last_business_amount
        or o.last_business_name <> n.last_business_name
        or o.cust_financial_type <> n.cust_financial_type
        or o.last_evaluate_bank <> n.last_evaluate_bank
        or o.evaluate_time <> n.evaluate_time
        or o.work_unit <> n.work_unit
        or o.cash_trans_cd <> n.cash_trans_cd
        or o.sign_amt <> n.sign_amt
        or o.settle_act <> n.settle_act
        or o.sign_speic_payment_acct <> n.sign_speic_payment_acct
        or o.sign_speic_payment_item <> n.sign_speic_payment_item
        or o.sp_fund_act <> n.sp_fund_act
        or o.sp_entrust_act <> n.sp_entrust_act
        or o.sign_control_ind <> n.sign_control_ind
        or o.txn_limit <> n.txn_limit
        or o.sign_face <> n.sign_face
        or o.year_limit <> n.year_limit
        or o.txn_times_limit <> n.txn_times_limit
        or o.create_te <> n.create_te
        or o.create_org <> n.create_org
        or o.init_system_id <> n.init_system_id
        or o.init_created_ts <> n.init_created_ts
        or o.created_ts <> n.created_ts
        or o.updated_ts <> n.updated_ts
        or o.last_updated_te <> n.last_updated_te
        or o.last_updated_org <> n.last_updated_org
        or o.last_system_id <> n.last_system_id
        or o.last_updated_ts <> n.last_updated_ts
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t05_pub_product_sign_cl(
            sign_contract_id -- 签约id
            ,agreement_id -- 签约编号
            ,agreement_item_seq_id -- 协议项编号
            ,taxpayers_no -- 纳税人编号
            ,cust_type_cd -- 客户类型
            ,account_name -- 户名
            ,suffix -- 后缀
            ,sign_id -- 协议书编号
            ,sp_id -- 第三方机构代码
            ,sp_name -- 第三方机构代码名称
            ,sp_sign_id -- 第三方机构协议号
            ,txn_limit_single -- 单笔交易限额
            ,txn_credit_smy -- 累计发生额
            ,day_limit -- 客户日累计限额
            ,day_actual_amount -- 客户日累计实际金额
            ,day_txn_limit_frequency -- 当日交易发起频率上限
            ,day_txn_actual_frequency -- 当日交易发起实际频率
            ,cup_txn_date -- 银联交易日期
            ,month_limit -- 月累计限额
            ,account_id -- 账户标志号
            ,act_char -- 账户性质
            ,curr_cd -- 币种
            ,last_business_no -- 上一次业务编号
            ,last_business_amount -- 上一次业务金额
            ,last_business_name -- 上一次业务名称
            ,cust_financial_type -- 客户理财类型
            ,last_evaluate_bank -- 上一次评估银行
            ,evaluate_time -- 评估时间
            ,work_unit -- 工作单位
            ,cash_trans_cd -- 钞汇标志
            ,sign_amt -- 客户签约金额
            ,settle_act -- 业务结算账号
            ,sign_speic_payment_acct -- 签约指定还款账号
            ,sign_speic_payment_item -- 签约指定还款名称
            ,sp_fund_act -- 第三方资金账号
            ,sp_entrust_act -- 第三方托管账号
            ,sign_control_ind -- 签约服务控制码
            ,txn_limit -- 交易限额
            ,sign_face -- 面签标志
            ,year_limit -- 年累计限额
            ,txn_times_limit -- 交易笔数限额
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t05_pub_product_sign_op(
            sign_contract_id -- 签约id
            ,agreement_id -- 签约编号
            ,agreement_item_seq_id -- 协议项编号
            ,taxpayers_no -- 纳税人编号
            ,cust_type_cd -- 客户类型
            ,account_name -- 户名
            ,suffix -- 后缀
            ,sign_id -- 协议书编号
            ,sp_id -- 第三方机构代码
            ,sp_name -- 第三方机构代码名称
            ,sp_sign_id -- 第三方机构协议号
            ,txn_limit_single -- 单笔交易限额
            ,txn_credit_smy -- 累计发生额
            ,day_limit -- 客户日累计限额
            ,day_actual_amount -- 客户日累计实际金额
            ,day_txn_limit_frequency -- 当日交易发起频率上限
            ,day_txn_actual_frequency -- 当日交易发起实际频率
            ,cup_txn_date -- 银联交易日期
            ,month_limit -- 月累计限额
            ,account_id -- 账户标志号
            ,act_char -- 账户性质
            ,curr_cd -- 币种
            ,last_business_no -- 上一次业务编号
            ,last_business_amount -- 上一次业务金额
            ,last_business_name -- 上一次业务名称
            ,cust_financial_type -- 客户理财类型
            ,last_evaluate_bank -- 上一次评估银行
            ,evaluate_time -- 评估时间
            ,work_unit -- 工作单位
            ,cash_trans_cd -- 钞汇标志
            ,sign_amt -- 客户签约金额
            ,settle_act -- 业务结算账号
            ,sign_speic_payment_acct -- 签约指定还款账号
            ,sign_speic_payment_item -- 签约指定还款名称
            ,sp_fund_act -- 第三方资金账号
            ,sp_entrust_act -- 第三方托管账号
            ,sign_control_ind -- 签约服务控制码
            ,txn_limit -- 交易限额
            ,sign_face -- 面签标志
            ,year_limit -- 年累计限额
            ,txn_times_limit -- 交易笔数限额
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sign_contract_id -- 签约id
    ,o.agreement_id -- 签约编号
    ,o.agreement_item_seq_id -- 协议项编号
    ,o.taxpayers_no -- 纳税人编号
    ,o.cust_type_cd -- 客户类型
    ,o.account_name -- 户名
    ,o.suffix -- 后缀
    ,o.sign_id -- 协议书编号
    ,o.sp_id -- 第三方机构代码
    ,o.sp_name -- 第三方机构代码名称
    ,o.sp_sign_id -- 第三方机构协议号
    ,o.txn_limit_single -- 单笔交易限额
    ,o.txn_credit_smy -- 累计发生额
    ,o.day_limit -- 客户日累计限额
    ,o.day_actual_amount -- 客户日累计实际金额
    ,o.day_txn_limit_frequency -- 当日交易发起频率上限
    ,o.day_txn_actual_frequency -- 当日交易发起实际频率
    ,o.cup_txn_date -- 银联交易日期
    ,o.month_limit -- 月累计限额
    ,o.account_id -- 账户标志号
    ,o.act_char -- 账户性质
    ,o.curr_cd -- 币种
    ,o.last_business_no -- 上一次业务编号
    ,o.last_business_amount -- 上一次业务金额
    ,o.last_business_name -- 上一次业务名称
    ,o.cust_financial_type -- 客户理财类型
    ,o.last_evaluate_bank -- 上一次评估银行
    ,o.evaluate_time -- 评估时间
    ,o.work_unit -- 工作单位
    ,o.cash_trans_cd -- 钞汇标志
    ,o.sign_amt -- 客户签约金额
    ,o.settle_act -- 业务结算账号
    ,o.sign_speic_payment_acct -- 签约指定还款账号
    ,o.sign_speic_payment_item -- 签约指定还款名称
    ,o.sp_fund_act -- 第三方资金账号
    ,o.sp_entrust_act -- 第三方托管账号
    ,o.sign_control_ind -- 签约服务控制码
    ,o.txn_limit -- 交易限额
    ,o.sign_face -- 面签标志
    ,o.year_limit -- 年累计限额
    ,o.txn_times_limit -- 交易笔数限额
    ,o.create_te -- 创建柜员
    ,o.create_org -- 创建机构号
    ,o.init_system_id -- 创建渠道
    ,o.init_created_ts -- 源系统创建时间
    ,o.created_ts -- 进入ecif的时间
    ,o.updated_ts -- 在ecif中失效的时间
    ,o.last_updated_te -- 最新更新柜员
    ,o.last_updated_org -- 最新更新机构号
    ,o.last_system_id -- 最新更新渠道
    ,o.last_updated_ts -- 最新更新时间
    ,o.src_sys_num -- 来源系统编号
    ,o.last_updated_src_sys_num -- 最新更新源系统编号
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
from ${iol_schema}.eifs_t05_pub_product_sign_bk o
    left join ${iol_schema}.eifs_t05_pub_product_sign_op n
        on
            o.sign_contract_id = n.sign_contract_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t05_pub_product_sign_cl d
        on
            o.sign_contract_id = d.sign_contract_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t05_pub_product_sign;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t05_pub_product_sign') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t05_pub_product_sign drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t05_pub_product_sign add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t05_pub_product_sign exchange partition p_${batch_date} with table ${iol_schema}.eifs_t05_pub_product_sign_cl;
alter table ${iol_schema}.eifs_t05_pub_product_sign exchange partition p_20991231 with table ${iol_schema}.eifs_t05_pub_product_sign_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t05_pub_product_sign to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t05_pub_product_sign_op purge;
drop table ${iol_schema}.eifs_t05_pub_product_sign_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t05_pub_product_sign_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t05_pub_product_sign',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
