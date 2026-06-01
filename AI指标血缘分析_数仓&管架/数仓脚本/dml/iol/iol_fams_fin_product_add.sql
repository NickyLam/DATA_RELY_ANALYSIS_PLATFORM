/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_fin_product_add
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
create table ${iol_schema}.fams_fin_product_add_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_fin_product_add
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_product_add_op purge;
drop table ${iol_schema}.fams_fin_product_add_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_product_add_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_product_add where 0=1;

create table ${iol_schema}.fams_fin_product_add_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_product_add where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_product_add_cl(
            finprod_id -- 金融产品代码
            ,sale_department -- 销售部门，零售产品管理部、金融同业部、对公产品和现金管理部
            ,sale_layer -- 销售分层
            ,sale_period -- 销售期次
            ,pur_speed -- 申购确认速度，如果资产只有一个确认速度，则存该字段
            ,red_speed -- 赎回确认速度
            ,is_sec_bond -- 是否次级债
            ,wind_id -- wind对象id
            ,is_auto_update -- 是否接口自动更新
            ,portfolio_id -- 投资组合代码
            ,prod_regist_code -- 产品登记编码
            ,is_cycle -- 是否周期型
            ,is_lay -- 是否分层
            ,lay_type -- 分层类型，金额分层、期限分层、客户类型
            ,invest_nature -- 投资性质，固定收益类、权益类、商品及金融衍生品类、混合类
            ,profit_flag -- 收益标识，非保本浮动收益型、保本浮动、保证收益型
            ,sale_mode -- 销售模式，直销、代销、委托
            ,chb_id -- 中债报送编码
            ,tmpl_id -- 产品模板代码
            ,close_days -- 封闭期限(天)，产品每次开放对应的封闭期限
            ,issue_status -- 产品发行状态
            ,issue_status_remark -- 发行状态备注
            ,is_compound_int -- 是否按日复利
            ,term_type -- 期限品种
            ,face_value -- 面值，债券单位面值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,pay_type -- 划款方式
            ,is_reconciliation -- 是否对账
            ,is_cash_manage -- 是否现金管理类
            ,risk_level -- 产品风险等级
            ,deal_mode -- 处理模式
            ,is_exclusive -- 是否专属产品
            ,bid_date -- 投标日期
            ,board -- 上市板
            ,sh_or_zh -- 是否沪港通或深港通
            ,is_margin_finprod -- 是否融资融券标的
            ,city_bond_lev -- 城投债级别
            ,is_city_bond -- 是否城投债
            ,investment_cycle -- 投资周期
            ,prod_manager -- 产品经理
            ,collect_type -- 收取方式
            ,regulatory_rating -- 监管评级
            ,toff_enddate -- 认购终止日
            ,trm_fund_abbr -- 交易所基金简称
            ,trm_fund_type -- 交易所基金类型
            ,gra_fund_type -- 分级基金
            ,pur_red_id -- 申购赎回代码
            ,pur_red_abbr -- 申购赎回简称
            ,pur_start_low -- 单笔申购金额下限
            ,red_start_low -- 单笔赎回份额下限
            ,etf_type -- etf类型
            ,etf_min_prunit -- etf最小申购赎回单位
            ,toff_strdate -- 认购起始日
            ,org_code -- 所属机构
            ,invest_manager -- 投资经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_product_add_op(
            finprod_id -- 金融产品代码
            ,sale_department -- 销售部门，零售产品管理部、金融同业部、对公产品和现金管理部
            ,sale_layer -- 销售分层
            ,sale_period -- 销售期次
            ,pur_speed -- 申购确认速度，如果资产只有一个确认速度，则存该字段
            ,red_speed -- 赎回确认速度
            ,is_sec_bond -- 是否次级债
            ,wind_id -- wind对象id
            ,is_auto_update -- 是否接口自动更新
            ,portfolio_id -- 投资组合代码
            ,prod_regist_code -- 产品登记编码
            ,is_cycle -- 是否周期型
            ,is_lay -- 是否分层
            ,lay_type -- 分层类型，金额分层、期限分层、客户类型
            ,invest_nature -- 投资性质，固定收益类、权益类、商品及金融衍生品类、混合类
            ,profit_flag -- 收益标识，非保本浮动收益型、保本浮动、保证收益型
            ,sale_mode -- 销售模式，直销、代销、委托
            ,chb_id -- 中债报送编码
            ,tmpl_id -- 产品模板代码
            ,close_days -- 封闭期限(天)，产品每次开放对应的封闭期限
            ,issue_status -- 产品发行状态
            ,issue_status_remark -- 发行状态备注
            ,is_compound_int -- 是否按日复利
            ,term_type -- 期限品种
            ,face_value -- 面值，债券单位面值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,pay_type -- 划款方式
            ,is_reconciliation -- 是否对账
            ,is_cash_manage -- 是否现金管理类
            ,risk_level -- 产品风险等级
            ,deal_mode -- 处理模式
            ,is_exclusive -- 是否专属产品
            ,bid_date -- 投标日期
            ,board -- 上市板
            ,sh_or_zh -- 是否沪港通或深港通
            ,is_margin_finprod -- 是否融资融券标的
            ,city_bond_lev -- 城投债级别
            ,is_city_bond -- 是否城投债
            ,investment_cycle -- 投资周期
            ,prod_manager -- 产品经理
            ,collect_type -- 收取方式
            ,regulatory_rating -- 监管评级
            ,toff_enddate -- 认购终止日
            ,trm_fund_abbr -- 交易所基金简称
            ,trm_fund_type -- 交易所基金类型
            ,gra_fund_type -- 分级基金
            ,pur_red_id -- 申购赎回代码
            ,pur_red_abbr -- 申购赎回简称
            ,pur_start_low -- 单笔申购金额下限
            ,red_start_low -- 单笔赎回份额下限
            ,etf_type -- etf类型
            ,etf_min_prunit -- etf最小申购赎回单位
            ,toff_strdate -- 认购起始日
            ,org_code -- 所属机构
            ,invest_manager -- 投资经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.sale_department, o.sale_department) as sale_department -- 销售部门，零售产品管理部、金融同业部、对公产品和现金管理部
    ,nvl(n.sale_layer, o.sale_layer) as sale_layer -- 销售分层
    ,nvl(n.sale_period, o.sale_period) as sale_period -- 销售期次
    ,nvl(n.pur_speed, o.pur_speed) as pur_speed -- 申购确认速度，如果资产只有一个确认速度，则存该字段
    ,nvl(n.red_speed, o.red_speed) as red_speed -- 赎回确认速度
    ,nvl(n.is_sec_bond, o.is_sec_bond) as is_sec_bond -- 是否次级债
    ,nvl(n.wind_id, o.wind_id) as wind_id -- wind对象id
    ,nvl(n.is_auto_update, o.is_auto_update) as is_auto_update -- 是否接口自动更新
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 投资组合代码
    ,nvl(n.prod_regist_code, o.prod_regist_code) as prod_regist_code -- 产品登记编码
    ,nvl(n.is_cycle, o.is_cycle) as is_cycle -- 是否周期型
    ,nvl(n.is_lay, o.is_lay) as is_lay -- 是否分层
    ,nvl(n.lay_type, o.lay_type) as lay_type -- 分层类型，金额分层、期限分层、客户类型
    ,nvl(n.invest_nature, o.invest_nature) as invest_nature -- 投资性质，固定收益类、权益类、商品及金融衍生品类、混合类
    ,nvl(n.profit_flag, o.profit_flag) as profit_flag -- 收益标识，非保本浮动收益型、保本浮动、保证收益型
    ,nvl(n.sale_mode, o.sale_mode) as sale_mode -- 销售模式，直销、代销、委托
    ,nvl(n.chb_id, o.chb_id) as chb_id -- 中债报送编码
    ,nvl(n.tmpl_id, o.tmpl_id) as tmpl_id -- 产品模板代码
    ,nvl(n.close_days, o.close_days) as close_days -- 封闭期限(天)，产品每次开放对应的封闭期限
    ,nvl(n.issue_status, o.issue_status) as issue_status -- 产品发行状态
    ,nvl(n.issue_status_remark, o.issue_status_remark) as issue_status_remark -- 发行状态备注
    ,nvl(n.is_compound_int, o.is_compound_int) as is_compound_int -- 是否按日复利
    ,nvl(n.term_type, o.term_type) as term_type -- 期限品种
    ,nvl(n.face_value, o.face_value) as face_value -- 面值，债券单位面值
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.pay_type, o.pay_type) as pay_type -- 划款方式
    ,nvl(n.is_reconciliation, o.is_reconciliation) as is_reconciliation -- 是否对账
    ,nvl(n.is_cash_manage, o.is_cash_manage) as is_cash_manage -- 是否现金管理类
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 产品风险等级
    ,nvl(n.deal_mode, o.deal_mode) as deal_mode -- 处理模式
    ,nvl(n.is_exclusive, o.is_exclusive) as is_exclusive -- 是否专属产品
    ,nvl(n.bid_date, o.bid_date) as bid_date -- 投标日期
    ,nvl(n.board, o.board) as board -- 上市板
    ,nvl(n.sh_or_zh, o.sh_or_zh) as sh_or_zh -- 是否沪港通或深港通
    ,nvl(n.is_margin_finprod, o.is_margin_finprod) as is_margin_finprod -- 是否融资融券标的
    ,nvl(n.city_bond_lev, o.city_bond_lev) as city_bond_lev -- 城投债级别
    ,nvl(n.is_city_bond, o.is_city_bond) as is_city_bond -- 是否城投债
    ,nvl(n.investment_cycle, o.investment_cycle) as investment_cycle -- 投资周期
    ,nvl(n.prod_manager, o.prod_manager) as prod_manager -- 产品经理
    ,nvl(n.collect_type, o.collect_type) as collect_type -- 收取方式
    ,nvl(n.regulatory_rating, o.regulatory_rating) as regulatory_rating -- 监管评级
    ,nvl(n.toff_enddate, o.toff_enddate) as toff_enddate -- 认购终止日
    ,nvl(n.trm_fund_abbr, o.trm_fund_abbr) as trm_fund_abbr -- 交易所基金简称
    ,nvl(n.trm_fund_type, o.trm_fund_type) as trm_fund_type -- 交易所基金类型
    ,nvl(n.gra_fund_type, o.gra_fund_type) as gra_fund_type -- 分级基金
    ,nvl(n.pur_red_id, o.pur_red_id) as pur_red_id -- 申购赎回代码
    ,nvl(n.pur_red_abbr, o.pur_red_abbr) as pur_red_abbr -- 申购赎回简称
    ,nvl(n.pur_start_low, o.pur_start_low) as pur_start_low -- 单笔申购金额下限
    ,nvl(n.red_start_low, o.red_start_low) as red_start_low -- 单笔赎回份额下限
    ,nvl(n.etf_type, o.etf_type) as etf_type -- etf类型
    ,nvl(n.etf_min_prunit, o.etf_min_prunit) as etf_min_prunit -- etf最小申购赎回单位
    ,nvl(n.toff_strdate, o.toff_strdate) as toff_strdate -- 认购起始日
    ,nvl(n.org_code, o.org_code) as org_code -- 所属机构
    ,nvl(n.invest_manager, o.invest_manager) as invest_manager -- 投资经理
    ,case when
            n.finprod_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.finprod_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.finprod_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_fin_product_add_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_fin_product_add where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.finprod_id = n.finprod_id
