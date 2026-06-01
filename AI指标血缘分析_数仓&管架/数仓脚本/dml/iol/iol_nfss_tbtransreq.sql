/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbtransreq
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
create table ${iol_schema}.nfss_tbtransreq_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbtransreq;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbtransreq_op purge;
drop table ${iol_schema}.nfss_tbtransreq_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbtransreq_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbtransreq where 0=1;

create table ${iol_schema}.nfss_tbtransreq_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbtransreq where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbtransreq_cl(
            serial_no -- 流水号
            ,ex_serial -- 发起方流水号
            ,contract_no -- 合约编号
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,occur_init_date -- 发生交易时的系统日期
            ,seller_code -- 销售商代码
            ,trans_code -- 交易代码
            ,control_flag -- 控制标志
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,ta_code -- TA代码
            ,asset_acc -- 理财帐号
            ,in_client_no -- 内部客户编号
            ,client_type -- 客户类型
            ,id_type -- 证件类型
            ,id_code -- 证件号码
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,bank_acc -- 银行帐号
            ,cash_flag -- 钞汇标志
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,channel -- 交易渠道
            ,term_no -- 终端编号
            ,oper_no -- 交易柜员
            ,auth_oper -- 授权柜员
            ,prd_code -- 产品代码
            ,curr_type -- 产品币种
            ,prd_type -- 产品类别
            ,share_class -- 收费方式
            ,asso_date -- 关联日期
            ,asso_serial -- 关联流水号
            ,asso_serial2 -- 协议关联流水号2
            ,asso_serial3 -- 协议关联流水号3
            ,amt -- 交易金额
            ,manage_charge -- 外收手续费
            ,manage_charge2 -- 撤单外收费金额
            ,agio -- 佣金折扣
            ,client_group -- 客户分组
            ,liqu_status -- 账务状态
            ,ori_channel -- 原流水交易渠道
            ,ori_branch_no -- 原流水交易机构
            ,vol -- 交易份额
            ,larg_red_flag -- 巨额赎回处理标志
            ,red_mode -- 赎回模式
            ,prd_price -- 产品价格
            ,amt_ratio -- 金额比例
            ,div_mode -- 分红方式
            ,div_rate -- 红利比例
            ,frozen_cause -- 冻结原因
            ,transfer_cause -- 过户原因
            ,conv_dir -- 转换方向
            ,targ_prd_code -- 目标产品代码
            ,targ_seller_code -- 对方销售商代码
            ,targ_asset_acc -- 对方理财账号
            ,targ_branch -- 对方网点号
            ,targ_bank_acc -- 目标银行帐号
            ,client_risk -- 客户风险等级
            ,product_risk -- 产品风险等级
            ,cfm_date -- 确认日期
            ,cfm_no -- TA确认流水号
            ,cfm_vol -- 确认份额
            ,to_host_serial -- 发送主机流水号
            ,host_check_date -- 主机对帐日期
            ,ori_host_chk_date -- 原交易主机对帐日期
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,monitor_flag -- 监管标志
            ,client_manager -- 客户经理
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,status -- 交易状态
            ,deal_mode -- 受理方式
            ,summary -- 摘要说明
            ,debit_account -- 认申购账号
            ,fee_account -- 外收费账号
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbtransreq_op(
            serial_no -- 流水号
            ,ex_serial -- 发起方流水号
            ,contract_no -- 合约编号
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,occur_init_date -- 发生交易时的系统日期
            ,seller_code -- 销售商代码
            ,trans_code -- 交易代码
            ,control_flag -- 控制标志
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,ta_code -- TA代码
            ,asset_acc -- 理财帐号
            ,in_client_no -- 内部客户编号
            ,client_type -- 客户类型
            ,id_type -- 证件类型
            ,id_code -- 证件号码
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,bank_acc -- 银行帐号
            ,cash_flag -- 钞汇标志
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,channel -- 交易渠道
            ,term_no -- 终端编号
            ,oper_no -- 交易柜员
            ,auth_oper -- 授权柜员
            ,prd_code -- 产品代码
            ,curr_type -- 产品币种
            ,prd_type -- 产品类别
            ,share_class -- 收费方式
            ,asso_date -- 关联日期
            ,asso_serial -- 关联流水号
            ,asso_serial2 -- 协议关联流水号2
            ,asso_serial3 -- 协议关联流水号3
            ,amt -- 交易金额
            ,manage_charge -- 外收手续费
            ,manage_charge2 -- 撤单外收费金额
            ,agio -- 佣金折扣
            ,client_group -- 客户分组
            ,liqu_status -- 账务状态
            ,ori_channel -- 原流水交易渠道
            ,ori_branch_no -- 原流水交易机构
            ,vol -- 交易份额
            ,larg_red_flag -- 巨额赎回处理标志
            ,red_mode -- 赎回模式
            ,prd_price -- 产品价格
            ,amt_ratio -- 金额比例
            ,div_mode -- 分红方式
            ,div_rate -- 红利比例
            ,frozen_cause -- 冻结原因
            ,transfer_cause -- 过户原因
            ,conv_dir -- 转换方向
            ,targ_prd_code -- 目标产品代码
            ,targ_seller_code -- 对方销售商代码
            ,targ_asset_acc -- 对方理财账号
            ,targ_branch -- 对方网点号
            ,targ_bank_acc -- 目标银行帐号
            ,client_risk -- 客户风险等级
            ,product_risk -- 产品风险等级
            ,cfm_date -- 确认日期
            ,cfm_no -- TA确认流水号
            ,cfm_vol -- 确认份额
            ,to_host_serial -- 发送主机流水号
            ,host_check_date -- 主机对帐日期
            ,ori_host_chk_date -- 原交易主机对帐日期
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,monitor_flag -- 监管标志
            ,client_manager -- 客户经理
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,status -- 交易状态
            ,deal_mode -- 受理方式
            ,summary -- 摘要说明
            ,debit_account -- 认申购账号
            ,fee_account -- 外收费账号
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serial_no, o.serial_no) as serial_no -- 流水号
    ,nvl(n.ex_serial, o.ex_serial) as ex_serial -- 发起方流水号
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合约编号
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 交易日期
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 交易时间
    ,nvl(n.occur_init_date, o.occur_init_date) as occur_init_date -- 发生交易时的系统日期
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 销售商代码
    ,nvl(n.trans_code, o.trans_code) as trans_code -- 交易代码
    ,nvl(n.control_flag, o.control_flag) as control_flag -- 控制标志
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 交易机构
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 交易所属机构
    ,nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 理财帐号
    ,nvl(n.in_client_no, o.in_client_no) as in_client_no -- 内部客户编号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.id_type, o.id_type) as id_type -- 证件类型
    ,nvl(n.id_code, o.id_code) as id_code -- 证件号码
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行编号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 银行帐号
    ,nvl(n.cash_flag, o.cash_flag) as cash_flag -- 钞汇标志
    ,nvl(n.trans_account_type, o.trans_account_type) as trans_account_type -- 交易介质类型
    ,nvl(n.trans_account, o.trans_account) as trans_account -- 交易介质
    ,nvl(n.channel, o.channel) as channel -- 交易渠道
    ,nvl(n.term_no, o.term_no) as term_no -- 终端编号
    ,nvl(n.oper_no, o.oper_no) as oper_no -- 交易柜员
    ,nvl(n.auth_oper, o.auth_oper) as auth_oper -- 授权柜员
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 产品币种
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 产品类别
    ,nvl(n.share_class, o.share_class) as share_class -- 收费方式
    ,nvl(n.asso_date, o.asso_date) as asso_date -- 关联日期
    ,nvl(n.asso_serial, o.asso_serial) as asso_serial -- 关联流水号
    ,nvl(n.asso_serial2, o.asso_serial2) as asso_serial2 -- 协议关联流水号2
    ,nvl(n.asso_serial3, o.asso_serial3) as asso_serial3 -- 协议关联流水号3
    ,nvl(n.amt, o.amt) as amt -- 交易金额
    ,nvl(n.manage_charge, o.manage_charge) as manage_charge -- 外收手续费
    ,nvl(n.manage_charge2, o.manage_charge2) as manage_charge2 -- 撤单外收费金额
    ,nvl(n.agio, o.agio) as agio -- 佣金折扣
    ,nvl(n.client_group, o.client_group) as client_group -- 客户分组
    ,nvl(n.liqu_status, o.liqu_status) as liqu_status -- 账务状态
    ,nvl(n.ori_channel, o.ori_channel) as ori_channel -- 原流水交易渠道
    ,nvl(n.ori_branch_no, o.ori_branch_no) as ori_branch_no -- 原流水交易机构
    ,nvl(n.vol, o.vol) as vol -- 交易份额
    ,nvl(n.larg_red_flag, o.larg_red_flag) as larg_red_flag -- 巨额赎回处理标志
    ,nvl(n.red_mode, o.red_mode) as red_mode -- 赎回模式
    ,nvl(n.prd_price, o.prd_price) as prd_price -- 产品价格
    ,nvl(n.amt_ratio, o.amt_ratio) as amt_ratio -- 金额比例
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 分红方式
    ,nvl(n.div_rate, o.div_rate) as div_rate -- 红利比例
    ,nvl(n.frozen_cause, o.frozen_cause) as frozen_cause -- 冻结原因
    ,nvl(n.transfer_cause, o.transfer_cause) as transfer_cause -- 过户原因
    ,nvl(n.conv_dir, o.conv_dir) as conv_dir -- 转换方向
    ,nvl(n.targ_prd_code, o.targ_prd_code) as targ_prd_code -- 目标产品代码
    ,nvl(n.targ_seller_code, o.targ_seller_code) as targ_seller_code -- 对方销售商代码
    ,nvl(n.targ_asset_acc, o.targ_asset_acc) as targ_asset_acc -- 对方理财账号
    ,nvl(n.targ_branch, o.targ_branch) as targ_branch -- 对方网点号
    ,nvl(n.targ_bank_acc, o.targ_bank_acc) as targ_bank_acc -- 目标银行帐号
    ,nvl(n.client_risk, o.client_risk) as client_risk -- 客户风险等级
    ,nvl(n.product_risk, o.product_risk) as product_risk -- 产品风险等级
    ,nvl(n.cfm_date, o.cfm_date) as cfm_date -- 确认日期
    ,nvl(n.cfm_no, o.cfm_no) as cfm_no -- TA确认流水号
    ,nvl(n.cfm_vol, o.cfm_vol) as cfm_vol -- 确认份额
    ,nvl(n.to_host_serial, o.to_host_serial) as to_host_serial -- 发送主机流水号
    ,nvl(n.host_check_date, o.host_check_date) as host_check_date -- 主机对帐日期
    ,nvl(n.ori_host_chk_date, o.ori_host_chk_date) as ori_host_chk_date -- 原交易主机对帐日期
    ,nvl(n.host_trans_code, o.host_trans_code) as host_trans_code -- 主机交易码
    ,nvl(n.host_date, o.host_date) as host_date -- 主机日期
    ,nvl(n.host_serial, o.host_serial) as host_serial -- 主机流水号
    ,nvl(n.monitor_flag, o.monitor_flag) as monitor_flag -- 监管标志
    ,nvl(n.client_manager, o.client_manager) as client_manager -- 客户经理
    ,nvl(n.err_code, o.err_code) as err_code -- 返回码
    ,nvl(n.err_msg, o.err_msg) as err_msg -- 错误信息
    ,nvl(n.status, o.status) as status -- 交易状态
    ,nvl(n.deal_mode, o.deal_mode) as deal_mode -- 受理方式
    ,nvl(n.summary, o.summary) as summary -- 摘要说明
    ,nvl(n.debit_account, o.debit_account) as debit_account -- 认申购账号
    ,nvl(n.fee_account, o.fee_account) as fee_account -- 外收费账号
    ,nvl(n.amt1, o.amt1) as amt1 -- 备用金额1
    ,nvl(n.amt2, o.amt2) as amt2 -- 备用金额2
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 保留域1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 保留域2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 保留域3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 保留域4
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 保留域5
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
from (select * from ${iol_schema}.nfss_tbtransreq_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbtransreq where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serial_no = n.serial_no
where (
        o.serial_no is null
    )
    or (
        n.serial_no is null
    )
    or (
        o.ex_serial <> n.ex_serial
        or o.contract_no <> n.contract_no
        or o.trans_date <> n.trans_date
        or o.trans_time <> n.trans_time
        or o.occur_init_date <> n.occur_init_date
        or o.seller_code <> n.seller_code
        or o.trans_code <> n.trans_code
        or o.control_flag <> n.control_flag
        or o.branch_no <> n.branch_no
        or o.open_branch <> n.open_branch
        or o.ta_code <> n.ta_code
        or o.asset_acc <> n.asset_acc
        or o.in_client_no <> n.in_client_no
        or o.client_type <> n.client_type
        or o.id_type <> n.id_type
        or o.id_code <> n.id_code
        or o.bank_no <> n.bank_no
        or o.client_no <> n.client_no
        or o.bank_acc <> n.bank_acc
        or o.cash_flag <> n.cash_flag
        or o.trans_account_type <> n.trans_account_type
        or o.trans_account <> n.trans_account
        or o.channel <> n.channel
        or o.term_no <> n.term_no
        or o.oper_no <> n.oper_no
        or o.auth_oper <> n.auth_oper
        or o.prd_code <> n.prd_code
        or o.curr_type <> n.curr_type
        or o.prd_type <> n.prd_type
        or o.share_class <> n.share_class
        or o.asso_date <> n.asso_date
        or o.asso_serial <> n.asso_serial
        or o.asso_serial2 <> n.asso_serial2
        or o.asso_serial3 <> n.asso_serial3
        or o.amt <> n.amt
        or o.manage_charge <> n.manage_charge
        or o.manage_charge2 <> n.manage_charge2
        or o.agio <> n.agio
        or o.client_group <> n.client_group
        or o.liqu_status <> n.liqu_status
        or o.ori_channel <> n.ori_channel
        or o.ori_branch_no <> n.ori_branch_no
        or o.vol <> n.vol
        or o.larg_red_flag <> n.larg_red_flag
        or o.red_mode <> n.red_mode
        or o.prd_price <> n.prd_price
        or o.amt_ratio <> n.amt_ratio
        or o.div_mode <> n.div_mode
        or o.div_rate <> n.div_rate
        or o.frozen_cause <> n.frozen_cause
        or o.transfer_cause <> n.transfer_cause
        or o.conv_dir <> n.conv_dir
        or o.targ_prd_code <> n.targ_prd_code
        or o.targ_seller_code <> n.targ_seller_code
        or o.targ_asset_acc <> n.targ_asset_acc
        or o.targ_branch <> n.targ_branch
        or o.targ_bank_acc <> n.targ_bank_acc
        or o.client_risk <> n.client_risk
        or o.product_risk <> n.product_risk
        or o.cfm_date <> n.cfm_date
        or o.cfm_no <> n.cfm_no
        or o.cfm_vol <> n.cfm_vol
        or o.to_host_serial <> n.to_host_serial
        or o.host_check_date <> n.host_check_date
        or o.ori_host_chk_date <> n.ori_host_chk_date
        or o.host_trans_code <> n.host_trans_code
        or o.host_date <> n.host_date
        or o.host_serial <> n.host_serial
        or o.monitor_flag <> n.monitor_flag
        or o.client_manager <> n.client_manager
        or o.err_code <> n.err_code
        or o.err_msg <> n.err_msg
        or o.status <> n.status
        or o.deal_mode <> n.deal_mode
        or o.summary <> n.summary
        or o.debit_account <> n.debit_account
        or o.fee_account <> n.fee_account
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
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
        into ${iol_schema}.nfss_tbtransreq_cl(
            serial_no -- 流水号
            ,ex_serial -- 发起方流水号
            ,contract_no -- 合约编号
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,occur_init_date -- 发生交易时的系统日期
            ,seller_code -- 销售商代码
            ,trans_code -- 交易代码
            ,control_flag -- 控制标志
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,ta_code -- TA代码
            ,asset_acc -- 理财帐号
            ,in_client_no -- 内部客户编号
            ,client_type -- 客户类型
            ,id_type -- 证件类型
            ,id_code -- 证件号码
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,bank_acc -- 银行帐号
            ,cash_flag -- 钞汇标志
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,channel -- 交易渠道
            ,term_no -- 终端编号
            ,oper_no -- 交易柜员
            ,auth_oper -- 授权柜员
            ,prd_code -- 产品代码
            ,curr_type -- 产品币种
            ,prd_type -- 产品类别
            ,share_class -- 收费方式
            ,asso_date -- 关联日期
            ,asso_serial -- 关联流水号
            ,asso_serial2 -- 协议关联流水号2
            ,asso_serial3 -- 协议关联流水号3
            ,amt -- 交易金额
            ,manage_charge -- 外收手续费
            ,manage_charge2 -- 撤单外收费金额
            ,agio -- 佣金折扣
            ,client_group -- 客户分组
            ,liqu_status -- 账务状态
            ,ori_channel -- 原流水交易渠道
            ,ori_branch_no -- 原流水交易机构
            ,vol -- 交易份额
            ,larg_red_flag -- 巨额赎回处理标志
            ,red_mode -- 赎回模式
            ,prd_price -- 产品价格
            ,amt_ratio -- 金额比例
            ,div_mode -- 分红方式
            ,div_rate -- 红利比例
            ,frozen_cause -- 冻结原因
            ,transfer_cause -- 过户原因
            ,conv_dir -- 转换方向
            ,targ_prd_code -- 目标产品代码
            ,targ_seller_code -- 对方销售商代码
            ,targ_asset_acc -- 对方理财账号
            ,targ_branch -- 对方网点号
            ,targ_bank_acc -- 目标银行帐号
            ,client_risk -- 客户风险等级
            ,product_risk -- 产品风险等级
            ,cfm_date -- 确认日期
            ,cfm_no -- TA确认流水号
            ,cfm_vol -- 确认份额
            ,to_host_serial -- 发送主机流水号
            ,host_check_date -- 主机对帐日期
            ,ori_host_chk_date -- 原交易主机对帐日期
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,monitor_flag -- 监管标志
            ,client_manager -- 客户经理
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,status -- 交易状态
            ,deal_mode -- 受理方式
            ,summary -- 摘要说明
            ,debit_account -- 认申购账号
            ,fee_account -- 外收费账号
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbtransreq_op(
            serial_no -- 流水号
            ,ex_serial -- 发起方流水号
            ,contract_no -- 合约编号
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,occur_init_date -- 发生交易时的系统日期
            ,seller_code -- 销售商代码
            ,trans_code -- 交易代码
            ,control_flag -- 控制标志
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,ta_code -- TA代码
            ,asset_acc -- 理财帐号
            ,in_client_no -- 内部客户编号
            ,client_type -- 客户类型
            ,id_type -- 证件类型
            ,id_code -- 证件号码
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,bank_acc -- 银行帐号
            ,cash_flag -- 钞汇标志
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,channel -- 交易渠道
            ,term_no -- 终端编号
            ,oper_no -- 交易柜员
            ,auth_oper -- 授权柜员
            ,prd_code -- 产品代码
            ,curr_type -- 产品币种
            ,prd_type -- 产品类别
            ,share_class -- 收费方式
            ,asso_date -- 关联日期
            ,asso_serial -- 关联流水号
            ,asso_serial2 -- 协议关联流水号2
            ,asso_serial3 -- 协议关联流水号3
            ,amt -- 交易金额
            ,manage_charge -- 外收手续费
            ,manage_charge2 -- 撤单外收费金额
            ,agio -- 佣金折扣
            ,client_group -- 客户分组
            ,liqu_status -- 账务状态
            ,ori_channel -- 原流水交易渠道
            ,ori_branch_no -- 原流水交易机构
            ,vol -- 交易份额
            ,larg_red_flag -- 巨额赎回处理标志
            ,red_mode -- 赎回模式
            ,prd_price -- 产品价格
            ,amt_ratio -- 金额比例
            ,div_mode -- 分红方式
            ,div_rate -- 红利比例
            ,frozen_cause -- 冻结原因
            ,transfer_cause -- 过户原因
            ,conv_dir -- 转换方向
            ,targ_prd_code -- 目标产品代码
            ,targ_seller_code -- 对方销售商代码
            ,targ_asset_acc -- 对方理财账号
            ,targ_branch -- 对方网点号
            ,targ_bank_acc -- 目标银行帐号
            ,client_risk -- 客户风险等级
            ,product_risk -- 产品风险等级
            ,cfm_date -- 确认日期
            ,cfm_no -- TA确认流水号
            ,cfm_vol -- 确认份额
            ,to_host_serial -- 发送主机流水号
            ,host_check_date -- 主机对帐日期
            ,ori_host_chk_date -- 原交易主机对帐日期
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,monitor_flag -- 监管标志
            ,client_manager -- 客户经理
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,status -- 交易状态
            ,deal_mode -- 受理方式
            ,summary -- 摘要说明
            ,debit_account -- 认申购账号
            ,fee_account -- 外收费账号
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serial_no -- 流水号
    ,o.ex_serial -- 发起方流水号
    ,o.contract_no -- 合约编号
    ,o.trans_date -- 交易日期
    ,o.trans_time -- 交易时间
    ,o.occur_init_date -- 发生交易时的系统日期
    ,o.seller_code -- 销售商代码
    ,o.trans_code -- 交易代码
    ,o.control_flag -- 控制标志
    ,o.branch_no -- 交易机构
    ,o.open_branch -- 交易所属机构
    ,o.ta_code -- TA代码
    ,o.asset_acc -- 理财帐号
    ,o.in_client_no -- 内部客户编号
    ,o.client_type -- 客户类型
    ,o.id_type -- 证件类型
    ,o.id_code -- 证件号码
    ,o.bank_no -- 银行编号
    ,o.client_no -- 客户编号
    ,o.bank_acc -- 银行帐号
    ,o.cash_flag -- 钞汇标志
    ,o.trans_account_type -- 交易介质类型
    ,o.trans_account -- 交易介质
    ,o.channel -- 交易渠道
    ,o.term_no -- 终端编号
    ,o.oper_no -- 交易柜员
    ,o.auth_oper -- 授权柜员
    ,o.prd_code -- 产品代码
    ,o.curr_type -- 产品币种
    ,o.prd_type -- 产品类别
    ,o.share_class -- 收费方式
    ,o.asso_date -- 关联日期
    ,o.asso_serial -- 关联流水号
    ,o.asso_serial2 -- 协议关联流水号2
    ,o.asso_serial3 -- 协议关联流水号3
    ,o.amt -- 交易金额
    ,o.manage_charge -- 外收手续费
    ,o.manage_charge2 -- 撤单外收费金额
    ,o.agio -- 佣金折扣
    ,o.client_group -- 客户分组
    ,o.liqu_status -- 账务状态
    ,o.ori_channel -- 原流水交易渠道
    ,o.ori_branch_no -- 原流水交易机构
    ,o.vol -- 交易份额
    ,o.larg_red_flag -- 巨额赎回处理标志
    ,o.red_mode -- 赎回模式
    ,o.prd_price -- 产品价格
    ,o.amt_ratio -- 金额比例
    ,o.div_mode -- 分红方式
    ,o.div_rate -- 红利比例
    ,o.frozen_cause -- 冻结原因
    ,o.transfer_cause -- 过户原因
    ,o.conv_dir -- 转换方向
    ,o.targ_prd_code -- 目标产品代码
    ,o.targ_seller_code -- 对方销售商代码
    ,o.targ_asset_acc -- 对方理财账号
    ,o.targ_branch -- 对方网点号
    ,o.targ_bank_acc -- 目标银行帐号
    ,o.client_risk -- 客户风险等级
    ,o.product_risk -- 产品风险等级
    ,o.cfm_date -- 确认日期
    ,o.cfm_no -- TA确认流水号
    ,o.cfm_vol -- 确认份额
    ,o.to_host_serial -- 发送主机流水号
    ,o.host_check_date -- 主机对帐日期
    ,o.ori_host_chk_date -- 原交易主机对帐日期
    ,o.host_trans_code -- 主机交易码
    ,o.host_date -- 主机日期
    ,o.host_serial -- 主机流水号
    ,o.monitor_flag -- 监管标志
    ,o.client_manager -- 客户经理
    ,o.err_code -- 返回码
    ,o.err_msg -- 错误信息
    ,o.status -- 交易状态
    ,o.deal_mode -- 受理方式
    ,o.summary -- 摘要说明
    ,o.debit_account -- 认申购账号
    ,o.fee_account -- 外收费账号
    ,o.amt1 -- 备用金额1
    ,o.amt2 -- 备用金额2
    ,o.reserve1 -- 保留域1
    ,o.reserve2 -- 保留域2
    ,o.reserve3 -- 保留域3
    ,o.reserve4 -- 保留域4
    ,o.reserve5 -- 保留域5
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tbtransreq_bk o
    left join ${iol_schema}.nfss_tbtransreq_op n
        on
            o.serial_no = n.serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbtransreq_cl d
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
-- truncate table ${iol_schema}.nfss_tbtransreq;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tbtransreq exchange partition p_19000101 with table ${iol_schema}.nfss_tbtransreq_cl;
alter table ${iol_schema}.nfss_tbtransreq exchange partition p_20991231 with table ${iol_schema}.nfss_tbtransreq_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbtransreq to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbtransreq_op purge;
drop table ${iol_schema}.nfss_tbtransreq_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbtransreq_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbtransreq',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
