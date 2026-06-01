/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbtranscfm
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
create table ${iol_schema}.nfss_tbtranscfm_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbtranscfm;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbtranscfm_op purge;
drop table ${iol_schema}.nfss_tbtranscfm_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbtranscfm_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbtranscfm where 0=1;

create table ${iol_schema}.nfss_tbtranscfm_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbtranscfm where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbtranscfm_cl(
            ta_code -- TA代码
            ,cfm_date -- 确认日期
            ,cfm_no -- TA确认流水号
            ,ori_cfm_no -- 原确认流水号
            ,from_flag -- 发起方
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,clear_date -- 清算日期
            ,serial_no -- 流水号
            ,trans_code -- 交易代码
            ,busin_code -- 业务代码
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,channel -- 交易渠道
            ,term_no -- 终端编号
            ,oper_no -- 交易柜员
            ,in_client_no -- 内部客户编号
            ,client_type -- 客户类型
            ,asset_acc -- 理财帐号
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,client_name -- 客户名称
            ,bank_acc -- 银行帐号
            ,ta_client -- TA交易账号
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,cash_flag -- 钞汇标志
            ,prd_code -- 产品代码
            ,share_class -- 收费类别
            ,nav -- 产品净值
            ,price -- 交易价格
            ,amt -- 交易金额
            ,curr_type -- 结算币种
            ,cfm_amt -- 确认金额
            ,vol -- 交易份额
            ,cfm_vol -- 确认份额
            ,larg_red_flag -- 巨额赎回处理标志
            ,red_cause -- 强行赎回原因
            ,agio -- 佣金折扣
            ,tot_fee -- 总费用
            ,charge -- 手续费
            ,stamp_tax -- 印花税
            ,interest_tax -- 利息税
            ,transfer_fee -- 过户费
            ,agency_fee -- 代理费
            ,back_fee -- 后端收费
            ,other_fee1 -- 其他费用1
            ,other_fee2 -- 其他费用2
            ,cfm_income -- 确认收益
            ,manage_fee -- 管理费金额#
            ,cont_frozen_amt -- 继续冻结金额#
            ,vol_cumulate -- 份额累积积数#
            ,detail_flag -- 明细标志
            ,finish_flag -- 结束标识
            ,frozen_cause -- 冻结原因
            ,conv_dir -- 转换方向
            ,targ_prd_code -- 目标产品代码
            ,targ_nav -- 目标产品净值
            ,targ_price -- 目标产品价格
            ,targ_cfm_vol -- 目标产品确认份额
            ,targ_seller_code -- 对方销售商代码
            ,targ_branch -- 对方网点号
            ,targ_asset_acc -- 对方理财帐号
            ,targ_bank_acc -- 目标银行帐号
            ,interest -- 利息金额
            ,vol_of_int -- 利息转份额
            ,div_mode -- 分红方式
            ,div_rate -- 红利比例
            ,summary -- 摘要说明
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,status -- 交易状态
            ,client_manager -- 客户经理
            ,asso_date -- 关联日期
            ,asso_serial -- 关联流水号
            ,bank_charge -- 银行手续费
            ,ex_serial -- 发起方流水号
            ,contract_no -- 合约编号
            ,manage_charge -- 外收手续费
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,post_vol -- 交易后份额
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,reserve3 -- 备用3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbtranscfm_op(
            ta_code -- TA代码
            ,cfm_date -- 确认日期
            ,cfm_no -- TA确认流水号
            ,ori_cfm_no -- 原确认流水号
            ,from_flag -- 发起方
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,clear_date -- 清算日期
            ,serial_no -- 流水号
            ,trans_code -- 交易代码
            ,busin_code -- 业务代码
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,channel -- 交易渠道
            ,term_no -- 终端编号
            ,oper_no -- 交易柜员
            ,in_client_no -- 内部客户编号
            ,client_type -- 客户类型
            ,asset_acc -- 理财帐号
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,client_name -- 客户名称
            ,bank_acc -- 银行帐号
            ,ta_client -- TA交易账号
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,cash_flag -- 钞汇标志
            ,prd_code -- 产品代码
            ,share_class -- 收费类别
            ,nav -- 产品净值
            ,price -- 交易价格
            ,amt -- 交易金额
            ,curr_type -- 结算币种
            ,cfm_amt -- 确认金额
            ,vol -- 交易份额
            ,cfm_vol -- 确认份额
            ,larg_red_flag -- 巨额赎回处理标志
            ,red_cause -- 强行赎回原因
            ,agio -- 佣金折扣
            ,tot_fee -- 总费用
            ,charge -- 手续费
            ,stamp_tax -- 印花税
            ,interest_tax -- 利息税
            ,transfer_fee -- 过户费
            ,agency_fee -- 代理费
            ,back_fee -- 后端收费
            ,other_fee1 -- 其他费用1
            ,other_fee2 -- 其他费用2
            ,cfm_income -- 确认收益
            ,manage_fee -- 管理费金额#
            ,cont_frozen_amt -- 继续冻结金额#
            ,vol_cumulate -- 份额累积积数#
            ,detail_flag -- 明细标志
            ,finish_flag -- 结束标识
            ,frozen_cause -- 冻结原因
            ,conv_dir -- 转换方向
            ,targ_prd_code -- 目标产品代码
            ,targ_nav -- 目标产品净值
            ,targ_price -- 目标产品价格
            ,targ_cfm_vol -- 目标产品确认份额
            ,targ_seller_code -- 对方销售商代码
            ,targ_branch -- 对方网点号
            ,targ_asset_acc -- 对方理财帐号
            ,targ_bank_acc -- 目标银行帐号
            ,interest -- 利息金额
            ,vol_of_int -- 利息转份额
            ,div_mode -- 分红方式
            ,div_rate -- 红利比例
            ,summary -- 摘要说明
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,status -- 交易状态
            ,client_manager -- 客户经理
            ,asso_date -- 关联日期
            ,asso_serial -- 关联流水号
            ,bank_charge -- 银行手续费
            ,ex_serial -- 发起方流水号
            ,contract_no -- 合约编号
            ,manage_charge -- 外收手续费
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,post_vol -- 交易后份额
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,reserve3 -- 备用3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.cfm_date, o.cfm_date) as cfm_date -- 确认日期
    ,nvl(n.cfm_no, o.cfm_no) as cfm_no -- TA确认流水号
    ,nvl(n.ori_cfm_no, o.ori_cfm_no) as ori_cfm_no -- 原确认流水号
    ,nvl(n.from_flag, o.from_flag) as from_flag -- 发起方
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 交易日期
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 交易时间
    ,nvl(n.clear_date, o.clear_date) as clear_date -- 清算日期
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 流水号
    ,nvl(n.trans_code, o.trans_code) as trans_code -- 交易代码
    ,nvl(n.busin_code, o.busin_code) as busin_code -- 业务代码
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 交易机构
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 交易所属机构
    ,nvl(n.channel, o.channel) as channel -- 交易渠道
    ,nvl(n.term_no, o.term_no) as term_no -- 终端编号
    ,nvl(n.oper_no, o.oper_no) as oper_no -- 交易柜员
    ,nvl(n.in_client_no, o.in_client_no) as in_client_no -- 内部客户编号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 理财帐号
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行编号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 银行帐号
    ,nvl(n.ta_client, o.ta_client) as ta_client -- TA交易账号
    ,nvl(n.trans_account_type, o.trans_account_type) as trans_account_type -- 交易介质类型
    ,nvl(n.trans_account, o.trans_account) as trans_account -- 交易介质
    ,nvl(n.cash_flag, o.cash_flag) as cash_flag -- 钞汇标志
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.share_class, o.share_class) as share_class -- 收费类别
    ,nvl(n.nav, o.nav) as nav -- 产品净值
    ,nvl(n.price, o.price) as price -- 交易价格
    ,nvl(n.amt, o.amt) as amt -- 交易金额
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 结算币种
    ,nvl(n.cfm_amt, o.cfm_amt) as cfm_amt -- 确认金额
    ,nvl(n.vol, o.vol) as vol -- 交易份额
    ,nvl(n.cfm_vol, o.cfm_vol) as cfm_vol -- 确认份额
    ,nvl(n.larg_red_flag, o.larg_red_flag) as larg_red_flag -- 巨额赎回处理标志
    ,nvl(n.red_cause, o.red_cause) as red_cause -- 强行赎回原因
    ,nvl(n.agio, o.agio) as agio -- 佣金折扣
    ,nvl(n.tot_fee, o.tot_fee) as tot_fee -- 总费用
    ,nvl(n.charge, o.charge) as charge -- 手续费
    ,nvl(n.stamp_tax, o.stamp_tax) as stamp_tax -- 印花税
    ,nvl(n.interest_tax, o.interest_tax) as interest_tax -- 利息税
    ,nvl(n.transfer_fee, o.transfer_fee) as transfer_fee -- 过户费
    ,nvl(n.agency_fee, o.agency_fee) as agency_fee -- 代理费
    ,nvl(n.back_fee, o.back_fee) as back_fee -- 后端收费
    ,nvl(n.other_fee1, o.other_fee1) as other_fee1 -- 其他费用1
    ,nvl(n.other_fee2, o.other_fee2) as other_fee2 -- 其他费用2
    ,nvl(n.cfm_income, o.cfm_income) as cfm_income -- 确认收益
    ,nvl(n.manage_fee, o.manage_fee) as manage_fee -- 管理费金额#
    ,nvl(n.cont_frozen_amt, o.cont_frozen_amt) as cont_frozen_amt -- 继续冻结金额#
    ,nvl(n.vol_cumulate, o.vol_cumulate) as vol_cumulate -- 份额累积积数#
    ,nvl(n.detail_flag, o.detail_flag) as detail_flag -- 明细标志
    ,nvl(n.finish_flag, o.finish_flag) as finish_flag -- 结束标识
    ,nvl(n.frozen_cause, o.frozen_cause) as frozen_cause -- 冻结原因
    ,nvl(n.conv_dir, o.conv_dir) as conv_dir -- 转换方向
    ,nvl(n.targ_prd_code, o.targ_prd_code) as targ_prd_code -- 目标产品代码
    ,nvl(n.targ_nav, o.targ_nav) as targ_nav -- 目标产品净值
    ,nvl(n.targ_price, o.targ_price) as targ_price -- 目标产品价格
    ,nvl(n.targ_cfm_vol, o.targ_cfm_vol) as targ_cfm_vol -- 目标产品确认份额
    ,nvl(n.targ_seller_code, o.targ_seller_code) as targ_seller_code -- 对方销售商代码
    ,nvl(n.targ_branch, o.targ_branch) as targ_branch -- 对方网点号
    ,nvl(n.targ_asset_acc, o.targ_asset_acc) as targ_asset_acc -- 对方理财帐号
    ,nvl(n.targ_bank_acc, o.targ_bank_acc) as targ_bank_acc -- 目标银行帐号
    ,nvl(n.interest, o.interest) as interest -- 利息金额
    ,nvl(n.vol_of_int, o.vol_of_int) as vol_of_int -- 利息转份额
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 分红方式
    ,nvl(n.div_rate, o.div_rate) as div_rate -- 红利比例
    ,nvl(n.summary, o.summary) as summary -- 摘要说明
    ,nvl(n.err_code, o.err_code) as err_code -- 返回码
    ,nvl(n.err_msg, o.err_msg) as err_msg -- 错误信息
    ,nvl(n.status, o.status) as status -- 交易状态
    ,nvl(n.client_manager, o.client_manager) as client_manager -- 客户经理
    ,nvl(n.asso_date, o.asso_date) as asso_date -- 关联日期
    ,nvl(n.asso_serial, o.asso_serial) as asso_serial -- 关联流水号
    ,nvl(n.bank_charge, o.bank_charge) as bank_charge -- 银行手续费
    ,nvl(n.ex_serial, o.ex_serial) as ex_serial -- 发起方流水号
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合约编号
    ,nvl(n.manage_charge, o.manage_charge) as manage_charge -- 外收手续费
    ,nvl(n.host_trans_code, o.host_trans_code) as host_trans_code -- 主机交易码
    ,nvl(n.host_date, o.host_date) as host_date -- 主机日期
    ,nvl(n.host_serial, o.host_serial) as host_serial -- 主机流水号
    ,nvl(n.post_vol, o.post_vol) as post_vol -- 交易后份额
    ,nvl(n.amt1, o.amt1) as amt1 -- 备用金额1
    ,nvl(n.amt2, o.amt2) as amt2 -- 备用金额2
    ,nvl(n.amt3, o.amt3) as amt3 -- 备用金额3
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备用3
    ,case when
            n.ta_code is null
            and n.cfm_date is null
            and n.cfm_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ta_code is null
            and n.cfm_date is null
            and n.cfm_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ta_code is null
            and n.cfm_date is null
            and n.cfm_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbtranscfm_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbtranscfm where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ta_code = n.ta_code
            and o.cfm_date = n.cfm_date
            and o.cfm_no = n.cfm_no
