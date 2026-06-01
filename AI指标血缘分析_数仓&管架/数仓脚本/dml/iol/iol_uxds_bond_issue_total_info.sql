/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_bond_issue_total_info
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
create table ${iol_schema}.uxds_bond_issue_total_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.uxds_bond_issue_total_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uxds_bond_issue_total_info_op purge;
drop table ${iol_schema}.uxds_bond_issue_total_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_bond_issue_total_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_bond_issue_total_info where 0=1;

create table ${iol_schema}.uxds_bond_issue_total_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_bond_issue_total_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uxds_bond_issue_total_info_cl(
            seq -- 记录唯一标识
            ,ctime -- 记录创建日期
            ,mtime -- 记录修改日期
            ,rtime -- 记录通讯到用户端日期
            ,bond_id -- 债券id
            ,announcement_date -- 公告日期
            ,issue_sd -- 发行起始日
            ,issue_ed -- 发行终止日
            ,plan_issue_total_vol -- 计划发行总量
            ,actual_issue_total_vol -- 实际发行总量
            ,issue_price -- 发行价格
            ,payment_date -- 缴款截止日
            ,cashing_commi_rate -- 兑付手续费率
            ,issue_method_code -- 发行方式编码
            ,issue_method -- 发行方式
            ,issue_object -- 发行对象
            ,distribution_method -- 分销方式
            ,distribution_object -- 分销对象
            ,competitive_bidding_amount -- 竞争性招标额
            ,basic_underwriting -- 基本承销额
            ,actual_rc_amt -- 实际募资金额
            ,total_issue_fee -- 发行费用总额
            ,underwriting_method_code -- 承销方式编码
            ,underwriting_method -- 承销方式
            ,online_pur_date -- 网上申购日期
            ,offline_subscription_date -- 网下认购日期
            ,online_pur_code -- 网上申购代码
            ,online_pur_short_name -- 网上申购简称
            ,orig_holders_place_amt_online -- 原股东每股获配金额
            ,offline_allocated_amt -- 网下获配金额
            ,online_issue_vol -- 网上发售数量
            ,online_issue_lottery_ratio -- 网上发售中签率
            ,offline_place_ratio -- 网下配售比例
            ,callback_mode_code -- 回拨方式编码
            ,callback_mode -- 回拨方式
            ,callback_num -- 回拨数量
            ,issue_fee_rate -- 发行费率
            ,online_release_deadline -- 上网发行截止日期
            ,online_issue_pur_limit_explain -- 网上发行认购数量限制说明
            ,listing_ad -- 上市公告日
            ,iec_passed_ad -- 审委审核通过公告日
            ,fore_issue_cost -- 预计发行费用
            ,orig_holders_place_date -- 原股东配售日期
            ,orig_holders_place_equity_rd -- 原股东配售股权登记日
            ,orig_holders_place_code -- 原股东配售代码
            ,orig_holders_place_short_name -- 原股东配售简称
            ,orig_holders_place_explain -- 原股东配售说明
            ,online_issue_pur_price -- 网上发行申购价格
            ,issue_result_ad -- 发行结果公告日
            ,orig_ls_shareholder_purchase -- 原限售股股东配购数量
            ,holder_prfr_allot_num -- 无限售股股东优先配售数量
            ,online_valid_pur_people_num -- 网上有效申购户数
            ,online_valid_pur_num -- 网上有效申购数量
            ,offline_valid_pur_account_num -- 网下有效申购户数
            ,offline_valid_pur_num -- 网下有效申购数量
            ,underwriting_sponsor_fee -- 承销保荐费用
            ,underwrite_balance -- 包销余额
            ,issue_cost_explain -- 发行费用说明
            ,offline_issue_sd -- 网下发行截止日期
            ,online_pur_quantity_dl -- 网上申购数量下限
            ,online_pur_quantity_ul -- 网上申购数量上限
            ,online_pur_quantity_unit -- 网上申购数量单位
            ,offline_pur_vol_dl -- 网下申购数量下限
            ,offline_pur_vol_ul -- 网下申购数量上限
            ,offline_pur_unit -- 网下申购数量单位
            ,offline_pur_font_money_ratio -- 网下申购定金比例
            ,online_pur_fund_unfreeze_date -- 网上申购资金解冻日
            ,offline_purcapital_unfrz_date -- 网下申购资金解冻日
            ,add_issue_total_vol -- 追加发行总量
            ,distribution_sd -- 分销起始日期
            ,distribution_ed -- 分销截至日期
            ,funds_to_account_confirm_time -- 资金到帐确认时间
            ,bond_transfer_time -- 债券过户时间
            ,basic_uw_add_contract_fee_rate -- 基本承销额附加承揽费率
            ,contract_fee_rate -- 承揽费率
            ,ib_financing_tool_reg_info_num -- 银行间债务融资工具注册信息记录号
            ,cb_issue_plan_record_num -- 可转债发行预案记录号
            ,currency_code -- 货币代码
            ,currency_name -- 货币名称
            ,rc_usage -- 募集资金用途
            ,old_holder_place_payment_date -- 老股东配售缴款日
            ,online_issue_allot_total_num -- 上网发行配号总数
            ,float_holder_place_amount -- 流通股股东可配售金额
            ,issue_status -- 发行状态
            ,nafmii_accept_reg_notice_num -- 交易商协会接受注册公告编号
            ,corp_bond_issue_reg_info_num -- 企业债券发行注册信息记录号
            ,offline_issue_lot_winning_num -- 网上中签号码
            ,accountant_fee -- 会计师费用
            ,repayment_order -- 偿付顺序
            ,issue_number -- 发行期号
            ,lawyer_fee -- 律师费用
            ,valid_bid_purchase_num -- 有效投标(申购)家数
            ,payment_sd -- 缴款起始日
            ,online_win_result_ad -- 网上中签结果公告日
            ,issue_total_amt -- 发行总额
            ,exchange_debt_issue_plan_num -- 可交换债发行预案记录号
            ,book_building_date -- 簿记建档日
            ,valid_purpurchase_amt -- 有效申购金额
            ,max_purchase_rate -- 最高申购利率
            ,min_purchase_rate -- 最低申购利率
            ,compliance_purchase_amt -- 合规申购金额
            ,compliance_purchase_num -- 合规申购家数
            ,full_field_multiplier -- 全场倍数
            ,wgt_bid_interest -- 加权中标利率
            ,marginal_multiple -- 边际倍数
            ,marginal_rate -- 边际利率
            ,csrc_bond_approval_reply_num -- 证监会债券核准批复记录号
            ,amount_ul_to_be_issued -- 计划发行金额上限
            ,amount_ll_to_be_issued -- 计划发行金额下限
            ,bounce_trigger_multiple -- 上弹触发倍数
            ,down_trigger_multiple -- 下弹触发倍数
            ,compulsory_trigger_multiple -- 强制触发倍数
            ,book_building_ed -- 簿记建档截止日
            ,issue_sd_announce -- 发行起始日(公告)
            ,min_purchase_price -- 最低申购价位
            ,max_purchase_price -- 最高申购价位
            ,issue_structure -- 发行结构
            ,issue_structure_code -- 发行结构编码
            ,issue_rule -- 发行规则
            ,issue_rule_code -- 发行规则编码
            ,orig_lh_valid_pur_num -- 原限售股股东有效申购数量
            ,unlimit_holder_valid_pur_num -- 无限售股股东有效申购数量
            ,old_holder_pur_account_num -- 老股东申购户数
            ,emission_reduction_benefits -- 减排效益
            ,csrc_bond_approval_number -- 证监会债券核准批复文号
            ,exchg_confirm_file_symbol -- 交易所确认文件文号
            ,cbirc_bond_approval_number -- 银保监会债券批复文号
            ,kpi -- 关键绩效指标
            ,spt -- 可持续发展绩效目标
            ,main_undwt_amount -- 主承销商包销金额
            ,main_undwt_ratio -- 主承销商包销比例
            ,joint_main_undwt_amount -- 联席主承销商包销金额
            ,joint_undwt_ratio -- 联席主承销商包销比例
            ,debt_credit_reg_date -- 债权债务登记日
            ,multiple -- 认购倍数
            ,isvalid -- 是否有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uxds_bond_issue_total_info_op(
            seq -- 记录唯一标识
            ,ctime -- 记录创建日期
            ,mtime -- 记录修改日期
            ,rtime -- 记录通讯到用户端日期
            ,bond_id -- 债券id
            ,announcement_date -- 公告日期
            ,issue_sd -- 发行起始日
            ,issue_ed -- 发行终止日
            ,plan_issue_total_vol -- 计划发行总量
            ,actual_issue_total_vol -- 实际发行总量
            ,issue_price -- 发行价格
            ,payment_date -- 缴款截止日
            ,cashing_commi_rate -- 兑付手续费率
            ,issue_method_code -- 发行方式编码
            ,issue_method -- 发行方式
            ,issue_object -- 发行对象
            ,distribution_method -- 分销方式
            ,distribution_object -- 分销对象
            ,competitive_bidding_amount -- 竞争性招标额
            ,basic_underwriting -- 基本承销额
            ,actual_rc_amt -- 实际募资金额
            ,total_issue_fee -- 发行费用总额
            ,underwriting_method_code -- 承销方式编码
            ,underwriting_method -- 承销方式
            ,online_pur_date -- 网上申购日期
            ,offline_subscription_date -- 网下认购日期
            ,online_pur_code -- 网上申购代码
            ,online_pur_short_name -- 网上申购简称
            ,orig_holders_place_amt_online -- 原股东每股获配金额
            ,offline_allocated_amt -- 网下获配金额
            ,online_issue_vol -- 网上发售数量
            ,online_issue_lottery_ratio -- 网上发售中签率
            ,offline_place_ratio -- 网下配售比例
            ,callback_mode_code -- 回拨方式编码
            ,callback_mode -- 回拨方式
            ,callback_num -- 回拨数量
            ,issue_fee_rate -- 发行费率
            ,online_release_deadline -- 上网发行截止日期
            ,online_issue_pur_limit_explain -- 网上发行认购数量限制说明
            ,listing_ad -- 上市公告日
            ,iec_passed_ad -- 审委审核通过公告日
            ,fore_issue_cost -- 预计发行费用
            ,orig_holders_place_date -- 原股东配售日期
            ,orig_holders_place_equity_rd -- 原股东配售股权登记日
            ,orig_holders_place_code -- 原股东配售代码
            ,orig_holders_place_short_name -- 原股东配售简称
            ,orig_holders_place_explain -- 原股东配售说明
            ,online_issue_pur_price -- 网上发行申购价格
            ,issue_result_ad -- 发行结果公告日
            ,orig_ls_shareholder_purchase -- 原限售股股东配购数量
            ,holder_prfr_allot_num -- 无限售股股东优先配售数量
            ,online_valid_pur_people_num -- 网上有效申购户数
            ,online_valid_pur_num -- 网上有效申购数量
            ,offline_valid_pur_account_num -- 网下有效申购户数
            ,offline_valid_pur_num -- 网下有效申购数量
            ,underwriting_sponsor_fee -- 承销保荐费用
            ,underwrite_balance -- 包销余额
            ,issue_cost_explain -- 发行费用说明
            ,offline_issue_sd -- 网下发行截止日期
            ,online_pur_quantity_dl -- 网上申购数量下限
            ,online_pur_quantity_ul -- 网上申购数量上限
            ,online_pur_quantity_unit -- 网上申购数量单位
            ,offline_pur_vol_dl -- 网下申购数量下限
            ,offline_pur_vol_ul -- 网下申购数量上限
            ,offline_pur_unit -- 网下申购数量单位
            ,offline_pur_font_money_ratio -- 网下申购定金比例
            ,online_pur_fund_unfreeze_date -- 网上申购资金解冻日
            ,offline_purcapital_unfrz_date -- 网下申购资金解冻日
            ,add_issue_total_vol -- 追加发行总量
            ,distribution_sd -- 分销起始日期
            ,distribution_ed -- 分销截至日期
            ,funds_to_account_confirm_time -- 资金到帐确认时间
            ,bond_transfer_time -- 债券过户时间
            ,basic_uw_add_contract_fee_rate -- 基本承销额附加承揽费率
            ,contract_fee_rate -- 承揽费率
            ,ib_financing_tool_reg_info_num -- 银行间债务融资工具注册信息记录号
            ,cb_issue_plan_record_num -- 可转债发行预案记录号
            ,currency_code -- 货币代码
            ,currency_name -- 货币名称
            ,rc_usage -- 募集资金用途
            ,old_holder_place_payment_date -- 老股东配售缴款日
            ,online_issue_allot_total_num -- 上网发行配号总数
            ,float_holder_place_amount -- 流通股股东可配售金额
            ,issue_status -- 发行状态
            ,nafmii_accept_reg_notice_num -- 交易商协会接受注册公告编号
            ,corp_bond_issue_reg_info_num -- 企业债券发行注册信息记录号
            ,offline_issue_lot_winning_num -- 网上中签号码
            ,accountant_fee -- 会计师费用
            ,repayment_order -- 偿付顺序
            ,issue_number -- 发行期号
            ,lawyer_fee -- 律师费用
            ,valid_bid_purchase_num -- 有效投标(申购)家数
            ,payment_sd -- 缴款起始日
            ,online_win_result_ad -- 网上中签结果公告日
            ,issue_total_amt -- 发行总额
            ,exchange_debt_issue_plan_num -- 可交换债发行预案记录号
            ,book_building_date -- 簿记建档日
            ,valid_purpurchase_amt -- 有效申购金额
            ,max_purchase_rate -- 最高申购利率
            ,min_purchase_rate -- 最低申购利率
            ,compliance_purchase_amt -- 合规申购金额
            ,compliance_purchase_num -- 合规申购家数
            ,full_field_multiplier -- 全场倍数
            ,wgt_bid_interest -- 加权中标利率
            ,marginal_multiple -- 边际倍数
            ,marginal_rate -- 边际利率
            ,csrc_bond_approval_reply_num -- 证监会债券核准批复记录号
            ,amount_ul_to_be_issued -- 计划发行金额上限
            ,amount_ll_to_be_issued -- 计划发行金额下限
            ,bounce_trigger_multiple -- 上弹触发倍数
            ,down_trigger_multiple -- 下弹触发倍数
            ,compulsory_trigger_multiple -- 强制触发倍数
            ,book_building_ed -- 簿记建档截止日
            ,issue_sd_announce -- 发行起始日(公告)
            ,min_purchase_price -- 最低申购价位
            ,max_purchase_price -- 最高申购价位
            ,issue_structure -- 发行结构
            ,issue_structure_code -- 发行结构编码
            ,issue_rule -- 发行规则
            ,issue_rule_code -- 发行规则编码
            ,orig_lh_valid_pur_num -- 原限售股股东有效申购数量
            ,unlimit_holder_valid_pur_num -- 无限售股股东有效申购数量
            ,old_holder_pur_account_num -- 老股东申购户数
            ,emission_reduction_benefits -- 减排效益
            ,csrc_bond_approval_number -- 证监会债券核准批复文号
            ,exchg_confirm_file_symbol -- 交易所确认文件文号
            ,cbirc_bond_approval_number -- 银保监会债券批复文号
            ,kpi -- 关键绩效指标
            ,spt -- 可持续发展绩效目标
            ,main_undwt_amount -- 主承销商包销金额
            ,main_undwt_ratio -- 主承销商包销比例
            ,joint_main_undwt_amount -- 联席主承销商包销金额
            ,joint_undwt_ratio -- 联席主承销商包销比例
            ,debt_credit_reg_date -- 债权债务登记日
            ,multiple -- 认购倍数
            ,isvalid -- 是否有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seq, o.seq) as seq -- 记录唯一标识
    ,nvl(n.ctime, o.ctime) as ctime -- 记录创建日期
    ,nvl(n.mtime, o.mtime) as mtime -- 记录修改日期
    ,nvl(n.rtime, o.rtime) as rtime -- 记录通讯到用户端日期
    ,nvl(n.bond_id, o.bond_id) as bond_id -- 债券id
    ,nvl(n.announcement_date, o.announcement_date) as announcement_date -- 公告日期
    ,nvl(n.issue_sd, o.issue_sd) as issue_sd -- 发行起始日
    ,nvl(n.issue_ed, o.issue_ed) as issue_ed -- 发行终止日
    ,nvl(n.plan_issue_total_vol, o.plan_issue_total_vol) as plan_issue_total_vol -- 计划发行总量
    ,nvl(n.actual_issue_total_vol, o.actual_issue_total_vol) as actual_issue_total_vol -- 实际发行总量
    ,nvl(n.issue_price, o.issue_price) as issue_price -- 发行价格
    ,nvl(n.payment_date, o.payment_date) as payment_date -- 缴款截止日
    ,nvl(n.cashing_commi_rate, o.cashing_commi_rate) as cashing_commi_rate -- 兑付手续费率
    ,nvl(n.issue_method_code, o.issue_method_code) as issue_method_code -- 发行方式编码
    ,nvl(n.issue_method, o.issue_method) as issue_method -- 发行方式
    ,nvl(n.issue_object, o.issue_object) as issue_object -- 发行对象
    ,nvl(n.distribution_method, o.distribution_method) as distribution_method -- 分销方式
    ,nvl(n.distribution_object, o.distribution_object) as distribution_object -- 分销对象
    ,nvl(n.competitive_bidding_amount, o.competitive_bidding_amount) as competitive_bidding_amount -- 竞争性招标额
    ,nvl(n.basic_underwriting, o.basic_underwriting) as basic_underwriting -- 基本承销额
    ,nvl(n.actual_rc_amt, o.actual_rc_amt) as actual_rc_amt -- 实际募资金额
    ,nvl(n.total_issue_fee, o.total_issue_fee) as total_issue_fee -- 发行费用总额
    ,nvl(n.underwriting_method_code, o.underwriting_method_code) as underwriting_method_code -- 承销方式编码
    ,nvl(n.underwriting_method, o.underwriting_method) as underwriting_method -- 承销方式
    ,nvl(n.online_pur_date, o.online_pur_date) as online_pur_date -- 网上申购日期
    ,nvl(n.offline_subscription_date, o.offline_subscription_date) as offline_subscription_date -- 网下认购日期
    ,nvl(n.online_pur_code, o.online_pur_code) as online_pur_code -- 网上申购代码
    ,nvl(n.online_pur_short_name, o.online_pur_short_name) as online_pur_short_name -- 网上申购简称
    ,nvl(n.orig_holders_place_amt_online, o.orig_holders_place_amt_online) as orig_holders_place_amt_online -- 原股东每股获配金额
    ,nvl(n.offline_allocated_amt, o.offline_allocated_amt) as offline_allocated_amt -- 网下获配金额
    ,nvl(n.online_issue_vol, o.online_issue_vol) as online_issue_vol -- 网上发售数量
    ,nvl(n.online_issue_lottery_ratio, o.online_issue_lottery_ratio) as online_issue_lottery_ratio -- 网上发售中签率
    ,nvl(n.offline_place_ratio, o.offline_place_ratio) as offline_place_ratio -- 网下配售比例
    ,nvl(n.callback_mode_code, o.callback_mode_code) as callback_mode_code -- 回拨方式编码
    ,nvl(n.callback_mode, o.callback_mode) as callback_mode -- 回拨方式
    ,nvl(n.callback_num, o.callback_num) as callback_num -- 回拨数量
    ,nvl(n.issue_fee_rate, o.issue_fee_rate) as issue_fee_rate -- 发行费率
    ,nvl(n.online_release_deadline, o.online_release_deadline) as online_release_deadline -- 上网发行截止日期
    ,nvl(n.online_issue_pur_limit_explain, o.online_issue_pur_limit_explain) as online_issue_pur_limit_explain -- 网上发行认购数量限制说明
    ,nvl(n.listing_ad, o.listing_ad) as listing_ad -- 上市公告日
    ,nvl(n.iec_passed_ad, o.iec_passed_ad) as iec_passed_ad -- 审委审核通过公告日
    ,nvl(n.fore_issue_cost, o.fore_issue_cost) as fore_issue_cost -- 预计发行费用
    ,nvl(n.orig_holders_place_date, o.orig_holders_place_date) as orig_holders_place_date -- 原股东配售日期
    ,nvl(n.orig_holders_place_equity_rd, o.orig_holders_place_equity_rd) as orig_holders_place_equity_rd -- 原股东配售股权登记日
    ,nvl(n.orig_holders_place_code, o.orig_holders_place_code) as orig_holders_place_code -- 原股东配售代码
    ,nvl(n.orig_holders_place_short_name, o.orig_holders_place_short_name) as orig_holders_place_short_name -- 原股东配售简称
    ,nvl(n.orig_holders_place_explain, o.orig_holders_place_explain) as orig_holders_place_explain -- 原股东配售说明
    ,nvl(n.online_issue_pur_price, o.online_issue_pur_price) as online_issue_pur_price -- 网上发行申购价格
    ,nvl(n.issue_result_ad, o.issue_result_ad) as issue_result_ad -- 发行结果公告日
    ,nvl(n.orig_ls_shareholder_purchase, o.orig_ls_shareholder_purchase) as orig_ls_shareholder_purchase -- 原限售股股东配购数量
    ,nvl(n.holder_prfr_allot_num, o.holder_prfr_allot_num) as holder_prfr_allot_num -- 无限售股股东优先配售数量
    ,nvl(n.online_valid_pur_people_num, o.online_valid_pur_people_num) as online_valid_pur_people_num -- 网上有效申购户数
    ,nvl(n.online_valid_pur_num, o.online_valid_pur_num) as online_valid_pur_num -- 网上有效申购数量
    ,nvl(n.offline_valid_pur_account_num, o.offline_valid_pur_account_num) as offline_valid_pur_account_num -- 网下有效申购户数
    ,nvl(n.offline_valid_pur_num, o.offline_valid_pur_num) as offline_valid_pur_num -- 网下有效申购数量
    ,nvl(n.underwriting_sponsor_fee, o.underwriting_sponsor_fee) as underwriting_sponsor_fee -- 承销保荐费用
    ,nvl(n.underwrite_balance, o.underwrite_balance) as underwrite_balance -- 包销余额
    ,nvl(n.issue_cost_explain, o.issue_cost_explain) as issue_cost_explain -- 发行费用说明
    ,nvl(n.offline_issue_sd, o.offline_issue_sd) as offline_issue_sd -- 网下发行截止日期
    ,nvl(n.online_pur_quantity_dl, o.online_pur_quantity_dl) as online_pur_quantity_dl -- 网上申购数量下限
    ,nvl(n.online_pur_quantity_ul, o.online_pur_quantity_ul) as online_pur_quantity_ul -- 网上申购数量上限
    ,nvl(n.online_pur_quantity_unit, o.online_pur_quantity_unit) as online_pur_quantity_unit -- 网上申购数量单位
    ,nvl(n.offline_pur_vol_dl, o.offline_pur_vol_dl) as offline_pur_vol_dl -- 网下申购数量下限
    ,nvl(n.offline_pur_vol_ul, o.offline_pur_vol_ul) as offline_pur_vol_ul -- 网下申购数量上限
    ,nvl(n.offline_pur_unit, o.offline_pur_unit) as offline_pur_unit -- 网下申购数量单位
    ,nvl(n.offline_pur_font_money_ratio, o.offline_pur_font_money_ratio) as offline_pur_font_money_ratio -- 网下申购定金比例
    ,nvl(n.online_pur_fund_unfreeze_date, o.online_pur_fund_unfreeze_date) as online_pur_fund_unfreeze_date -- 网上申购资金解冻日
    ,nvl(n.offline_purcapital_unfrz_date, o.offline_purcapital_unfrz_date) as offline_purcapital_unfrz_date -- 网下申购资金解冻日
    ,nvl(n.add_issue_total_vol, o.add_issue_total_vol) as add_issue_total_vol -- 追加发行总量
    ,nvl(n.distribution_sd, o.distribution_sd) as distribution_sd -- 分销起始日期
    ,nvl(n.distribution_ed, o.distribution_ed) as distribution_ed -- 分销截至日期
    ,nvl(n.funds_to_account_confirm_time, o.funds_to_account_confirm_time) as funds_to_account_confirm_time -- 资金到帐确认时间
    ,nvl(n.bond_transfer_time, o.bond_transfer_time) as bond_transfer_time -- 债券过户时间
    ,nvl(n.basic_uw_add_contract_fee_rate, o.basic_uw_add_contract_fee_rate) as basic_uw_add_contract_fee_rate -- 基本承销额附加承揽费率
    ,nvl(n.contract_fee_rate, o.contract_fee_rate) as contract_fee_rate -- 承揽费率
    ,nvl(n.ib_financing_tool_reg_info_num, o.ib_financing_tool_reg_info_num) as ib_financing_tool_reg_info_num -- 银行间债务融资工具注册信息记录号
    ,nvl(n.cb_issue_plan_record_num, o.cb_issue_plan_record_num) as cb_issue_plan_record_num -- 可转债发行预案记录号
    ,nvl(n.currency_code, o.currency_code) as currency_code -- 货币代码
    ,nvl(n.currency_name, o.currency_name) as currency_name -- 货币名称
    ,nvl(n.rc_usage, o.rc_usage) as rc_usage -- 募集资金用途
    ,nvl(n.old_holder_place_payment_date, o.old_holder_place_payment_date) as old_holder_place_payment_date -- 老股东配售缴款日
    ,nvl(n.online_issue_allot_total_num, o.online_issue_allot_total_num) as online_issue_allot_total_num -- 上网发行配号总数
    ,nvl(n.float_holder_place_amount, o.float_holder_place_amount) as float_holder_place_amount -- 流通股股东可配售金额
    ,nvl(n.issue_status, o.issue_status) as issue_status -- 发行状态
    ,nvl(n.nafmii_accept_reg_notice_num, o.nafmii_accept_reg_notice_num) as nafmii_accept_reg_notice_num -- 交易商协会接受注册公告编号
    ,nvl(n.corp_bond_issue_reg_info_num, o.corp_bond_issue_reg_info_num) as corp_bond_issue_reg_info_num -- 企业债券发行注册信息记录号
    ,nvl(n.offline_issue_lot_winning_num, o.offline_issue_lot_winning_num) as offline_issue_lot_winning_num -- 网上中签号码
    ,nvl(n.accountant_fee, o.accountant_fee) as accountant_fee -- 会计师费用
    ,nvl(n.repayment_order, o.repayment_order) as repayment_order -- 偿付顺序
    ,nvl(n.issue_number, o.issue_number) as issue_number -- 发行期号
    ,nvl(n.lawyer_fee, o.lawyer_fee) as lawyer_fee -- 律师费用
    ,nvl(n.valid_bid_purchase_num, o.valid_bid_purchase_num) as valid_bid_purchase_num -- 有效投标(申购)家数
    ,nvl(n.payment_sd, o.payment_sd) as payment_sd -- 缴款起始日
    ,nvl(n.online_win_result_ad, o.online_win_result_ad) as online_win_result_ad -- 网上中签结果公告日
    ,nvl(n.issue_total_amt, o.issue_total_amt) as issue_total_amt -- 发行总额
    ,nvl(n.exchange_debt_issue_plan_num, o.exchange_debt_issue_plan_num) as exchange_debt_issue_plan_num -- 可交换债发行预案记录号
    ,nvl(n.book_building_date, o.book_building_date) as book_building_date -- 簿记建档日
    ,nvl(n.valid_purpurchase_amt, o.valid_purpurchase_amt) as valid_purpurchase_amt -- 有效申购金额
    ,nvl(n.max_purchase_rate, o.max_purchase_rate) as max_purchase_rate -- 最高申购利率
    ,nvl(n.min_purchase_rate, o.min_purchase_rate) as min_purchase_rate -- 最低申购利率
    ,nvl(n.compliance_purchase_amt, o.compliance_purchase_amt) as compliance_purchase_amt -- 合规申购金额
    ,nvl(n.compliance_purchase_num, o.compliance_purchase_num) as compliance_purchase_num -- 合规申购家数
    ,nvl(n.full_field_multiplier, o.full_field_multiplier) as full_field_multiplier -- 全场倍数
    ,nvl(n.wgt_bid_interest, o.wgt_bid_interest) as wgt_bid_interest -- 加权中标利率
    ,nvl(n.marginal_multiple, o.marginal_multiple) as marginal_multiple -- 边际倍数
    ,nvl(n.marginal_rate, o.marginal_rate) as marginal_rate -- 边际利率
    ,nvl(n.csrc_bond_approval_reply_num, o.csrc_bond_approval_reply_num) as csrc_bond_approval_reply_num -- 证监会债券核准批复记录号
    ,nvl(n.amount_ul_to_be_issued, o.amount_ul_to_be_issued) as amount_ul_to_be_issued -- 计划发行金额上限
    ,nvl(n.amount_ll_to_be_issued, o.amount_ll_to_be_issued) as amount_ll_to_be_issued -- 计划发行金额下限
    ,nvl(n.bounce_trigger_multiple, o.bounce_trigger_multiple) as bounce_trigger_multiple -- 上弹触发倍数
    ,nvl(n.down_trigger_multiple, o.down_trigger_multiple) as down_trigger_multiple -- 下弹触发倍数
    ,nvl(n.compulsory_trigger_multiple, o.compulsory_trigger_multiple) as compulsory_trigger_multiple -- 强制触发倍数
    ,nvl(n.book_building_ed, o.book_building_ed) as book_building_ed -- 簿记建档截止日
    ,nvl(n.issue_sd_announce, o.issue_sd_announce) as issue_sd_announce -- 发行起始日(公告)
    ,nvl(n.min_purchase_price, o.min_purchase_price) as min_purchase_price -- 最低申购价位
    ,nvl(n.max_purchase_price, o.max_purchase_price) as max_purchase_price -- 最高申购价位
    ,nvl(n.issue_structure, o.issue_structure) as issue_structure -- 发行结构
    ,nvl(n.issue_structure_code, o.issue_structure_code) as issue_structure_code -- 发行结构编码
    ,nvl(n.issue_rule, o.issue_rule) as issue_rule -- 发行规则
    ,nvl(n.issue_rule_code, o.issue_rule_code) as issue_rule_code -- 发行规则编码
    ,nvl(n.orig_lh_valid_pur_num, o.orig_lh_valid_pur_num) as orig_lh_valid_pur_num -- 原限售股股东有效申购数量
    ,nvl(n.unlimit_holder_valid_pur_num, o.unlimit_holder_valid_pur_num) as unlimit_holder_valid_pur_num -- 无限售股股东有效申购数量
    ,nvl(n.old_holder_pur_account_num, o.old_holder_pur_account_num) as old_holder_pur_account_num -- 老股东申购户数
    ,nvl(n.emission_reduction_benefits, o.emission_reduction_benefits) as emission_reduction_benefits -- 减排效益
    ,nvl(n.csrc_bond_approval_number, o.csrc_bond_approval_number) as csrc_bond_approval_number -- 证监会债券核准批复文号
    ,nvl(n.exchg_confirm_file_symbol, o.exchg_confirm_file_symbol) as exchg_confirm_file_symbol -- 交易所确认文件文号
    ,nvl(n.cbirc_bond_approval_number, o.cbirc_bond_approval_number) as cbirc_bond_approval_number -- 银保监会债券批复文号
    ,nvl(n.kpi, o.kpi) as kpi -- 关键绩效指标
    ,nvl(n.spt, o.spt) as spt -- 可持续发展绩效目标
    ,nvl(n.main_undwt_amount, o.main_undwt_amount) as main_undwt_amount -- 主承销商包销金额
    ,nvl(n.main_undwt_ratio, o.main_undwt_ratio) as main_undwt_ratio -- 主承销商包销比例
    ,nvl(n.joint_main_undwt_amount, o.joint_main_undwt_amount) as joint_main_undwt_amount -- 联席主承销商包销金额
    ,nvl(n.joint_undwt_ratio, o.joint_undwt_ratio) as joint_undwt_ratio -- 联席主承销商包销比例
    ,nvl(n.debt_credit_reg_date, o.debt_credit_reg_date) as debt_credit_reg_date -- 债权债务登记日
    ,nvl(n.multiple, o.multiple) as multiple -- 认购倍数
    ,nvl(n.isvalid, o.isvalid) as isvalid -- 是否有效
    ,case when
            n.seq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.uxds_bond_issue_total_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.uxds_bond_issue_total_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq = n.seq
where (
        o.seq is null
    )
    or (
        n.seq is null
    )
    or (
        o.ctime <> n.ctime
        or o.mtime <> n.mtime
        or o.rtime <> n.rtime
        or o.bond_id <> n.bond_id
        or o.announcement_date <> n.announcement_date
        or o.issue_sd <> n.issue_sd
        or o.issue_ed <> n.issue_ed
        or o.plan_issue_total_vol <> n.plan_issue_total_vol
        or o.actual_issue_total_vol <> n.actual_issue_total_vol
        or o.issue_price <> n.issue_price
        or o.payment_date <> n.payment_date
        or o.cashing_commi_rate <> n.cashing_commi_rate
        or o.issue_method_code <> n.issue_method_code
        or o.issue_method <> n.issue_method
        or o.issue_object <> n.issue_object
        or o.distribution_method <> n.distribution_method
        or o.distribution_object <> n.distribution_object
        or o.competitive_bidding_amount <> n.competitive_bidding_amount
        or o.basic_underwriting <> n.basic_underwriting
        or o.actual_rc_amt <> n.actual_rc_amt
        or o.total_issue_fee <> n.total_issue_fee
        or o.underwriting_method_code <> n.underwriting_method_code
        or o.underwriting_method <> n.underwriting_method
        or o.online_pur_date <> n.online_pur_date
        or o.offline_subscription_date <> n.offline_subscription_date
        or o.online_pur_code <> n.online_pur_code
        or o.online_pur_short_name <> n.online_pur_short_name
        or o.orig_holders_place_amt_online <> n.orig_holders_place_amt_online
        or o.offline_allocated_amt <> n.offline_allocated_amt
        or o.online_issue_vol <> n.online_issue_vol
        or o.online_issue_lottery_ratio <> n.online_issue_lottery_ratio
        or o.offline_place_ratio <> n.offline_place_ratio
        or o.callback_mode_code <> n.callback_mode_code
        or o.callback_mode <> n.callback_mode
        or o.callback_num <> n.callback_num
        or o.issue_fee_rate <> n.issue_fee_rate
        or o.online_release_deadline <> n.online_release_deadline
        or o.online_issue_pur_limit_explain <> n.online_issue_pur_limit_explain
        or o.listing_ad <> n.listing_ad
        or o.iec_passed_ad <> n.iec_passed_ad
        or o.fore_issue_cost <> n.fore_issue_cost
        or o.orig_holders_place_date <> n.orig_holders_place_date
        or o.orig_holders_place_equity_rd <> n.orig_holders_place_equity_rd
        or o.orig_holders_place_code <> n.orig_holders_place_code
        or o.orig_holders_place_short_name <> n.orig_holders_place_short_name
        or o.orig_holders_place_explain <> n.orig_holders_place_explain
        or o.online_issue_pur_price <> n.online_issue_pur_price
        or o.issue_result_ad <> n.issue_result_ad
        or o.orig_ls_shareholder_purchase <> n.orig_ls_shareholder_purchase
        or o.holder_prfr_allot_num <> n.holder_prfr_allot_num
        or o.online_valid_pur_people_num <> n.online_valid_pur_people_num
        or o.online_valid_pur_num <> n.online_valid_pur_num
        or o.offline_valid_pur_account_num <> n.offline_valid_pur_account_num
        or o.offline_valid_pur_num <> n.offline_valid_pur_num
        or o.underwriting_sponsor_fee <> n.underwriting_sponsor_fee
        or o.underwrite_balance <> n.underwrite_balance
        or o.issue_cost_explain <> n.issue_cost_explain
        or o.offline_issue_sd <> n.offline_issue_sd
        or o.online_pur_quantity_dl <> n.online_pur_quantity_dl
        or o.online_pur_quantity_ul <> n.online_pur_quantity_ul
        or o.online_pur_quantity_unit <> n.online_pur_quantity_unit
        or o.offline_pur_vol_dl <> n.offline_pur_vol_dl
        or o.offline_pur_vol_ul <> n.offline_pur_vol_ul
        or o.offline_pur_unit <> n.offline_pur_unit
        or o.offline_pur_font_money_ratio <> n.offline_pur_font_money_ratio
        or o.online_pur_fund_unfreeze_date <> n.online_pur_fund_unfreeze_date
        or o.offline_purcapital_unfrz_date <> n.offline_purcapital_unfrz_date
        or o.add_issue_total_vol <> n.add_issue_total_vol
        or o.distribution_sd <> n.distribution_sd
        or o.distribution_ed <> n.distribution_ed
        or o.funds_to_account_confirm_time <> n.funds_to_account_confirm_time
        or o.bond_transfer_time <> n.bond_transfer_time
        or o.basic_uw_add_contract_fee_rate <> n.basic_uw_add_contract_fee_rate
        or o.contract_fee_rate <> n.contract_fee_rate
        or o.ib_financing_tool_reg_info_num <> n.ib_financing_tool_reg_info_num
        or o.cb_issue_plan_record_num <> n.cb_issue_plan_record_num
        or o.currency_code <> n.currency_code
        or o.currency_name <> n.currency_name
        or o.rc_usage <> n.rc_usage
        or o.old_holder_place_payment_date <> n.old_holder_place_payment_date
        or o.online_issue_allot_total_num <> n.online_issue_allot_total_num
        or o.float_holder_place_amount <> n.float_holder_place_amount
        or o.issue_status <> n.issue_status
        or o.nafmii_accept_reg_notice_num <> n.nafmii_accept_reg_notice_num
        or o.corp_bond_issue_reg_info_num <> n.corp_bond_issue_reg_info_num
        or o.offline_issue_lot_winning_num <> n.offline_issue_lot_winning_num
        or o.accountant_fee <> n.accountant_fee
        or o.repayment_order <> n.repayment_order
        or o.issue_number <> n.issue_number
        or o.lawyer_fee <> n.lawyer_fee
        or o.valid_bid_purchase_num <> n.valid_bid_purchase_num
        or o.payment_sd <> n.payment_sd
        or o.online_win_result_ad <> n.online_win_result_ad
        or o.issue_total_amt <> n.issue_total_amt
        or o.exchange_debt_issue_plan_num <> n.exchange_debt_issue_plan_num
        or o.book_building_date <> n.book_building_date
        or o.valid_purpurchase_amt <> n.valid_purpurchase_amt
        or o.max_purchase_rate <> n.max_purchase_rate
        or o.min_purchase_rate <> n.min_purchase_rate
        or o.compliance_purchase_amt <> n.compliance_purchase_amt
        or o.compliance_purchase_num <> n.compliance_purchase_num
        or o.full_field_multiplier <> n.full_field_multiplier
        or o.wgt_bid_interest <> n.wgt_bid_interest
        or o.marginal_multiple <> n.marginal_multiple
        or o.marginal_rate <> n.marginal_rate
        or o.csrc_bond_approval_reply_num <> n.csrc_bond_approval_reply_num
        or o.amount_ul_to_be_issued <> n.amount_ul_to_be_issued
        or o.amount_ll_to_be_issued <> n.amount_ll_to_be_issued
        or o.bounce_trigger_multiple <> n.bounce_trigger_multiple
        or o.down_trigger_multiple <> n.down_trigger_multiple
        or o.compulsory_trigger_multiple <> n.compulsory_trigger_multiple
        or o.book_building_ed <> n.book_building_ed
        or o.issue_sd_announce <> n.issue_sd_announce
        or o.min_purchase_price <> n.min_purchase_price
        or o.max_purchase_price <> n.max_purchase_price
        or o.issue_structure <> n.issue_structure
        or o.issue_structure_code <> n.issue_structure_code
        or o.issue_rule <> n.issue_rule
        or o.issue_rule_code <> n.issue_rule_code
        or o.orig_lh_valid_pur_num <> n.orig_lh_valid_pur_num
        or o.unlimit_holder_valid_pur_num <> n.unlimit_holder_valid_pur_num
        or o.old_holder_pur_account_num <> n.old_holder_pur_account_num
        or o.emission_reduction_benefits <> n.emission_reduction_benefits
        or o.csrc_bond_approval_number <> n.csrc_bond_approval_number
        or o.exchg_confirm_file_symbol <> n.exchg_confirm_file_symbol
        or o.cbirc_bond_approval_number <> n.cbirc_bond_approval_number
        or o.kpi <> n.kpi
        or o.spt <> n.spt
        or o.main_undwt_amount <> n.main_undwt_amount
        or o.main_undwt_ratio <> n.main_undwt_ratio
        or o.joint_main_undwt_amount <> n.joint_main_undwt_amount
        or o.joint_undwt_ratio <> n.joint_undwt_ratio
        or o.debt_credit_reg_date <> n.debt_credit_reg_date
        or o.multiple <> n.multiple
        or o.isvalid <> n.isvalid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uxds_bond_issue_total_info_cl(
            seq -- 记录唯一标识
            ,ctime -- 记录创建日期
            ,mtime -- 记录修改日期
            ,rtime -- 记录通讯到用户端日期
            ,bond_id -- 债券id
            ,announcement_date -- 公告日期
            ,issue_sd -- 发行起始日
            ,issue_ed -- 发行终止日
            ,plan_issue_total_vol -- 计划发行总量
            ,actual_issue_total_vol -- 实际发行总量
            ,issue_price -- 发行价格
            ,payment_date -- 缴款截止日
            ,cashing_commi_rate -- 兑付手续费率
            ,issue_method_code -- 发行方式编码
            ,issue_method -- 发行方式
            ,issue_object -- 发行对象
            ,distribution_method -- 分销方式
            ,distribution_object -- 分销对象
            ,competitive_bidding_amount -- 竞争性招标额
            ,basic_underwriting -- 基本承销额
            ,actual_rc_amt -- 实际募资金额
            ,total_issue_fee -- 发行费用总额
            ,underwriting_method_code -- 承销方式编码
            ,underwriting_method -- 承销方式
            ,online_pur_date -- 网上申购日期
            ,offline_subscription_date -- 网下认购日期
            ,online_pur_code -- 网上申购代码
            ,online_pur_short_name -- 网上申购简称
            ,orig_holders_place_amt_online -- 原股东每股获配金额
            ,offline_allocated_amt -- 网下获配金额
            ,online_issue_vol -- 网上发售数量
            ,online_issue_lottery_ratio -- 网上发售中签率
            ,offline_place_ratio -- 网下配售比例
            ,callback_mode_code -- 回拨方式编码
            ,callback_mode -- 回拨方式
            ,callback_num -- 回拨数量
            ,issue_fee_rate -- 发行费率
            ,online_release_deadline -- 上网发行截止日期
            ,online_issue_pur_limit_explain -- 网上发行认购数量限制说明
            ,listing_ad -- 上市公告日
            ,iec_passed_ad -- 审委审核通过公告日
            ,fore_issue_cost -- 预计发行费用
            ,orig_holders_place_date -- 原股东配售日期
            ,orig_holders_place_equity_rd -- 原股东配售股权登记日
            ,orig_holders_place_code -- 原股东配售代码
            ,orig_holders_place_short_name -- 原股东配售简称
            ,orig_holders_place_explain -- 原股东配售说明
            ,online_issue_pur_price -- 网上发行申购价格
            ,issue_result_ad -- 发行结果公告日
            ,orig_ls_shareholder_purchase -- 原限售股股东配购数量
            ,holder_prfr_allot_num -- 无限售股股东优先配售数量
            ,online_valid_pur_people_num -- 网上有效申购户数
            ,online_valid_pur_num -- 网上有效申购数量
            ,offline_valid_pur_account_num -- 网下有效申购户数
            ,offline_valid_pur_num -- 网下有效申购数量
            ,underwriting_sponsor_fee -- 承销保荐费用
            ,underwrite_balance -- 包销余额
            ,issue_cost_explain -- 发行费用说明
            ,offline_issue_sd -- 网下发行截止日期
            ,online_pur_quantity_dl -- 网上申购数量下限
            ,online_pur_quantity_ul -- 网上申购数量上限
            ,online_pur_quantity_unit -- 网上申购数量单位
            ,offline_pur_vol_dl -- 网下申购数量下限
            ,offline_pur_vol_ul -- 网下申购数量上限
            ,offline_pur_unit -- 网下申购数量单位
            ,offline_pur_font_money_ratio -- 网下申购定金比例
            ,online_pur_fund_unfreeze_date -- 网上申购资金解冻日
            ,offline_purcapital_unfrz_date -- 网下申购资金解冻日
            ,add_issue_total_vol -- 追加发行总量
            ,distribution_sd -- 分销起始日期
            ,distribution_ed -- 分销截至日期
            ,funds_to_account_confirm_time -- 资金到帐确认时间
            ,bond_transfer_time -- 债券过户时间
            ,basic_uw_add_contract_fee_rate -- 基本承销额附加承揽费率
            ,contract_fee_rate -- 承揽费率
            ,ib_financing_tool_reg_info_num -- 银行间债务融资工具注册信息记录号
            ,cb_issue_plan_record_num -- 可转债发行预案记录号
            ,currency_code -- 货币代码
            ,currency_name -- 货币名称
            ,rc_usage -- 募集资金用途
            ,old_holder_place_payment_date -- 老股东配售缴款日
            ,online_issue_allot_total_num -- 上网发行配号总数
            ,float_holder_place_amount -- 流通股股东可配售金额
            ,issue_status -- 发行状态
            ,nafmii_accept_reg_notice_num -- 交易商协会接受注册公告编号
            ,corp_bond_issue_reg_info_num -- 企业债券发行注册信息记录号
            ,offline_issue_lot_winning_num -- 网上中签号码
            ,accountant_fee -- 会计师费用
            ,repayment_order -- 偿付顺序
            ,issue_number -- 发行期号
            ,lawyer_fee -- 律师费用
            ,valid_bid_purchase_num -- 有效投标(申购)家数
            ,payment_sd -- 缴款起始日
            ,online_win_result_ad -- 网上中签结果公告日
            ,issue_total_amt -- 发行总额
            ,exchange_debt_issue_plan_num -- 可交换债发行预案记录号
            ,book_building_date -- 簿记建档日
            ,valid_purpurchase_amt -- 有效申购金额
            ,max_purchase_rate -- 最高申购利率
            ,min_purchase_rate -- 最低申购利率
            ,compliance_purchase_amt -- 合规申购金额
            ,compliance_purchase_num -- 合规申购家数
            ,full_field_multiplier -- 全场倍数
            ,wgt_bid_interest -- 加权中标利率
            ,marginal_multiple -- 边际倍数
            ,marginal_rate -- 边际利率
            ,csrc_bond_approval_reply_num -- 证监会债券核准批复记录号
            ,amount_ul_to_be_issued -- 计划发行金额上限
            ,amount_ll_to_be_issued -- 计划发行金额下限
            ,bounce_trigger_multiple -- 上弹触发倍数
            ,down_trigger_multiple -- 下弹触发倍数
            ,compulsory_trigger_multiple -- 强制触发倍数
            ,book_building_ed -- 簿记建档截止日
            ,issue_sd_announce -- 发行起始日(公告)
            ,min_purchase_price -- 最低申购价位
            ,max_purchase_price -- 最高申购价位
            ,issue_structure -- 发行结构
            ,issue_structure_code -- 发行结构编码
            ,issue_rule -- 发行规则
            ,issue_rule_code -- 发行规则编码
            ,orig_lh_valid_pur_num -- 原限售股股东有效申购数量
            ,unlimit_holder_valid_pur_num -- 无限售股股东有效申购数量
            ,old_holder_pur_account_num -- 老股东申购户数
            ,emission_reduction_benefits -- 减排效益
            ,csrc_bond_approval_number -- 证监会债券核准批复文号
            ,exchg_confirm_file_symbol -- 交易所确认文件文号
            ,cbirc_bond_approval_number -- 银保监会债券批复文号
            ,kpi -- 关键绩效指标
            ,spt -- 可持续发展绩效目标
            ,main_undwt_amount -- 主承销商包销金额
            ,main_undwt_ratio -- 主承销商包销比例
            ,joint_main_undwt_amount -- 联席主承销商包销金额
            ,joint_undwt_ratio -- 联席主承销商包销比例
            ,debt_credit_reg_date -- 债权债务登记日
            ,multiple -- 认购倍数
            ,isvalid -- 是否有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uxds_bond_issue_total_info_op(
            seq -- 记录唯一标识
            ,ctime -- 记录创建日期
            ,mtime -- 记录修改日期
            ,rtime -- 记录通讯到用户端日期
            ,bond_id -- 债券id
            ,announcement_date -- 公告日期
            ,issue_sd -- 发行起始日
            ,issue_ed -- 发行终止日
            ,plan_issue_total_vol -- 计划发行总量
            ,actual_issue_total_vol -- 实际发行总量
            ,issue_price -- 发行价格
            ,payment_date -- 缴款截止日
            ,cashing_commi_rate -- 兑付手续费率
            ,issue_method_code -- 发行方式编码
            ,issue_method -- 发行方式
            ,issue_object -- 发行对象
            ,distribution_method -- 分销方式
            ,distribution_object -- 分销对象
            ,competitive_bidding_amount -- 竞争性招标额
            ,basic_underwriting -- 基本承销额
            ,actual_rc_amt -- 实际募资金额
            ,total_issue_fee -- 发行费用总额
            ,underwriting_method_code -- 承销方式编码
            ,underwriting_method -- 承销方式
            ,online_pur_date -- 网上申购日期
            ,offline_subscription_date -- 网下认购日期
            ,online_pur_code -- 网上申购代码
            ,online_pur_short_name -- 网上申购简称
            ,orig_holders_place_amt_online -- 原股东每股获配金额
            ,offline_allocated_amt -- 网下获配金额
            ,online_issue_vol -- 网上发售数量
            ,online_issue_lottery_ratio -- 网上发售中签率
            ,offline_place_ratio -- 网下配售比例
            ,callback_mode_code -- 回拨方式编码
            ,callback_mode -- 回拨方式
            ,callback_num -- 回拨数量
            ,issue_fee_rate -- 发行费率
            ,online_release_deadline -- 上网发行截止日期
            ,online_issue_pur_limit_explain -- 网上发行认购数量限制说明
            ,listing_ad -- 上市公告日
            ,iec_passed_ad -- 审委审核通过公告日
            ,fore_issue_cost -- 预计发行费用
            ,orig_holders_place_date -- 原股东配售日期
            ,orig_holders_place_equity_rd -- 原股东配售股权登记日
            ,orig_holders_place_code -- 原股东配售代码
            ,orig_holders_place_short_name -- 原股东配售简称
            ,orig_holders_place_explain -- 原股东配售说明
            ,online_issue_pur_price -- 网上发行申购价格
            ,issue_result_ad -- 发行结果公告日
            ,orig_ls_shareholder_purchase -- 原限售股股东配购数量
            ,holder_prfr_allot_num -- 无限售股股东优先配售数量
            ,online_valid_pur_people_num -- 网上有效申购户数
            ,online_valid_pur_num -- 网上有效申购数量
            ,offline_valid_pur_account_num -- 网下有效申购户数
            ,offline_valid_pur_num -- 网下有效申购数量
            ,underwriting_sponsor_fee -- 承销保荐费用
            ,underwrite_balance -- 包销余额
            ,issue_cost_explain -- 发行费用说明
            ,offline_issue_sd -- 网下发行截止日期
            ,online_pur_quantity_dl -- 网上申购数量下限
            ,online_pur_quantity_ul -- 网上申购数量上限
            ,online_pur_quantity_unit -- 网上申购数量单位
            ,offline_pur_vol_dl -- 网下申购数量下限
            ,offline_pur_vol_ul -- 网下申购数量上限
            ,offline_pur_unit -- 网下申购数量单位
            ,offline_pur_font_money_ratio -- 网下申购定金比例
            ,online_pur_fund_unfreeze_date -- 网上申购资金解冻日
            ,offline_purcapital_unfrz_date -- 网下申购资金解冻日
            ,add_issue_total_vol -- 追加发行总量
            ,distribution_sd -- 分销起始日期
            ,distribution_ed -- 分销截至日期
            ,funds_to_account_confirm_time -- 资金到帐确认时间
            ,bond_transfer_time -- 债券过户时间
            ,basic_uw_add_contract_fee_rate -- 基本承销额附加承揽费率
            ,contract_fee_rate -- 承揽费率
            ,ib_financing_tool_reg_info_num -- 银行间债务融资工具注册信息记录号
            ,cb_issue_plan_record_num -- 可转债发行预案记录号
            ,currency_code -- 货币代码
            ,currency_name -- 货币名称
            ,rc_usage -- 募集资金用途
            ,old_holder_place_payment_date -- 老股东配售缴款日
            ,online_issue_allot_total_num -- 上网发行配号总数
            ,float_holder_place_amount -- 流通股股东可配售金额
            ,issue_status -- 发行状态
            ,nafmii_accept_reg_notice_num -- 交易商协会接受注册公告编号
            ,corp_bond_issue_reg_info_num -- 企业债券发行注册信息记录号
            ,offline_issue_lot_winning_num -- 网上中签号码
            ,accountant_fee -- 会计师费用
            ,repayment_order -- 偿付顺序
            ,issue_number -- 发行期号
            ,lawyer_fee -- 律师费用
            ,valid_bid_purchase_num -- 有效投标(申购)家数
            ,payment_sd -- 缴款起始日
            ,online_win_result_ad -- 网上中签结果公告日
            ,issue_total_amt -- 发行总额
            ,exchange_debt_issue_plan_num -- 可交换债发行预案记录号
            ,book_building_date -- 簿记建档日
            ,valid_purpurchase_amt -- 有效申购金额
            ,max_purchase_rate -- 最高申购利率
            ,min_purchase_rate -- 最低申购利率
            ,compliance_purchase_amt -- 合规申购金额
            ,compliance_purchase_num -- 合规申购家数
            ,full_field_multiplier -- 全场倍数
            ,wgt_bid_interest -- 加权中标利率
            ,marginal_multiple -- 边际倍数
            ,marginal_rate -- 边际利率
            ,csrc_bond_approval_reply_num -- 证监会债券核准批复记录号
            ,amount_ul_to_be_issued -- 计划发行金额上限
            ,amount_ll_to_be_issued -- 计划发行金额下限
            ,bounce_trigger_multiple -- 上弹触发倍数
            ,down_trigger_multiple -- 下弹触发倍数
            ,compulsory_trigger_multiple -- 强制触发倍数
            ,book_building_ed -- 簿记建档截止日
            ,issue_sd_announce -- 发行起始日(公告)
            ,min_purchase_price -- 最低申购价位
            ,max_purchase_price -- 最高申购价位
            ,issue_structure -- 发行结构
            ,issue_structure_code -- 发行结构编码
            ,issue_rule -- 发行规则
            ,issue_rule_code -- 发行规则编码
            ,orig_lh_valid_pur_num -- 原限售股股东有效申购数量
            ,unlimit_holder_valid_pur_num -- 无限售股股东有效申购数量
            ,old_holder_pur_account_num -- 老股东申购户数
            ,emission_reduction_benefits -- 减排效益
            ,csrc_bond_approval_number -- 证监会债券核准批复文号
            ,exchg_confirm_file_symbol -- 交易所确认文件文号
            ,cbirc_bond_approval_number -- 银保监会债券批复文号
            ,kpi -- 关键绩效指标
            ,spt -- 可持续发展绩效目标
            ,main_undwt_amount -- 主承销商包销金额
            ,main_undwt_ratio -- 主承销商包销比例
            ,joint_main_undwt_amount -- 联席主承销商包销金额
            ,joint_undwt_ratio -- 联席主承销商包销比例
            ,debt_credit_reg_date -- 债权债务登记日
            ,multiple -- 认购倍数
            ,isvalid -- 是否有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seq -- 记录唯一标识
    ,o.ctime -- 记录创建日期
    ,o.mtime -- 记录修改日期
    ,o.rtime -- 记录通讯到用户端日期
    ,o.bond_id -- 债券id
    ,o.announcement_date -- 公告日期
    ,o.issue_sd -- 发行起始日
    ,o.issue_ed -- 发行终止日
    ,o.plan_issue_total_vol -- 计划发行总量
    ,o.actual_issue_total_vol -- 实际发行总量
    ,o.issue_price -- 发行价格
    ,o.payment_date -- 缴款截止日
    ,o.cashing_commi_rate -- 兑付手续费率
    ,o.issue_method_code -- 发行方式编码
    ,o.issue_method -- 发行方式
    ,o.issue_object -- 发行对象
    ,o.distribution_method -- 分销方式
    ,o.distribution_object -- 分销对象
    ,o.competitive_bidding_amount -- 竞争性招标额
    ,o.basic_underwriting -- 基本承销额
    ,o.actual_rc_amt -- 实际募资金额
    ,o.total_issue_fee -- 发行费用总额
    ,o.underwriting_method_code -- 承销方式编码
    ,o.underwriting_method -- 承销方式
    ,o.online_pur_date -- 网上申购日期
    ,o.offline_subscription_date -- 网下认购日期
    ,o.online_pur_code -- 网上申购代码
    ,o.online_pur_short_name -- 网上申购简称
    ,o.orig_holders_place_amt_online -- 原股东每股获配金额
    ,o.offline_allocated_amt -- 网下获配金额
    ,o.online_issue_vol -- 网上发售数量
    ,o.online_issue_lottery_ratio -- 网上发售中签率
    ,o.offline_place_ratio -- 网下配售比例
    ,o.callback_mode_code -- 回拨方式编码
    ,o.callback_mode -- 回拨方式
    ,o.callback_num -- 回拨数量
    ,o.issue_fee_rate -- 发行费率
    ,o.online_release_deadline -- 上网发行截止日期
    ,o.online_issue_pur_limit_explain -- 网上发行认购数量限制说明
    ,o.listing_ad -- 上市公告日
    ,o.iec_passed_ad -- 审委审核通过公告日
    ,o.fore_issue_cost -- 预计发行费用
    ,o.orig_holders_place_date -- 原股东配售日期
    ,o.orig_holders_place_equity_rd -- 原股东配售股权登记日
    ,o.orig_holders_place_code -- 原股东配售代码
    ,o.orig_holders_place_short_name -- 原股东配售简称
    ,o.orig_holders_place_explain -- 原股东配售说明
    ,o.online_issue_pur_price -- 网上发行申购价格
    ,o.issue_result_ad -- 发行结果公告日
    ,o.orig_ls_shareholder_purchase -- 原限售股股东配购数量
    ,o.holder_prfr_allot_num -- 无限售股股东优先配售数量
    ,o.online_valid_pur_people_num -- 网上有效申购户数
    ,o.online_valid_pur_num -- 网上有效申购数量
    ,o.offline_valid_pur_account_num -- 网下有效申购户数
    ,o.offline_valid_pur_num -- 网下有效申购数量
    ,o.underwriting_sponsor_fee -- 承销保荐费用
    ,o.underwrite_balance -- 包销余额
    ,o.issue_cost_explain -- 发行费用说明
    ,o.offline_issue_sd -- 网下发行截止日期
    ,o.online_pur_quantity_dl -- 网上申购数量下限
    ,o.online_pur_quantity_ul -- 网上申购数量上限
    ,o.online_pur_quantity_unit -- 网上申购数量单位
    ,o.offline_pur_vol_dl -- 网下申购数量下限
    ,o.offline_pur_vol_ul -- 网下申购数量上限
    ,o.offline_pur_unit -- 网下申购数量单位
    ,o.offline_pur_font_money_ratio -- 网下申购定金比例
    ,o.online_pur_fund_unfreeze_date -- 网上申购资金解冻日
    ,o.offline_purcapital_unfrz_date -- 网下申购资金解冻日
    ,o.add_issue_total_vol -- 追加发行总量
    ,o.distribution_sd -- 分销起始日期
    ,o.distribution_ed -- 分销截至日期
    ,o.funds_to_account_confirm_time -- 资金到帐确认时间
    ,o.bond_transfer_time -- 债券过户时间
    ,o.basic_uw_add_contract_fee_rate -- 基本承销额附加承揽费率
    ,o.contract_fee_rate -- 承揽费率
    ,o.ib_financing_tool_reg_info_num -- 银行间债务融资工具注册信息记录号
    ,o.cb_issue_plan_record_num -- 可转债发行预案记录号
    ,o.currency_code -- 货币代码
    ,o.currency_name -- 货币名称
    ,o.rc_usage -- 募集资金用途
    ,o.old_holder_place_payment_date -- 老股东配售缴款日
    ,o.online_issue_allot_total_num -- 上网发行配号总数
    ,o.float_holder_place_amount -- 流通股股东可配售金额
    ,o.issue_status -- 发行状态
    ,o.nafmii_accept_reg_notice_num -- 交易商协会接受注册公告编号
    ,o.corp_bond_issue_reg_info_num -- 企业债券发行注册信息记录号
    ,o.offline_issue_lot_winning_num -- 网上中签号码
    ,o.accountant_fee -- 会计师费用
    ,o.repayment_order -- 偿付顺序
    ,o.issue_number -- 发行期号
    ,o.lawyer_fee -- 律师费用
    ,o.valid_bid_purchase_num -- 有效投标(申购)家数
    ,o.payment_sd -- 缴款起始日
    ,o.online_win_result_ad -- 网上中签结果公告日
    ,o.issue_total_amt -- 发行总额
    ,o.exchange_debt_issue_plan_num -- 可交换债发行预案记录号
    ,o.book_building_date -- 簿记建档日
    ,o.valid_purpurchase_amt -- 有效申购金额
    ,o.max_purchase_rate -- 最高申购利率
    ,o.min_purchase_rate -- 最低申购利率
    ,o.compliance_purchase_amt -- 合规申购金额
    ,o.compliance_purchase_num -- 合规申购家数
    ,o.full_field_multiplier -- 全场倍数
    ,o.wgt_bid_interest -- 加权中标利率
    ,o.marginal_multiple -- 边际倍数
    ,o.marginal_rate -- 边际利率
    ,o.csrc_bond_approval_reply_num -- 证监会债券核准批复记录号
    ,o.amount_ul_to_be_issued -- 计划发行金额上限
    ,o.amount_ll_to_be_issued -- 计划发行金额下限
    ,o.bounce_trigger_multiple -- 上弹触发倍数
    ,o.down_trigger_multiple -- 下弹触发倍数
    ,o.compulsory_trigger_multiple -- 强制触发倍数
    ,o.book_building_ed -- 簿记建档截止日
    ,o.issue_sd_announce -- 发行起始日(公告)
    ,o.min_purchase_price -- 最低申购价位
    ,o.max_purchase_price -- 最高申购价位
    ,o.issue_structure -- 发行结构
    ,o.issue_structure_code -- 发行结构编码
    ,o.issue_rule -- 发行规则
    ,o.issue_rule_code -- 发行规则编码
    ,o.orig_lh_valid_pur_num -- 原限售股股东有效申购数量
    ,o.unlimit_holder_valid_pur_num -- 无限售股股东有效申购数量
    ,o.old_holder_pur_account_num -- 老股东申购户数
    ,o.emission_reduction_benefits -- 减排效益
    ,o.csrc_bond_approval_number -- 证监会债券核准批复文号
    ,o.exchg_confirm_file_symbol -- 交易所确认文件文号
    ,o.cbirc_bond_approval_number -- 银保监会债券批复文号
    ,o.kpi -- 关键绩效指标
    ,o.spt -- 可持续发展绩效目标
    ,o.main_undwt_amount -- 主承销商包销金额
    ,o.main_undwt_ratio -- 主承销商包销比例
    ,o.joint_main_undwt_amount -- 联席主承销商包销金额
    ,o.joint_undwt_ratio -- 联席主承销商包销比例
    ,o.debt_credit_reg_date -- 债权债务登记日
    ,o.multiple -- 认购倍数
    ,o.isvalid -- 是否有效
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
from ${iol_schema}.uxds_bond_issue_total_info_bk o
    left join ${iol_schema}.uxds_bond_issue_total_info_op n
        on
            o.seq = n.seq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.uxds_bond_issue_total_info_cl d
        on
            o.seq = d.seq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.uxds_bond_issue_total_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('uxds_bond_issue_total_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.uxds_bond_issue_total_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.uxds_bond_issue_total_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.uxds_bond_issue_total_info exchange partition p_${batch_date} with table ${iol_schema}.uxds_bond_issue_total_info_cl;
alter table ${iol_schema}.uxds_bond_issue_total_info exchange partition p_20991231 with table ${iol_schema}.uxds_bond_issue_total_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_bond_issue_total_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uxds_bond_issue_total_info_op purge;
drop table ${iol_schema}.uxds_bond_issue_total_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.uxds_bond_issue_total_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_bond_issue_total_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
