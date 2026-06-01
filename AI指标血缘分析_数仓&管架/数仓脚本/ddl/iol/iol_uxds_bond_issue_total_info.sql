/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_bond_issue_total_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_bond_issue_total_info
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_bond_issue_total_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_bond_issue_total_info(
    seq number(20,0) -- 记录唯一标识
    ,ctime date -- 记录创建日期
    ,mtime date -- 记录修改日期
    ,rtime date -- 记录通讯到用户端日期
    ,bond_id varchar2(30) -- 债券id
    ,announcement_date date -- 公告日期
    ,issue_sd date -- 发行起始日
    ,issue_ed date -- 发行终止日
    ,plan_issue_total_vol number(24,10) -- 计划发行总量
    ,actual_issue_total_vol number(24,10) -- 实际发行总量
    ,issue_price number(18,4) -- 发行价格
    ,payment_date date -- 缴款截止日
    ,cashing_commi_rate number(10,4) -- 兑付手续费率
    ,issue_method_code varchar2(180) -- 发行方式编码
    ,issue_method varchar2(360) -- 发行方式
    ,issue_object varchar2(1500) -- 发行对象
    ,distribution_method varchar2(1500) -- 分销方式
    ,distribution_object varchar2(1500) -- 分销对象
    ,competitive_bidding_amount number(10,4) -- 竞争性招标额
    ,basic_underwriting number(10,4) -- 基本承销额
    ,actual_rc_amt number(18,4) -- 实际募资金额
    ,total_issue_fee number(18,4) -- 发行费用总额
    ,underwriting_method_code varchar2(180) -- 承销方式编码
    ,underwriting_method varchar2(180) -- 承销方式
    ,online_pur_date date -- 网上申购日期
    ,offline_subscription_date date -- 网下认购日期
    ,online_pur_code varchar2(30) -- 网上申购代码
    ,online_pur_short_name varchar2(120) -- 网上申购简称
    ,orig_holders_place_amt_online number(20,5) -- 原股东每股获配金额
    ,offline_allocated_amt number(18,4) -- 网下获配金额
    ,online_issue_vol number(18,4) -- 网上发售数量
    ,online_issue_lottery_ratio number(18,8) -- 网上发售中签率
    ,offline_place_ratio number(18,8) -- 网下配售比例
    ,callback_mode_code varchar2(36) -- 回拨方式编码
    ,callback_mode varchar2(180) -- 回拨方式
    ,callback_num number(18,4) -- 回拨数量
    ,issue_fee_rate number(18,4) -- 发行费率
    ,online_release_deadline date -- 上网发行截止日期
    ,online_issue_pur_limit_explain varchar2(4000) -- 网上发行认购数量限制说明
    ,listing_ad date -- 上市公告日
    ,iec_passed_ad date -- 审委审核通过公告日
    ,fore_issue_cost number(18,4) -- 预计发行费用
    ,orig_holders_place_date date -- 原股东配售日期
    ,orig_holders_place_equity_rd date -- 原股东配售股权登记日
    ,orig_holders_place_code varchar2(96) -- 原股东配售代码
    ,orig_holders_place_short_name varchar2(96) -- 原股东配售简称
    ,orig_holders_place_explain varchar2(4000) -- 原股东配售说明
    ,online_issue_pur_price number(18,4) -- 网上发行申购价格
    ,issue_result_ad date -- 发行结果公告日
    ,orig_ls_shareholder_purchase number(20,0) -- 原限售股股东配购数量
    ,holder_prfr_allot_num number(20,0) -- 无限售股股东优先配售数量
    ,online_valid_pur_people_num number(20,0) -- 网上有效申购户数
    ,online_valid_pur_num number(20,0) -- 网上有效申购数量
    ,offline_valid_pur_account_num number(20,0) -- 网下有效申购户数
    ,offline_valid_pur_num number(20,0) -- 网下有效申购数量
    ,underwriting_sponsor_fee number(18,4) -- 承销保荐费用
    ,underwrite_balance number(18,4) -- 包销余额
    ,issue_cost_explain varchar2(3000) -- 发行费用说明
    ,offline_issue_sd date -- 网下发行截止日期
    ,online_pur_quantity_dl number(18,4) -- 网上申购数量下限
    ,online_pur_quantity_ul number(18,4) -- 网上申购数量上限
    ,online_pur_quantity_unit number(18,4) -- 网上申购数量单位
    ,offline_pur_vol_dl number(18,4) -- 网下申购数量下限
    ,offline_pur_vol_ul number(18,4) -- 网下申购数量上限
    ,offline_pur_unit number(18,4) -- 网下申购数量单位
    ,offline_pur_font_money_ratio number(18,4) -- 网下申购定金比例
    ,online_pur_fund_unfreeze_date date -- 网上申购资金解冻日
    ,offline_purcapital_unfrz_date date -- 网下申购资金解冻日
    ,add_issue_total_vol number(18,6) -- 追加发行总量
    ,distribution_sd date -- 分销起始日期
    ,distribution_ed date -- 分销截至日期
    ,funds_to_account_confirm_time date -- 资金到帐确认时间
    ,bond_transfer_time date -- 债券过户时间
    ,basic_uw_add_contract_fee_rate number(18,4) -- 基本承销额附加承揽费率
    ,contract_fee_rate number(18,4) -- 承揽费率
    ,ib_financing_tool_reg_info_num number(20,0) -- 银行间债务融资工具注册信息记录号
    ,cb_issue_plan_record_num number(20,0) -- 可转债发行预案记录号
    ,currency_code varchar2(36) -- 货币代码
    ,currency_name varchar2(90) -- 货币名称
    ,rc_usage varchar2(4000) -- 募集资金用途
    ,old_holder_place_payment_date date -- 老股东配售缴款日
    ,online_issue_allot_total_num number(18,4) -- 上网发行配号总数
    ,float_holder_place_amount number(18,4) -- 流通股股东可配售金额
    ,issue_status number(18,4) -- 发行状态
    ,nafmii_accept_reg_notice_num varchar2(120) -- 交易商协会接受注册公告编号
    ,corp_bond_issue_reg_info_num number(20,0) -- 企业债券发行注册信息记录号
    ,offline_issue_lot_winning_num varchar2(3000) -- 网上中签号码
    ,accountant_fee number(18,4) -- 会计师费用
    ,repayment_order number(12,0) -- 偿付顺序
    ,issue_number number(12,0) -- 发行期号
    ,lawyer_fee number(18,4) -- 律师费用
    ,valid_bid_purchase_num number(12,0) -- 有效投标(申购)家数
    ,payment_sd date -- 缴款起始日
    ,online_win_result_ad date -- 网上中签结果公告日
    ,issue_total_amt number(24,10) -- 发行总额
    ,exchange_debt_issue_plan_num number(20,0) -- 可交换债发行预案记录号
    ,book_building_date date -- 簿记建档日
    ,valid_purpurchase_amt number(24,6) -- 有效申购金额
    ,max_purchase_rate number(24,4) -- 最高申购利率
    ,min_purchase_rate number(24,4) -- 最低申购利率
    ,compliance_purchase_amt number(24,6) -- 合规申购金额
    ,compliance_purchase_num number(5,0) -- 合规申购家数
    ,full_field_multiplier number(18,4) -- 全场倍数
    ,wgt_bid_interest number(18,4) -- 加权中标利率
    ,marginal_multiple number(18,4) -- 边际倍数
    ,marginal_rate number(18,4) -- 边际利率
    ,csrc_bond_approval_reply_num number(20,0) -- 证监会债券核准批复记录号
    ,amount_ul_to_be_issued number(18,6) -- 计划发行金额上限
    ,amount_ll_to_be_issued number(18,6) -- 计划发行金额下限
    ,bounce_trigger_multiple number(8,2) -- 上弹触发倍数
    ,down_trigger_multiple number(8,2) -- 下弹触发倍数
    ,compulsory_trigger_multiple number(8,2) -- 强制触发倍数
    ,book_building_ed date -- 簿记建档截止日
    ,issue_sd_announce date -- 发行起始日(公告)
    ,min_purchase_price number(24,4) -- 最低申购价位
    ,max_purchase_price number(24,4) -- 最高申购价位
    ,issue_structure varchar2(300) -- 发行结构
    ,issue_structure_code varchar2(30) -- 发行结构编码
    ,issue_rule varchar2(300) -- 发行规则
    ,issue_rule_code varchar2(30) -- 发行规则编码
    ,orig_lh_valid_pur_num number(20,0) -- 原限售股股东有效申购数量
    ,unlimit_holder_valid_pur_num number(20,0) -- 无限售股股东有效申购数量
    ,old_holder_pur_account_num number(18,4) -- 老股东申购户数
    ,emission_reduction_benefits varchar2(1500) -- 减排效益
    ,csrc_bond_approval_number varchar2(120) -- 证监会债券核准批复文号
    ,exchg_confirm_file_symbol varchar2(120) -- 交易所确认文件文号
    ,cbirc_bond_approval_number varchar2(120) -- 银保监会债券批复文号
    ,kpi varchar2(1500) -- 关键绩效指标
    ,spt varchar2(1500) -- 可持续发展绩效目标
    ,main_undwt_amount number(24,10) -- 主承销商包销金额
    ,main_undwt_ratio number(18,4) -- 主承销商包销比例
    ,joint_main_undwt_amount number(24,10) -- 联席主承销商包销金额
    ,joint_undwt_ratio number(18,4) -- 联席主承销商包销比例
    ,debt_credit_reg_date date -- 债权债务登记日
    ,multiple number(18,4) -- 认购倍数
    ,isvalid number(1,0) -- 是否有效
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.uxds_bond_issue_total_info to ${iml_schema};
grant select on ${iol_schema}.uxds_bond_issue_total_info to ${icl_schema};
grant select on ${iol_schema}.uxds_bond_issue_total_info to ${idl_schema};
grant select on ${iol_schema}.uxds_bond_issue_total_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_bond_issue_total_info is '中国债券发行信息总表';
comment on column ${iol_schema}.uxds_bond_issue_total_info.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_bond_issue_total_info.ctime is '记录创建日期';
comment on column ${iol_schema}.uxds_bond_issue_total_info.mtime is '记录修改日期';
comment on column ${iol_schema}.uxds_bond_issue_total_info.rtime is '记录通讯到用户端日期';
comment on column ${iol_schema}.uxds_bond_issue_total_info.bond_id is '债券id';
comment on column ${iol_schema}.uxds_bond_issue_total_info.announcement_date is '公告日期';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_sd is '发行起始日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_ed is '发行终止日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.plan_issue_total_vol is '计划发行总量';
comment on column ${iol_schema}.uxds_bond_issue_total_info.actual_issue_total_vol is '实际发行总量';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_price is '发行价格';
comment on column ${iol_schema}.uxds_bond_issue_total_info.payment_date is '缴款截止日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.cashing_commi_rate is '兑付手续费率';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_method_code is '发行方式编码';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_method is '发行方式';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_object is '发行对象';
comment on column ${iol_schema}.uxds_bond_issue_total_info.distribution_method is '分销方式';
comment on column ${iol_schema}.uxds_bond_issue_total_info.distribution_object is '分销对象';
comment on column ${iol_schema}.uxds_bond_issue_total_info.competitive_bidding_amount is '竞争性招标额';
comment on column ${iol_schema}.uxds_bond_issue_total_info.basic_underwriting is '基本承销额';
comment on column ${iol_schema}.uxds_bond_issue_total_info.actual_rc_amt is '实际募资金额';
comment on column ${iol_schema}.uxds_bond_issue_total_info.total_issue_fee is '发行费用总额';
comment on column ${iol_schema}.uxds_bond_issue_total_info.underwriting_method_code is '承销方式编码';
comment on column ${iol_schema}.uxds_bond_issue_total_info.underwriting_method is '承销方式';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_pur_date is '网上申购日期';
comment on column ${iol_schema}.uxds_bond_issue_total_info.offline_subscription_date is '网下认购日期';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_pur_code is '网上申购代码';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_pur_short_name is '网上申购简称';
comment on column ${iol_schema}.uxds_bond_issue_total_info.orig_holders_place_amt_online is '原股东每股获配金额';
comment on column ${iol_schema}.uxds_bond_issue_total_info.offline_allocated_amt is '网下获配金额';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_issue_vol is '网上发售数量';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_issue_lottery_ratio is '网上发售中签率';
comment on column ${iol_schema}.uxds_bond_issue_total_info.offline_place_ratio is '网下配售比例';
comment on column ${iol_schema}.uxds_bond_issue_total_info.callback_mode_code is '回拨方式编码';
comment on column ${iol_schema}.uxds_bond_issue_total_info.callback_mode is '回拨方式';
comment on column ${iol_schema}.uxds_bond_issue_total_info.callback_num is '回拨数量';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_fee_rate is '发行费率';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_release_deadline is '上网发行截止日期';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_issue_pur_limit_explain is '网上发行认购数量限制说明';
comment on column ${iol_schema}.uxds_bond_issue_total_info.listing_ad is '上市公告日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.iec_passed_ad is '审委审核通过公告日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.fore_issue_cost is '预计发行费用';
comment on column ${iol_schema}.uxds_bond_issue_total_info.orig_holders_place_date is '原股东配售日期';
comment on column ${iol_schema}.uxds_bond_issue_total_info.orig_holders_place_equity_rd is '原股东配售股权登记日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.orig_holders_place_code is '原股东配售代码';
comment on column ${iol_schema}.uxds_bond_issue_total_info.orig_holders_place_short_name is '原股东配售简称';
comment on column ${iol_schema}.uxds_bond_issue_total_info.orig_holders_place_explain is '原股东配售说明';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_issue_pur_price is '网上发行申购价格';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_result_ad is '发行结果公告日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.orig_ls_shareholder_purchase is '原限售股股东配购数量';
comment on column ${iol_schema}.uxds_bond_issue_total_info.holder_prfr_allot_num is '无限售股股东优先配售数量';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_valid_pur_people_num is '网上有效申购户数';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_valid_pur_num is '网上有效申购数量';
comment on column ${iol_schema}.uxds_bond_issue_total_info.offline_valid_pur_account_num is '网下有效申购户数';
comment on column ${iol_schema}.uxds_bond_issue_total_info.offline_valid_pur_num is '网下有效申购数量';
comment on column ${iol_schema}.uxds_bond_issue_total_info.underwriting_sponsor_fee is '承销保荐费用';
comment on column ${iol_schema}.uxds_bond_issue_total_info.underwrite_balance is '包销余额';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_cost_explain is '发行费用说明';
comment on column ${iol_schema}.uxds_bond_issue_total_info.offline_issue_sd is '网下发行截止日期';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_pur_quantity_dl is '网上申购数量下限';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_pur_quantity_ul is '网上申购数量上限';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_pur_quantity_unit is '网上申购数量单位';
comment on column ${iol_schema}.uxds_bond_issue_total_info.offline_pur_vol_dl is '网下申购数量下限';
comment on column ${iol_schema}.uxds_bond_issue_total_info.offline_pur_vol_ul is '网下申购数量上限';
comment on column ${iol_schema}.uxds_bond_issue_total_info.offline_pur_unit is '网下申购数量单位';
comment on column ${iol_schema}.uxds_bond_issue_total_info.offline_pur_font_money_ratio is '网下申购定金比例';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_pur_fund_unfreeze_date is '网上申购资金解冻日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.offline_purcapital_unfrz_date is '网下申购资金解冻日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.add_issue_total_vol is '追加发行总量';
comment on column ${iol_schema}.uxds_bond_issue_total_info.distribution_sd is '分销起始日期';
comment on column ${iol_schema}.uxds_bond_issue_total_info.distribution_ed is '分销截至日期';
comment on column ${iol_schema}.uxds_bond_issue_total_info.funds_to_account_confirm_time is '资金到帐确认时间';
comment on column ${iol_schema}.uxds_bond_issue_total_info.bond_transfer_time is '债券过户时间';
comment on column ${iol_schema}.uxds_bond_issue_total_info.basic_uw_add_contract_fee_rate is '基本承销额附加承揽费率';
comment on column ${iol_schema}.uxds_bond_issue_total_info.contract_fee_rate is '承揽费率';
comment on column ${iol_schema}.uxds_bond_issue_total_info.ib_financing_tool_reg_info_num is '银行间债务融资工具注册信息记录号';
comment on column ${iol_schema}.uxds_bond_issue_total_info.cb_issue_plan_record_num is '可转债发行预案记录号';
comment on column ${iol_schema}.uxds_bond_issue_total_info.currency_code is '货币代码';
comment on column ${iol_schema}.uxds_bond_issue_total_info.currency_name is '货币名称';
comment on column ${iol_schema}.uxds_bond_issue_total_info.rc_usage is '募集资金用途';
comment on column ${iol_schema}.uxds_bond_issue_total_info.old_holder_place_payment_date is '老股东配售缴款日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_issue_allot_total_num is '上网发行配号总数';
comment on column ${iol_schema}.uxds_bond_issue_total_info.float_holder_place_amount is '流通股股东可配售金额';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_status is '发行状态';
comment on column ${iol_schema}.uxds_bond_issue_total_info.nafmii_accept_reg_notice_num is '交易商协会接受注册公告编号';
comment on column ${iol_schema}.uxds_bond_issue_total_info.corp_bond_issue_reg_info_num is '企业债券发行注册信息记录号';
comment on column ${iol_schema}.uxds_bond_issue_total_info.offline_issue_lot_winning_num is '网上中签号码';
comment on column ${iol_schema}.uxds_bond_issue_total_info.accountant_fee is '会计师费用';
comment on column ${iol_schema}.uxds_bond_issue_total_info.repayment_order is '偿付顺序';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_number is '发行期号';
comment on column ${iol_schema}.uxds_bond_issue_total_info.lawyer_fee is '律师费用';
comment on column ${iol_schema}.uxds_bond_issue_total_info.valid_bid_purchase_num is '有效投标(申购)家数';
comment on column ${iol_schema}.uxds_bond_issue_total_info.payment_sd is '缴款起始日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.online_win_result_ad is '网上中签结果公告日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_total_amt is '发行总额';
comment on column ${iol_schema}.uxds_bond_issue_total_info.exchange_debt_issue_plan_num is '可交换债发行预案记录号';
comment on column ${iol_schema}.uxds_bond_issue_total_info.book_building_date is '簿记建档日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.valid_purpurchase_amt is '有效申购金额';
comment on column ${iol_schema}.uxds_bond_issue_total_info.max_purchase_rate is '最高申购利率';
comment on column ${iol_schema}.uxds_bond_issue_total_info.min_purchase_rate is '最低申购利率';
comment on column ${iol_schema}.uxds_bond_issue_total_info.compliance_purchase_amt is '合规申购金额';
comment on column ${iol_schema}.uxds_bond_issue_total_info.compliance_purchase_num is '合规申购家数';
comment on column ${iol_schema}.uxds_bond_issue_total_info.full_field_multiplier is '全场倍数';
comment on column ${iol_schema}.uxds_bond_issue_total_info.wgt_bid_interest is '加权中标利率';
comment on column ${iol_schema}.uxds_bond_issue_total_info.marginal_multiple is '边际倍数';
comment on column ${iol_schema}.uxds_bond_issue_total_info.marginal_rate is '边际利率';
comment on column ${iol_schema}.uxds_bond_issue_total_info.csrc_bond_approval_reply_num is '证监会债券核准批复记录号';
comment on column ${iol_schema}.uxds_bond_issue_total_info.amount_ul_to_be_issued is '计划发行金额上限';
comment on column ${iol_schema}.uxds_bond_issue_total_info.amount_ll_to_be_issued is '计划发行金额下限';
comment on column ${iol_schema}.uxds_bond_issue_total_info.bounce_trigger_multiple is '上弹触发倍数';
comment on column ${iol_schema}.uxds_bond_issue_total_info.down_trigger_multiple is '下弹触发倍数';
comment on column ${iol_schema}.uxds_bond_issue_total_info.compulsory_trigger_multiple is '强制触发倍数';
comment on column ${iol_schema}.uxds_bond_issue_total_info.book_building_ed is '簿记建档截止日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_sd_announce is '发行起始日(公告)';
comment on column ${iol_schema}.uxds_bond_issue_total_info.min_purchase_price is '最低申购价位';
comment on column ${iol_schema}.uxds_bond_issue_total_info.max_purchase_price is '最高申购价位';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_structure is '发行结构';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_structure_code is '发行结构编码';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_rule is '发行规则';
comment on column ${iol_schema}.uxds_bond_issue_total_info.issue_rule_code is '发行规则编码';
comment on column ${iol_schema}.uxds_bond_issue_total_info.orig_lh_valid_pur_num is '原限售股股东有效申购数量';
comment on column ${iol_schema}.uxds_bond_issue_total_info.unlimit_holder_valid_pur_num is '无限售股股东有效申购数量';
comment on column ${iol_schema}.uxds_bond_issue_total_info.old_holder_pur_account_num is '老股东申购户数';
comment on column ${iol_schema}.uxds_bond_issue_total_info.emission_reduction_benefits is '减排效益';
comment on column ${iol_schema}.uxds_bond_issue_total_info.csrc_bond_approval_number is '证监会债券核准批复文号';
comment on column ${iol_schema}.uxds_bond_issue_total_info.exchg_confirm_file_symbol is '交易所确认文件文号';
comment on column ${iol_schema}.uxds_bond_issue_total_info.cbirc_bond_approval_number is '银保监会债券批复文号';
comment on column ${iol_schema}.uxds_bond_issue_total_info.kpi is '关键绩效指标';
comment on column ${iol_schema}.uxds_bond_issue_total_info.spt is '可持续发展绩效目标';
comment on column ${iol_schema}.uxds_bond_issue_total_info.main_undwt_amount is '主承销商包销金额';
comment on column ${iol_schema}.uxds_bond_issue_total_info.main_undwt_ratio is '主承销商包销比例';
comment on column ${iol_schema}.uxds_bond_issue_total_info.joint_main_undwt_amount is '联席主承销商包销金额';
comment on column ${iol_schema}.uxds_bond_issue_total_info.joint_undwt_ratio is '联席主承销商包销比例';
comment on column ${iol_schema}.uxds_bond_issue_total_info.debt_credit_reg_date is '债权债务登记日';
comment on column ${iol_schema}.uxds_bond_issue_total_info.multiple is '认购倍数';
comment on column ${iol_schema}.uxds_bond_issue_total_info.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_bond_issue_total_info.start_dt is '开始时间';
comment on column ${iol_schema}.uxds_bond_issue_total_info.end_dt is '结束时间';
comment on column ${iol_schema}.uxds_bond_issue_total_info.id_mark is '增删标志';
comment on column ${iol_schema}.uxds_bond_issue_total_info.etl_timestamp is 'ETL处理时间戳';
