/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_tbnd
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
create table ${iol_schema}.ibms_tbnd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_tbnd
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tbnd_op purge;
drop table ${iol_schema}.ibms_tbnd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tbnd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tbnd where 0=1;

create table ${iol_schema}.ibms_tbnd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tbnd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tbnd_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,sh_code -- 上交所代码
            ,sz_code -- 深交所代码
            ,yh_code -- 银行间代码
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 报价方式
            ,b_name -- 债券名称
            ,p_type -- 产品类型
            ,p_class -- 产品分类
            ,b_par_value -- 面额
            ,b_issue_price -- 发行价格
            ,b_issue_date -- 发行日期
            ,b_list_date -- 上市时间
            ,b_start_date -- 起息日
            ,b_mtr_date -- 到期日
            ,b_term -- 期限
            ,b_daycount -- 计息基准
            ,i_code_bench -- 基准利率代码
            ,a_type_bench -- 基准利率资产类型
            ,m_type_bench -- 基准利率市场类型
            ,b_issue_mode -- 发行方式
            ,b_coupon_type -- 票息类型
            ,b_cash_times -- 付息次数
            ,b_embopt_type -- 含权类型
            ,b_amortizing -- 本金偿还类型
            ,b_as_type -- 资产化类型
            ,b_issuer -- 发行机构
            ,b_warrantor -- 担保机构
            ,b_seniority -- 清偿等级
            ,b_fpml -- 条款FPML
            ,b_coupon -- 利率/利差
            ,b_name_full -- 债券全称
            ,b_actual_mtr_date -- 实际到期日
            ,d_code -- 债券内部代码
            ,b_p_class -- 债券产品分类
            ,b_actual_issue_amount -- 实际发行量
            ,chinesespell -- 中文拼写 中文拼写
            ,b_coupon_prec -- 利率精度
            ,host_market -- 托管市场
            ,bj_market -- 薄记市场
            ,issuer_id -- 发行人ID
            ,warrantor_id -- 担保人ID
            ,is_delete -- 是否删除
            ,usable_flag -- 是否已生效：1： 正常 2： 新增
            ,memo -- 备注
            ,update_user -- 更新人员
            ,account_user -- 复核人员
            ,update_time -- 更新时间
            ,account_time -- 复核时间
            ,imp_date -- 导入日期
            ,imp_time -- 导入时间
            ,pipe_id -- 导入管道
            ,b_fst_pay_date -- 首个付息日
            ,b_fst_reg_calc_start_date -- 首个规则计息区间开始日
            ,b_initial_fixing_date -- 首周期定息日
            ,b_pay_freq -- 支付频率
            ,b_pay_bizday_convertion -- 支付调整规则
            ,b_calc_freq -- 计息频率
            ,b_calc_bizday_convertion -- 计息调整规则
            ,b_reset_freq -- 重置频率
            ,b_reset_bizday_convertion -- 重置调整规则
            ,b_fixing_dates_offset -- 定息日偏移
            ,b_fixing_bizday_convertion -- 定息日调整规则
            ,b_fixing_precision -- 定息精度，普通债券为4，少量债券为6
            ,b_initial_rate -- 首周期定息利率
            ,b_multiplier -- 初始利率倍数
            ,b_cap_rate -- 初始利率上限
            ,b_floor_rate -- 初始利率下限
            ,b_exercise_style -- 行权类型，A：美式 B：百慕大 E：欧式
            ,b_exercise_date -- 首个行权日，含权债有效
            ,b_strike_price -- 首个执行价格，含权债有效
            ,b_compensation_rate -- 首个补偿利率，含权债有效
            ,p_class_act -- 会计产品分类
            ,b_issuer_code -- 发行人代码
            ,special_desc -- 特殊条款说明
            ,b_actual_amount_rate -- 发行额度占比（%）
            ,trustenhancing_type -- 增信方式
            ,b_issue_list_date -- 上市公告日期
            ,issue_feerate -- 发行费率
            ,underwriting_type -- 承销方式
            ,b_extend_type -- 债券扩展字段 第1位：是否可转股；第2位：是否可赎回；第3位：是否可回售；第4位：是否可转为相关债券（固息转浮息、浮息转固息)；第5位: 是否公开发行；第6位：是否永续；第7位：是否自贸区；第8位：是否权益类标识；第9位：利率债/信用债；第10位：减记条款；第11位：违约标记；第12位：临时债券标记
            ,s_type -- 标准类型
            ,p_class_dv -- 数据厂商债券分类
            ,p_class_ccdc -- 中债债券分类
            ,q_par_value -- 报价面值，0：报价以债券面值报价；其它值为报价面值
            ,confirm_term -- 是否完整条款，1：不完整条款；0或空值：完整条款
            ,sec_code -- 证券唯一编码
            ,public_issue -- 是否公开发行，0：否；1：是
            ,b_user_mtr_date -- 用户指定到期日
            ,ai_daycount -- 应计利息计息基准
            ,ytm_daycount -- 到期收益率计息基准
            ,b_early_mtr_date -- 提前到期日
            ,manage_mode -- 管理模式,1:自主管理；2:委托管理,默认1
            ,bond_nature -- 债券性质
            ,is_city_investment -- 是否城投债
            ,perpetual -- 是否永续债
            ,legal_mtr_date -- 法定到期日
            ,b_plan_issue_amount -- 计划发行量
            ,is_default -- 是否违约
            ,cf_daycount -- 前台现金流计息基准
            ,ai_daycount_back -- 后台应计利息计息基准
            ,ytm_daycount_back -- 后台到期收益率计息基准
            ,cf_daycount_back -- 后台现金流计息基准
            ,is_temp -- 是否临时代码，0：否；1：是
            ,b_ext_rating -- 最新债项评级
            ,b_ext_rating_institution -- 最新债项评级机构
            ,b_issuer_ext_rating -- 最新发行人评级
            ,b_issuer_ext_r_institution -- 最新发行人评级机构
            ,b_fst_ext_rating -- 债项首次评级
            ,b_fst_ext_rating_inst -- 债项首次评级机构
            ,b_fst_issuer_ext_rating -- 发行人首次评级
            ,b_fst_issuer_ext_r_inst -- 发行人首次评级机构
            ,b_as_asset_type_name -- 基础资产类型名称(仅对ABS债券有效)
            ,ref_yield -- 参考收益率
            ,warrantor_responsibility -- 担保人是否有连带责任,0-否,1-是
            ,debts_registration_date -- 债权债务登记日
            ,guarantor_rating -- 担保人评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tbnd_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,sh_code -- 上交所代码
            ,sz_code -- 深交所代码
            ,yh_code -- 银行间代码
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 报价方式
            ,b_name -- 债券名称
            ,p_type -- 产品类型
            ,p_class -- 产品分类
            ,b_par_value -- 面额
            ,b_issue_price -- 发行价格
            ,b_issue_date -- 发行日期
            ,b_list_date -- 上市时间
            ,b_start_date -- 起息日
            ,b_mtr_date -- 到期日
            ,b_term -- 期限
            ,b_daycount -- 计息基准
            ,i_code_bench -- 基准利率代码
            ,a_type_bench -- 基准利率资产类型
            ,m_type_bench -- 基准利率市场类型
            ,b_issue_mode -- 发行方式
            ,b_coupon_type -- 票息类型
            ,b_cash_times -- 付息次数
            ,b_embopt_type -- 含权类型
            ,b_amortizing -- 本金偿还类型
            ,b_as_type -- 资产化类型
            ,b_issuer -- 发行机构
            ,b_warrantor -- 担保机构
            ,b_seniority -- 清偿等级
            ,b_fpml -- 条款FPML
            ,b_coupon -- 利率/利差
            ,b_name_full -- 债券全称
            ,b_actual_mtr_date -- 实际到期日
            ,d_code -- 债券内部代码
            ,b_p_class -- 债券产品分类
            ,b_actual_issue_amount -- 实际发行量
            ,chinesespell -- 中文拼写 中文拼写
            ,b_coupon_prec -- 利率精度
            ,host_market -- 托管市场
            ,bj_market -- 薄记市场
            ,issuer_id -- 发行人ID
            ,warrantor_id -- 担保人ID
            ,is_delete -- 是否删除
            ,usable_flag -- 是否已生效：1： 正常 2： 新增
            ,memo -- 备注
            ,update_user -- 更新人员
            ,account_user -- 复核人员
            ,update_time -- 更新时间
            ,account_time -- 复核时间
            ,imp_date -- 导入日期
            ,imp_time -- 导入时间
            ,pipe_id -- 导入管道
            ,b_fst_pay_date -- 首个付息日
            ,b_fst_reg_calc_start_date -- 首个规则计息区间开始日
            ,b_initial_fixing_date -- 首周期定息日
            ,b_pay_freq -- 支付频率
            ,b_pay_bizday_convertion -- 支付调整规则
            ,b_calc_freq -- 计息频率
            ,b_calc_bizday_convertion -- 计息调整规则
            ,b_reset_freq -- 重置频率
            ,b_reset_bizday_convertion -- 重置调整规则
            ,b_fixing_dates_offset -- 定息日偏移
            ,b_fixing_bizday_convertion -- 定息日调整规则
            ,b_fixing_precision -- 定息精度，普通债券为4，少量债券为6
            ,b_initial_rate -- 首周期定息利率
            ,b_multiplier -- 初始利率倍数
            ,b_cap_rate -- 初始利率上限
            ,b_floor_rate -- 初始利率下限
            ,b_exercise_style -- 行权类型，A：美式 B：百慕大 E：欧式
            ,b_exercise_date -- 首个行权日，含权债有效
            ,b_strike_price -- 首个执行价格，含权债有效
            ,b_compensation_rate -- 首个补偿利率，含权债有效
            ,p_class_act -- 会计产品分类
            ,b_issuer_code -- 发行人代码
            ,special_desc -- 特殊条款说明
            ,b_actual_amount_rate -- 发行额度占比（%）
            ,trustenhancing_type -- 增信方式
            ,b_issue_list_date -- 上市公告日期
            ,issue_feerate -- 发行费率
            ,underwriting_type -- 承销方式
            ,b_extend_type -- 债券扩展字段 第1位：是否可转股；第2位：是否可赎回；第3位：是否可回售；第4位：是否可转为相关债券（固息转浮息、浮息转固息)；第5位: 是否公开发行；第6位：是否永续；第7位：是否自贸区；第8位：是否权益类标识；第9位：利率债/信用债；第10位：减记条款；第11位：违约标记；第12位：临时债券标记
            ,s_type -- 标准类型
            ,p_class_dv -- 数据厂商债券分类
            ,p_class_ccdc -- 中债债券分类
            ,q_par_value -- 报价面值，0：报价以债券面值报价；其它值为报价面值
            ,confirm_term -- 是否完整条款，1：不完整条款；0或空值：完整条款
            ,sec_code -- 证券唯一编码
            ,public_issue -- 是否公开发行，0：否；1：是
            ,b_user_mtr_date -- 用户指定到期日
            ,ai_daycount -- 应计利息计息基准
            ,ytm_daycount -- 到期收益率计息基准
            ,b_early_mtr_date -- 提前到期日
            ,manage_mode -- 管理模式,1:自主管理；2:委托管理,默认1
            ,bond_nature -- 债券性质
            ,is_city_investment -- 是否城投债
            ,perpetual -- 是否永续债
            ,legal_mtr_date -- 法定到期日
            ,b_plan_issue_amount -- 计划发行量
            ,is_default -- 是否违约
            ,cf_daycount -- 前台现金流计息基准
            ,ai_daycount_back -- 后台应计利息计息基准
            ,ytm_daycount_back -- 后台到期收益率计息基准
            ,cf_daycount_back -- 后台现金流计息基准
            ,is_temp -- 是否临时代码，0：否；1：是
            ,b_ext_rating -- 最新债项评级
            ,b_ext_rating_institution -- 最新债项评级机构
            ,b_issuer_ext_rating -- 最新发行人评级
            ,b_issuer_ext_r_institution -- 最新发行人评级机构
            ,b_fst_ext_rating -- 债项首次评级
            ,b_fst_ext_rating_inst -- 债项首次评级机构
            ,b_fst_issuer_ext_rating -- 发行人首次评级
            ,b_fst_issuer_ext_r_inst -- 发行人首次评级机构
            ,b_as_asset_type_name -- 基础资产类型名称(仅对ABS债券有效)
            ,ref_yield -- 参考收益率
            ,warrantor_responsibility -- 担保人是否有连带责任,0-否,1-是
            ,debts_registration_date -- 债权债务登记日
            ,guarantor_rating -- 担保人评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.sh_code, o.sh_code) as sh_code -- 上交所代码
    ,nvl(n.sz_code, o.sz_code) as sz_code -- 深交所代码
    ,nvl(n.yh_code, o.yh_code) as yh_code -- 银行间代码
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.country, o.country) as country -- 国家
    ,nvl(n.q_type, o.q_type) as q_type -- 报价方式
    ,nvl(n.b_name, o.b_name) as b_name -- 债券名称
    ,nvl(n.p_type, o.p_type) as p_type -- 产品类型
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类
    ,nvl(n.b_par_value, o.b_par_value) as b_par_value -- 面额
    ,nvl(n.b_issue_price, o.b_issue_price) as b_issue_price -- 发行价格
    ,nvl(n.b_issue_date, o.b_issue_date) as b_issue_date -- 发行日期
    ,nvl(n.b_list_date, o.b_list_date) as b_list_date -- 上市时间
    ,nvl(n.b_start_date, o.b_start_date) as b_start_date -- 起息日
    ,nvl(n.b_mtr_date, o.b_mtr_date) as b_mtr_date -- 到期日
    ,nvl(n.b_term, o.b_term) as b_term -- 期限
    ,nvl(n.b_daycount, o.b_daycount) as b_daycount -- 计息基准
    ,nvl(n.i_code_bench, o.i_code_bench) as i_code_bench -- 基准利率代码
    ,nvl(n.a_type_bench, o.a_type_bench) as a_type_bench -- 基准利率资产类型
    ,nvl(n.m_type_bench, o.m_type_bench) as m_type_bench -- 基准利率市场类型
    ,nvl(n.b_issue_mode, o.b_issue_mode) as b_issue_mode -- 发行方式
    ,nvl(n.b_coupon_type, o.b_coupon_type) as b_coupon_type -- 票息类型
    ,nvl(n.b_cash_times, o.b_cash_times) as b_cash_times -- 付息次数
    ,nvl(n.b_embopt_type, o.b_embopt_type) as b_embopt_type -- 含权类型
    ,nvl(n.b_amortizing, o.b_amortizing) as b_amortizing -- 本金偿还类型
    ,nvl(n.b_as_type, o.b_as_type) as b_as_type -- 资产化类型
    ,nvl(n.b_issuer, o.b_issuer) as b_issuer -- 发行机构
    ,nvl(n.b_warrantor, o.b_warrantor) as b_warrantor -- 担保机构
    ,nvl(n.b_seniority, o.b_seniority) as b_seniority -- 清偿等级
    ,nvl(n.b_fpml, o.b_fpml) as b_fpml -- 条款FPML
    ,nvl(n.b_coupon, o.b_coupon) as b_coupon -- 利率/利差
    ,nvl(n.b_name_full, o.b_name_full) as b_name_full -- 债券全称
    ,nvl(n.b_actual_mtr_date, o.b_actual_mtr_date) as b_actual_mtr_date -- 实际到期日
    ,nvl(n.d_code, o.d_code) as d_code -- 债券内部代码
    ,nvl(n.b_p_class, o.b_p_class) as b_p_class -- 债券产品分类
    ,nvl(n.b_actual_issue_amount, o.b_actual_issue_amount) as b_actual_issue_amount -- 实际发行量
    ,nvl(n.chinesespell, o.chinesespell) as chinesespell -- 中文拼写 中文拼写
    ,nvl(n.b_coupon_prec, o.b_coupon_prec) as b_coupon_prec -- 利率精度
    ,nvl(n.host_market, o.host_market) as host_market -- 托管市场
    ,nvl(n.bj_market, o.bj_market) as bj_market -- 薄记市场
    ,nvl(n.issuer_id, o.issuer_id) as issuer_id -- 发行人ID
    ,nvl(n.warrantor_id, o.warrantor_id) as warrantor_id -- 担保人ID
    ,nvl(n.is_delete, o.is_delete) as is_delete -- 是否删除
    ,nvl(n.usable_flag, o.usable_flag) as usable_flag -- 是否已生效：1： 正常 2： 新增
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人员
    ,nvl(n.account_user, o.account_user) as account_user -- 复核人员
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.account_time, o.account_time) as account_time -- 复核时间
    ,nvl(n.imp_date, o.imp_date) as imp_date -- 导入日期
    ,nvl(n.imp_time, o.imp_time) as imp_time -- 导入时间
    ,nvl(n.pipe_id, o.pipe_id) as pipe_id -- 导入管道
    ,nvl(n.b_fst_pay_date, o.b_fst_pay_date) as b_fst_pay_date -- 首个付息日
    ,nvl(n.b_fst_reg_calc_start_date, o.b_fst_reg_calc_start_date) as b_fst_reg_calc_start_date -- 首个规则计息区间开始日
    ,nvl(n.b_initial_fixing_date, o.b_initial_fixing_date) as b_initial_fixing_date -- 首周期定息日
    ,nvl(n.b_pay_freq, o.b_pay_freq) as b_pay_freq -- 支付频率
    ,nvl(n.b_pay_bizday_convertion, o.b_pay_bizday_convertion) as b_pay_bizday_convertion -- 支付调整规则
    ,nvl(n.b_calc_freq, o.b_calc_freq) as b_calc_freq -- 计息频率
    ,nvl(n.b_calc_bizday_convertion, o.b_calc_bizday_convertion) as b_calc_bizday_convertion -- 计息调整规则
    ,nvl(n.b_reset_freq, o.b_reset_freq) as b_reset_freq -- 重置频率
    ,nvl(n.b_reset_bizday_convertion, o.b_reset_bizday_convertion) as b_reset_bizday_convertion -- 重置调整规则
    ,nvl(n.b_fixing_dates_offset, o.b_fixing_dates_offset) as b_fixing_dates_offset -- 定息日偏移
    ,nvl(n.b_fixing_bizday_convertion, o.b_fixing_bizday_convertion) as b_fixing_bizday_convertion -- 定息日调整规则
    ,nvl(n.b_fixing_precision, o.b_fixing_precision) as b_fixing_precision -- 定息精度，普通债券为4，少量债券为6
    ,nvl(n.b_initial_rate, o.b_initial_rate) as b_initial_rate -- 首周期定息利率
    ,nvl(n.b_multiplier, o.b_multiplier) as b_multiplier -- 初始利率倍数
    ,nvl(n.b_cap_rate, o.b_cap_rate) as b_cap_rate -- 初始利率上限
    ,nvl(n.b_floor_rate, o.b_floor_rate) as b_floor_rate -- 初始利率下限
    ,nvl(n.b_exercise_style, o.b_exercise_style) as b_exercise_style -- 行权类型，A：美式 B：百慕大 E：欧式
    ,nvl(n.b_exercise_date, o.b_exercise_date) as b_exercise_date -- 首个行权日，含权债有效
    ,nvl(n.b_strike_price, o.b_strike_price) as b_strike_price -- 首个执行价格，含权债有效
    ,nvl(n.b_compensation_rate, o.b_compensation_rate) as b_compensation_rate -- 首个补偿利率，含权债有效
    ,nvl(n.p_class_act, o.p_class_act) as p_class_act -- 会计产品分类
    ,nvl(n.b_issuer_code, o.b_issuer_code) as b_issuer_code -- 发行人代码
    ,nvl(n.special_desc, o.special_desc) as special_desc -- 特殊条款说明
    ,nvl(n.b_actual_amount_rate, o.b_actual_amount_rate) as b_actual_amount_rate -- 发行额度占比（%）
    ,nvl(n.trustenhancing_type, o.trustenhancing_type) as trustenhancing_type -- 增信方式
    ,nvl(n.b_issue_list_date, o.b_issue_list_date) as b_issue_list_date -- 上市公告日期
    ,nvl(n.issue_feerate, o.issue_feerate) as issue_feerate -- 发行费率
    ,nvl(n.underwriting_type, o.underwriting_type) as underwriting_type -- 承销方式
    ,nvl(n.b_extend_type, o.b_extend_type) as b_extend_type -- 债券扩展字段 第1位：是否可转股；第2位：是否可赎回；第3位：是否可回售；第4位：是否可转为相关债券（固息转浮息、浮息转固息)；第5位: 是否公开发行；第6位：是否永续；第7位：是否自贸区；第8位：是否权益类标识；第9位：利率债/信用债；第10位：减记条款；第11位：违约标记；第12位：临时债券标记
    ,nvl(n.s_type, o.s_type) as s_type -- 标准类型
    ,nvl(n.p_class_dv, o.p_class_dv) as p_class_dv -- 数据厂商债券分类
    ,nvl(n.p_class_ccdc, o.p_class_ccdc) as p_class_ccdc -- 中债债券分类
    ,nvl(n.q_par_value, o.q_par_value) as q_par_value -- 报价面值，0：报价以债券面值报价；其它值为报价面值
    ,nvl(n.confirm_term, o.confirm_term) as confirm_term -- 是否完整条款，1：不完整条款；0或空值：完整条款
    ,nvl(n.sec_code, o.sec_code) as sec_code -- 证券唯一编码
    ,nvl(n.public_issue, o.public_issue) as public_issue -- 是否公开发行，0：否；1：是
    ,nvl(n.b_user_mtr_date, o.b_user_mtr_date) as b_user_mtr_date -- 用户指定到期日
    ,nvl(n.ai_daycount, o.ai_daycount) as ai_daycount -- 应计利息计息基准
    ,nvl(n.ytm_daycount, o.ytm_daycount) as ytm_daycount -- 到期收益率计息基准
    ,nvl(n.b_early_mtr_date, o.b_early_mtr_date) as b_early_mtr_date -- 提前到期日
    ,nvl(n.manage_mode, o.manage_mode) as manage_mode -- 管理模式,1:自主管理；2:委托管理,默认1
    ,nvl(n.bond_nature, o.bond_nature) as bond_nature -- 债券性质
    ,nvl(n.is_city_investment, o.is_city_investment) as is_city_investment -- 是否城投债
    ,nvl(n.perpetual, o.perpetual) as perpetual -- 是否永续债
    ,nvl(n.legal_mtr_date, o.legal_mtr_date) as legal_mtr_date -- 法定到期日
    ,nvl(n.b_plan_issue_amount, o.b_plan_issue_amount) as b_plan_issue_amount -- 计划发行量
    ,nvl(n.is_default, o.is_default) as is_default -- 是否违约
    ,nvl(n.cf_daycount, o.cf_daycount) as cf_daycount -- 前台现金流计息基准
    ,nvl(n.ai_daycount_back, o.ai_daycount_back) as ai_daycount_back -- 后台应计利息计息基准
    ,nvl(n.ytm_daycount_back, o.ytm_daycount_back) as ytm_daycount_back -- 后台到期收益率计息基准
    ,nvl(n.cf_daycount_back, o.cf_daycount_back) as cf_daycount_back -- 后台现金流计息基准
    ,nvl(n.is_temp, o.is_temp) as is_temp -- 是否临时代码，0：否；1：是
    ,nvl(n.b_ext_rating, o.b_ext_rating) as b_ext_rating -- 最新债项评级
    ,nvl(n.b_ext_rating_institution, o.b_ext_rating_institution) as b_ext_rating_institution -- 最新债项评级机构
    ,nvl(n.b_issuer_ext_rating, o.b_issuer_ext_rating) as b_issuer_ext_rating -- 最新发行人评级
    ,nvl(n.b_issuer_ext_r_institution, o.b_issuer_ext_r_institution) as b_issuer_ext_r_institution -- 最新发行人评级机构
    ,nvl(n.b_fst_ext_rating, o.b_fst_ext_rating) as b_fst_ext_rating -- 债项首次评级
    ,nvl(n.b_fst_ext_rating_inst, o.b_fst_ext_rating_inst) as b_fst_ext_rating_inst -- 债项首次评级机构
    ,nvl(n.b_fst_issuer_ext_rating, o.b_fst_issuer_ext_rating) as b_fst_issuer_ext_rating -- 发行人首次评级
    ,nvl(n.b_fst_issuer_ext_r_inst, o.b_fst_issuer_ext_r_inst) as b_fst_issuer_ext_r_inst -- 发行人首次评级机构
    ,nvl(n.b_as_asset_type_name, o.b_as_asset_type_name) as b_as_asset_type_name -- 基础资产类型名称(仅对ABS债券有效)
    ,nvl(n.ref_yield, o.ref_yield) as ref_yield -- 参考收益率
    ,nvl(n.warrantor_responsibility, o.warrantor_responsibility) as warrantor_responsibility -- 担保人是否有连带责任,0-否,1-是
    ,nvl(n.debts_registration_date, o.debts_registration_date) as debts_registration_date -- 债权债务登记日
    ,nvl(n.guarantor_rating, o.guarantor_rating) as guarantor_rating -- 担保人评级
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_tbnd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_tbnd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
    )
    or (
        o.sh_code <> n.sh_code
        or o.sz_code <> n.sz_code
        or o.yh_code <> n.yh_code
        or o.currency <> n.currency
        or o.country <> n.country
        or o.q_type <> n.q_type
        or o.b_name <> n.b_name
        or o.p_type <> n.p_type
        or o.p_class <> n.p_class
        or o.b_par_value <> n.b_par_value
        or o.b_issue_price <> n.b_issue_price
        or o.b_issue_date <> n.b_issue_date
        or o.b_list_date <> n.b_list_date
        or o.b_start_date <> n.b_start_date
        or o.b_mtr_date <> n.b_mtr_date
        or o.b_term <> n.b_term
        or o.b_daycount <> n.b_daycount
        or o.i_code_bench <> n.i_code_bench
        or o.a_type_bench <> n.a_type_bench
        or o.m_type_bench <> n.m_type_bench
        or o.b_issue_mode <> n.b_issue_mode
        or o.b_coupon_type <> n.b_coupon_type
        or o.b_cash_times <> n.b_cash_times
        or o.b_embopt_type <> n.b_embopt_type
        or o.b_amortizing <> n.b_amortizing
        or o.b_as_type <> n.b_as_type
        or o.b_issuer <> n.b_issuer
        or o.b_warrantor <> n.b_warrantor
        or o.b_seniority <> n.b_seniority
        or o.b_fpml <> n.b_fpml
        or o.b_coupon <> n.b_coupon
        or o.b_name_full <> n.b_name_full
        or o.b_actual_mtr_date <> n.b_actual_mtr_date
        or o.d_code <> n.d_code
        or o.b_p_class <> n.b_p_class
        or o.b_actual_issue_amount <> n.b_actual_issue_amount
        or o.chinesespell <> n.chinesespell
        or o.b_coupon_prec <> n.b_coupon_prec
        or o.host_market <> n.host_market
        or o.bj_market <> n.bj_market
        or o.issuer_id <> n.issuer_id
        or o.warrantor_id <> n.warrantor_id
        or o.is_delete <> n.is_delete
        or o.usable_flag <> n.usable_flag
        or o.memo <> n.memo
        or o.update_user <> n.update_user
        or o.account_user <> n.account_user
        or o.update_time <> n.update_time
        or o.account_time <> n.account_time
        or o.imp_date <> n.imp_date
        or o.imp_time <> n.imp_time
        or o.pipe_id <> n.pipe_id
        or o.b_fst_pay_date <> n.b_fst_pay_date
        or o.b_fst_reg_calc_start_date <> n.b_fst_reg_calc_start_date
        or o.b_initial_fixing_date <> n.b_initial_fixing_date
        or o.b_pay_freq <> n.b_pay_freq
        or o.b_pay_bizday_convertion <> n.b_pay_bizday_convertion
        or o.b_calc_freq <> n.b_calc_freq
        or o.b_calc_bizday_convertion <> n.b_calc_bizday_convertion
        or o.b_reset_freq <> n.b_reset_freq
        or o.b_reset_bizday_convertion <> n.b_reset_bizday_convertion
        or o.b_fixing_dates_offset <> n.b_fixing_dates_offset
        or o.b_fixing_bizday_convertion <> n.b_fixing_bizday_convertion
        or o.b_fixing_precision <> n.b_fixing_precision
        or o.b_initial_rate <> n.b_initial_rate
        or o.b_multiplier <> n.b_multiplier
        or o.b_cap_rate <> n.b_cap_rate
        or o.b_floor_rate <> n.b_floor_rate
        or o.b_exercise_style <> n.b_exercise_style
        or o.b_exercise_date <> n.b_exercise_date
        or o.b_strike_price <> n.b_strike_price
        or o.b_compensation_rate <> n.b_compensation_rate
        or o.p_class_act <> n.p_class_act
        or o.b_issuer_code <> n.b_issuer_code
        or o.special_desc <> n.special_desc
        or o.b_actual_amount_rate <> n.b_actual_amount_rate
        or o.trustenhancing_type <> n.trustenhancing_type
        or o.b_issue_list_date <> n.b_issue_list_date
        or o.issue_feerate <> n.issue_feerate
        or o.underwriting_type <> n.underwriting_type
        or o.b_extend_type <> n.b_extend_type
        or o.s_type <> n.s_type
        or o.p_class_dv <> n.p_class_dv
        or o.p_class_ccdc <> n.p_class_ccdc
        or o.q_par_value <> n.q_par_value
        or o.confirm_term <> n.confirm_term
        or o.sec_code <> n.sec_code
        or o.public_issue <> n.public_issue
        or o.b_user_mtr_date <> n.b_user_mtr_date
        or o.ai_daycount <> n.ai_daycount
        or o.ytm_daycount <> n.ytm_daycount
        or o.b_early_mtr_date <> n.b_early_mtr_date
        or o.manage_mode <> n.manage_mode
        or o.bond_nature <> n.bond_nature
        or o.is_city_investment <> n.is_city_investment
        or o.perpetual <> n.perpetual
        or o.legal_mtr_date <> n.legal_mtr_date
        or o.b_plan_issue_amount <> n.b_plan_issue_amount
        or o.is_default <> n.is_default
        or o.cf_daycount <> n.cf_daycount
        or o.ai_daycount_back <> n.ai_daycount_back
        or o.ytm_daycount_back <> n.ytm_daycount_back
        or o.cf_daycount_back <> n.cf_daycount_back
        or o.is_temp <> n.is_temp
        or o.b_ext_rating <> n.b_ext_rating
        or o.b_ext_rating_institution <> n.b_ext_rating_institution
        or o.b_issuer_ext_rating <> n.b_issuer_ext_rating
        or o.b_issuer_ext_r_institution <> n.b_issuer_ext_r_institution
        or o.b_fst_ext_rating <> n.b_fst_ext_rating
        or o.b_fst_ext_rating_inst <> n.b_fst_ext_rating_inst
        or o.b_fst_issuer_ext_rating <> n.b_fst_issuer_ext_rating
        or o.b_fst_issuer_ext_r_inst <> n.b_fst_issuer_ext_r_inst
        or o.b_as_asset_type_name <> n.b_as_asset_type_name
        or o.ref_yield <> n.ref_yield
        or o.warrantor_responsibility <> n.warrantor_responsibility
        or o.debts_registration_date <> n.debts_registration_date
        or o.guarantor_rating <> n.guarantor_rating
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tbnd_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,sh_code -- 上交所代码
            ,sz_code -- 深交所代码
            ,yh_code -- 银行间代码
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 报价方式
            ,b_name -- 债券名称
            ,p_type -- 产品类型
            ,p_class -- 产品分类
            ,b_par_value -- 面额
            ,b_issue_price -- 发行价格
            ,b_issue_date -- 发行日期
            ,b_list_date -- 上市时间
            ,b_start_date -- 起息日
            ,b_mtr_date -- 到期日
            ,b_term -- 期限
            ,b_daycount -- 计息基准
            ,i_code_bench -- 基准利率代码
            ,a_type_bench -- 基准利率资产类型
            ,m_type_bench -- 基准利率市场类型
            ,b_issue_mode -- 发行方式
            ,b_coupon_type -- 票息类型
            ,b_cash_times -- 付息次数
            ,b_embopt_type -- 含权类型
            ,b_amortizing -- 本金偿还类型
            ,b_as_type -- 资产化类型
            ,b_issuer -- 发行机构
            ,b_warrantor -- 担保机构
            ,b_seniority -- 清偿等级
            ,b_fpml -- 条款FPML
            ,b_coupon -- 利率/利差
            ,b_name_full -- 债券全称
            ,b_actual_mtr_date -- 实际到期日
            ,d_code -- 债券内部代码
            ,b_p_class -- 债券产品分类
            ,b_actual_issue_amount -- 实际发行量
            ,chinesespell -- 中文拼写 中文拼写
            ,b_coupon_prec -- 利率精度
            ,host_market -- 托管市场
            ,bj_market -- 薄记市场
            ,issuer_id -- 发行人ID
            ,warrantor_id -- 担保人ID
            ,is_delete -- 是否删除
            ,usable_flag -- 是否已生效：1： 正常 2： 新增
            ,memo -- 备注
            ,update_user -- 更新人员
            ,account_user -- 复核人员
            ,update_time -- 更新时间
            ,account_time -- 复核时间
            ,imp_date -- 导入日期
            ,imp_time -- 导入时间
            ,pipe_id -- 导入管道
            ,b_fst_pay_date -- 首个付息日
            ,b_fst_reg_calc_start_date -- 首个规则计息区间开始日
            ,b_initial_fixing_date -- 首周期定息日
            ,b_pay_freq -- 支付频率
            ,b_pay_bizday_convertion -- 支付调整规则
            ,b_calc_freq -- 计息频率
            ,b_calc_bizday_convertion -- 计息调整规则
            ,b_reset_freq -- 重置频率
            ,b_reset_bizday_convertion -- 重置调整规则
            ,b_fixing_dates_offset -- 定息日偏移
            ,b_fixing_bizday_convertion -- 定息日调整规则
            ,b_fixing_precision -- 定息精度，普通债券为4，少量债券为6
            ,b_initial_rate -- 首周期定息利率
            ,b_multiplier -- 初始利率倍数
            ,b_cap_rate -- 初始利率上限
            ,b_floor_rate -- 初始利率下限
            ,b_exercise_style -- 行权类型，A：美式 B：百慕大 E：欧式
            ,b_exercise_date -- 首个行权日，含权债有效
            ,b_strike_price -- 首个执行价格，含权债有效
            ,b_compensation_rate -- 首个补偿利率，含权债有效
            ,p_class_act -- 会计产品分类
            ,b_issuer_code -- 发行人代码
            ,special_desc -- 特殊条款说明
            ,b_actual_amount_rate -- 发行额度占比（%）
            ,trustenhancing_type -- 增信方式
            ,b_issue_list_date -- 上市公告日期
            ,issue_feerate -- 发行费率
            ,underwriting_type -- 承销方式
            ,b_extend_type -- 债券扩展字段 第1位：是否可转股；第2位：是否可赎回；第3位：是否可回售；第4位：是否可转为相关债券（固息转浮息、浮息转固息)；第5位: 是否公开发行；第6位：是否永续；第7位：是否自贸区；第8位：是否权益类标识；第9位：利率债/信用债；第10位：减记条款；第11位：违约标记；第12位：临时债券标记
            ,s_type -- 标准类型
            ,p_class_dv -- 数据厂商债券分类
            ,p_class_ccdc -- 中债债券分类
            ,q_par_value -- 报价面值，0：报价以债券面值报价；其它值为报价面值
            ,confirm_term -- 是否完整条款，1：不完整条款；0或空值：完整条款
            ,sec_code -- 证券唯一编码
            ,public_issue -- 是否公开发行，0：否；1：是
            ,b_user_mtr_date -- 用户指定到期日
            ,ai_daycount -- 应计利息计息基准
            ,ytm_daycount -- 到期收益率计息基准
            ,b_early_mtr_date -- 提前到期日
            ,manage_mode -- 管理模式,1:自主管理；2:委托管理,默认1
            ,bond_nature -- 债券性质
            ,is_city_investment -- 是否城投债
            ,perpetual -- 是否永续债
            ,legal_mtr_date -- 法定到期日
            ,b_plan_issue_amount -- 计划发行量
            ,is_default -- 是否违约
            ,cf_daycount -- 前台现金流计息基准
            ,ai_daycount_back -- 后台应计利息计息基准
            ,ytm_daycount_back -- 后台到期收益率计息基准
            ,cf_daycount_back -- 后台现金流计息基准
            ,is_temp -- 是否临时代码，0：否；1：是
            ,b_ext_rating -- 最新债项评级
            ,b_ext_rating_institution -- 最新债项评级机构
            ,b_issuer_ext_rating -- 最新发行人评级
            ,b_issuer_ext_r_institution -- 最新发行人评级机构
            ,b_fst_ext_rating -- 债项首次评级
            ,b_fst_ext_rating_inst -- 债项首次评级机构
            ,b_fst_issuer_ext_rating -- 发行人首次评级
            ,b_fst_issuer_ext_r_inst -- 发行人首次评级机构
            ,b_as_asset_type_name -- 基础资产类型名称(仅对ABS债券有效)
            ,ref_yield -- 参考收益率
            ,warrantor_responsibility -- 担保人是否有连带责任,0-否,1-是
            ,debts_registration_date -- 债权债务登记日
            ,guarantor_rating -- 担保人评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tbnd_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,sh_code -- 上交所代码
            ,sz_code -- 深交所代码
            ,yh_code -- 银行间代码
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 报价方式
            ,b_name -- 债券名称
            ,p_type -- 产品类型
            ,p_class -- 产品分类
            ,b_par_value -- 面额
            ,b_issue_price -- 发行价格
            ,b_issue_date -- 发行日期
            ,b_list_date -- 上市时间
            ,b_start_date -- 起息日
            ,b_mtr_date -- 到期日
            ,b_term -- 期限
            ,b_daycount -- 计息基准
            ,i_code_bench -- 基准利率代码
            ,a_type_bench -- 基准利率资产类型
            ,m_type_bench -- 基准利率市场类型
            ,b_issue_mode -- 发行方式
            ,b_coupon_type -- 票息类型
            ,b_cash_times -- 付息次数
            ,b_embopt_type -- 含权类型
            ,b_amortizing -- 本金偿还类型
            ,b_as_type -- 资产化类型
            ,b_issuer -- 发行机构
            ,b_warrantor -- 担保机构
            ,b_seniority -- 清偿等级
            ,b_fpml -- 条款FPML
            ,b_coupon -- 利率/利差
            ,b_name_full -- 债券全称
            ,b_actual_mtr_date -- 实际到期日
            ,d_code -- 债券内部代码
            ,b_p_class -- 债券产品分类
            ,b_actual_issue_amount -- 实际发行量
            ,chinesespell -- 中文拼写 中文拼写
            ,b_coupon_prec -- 利率精度
            ,host_market -- 托管市场
            ,bj_market -- 薄记市场
            ,issuer_id -- 发行人ID
            ,warrantor_id -- 担保人ID
            ,is_delete -- 是否删除
            ,usable_flag -- 是否已生效：1： 正常 2： 新增
            ,memo -- 备注
            ,update_user -- 更新人员
            ,account_user -- 复核人员
            ,update_time -- 更新时间
            ,account_time -- 复核时间
            ,imp_date -- 导入日期
            ,imp_time -- 导入时间
            ,pipe_id -- 导入管道
            ,b_fst_pay_date -- 首个付息日
            ,b_fst_reg_calc_start_date -- 首个规则计息区间开始日
            ,b_initial_fixing_date -- 首周期定息日
            ,b_pay_freq -- 支付频率
            ,b_pay_bizday_convertion -- 支付调整规则
            ,b_calc_freq -- 计息频率
            ,b_calc_bizday_convertion -- 计息调整规则
            ,b_reset_freq -- 重置频率
            ,b_reset_bizday_convertion -- 重置调整规则
            ,b_fixing_dates_offset -- 定息日偏移
            ,b_fixing_bizday_convertion -- 定息日调整规则
            ,b_fixing_precision -- 定息精度，普通债券为4，少量债券为6
            ,b_initial_rate -- 首周期定息利率
            ,b_multiplier -- 初始利率倍数
            ,b_cap_rate -- 初始利率上限
            ,b_floor_rate -- 初始利率下限
            ,b_exercise_style -- 行权类型，A：美式 B：百慕大 E：欧式
            ,b_exercise_date -- 首个行权日，含权债有效
            ,b_strike_price -- 首个执行价格，含权债有效
            ,b_compensation_rate -- 首个补偿利率，含权债有效
            ,p_class_act -- 会计产品分类
            ,b_issuer_code -- 发行人代码
            ,special_desc -- 特殊条款说明
            ,b_actual_amount_rate -- 发行额度占比（%）
            ,trustenhancing_type -- 增信方式
            ,b_issue_list_date -- 上市公告日期
            ,issue_feerate -- 发行费率
            ,underwriting_type -- 承销方式
            ,b_extend_type -- 债券扩展字段 第1位：是否可转股；第2位：是否可赎回；第3位：是否可回售；第4位：是否可转为相关债券（固息转浮息、浮息转固息)；第5位: 是否公开发行；第6位：是否永续；第7位：是否自贸区；第8位：是否权益类标识；第9位：利率债/信用债；第10位：减记条款；第11位：违约标记；第12位：临时债券标记
            ,s_type -- 标准类型
            ,p_class_dv -- 数据厂商债券分类
            ,p_class_ccdc -- 中债债券分类
            ,q_par_value -- 报价面值，0：报价以债券面值报价；其它值为报价面值
            ,confirm_term -- 是否完整条款，1：不完整条款；0或空值：完整条款
            ,sec_code -- 证券唯一编码
            ,public_issue -- 是否公开发行，0：否；1：是
            ,b_user_mtr_date -- 用户指定到期日
            ,ai_daycount -- 应计利息计息基准
            ,ytm_daycount -- 到期收益率计息基准
            ,b_early_mtr_date -- 提前到期日
            ,manage_mode -- 管理模式,1:自主管理；2:委托管理,默认1
            ,bond_nature -- 债券性质
            ,is_city_investment -- 是否城投债
            ,perpetual -- 是否永续债
            ,legal_mtr_date -- 法定到期日
            ,b_plan_issue_amount -- 计划发行量
            ,is_default -- 是否违约
            ,cf_daycount -- 前台现金流计息基准
            ,ai_daycount_back -- 后台应计利息计息基准
            ,ytm_daycount_back -- 后台到期收益率计息基准
            ,cf_daycount_back -- 后台现金流计息基准
            ,is_temp -- 是否临时代码，0：否；1：是
            ,b_ext_rating -- 最新债项评级
            ,b_ext_rating_institution -- 最新债项评级机构
            ,b_issuer_ext_rating -- 最新发行人评级
            ,b_issuer_ext_r_institution -- 最新发行人评级机构
            ,b_fst_ext_rating -- 债项首次评级
            ,b_fst_ext_rating_inst -- 债项首次评级机构
            ,b_fst_issuer_ext_rating -- 发行人首次评级
            ,b_fst_issuer_ext_r_inst -- 发行人首次评级机构
            ,b_as_asset_type_name -- 基础资产类型名称(仅对ABS债券有效)
            ,ref_yield -- 参考收益率
            ,warrantor_responsibility -- 担保人是否有连带责任,0-否,1-是
            ,debts_registration_date -- 债权债务登记日
            ,guarantor_rating -- 担保人评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 金融工具代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.sh_code -- 上交所代码
    ,o.sz_code -- 深交所代码
    ,o.yh_code -- 银行间代码
    ,o.currency -- 币种
    ,o.country -- 国家
    ,o.q_type -- 报价方式
    ,o.b_name -- 债券名称
    ,o.p_type -- 产品类型
    ,o.p_class -- 产品分类
    ,o.b_par_value -- 面额
    ,o.b_issue_price -- 发行价格
    ,o.b_issue_date -- 发行日期
    ,o.b_list_date -- 上市时间
    ,o.b_start_date -- 起息日
    ,o.b_mtr_date -- 到期日
    ,o.b_term -- 期限
    ,o.b_daycount -- 计息基准
    ,o.i_code_bench -- 基准利率代码
    ,o.a_type_bench -- 基准利率资产类型
    ,o.m_type_bench -- 基准利率市场类型
    ,o.b_issue_mode -- 发行方式
    ,o.b_coupon_type -- 票息类型
    ,o.b_cash_times -- 付息次数
    ,o.b_embopt_type -- 含权类型
    ,o.b_amortizing -- 本金偿还类型
    ,o.b_as_type -- 资产化类型
    ,o.b_issuer -- 发行机构
    ,o.b_warrantor -- 担保机构
    ,o.b_seniority -- 清偿等级
    ,o.b_fpml -- 条款FPML
    ,o.b_coupon -- 利率/利差
    ,o.b_name_full -- 债券全称
    ,o.b_actual_mtr_date -- 实际到期日
    ,o.d_code -- 债券内部代码
    ,o.b_p_class -- 债券产品分类
    ,o.b_actual_issue_amount -- 实际发行量
    ,o.chinesespell -- 中文拼写 中文拼写
    ,o.b_coupon_prec -- 利率精度
    ,o.host_market -- 托管市场
    ,o.bj_market -- 薄记市场
    ,o.issuer_id -- 发行人ID
    ,o.warrantor_id -- 担保人ID
    ,o.is_delete -- 是否删除
    ,o.usable_flag -- 是否已生效：1： 正常 2： 新增
    ,o.memo -- 备注
    ,o.update_user -- 更新人员
    ,o.account_user -- 复核人员
    ,o.update_time -- 更新时间
    ,o.account_time -- 复核时间
    ,o.imp_date -- 导入日期
    ,o.imp_time -- 导入时间
    ,o.pipe_id -- 导入管道
    ,o.b_fst_pay_date -- 首个付息日
    ,o.b_fst_reg_calc_start_date -- 首个规则计息区间开始日
    ,o.b_initial_fixing_date -- 首周期定息日
    ,o.b_pay_freq -- 支付频率
    ,o.b_pay_bizday_convertion -- 支付调整规则
    ,o.b_calc_freq -- 计息频率
    ,o.b_calc_bizday_convertion -- 计息调整规则
    ,o.b_reset_freq -- 重置频率
    ,o.b_reset_bizday_convertion -- 重置调整规则
    ,o.b_fixing_dates_offset -- 定息日偏移
    ,o.b_fixing_bizday_convertion -- 定息日调整规则
    ,o.b_fixing_precision -- 定息精度，普通债券为4，少量债券为6
    ,o.b_initial_rate -- 首周期定息利率
    ,o.b_multiplier -- 初始利率倍数
    ,o.b_cap_rate -- 初始利率上限
    ,o.b_floor_rate -- 初始利率下限
    ,o.b_exercise_style -- 行权类型，A：美式 B：百慕大 E：欧式
    ,o.b_exercise_date -- 首个行权日，含权债有效
    ,o.b_strike_price -- 首个执行价格，含权债有效
    ,o.b_compensation_rate -- 首个补偿利率，含权债有效
    ,o.p_class_act -- 会计产品分类
    ,o.b_issuer_code -- 发行人代码
    ,o.special_desc -- 特殊条款说明
    ,o.b_actual_amount_rate -- 发行额度占比（%）
    ,o.trustenhancing_type -- 增信方式
    ,o.b_issue_list_date -- 上市公告日期
    ,o.issue_feerate -- 发行费率
    ,o.underwriting_type -- 承销方式
    ,o.b_extend_type -- 债券扩展字段 第1位：是否可转股；第2位：是否可赎回；第3位：是否可回售；第4位：是否可转为相关债券（固息转浮息、浮息转固息)；第5位: 是否公开发行；第6位：是否永续；第7位：是否自贸区；第8位：是否权益类标识；第9位：利率债/信用债；第10位：减记条款；第11位：违约标记；第12位：临时债券标记
    ,o.s_type -- 标准类型
    ,o.p_class_dv -- 数据厂商债券分类
    ,o.p_class_ccdc -- 中债债券分类
    ,o.q_par_value -- 报价面值，0：报价以债券面值报价；其它值为报价面值
    ,o.confirm_term -- 是否完整条款，1：不完整条款；0或空值：完整条款
    ,o.sec_code -- 证券唯一编码
    ,o.public_issue -- 是否公开发行，0：否；1：是
    ,o.b_user_mtr_date -- 用户指定到期日
    ,o.ai_daycount -- 应计利息计息基准
    ,o.ytm_daycount -- 到期收益率计息基准
    ,o.b_early_mtr_date -- 提前到期日
    ,o.manage_mode -- 管理模式,1:自主管理；2:委托管理,默认1
    ,o.bond_nature -- 债券性质
    ,o.is_city_investment -- 是否城投债
    ,o.perpetual -- 是否永续债
    ,o.legal_mtr_date -- 法定到期日
    ,o.b_plan_issue_amount -- 计划发行量
    ,o.is_default -- 是否违约
    ,o.cf_daycount -- 前台现金流计息基准
    ,o.ai_daycount_back -- 后台应计利息计息基准
    ,o.ytm_daycount_back -- 后台到期收益率计息基准
    ,o.cf_daycount_back -- 后台现金流计息基准
    ,o.is_temp -- 是否临时代码，0：否；1：是
    ,o.b_ext_rating -- 最新债项评级
    ,o.b_ext_rating_institution -- 最新债项评级机构
    ,o.b_issuer_ext_rating -- 最新发行人评级
    ,o.b_issuer_ext_r_institution -- 最新发行人评级机构
    ,o.b_fst_ext_rating -- 债项首次评级
    ,o.b_fst_ext_rating_inst -- 债项首次评级机构
    ,o.b_fst_issuer_ext_rating -- 发行人首次评级
    ,o.b_fst_issuer_ext_r_inst -- 发行人首次评级机构
    ,o.b_as_asset_type_name -- 基础资产类型名称(仅对ABS债券有效)
    ,o.ref_yield -- 参考收益率
    ,o.warrantor_responsibility -- 担保人是否有连带责任,0-否,1-是
    ,o.debts_registration_date -- 债权债务登记日
    ,o.guarantor_rating -- 担保人评级
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
from ${iol_schema}.ibms_tbnd_bk o
    left join ${iol_schema}.ibms_tbnd_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_tbnd_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_tbnd;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_tbnd') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_tbnd drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_tbnd add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_tbnd exchange partition p_${batch_date} with table ${iol_schema}.ibms_tbnd_cl;
alter table ${iol_schema}.ibms_tbnd exchange partition p_20991231 with table ${iol_schema}.ibms_tbnd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_tbnd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tbnd_op purge;
drop table ${iol_schema}.ibms_tbnd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_tbnd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_tbnd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
