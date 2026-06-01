/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ptl_portfolio
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ptl_portfolio
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ptl_portfolio purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ptl_portfolio(
    portfolio_id varchar2(32) -- 组合代码
    ,portfolio_type varchar2(50) -- 组合类型，管理组合、投资组合、资金单元、过渡组合
    ,portfolio_name varchar2(200) -- 组合名称
    ,vdate date -- 组合开始日
    ,mdate date -- 组合结束日
    ,profit_type varchar2(50) -- 收益类型，预期收益型/净值型/货币型
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,income_flag varchar2(50) -- 是否保本
    ,remark varchar2(1000) -- 备注
    ,parent_portfolio_id varchar2(32) -- 母组合代码
    ,invest_yesorno varchar2(50) -- 是否能投资
    ,inv_trans_portf varchar2(32) -- 所属投资过渡组合
    ,risk_enabled varchar2(50) -- 是否启用风险
    ,ccy varchar2(50) -- 币种
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
grant select on ${iol_schema}.fams_ptl_portfolio to ${iml_schema};
grant select on ${iol_schema}.fams_ptl_portfolio to ${icl_schema};
grant select on ${iol_schema}.fams_ptl_portfolio to ${idl_schema};
grant select on ${iol_schema}.fams_ptl_portfolio to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ptl_portfolio is '组合';
comment on column ${iol_schema}.fams_ptl_portfolio.portfolio_id is '组合代码';
comment on column ${iol_schema}.fams_ptl_portfolio.portfolio_type is '组合类型，管理组合、投资组合、资金单元、过渡组合';
comment on column ${iol_schema}.fams_ptl_portfolio.portfolio_name is '组合名称';
comment on column ${iol_schema}.fams_ptl_portfolio.vdate is '组合开始日';
comment on column ${iol_schema}.fams_ptl_portfolio.mdate is '组合结束日';
comment on column ${iol_schema}.fams_ptl_portfolio.profit_type is '收益类型，预期收益型/净值型/货币型';
comment on column ${iol_schema}.fams_ptl_portfolio.create_user is '创建人';
comment on column ${iol_schema}.fams_ptl_portfolio.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ptl_portfolio.create_time is '创建时间';
comment on column ${iol_schema}.fams_ptl_portfolio.update_user is '更新人';
comment on column ${iol_schema}.fams_ptl_portfolio.update_time is '更新时间';
comment on column ${iol_schema}.fams_ptl_portfolio.income_flag is '是否保本';
comment on column ${iol_schema}.fams_ptl_portfolio.remark is '备注';
comment on column ${iol_schema}.fams_ptl_portfolio.parent_portfolio_id is '母组合代码';
comment on column ${iol_schema}.fams_ptl_portfolio.invest_yesorno is '是否能投资';
comment on column ${iol_schema}.fams_ptl_portfolio.inv_trans_portf is '所属投资过渡组合';
comment on column ${iol_schema}.fams_ptl_portfolio.risk_enabled is '是否启用风险';
comment on column ${iol_schema}.fams_ptl_portfolio.ccy is '币种';
comment on column ${iol_schema}.fams_ptl_portfolio.start_dt is '开始时间';
comment on column ${iol_schema}.fams_ptl_portfolio.end_dt is '结束时间';
comment on column ${iol_schema}.fams_ptl_portfolio.id_mark is '增删标志';
comment on column ${iol_schema}.fams_ptl_portfolio.etl_timestamp is 'ETL处理时间戳';
