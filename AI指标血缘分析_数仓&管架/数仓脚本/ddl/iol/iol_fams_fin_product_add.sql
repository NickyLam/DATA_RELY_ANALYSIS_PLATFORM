/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_product_add
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_product_add
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_product_add purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_product_add(
    finprod_id varchar2(50) -- 金融产品代码
    ,sale_department varchar2(50) -- 销售部门，零售产品管理部、金融同业部、对公产品和现金管理部
    ,sale_layer varchar2(32) -- 销售分层
    ,sale_period number(10) -- 销售期次
    ,pur_speed number(10) -- 申购确认速度，如果资产只有一个确认速度，则存该字段
    ,red_speed number(10) -- 赎回确认速度
    ,is_sec_bond varchar2(50) -- 是否次级债
    ,wind_id varchar2(100) -- wind对象id
    ,is_auto_update varchar2(50) -- 是否接口自动更新
    ,portfolio_id varchar2(32) -- 投资组合代码
    ,prod_regist_code varchar2(15) -- 产品登记编码
    ,is_cycle varchar2(50) -- 是否周期型
    ,is_lay varchar2(50) -- 是否分层
    ,lay_type varchar2(50) -- 分层类型，金额分层、期限分层、客户类型
    ,invest_nature varchar2(50) -- 投资性质，固定收益类、权益类、商品及金融衍生品类、混合类
    ,profit_flag varchar2(50) -- 收益标识，非保本浮动收益型、保本浮动、保证收益型
    ,sale_mode varchar2(50) -- 销售模式，直销、代销、委托
    ,chb_id varchar2(32) -- 中债报送编码
    ,tmpl_id varchar2(50) -- 产品模板代码
    ,close_days number(10) -- 封闭期限(天)，产品每次开放对应的封闭期限
    ,issue_status varchar2(50) -- 产品发行状态
    ,issue_status_remark varchar2(1000) -- 发行状态备注
    ,is_compound_int varchar2(50) -- 是否按日复利
    ,term_type varchar2(50) -- 期限品种
    ,face_value number(30,14) -- 面值，债券单位面值
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,pay_type varchar2(50) -- 划款方式
    ,is_reconciliation varchar2(50) -- 是否对账
    ,is_cash_manage varchar2(50) -- 是否现金管理类
    ,risk_level varchar2(50) -- 产品风险等级
    ,deal_mode varchar2(50) -- 处理模式
    ,is_exclusive varchar2(50) -- 是否专属产品
    ,bid_date date -- 投标日期
    ,board varchar2(50) -- 上市板
    ,sh_or_zh varchar2(50) -- 是否沪港通或深港通
    ,is_margin_finprod varchar2(50) -- 是否融资融券标的
    ,city_bond_lev varchar2(50) -- 城投债级别
    ,is_city_bond varchar2(50) -- 是否城投债
    ,investment_cycle varchar2(50) -- 投资周期
    ,prod_manager varchar2(50) -- 产品经理
    ,collect_type varchar2(50) -- 收取方式
    ,regulatory_rating varchar2(1000) -- 监管评级
    ,toff_enddate date -- 认购终止日
    ,trm_fund_abbr varchar2(200) -- 交易所基金简称
    ,trm_fund_type varchar2(50) -- 交易所基金类型
    ,gra_fund_type varchar2(50) -- 分级基金
    ,pur_red_id varchar2(50) -- 申购赎回代码
    ,pur_red_abbr varchar2(200) -- 申购赎回简称
    ,pur_start_low number(30,2) -- 单笔申购金额下限
    ,red_start_low number(30,2) -- 单笔赎回份额下限
    ,etf_type varchar2(50) -- etf类型
    ,etf_min_prunit number(30,2) -- etf最小申购赎回单位
    ,toff_strdate date -- 认购起始日
    ,org_code varchar2(32) -- 所属机构
    ,invest_manager varchar2(50) -- 投资经理
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
grant select on ${iol_schema}.fams_fin_product_add to ${iml_schema};
grant select on ${iol_schema}.fams_fin_product_add to ${icl_schema};
grant select on ${iol_schema}.fams_fin_product_add to ${idl_schema};
grant select on ${iol_schema}.fams_fin_product_add to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_product_add is '标的类金融产品附属表';
comment on column ${iol_schema}.fams_fin_product_add.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_fin_product_add.sale_department is '销售部门，零售产品管理部、金融同业部、对公产品和现金管理部';
comment on column ${iol_schema}.fams_fin_product_add.sale_layer is '销售分层';
comment on column ${iol_schema}.fams_fin_product_add.sale_period is '销售期次';
comment on column ${iol_schema}.fams_fin_product_add.pur_speed is '申购确认速度，如果资产只有一个确认速度，则存该字段';
comment on column ${iol_schema}.fams_fin_product_add.red_speed is '赎回确认速度';
comment on column ${iol_schema}.fams_fin_product_add.is_sec_bond is '是否次级债';
comment on column ${iol_schema}.fams_fin_product_add.wind_id is 'wind对象id';
comment on column ${iol_schema}.fams_fin_product_add.is_auto_update is '是否接口自动更新';
comment on column ${iol_schema}.fams_fin_product_add.portfolio_id is '投资组合代码';
comment on column ${iol_schema}.fams_fin_product_add.prod_regist_code is '产品登记编码';
comment on column ${iol_schema}.fams_fin_product_add.is_cycle is '是否周期型';
comment on column ${iol_schema}.fams_fin_product_add.is_lay is '是否分层';
comment on column ${iol_schema}.fams_fin_product_add.lay_type is '分层类型，金额分层、期限分层、客户类型';
comment on column ${iol_schema}.fams_fin_product_add.invest_nature is '投资性质，固定收益类、权益类、商品及金融衍生品类、混合类';
comment on column ${iol_schema}.fams_fin_product_add.profit_flag is '收益标识，非保本浮动收益型、保本浮动、保证收益型';
comment on column ${iol_schema}.fams_fin_product_add.sale_mode is '销售模式，直销、代销、委托';
comment on column ${iol_schema}.fams_fin_product_add.chb_id is '中债报送编码';
comment on column ${iol_schema}.fams_fin_product_add.tmpl_id is '产品模板代码';
comment on column ${iol_schema}.fams_fin_product_add.close_days is '封闭期限(天)，产品每次开放对应的封闭期限';
comment on column ${iol_schema}.fams_fin_product_add.issue_status is '产品发行状态';
comment on column ${iol_schema}.fams_fin_product_add.issue_status_remark is '发行状态备注';
comment on column ${iol_schema}.fams_fin_product_add.is_compound_int is '是否按日复利';
comment on column ${iol_schema}.fams_fin_product_add.term_type is '期限品种';
comment on column ${iol_schema}.fams_fin_product_add.face_value is '面值，债券单位面值';
comment on column ${iol_schema}.fams_fin_product_add.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_product_add.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_product_add.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_product_add.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_product_add.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_product_add.pay_type is '划款方式';
comment on column ${iol_schema}.fams_fin_product_add.is_reconciliation is '是否对账';
comment on column ${iol_schema}.fams_fin_product_add.is_cash_manage is '是否现金管理类';
comment on column ${iol_schema}.fams_fin_product_add.risk_level is '产品风险等级';
comment on column ${iol_schema}.fams_fin_product_add.deal_mode is '处理模式';
comment on column ${iol_schema}.fams_fin_product_add.is_exclusive is '是否专属产品';
comment on column ${iol_schema}.fams_fin_product_add.bid_date is '投标日期';
comment on column ${iol_schema}.fams_fin_product_add.board is '上市板';
comment on column ${iol_schema}.fams_fin_product_add.sh_or_zh is '是否沪港通或深港通';
comment on column ${iol_schema}.fams_fin_product_add.is_margin_finprod is '是否融资融券标的';
comment on column ${iol_schema}.fams_fin_product_add.city_bond_lev is '城投债级别';
comment on column ${iol_schema}.fams_fin_product_add.is_city_bond is '是否城投债';
comment on column ${iol_schema}.fams_fin_product_add.investment_cycle is '投资周期';
comment on column ${iol_schema}.fams_fin_product_add.prod_manager is '产品经理';
comment on column ${iol_schema}.fams_fin_product_add.collect_type is '收取方式';
comment on column ${iol_schema}.fams_fin_product_add.regulatory_rating is '监管评级';
comment on column ${iol_schema}.fams_fin_product_add.toff_enddate is '认购终止日';
comment on column ${iol_schema}.fams_fin_product_add.trm_fund_abbr is '交易所基金简称';
comment on column ${iol_schema}.fams_fin_product_add.trm_fund_type is '交易所基金类型';
comment on column ${iol_schema}.fams_fin_product_add.gra_fund_type is '分级基金';
comment on column ${iol_schema}.fams_fin_product_add.pur_red_id is '申购赎回代码';
comment on column ${iol_schema}.fams_fin_product_add.pur_red_abbr is '申购赎回简称';
comment on column ${iol_schema}.fams_fin_product_add.pur_start_low is '单笔申购金额下限';
comment on column ${iol_schema}.fams_fin_product_add.red_start_low is '单笔赎回份额下限';
comment on column ${iol_schema}.fams_fin_product_add.etf_type is 'etf类型';
comment on column ${iol_schema}.fams_fin_product_add.etf_min_prunit is 'etf最小申购赎回单位';
comment on column ${iol_schema}.fams_fin_product_add.toff_strdate is '认购起始日';
comment on column ${iol_schema}.fams_fin_product_add.org_code is '所属机构';
comment on column ${iol_schema}.fams_fin_product_add.invest_manager is '投资经理';
comment on column ${iol_schema}.fams_fin_product_add.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fin_product_add.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fin_product_add.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fin_product_add.etl_timestamp is 'ETL处理时间戳';