where (
        o.finprod_id is null
    )
    or (
        n.finprod_id is null
    )
    or (
        o.sale_department <> n.sale_department
        or o.sale_layer <> n.sale_layer
        or o.sale_period <> n.sale_period
        or o.pur_speed <> n.pur_speed
        or o.red_speed <> n.red_speed
        or o.is_sec_bond <> n.is_sec_bond
        or o.wind_id <> n.wind_id
        or o.is_auto_update <> n.is_auto_update
        or o.portfolio_id <> n.portfolio_id
        or o.prod_regist_code <> n.prod_regist_code
        or o.is_cycle <> n.is_cycle
        or o.is_lay <> n.is_lay
        or o.lay_type <> n.lay_type
        or o.invest_nature <> n.invest_nature
        or o.profit_flag <> n.profit_flag
        or o.sale_mode <> n.sale_mode
        or o.chb_id <> n.chb_id
        or o.tmpl_id <> n.tmpl_id
        or o.close_days <> n.close_days
        or o.issue_status <> n.issue_status
        or o.issue_status_remark <> n.issue_status_remark
        or o.is_compound_int <> n.is_compound_int
        or o.term_type <> n.term_type
        or o.face_value <> n.face_value
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.pay_type <> n.pay_type
        or o.is_reconciliation <> n.is_reconciliation
        or o.is_cash_manage <> n.is_cash_manage
        or o.risk_level <> n.risk_level
        or o.deal_mode <> n.deal_mode
        or o.is_exclusive <> n.is_exclusive
        or o.bid_date <> n.bid_date
        or o.board <> n.board
        or o.sh_or_zh <> n.sh_or_zh
        or o.is_margin_finprod <> n.is_margin_finprod
        or o.city_bond_lev <> n.city_bond_lev
        or o.is_city_bond <> n.is_city_bond
        or o.investment_cycle <> n.investment_cycle
        or o.prod_manager <> n.prod_manager
        or o.collect_type <> n.collect_type
        or o.regulatory_rating <> n.regulatory_rating
        or o.toff_enddate <> n.toff_enddate
        or o.trm_fund_abbr <> n.trm_fund_abbr
        or o.trm_fund_type <> n.trm_fund_type
        or o.gra_fund_type <> n.gra_fund_type
        or o.pur_red_id <> n.pur_red_id
        or o.pur_red_abbr <> n.pur_red_abbr
        or o.pur_start_low <> n.pur_start_low
        or o.red_start_low <> n.red_start_low
        or o.etf_type <> n.etf_type
        or o.etf_min_prunit <> n.etf_min_prunit
        or o.toff_strdate <> n.toff_strdate
        or o.org_code <> n.org_code
        or o.invest_manager <> n.invest_manager
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_product_add_cl(
            finprod_id -- 金融产品代码
            ,sale_department -- 销售部门，零售产品管理部、金融同业部、对公产品和现金管理部
            ,sale_layer -- 销售分层
            ,sale_period -- 销售期次
            ,pur_speed -- 申购确认速度，如果资产只有一个确认速度，则存该字段
            ,red_speed -- 赎回确认速度
            ,is_sec_bond -- 是否次级债
            ,wind_id -- wind对象id
            ,is_auto_update -- 是否接口自动更新
            ,portfolio_id -- 投资组合代码
            ,prod_regist_code -- 产品登记编码
            ,is_cycle -- 是否周期型
            ,is_lay -- 是否分层
            ,lay_type -- 分层类型，金额分层、期限分层、客户类型
            ,invest_nature -- 投资性质，固定收益类、权益类、商品及金融衍生品类、混合类
            ,profit_flag -- 收益标识，非保本浮动收益型、保本浮动、保证收益型
            ,sale_mode -- 销售模式，直销、代销、委托
            ,chb_id -- 中债报送编码
            ,tmpl_id -- 产品模板代码
            ,close_days -- 封闭期限(天)，产品每次开放对应的封闭期限
            ,issue_status -- 产品发行状态
            ,issue_status_remark -- 发行状态备注
            ,is_compound_int -- 是否按日复利
            ,term_type -- 期限品种
            ,face_value -- 面值，债券单位面值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,pay_type -- 划款方式
            ,is_reconciliation -- 是否对账
            ,is_cash_manage -- 是否现金管理类
            ,risk_level -- 产品风险等级
            ,deal_mode -- 处理模式
            ,is_exclusive -- 是否专属产品
            ,bid_date -- 投标日期
            ,board -- 上市板
            ,sh_or_zh -- 是否沪港通或深港通
            ,is_margin_finprod -- 是否融资融券标的
            ,city_bond_lev -- 城投债级别
            ,is_city_bond -- 是否城投债
            ,investment_cycle -- 投资周期
            ,prod_manager -- 产品经理
            ,collect_type -- 收取方式
            ,regulatory_rating -- 监管评级
            ,toff_enddate -- 认购终止日
            ,trm_fund_abbr -- 交易所基金简称
            ,trm_fund_type -- 交易所基金类型
            ,gra_fund_type -- 分级基金
            ,pur_red_id -- 申购赎回代码
            ,pur_red_abbr -- 申购赎回简称
            ,pur_start_low -- 单笔申购金额下限
            ,red_start_low -- 单笔赎回份额下限
            ,etf_type -- etf类型
            ,etf_min_prunit -- etf最小申购赎回单位
            ,toff_strdate -- 认购起始日
            ,org_code -- 所属机构
            ,invest_manager -- 投资经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_product_add_op(
            finprod_id -- 金融产品代码
            ,sale_department -- 销售部门，零售产品管理部、金融同业部、对公产品和现金管理部
            ,sale_layer -- 销售分层
            ,sale_period -- 销售期次
            ,pur_speed -- 申购确认速度，如果资产只有一个确认速度，则存该字段
            ,red_speed -- 赎回确认速度
            ,is_sec_bond -- 是否次级债
            ,wind_id -- wind对象id
            ,is_auto_update -- 是否接口自动更新
            ,portfolio_id -- 投资组合代码
            ,prod_regist_code -- 产品登记编码
            ,is_cycle -- 是否周期型
            ,is_lay -- 是否分层
            ,lay_type -- 分层类型，金额分层、期限分层、客户类型
            ,invest_nature -- 投资性质，固定收益类、权益类、商品及金融衍生品类、混合类
            ,profit_flag -- 收益标识，非保本浮动收益型、保本浮动、保证收益型
            ,sale_mode -- 销售模式，直销、代销、委托
            ,chb_id -- 中债报送编码
            ,tmpl_id -- 产品模板代码
            ,close_days -- 封闭期限(天)，产品每次开放对应的封闭期限
            ,issue_status -- 产品发行状态
            ,issue_status_remark -- 发行状态备注
            ,is_compound_int -- 是否按日复利
            ,term_type -- 期限品种
            ,face_value -- 面值，债券单位面值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,pay_type -- 划款方式
            ,is_reconciliation -- 是否对账
            ,is_cash_manage -- 是否现金管理类
            ,risk_level -- 产品风险等级
            ,deal_mode -- 处理模式
            ,is_exclusive -- 是否专属产品
            ,bid_date -- 投标日期
            ,board -- 上市板
            ,sh_or_zh -- 是否沪港通或深港通
            ,is_margin_finprod -- 是否融资融券标的
            ,city_bond_lev -- 城投债级别
            ,is_city_bond -- 是否城投债
            ,investment_cycle -- 投资周期
            ,prod_manager -- 产品经理
            ,collect_type -- 收取方式
            ,regulatory_rating -- 监管评级
            ,toff_enddate -- 认购终止日
            ,trm_fund_abbr -- 交易所基金简称
            ,trm_fund_type -- 交易所基金类型
            ,gra_fund_type -- 分级基金
            ,pur_red_id -- 申购赎回代码
            ,pur_red_abbr -- 申购赎回简称
            ,pur_start_low -- 单笔申购金额下限
            ,red_start_low -- 单笔赎回份额下限
            ,etf_type -- etf类型
            ,etf_min_prunit -- etf最小申购赎回单位
            ,toff_strdate -- 认购起始日
            ,org_code -- 所属机构
            ,invest_manager -- 投资经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.finprod_id -- 金融产品代码
    ,o.sale_department -- 销售部门，零售产品管理部、金融同业部、对公产品和现金管理部
    ,o.sale_layer -- 销售分层
    ,o.sale_period -- 销售期次
    ,o.pur_speed -- 申购确认速度，如果资产只有一个确认速度，则存该字段
    ,o.red_speed -- 赎回确认速度
    ,o.is_sec_bond -- 是否次级债
    ,o.wind_id -- wind对象id
    ,o.is_auto_update -- 是否接口自动更新
    ,o.portfolio_id -- 投资组合代码
    ,o.prod_regist_code -- 产品登记编码
    ,o.is_cycle -- 是否周期型
    ,o.is_lay -- 是否分层
    ,o.lay_type -- 分层类型，金额分层、期限分层、客户类型
    ,o.invest_nature -- 投资性质，固定收益类、权益类、商品及金融衍生品类、混合类
    ,o.profit_flag -- 收益标识，非保本浮动收益型、保本浮动、保证收益型
    ,o.sale_mode -- 销售模式，直销、代销、委托
    ,o.chb_id -- 中债报送编码
    ,o.tmpl_id -- 产品模板代码
    ,o.close_days -- 封闭期限(天)，产品每次开放对应的封闭期限
    ,o.issue_status -- 产品发行状态
    ,o.issue_status_remark -- 发行状态备注
    ,o.is_compound_int -- 是否按日复利
    ,o.term_type -- 期限品种
    ,o.face_value -- 面值，债券单位面值
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.pay_type -- 划款方式
    ,o.is_reconciliation -- 是否对账
    ,o.is_cash_manage -- 是否现金管理类
    ,o.risk_level -- 产品风险等级
    ,o.deal_mode -- 处理模式
    ,o.is_exclusive -- 是否专属产品
    ,o.bid_date -- 投标日期
    ,o.board -- 上市板
    ,o.sh_or_zh -- 是否沪港通或深港通
    ,o.is_margin_finprod -- 是否融资融券标的
    ,o.city_bond_lev -- 城投债级别
    ,o.is_city_bond -- 是否城投债
    ,o.investment_cycle -- 投资周期
    ,o.prod_manager -- 产品经理
    ,o.collect_type -- 收取方式
    ,o.regulatory_rating -- 监管评级
    ,o.toff_enddate -- 认购终止日
    ,o.trm_fund_abbr -- 交易所基金简称
    ,o.trm_fund_type -- 交易所基金类型
    ,o.gra_fund_type -- 分级基金
    ,o.pur_red_id -- 申购赎回代码
    ,o.pur_red_abbr -- 申购赎回简称
    ,o.pur_start_low -- 单笔申购金额下限
    ,o.red_start_low -- 单笔赎回份额下限
    ,o.etf_type -- etf类型
    ,o.etf_min_prunit -- etf最小申购赎回单位
    ,o.toff_strdate -- 认购起始日
    ,o.org_code -- 所属机构
    ,o.invest_manager -- 投资经理
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
from ${iol_schema}.fams_fin_product_add_bk o
    left join ${iol_schema}.fams_fin_product_add_op n
        on
            o.finprod_id = n.finprod_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_fin_product_add_cl d
        on
            o.finprod_id = d.finprod_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_fin_product_add;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_fin_product_add') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_fin_product_add drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_fin_product_add add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_fin_product_add exchange partition p_${batch_date} with table ${iol_schema}.fams_fin_product_add_cl;
alter table ${iol_schema}.fams_fin_product_add exchange partition p_20991231 with table ${iol_schema}.fams_fin_product_add_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_fin_product_add to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_product_add_op purge;
drop table ${iol_schema}.fams_fin_product_add_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_fin_product_add_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_fin_product_add',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
