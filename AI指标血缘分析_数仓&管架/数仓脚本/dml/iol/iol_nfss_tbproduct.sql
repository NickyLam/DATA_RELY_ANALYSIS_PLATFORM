/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbproduct
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
create table ${iol_schema}.nfss_tbproduct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbproduct;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbproduct_op purge;
drop table ${iol_schema}.nfss_tbproduct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbproduct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbproduct where 0=1;

create table ${iol_schema}.nfss_tbproduct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbproduct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbproduct_cl(
            prd_code -- 产品代码
            ,model_flag -- 产品归属类别
            ,model_comment -- 模板说明
            ,prd_type -- 产品类别
            ,ta_code -- TA代码
            ,prd_name -- 产品名称
            ,prd_name2 -- 产品别名
            ,vol_digit -- 产品份额小数位数
            ,amt_digit -- 产品金额小数位数
            ,nav_digit -- 产品净值小数位数
            ,nav -- 产品净值
            ,nav_date -- 净值日期
            ,nav_days -- 净值天数
            ,face_value -- 产品面值
            ,iss_price -- 发行价格
            ,asso_code -- 关联代码
            ,prd_sponsor -- 产品发起人
            ,prd_trustee -- 产品托管人
            ,prd_manager -- 产品管理人
            ,dep_id -- 产品主办部门
            ,branch_no -- 产品主办机构
            ,ipo_start_date -- 募集开始日期
            ,ipo_end_date -- 募集结束日期
            ,estab_date -- 产品成立日期
            ,income_date -- 产品起息日期
            ,end_date -- 产品结束日期
            ,interest_end_date -- 利息截止日#
            ,income_end_date -- 收益到期日#
            ,issue_fail_date -- 募集失败日期#
            ,alimit_end_date -- 募集后封闭到期日#
            ,real_estab_date -- 实际成立日期#
            ,prd_min_bala -- 产品最低募集金额
            ,prd_max_bala -- 产品最高募集金额
            ,prd_min_shares -- 产品最低募集份额#
            ,prd_max_shares -- 产品最高募集份额#
            ,prd_issue_real_bala -- 产品实际募集金额#
            ,curr_scale -- 当前规模
            ,div_modes -- 允许的分红方式
            ,div_mode -- 默认分红方式
            ,inst_flag -- 销售区域是否控制标志
            ,limit_flag -- 额度控制标志
            ,liqu_mode -- 募集期帐务模式
            ,liqu_mode2 -- 开放期帐务模式
            ,channels -- 允许渠道组
            ,client_groups -- 允许客户组
            ,temp_flag -- 模板标志
            ,control_flag -- 控制标志
            ,control_flag2 -- BTA控制标志#
            ,share_class -- 前后端收费类别
            ,issue_cfm_rate -- 成立确认比例#
            ,sub_mode -- 是否外收费
            ,sub_exp -- 认购导出模式
            ,interest_way -- 收益体现方式
            ,prd_attr -- 产品属性
            ,risk_level -- 风险等级
            ,grade -- 评估等级
            ,status -- 产品状态
            ,conv_flag -- 转换标志
            ,prd_totvol -- 产品当前总份额
            ,tot_nav -- 产品累计净值
            ,curr_type -- 币种
            ,cost_curr_type -- 返还本金币种
            ,income_curr_type -- 收益币种
            ,cash_flag -- 钞汇标志
            ,agio_type -- 折扣率计算方式
            ,open_time -- 开市时间
            ,close_time -- 闭市时间
            ,paper_no -- 产品适合度试卷编号
            ,paper_name -- 产品适合度试卷名称
            ,protocol_name -- 产品协议书名称
            ,psub_unit -- 个人最小购买单位
            ,pfirst_amt -- 个人首次最低投资金额
            ,papp_amt -- 个人追加最低投资金额
            ,pmin_invest_amt -- 个人最低定投金额
            ,pmin_hold -- 个人最低持有份额
            ,pmin_red -- 个人单笔最少赎回份额
            ,pmax_red -- 个人单笔最大赎回份额
            ,pred_unit -- 个人赎回单位
            ,pmin_conv_vol -- 个人最低基金转换份额
            ,pmin_red_vol -- 个人最低定赎份额
            ,pmax_amt -- 个人单笔最大购买金额
            ,pmax_accu_amt -- 个人单户累计最大购买金额#
            ,osub_unit -- 机构最小购买单位
            ,ofirst_amt -- 机构首次最低投资金额
            ,oapp_amt -- 机构追加最低投资金额
            ,omin_invest_amt -- 机构最低定投金额
            ,omin_hold -- 机构最低持有份额
            ,omin_red -- 机构单笔最小赎回份额
            ,omax_red -- 机构单笔最大赎回份额
            ,ored_unit -- 机构赎回单位
            ,omin_conv_vol -- 机构最低基金转换份额
            ,omin_red_vol -- 机构最低定赎份额
            ,omax_amt -- 机构单笔最大购买金额
            ,omax_accu_amt -- 机构单户累计最大购买金额#
            ,tot_client -- 累计购买客户数
            ,ipo_time -- 募集开始时间
            ,order_date -- 预约购买开始日期
            ,order_time -- 预约购买开始时间
            ,book_buy_days -- 客户预约购买最大允许提前天数
            ,book_sell_days -- 客户预约赎回最大允许提前天数
            ,book_buy_date -- 银行指定预约购买受理日
            ,book_sell_date -- 银行指定预约赎回受理日
            ,dir_order_type -- 定向预约模式
            ,dir_hold_day -- 定向预约有效天数
            ,dir_free_date -- 定向预约释放日期
            ,dir_start_date -- 定向预约开始日期
            ,dir_start_time -- 定向预约开始时间
            ,invest_fail_times -- 定投失败次数
            ,debit_account -- 认申购账号
            ,crebit_account -- 赎回账号
            ,red_draw_account -- 实时赎回垫支帐号
            ,charge_account -- 手续费分配账号
            ,manage_account -- 管理费分配账号
            ,red_days -- 赎回资金到帐天数
            ,div_days -- 分红资金到帐天数
            ,refund_days -- 产品到期资金到帐天数
            ,fail_days -- 发行失败/比例退款天数
            ,open_buy_days -- 申购失败资金到帐延迟天数
            ,red_arr_date -- 赎回资金到帐日期
            ,div_arr_date -- 分红资金到帐日期
            ,refund_arr_date -- 产品到期资金到帐日期
            ,fail_arr_date -- 发行失败/比例退款到帐日期
            ,open_arr_date -- 申购失败资金到帐延迟日期
            ,large_buy_rate -- 超额申购比例#
            ,large_red_rate -- 巨额赎回比例#
            ,real_red_amt_rate -- 实时赎回资金比例
            ,real_red_vol_rate -- 当日实时赎回份额比例上限#
            ,real_red_max_vol -- 当日实时赎回份额上限
            ,base_days -- 产品计息基数#
            ,interest_days -- 认购利息计息基数#
            ,manage_days -- 管理费基础天数#
            ,red_fare_rate -- 赎回费归基金资产比例#
            ,conv_fare_rate -- 转换费归基金资产比例#
            ,manage_rate -- 管理费计提比例#
            ,total_bonus -- 累计单位分红#
            ,cash_rate -- 货币式产品收益兑付频率
            ,money_date -- 货币产品收益兑付日期#
            ,corpus_rate -- 保本比例#
            ,evend_date -- 保本到期日#
            ,tn_confirm -- 所有业务清算延后天数#
            ,guest_rate -- 预期收益率#
            ,cycle_days -- 周期天数#
            ,trans_way -- 交易方式
            ,int1 -- 备用整数1
            ,int2 -- 备用整数2
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,reserve4 -- 备注4
            ,reserve5 -- 备注5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbproduct_op(
            prd_code -- 产品代码
            ,model_flag -- 产品归属类别
            ,model_comment -- 模板说明
            ,prd_type -- 产品类别
            ,ta_code -- TA代码
            ,prd_name -- 产品名称
            ,prd_name2 -- 产品别名
            ,vol_digit -- 产品份额小数位数
            ,amt_digit -- 产品金额小数位数
            ,nav_digit -- 产品净值小数位数
            ,nav -- 产品净值
            ,nav_date -- 净值日期
            ,nav_days -- 净值天数
            ,face_value -- 产品面值
            ,iss_price -- 发行价格
            ,asso_code -- 关联代码
            ,prd_sponsor -- 产品发起人
            ,prd_trustee -- 产品托管人
            ,prd_manager -- 产品管理人
            ,dep_id -- 产品主办部门
            ,branch_no -- 产品主办机构
            ,ipo_start_date -- 募集开始日期
            ,ipo_end_date -- 募集结束日期
            ,estab_date -- 产品成立日期
            ,income_date -- 产品起息日期
            ,end_date -- 产品结束日期
            ,interest_end_date -- 利息截止日#
            ,income_end_date -- 收益到期日#
            ,issue_fail_date -- 募集失败日期#
            ,alimit_end_date -- 募集后封闭到期日#
            ,real_estab_date -- 实际成立日期#
            ,prd_min_bala -- 产品最低募集金额
            ,prd_max_bala -- 产品最高募集金额
            ,prd_min_shares -- 产品最低募集份额#
            ,prd_max_shares -- 产品最高募集份额#
            ,prd_issue_real_bala -- 产品实际募集金额#
            ,curr_scale -- 当前规模
            ,div_modes -- 允许的分红方式
            ,div_mode -- 默认分红方式
            ,inst_flag -- 销售区域是否控制标志
            ,limit_flag -- 额度控制标志
            ,liqu_mode -- 募集期帐务模式
            ,liqu_mode2 -- 开放期帐务模式
            ,channels -- 允许渠道组
            ,client_groups -- 允许客户组
            ,temp_flag -- 模板标志
            ,control_flag -- 控制标志
            ,control_flag2 -- BTA控制标志#
            ,share_class -- 前后端收费类别
            ,issue_cfm_rate -- 成立确认比例#
            ,sub_mode -- 是否外收费
            ,sub_exp -- 认购导出模式
            ,interest_way -- 收益体现方式
            ,prd_attr -- 产品属性
            ,risk_level -- 风险等级
            ,grade -- 评估等级
            ,status -- 产品状态
            ,conv_flag -- 转换标志
            ,prd_totvol -- 产品当前总份额
            ,tot_nav -- 产品累计净值
            ,curr_type -- 币种
            ,cost_curr_type -- 返还本金币种
            ,income_curr_type -- 收益币种
            ,cash_flag -- 钞汇标志
            ,agio_type -- 折扣率计算方式
            ,open_time -- 开市时间
            ,close_time -- 闭市时间
            ,paper_no -- 产品适合度试卷编号
            ,paper_name -- 产品适合度试卷名称
            ,protocol_name -- 产品协议书名称
            ,psub_unit -- 个人最小购买单位
            ,pfirst_amt -- 个人首次最低投资金额
            ,papp_amt -- 个人追加最低投资金额
            ,pmin_invest_amt -- 个人最低定投金额
            ,pmin_hold -- 个人最低持有份额
            ,pmin_red -- 个人单笔最少赎回份额
            ,pmax_red -- 个人单笔最大赎回份额
            ,pred_unit -- 个人赎回单位
            ,pmin_conv_vol -- 个人最低基金转换份额
            ,pmin_red_vol -- 个人最低定赎份额
            ,pmax_amt -- 个人单笔最大购买金额
            ,pmax_accu_amt -- 个人单户累计最大购买金额#
            ,osub_unit -- 机构最小购买单位
            ,ofirst_amt -- 机构首次最低投资金额
            ,oapp_amt -- 机构追加最低投资金额
            ,omin_invest_amt -- 机构最低定投金额
            ,omin_hold -- 机构最低持有份额
            ,omin_red -- 机构单笔最小赎回份额
            ,omax_red -- 机构单笔最大赎回份额
            ,ored_unit -- 机构赎回单位
            ,omin_conv_vol -- 机构最低基金转换份额
            ,omin_red_vol -- 机构最低定赎份额
            ,omax_amt -- 机构单笔最大购买金额
            ,omax_accu_amt -- 机构单户累计最大购买金额#
            ,tot_client -- 累计购买客户数
            ,ipo_time -- 募集开始时间
            ,order_date -- 预约购买开始日期
            ,order_time -- 预约购买开始时间
            ,book_buy_days -- 客户预约购买最大允许提前天数
            ,book_sell_days -- 客户预约赎回最大允许提前天数
            ,book_buy_date -- 银行指定预约购买受理日
            ,book_sell_date -- 银行指定预约赎回受理日
            ,dir_order_type -- 定向预约模式
            ,dir_hold_day -- 定向预约有效天数
            ,dir_free_date -- 定向预约释放日期
            ,dir_start_date -- 定向预约开始日期
            ,dir_start_time -- 定向预约开始时间
            ,invest_fail_times -- 定投失败次数
            ,debit_account -- 认申购账号
            ,crebit_account -- 赎回账号
            ,red_draw_account -- 实时赎回垫支帐号
            ,charge_account -- 手续费分配账号
            ,manage_account -- 管理费分配账号
            ,red_days -- 赎回资金到帐天数
            ,div_days -- 分红资金到帐天数
            ,refund_days -- 产品到期资金到帐天数
            ,fail_days -- 发行失败/比例退款天数
            ,open_buy_days -- 申购失败资金到帐延迟天数
            ,red_arr_date -- 赎回资金到帐日期
            ,div_arr_date -- 分红资金到帐日期
            ,refund_arr_date -- 产品到期资金到帐日期
            ,fail_arr_date -- 发行失败/比例退款到帐日期
            ,open_arr_date -- 申购失败资金到帐延迟日期
            ,large_buy_rate -- 超额申购比例#
            ,large_red_rate -- 巨额赎回比例#
            ,real_red_amt_rate -- 实时赎回资金比例
            ,real_red_vol_rate -- 当日实时赎回份额比例上限#
            ,real_red_max_vol -- 当日实时赎回份额上限
            ,base_days -- 产品计息基数#
            ,interest_days -- 认购利息计息基数#
            ,manage_days -- 管理费基础天数#
            ,red_fare_rate -- 赎回费归基金资产比例#
            ,conv_fare_rate -- 转换费归基金资产比例#
            ,manage_rate -- 管理费计提比例#
            ,total_bonus -- 累计单位分红#
            ,cash_rate -- 货币式产品收益兑付频率
            ,money_date -- 货币产品收益兑付日期#
            ,corpus_rate -- 保本比例#
            ,evend_date -- 保本到期日#
            ,tn_confirm -- 所有业务清算延后天数#
            ,guest_rate -- 预期收益率#
            ,cycle_days -- 周期天数#
            ,trans_way -- 交易方式
            ,int1 -- 备用整数1
            ,int2 -- 备用整数2
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,reserve4 -- 备注4
            ,reserve5 -- 备注5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.model_flag, o.model_flag) as model_flag -- 产品归属类别
    ,nvl(n.model_comment, o.model_comment) as model_comment -- 模板说明
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 产品类别
    ,nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.prd_name, o.prd_name) as prd_name -- 产品名称
    ,nvl(n.prd_name2, o.prd_name2) as prd_name2 -- 产品别名
    ,nvl(n.vol_digit, o.vol_digit) as vol_digit -- 产品份额小数位数
    ,nvl(n.amt_digit, o.amt_digit) as amt_digit -- 产品金额小数位数
    ,nvl(n.nav_digit, o.nav_digit) as nav_digit -- 产品净值小数位数
    ,nvl(n.nav, o.nav) as nav -- 产品净值
    ,nvl(n.nav_date, o.nav_date) as nav_date -- 净值日期
    ,nvl(n.nav_days, o.nav_days) as nav_days -- 净值天数
    ,nvl(n.face_value, o.face_value) as face_value -- 产品面值
    ,nvl(n.iss_price, o.iss_price) as iss_price -- 发行价格
    ,nvl(n.asso_code, o.asso_code) as asso_code -- 关联代码
    ,nvl(n.prd_sponsor, o.prd_sponsor) as prd_sponsor -- 产品发起人
    ,nvl(n.prd_trustee, o.prd_trustee) as prd_trustee -- 产品托管人
    ,nvl(n.prd_manager, o.prd_manager) as prd_manager -- 产品管理人
    ,nvl(n.dep_id, o.dep_id) as dep_id -- 产品主办部门
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 产品主办机构
    ,nvl(n.ipo_start_date, o.ipo_start_date) as ipo_start_date -- 募集开始日期
    ,nvl(n.ipo_end_date, o.ipo_end_date) as ipo_end_date -- 募集结束日期
    ,nvl(n.estab_date, o.estab_date) as estab_date -- 产品成立日期
    ,nvl(n.income_date, o.income_date) as income_date -- 产品起息日期
    ,nvl(n.end_date, o.end_date) as end_date -- 产品结束日期
    ,nvl(n.interest_end_date, o.interest_end_date) as interest_end_date -- 利息截止日#
    ,nvl(n.income_end_date, o.income_end_date) as income_end_date -- 收益到期日#
    ,nvl(n.issue_fail_date, o.issue_fail_date) as issue_fail_date -- 募集失败日期#
    ,nvl(n.alimit_end_date, o.alimit_end_date) as alimit_end_date -- 募集后封闭到期日#
    ,nvl(n.real_estab_date, o.real_estab_date) as real_estab_date -- 实际成立日期#
    ,nvl(n.prd_min_bala, o.prd_min_bala) as prd_min_bala -- 产品最低募集金额
    ,nvl(n.prd_max_bala, o.prd_max_bala) as prd_max_bala -- 产品最高募集金额
    ,nvl(n.prd_min_shares, o.prd_min_shares) as prd_min_shares -- 产品最低募集份额#
    ,nvl(n.prd_max_shares, o.prd_max_shares) as prd_max_shares -- 产品最高募集份额#
    ,nvl(n.prd_issue_real_bala, o.prd_issue_real_bala) as prd_issue_real_bala -- 产品实际募集金额#
    ,nvl(n.curr_scale, o.curr_scale) as curr_scale -- 当前规模
    ,nvl(n.div_modes, o.div_modes) as div_modes -- 允许的分红方式
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 默认分红方式
    ,nvl(n.inst_flag, o.inst_flag) as inst_flag -- 销售区域是否控制标志
    ,nvl(n.limit_flag, o.limit_flag) as limit_flag -- 额度控制标志
    ,nvl(n.liqu_mode, o.liqu_mode) as liqu_mode -- 募集期帐务模式
    ,nvl(n.liqu_mode2, o.liqu_mode2) as liqu_mode2 -- 开放期帐务模式
    ,nvl(n.channels, o.channels) as channels -- 允许渠道组
    ,nvl(n.client_groups, o.client_groups) as client_groups -- 允许客户组
    ,nvl(n.temp_flag, o.temp_flag) as temp_flag -- 模板标志
    ,nvl(n.control_flag, o.control_flag) as control_flag -- 控制标志
    ,nvl(n.control_flag2, o.control_flag2) as control_flag2 -- BTA控制标志#
    ,nvl(n.share_class, o.share_class) as share_class -- 前后端收费类别
    ,nvl(n.issue_cfm_rate, o.issue_cfm_rate) as issue_cfm_rate -- 成立确认比例#
    ,nvl(n.sub_mode, o.sub_mode) as sub_mode -- 是否外收费
    ,nvl(n.sub_exp, o.sub_exp) as sub_exp -- 认购导出模式
    ,nvl(n.interest_way, o.interest_way) as interest_way -- 收益体现方式
    ,nvl(n.prd_attr, o.prd_attr) as prd_attr -- 产品属性
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 风险等级
    ,nvl(n.grade, o.grade) as grade -- 评估等级
    ,nvl(n.status, o.status) as status -- 产品状态
    ,nvl(n.conv_flag, o.conv_flag) as conv_flag -- 转换标志
    ,nvl(n.prd_totvol, o.prd_totvol) as prd_totvol -- 产品当前总份额
    ,nvl(n.tot_nav, o.tot_nav) as tot_nav -- 产品累计净值
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 币种
    ,nvl(n.cost_curr_type, o.cost_curr_type) as cost_curr_type -- 返还本金币种
    ,nvl(n.income_curr_type, o.income_curr_type) as income_curr_type -- 收益币种
    ,nvl(n.cash_flag, o.cash_flag) as cash_flag -- 钞汇标志
    ,nvl(n.agio_type, o.agio_type) as agio_type -- 折扣率计算方式
    ,nvl(n.open_time, o.open_time) as open_time -- 开市时间
    ,nvl(n.close_time, o.close_time) as close_time -- 闭市时间
    ,nvl(n.paper_no, o.paper_no) as paper_no -- 产品适合度试卷编号
    ,nvl(n.paper_name, o.paper_name) as paper_name -- 产品适合度试卷名称
    ,nvl(n.protocol_name, o.protocol_name) as protocol_name -- 产品协议书名称
    ,nvl(n.psub_unit, o.psub_unit) as psub_unit -- 个人最小购买单位
    ,nvl(n.pfirst_amt, o.pfirst_amt) as pfirst_amt -- 个人首次最低投资金额
    ,nvl(n.papp_amt, o.papp_amt) as papp_amt -- 个人追加最低投资金额
    ,nvl(n.pmin_invest_amt, o.pmin_invest_amt) as pmin_invest_amt -- 个人最低定投金额
    ,nvl(n.pmin_hold, o.pmin_hold) as pmin_hold -- 个人最低持有份额
    ,nvl(n.pmin_red, o.pmin_red) as pmin_red -- 个人单笔最少赎回份额
    ,nvl(n.pmax_red, o.pmax_red) as pmax_red -- 个人单笔最大赎回份额
    ,nvl(n.pred_unit, o.pred_unit) as pred_unit -- 个人赎回单位
    ,nvl(n.pmin_conv_vol, o.pmin_conv_vol) as pmin_conv_vol -- 个人最低基金转换份额
    ,nvl(n.pmin_red_vol, o.pmin_red_vol) as pmin_red_vol -- 个人最低定赎份额
    ,nvl(n.pmax_amt, o.pmax_amt) as pmax_amt -- 个人单笔最大购买金额
    ,nvl(n.pmax_accu_amt, o.pmax_accu_amt) as pmax_accu_amt -- 个人单户累计最大购买金额#
    ,nvl(n.osub_unit, o.osub_unit) as osub_unit -- 机构最小购买单位
    ,nvl(n.ofirst_amt, o.ofirst_amt) as ofirst_amt -- 机构首次最低投资金额
    ,nvl(n.oapp_amt, o.oapp_amt) as oapp_amt -- 机构追加最低投资金额
    ,nvl(n.omin_invest_amt, o.omin_invest_amt) as omin_invest_amt -- 机构最低定投金额
    ,nvl(n.omin_hold, o.omin_hold) as omin_hold -- 机构最低持有份额
    ,nvl(n.omin_red, o.omin_red) as omin_red -- 机构单笔最小赎回份额
    ,nvl(n.omax_red, o.omax_red) as omax_red -- 机构单笔最大赎回份额
    ,nvl(n.ored_unit, o.ored_unit) as ored_unit -- 机构赎回单位
    ,nvl(n.omin_conv_vol, o.omin_conv_vol) as omin_conv_vol -- 机构最低基金转换份额
    ,nvl(n.omin_red_vol, o.omin_red_vol) as omin_red_vol -- 机构最低定赎份额
    ,nvl(n.omax_amt, o.omax_amt) as omax_amt -- 机构单笔最大购买金额
    ,nvl(n.omax_accu_amt, o.omax_accu_amt) as omax_accu_amt -- 机构单户累计最大购买金额#
    ,nvl(n.tot_client, o.tot_client) as tot_client -- 累计购买客户数
    ,nvl(n.ipo_time, o.ipo_time) as ipo_time -- 募集开始时间
    ,nvl(n.order_date, o.order_date) as order_date -- 预约购买开始日期
    ,nvl(n.order_time, o.order_time) as order_time -- 预约购买开始时间
    ,nvl(n.book_buy_days, o.book_buy_days) as book_buy_days -- 客户预约购买最大允许提前天数
    ,nvl(n.book_sell_days, o.book_sell_days) as book_sell_days -- 客户预约赎回最大允许提前天数
    ,nvl(n.book_buy_date, o.book_buy_date) as book_buy_date -- 银行指定预约购买受理日
    ,nvl(n.book_sell_date, o.book_sell_date) as book_sell_date -- 银行指定预约赎回受理日
    ,nvl(n.dir_order_type, o.dir_order_type) as dir_order_type -- 定向预约模式
    ,nvl(n.dir_hold_day, o.dir_hold_day) as dir_hold_day -- 定向预约有效天数
    ,nvl(n.dir_free_date, o.dir_free_date) as dir_free_date -- 定向预约释放日期
    ,nvl(n.dir_start_date, o.dir_start_date) as dir_start_date -- 定向预约开始日期
    ,nvl(n.dir_start_time, o.dir_start_time) as dir_start_time -- 定向预约开始时间
    ,nvl(n.invest_fail_times, o.invest_fail_times) as invest_fail_times -- 定投失败次数
    ,nvl(n.debit_account, o.debit_account) as debit_account -- 认申购账号
    ,nvl(n.crebit_account, o.crebit_account) as crebit_account -- 赎回账号
    ,nvl(n.red_draw_account, o.red_draw_account) as red_draw_account -- 实时赎回垫支帐号
    ,nvl(n.charge_account, o.charge_account) as charge_account -- 手续费分配账号
    ,nvl(n.manage_account, o.manage_account) as manage_account -- 管理费分配账号
    ,nvl(n.red_days, o.red_days) as red_days -- 赎回资金到帐天数
    ,nvl(n.div_days, o.div_days) as div_days -- 分红资金到帐天数
    ,nvl(n.refund_days, o.refund_days) as refund_days -- 产品到期资金到帐天数
    ,nvl(n.fail_days, o.fail_days) as fail_days -- 发行失败/比例退款天数
    ,nvl(n.open_buy_days, o.open_buy_days) as open_buy_days -- 申购失败资金到帐延迟天数
    ,nvl(n.red_arr_date, o.red_arr_date) as red_arr_date -- 赎回资金到帐日期
    ,nvl(n.div_arr_date, o.div_arr_date) as div_arr_date -- 分红资金到帐日期
    ,nvl(n.refund_arr_date, o.refund_arr_date) as refund_arr_date -- 产品到期资金到帐日期
    ,nvl(n.fail_arr_date, o.fail_arr_date) as fail_arr_date -- 发行失败/比例退款到帐日期
    ,nvl(n.open_arr_date, o.open_arr_date) as open_arr_date -- 申购失败资金到帐延迟日期
    ,nvl(n.large_buy_rate, o.large_buy_rate) as large_buy_rate -- 超额申购比例#
    ,nvl(n.large_red_rate, o.large_red_rate) as large_red_rate -- 巨额赎回比例#
    ,nvl(n.real_red_amt_rate, o.real_red_amt_rate) as real_red_amt_rate -- 实时赎回资金比例
    ,nvl(n.real_red_vol_rate, o.real_red_vol_rate) as real_red_vol_rate -- 当日实时赎回份额比例上限#
    ,nvl(n.real_red_max_vol, o.real_red_max_vol) as real_red_max_vol -- 当日实时赎回份额上限
    ,nvl(n.base_days, o.base_days) as base_days -- 产品计息基数#
    ,nvl(n.interest_days, o.interest_days) as interest_days -- 认购利息计息基数#
    ,nvl(n.manage_days, o.manage_days) as manage_days -- 管理费基础天数#
    ,nvl(n.red_fare_rate, o.red_fare_rate) as red_fare_rate -- 赎回费归基金资产比例#
    ,nvl(n.conv_fare_rate, o.conv_fare_rate) as conv_fare_rate -- 转换费归基金资产比例#
    ,nvl(n.manage_rate, o.manage_rate) as manage_rate -- 管理费计提比例#
    ,nvl(n.total_bonus, o.total_bonus) as total_bonus -- 累计单位分红#
    ,nvl(n.cash_rate, o.cash_rate) as cash_rate -- 货币式产品收益兑付频率
    ,nvl(n.money_date, o.money_date) as money_date -- 货币产品收益兑付日期#
    ,nvl(n.corpus_rate, o.corpus_rate) as corpus_rate -- 保本比例#
    ,nvl(n.evend_date, o.evend_date) as evend_date -- 保本到期日#
    ,nvl(n.tn_confirm, o.tn_confirm) as tn_confirm -- 所有业务清算延后天数#
    ,nvl(n.guest_rate, o.guest_rate) as guest_rate -- 预期收益率#
    ,nvl(n.cycle_days, o.cycle_days) as cycle_days -- 周期天数#
    ,nvl(n.trans_way, o.trans_way) as trans_way -- 交易方式
    ,nvl(n.int1, o.int1) as int1 -- 备用整数1
    ,nvl(n.int2, o.int2) as int2 -- 备用整数2
    ,nvl(n.amt1, o.amt1) as amt1 -- 备用金额1
    ,nvl(n.amt2, o.amt2) as amt2 -- 备用金额2
    ,nvl(n.amt3, o.amt3) as amt3 -- 备用金额3
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备注3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 备注4
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 备注5
    ,case when
            n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbproduct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbproduct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_code = n.prd_code
