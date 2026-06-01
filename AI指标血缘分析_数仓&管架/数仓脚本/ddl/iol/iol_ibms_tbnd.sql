/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tbnd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tbnd
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tbnd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tbnd(
    i_code varchar2(45) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,sh_code varchar2(45) -- 上交所代码
    ,sz_code varchar2(45) -- 深交所代码
    ,yh_code varchar2(45) -- 银行间代码
    ,currency varchar2(5) -- 币种
    ,country varchar2(3) -- 国家
    ,q_type varchar2(3) -- 报价方式
    ,b_name varchar2(300) -- 债券名称
    ,p_type varchar2(45) -- 产品类型
    ,p_class varchar2(90) -- 产品分类
    ,b_par_value number(31,8) -- 面额
    ,b_issue_price number(12,4) -- 发行价格
    ,b_issue_date varchar2(15) -- 发行日期
    ,b_list_date varchar2(15) -- 上市时间
    ,b_start_date varchar2(15) -- 起息日
    ,b_mtr_date varchar2(15) -- 到期日
    ,b_term varchar2(9) -- 期限
    ,b_daycount varchar2(180) -- 计息基准
    ,i_code_bench varchar2(150) -- 基准利率代码
    ,a_type_bench varchar2(30) -- 基准利率资产类型
    ,m_type_bench varchar2(30) -- 基准利率市场类型
    ,b_issue_mode varchar2(2) -- 发行方式
    ,b_coupon_type varchar2(2) -- 票息类型
    ,b_cash_times number(22) -- 付息次数
    ,b_embopt_type varchar2(15) -- 含权类型
    ,b_amortizing varchar2(2) -- 本金偿还类型
    ,b_as_type varchar2(45) -- 资产化类型
    ,b_issuer varchar2(300) -- 发行机构
    ,b_warrantor varchar2(1500) -- 担保机构
    ,b_seniority varchar2(30) -- 清偿等级
    ,b_fpml varchar2(4000) -- 条款fpml
    ,b_coupon number(15,8) -- 利率/利差
    ,b_name_full varchar2(750) -- 债券全称
    ,b_actual_mtr_date varchar2(15) -- 实际到期日
    ,d_code varchar2(60) -- 债券内部代码
    ,b_p_class varchar2(90) -- 债券产品分类
    ,b_actual_issue_amount number(38,8) -- 实际发行量
    ,chinesespell varchar2(75) -- 中文拼写  中文拼写
    ,b_coupon_prec number(22) -- 利率精度
    ,host_market varchar2(30) -- 托管市场
    ,bj_market varchar2(30) -- 薄记市场
    ,issuer_id number(22) -- 发行人id
    ,warrantor_id number(22) -- 担保人id
    ,is_delete number(22) -- 是否删除
    ,usable_flag number(22) -- 是否已生效：1： 正常 2： 新增
    ,memo varchar2(3000) -- 备注
    ,update_user varchar2(45) -- 更新人员
    ,account_user varchar2(45) -- 复核人员
    ,update_time varchar2(30) -- 更新时间
    ,account_time varchar2(30) -- 复核时间
    ,imp_date varchar2(15) -- 导入日期
    ,imp_time varchar2(29) -- 导入时间
    ,pipe_id number(22) -- 导入管道
    ,b_fst_pay_date varchar2(15) -- 首个付息日
    ,b_fst_reg_calc_start_date varchar2(15) -- 首个规则计息区间开始日
    ,b_initial_fixing_date varchar2(15) -- 首周期定息日
    ,b_pay_freq varchar2(9) -- 支付频率
    ,b_pay_bizday_convertion varchar2(45) -- 支付调整规则
    ,b_calc_freq varchar2(9) -- 计息频率
    ,b_calc_bizday_convertion varchar2(45) -- 计息调整规则
    ,b_reset_freq varchar2(9) -- 重置频率
    ,b_reset_bizday_convertion varchar2(45) -- 重置调整规则
    ,b_fixing_dates_offset varchar2(9) -- 定息日偏移
    ,b_fixing_bizday_convertion varchar2(45) -- 定息日调整规则
    ,b_fixing_precision number(22) -- 定息精度，普通债券为4，少量债券为6
    ,b_initial_rate number(12,6) -- 首周期定息利率
    ,b_multiplier number(6,4) -- 初始利率倍数
    ,b_cap_rate number(12,6) -- 初始利率上限
    ,b_floor_rate number(12,6) -- 初始利率下限
    ,b_exercise_style varchar2(2) -- 行权类型，a：美式 b：百慕大 e：欧式
    ,b_exercise_date varchar2(15) -- 首个行权日，含权债有效
    ,b_strike_price number(12,4) -- 首个执行价格，含权债有效
    ,b_compensation_rate number(12,6) -- 首个补偿利率，含权债有效
    ,p_class_act varchar2(90) -- 会计产品分类
    ,b_issuer_code varchar2(150) -- 发行人代码
    ,special_desc varchar2(4000) -- 特殊条款说明
    ,b_actual_amount_rate number(38,4) -- 发行额度占比（%）
    ,trustenhancing_type varchar2(75) -- 增信方式
    ,b_issue_list_date varchar2(15) -- 上市公告日期
    ,issue_feerate number(20,4) -- 发行费率
    ,underwriting_type varchar2(150) -- 承销方式
    ,b_extend_type varchar2(150) -- 债券扩展字段 第1位：是否可转股；第2位：是否可赎回；第3位：是否可回售；第4位：是否可转为相关债券（固息转浮息、浮息转固息)；第5位: 是否公开发行；第6位：是否永续；第7位：是否自贸区；第8位：是否权益类标识；第9位：利率债/信用债；第10位：减记条款；第11位：违约标记；第12位：临时债券标记
    ,s_type varchar2(45) -- 标准类型
    ,p_class_dv varchar2(90) -- 数据厂商债券分类
    ,p_class_ccdc varchar2(90) -- 中债债券分类
    ,q_par_value number(20,6) -- 报价面值，0：报价以债券面值报价；其它值为报价面值
    ,confirm_term varchar2(2) -- 是否完整条款，1：不完整条款；0或空值：完整条款
    ,sec_code varchar2(150) -- 证券唯一编码
    ,public_issue varchar2(2) -- 是否公开发行，0：否；1：是
    ,b_user_mtr_date varchar2(15) -- 用户指定到期日
    ,ai_daycount varchar2(45) -- 应计利息计息基准
    ,ytm_daycount varchar2(45) -- 到期收益率计息基准
    ,b_early_mtr_date varchar2(15) -- 提前到期日
    ,manage_mode varchar2(15) -- 管理模式,1:自主管理；2:委托管理,默认1
    ,bond_nature varchar2(15) -- 债券性质
    ,is_city_investment varchar2(2) -- 是否城投债
    ,perpetual varchar2(2) -- 是否永续债
    ,legal_mtr_date varchar2(15) -- 法定到期日
    ,b_plan_issue_amount number(31,8) -- 计划发行量
    ,is_default varchar2(2) -- 是否违约
    ,cf_daycount varchar2(45) -- 前台现金流计息基准
    ,ai_daycount_back varchar2(45) -- 后台应计利息计息基准
    ,ytm_daycount_back varchar2(45) -- 后台到期收益率计息基准
    ,cf_daycount_back varchar2(45) -- 后台现金流计息基准
    ,is_temp number(1,0) -- 是否临时代码，0：否；1：是
    ,b_ext_rating varchar2(15) -- 最新债项评级
    ,b_ext_rating_institution varchar2(150) -- 最新债项评级机构
    ,b_issuer_ext_rating varchar2(15) -- 最新发行人评级
    ,b_issuer_ext_r_institution varchar2(150) -- 最新发行人评级机构
    ,b_fst_ext_rating varchar2(15) -- 债项首次评级
    ,b_fst_ext_rating_inst varchar2(150) -- 债项首次评级机构
    ,b_fst_issuer_ext_rating varchar2(15) -- 发行人首次评级
    ,b_fst_issuer_ext_r_inst varchar2(150) -- 发行人首次评级机构
    ,b_as_asset_type_name varchar2(150) -- 基础资产类型名称(仅对abs债券有效)
    ,ref_yield number(12,6) -- 参考收益率
    ,warrantor_responsibility varchar2(2) -- 担保人是否有连带责任,0-否,1-是
    ,debts_registration_date varchar2(15) -- 债权债务登记日
    ,guarantor_rating number(10,2) -- 担保人评级
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
grant select on ${iol_schema}.ibms_tbnd to ${iml_schema};
grant select on ${iol_schema}.ibms_tbnd to ${icl_schema};
grant select on ${iol_schema}.ibms_tbnd to ${idl_schema};
grant select on ${iol_schema}.ibms_tbnd to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tbnd is '债券基本信息表';
comment on column ${iol_schema}.ibms_tbnd.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_tbnd.a_type is '资产类型';
comment on column ${iol_schema}.ibms_tbnd.m_type is '市场类型';
comment on column ${iol_schema}.ibms_tbnd.sh_code is '上交所代码';
comment on column ${iol_schema}.ibms_tbnd.sz_code is '深交所代码';
comment on column ${iol_schema}.ibms_tbnd.yh_code is '银行间代码';
comment on column ${iol_schema}.ibms_tbnd.currency is '币种';
comment on column ${iol_schema}.ibms_tbnd.country is '国家';
comment on column ${iol_schema}.ibms_tbnd.q_type is '报价方式';
comment on column ${iol_schema}.ibms_tbnd.b_name is '债券名称';
comment on column ${iol_schema}.ibms_tbnd.p_type is '产品类型';
comment on column ${iol_schema}.ibms_tbnd.p_class is '产品分类';
comment on column ${iol_schema}.ibms_tbnd.b_par_value is '面额';
comment on column ${iol_schema}.ibms_tbnd.b_issue_price is '发行价格';
comment on column ${iol_schema}.ibms_tbnd.b_issue_date is '发行日期';
comment on column ${iol_schema}.ibms_tbnd.b_list_date is '上市时间';
comment on column ${iol_schema}.ibms_tbnd.b_start_date is '起息日';
comment on column ${iol_schema}.ibms_tbnd.b_mtr_date is '到期日';
comment on column ${iol_schema}.ibms_tbnd.b_term is '期限';
comment on column ${iol_schema}.ibms_tbnd.b_daycount is '计息基准';
comment on column ${iol_schema}.ibms_tbnd.i_code_bench is '基准利率代码';
comment on column ${iol_schema}.ibms_tbnd.a_type_bench is '基准利率资产类型';
comment on column ${iol_schema}.ibms_tbnd.m_type_bench is '基准利率市场类型';
comment on column ${iol_schema}.ibms_tbnd.b_issue_mode is '发行方式';
comment on column ${iol_schema}.ibms_tbnd.b_coupon_type is '票息类型';
comment on column ${iol_schema}.ibms_tbnd.b_cash_times is '付息次数';
comment on column ${iol_schema}.ibms_tbnd.b_embopt_type is '含权类型';
comment on column ${iol_schema}.ibms_tbnd.b_amortizing is '本金偿还类型';
comment on column ${iol_schema}.ibms_tbnd.b_as_type is '资产化类型';
comment on column ${iol_schema}.ibms_tbnd.b_issuer is '发行机构';
comment on column ${iol_schema}.ibms_tbnd.b_warrantor is '担保机构';
comment on column ${iol_schema}.ibms_tbnd.b_seniority is '清偿等级';
comment on column ${iol_schema}.ibms_tbnd.b_fpml is '条款fpml';
comment on column ${iol_schema}.ibms_tbnd.b_coupon is '利率/利差';
comment on column ${iol_schema}.ibms_tbnd.b_name_full is '债券全称';
comment on column ${iol_schema}.ibms_tbnd.b_actual_mtr_date is '实际到期日';
comment on column ${iol_schema}.ibms_tbnd.d_code is '债券内部代码';
comment on column ${iol_schema}.ibms_tbnd.b_p_class is '债券产品分类';
comment on column ${iol_schema}.ibms_tbnd.b_actual_issue_amount is '实际发行量';
comment on column ${iol_schema}.ibms_tbnd.chinesespell is '中文拼写  中文拼写';
comment on column ${iol_schema}.ibms_tbnd.b_coupon_prec is '利率精度';
comment on column ${iol_schema}.ibms_tbnd.host_market is '托管市场';
comment on column ${iol_schema}.ibms_tbnd.bj_market is '薄记市场';
comment on column ${iol_schema}.ibms_tbnd.issuer_id is '发行人id';
comment on column ${iol_schema}.ibms_tbnd.warrantor_id is '担保人id';
comment on column ${iol_schema}.ibms_tbnd.is_delete is '是否删除';
comment on column ${iol_schema}.ibms_tbnd.usable_flag is '是否已生效：1： 正常 2： 新增';
comment on column ${iol_schema}.ibms_tbnd.memo is '备注';
comment on column ${iol_schema}.ibms_tbnd.update_user is '更新人员';
comment on column ${iol_schema}.ibms_tbnd.account_user is '复核人员';
comment on column ${iol_schema}.ibms_tbnd.update_time is '更新时间';
comment on column ${iol_schema}.ibms_tbnd.account_time is '复核时间';
comment on column ${iol_schema}.ibms_tbnd.imp_date is '导入日期';
comment on column ${iol_schema}.ibms_tbnd.imp_time is '导入时间';
comment on column ${iol_schema}.ibms_tbnd.pipe_id is '导入管道';
comment on column ${iol_schema}.ibms_tbnd.b_fst_pay_date is '首个付息日';
comment on column ${iol_schema}.ibms_tbnd.b_fst_reg_calc_start_date is '首个规则计息区间开始日';
comment on column ${iol_schema}.ibms_tbnd.b_initial_fixing_date is '首周期定息日';
comment on column ${iol_schema}.ibms_tbnd.b_pay_freq is '支付频率';
comment on column ${iol_schema}.ibms_tbnd.b_pay_bizday_convertion is '支付调整规则';
comment on column ${iol_schema}.ibms_tbnd.b_calc_freq is '计息频率';
comment on column ${iol_schema}.ibms_tbnd.b_calc_bizday_convertion is '计息调整规则';
comment on column ${iol_schema}.ibms_tbnd.b_reset_freq is '重置频率';
comment on column ${iol_schema}.ibms_tbnd.b_reset_bizday_convertion is '重置调整规则';
comment on column ${iol_schema}.ibms_tbnd.b_fixing_dates_offset is '定息日偏移';
comment on column ${iol_schema}.ibms_tbnd.b_fixing_bizday_convertion is '定息日调整规则';
comment on column ${iol_schema}.ibms_tbnd.b_fixing_precision is '定息精度，普通债券为4，少量债券为6';
comment on column ${iol_schema}.ibms_tbnd.b_initial_rate is '首周期定息利率';
comment on column ${iol_schema}.ibms_tbnd.b_multiplier is '初始利率倍数';
comment on column ${iol_schema}.ibms_tbnd.b_cap_rate is '初始利率上限';
comment on column ${iol_schema}.ibms_tbnd.b_floor_rate is '初始利率下限';
comment on column ${iol_schema}.ibms_tbnd.b_exercise_style is '行权类型，a：美式 b：百慕大 e：欧式';
comment on column ${iol_schema}.ibms_tbnd.b_exercise_date is '首个行权日，含权债有效';
comment on column ${iol_schema}.ibms_tbnd.b_strike_price is '首个执行价格，含权债有效';
comment on column ${iol_schema}.ibms_tbnd.b_compensation_rate is '首个补偿利率，含权债有效';
comment on column ${iol_schema}.ibms_tbnd.p_class_act is '会计产品分类';
comment on column ${iol_schema}.ibms_tbnd.b_issuer_code is '发行人代码';
comment on column ${iol_schema}.ibms_tbnd.special_desc is '特殊条款说明';
comment on column ${iol_schema}.ibms_tbnd.b_actual_amount_rate is '发行额度占比（%）';
comment on column ${iol_schema}.ibms_tbnd.trustenhancing_type is '增信方式';
comment on column ${iol_schema}.ibms_tbnd.b_issue_list_date is '上市公告日期';
comment on column ${iol_schema}.ibms_tbnd.issue_feerate is '发行费率';
comment on column ${iol_schema}.ibms_tbnd.underwriting_type is '承销方式';
comment on column ${iol_schema}.ibms_tbnd.b_extend_type is '债券扩展字段 第1位：是否可转股；第2位：是否可赎回；第3位：是否可回售；第4位：是否可转为相关债券（固息转浮息、浮息转固息)；第5位: 是否公开发行；第6位：是否永续；第7位：是否自贸区；第8位：是否权益类标识；第9位：利率债/信用债；第10位：减记条款；第11位：违约标记；第12位：临时债券标记';
comment on column ${iol_schema}.ibms_tbnd.s_type is '标准类型';
comment on column ${iol_schema}.ibms_tbnd.p_class_dv is '数据厂商债券分类';
comment on column ${iol_schema}.ibms_tbnd.p_class_ccdc is '中债债券分类';
comment on column ${iol_schema}.ibms_tbnd.q_par_value is '报价面值，0：报价以债券面值报价；其它值为报价面值';
comment on column ${iol_schema}.ibms_tbnd.confirm_term is '是否完整条款，1：不完整条款；0或空值：完整条款';
comment on column ${iol_schema}.ibms_tbnd.sec_code is '证券唯一编码';
comment on column ${iol_schema}.ibms_tbnd.public_issue is '是否公开发行，0：否；1：是';
comment on column ${iol_schema}.ibms_tbnd.b_user_mtr_date is '用户指定到期日';
comment on column ${iol_schema}.ibms_tbnd.ai_daycount is '应计利息计息基准';
comment on column ${iol_schema}.ibms_tbnd.ytm_daycount is '到期收益率计息基准';
comment on column ${iol_schema}.ibms_tbnd.b_early_mtr_date is '提前到期日';
comment on column ${iol_schema}.ibms_tbnd.manage_mode is '管理模式,1:自主管理；2:委托管理,默认1';
comment on column ${iol_schema}.ibms_tbnd.bond_nature is '债券性质';
comment on column ${iol_schema}.ibms_tbnd.is_city_investment is '是否城投债';
comment on column ${iol_schema}.ibms_tbnd.perpetual is '是否永续债';
comment on column ${iol_schema}.ibms_tbnd.legal_mtr_date is '法定到期日';
comment on column ${iol_schema}.ibms_tbnd.b_plan_issue_amount is '计划发行量';
comment on column ${iol_schema}.ibms_tbnd.is_default is '是否违约';
comment on column ${iol_schema}.ibms_tbnd.cf_daycount is '前台现金流计息基准';
comment on column ${iol_schema}.ibms_tbnd.ai_daycount_back is '后台应计利息计息基准';
comment on column ${iol_schema}.ibms_tbnd.ytm_daycount_back is '后台到期收益率计息基准';
comment on column ${iol_schema}.ibms_tbnd.cf_daycount_back is '后台现金流计息基准';
comment on column ${iol_schema}.ibms_tbnd.is_temp is '是否临时代码，0：否；1：是';
comment on column ${iol_schema}.ibms_tbnd.b_ext_rating is '最新债项评级';
comment on column ${iol_schema}.ibms_tbnd.b_ext_rating_institution is '最新债项评级机构';
comment on column ${iol_schema}.ibms_tbnd.b_issuer_ext_rating is '最新发行人评级';
comment on column ${iol_schema}.ibms_tbnd.b_issuer_ext_r_institution is '最新发行人评级机构';
comment on column ${iol_schema}.ibms_tbnd.b_fst_ext_rating is '债项首次评级';
comment on column ${iol_schema}.ibms_tbnd.b_fst_ext_rating_inst is '债项首次评级机构';
comment on column ${iol_schema}.ibms_tbnd.b_fst_issuer_ext_rating is '发行人首次评级';
comment on column ${iol_schema}.ibms_tbnd.b_fst_issuer_ext_r_inst is '发行人首次评级机构';
comment on column ${iol_schema}.ibms_tbnd.b_as_asset_type_name is '基础资产类型名称(仅对abs债券有效)';
comment on column ${iol_schema}.ibms_tbnd.ref_yield is '参考收益率';
comment on column ${iol_schema}.ibms_tbnd.warrantor_responsibility is '担保人是否有连带责任,0-否,1-是';
comment on column ${iol_schema}.ibms_tbnd.debts_registration_date is '债权债务登记日';
comment on column ${iol_schema}.ibms_tbnd.guarantor_rating is '担保人评级';
comment on column ${iol_schema}.ibms_tbnd.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_tbnd.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_tbnd.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_tbnd.etl_timestamp is 'ETL处理时间戳';