where (
        o.ta_code is null
        and o.cfm_date is null
        and o.cfm_no is null
    )
    or (
        n.ta_code is null
        and n.cfm_date is null
        and n.cfm_no is null
    )
    or (
        o.ori_cfm_no <> n.ori_cfm_no
        or o.from_flag <> n.from_flag
        or o.trans_date <> n.trans_date
        or o.trans_time <> n.trans_time
        or o.clear_date <> n.clear_date
        or o.serial_no <> n.serial_no
        or o.trans_code <> n.trans_code
        or o.busin_code <> n.busin_code
        or o.branch_no <> n.branch_no
        or o.open_branch <> n.open_branch
        or o.channel <> n.channel
        or o.term_no <> n.term_no
        or o.oper_no <> n.oper_no
        or o.in_client_no <> n.in_client_no
        or o.client_type <> n.client_type
        or o.asset_acc <> n.asset_acc
        or o.bank_no <> n.bank_no
        or o.client_no <> n.client_no
        or o.client_name <> n.client_name
        or o.bank_acc <> n.bank_acc
        or o.ta_client <> n.ta_client
        or o.trans_account_type <> n.trans_account_type
        or o.trans_account <> n.trans_account
        or o.cash_flag <> n.cash_flag
        or o.prd_code <> n.prd_code
        or o.share_class <> n.share_class
        or o.nav <> n.nav
        or o.price <> n.price
        or o.amt <> n.amt
        or o.curr_type <> n.curr_type
        or o.cfm_amt <> n.cfm_amt
        or o.vol <> n.vol
        or o.cfm_vol <> n.cfm_vol
        or o.larg_red_flag <> n.larg_red_flag
        or o.red_cause <> n.red_cause
        or o.agio <> n.agio
        or o.tot_fee <> n.tot_fee
        or o.charge <> n.charge
        or o.stamp_tax <> n.stamp_tax
        or o.interest_tax <> n.interest_tax
        or o.transfer_fee <> n.transfer_fee
        or o.agency_fee <> n.agency_fee
        or o.back_fee <> n.back_fee
        or o.other_fee1 <> n.other_fee1
        or o.other_fee2 <> n.other_fee2
        or o.cfm_income <> n.cfm_income
        or o.manage_fee <> n.manage_fee
        or o.cont_frozen_amt <> n.cont_frozen_amt
        or o.vol_cumulate <> n.vol_cumulate
        or o.detail_flag <> n.detail_flag
        or o.finish_flag <> n.finish_flag
        or o.frozen_cause <> n.frozen_cause
        or o.conv_dir <> n.conv_dir
        or o.targ_prd_code <> n.targ_prd_code
        or o.targ_nav <> n.targ_nav
        or o.targ_price <> n.targ_price
        or o.targ_cfm_vol <> n.targ_cfm_vol
        or o.targ_seller_code <> n.targ_seller_code
        or o.targ_branch <> n.targ_branch
        or o.targ_asset_acc <> n.targ_asset_acc
        or o.targ_bank_acc <> n.targ_bank_acc
        or o.interest <> n.interest
        or o.vol_of_int <> n.vol_of_int
        or o.div_mode <> n.div_mode
        or o.div_rate <> n.div_rate
        or o.summary <> n.summary
        or o.err_code <> n.err_code
        or o.err_msg <> n.err_msg
        or o.status <> n.status
        or o.client_manager <> n.client_manager
        or o.asso_date <> n.asso_date
        or o.asso_serial <> n.asso_serial
        or o.bank_charge <> n.bank_charge
        or o.ex_serial <> n.ex_serial
        or o.contract_no <> n.contract_no
        or o.manage_charge <> n.manage_charge
        or o.host_trans_code <> n.host_trans_code
        or o.host_date <> n.host_date
        or o.host_serial <> n.host_serial
        or o.post_vol <> n.post_vol
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.amt3 <> n.amt3
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbtranscfm_cl(
            ta_code -- TA代码
            ,cfm_date -- 确认日期
            ,cfm_no -- TA确认流水号
            ,ori_cfm_no -- 原确认流水号
            ,from_flag -- 发起方
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,clear_date -- 清算日期
            ,serial_no -- 流水号
            ,trans_code -- 交易代码
            ,busin_code -- 业务代码
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,channel -- 交易渠道
            ,term_no -- 终端编号
            ,oper_no -- 交易柜员
            ,in_client_no -- 内部客户编号
            ,client_type -- 客户类型
            ,asset_acc -- 理财帐号
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,client_name -- 客户名称
            ,bank_acc -- 银行帐号
            ,ta_client -- TA交易账号
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,cash_flag -- 钞汇标志
            ,prd_code -- 产品代码
            ,share_class -- 收费类别
            ,nav -- 产品净值
            ,price -- 交易价格
            ,amt -- 交易金额
            ,curr_type -- 结算币种
            ,cfm_amt -- 确认金额
            ,vol -- 交易份额
            ,cfm_vol -- 确认份额
            ,larg_red_flag -- 巨额赎回处理标志
            ,red_cause -- 强行赎回原因
            ,agio -- 佣金折扣
            ,tot_fee -- 总费用
            ,charge -- 手续费
            ,stamp_tax -- 印花税
            ,interest_tax -- 利息税
            ,transfer_fee -- 过户费
            ,agency_fee -- 代理费
            ,back_fee -- 后端收费
            ,other_fee1 -- 其他费用1
            ,other_fee2 -- 其他费用2
            ,cfm_income -- 确认收益
            ,manage_fee -- 管理费金额#
            ,cont_frozen_amt -- 继续冻结金额#
            ,vol_cumulate -- 份额累积积数#
            ,detail_flag -- 明细标志
            ,finish_flag -- 结束标识
            ,frozen_cause -- 冻结原因
            ,conv_dir -- 转换方向
            ,targ_prd_code -- 目标产品代码
            ,targ_nav -- 目标产品净值
            ,targ_price -- 目标产品价格
            ,targ_cfm_vol -- 目标产品确认份额
            ,targ_seller_code -- 对方销售商代码
            ,targ_branch -- 对方网点号
            ,targ_asset_acc -- 对方理财帐号
            ,targ_bank_acc -- 目标银行帐号
            ,interest -- 利息金额
            ,vol_of_int -- 利息转份额
            ,div_mode -- 分红方式
            ,div_rate -- 红利比例
            ,summary -- 摘要说明
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,status -- 交易状态
            ,client_manager -- 客户经理
            ,asso_date -- 关联日期
            ,asso_serial -- 关联流水号
            ,bank_charge -- 银行手续费
            ,ex_serial -- 发起方流水号
            ,contract_no -- 合约编号
            ,manage_charge -- 外收手续费
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,post_vol -- 交易后份额
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,reserve3 -- 备用3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbtranscfm_op(
            ta_code -- TA代码
            ,cfm_date -- 确认日期
            ,cfm_no -- TA确认流水号
            ,ori_cfm_no -- 原确认流水号
            ,from_flag -- 发起方
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,clear_date -- 清算日期
            ,serial_no -- 流水号
            ,trans_code -- 交易代码
            ,busin_code -- 业务代码
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,channel -- 交易渠道
            ,term_no -- 终端编号
            ,oper_no -- 交易柜员
            ,in_client_no -- 内部客户编号
            ,client_type -- 客户类型
            ,asset_acc -- 理财帐号
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,client_name -- 客户名称
            ,bank_acc -- 银行帐号
            ,ta_client -- TA交易账号
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,cash_flag -- 钞汇标志
            ,prd_code -- 产品代码
            ,share_class -- 收费类别
            ,nav -- 产品净值
            ,price -- 交易价格
            ,amt -- 交易金额
            ,curr_type -- 结算币种
            ,cfm_amt -- 确认金额
            ,vol -- 交易份额
            ,cfm_vol -- 确认份额
            ,larg_red_flag -- 巨额赎回处理标志
            ,red_cause -- 强行赎回原因
            ,agio -- 佣金折扣
            ,tot_fee -- 总费用
            ,charge -- 手续费
            ,stamp_tax -- 印花税
            ,interest_tax -- 利息税
            ,transfer_fee -- 过户费
            ,agency_fee -- 代理费
            ,back_fee -- 后端收费
            ,other_fee1 -- 其他费用1
            ,other_fee2 -- 其他费用2
            ,cfm_income -- 确认收益
            ,manage_fee -- 管理费金额#
            ,cont_frozen_amt -- 继续冻结金额#
            ,vol_cumulate -- 份额累积积数#
            ,detail_flag -- 明细标志
            ,finish_flag -- 结束标识
            ,frozen_cause -- 冻结原因
            ,conv_dir -- 转换方向
            ,targ_prd_code -- 目标产品代码
            ,targ_nav -- 目标产品净值
            ,targ_price -- 目标产品价格
            ,targ_cfm_vol -- 目标产品确认份额
            ,targ_seller_code -- 对方销售商代码
            ,targ_branch -- 对方网点号
            ,targ_asset_acc -- 对方理财帐号
            ,targ_bank_acc -- 目标银行帐号
            ,interest -- 利息金额
            ,vol_of_int -- 利息转份额
            ,div_mode -- 分红方式
            ,div_rate -- 红利比例
            ,summary -- 摘要说明
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,status -- 交易状态
            ,client_manager -- 客户经理
            ,asso_date -- 关联日期
            ,asso_serial -- 关联流水号
            ,bank_charge -- 银行手续费
            ,ex_serial -- 发起方流水号
            ,contract_no -- 合约编号
            ,manage_charge -- 外收手续费
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,post_vol -- 交易后份额
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,reserve3 -- 备用3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ta_code -- TA代码
    ,o.cfm_date -- 确认日期
    ,o.cfm_no -- TA确认流水号
    ,o.ori_cfm_no -- 原确认流水号
    ,o.from_flag -- 发起方
    ,o.trans_date -- 交易日期
    ,o.trans_time -- 交易时间
    ,o.clear_date -- 清算日期
    ,o.serial_no -- 流水号
    ,o.trans_code -- 交易代码
    ,o.busin_code -- 业务代码
    ,o.branch_no -- 交易机构
    ,o.open_branch -- 交易所属机构
    ,o.channel -- 交易渠道
    ,o.term_no -- 终端编号
    ,o.oper_no -- 交易柜员
    ,o.in_client_no -- 内部客户编号
    ,o.client_type -- 客户类型
    ,o.asset_acc -- 理财帐号
    ,o.bank_no -- 银行编号
    ,o.client_no -- 客户编号
    ,o.client_name -- 客户名称
    ,o.bank_acc -- 银行帐号
    ,o.ta_client -- TA交易账号
    ,o.trans_account_type -- 交易介质类型
    ,o.trans_account -- 交易介质
    ,o.cash_flag -- 钞汇标志
    ,o.prd_code -- 产品代码
    ,o.share_class -- 收费类别
    ,o.nav -- 产品净值
    ,o.price -- 交易价格
    ,o.amt -- 交易金额
    ,o.curr_type -- 结算币种
    ,o.cfm_amt -- 确认金额
    ,o.vol -- 交易份额
    ,o.cfm_vol -- 确认份额
    ,o.larg_red_flag -- 巨额赎回处理标志
    ,o.red_cause -- 强行赎回原因
    ,o.agio -- 佣金折扣
    ,o.tot_fee -- 总费用
    ,o.charge -- 手续费
    ,o.stamp_tax -- 印花税
    ,o.interest_tax -- 利息税
    ,o.transfer_fee -- 过户费
    ,o.agency_fee -- 代理费
    ,o.back_fee -- 后端收费
    ,o.other_fee1 -- 其他费用1
    ,o.other_fee2 -- 其他费用2
    ,o.cfm_income -- 确认收益
    ,o.manage_fee -- 管理费金额#
    ,o.cont_frozen_amt -- 继续冻结金额#
    ,o.vol_cumulate -- 份额累积积数#
    ,o.detail_flag -- 明细标志
    ,o.finish_flag -- 结束标识
    ,o.frozen_cause -- 冻结原因
    ,o.conv_dir -- 转换方向
    ,o.targ_prd_code -- 目标产品代码
    ,o.targ_nav -- 目标产品净值
    ,o.targ_price -- 目标产品价格
    ,o.targ_cfm_vol -- 目标产品确认份额
    ,o.targ_seller_code -- 对方销售商代码
    ,o.targ_branch -- 对方网点号
    ,o.targ_asset_acc -- 对方理财帐号
    ,o.targ_bank_acc -- 目标银行帐号
    ,o.interest -- 利息金额
    ,o.vol_of_int -- 利息转份额
    ,o.div_mode -- 分红方式
    ,o.div_rate -- 红利比例
    ,o.summary -- 摘要说明
    ,o.err_code -- 返回码
    ,o.err_msg -- 错误信息
    ,o.status -- 交易状态
    ,o.client_manager -- 客户经理
    ,o.asso_date -- 关联日期
    ,o.asso_serial -- 关联流水号
    ,o.bank_charge -- 银行手续费
    ,o.ex_serial -- 发起方流水号
    ,o.contract_no -- 合约编号
    ,o.manage_charge -- 外收手续费
    ,o.host_trans_code -- 主机交易码
    ,o.host_date -- 主机日期
    ,o.host_serial -- 主机流水号
    ,o.post_vol -- 交易后份额
    ,o.amt1 -- 备用金额1
    ,o.amt2 -- 备用金额2
    ,o.amt3 -- 备用金额3
    ,o.reserve1 -- 备用1
    ,o.reserve2 -- 备用2
    ,o.reserve3 -- 备用3
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tbtranscfm_bk o
    left join ${iol_schema}.nfss_tbtranscfm_op n
        on
            o.ta_code = n.ta_code
            and o.cfm_date = n.cfm_date
            and o.cfm_no = n.cfm_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbtranscfm_cl d
        on
            o.ta_code = d.ta_code
            and o.cfm_date = d.cfm_date
            and o.cfm_no = d.cfm_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nfss_tbtranscfm;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tbtranscfm exchange partition p_19000101 with table ${iol_schema}.nfss_tbtranscfm_cl;
alter table ${iol_schema}.nfss_tbtranscfm exchange partition p_20991231 with table ${iol_schema}.nfss_tbtranscfm_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbtranscfm to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbtranscfm_op purge;
drop table ${iol_schema}.nfss_tbtranscfm_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbtranscfm_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbtranscfm',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
