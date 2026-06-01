/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_abssubfiledata
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_abssubfiledata
whenever sqlerror continue none;
drop table ${iol_schema}.wind_abssubfiledata purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_abssubfiledata(
    s_info_windcode varchar2(60) -- Wind代码
    ,yield_min number(20,4) -- 预期最低年收 益率(%)
    ,yield_max number(20,4) -- 预期最高年收 益率(%)
    ,s_info_compcode varchar2(15) -- 资产所有方公司id
    ,b_anal_ptmyear number(20,4) -- 存续期
    ,basic_assets varchar2(3000) -- 基础资产
    ,mobile_places varchar2(1200) -- 流动场所
    ,product_compname varchar2(300) -- 产品设立人
    ,start_date varchar2(12) -- 转让起始日期
    ,end_date varchar2(12) -- 转让截止日期
    ,product_manager varchar2(300) -- 产品管理人
    ,bookkeeping_manager varchar2(300) -- 薄记管理人
    ,subdivide_code number(9,0) -- 资产支持证券 分档代码
    ,intex_name varchar2(30) -- Intex项目名称
    ,intex_code varchar2(30) -- Intex分档代码
    ,intex_rate varchar2(75) -- Intex利率基准
    ,repay_typecode number(9,0) -- 还本方式代码
    ,amount_ownhold number(24,8) -- 自持金额
    ,fix_capital_cost number(24,4) -- 固定资金成本
    ,sub_period_revenue_cap number(24,4) -- 次级期间收益 上限
    ,abs_id varchar2(15) -- 项目ID
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
grant select on ${iol_schema}.wind_abssubfiledata to ${iml_schema};
grant select on ${iol_schema}.wind_abssubfiledata to ${icl_schema};
grant select on ${iol_schema}.wind_abssubfiledata to ${idl_schema};
grant select on ${iol_schema}.wind_abssubfiledata to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_abssubfiledata is '资产支持证券分档基本资料';
comment on column ${iol_schema}.wind_abssubfiledata.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_abssubfiledata.yield_min is '预期最低年收 益率(%)';
comment on column ${iol_schema}.wind_abssubfiledata.yield_max is '预期最高年收 益率(%)';
comment on column ${iol_schema}.wind_abssubfiledata.s_info_compcode is '资产所有方公司id';
comment on column ${iol_schema}.wind_abssubfiledata.b_anal_ptmyear is '存续期';
comment on column ${iol_schema}.wind_abssubfiledata.basic_assets is '基础资产';
comment on column ${iol_schema}.wind_abssubfiledata.mobile_places is '流动场所';
comment on column ${iol_schema}.wind_abssubfiledata.product_compname is '产品设立人';
comment on column ${iol_schema}.wind_abssubfiledata.start_date is '转让起始日期';
comment on column ${iol_schema}.wind_abssubfiledata.end_date is '转让截止日期';
comment on column ${iol_schema}.wind_abssubfiledata.product_manager is '产品管理人';
comment on column ${iol_schema}.wind_abssubfiledata.bookkeeping_manager is '薄记管理人';
comment on column ${iol_schema}.wind_abssubfiledata.subdivide_code is '资产支持证券 分档代码';
comment on column ${iol_schema}.wind_abssubfiledata.intex_name is 'Intex项目名称';
comment on column ${iol_schema}.wind_abssubfiledata.intex_code is 'Intex分档代码';
comment on column ${iol_schema}.wind_abssubfiledata.intex_rate is 'Intex利率基准';
comment on column ${iol_schema}.wind_abssubfiledata.repay_typecode is '还本方式代码';
comment on column ${iol_schema}.wind_abssubfiledata.amount_ownhold is '自持金额';
comment on column ${iol_schema}.wind_abssubfiledata.fix_capital_cost is '固定资金成本';
comment on column ${iol_schema}.wind_abssubfiledata.sub_period_revenue_cap is '次级期间收益 上限';
comment on column ${iol_schema}.wind_abssubfiledata.abs_id is '项目ID';
comment on column ${iol_schema}.wind_abssubfiledata.start_dt is '开始时间';
comment on column ${iol_schema}.wind_abssubfiledata.end_dt is '结束时间';
comment on column ${iol_schema}.wind_abssubfiledata.id_mark is '增删标志';
comment on column ${iol_schema}.wind_abssubfiledata.etl_timestamp is 'ETL处理时间戳';
