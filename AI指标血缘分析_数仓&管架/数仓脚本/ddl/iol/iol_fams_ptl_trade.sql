/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ptl_trade
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ptl_trade
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ptl_trade purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ptl_trade(
    portfolio_id varchar2(32) -- 组合代码
    ,busi_no varchar2(36) -- 业务编号
    ,busi_table varchar2(50) -- 业务表，交易表、结算指令等
    ,busi_id varchar2(50) -- 业务明细代码，金融产品代码、资金账号等
    ,busi_type varchar2(50) -- 业务类型，债券交易、债券存续交易、基金交易、收划款等
    ,inv_aim varchar2(50) -- 投资目的
    ,sec_manage_acct_id varchar2(32) -- 证券托管户代码
    ,settle_date date -- 实际发生日
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
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_ptl_trade to ${iml_schema};
grant select on ${iol_schema}.fams_ptl_trade to ${icl_schema};
grant select on ${iol_schema}.fams_ptl_trade to ${idl_schema};
grant select on ${iol_schema}.fams_ptl_trade to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ptl_trade is '组合交易表';
comment on column ${iol_schema}.fams_ptl_trade.portfolio_id is '组合代码';
comment on column ${iol_schema}.fams_ptl_trade.busi_no is '业务编号';
comment on column ${iol_schema}.fams_ptl_trade.busi_table is '业务表，交易表、结算指令等';
comment on column ${iol_schema}.fams_ptl_trade.busi_id is '业务明细代码，金融产品代码、资金账号等';
comment on column ${iol_schema}.fams_ptl_trade.busi_type is '业务类型，债券交易、债券存续交易、基金交易、收划款等';
comment on column ${iol_schema}.fams_ptl_trade.inv_aim is '投资目的';
comment on column ${iol_schema}.fams_ptl_trade.sec_manage_acct_id is '证券托管户代码';
comment on column ${iol_schema}.fams_ptl_trade.settle_date is '实际发生日';
comment on column ${iol_schema}.fams_ptl_trade.create_user is '创建人';
comment on column ${iol_schema}.fams_ptl_trade.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ptl_trade.create_time is '创建时间';
comment on column ${iol_schema}.fams_ptl_trade.update_user is '更新人';
comment on column ${iol_schema}.fams_ptl_trade.update_time is '更新时间';
comment on column ${iol_schema}.fams_ptl_trade.start_dt is '开始时间';
comment on column ${iol_schema}.fams_ptl_trade.end_dt is '结束时间';
comment on column ${iol_schema}.fams_ptl_trade.id_mark is '增删标志';
comment on column ${iol_schema}.fams_ptl_trade.etl_timestamp is 'ETL处理时间戳';
