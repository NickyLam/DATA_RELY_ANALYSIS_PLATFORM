/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_prd_year_yield
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_prd_year_yield
whenever sqlerror continue none;
drop table ${iol_schema}.fams_prd_year_yield purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_prd_year_yield(
    prod_id varchar2(50) -- 产品代码
    ,prod_name varchar2(200) -- 产品名称
    ,val_date varchar2(20) -- 估值日期
    ,ccy varchar2(10) -- 币种
    ,paidup_capital number(30,6) -- 实收资本（元）
    ,unit_net number(30,12) -- 单位净值
    ,total_net number(30,12) -- 累计净值
    ,asset_val number(30,6) -- 资产净值（元）
    ,day_yield number(30,8) -- 日年化收益率（%）
    ,seven_yield number(30,8) -- 七日年化收益率（%）
    ,month_yield number(30,8) -- 近1个月年化收益率（%）
    ,three_month_yield number(30,8) -- 近3个月年化收益率（%）
    ,six_month_yield number(30,8) -- 近6个月年化收益率（%）
    ,year_yield number(30,8) -- 近一年年化收益率（%）
    ,since_this_year_yield number(30,8) -- 今年以来年化收益率（%）
    ,two_year_yield number(30,8) -- 近两年年化收益率（%）
    ,three_year_yield number(30,8) -- 近三年年化收益率（%）
    ,establish_yield number(30,8) -- 成立以来年化收益率（%）
    ,upper_cycle_yield number(30,8) -- 上周期年化收益率（%）
    ,send_type varchar2(20) -- 发送方式
    ,send_status varchar2(20) -- 发送状态
    ,send_time timestamp -- 发送时间
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,seven_retreat_yield number(30,6) -- 七日最大回撤率
    ,month_retreat_yield number(30,6) -- 一个月最大回撤率
    ,three_month_retreat_yield number(30,6) -- 三个月最大回撤率
    ,six_month_retreat_yield number(30,6) -- 六个月最大回撤率
    ,year_retreat_yield number(30,6) -- 一年最大回撤率
    ,since_this_year_retreat_yield number(30,6) -- 今年以来最大回撤率
    ,establish_retreat_yield number(30,6) -- 成立以来以来最大回撤率
    ,deal_mode varchar2(50) -- 产品处理模式
    ,profit_type varchar2(50) -- 产品收益类型
    ,vdate date -- 产品成立日
    ,mdate date -- 产品到期日
    ,base_rule_value number(30,6) -- 业绩比较基准%
    ,tot_net_unit_value number(30,12) -- 累计单位净值/累计万份收益
    ,five_year_yield number(30,8) -- 近五年年化收益率（%）
    ,day_yield_chg number(30,8) -- 当日年化收益率涨跌幅
    ,seven_yield_chg number(30,8) -- 近七日年化收益率涨跌幅%
    ,month_yield_chg number(30,8) -- 近一个月年化收益率涨跌幅(%)
    ,three_month_yield_chg number(30,8) -- 近三个月年化收益率涨跌幅(%)
    ,six_month_yield_chg number(30,8) -- 近六个月年化收益率涨跌幅（%）
    ,year_yield_chg number(30,8) -- 近一年年化收益率涨跌幅（%）
    ,three_year_yield_chg number(30,8) -- 近三年年化收益率涨跌幅（%）
    ,five_year_yield_chg number(30,8) -- 近五年年化收益率涨跌幅（%）
    ,since_this_year_yield_chg number(30,8) -- 今年以来年化收益率涨跌幅（%）
    ,establish_yield_chg number(30,8) -- 成立以来年化收益率涨跌幅(%)
    ,past_fiscal_year_yield number(30,8) -- 过往会计年度年化收益率（一年）(%)
    ,past_fiscal_year_two_yield number(30,8) -- 过往会计年度年化收益率（两年）(%)
    ,past_fiscal_year_three_yield number(30,8) -- 过往会计年度年化收益率（三年）(%)
    ,past_fiscal_year_four_yield number(30,8) -- 过往会计年度年化收益率（四年）(%)
    ,past_fiscal_year_five_yield number(30,8) -- 过往会计年度年化收益率（五年）(%)
    ,raise_amt number(30,2) -- 募集余额
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
grant select on ${iol_schema}.fams_prd_year_yield to ${iml_schema};
grant select on ${iol_schema}.fams_prd_year_yield to ${icl_schema};
grant select on ${iol_schema}.fams_prd_year_yield to ${idl_schema};
grant select on ${iol_schema}.fams_prd_year_yield to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_prd_year_yield is '产品年化收益率表';
comment on column ${iol_schema}.fams_prd_year_yield.prod_id is '产品代码';
comment on column ${iol_schema}.fams_prd_year_yield.prod_name is '产品名称';
comment on column ${iol_schema}.fams_prd_year_yield.val_date is '估值日期';
comment on column ${iol_schema}.fams_prd_year_yield.ccy is '币种';
comment on column ${iol_schema}.fams_prd_year_yield.paidup_capital is '实收资本（元）';
comment on column ${iol_schema}.fams_prd_year_yield.unit_net is '单位净值';
comment on column ${iol_schema}.fams_prd_year_yield.total_net is '累计净值';
comment on column ${iol_schema}.fams_prd_year_yield.asset_val is '资产净值（元）';
comment on column ${iol_schema}.fams_prd_year_yield.day_yield is '日年化收益率（%）';
comment on column ${iol_schema}.fams_prd_year_yield.seven_yield is '七日年化收益率（%）';
comment on column ${iol_schema}.fams_prd_year_yield.month_yield is '近1个月年化收益率（%）';
comment on column ${iol_schema}.fams_prd_year_yield.three_month_yield is '近3个月年化收益率（%）';
comment on column ${iol_schema}.fams_prd_year_yield.six_month_yield is '近6个月年化收益率（%）';
comment on column ${iol_schema}.fams_prd_year_yield.year_yield is '近一年年化收益率（%）';
comment on column ${iol_schema}.fams_prd_year_yield.since_this_year_yield is '今年以来年化收益率（%）';
comment on column ${iol_schema}.fams_prd_year_yield.two_year_yield is '近两年年化收益率（%）';
comment on column ${iol_schema}.fams_prd_year_yield.three_year_yield is '近三年年化收益率（%）';
comment on column ${iol_schema}.fams_prd_year_yield.establish_yield is '成立以来年化收益率（%）';
comment on column ${iol_schema}.fams_prd_year_yield.upper_cycle_yield is '上周期年化收益率（%）';
comment on column ${iol_schema}.fams_prd_year_yield.send_type is '发送方式';
comment on column ${iol_schema}.fams_prd_year_yield.send_status is '发送状态';
comment on column ${iol_schema}.fams_prd_year_yield.send_time is '发送时间';
comment on column ${iol_schema}.fams_prd_year_yield.create_user is '创建人';
comment on column ${iol_schema}.fams_prd_year_yield.create_dept is '创建部门';
comment on column ${iol_schema}.fams_prd_year_yield.create_time is '创建时间';
comment on column ${iol_schema}.fams_prd_year_yield.update_user is '更新人';
comment on column ${iol_schema}.fams_prd_year_yield.update_time is '更新时间';
comment on column ${iol_schema}.fams_prd_year_yield.seven_retreat_yield is '七日最大回撤率';
comment on column ${iol_schema}.fams_prd_year_yield.month_retreat_yield is '一个月最大回撤率';
comment on column ${iol_schema}.fams_prd_year_yield.three_month_retreat_yield is '三个月最大回撤率';
comment on column ${iol_schema}.fams_prd_year_yield.six_month_retreat_yield is '六个月最大回撤率';
comment on column ${iol_schema}.fams_prd_year_yield.year_retreat_yield is '一年最大回撤率';
comment on column ${iol_schema}.fams_prd_year_yield.since_this_year_retreat_yield is '今年以来最大回撤率';
comment on column ${iol_schema}.fams_prd_year_yield.establish_retreat_yield is '成立以来以来最大回撤率';
comment on column ${iol_schema}.fams_prd_year_yield.deal_mode is '产品处理模式';
comment on column ${iol_schema}.fams_prd_year_yield.profit_type is '产品收益类型';
comment on column ${iol_schema}.fams_prd_year_yield.vdate is '产品成立日';
comment on column ${iol_schema}.fams_prd_year_yield.mdate is '产品到期日';
comment on column ${iol_schema}.fams_prd_year_yield.base_rule_value is '业绩比较基准%';
comment on column ${iol_schema}.fams_prd_year_yield.tot_net_unit_value is '累计单位净值/累计万份收益';
comment on column ${iol_schema}.fams_prd_year_yield.five_year_yield is '近五年年化收益率（%）';
comment on column ${iol_schema}.fams_prd_year_yield.day_yield_chg is '当日年化收益率涨跌幅';
comment on column ${iol_schema}.fams_prd_year_yield.seven_yield_chg is '近七日年化收益率涨跌幅%';
comment on column ${iol_schema}.fams_prd_year_yield.month_yield_chg is '近一个月年化收益率涨跌幅(%)';
comment on column ${iol_schema}.fams_prd_year_yield.three_month_yield_chg is '近三个月年化收益率涨跌幅(%)';
comment on column ${iol_schema}.fams_prd_year_yield.six_month_yield_chg is '近六个月年化收益率涨跌幅（%）';
comment on column ${iol_schema}.fams_prd_year_yield.year_yield_chg is '近一年年化收益率涨跌幅（%）';
comment on column ${iol_schema}.fams_prd_year_yield.three_year_yield_chg is '近三年年化收益率涨跌幅（%）';
comment on column ${iol_schema}.fams_prd_year_yield.five_year_yield_chg is '近五年年化收益率涨跌幅（%）';
comment on column ${iol_schema}.fams_prd_year_yield.since_this_year_yield_chg is '今年以来年化收益率涨跌幅（%）';
comment on column ${iol_schema}.fams_prd_year_yield.establish_yield_chg is '成立以来年化收益率涨跌幅(%)';
comment on column ${iol_schema}.fams_prd_year_yield.past_fiscal_year_yield is '过往会计年度年化收益率（一年）(%)';
comment on column ${iol_schema}.fams_prd_year_yield.past_fiscal_year_two_yield is '过往会计年度年化收益率（两年）(%)';
comment on column ${iol_schema}.fams_prd_year_yield.past_fiscal_year_three_yield is '过往会计年度年化收益率（三年）(%)';
comment on column ${iol_schema}.fams_prd_year_yield.past_fiscal_year_four_yield is '过往会计年度年化收益率（四年）(%)';
comment on column ${iol_schema}.fams_prd_year_yield.past_fiscal_year_five_yield is '过往会计年度年化收益率（五年）(%)';
comment on column ${iol_schema}.fams_prd_year_yield.raise_amt is '募集余额';
comment on column ${iol_schema}.fams_prd_year_yield.start_dt is '开始时间';
comment on column ${iol_schema}.fams_prd_year_yield.end_dt is '结束时间';
comment on column ${iol_schema}.fams_prd_year_yield.id_mark is '增删标志';
comment on column ${iol_schema}.fams_prd_year_yield.etl_timestamp is 'ETL处理时间戳';
