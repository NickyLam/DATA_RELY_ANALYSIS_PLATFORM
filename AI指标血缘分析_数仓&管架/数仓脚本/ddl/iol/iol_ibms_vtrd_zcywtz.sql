/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_vtrd_zcywtz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_vtrd_zcywtz
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_vtrd_zcywtz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_zcywtz(
    obj_id varchar2(45) -- 核算id
    ,beg_date varchar2(15) -- 余额日期
    ,org_id varchar2(45) -- 机构号
    ,trade_id varchar2(45) -- 交易单号
    ,secu_acct_name varchar2(180) -- 投组单元
    ,dict_value varchar2(4000) -- 会计分类
    ,p_type_name varchar2(150) -- 产品类型
    ,p_class varchar2(150) -- 产品分类
    ,i_code varchar2(125) -- 金融工具代码
    ,i_name varchar2(383) -- 金融工具名称
    ,trd_orddate varchar2(30) -- 交易日期
    ,trd_party_name varchar2(383) -- 交易对手
    ,trd_party_class varchar2(600) -- 交易对手客户分类
    ,issue_name varchar2(684) -- 发行人/实际融资人
    ,issue_class varchar2(300) -- 实际融资人客户分类
    ,exhacc varchar2(75) -- 划款账号
    ,party_acct_code varchar2(300) -- 收款账号
    ,currency varchar2(300) -- 币种
    ,cp number(22,0) -- 投资本金
    ,coupon number(22,0) -- 执行利率
    ,open_date varchar2(15) -- 起息日
    ,end_date varchar2(15) -- 到期日
    ,inst_start_date varchar2(60) -- 原始期限
    ,inst_mrt_date number(22,0) -- 剩余期限
    ,first_payment_date varchar2(30) -- 首次付息日
    ,pay_freq_name varchar2(4000) -- 付息频率
    ,daycount_name varchar2(1500) -- 计息基准
    ,coupon_type_name varchar2(1500) -- 息票类型
    ,tzye number(22,0) -- 投资余额
    ,ai number(22,0) -- 应计利息
    ,prft_ir number(22,0) -- 利息收入
    ,zmye number(22,0) -- 账面余额
    ,business_category_name varchar2(1500) -- 投向行业门类
    ,business_category_min_name varchar2(1500) -- 投向行业大类
    ,s_grade varchar2(32) -- 债项/主体评级
    ,g31_plass varchar2(1500) -- g31分类
    ,final_invest_name varchar2(4000) -- 最终投向类型
    ,management_mode varchar2(12) -- 管理方式
    ,raise_way varchar2(6) -- 产品募集方式
    ,tzcplx varchar2(1500) -- 投资产品类型
    ,under_debt_class varchar2(4000) -- 底层为债券的债券分类
    ,under_debt_rating varchar2(4000) -- 底层为债券的评级
    ,hx_isgover_fund varchar2(3) -- 是否政府投资基金
    ,is_pioneer_invest_fund varchar2(3) -- 是否创业投资基金
    ,hx_isdistbus varchar2(3) -- 是否异地业务
    ,hx_islocfinanc varchar2(3) -- 是否地方政府融资平台
    ,risk_assets_weight number(22,0) -- 风险权重
    ,trader varchar2(150) -- 经办人
    ,op_user_name1 varchar2(150) -- 总行经办人
    ,op_user_name2 varchar2(150) -- 总行复核人
    ,cp_subj_code varchar2(150) -- 本金科目号
    ,ai_tax_rate number(22,0) -- 增值税税率(应计利息收入)
    ,amrt_tax_rate number(22,0) -- 增值税税率(摊销利息收入)
    ,trd_tax_rate number(22,0) -- 增值税税率(买卖损益)
    ,ibs varchar2(5) -- 数据来源
    ,hxkhh varchar2(75) -- 交易对手核心客户号
    ,hxkhh1 varchar2(75) -- 实际融资人核心客户号
    ,mid_invest_industry_categories varchar2(1500) -- 投向行业中类
    ,invest_industry_subcategories varchar2(1500) -- 投向行业细类
    ,funds_purpose varchar2(150) -- 资金用途
    ,guarantee_method varchar2(4000) -- 担保方式
    ,credit_methods varchar2(4000) -- 增信方式
    ,credit_cust varchar2(450) -- 增信主体
    ,datamark varchar2(1671) -- 唯一标识
    ,month_repay_record varchar2(4000) -- 当月还本记录
    ,month_average number -- 月日均
    ,year_average number -- 年日均
    ,in_due_ai number -- 表内应收未收利息
    ,out_due_ai number -- 表外应收利息
    ,this_month_prft_ir number -- 利息收入（当月）
    ,this_year_prft_ir number -- 利息收入（本年）
    ,year_chg_fv number -- 公允价值变动（年初）
    ,month_chg_fv number -- 公允价值变动（当月）
    ,year_prft_fv_real number -- 公允价值变动损益（本年）
    ,year_prft_trd number -- 买卖损益（本年）
    ,prft_ir_subj_code varchar2(150) -- 利息损益科目号
    ,prft_trd_subj_code varchar2(150) -- 价差损益科目号
    ,chg_fv_subj_code varchar2(150) -- 估值损益科目号
    ,basic_asset_clients varchar2(4000) -- 基础资产客户
    ,underly_types_assets varchar2(1500) -- 底层资产类型
    ,guarantee_description varchar2(383) -- 担保描述
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
grant select on ${iol_schema}.ibms_vtrd_zcywtz to ${iml_schema};
grant select on ${iol_schema}.ibms_vtrd_zcywtz to ${icl_schema};
grant select on ${iol_schema}.ibms_vtrd_zcywtz to ${idl_schema};
grant select on ${iol_schema}.ibms_vtrd_zcywtz to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_vtrd_zcywtz is '资产业务信息台账';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.obj_id is '核算id';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.beg_date is '余额日期';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.org_id is '机构号';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.trade_id is '交易单号';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.secu_acct_name is '投组单元';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.dict_value is '会计分类';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.p_type_name is '产品类型';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.p_class is '产品分类';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.i_name is '金融工具名称';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.trd_orddate is '交易日期';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.trd_party_name is '交易对手';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.trd_party_class is '交易对手客户分类';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.issue_name is '发行人/实际融资人';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.issue_class is '实际融资人客户分类';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.exhacc is '划款账号';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.party_acct_code is '收款账号';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.currency is '币种';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.cp is '投资本金';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.coupon is '执行利率';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.open_date is '起息日';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.end_date is '到期日';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.inst_start_date is '原始期限';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.inst_mrt_date is '剩余期限';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.first_payment_date is '首次付息日';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.pay_freq_name is '付息频率';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.daycount_name is '计息基准';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.coupon_type_name is '息票类型';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.tzye is '投资余额';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.ai is '应计利息';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.prft_ir is '利息收入';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.zmye is '账面余额';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.business_category_name is '投向行业门类';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.business_category_min_name is '投向行业大类';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.s_grade is '债项/主体评级';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.g31_plass is 'g31分类';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.final_invest_name is '最终投向类型';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.management_mode is '管理方式';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.raise_way is '产品募集方式';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.tzcplx is '投资产品类型';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.under_debt_class is '底层为债券的债券分类';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.under_debt_rating is '底层为债券的评级';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.hx_isgover_fund is '是否政府投资基金';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.is_pioneer_invest_fund is '是否创业投资基金';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.hx_isdistbus is '是否异地业务';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.hx_islocfinanc is '是否地方政府融资平台';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.risk_assets_weight is '风险权重';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.trader is '经办人';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.op_user_name1 is '总行经办人';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.op_user_name2 is '总行复核人';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.cp_subj_code is '本金科目号';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.ai_tax_rate is '增值税税率(应计利息收入)';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.amrt_tax_rate is '增值税税率(摊销利息收入)';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.trd_tax_rate is '增值税税率(买卖损益)';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.ibs is '数据来源';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.hxkhh is '交易对手核心客户号';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.hxkhh1 is '实际融资人核心客户号';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.mid_invest_industry_categories is '投向行业中类';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.invest_industry_subcategories is '投向行业细类';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.funds_purpose is '资金用途';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.guarantee_method is '担保方式';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.credit_methods is '增信方式';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.credit_cust is '增信主体';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.datamark is '唯一标识';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.month_repay_record is '当月还本记录';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.month_average is '月日均';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.year_average is '年日均';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.in_due_ai is '表内应收未收利息';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.out_due_ai is '表外应收利息';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.this_month_prft_ir is '利息收入（当月）';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.this_year_prft_ir is '利息收入（本年）';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.year_chg_fv is '公允价值变动（年初）';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.month_chg_fv is '公允价值变动（当月）';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.year_prft_fv_real is '公允价值变动损益（本年）';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.year_prft_trd is '买卖损益（本年）';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.prft_ir_subj_code is '利息损益科目号';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.prft_trd_subj_code is '价差损益科目号';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.chg_fv_subj_code is '估值损益科目号';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.basic_asset_clients is '基础资产客户';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.underly_types_assets is '底层资产类型';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.guarantee_description is '担保描述';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_vtrd_zcywtz.etl_timestamp is 'ETL处理时间戳';
