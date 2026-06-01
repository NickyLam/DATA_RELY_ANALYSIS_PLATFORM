/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_trade_product
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_trade_product
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_trade_product purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_trade_product(
    finprod_id varchar2(50) -- 金融产品代码
    ,branch number(10) -- 分支序号
    ,finprod_type varchar2(50) -- 金融产品类型（估值核算），回购、拆借、利率互换等
    ,finprod_type2 varchar2(50) -- 金融产品类型（投管分类），回购、拆入、拆出、特拆拆入、利率互换、理财产品子产品等
    ,profit_type varchar2(50) -- 收益类型，净值、预期收益、货币、结构
    ,branch_type varchar2(50) -- 分支类型
    ,chl_agrt_id varchar2(32) -- 通道代码
    ,prin number(30,2) -- 名义本金
    ,ccy varchar2(50) -- 本金币种
    ,vdate date -- 起息日
    ,mdate date -- 到期日
    ,term number(10) -- 期限(天)
    ,int_type varchar2(50) -- 利率类型
    ,int_rate number(30,14) -- 固定利率
    ,int_rate_id varchar2(32) -- 浮动利率基准编号
    ,basis varchar2(50) -- 计息基础
    ,m_prin_amt number(30,2) -- 到期本金
    ,m_int_amt number(30,2) -- 到期利息
    ,m_trade_amt number(30,2) -- 到期金额
    ,capi_income_feature varchar2(50) -- 本金收益特征，保本、非保本
    ,o_finprod_id varchar2(50) -- 原金融产品代码，发生标的转换时用
    ,trade_market varchar2(50) -- 交易场所
    ,calendar_id varchar2(32) -- 交易日历
    ,term_type varchar2(50) -- 期限品种
    ,counter_id varchar2(32) -- 交易对手
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,m_unit_cprice number(30,14) -- 
    ,m_unit_int number(30,14) -- 
    ,m_unit_fprice number(30,14) -- 
    ,m_yield number(30,14) -- 
    ,m_delivery_type varchar2(50) -- 
    ,vpay_date date -- 首期交付日
    ,mpay_date date -- 到期交付日
    ,contract_no varchar2(200) -- 合同编号
    ,act_cap_days number(10) -- 实际占款天数
    ,irs_type varchar2(50) -- 互换方式
    ,exc_ps varchar2(50) -- 外汇交易方向
    ,cur_pair varchar2(50) -- 货币对
    ,exc_fxs_term_type varchar2(50) -- 掉期期限类型
    ,usd_amt number(30,2) -- 到期折美元金额
    ,dif_settle_ref_rate varchar2(50) -- 差额交割参考汇率
    ,conflict_solve_way varchar2(50) -- 争议解决方式
    ,period_id varchar2(50) -- 期次代码
    ,is_rush_back varchar2(50) -- 截止日是否冲回
    ,contract_name varchar2(200) -- 合同名称
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_fin_trade_product to ${iml_schema};
grant select on ${iol_schema}.fams_fin_trade_product to ${icl_schema};
grant select on ${iol_schema}.fams_fin_trade_product to ${idl_schema};
grant select on ${iol_schema}.fams_fin_trade_product to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_trade_product is '交易类金融产品';
comment on column ${iol_schema}.fams_fin_trade_product.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_fin_trade_product.branch is '分支序号';
comment on column ${iol_schema}.fams_fin_trade_product.finprod_type is '金融产品类型（估值核算），回购、拆借、利率互换等';
comment on column ${iol_schema}.fams_fin_trade_product.finprod_type2 is '金融产品类型（投管分类），回购、拆入、拆出、特拆拆入、利率互换、理财产品子产品等';
comment on column ${iol_schema}.fams_fin_trade_product.profit_type is '收益类型，净值、预期收益、货币、结构';
comment on column ${iol_schema}.fams_fin_trade_product.branch_type is '分支类型';
comment on column ${iol_schema}.fams_fin_trade_product.chl_agrt_id is '通道代码';
comment on column ${iol_schema}.fams_fin_trade_product.prin is '名义本金';
comment on column ${iol_schema}.fams_fin_trade_product.ccy is '本金币种';
comment on column ${iol_schema}.fams_fin_trade_product.vdate is '起息日';
comment on column ${iol_schema}.fams_fin_trade_product.mdate is '到期日';
comment on column ${iol_schema}.fams_fin_trade_product.term is '期限(天)';
comment on column ${iol_schema}.fams_fin_trade_product.int_type is '利率类型';
comment on column ${iol_schema}.fams_fin_trade_product.int_rate is '固定利率';
comment on column ${iol_schema}.fams_fin_trade_product.int_rate_id is '浮动利率基准编号';
comment on column ${iol_schema}.fams_fin_trade_product.basis is '计息基础';
comment on column ${iol_schema}.fams_fin_trade_product.m_prin_amt is '到期本金';
comment on column ${iol_schema}.fams_fin_trade_product.m_int_amt is '到期利息';
comment on column ${iol_schema}.fams_fin_trade_product.m_trade_amt is '到期金额';
comment on column ${iol_schema}.fams_fin_trade_product.capi_income_feature is '本金收益特征，保本、非保本';
comment on column ${iol_schema}.fams_fin_trade_product.o_finprod_id is '原金融产品代码，发生标的转换时用';
comment on column ${iol_schema}.fams_fin_trade_product.trade_market is '交易场所';
comment on column ${iol_schema}.fams_fin_trade_product.calendar_id is '交易日历';
comment on column ${iol_schema}.fams_fin_trade_product.term_type is '期限品种';
comment on column ${iol_schema}.fams_fin_trade_product.counter_id is '交易对手';
comment on column ${iol_schema}.fams_fin_trade_product.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_trade_product.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_trade_product.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_trade_product.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_trade_product.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_trade_product.m_unit_cprice is '';
comment on column ${iol_schema}.fams_fin_trade_product.m_unit_int is '';
comment on column ${iol_schema}.fams_fin_trade_product.m_unit_fprice is '';
comment on column ${iol_schema}.fams_fin_trade_product.m_yield is '';
comment on column ${iol_schema}.fams_fin_trade_product.m_delivery_type is '';
comment on column ${iol_schema}.fams_fin_trade_product.vpay_date is '首期交付日';
comment on column ${iol_schema}.fams_fin_trade_product.mpay_date is '到期交付日';
comment on column ${iol_schema}.fams_fin_trade_product.contract_no is '合同编号';
comment on column ${iol_schema}.fams_fin_trade_product.act_cap_days is '实际占款天数';
comment on column ${iol_schema}.fams_fin_trade_product.irs_type is '互换方式';
comment on column ${iol_schema}.fams_fin_trade_product.exc_ps is '外汇交易方向';
comment on column ${iol_schema}.fams_fin_trade_product.cur_pair is '货币对';
comment on column ${iol_schema}.fams_fin_trade_product.exc_fxs_term_type is '掉期期限类型';
comment on column ${iol_schema}.fams_fin_trade_product.usd_amt is '到期折美元金额';
comment on column ${iol_schema}.fams_fin_trade_product.dif_settle_ref_rate is '差额交割参考汇率';
comment on column ${iol_schema}.fams_fin_trade_product.conflict_solve_way is '争议解决方式';
comment on column ${iol_schema}.fams_fin_trade_product.period_id is '期次代码';
comment on column ${iol_schema}.fams_fin_trade_product.is_rush_back is '截止日是否冲回';
comment on column ${iol_schema}.fams_fin_trade_product.contract_name is '合同名称';
comment on column ${iol_schema}.fams_fin_trade_product.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fin_trade_product.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fin_trade_product.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fin_trade_product.etl_timestamp is 'ETL处理时间戳';
