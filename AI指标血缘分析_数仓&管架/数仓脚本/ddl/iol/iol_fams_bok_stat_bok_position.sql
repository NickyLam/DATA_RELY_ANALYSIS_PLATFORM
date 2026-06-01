/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_bok_stat_bok_position
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_bok_stat_bok_position
whenever sqlerror continue none;
drop table ${iol_schema}.fams_bok_stat_bok_position purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_stat_bok_position(
    bookset_id varchar2(50) -- 账套代码
    ,finprod_id varchar2(50) -- 金融产品代码
    ,happen_date date -- 发生日期
    ,book_date date -- 入账日期
    ,bookset_date date -- 账套日期
    ,profit_type varchar2(50) -- 收益类型
    ,capital number(30,2) -- 实收资本
    ,profit_amt number(30,2) -- 当日应付利润
    ,tot_profit_amt number(30,2) -- 累计应付利润
    ,int_rate number(30,14) -- 计提利率
    ,net_asset_value_bef number(30,2) -- 费前资产净值
    ,net_asset_value number(30,2) -- 资产净值
    ,net_unit_value_bef number(30,14) -- 费前单位净值
    ,net_unit_value number(30,14) -- 单位净值
    ,p_yield_bef number(30,14) -- 万份收益_费前
    ,p_yield number(30,14) -- 万份收益
    ,tdy_yield_bef number(30,14) -- 当日年化收益率_费前
    ,tdy_yield number(30,14) -- 当日年化收益率
    ,yield_term_bef number(30,14) -- 周期年化收益率_费前
    ,yield_term number(30,14) -- 周期年化收益率
    ,yield_7_bef number(30,14) -- 当日7日年化收益率_费前
    ,yield_7 number(30,14) -- 当日7日年化收益率
    ,tot_bouns_amt number(30,2) -- 累计分红金额
    ,tdy_bouns_amt number(30,2) -- 当日分红金额
    ,tot_bouns_net number(30,14) -- 累计分红净值
    ,tdy_bouns_net number(30,14) -- 当日分红净值
    ,is_sub_prd varchar2(50) -- 是否子产品
    ,layering_id varchar2(80) -- 分层代码，子产品存分层代码，母产品存核算主体代码
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_bok_stat_bok_position to ${iml_schema};
grant select on ${iol_schema}.fams_bok_stat_bok_position to ${icl_schema};
grant select on ${iol_schema}.fams_bok_stat_bok_position to ${idl_schema};
grant select on ${iol_schema}.fams_bok_stat_bok_position to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_bok_stat_bok_position is '统计分析账套汇总表';
comment on column ${iol_schema}.fams_bok_stat_bok_position.bookset_id is '账套代码';
comment on column ${iol_schema}.fams_bok_stat_bok_position.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_bok_stat_bok_position.happen_date is '发生日期';
comment on column ${iol_schema}.fams_bok_stat_bok_position.book_date is '入账日期';
comment on column ${iol_schema}.fams_bok_stat_bok_position.bookset_date is '账套日期';
comment on column ${iol_schema}.fams_bok_stat_bok_position.profit_type is '收益类型';
comment on column ${iol_schema}.fams_bok_stat_bok_position.capital is '实收资本';
comment on column ${iol_schema}.fams_bok_stat_bok_position.profit_amt is '当日应付利润';
comment on column ${iol_schema}.fams_bok_stat_bok_position.tot_profit_amt is '累计应付利润';
comment on column ${iol_schema}.fams_bok_stat_bok_position.int_rate is '计提利率';
comment on column ${iol_schema}.fams_bok_stat_bok_position.net_asset_value_bef is '费前资产净值';
comment on column ${iol_schema}.fams_bok_stat_bok_position.net_asset_value is '资产净值';
comment on column ${iol_schema}.fams_bok_stat_bok_position.net_unit_value_bef is '费前单位净值';
comment on column ${iol_schema}.fams_bok_stat_bok_position.net_unit_value is '单位净值';
comment on column ${iol_schema}.fams_bok_stat_bok_position.p_yield_bef is '万份收益_费前';
comment on column ${iol_schema}.fams_bok_stat_bok_position.p_yield is '万份收益';
comment on column ${iol_schema}.fams_bok_stat_bok_position.tdy_yield_bef is '当日年化收益率_费前';
comment on column ${iol_schema}.fams_bok_stat_bok_position.tdy_yield is '当日年化收益率';
comment on column ${iol_schema}.fams_bok_stat_bok_position.yield_term_bef is '周期年化收益率_费前';
comment on column ${iol_schema}.fams_bok_stat_bok_position.yield_term is '周期年化收益率';
comment on column ${iol_schema}.fams_bok_stat_bok_position.yield_7_bef is '当日7日年化收益率_费前';
comment on column ${iol_schema}.fams_bok_stat_bok_position.yield_7 is '当日7日年化收益率';
comment on column ${iol_schema}.fams_bok_stat_bok_position.tot_bouns_amt is '累计分红金额';
comment on column ${iol_schema}.fams_bok_stat_bok_position.tdy_bouns_amt is '当日分红金额';
comment on column ${iol_schema}.fams_bok_stat_bok_position.tot_bouns_net is '累计分红净值';
comment on column ${iol_schema}.fams_bok_stat_bok_position.tdy_bouns_net is '当日分红净值';
comment on column ${iol_schema}.fams_bok_stat_bok_position.is_sub_prd is '是否子产品';
comment on column ${iol_schema}.fams_bok_stat_bok_position.layering_id is '分层代码，子产品存分层代码，母产品存核算主体代码';
comment on column ${iol_schema}.fams_bok_stat_bok_position.create_user is '创建人';
comment on column ${iol_schema}.fams_bok_stat_bok_position.create_dept is '创建部门';
comment on column ${iol_schema}.fams_bok_stat_bok_position.create_time is '创建时间';
comment on column ${iol_schema}.fams_bok_stat_bok_position.update_user is '更新人';
comment on column ${iol_schema}.fams_bok_stat_bok_position.update_time is '更新时间';
comment on column ${iol_schema}.fams_bok_stat_bok_position.start_dt is '开始时间';
comment on column ${iol_schema}.fams_bok_stat_bok_position.end_dt is '结束时间';
comment on column ${iol_schema}.fams_bok_stat_bok_position.id_mark is '增删标志';
comment on column ${iol_schema}.fams_bok_stat_bok_position.etl_timestamp is 'ETL处理时间戳';
