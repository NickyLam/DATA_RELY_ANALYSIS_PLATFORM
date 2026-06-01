/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbshare0
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
create table ${iol_schema}.nfss_tbshare0_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbshare0;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbshare0_op purge;
drop table ${iol_schema}.nfss_tbshare0_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbshare0_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbshare0 where 0=1;

create table ${iol_schema}.nfss_tbshare0_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbshare0 where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbshare0_cl(
            in_client_no -- 内部客户编号
            ,seller_code -- 销售商代码
            ,bank_no -- 银行编号
            ,client_no -- 银行客户号
            ,bank_acc -- 银行账号
            ,ta_client -- TA交易帐号
            ,cash_flag -- 钞汇标志
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,ta_code -- TA代码
            ,asset_acc -- 理财帐号
            ,prd_code -- 产品代码
            ,contract_no -- 合约编号
            ,last_date -- 最后变动日期
            ,tot_vol -- 份额总数
            ,frozen_vol -- 交易冻结份额
            ,long_frozen_vol -- 长期冻结份额
            ,group_vol -- 组合投资份额
            ,div_mode -- 当前分红方式
            ,old_div_mode -- 原分红方式
            ,div_rate -- 红利比例
            ,ystdy_tot_vol -- 昨日总份额
            ,open_branch -- 份额所属机构
            ,client_type -- 客户类别
            ,append_flag -- 追加投资标志
            ,other_frozen -- 本地冻结份额
            ,income -- 本期收益
            ,income_rate -- 收益客户比例
            ,cost -- 买入成本
            ,tot_income -- 累计收入
            ,income_onway -- 未付收益#
            ,income_frozen -- 冻结的未付收益#
            ,income_new -- 当天新分配收益#
            ,manage_agio -- 管理费折扣率#
            ,tot_manage_fee -- 管理费总额#
            ,manage_fee -- 最新结转管理费#
            ,manage_date -- 管理费计算日期#
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,reserve3 -- 备用3
            ,reserve4 -- 备用4
            ,reserve5 -- 备用5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbshare0_op(
            in_client_no -- 内部客户编号
            ,seller_code -- 销售商代码
            ,bank_no -- 银行编号
            ,client_no -- 银行客户号
            ,bank_acc -- 银行账号
            ,ta_client -- TA交易帐号
            ,cash_flag -- 钞汇标志
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,ta_code -- TA代码
            ,asset_acc -- 理财帐号
            ,prd_code -- 产品代码
            ,contract_no -- 合约编号
            ,last_date -- 最后变动日期
            ,tot_vol -- 份额总数
            ,frozen_vol -- 交易冻结份额
            ,long_frozen_vol -- 长期冻结份额
            ,group_vol -- 组合投资份额
            ,div_mode -- 当前分红方式
            ,old_div_mode -- 原分红方式
            ,div_rate -- 红利比例
            ,ystdy_tot_vol -- 昨日总份额
            ,open_branch -- 份额所属机构
            ,client_type -- 客户类别
            ,append_flag -- 追加投资标志
            ,other_frozen -- 本地冻结份额
            ,income -- 本期收益
            ,income_rate -- 收益客户比例
            ,cost -- 买入成本
            ,tot_income -- 累计收入
            ,income_onway -- 未付收益#
            ,income_frozen -- 冻结的未付收益#
            ,income_new -- 当天新分配收益#
            ,manage_agio -- 管理费折扣率#
            ,tot_manage_fee -- 管理费总额#
            ,manage_fee -- 最新结转管理费#
            ,manage_date -- 管理费计算日期#
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,reserve3 -- 备用3
            ,reserve4 -- 备用4
            ,reserve5 -- 备用5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.in_client_no, o.in_client_no) as in_client_no -- 内部客户编号
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 销售商代码
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行编号
    ,nvl(n.client_no, o.client_no) as client_no -- 银行客户号
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 银行账号
    ,nvl(n.ta_client, o.ta_client) as ta_client -- TA交易帐号
    ,nvl(n.cash_flag, o.cash_flag) as cash_flag -- 钞汇标志
    ,nvl(n.trans_account_type, o.trans_account_type) as trans_account_type -- 交易介质类型
    ,nvl(n.trans_account, o.trans_account) as trans_account -- 交易介质
    ,nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 理财帐号
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合约编号
    ,nvl(n.last_date, o.last_date) as last_date -- 最后变动日期
    ,nvl(n.tot_vol, o.tot_vol) as tot_vol -- 份额总数
    ,nvl(n.frozen_vol, o.frozen_vol) as frozen_vol -- 交易冻结份额
    ,nvl(n.long_frozen_vol, o.long_frozen_vol) as long_frozen_vol -- 长期冻结份额
    ,nvl(n.group_vol, o.group_vol) as group_vol -- 组合投资份额
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 当前分红方式
    ,nvl(n.old_div_mode, o.old_div_mode) as old_div_mode -- 原分红方式
    ,nvl(n.div_rate, o.div_rate) as div_rate -- 红利比例
    ,nvl(n.ystdy_tot_vol, o.ystdy_tot_vol) as ystdy_tot_vol -- 昨日总份额
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 份额所属机构
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类别
    ,nvl(n.append_flag, o.append_flag) as append_flag -- 追加投资标志
    ,nvl(n.other_frozen, o.other_frozen) as other_frozen -- 本地冻结份额
    ,nvl(n.income, o.income) as income -- 本期收益
    ,nvl(n.income_rate, o.income_rate) as income_rate -- 收益客户比例
    ,nvl(n.cost, o.cost) as cost -- 买入成本
    ,nvl(n.tot_income, o.tot_income) as tot_income -- 累计收入
    ,nvl(n.income_onway, o.income_onway) as income_onway -- 未付收益#
    ,nvl(n.income_frozen, o.income_frozen) as income_frozen -- 冻结的未付收益#
    ,nvl(n.income_new, o.income_new) as income_new -- 当天新分配收益#
    ,nvl(n.manage_agio, o.manage_agio) as manage_agio -- 管理费折扣率#
    ,nvl(n.tot_manage_fee, o.tot_manage_fee) as tot_manage_fee -- 管理费总额#
    ,nvl(n.manage_fee, o.manage_fee) as manage_fee -- 最新结转管理费#
    ,nvl(n.manage_date, o.manage_date) as manage_date -- 管理费计算日期#
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备用3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 备用4
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 备用5
    ,case when
            n.in_client_no is null
            and n.seller_code is null
            and n.bank_no is null
            and n.bank_acc is null
            and n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.in_client_no is null
            and n.seller_code is null
            and n.bank_no is null
            and n.bank_acc is null
            and n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.in_client_no is null
            and n.seller_code is null
            and n.bank_no is null
            and n.bank_acc is null
            and n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbshare0_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbshare0 where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.in_client_no = n.in_client_no
            and o.seller_code = n.seller_code
            and o.bank_no = n.bank_no
            and o.bank_acc = n.bank_acc
            and o.prd_code = n.prd_code
where (
        o.in_client_no is null
        and o.seller_code is null
        and o.bank_no is null
        and o.bank_acc is null
        and o.prd_code is null
    )
    or (
        n.in_client_no is null
        and n.seller_code is null
        and n.bank_no is null
        and n.bank_acc is null
        and n.prd_code is null
    )
    or (
        o.client_no <> n.client_no
        or o.ta_client <> n.ta_client
        or o.cash_flag <> n.cash_flag
        or o.trans_account_type <> n.trans_account_type
        or o.trans_account <> n.trans_account
        or o.ta_code <> n.ta_code
        or o.asset_acc <> n.asset_acc
        or o.contract_no <> n.contract_no
        or o.last_date <> n.last_date
        or o.tot_vol <> n.tot_vol
        or o.frozen_vol <> n.frozen_vol
        or o.long_frozen_vol <> n.long_frozen_vol
        or o.group_vol <> n.group_vol
        or o.div_mode <> n.div_mode
        or o.old_div_mode <> n.old_div_mode
        or o.div_rate <> n.div_rate
        or o.ystdy_tot_vol <> n.ystdy_tot_vol
        or o.open_branch <> n.open_branch
        or o.client_type <> n.client_type
        or o.append_flag <> n.append_flag
        or o.other_frozen <> n.other_frozen
        or o.income <> n.income
        or o.income_rate <> n.income_rate
        or o.cost <> n.cost
        or o.tot_income <> n.tot_income
        or o.income_onway <> n.income_onway
        or o.income_frozen <> n.income_frozen
        or o.income_new <> n.income_new
        or o.manage_agio <> n.manage_agio
        or o.tot_manage_fee <> n.tot_manage_fee
        or o.manage_fee <> n.manage_fee
        or o.manage_date <> n.manage_date
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbshare0_cl(
            in_client_no -- 内部客户编号
            ,seller_code -- 销售商代码
            ,bank_no -- 银行编号
            ,client_no -- 银行客户号
            ,bank_acc -- 银行账号
            ,ta_client -- TA交易帐号
            ,cash_flag -- 钞汇标志
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,ta_code -- TA代码
            ,asset_acc -- 理财帐号
            ,prd_code -- 产品代码
            ,contract_no -- 合约编号
            ,last_date -- 最后变动日期
            ,tot_vol -- 份额总数
            ,frozen_vol -- 交易冻结份额
            ,long_frozen_vol -- 长期冻结份额
            ,group_vol -- 组合投资份额
            ,div_mode -- 当前分红方式
            ,old_div_mode -- 原分红方式
            ,div_rate -- 红利比例
            ,ystdy_tot_vol -- 昨日总份额
            ,open_branch -- 份额所属机构
            ,client_type -- 客户类别
            ,append_flag -- 追加投资标志
            ,other_frozen -- 本地冻结份额
            ,income -- 本期收益
            ,income_rate -- 收益客户比例
            ,cost -- 买入成本
            ,tot_income -- 累计收入
            ,income_onway -- 未付收益#
            ,income_frozen -- 冻结的未付收益#
            ,income_new -- 当天新分配收益#
            ,manage_agio -- 管理费折扣率#
            ,tot_manage_fee -- 管理费总额#
            ,manage_fee -- 最新结转管理费#
            ,manage_date -- 管理费计算日期#
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,reserve3 -- 备用3
            ,reserve4 -- 备用4
            ,reserve5 -- 备用5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbshare0_op(
            in_client_no -- 内部客户编号
            ,seller_code -- 销售商代码
            ,bank_no -- 银行编号
            ,client_no -- 银行客户号
            ,bank_acc -- 银行账号
            ,ta_client -- TA交易帐号
            ,cash_flag -- 钞汇标志
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,ta_code -- TA代码
            ,asset_acc -- 理财帐号
            ,prd_code -- 产品代码
            ,contract_no -- 合约编号
            ,last_date -- 最后变动日期
            ,tot_vol -- 份额总数
            ,frozen_vol -- 交易冻结份额
            ,long_frozen_vol -- 长期冻结份额
            ,group_vol -- 组合投资份额
            ,div_mode -- 当前分红方式
            ,old_div_mode -- 原分红方式
            ,div_rate -- 红利比例
            ,ystdy_tot_vol -- 昨日总份额
            ,open_branch -- 份额所属机构
            ,client_type -- 客户类别
            ,append_flag -- 追加投资标志
            ,other_frozen -- 本地冻结份额
            ,income -- 本期收益
            ,income_rate -- 收益客户比例
            ,cost -- 买入成本
            ,tot_income -- 累计收入
            ,income_onway -- 未付收益#
            ,income_frozen -- 冻结的未付收益#
            ,income_new -- 当天新分配收益#
            ,manage_agio -- 管理费折扣率#
            ,tot_manage_fee -- 管理费总额#
            ,manage_fee -- 最新结转管理费#
            ,manage_date -- 管理费计算日期#
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,reserve3 -- 备用3
            ,reserve4 -- 备用4
            ,reserve5 -- 备用5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.in_client_no -- 内部客户编号
    ,o.seller_code -- 销售商代码
    ,o.bank_no -- 银行编号
    ,o.client_no -- 银行客户号
    ,o.bank_acc -- 银行账号
    ,o.ta_client -- TA交易帐号
    ,o.cash_flag -- 钞汇标志
    ,o.trans_account_type -- 交易介质类型
    ,o.trans_account -- 交易介质
    ,o.ta_code -- TA代码
    ,o.asset_acc -- 理财帐号
    ,o.prd_code -- 产品代码
    ,o.contract_no -- 合约编号
    ,o.last_date -- 最后变动日期
    ,o.tot_vol -- 份额总数
    ,o.frozen_vol -- 交易冻结份额
    ,o.long_frozen_vol -- 长期冻结份额
    ,o.group_vol -- 组合投资份额
    ,o.div_mode -- 当前分红方式
    ,o.old_div_mode -- 原分红方式
    ,o.div_rate -- 红利比例
    ,o.ystdy_tot_vol -- 昨日总份额
    ,o.open_branch -- 份额所属机构
    ,o.client_type -- 客户类别
    ,o.append_flag -- 追加投资标志
    ,o.other_frozen -- 本地冻结份额
    ,o.income -- 本期收益
    ,o.income_rate -- 收益客户比例
    ,o.cost -- 买入成本
    ,o.tot_income -- 累计收入
    ,o.income_onway -- 未付收益#
    ,o.income_frozen -- 冻结的未付收益#
    ,o.income_new -- 当天新分配收益#
    ,o.manage_agio -- 管理费折扣率#
    ,o.tot_manage_fee -- 管理费总额#
    ,o.manage_fee -- 最新结转管理费#
    ,o.manage_date -- 管理费计算日期#
    ,o.reserve1 -- 备用1
    ,o.reserve2 -- 备用2
    ,o.reserve3 -- 备用3
    ,o.reserve4 -- 备用4
    ,o.reserve5 -- 备用5
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tbshare0_bk o
    left join ${iol_schema}.nfss_tbshare0_op n
        on
            o.in_client_no = n.in_client_no
            and o.seller_code = n.seller_code
            and o.bank_no = n.bank_no
            and o.bank_acc = n.bank_acc
            and o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbshare0_cl d
        on
            o.in_client_no = d.in_client_no
            and o.seller_code = d.seller_code
            and o.bank_no = d.bank_no
            and o.bank_acc = d.bank_acc
            and o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nfss_tbshare0;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tbshare0 exchange partition p_19000101 with table ${iol_schema}.nfss_tbshare0_cl;
alter table ${iol_schema}.nfss_tbshare0 exchange partition p_20991231 with table ${iol_schema}.nfss_tbshare0_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbshare0 to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbshare0_op purge;
drop table ${iol_schema}.nfss_tbshare0_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbshare0_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbshare0',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
