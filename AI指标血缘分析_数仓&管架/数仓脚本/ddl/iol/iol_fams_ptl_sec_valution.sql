/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ptl_sec_valution
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ptl_sec_valution
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ptl_sec_valution purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ptl_sec_valution(
    cdate date -- 日期
    ,portfolio_id varchar2(64) -- 组合代码
    ,finprod_id varchar2(100) -- 金融产品代码
    ,inv_aim varchar2(100) -- 投资目的
    ,ccy varchar2(100) -- 币种
    ,share_amt number(30,4) -- 数量
    ,tdy_float_ingpl number(30,2) -- 公允价值变动
    ,dsc_cost_amt number(30,2) -- 摊销总成本，券面+利息调整
    ,dsc_clean_price number(30,14) -- 摊销成本净价
    ,tdy_intincexp number(30,2) -- 当日应计利息
    ,buy_cost_amt number(30,14) -- 买入总成本，暂时不用
    ,buy_clean_price number(30,14) -- 买入成本净价，暂时不用
    ,market_value number(30,2) -- 市值，暂时不用
    ,market_clean_price number(30,14) -- 市价净价，暂时不用
    ,tdy_dscincexp_add number(30,2) -- 当日发生摊销收入，暂时不用
    ,tdy_intincexp_add number(30,2) -- 当日发生利息收入，暂时不用
    ,tdy_dscloss_add number(30,2) -- 当日发生价差收入，暂时不用
    ,tdy_float_ingpl_add number(30,2) -- 当日发生浮动盈亏，暂时不用
    ,tdy_fee_add number(30,2) -- 当日发生费用支出，暂时不用
    ,accu_net_value number(30,14) -- 累计单位净值，暂时不用
    ,create_user varchar2(40) -- 创建人
    ,create_dept varchar2(64) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(40) -- 更新人
    ,update_time timestamp -- 更新时间
    ,act_d_yield number(30,14) -- 实际日利率
    ,sec_acct_id varchar2(64) -- 证券管理账户/通道代码，无通道无证券管理账户的存999999，目前不管证券管理户维度
    ,delay_pay_amt number(30,2) -- 待清算资金
    ,b_ccy varchar2(100) -- 本位币
    ,tdy_float_ingpl_b number(30,2) -- 公允价值变动_本位币
    ,dsc_cost_amt_b number(30,14) -- 摊销总成本_本位币
    ,dsc_clean_price_b number(30,14) -- 摊销成本净价_本位币，摊销总成本/数量
    ,delay_pay_amt_b number(30,2) -- 待清算资金_本位币， 还本/付息区间后未支付的本金/利息，T+1交易，资金清算金额
    ,tdy_intincexp_b number(30,2) -- 当日应计利息_本位币
    ,in_tdy_intincexp number(30,2) -- 收入端应计利息_原币
    ,out_tdy_intincexp number(30,2) -- 支出端应计利息_原币
    ,end_days_1 number(20,0) -- 剩余期限，下一个付息日行权日-计算日
    ,end_days_2 number(20,0) -- 剩余存续期限,到期日-计算日
    ,int_rate number(30,14) -- 计提利率
    ,tdy_dscloss_add_b number(30,2) -- 当日价差收入_本币
    ,gen_type varchar2(100) -- 生成方式
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
grant select on ${iol_schema}.fams_ptl_sec_valution to ${iml_schema};
grant select on ${iol_schema}.fams_ptl_sec_valution to ${icl_schema};
grant select on ${iol_schema}.fams_ptl_sec_valution to ${idl_schema};
grant select on ${iol_schema}.fams_ptl_sec_valution to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ptl_sec_valution is '组合资产估值';
comment on column ${iol_schema}.fams_ptl_sec_valution.cdate is '日期';
comment on column ${iol_schema}.fams_ptl_sec_valution.portfolio_id is '组合代码';
comment on column ${iol_schema}.fams_ptl_sec_valution.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_ptl_sec_valution.inv_aim is '投资目的';
comment on column ${iol_schema}.fams_ptl_sec_valution.ccy is '币种';
comment on column ${iol_schema}.fams_ptl_sec_valution.share_amt is '数量';
comment on column ${iol_schema}.fams_ptl_sec_valution.tdy_float_ingpl is '公允价值变动';
comment on column ${iol_schema}.fams_ptl_sec_valution.dsc_cost_amt is '摊销总成本，券面+利息调整';
comment on column ${iol_schema}.fams_ptl_sec_valution.dsc_clean_price is '摊销成本净价';
comment on column ${iol_schema}.fams_ptl_sec_valution.tdy_intincexp is '当日应计利息';
comment on column ${iol_schema}.fams_ptl_sec_valution.buy_cost_amt is '买入总成本，暂时不用';
comment on column ${iol_schema}.fams_ptl_sec_valution.buy_clean_price is '买入成本净价，暂时不用';
comment on column ${iol_schema}.fams_ptl_sec_valution.market_value is '市值，暂时不用';
comment on column ${iol_schema}.fams_ptl_sec_valution.market_clean_price is '市价净价，暂时不用';
comment on column ${iol_schema}.fams_ptl_sec_valution.tdy_dscincexp_add is '当日发生摊销收入，暂时不用';
comment on column ${iol_schema}.fams_ptl_sec_valution.tdy_intincexp_add is '当日发生利息收入，暂时不用';
comment on column ${iol_schema}.fams_ptl_sec_valution.tdy_dscloss_add is '当日发生价差收入，暂时不用';
comment on column ${iol_schema}.fams_ptl_sec_valution.tdy_float_ingpl_add is '当日发生浮动盈亏，暂时不用';
comment on column ${iol_schema}.fams_ptl_sec_valution.tdy_fee_add is '当日发生费用支出，暂时不用';
comment on column ${iol_schema}.fams_ptl_sec_valution.accu_net_value is '累计单位净值，暂时不用';
comment on column ${iol_schema}.fams_ptl_sec_valution.create_user is '创建人';
comment on column ${iol_schema}.fams_ptl_sec_valution.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ptl_sec_valution.create_time is '创建时间';
comment on column ${iol_schema}.fams_ptl_sec_valution.update_user is '更新人';
comment on column ${iol_schema}.fams_ptl_sec_valution.update_time is '更新时间';
comment on column ${iol_schema}.fams_ptl_sec_valution.act_d_yield is '实际日利率';
comment on column ${iol_schema}.fams_ptl_sec_valution.sec_acct_id is '证券管理账户/通道代码，无通道无证券管理账户的存999999，目前不管证券管理户维度';
comment on column ${iol_schema}.fams_ptl_sec_valution.delay_pay_amt is '待清算资金';
comment on column ${iol_schema}.fams_ptl_sec_valution.b_ccy is '本位币';
comment on column ${iol_schema}.fams_ptl_sec_valution.tdy_float_ingpl_b is '公允价值变动_本位币';
comment on column ${iol_schema}.fams_ptl_sec_valution.dsc_cost_amt_b is '摊销总成本_本位币';
comment on column ${iol_schema}.fams_ptl_sec_valution.dsc_clean_price_b is '摊销成本净价_本位币，摊销总成本/数量';
comment on column ${iol_schema}.fams_ptl_sec_valution.delay_pay_amt_b is '待清算资金_本位币， 还本/付息区间后未支付的本金/利息，T+1交易，资金清算金额';
comment on column ${iol_schema}.fams_ptl_sec_valution.tdy_intincexp_b is '当日应计利息_本位币';
comment on column ${iol_schema}.fams_ptl_sec_valution.in_tdy_intincexp is '收入端应计利息_原币';
comment on column ${iol_schema}.fams_ptl_sec_valution.out_tdy_intincexp is '支出端应计利息_原币';
comment on column ${iol_schema}.fams_ptl_sec_valution.end_days_1 is '剩余期限，下一个付息日行权日-计算日';
comment on column ${iol_schema}.fams_ptl_sec_valution.end_days_2 is '剩余存续期限,到期日-计算日';
comment on column ${iol_schema}.fams_ptl_sec_valution.int_rate is '计提利率';
comment on column ${iol_schema}.fams_ptl_sec_valution.tdy_dscloss_add_b is '当日价差收入_本币';
comment on column ${iol_schema}.fams_ptl_sec_valution.gen_type is '生成方式';
comment on column ${iol_schema}.fams_ptl_sec_valution.start_dt is '开始时间';
comment on column ${iol_schema}.fams_ptl_sec_valution.end_dt is '结束时间';
comment on column ${iol_schema}.fams_ptl_sec_valution.id_mark is '增删标志';
comment on column ${iol_schema}.fams_ptl_sec_valution.etl_timestamp is 'ETL处理时间戳';