where (
        o.prd_code is null
    )
    or (
        n.prd_code is null
    )
    or (
        o.model_flag <> n.model_flag
        or o.model_comment <> n.model_comment
        or o.prd_type <> n.prd_type
        or o.ta_code <> n.ta_code
        or o.prd_name <> n.prd_name
        or o.prd_name2 <> n.prd_name2
        or o.vol_digit <> n.vol_digit
        or o.amt_digit <> n.amt_digit
        or o.nav_digit <> n.nav_digit
        or o.nav <> n.nav
        or o.nav_date <> n.nav_date
        or o.nav_days <> n.nav_days
        or o.face_value <> n.face_value
        or o.iss_price <> n.iss_price
        or o.asso_code <> n.asso_code
        or o.prd_sponsor <> n.prd_sponsor
        or o.prd_trustee <> n.prd_trustee
        or o.prd_manager <> n.prd_manager
        or o.dep_id <> n.dep_id
        or o.branch_no <> n.branch_no
        or o.ipo_start_date <> n.ipo_start_date
        or o.ipo_end_date <> n.ipo_end_date
        or o.estab_date <> n.estab_date
        or o.income_date <> n.income_date
        or o.end_date <> n.end_date
        or o.interest_end_date <> n.interest_end_date
        or o.income_end_date <> n.income_end_date
        or o.issue_fail_date <> n.issue_fail_date
        or o.alimit_end_date <> n.alimit_end_date
        or o.real_estab_date <> n.real_estab_date
        or o.prd_min_bala <> n.prd_min_bala
        or o.prd_max_bala <> n.prd_max_bala
        or o.prd_min_shares <> n.prd_min_shares
        or o.prd_max_shares <> n.prd_max_shares
        or o.prd_issue_real_bala <> n.prd_issue_real_bala
        or o.curr_scale <> n.curr_scale
        or o.div_modes <> n.div_modes
        or o.div_mode <> n.div_mode
        or o.inst_flag <> n.inst_flag
        or o.limit_flag <> n.limit_flag
        or o.liqu_mode <> n.liqu_mode
        or o.liqu_mode2 <> n.liqu_mode2
        or o.channels <> n.channels
        or o.client_groups <> n.client_groups
        or o.temp_flag <> n.temp_flag
        or o.control_flag <> n.control_flag
        or o.control_flag2 <> n.control_flag2
        or o.share_class <> n.share_class
        or o.issue_cfm_rate <> n.issue_cfm_rate
        or o.sub_mode <> n.sub_mode
        or o.sub_exp <> n.sub_exp
        or o.interest_way <> n.interest_way
        or o.prd_attr <> n.prd_attr
        or o.risk_level <> n.risk_level
        or o.grade <> n.grade
        or o.status <> n.status
        or o.conv_flag <> n.conv_flag
        or o.prd_totvol <> n.prd_totvol
        or o.tot_nav <> n.tot_nav
        or o.curr_type <> n.curr_type
        or o.cost_curr_type <> n.cost_curr_type
        or o.income_curr_type <> n.income_curr_type
        or o.cash_flag <> n.cash_flag
        or o.agio_type <> n.agio_type
        or o.open_time <> n.open_time
        or o.close_time <> n.close_time
        or o.paper_no <> n.paper_no
        or o.paper_name <> n.paper_name
        or o.protocol_name <> n.protocol_name
        or o.psub_unit <> n.psub_unit
        or o.pfirst_amt <> n.pfirst_amt
        or o.papp_amt <> n.papp_amt
        or o.pmin_invest_amt <> n.pmin_invest_amt
        or o.pmin_hold <> n.pmin_hold
        or o.pmin_red <> n.pmin_red
        or o.pmax_red <> n.pmax_red
        or o.pred_unit <> n.pred_unit
        or o.pmin_conv_vol <> n.pmin_conv_vol
        or o.pmin_red_vol <> n.pmin_red_vol
        or o.pmax_amt <> n.pmax_amt
        or o.pmax_accu_amt <> n.pmax_accu_amt
        or o.osub_unit <> n.osub_unit
        or o.ofirst_amt <> n.ofirst_amt
        or o.oapp_amt <> n.oapp_amt
        or o.omin_invest_amt <> n.omin_invest_amt
        or o.omin_hold <> n.omin_hold
        or o.omin_red <> n.omin_red
        or o.omax_red <> n.omax_red
        or o.ored_unit <> n.ored_unit
        or o.omin_conv_vol <> n.omin_conv_vol
        or o.omin_red_vol <> n.omin_red_vol
        or o.omax_amt <> n.omax_amt
        or o.omax_accu_amt <> n.omax_accu_amt
        or o.tot_client <> n.tot_client
        or o.ipo_time <> n.ipo_time
        or o.order_date <> n.order_date
        or o.order_time <> n.order_time
        or o.book_buy_days <> n.book_buy_days
        or o.book_sell_days <> n.book_sell_days
        or o.book_buy_date <> n.book_buy_date
        or o.book_sell_date <> n.book_sell_date
        or o.dir_order_type <> n.dir_order_type
        or o.dir_hold_day <> n.dir_hold_day
        or o.dir_free_date <> n.dir_free_date
        or o.dir_start_date <> n.dir_start_date
        or o.dir_start_time <> n.dir_start_time
        or o.invest_fail_times <> n.invest_fail_times
        or o.debit_account <> n.debit_account
        or o.crebit_account <> n.crebit_account
        or o.red_draw_account <> n.red_draw_account
        or o.charge_account <> n.charge_account
        or o.manage_account <> n.manage_account
        or o.red_days <> n.red_days
        or o.div_days <> n.div_days
        or o.refund_days <> n.refund_days
        or o.fail_days <> n.fail_days
        or o.open_buy_days <> n.open_buy_days
        or o.red_arr_date <> n.red_arr_date
        or o.div_arr_date <> n.div_arr_date
        or o.refund_arr_date <> n.refund_arr_date
        or o.fail_arr_date <> n.fail_arr_date
        or o.open_arr_date <> n.open_arr_date
        or o.large_buy_rate <> n.large_buy_rate
        or o.large_red_rate <> n.large_red_rate
        or o.real_red_amt_rate <> n.real_red_amt_rate
        or o.real_red_vol_rate <> n.real_red_vol_rate
        or o.real_red_max_vol <> n.real_red_max_vol
        or o.base_days <> n.base_days
        or o.interest_days <> n.interest_days
        or o.manage_days <> n.manage_days
        or o.red_fare_rate <> n.red_fare_rate
        or o.conv_fare_rate <> n.conv_fare_rate
        or o.manage_rate <> n.manage_rate
        or o.total_bonus <> n.total_bonus
        or o.cash_rate <> n.cash_rate
        or o.money_date <> n.money_date
        or o.corpus_rate <> n.corpus_rate
        or o.evend_date <> n.evend_date
        or o.tn_confirm <> n.tn_confirm
        or o.guest_rate <> n.guest_rate
        or o.cycle_days <> n.cycle_days
        or o.trans_way <> n.trans_way
        or o.int1 <> n.int1
        or o.int2 <> n.int2
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.amt3 <> n.amt3
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
        into ${iol_schema}.nfss_tbproduct_cl(
            prd_code -- 产品代码
            ,model_flag -- 产品归属类别
            ,model_comment -- 模板说明
            ,prd_type -- 产品类别
            ,ta_code -- TA代码
            ,prd_name -- 产品名称
            ,prd_name2 -- 产品别名
            ,vol_digit -- 产品份额小数位数
            ,amt_digit -- 产品金额小数位数
            ,nav_digit -- 产品净值小数位数
            ,nav -- 产品净值
            ,nav_date -- 净值日期
            ,nav_days -- 净值天数
            ,face_value -- 产品面值
            ,iss_price -- 发行价格
            ,asso_code -- 关联代码
            ,prd_sponsor -- 产品发起人
            ,prd_trustee -- 产品托管人
            ,prd_manager -- 产品管理人
            ,dep_id -- 产品主办部门
            ,branch_no -- 产品主办机构
            ,ipo_start_date -- 募集开始日期
            ,ipo_end_date -- 募集结束日期
            ,estab_date -- 产品成立日期
            ,income_date -- 产品起息日期
            ,end_date -- 产品结束日期
            ,interest_end_date -- 利息截止日#
            ,income_end_date -- 收益到期日#
            ,issue_fail_date -- 募集失败日期#
            ,alimit_end_date -- 募集后封闭到期日#
            ,real_estab_date -- 实际成立日期#
            ,prd_min_bala -- 产品最低募集金额
            ,prd_max_bala -- 产品最高募集金额
            ,prd_min_shares -- 产品最低募集份额#
            ,prd_max_shares -- 产品最高募集份额#
            ,prd_issue_real_bala -- 产品实际募集金额#
            ,curr_scale -- 当前规模
            ,div_modes -- 允许的分红方式
            ,div_mode -- 默认分红方式
            ,inst_flag -- 销售区域是否控制标志
            ,limit_flag -- 额度控制标志
            ,liqu_mode -- 募集期帐务模式
            ,liqu_mode2 -- 开放期帐务模式
            ,channels -- 允许渠道组
            ,client_groups -- 允许客户组
            ,temp_flag -- 模板标志
            ,control_flag -- 控制标志
            ,control_flag2 -- BTA控制标志#
            ,share_class -- 前后端收费类别
            ,issue_cfm_rate -- 成立确认比例#
            ,sub_mode -- 是否外收费
            ,sub_exp -- 认购导出模式
            ,interest_way -- 收益体现方式
            ,prd_attr -- 产品属性
            ,risk_level -- 风险等级
            ,grade -- 评估等级
            ,status -- 产品状态
            ,conv_flag -- 转换标志
            ,prd_totvol -- 产品当前总份额
            ,tot_nav -- 产品累计净值
            ,curr_type -- 币种
            ,cost_curr_type -- 返还本金币种
            ,income_curr_type -- 收益币种
            ,cash_flag -- 钞汇标志
            ,agio_type -- 折扣率计算方式
            ,open_time -- 开市时间
            ,close_time -- 闭市时间
            ,paper_no -- 产品适合度试卷编号
            ,paper_name -- 产品适合度试卷名称
            ,protocol_name -- 产品协议书名称
            ,psub_unit -- 个人最小购买单位
            ,pfirst_amt -- 个人首次最低投资金额
            ,papp_amt -- 个人追加最低投资金额
            ,pmin_invest_amt -- 个人最低定投金额
            ,pmin_hold -- 个人最低持有份额
            ,pmin_red -- 个人单笔最少赎回份额
            ,pmax_red -- 个人单笔最大赎回份额
            ,pred_unit -- 个人赎回单位
            ,pmin_conv_vol -- 个人最低基金转换份额
            ,pmin_red_vol -- 个人最低定赎份额
            ,pmax_amt -- 个人单笔最大购买金额
            ,pmax_accu_amt -- 个人单户累计最大购买金额#
            ,osub_unit -- 机构最小购买单位
            ,ofirst_amt -- 机构首次最低投资金额
            ,oapp_amt -- 机构追加最低投资金额
            ,omin_invest_amt -- 机构最低定投金额
            ,omin_hold -- 机构最低持有份额
            ,omin_red -- 机构单笔最小赎回份额
            ,omax_red -- 机构单笔最大赎回份额
            ,ored_unit -- 机构赎回单位
            ,omin_conv_vol -- 机构最低基金转换份额
            ,omin_red_vol -- 机构最低定赎份额
            ,omax_amt -- 机构单笔最大购买金额
            ,omax_accu_amt -- 机构单户累计最大购买金额#
            ,tot_client -- 累计购买客户数
            ,ipo_time -- 募集开始时间
            ,order_date -- 预约购买开始日期
            ,order_time -- 预约购买开始时间
            ,book_buy_days -- 客户预约购买最大允许提前天数
            ,book_sell_days -- 客户预约赎回最大允许提前天数
            ,book_buy_date -- 银行指定预约购买受理日
            ,book_sell_date -- 银行指定预约赎回受理日
            ,dir_order_type -- 定向预约模式
            ,dir_hold_day -- 定向预约有效天数
            ,dir_free_date -- 定向预约释放日期
            ,dir_start_date -- 定向预约开始日期
            ,dir_start_time -- 定向预约开始时间
            ,invest_fail_times -- 定投失败次数
            ,debit_account -- 认申购账号
            ,crebit_account -- 赎回账号
            ,red_draw_account -- 实时赎回垫支帐号
            ,charge_account -- 手续费分配账号
            ,manage_account -- 管理费分配账号
            ,red_days -- 赎回资金到帐天数
            ,div_days -- 分红资金到帐天数
            ,refund_days -- 产品到期资金到帐天数
            ,fail_days -- 发行失败/比例退款天数
            ,open_buy_days -- 申购失败资金到帐延迟天数
            ,red_arr_date -- 赎回资金到帐日期
            ,div_arr_date -- 分红资金到帐日期
            ,refund_arr_date -- 产品到期资金到帐日期
            ,fail_arr_date -- 发行失败/比例退款到帐日期
            ,open_arr_date -- 申购失败资金到帐延迟日期
            ,large_buy_rate -- 超额申购比例#
            ,large_red_rate -- 巨额赎回比例#
            ,real_red_amt_rate -- 实时赎回资金比例
            ,real_red_vol_rate -- 当日实时赎回份额比例上限#
            ,real_red_max_vol -- 当日实时赎回份额上限
            ,base_days -- 产品计息基数#
            ,interest_days -- 认购利息计息基数#
            ,manage_days -- 管理费基础天数#
            ,red_fare_rate -- 赎回费归基金资产比例#
            ,conv_fare_rate -- 转换费归基金资产比例#
            ,manage_rate -- 管理费计提比例#
            ,total_bonus -- 累计单位分红#
            ,cash_rate -- 货币式产品收益兑付频率
            ,money_date -- 货币产品收益兑付日期#
            ,corpus_rate -- 保本比例#
            ,evend_date -- 保本到期日#
            ,tn_confirm -- 所有业务清算延后天数#
            ,guest_rate -- 预期收益率#
            ,cycle_days -- 周期天数#
            ,trans_way -- 交易方式
            ,int1 -- 备用整数1
            ,int2 -- 备用整数2
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,reserve4 -- 备注4
            ,reserve5 -- 备注5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbproduct_op(
            prd_code -- 产品代码
            ,model_flag -- 产品归属类别
            ,model_comment -- 模板说明
            ,prd_type -- 产品类别
            ,ta_code -- TA代码
            ,prd_name -- 产品名称
            ,prd_name2 -- 产品别名
            ,vol_digit -- 产品份额小数位数
            ,amt_digit -- 产品金额小数位数
            ,nav_digit -- 产品净值小数位数
            ,nav -- 产品净值
            ,nav_date -- 净值日期
            ,nav_days -- 净值天数
            ,face_value -- 产品面值
            ,iss_price -- 发行价格
            ,asso_code -- 关联代码
            ,prd_sponsor -- 产品发起人
            ,prd_trustee -- 产品托管人
            ,prd_manager -- 产品管理人
            ,dep_id -- 产品主办部门
            ,branch_no -- 产品主办机构
            ,ipo_start_date -- 募集开始日期
            ,ipo_end_date -- 募集结束日期
            ,estab_date -- 产品成立日期
            ,income_date -- 产品起息日期
            ,end_date -- 产品结束日期
            ,interest_end_date -- 利息截止日#
            ,income_end_date -- 收益到期日#
            ,issue_fail_date -- 募集失败日期#
            ,alimit_end_date -- 募集后封闭到期日#
            ,real_estab_date -- 实际成立日期#
            ,prd_min_bala -- 产品最低募集金额
            ,prd_max_bala -- 产品最高募集金额
            ,prd_min_shares -- 产品最低募集份额#
            ,prd_max_shares -- 产品最高募集份额#
            ,prd_issue_real_bala -- 产品实际募集金额#
            ,curr_scale -- 当前规模
            ,div_modes -- 允许的分红方式
            ,div_mode -- 默认分红方式
            ,inst_flag -- 销售区域是否控制标志
            ,limit_flag -- 额度控制标志
            ,liqu_mode -- 募集期帐务模式
            ,liqu_mode2 -- 开放期帐务模式
            ,channels -- 允许渠道组
            ,client_groups -- 允许客户组
            ,temp_flag -- 模板标志
            ,control_flag -- 控制标志
            ,control_flag2 -- BTA控制标志#
            ,share_class -- 前后端收费类别
            ,issue_cfm_rate -- 成立确认比例#
            ,sub_mode -- 是否外收费
            ,sub_exp -- 认购导出模式
            ,interest_way -- 收益体现方式
            ,prd_attr -- 产品属性
            ,risk_level -- 风险等级
            ,grade -- 评估等级
            ,status -- 产品状态
            ,conv_flag -- 转换标志
            ,prd_totvol -- 产品当前总份额
            ,tot_nav -- 产品累计净值
            ,curr_type -- 币种
            ,cost_curr_type -- 返还本金币种
            ,income_curr_type -- 收益币种
            ,cash_flag -- 钞汇标志
            ,agio_type -- 折扣率计算方式
            ,open_time -- 开市时间
            ,close_time -- 闭市时间
            ,paper_no -- 产品适合度试卷编号
            ,paper_name -- 产品适合度试卷名称
            ,protocol_name -- 产品协议书名称
            ,psub_unit -- 个人最小购买单位
            ,pfirst_amt -- 个人首次最低投资金额
            ,papp_amt -- 个人追加最低投资金额
            ,pmin_invest_amt -- 个人最低定投金额
            ,pmin_hold -- 个人最低持有份额
            ,pmin_red -- 个人单笔最少赎回份额
            ,pmax_red -- 个人单笔最大赎回份额
            ,pred_unit -- 个人赎回单位
            ,pmin_conv_vol -- 个人最低基金转换份额
            ,pmin_red_vol -- 个人最低定赎份额
            ,pmax_amt -- 个人单笔最大购买金额
            ,pmax_accu_amt -- 个人单户累计最大购买金额#
            ,osub_unit -- 机构最小购买单位
            ,ofirst_amt -- 机构首次最低投资金额
            ,oapp_amt -- 机构追加最低投资金额
            ,omin_invest_amt -- 机构最低定投金额
            ,omin_hold -- 机构最低持有份额
            ,omin_red -- 机构单笔最小赎回份额
            ,omax_red -- 机构单笔最大赎回份额
            ,ored_unit -- 机构赎回单位
            ,omin_conv_vol -- 机构最低基金转换份额
            ,omin_red_vol -- 机构最低定赎份额
            ,omax_amt -- 机构单笔最大购买金额
            ,omax_accu_amt -- 机构单户累计最大购买金额#
            ,tot_client -- 累计购买客户数
            ,ipo_time -- 募集开始时间
            ,order_date -- 预约购买开始日期
            ,order_time -- 预约购买开始时间
            ,book_buy_days -- 客户预约购买最大允许提前天数
            ,book_sell_days -- 客户预约赎回最大允许提前天数
            ,book_buy_date -- 银行指定预约购买受理日
            ,book_sell_date -- 银行指定预约赎回受理日
            ,dir_order_type -- 定向预约模式
            ,dir_hold_day -- 定向预约有效天数
            ,dir_free_date -- 定向预约释放日期
            ,dir_start_date -- 定向预约开始日期
            ,dir_start_time -- 定向预约开始时间
            ,invest_fail_times -- 定投失败次数
            ,debit_account -- 认申购账号
            ,crebit_account -- 赎回账号
            ,red_draw_account -- 实时赎回垫支帐号
            ,charge_account -- 手续费分配账号
            ,manage_account -- 管理费分配账号
            ,red_days -- 赎回资金到帐天数
            ,div_days -- 分红资金到帐天数
            ,refund_days -- 产品到期资金到帐天数
            ,fail_days -- 发行失败/比例退款天数
            ,open_buy_days -- 申购失败资金到帐延迟天数
            ,red_arr_date -- 赎回资金到帐日期
            ,div_arr_date -- 分红资金到帐日期
            ,refund_arr_date -- 产品到期资金到帐日期
            ,fail_arr_date -- 发行失败/比例退款到帐日期
            ,open_arr_date -- 申购失败资金到帐延迟日期
            ,large_buy_rate -- 超额申购比例#
            ,large_red_rate -- 巨额赎回比例#
            ,real_red_amt_rate -- 实时赎回资金比例
            ,real_red_vol_rate -- 当日实时赎回份额比例上限#
            ,real_red_max_vol -- 当日实时赎回份额上限
            ,base_days -- 产品计息基数#
            ,interest_days -- 认购利息计息基数#
            ,manage_days -- 管理费基础天数#
            ,red_fare_rate -- 赎回费归基金资产比例#
            ,conv_fare_rate -- 转换费归基金资产比例#
            ,manage_rate -- 管理费计提比例#
            ,total_bonus -- 累计单位分红#
            ,cash_rate -- 货币式产品收益兑付频率
            ,money_date -- 货币产品收益兑付日期#
            ,corpus_rate -- 保本比例#
            ,evend_date -- 保本到期日#
            ,tn_confirm -- 所有业务清算延后天数#
            ,guest_rate -- 预期收益率#
            ,cycle_days -- 周期天数#
            ,trans_way -- 交易方式
            ,int1 -- 备用整数1
            ,int2 -- 备用整数2
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,reserve4 -- 备注4
            ,reserve5 -- 备注5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prd_code -- 产品代码
    ,o.model_flag -- 产品归属类别
    ,o.model_comment -- 模板说明
    ,o.prd_type -- 产品类别
    ,o.ta_code -- TA代码
    ,o.prd_name -- 产品名称
    ,o.prd_name2 -- 产品别名
    ,o.vol_digit -- 产品份额小数位数
    ,o.amt_digit -- 产品金额小数位数
    ,o.nav_digit -- 产品净值小数位数
    ,o.nav -- 产品净值
    ,o.nav_date -- 净值日期
    ,o.nav_days -- 净值天数
    ,o.face_value -- 产品面值
    ,o.iss_price -- 发行价格
    ,o.asso_code -- 关联代码
    ,o.prd_sponsor -- 产品发起人
    ,o.prd_trustee -- 产品托管人
    ,o.prd_manager -- 产品管理人
    ,o.dep_id -- 产品主办部门
    ,o.branch_no -- 产品主办机构
    ,o.ipo_start_date -- 募集开始日期
    ,o.ipo_end_date -- 募集结束日期
    ,o.estab_date -- 产品成立日期
    ,o.income_date -- 产品起息日期
    ,o.end_date -- 产品结束日期
    ,o.interest_end_date -- 利息截止日#
    ,o.income_end_date -- 收益到期日#
    ,o.issue_fail_date -- 募集失败日期#
    ,o.alimit_end_date -- 募集后封闭到期日#
    ,o.real_estab_date -- 实际成立日期#
    ,o.prd_min_bala -- 产品最低募集金额
    ,o.prd_max_bala -- 产品最高募集金额
    ,o.prd_min_shares -- 产品最低募集份额#
    ,o.prd_max_shares -- 产品最高募集份额#
    ,o.prd_issue_real_bala -- 产品实际募集金额#
    ,o.curr_scale -- 当前规模
    ,o.div_modes -- 允许的分红方式
    ,o.div_mode -- 默认分红方式
    ,o.inst_flag -- 销售区域是否控制标志
    ,o.limit_flag -- 额度控制标志
    ,o.liqu_mode -- 募集期帐务模式
    ,o.liqu_mode2 -- 开放期帐务模式
    ,o.channels -- 允许渠道组
    ,o.client_groups -- 允许客户组
    ,o.temp_flag -- 模板标志
    ,o.control_flag -- 控制标志
    ,o.control_flag2 -- BTA控制标志#
    ,o.share_class -- 前后端收费类别
    ,o.issue_cfm_rate -- 成立确认比例#
    ,o.sub_mode -- 是否外收费
    ,o.sub_exp -- 认购导出模式
    ,o.interest_way -- 收益体现方式
    ,o.prd_attr -- 产品属性
    ,o.risk_level -- 风险等级
    ,o.grade -- 评估等级
    ,o.status -- 产品状态
    ,o.conv_flag -- 转换标志
    ,o.prd_totvol -- 产品当前总份额
    ,o.tot_nav -- 产品累计净值
    ,o.curr_type -- 币种
    ,o.cost_curr_type -- 返还本金币种
    ,o.income_curr_type -- 收益币种
    ,o.cash_flag -- 钞汇标志
    ,o.agio_type -- 折扣率计算方式
    ,o.open_time -- 开市时间
    ,o.close_time -- 闭市时间
    ,o.paper_no -- 产品适合度试卷编号
    ,o.paper_name -- 产品适合度试卷名称
    ,o.protocol_name -- 产品协议书名称
    ,o.psub_unit -- 个人最小购买单位
    ,o.pfirst_amt -- 个人首次最低投资金额
    ,o.papp_amt -- 个人追加最低投资金额
    ,o.pmin_invest_amt -- 个人最低定投金额
    ,o.pmin_hold -- 个人最低持有份额
    ,o.pmin_red -- 个人单笔最少赎回份额
    ,o.pmax_red -- 个人单笔最大赎回份额
    ,o.pred_unit -- 个人赎回单位
    ,o.pmin_conv_vol -- 个人最低基金转换份额
    ,o.pmin_red_vol -- 个人最低定赎份额
    ,o.pmax_amt -- 个人单笔最大购买金额
    ,o.pmax_accu_amt -- 个人单户累计最大购买金额#
    ,o.osub_unit -- 机构最小购买单位
    ,o.ofirst_amt -- 机构首次最低投资金额
    ,o.oapp_amt -- 机构追加最低投资金额
    ,o.omin_invest_amt -- 机构最低定投金额
    ,o.omin_hold -- 机构最低持有份额
    ,o.omin_red -- 机构单笔最小赎回份额
    ,o.omax_red -- 机构单笔最大赎回份额
    ,o.ored_unit -- 机构赎回单位
    ,o.omin_conv_vol -- 机构最低基金转换份额
    ,o.omin_red_vol -- 机构最低定赎份额
    ,o.omax_amt -- 机构单笔最大购买金额
    ,o.omax_accu_amt -- 机构单户累计最大购买金额#
    ,o.tot_client -- 累计购买客户数
    ,o.ipo_time -- 募集开始时间
    ,o.order_date -- 预约购买开始日期
    ,o.order_time -- 预约购买开始时间
    ,o.book_buy_days -- 客户预约购买最大允许提前天数
    ,o.book_sell_days -- 客户预约赎回最大允许提前天数
    ,o.book_buy_date -- 银行指定预约购买受理日
    ,o.book_sell_date -- 银行指定预约赎回受理日
    ,o.dir_order_type -- 定向预约模式
    ,o.dir_hold_day -- 定向预约有效天数
    ,o.dir_free_date -- 定向预约释放日期
    ,o.dir_start_date -- 定向预约开始日期
    ,o.dir_start_time -- 定向预约开始时间
    ,o.invest_fail_times -- 定投失败次数
    ,o.debit_account -- 认申购账号
    ,o.crebit_account -- 赎回账号
    ,o.red_draw_account -- 实时赎回垫支帐号
    ,o.charge_account -- 手续费分配账号
    ,o.manage_account -- 管理费分配账号
    ,o.red_days -- 赎回资金到帐天数
    ,o.div_days -- 分红资金到帐天数
    ,o.refund_days -- 产品到期资金到帐天数
    ,o.fail_days -- 发行失败/比例退款天数
    ,o.open_buy_days -- 申购失败资金到帐延迟天数
    ,o.red_arr_date -- 赎回资金到帐日期
    ,o.div_arr_date -- 分红资金到帐日期
    ,o.refund_arr_date -- 产品到期资金到帐日期
    ,o.fail_arr_date -- 发行失败/比例退款到帐日期
    ,o.open_arr_date -- 申购失败资金到帐延迟日期
    ,o.large_buy_rate -- 超额申购比例#
    ,o.large_red_rate -- 巨额赎回比例#
    ,o.real_red_amt_rate -- 实时赎回资金比例
    ,o.real_red_vol_rate -- 当日实时赎回份额比例上限#
    ,o.real_red_max_vol -- 当日实时赎回份额上限
    ,o.base_days -- 产品计息基数#
    ,o.interest_days -- 认购利息计息基数#
    ,o.manage_days -- 管理费基础天数#
    ,o.red_fare_rate -- 赎回费归基金资产比例#
    ,o.conv_fare_rate -- 转换费归基金资产比例#
    ,o.manage_rate -- 管理费计提比例#
    ,o.total_bonus -- 累计单位分红#
    ,o.cash_rate -- 货币式产品收益兑付频率
    ,o.money_date -- 货币产品收益兑付日期#
    ,o.corpus_rate -- 保本比例#
    ,o.evend_date -- 保本到期日#
    ,o.tn_confirm -- 所有业务清算延后天数#
    ,o.guest_rate -- 预期收益率#
    ,o.cycle_days -- 周期天数#
    ,o.trans_way -- 交易方式
    ,o.int1 -- 备用整数1
    ,o.int2 -- 备用整数2
    ,o.amt1 -- 备用金额1
    ,o.amt2 -- 备用金额2
    ,o.amt3 -- 备用金额3
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.reserve3 -- 备注3
    ,o.reserve4 -- 备注4
    ,o.reserve5 -- 备注5
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tbproduct_bk o
    left join ${iol_schema}.nfss_tbproduct_op n
        on
            o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbproduct_cl d
        on
            o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nfss_tbproduct;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tbproduct exchange partition p_19000101 with table ${iol_schema}.nfss_tbproduct_cl;
alter table ${iol_schema}.nfss_tbproduct exchange partition p_20991231 with table ${iol_schema}.nfss_tbproduct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbproduct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbproduct_op purge;
drop table ${iol_schema}.nfss_tbproduct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbproduct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbproduct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
