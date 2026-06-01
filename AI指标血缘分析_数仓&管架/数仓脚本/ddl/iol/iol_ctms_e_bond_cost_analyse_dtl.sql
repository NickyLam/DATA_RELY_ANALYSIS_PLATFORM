/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_e_bond_cost_analyse_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_e_bond_cost_analyse_dtl
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_e_bond_cost_analyse_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_e_bond_cost_analyse_dtl(
    settledate varchar2(12) -- 数据日期
    ,account_type varchar2(384) -- 账户分类
    ,third_type varchar2(15) -- 简易三分类
    ,security_id varchar2(24) -- 债券代码
    ,security_name varchar2(384) -- 债券名称
    ,security_type varchar2(24) -- 债券类别代码
    ,security_type_name varchar2(75) -- 债券类别名称
    ,currency varchar2(12) -- 币种
    ,position number(17,2) -- 券面总额
    ,residual_qty number(23,8) -- 剩余本金
    ,price_yield number(23,8) -- 到期收益率
    ,net_price number(23,8) -- 市场净价/折溢摊净价
    ,term_to_maturity number -- 剩余期限/年
    ,mduration number -- 修正久期
    ,floatingpl number(23,8) -- 浮动盈亏
    ,pfolio_id number(38,0) -- 投组编号
    ,pfolio_name varchar2(384) -- 投组名称
    ,dirty_market_value number(23,8) -- 全价市值
    ,is_qualified varchar2(15) -- 是否合格债券
    ,issuer_name varchar2(96) -- 发行人名称
    ,issuer_label varchar2(96) -- 发行人ECIF客户号
    ,dmp_time timestamp -- 创建时间戳
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ctms_e_bond_cost_analyse_dtl to ${iml_schema};
grant select on ${iol_schema}.ctms_e_bond_cost_analyse_dtl to ${icl_schema};
grant select on ${iol_schema}.ctms_e_bond_cost_analyse_dtl to ${idl_schema};
grant select on ${iol_schema}.ctms_e_bond_cost_analyse_dtl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_e_bond_cost_analyse_dtl is '每日日终债券明细表';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.settledate is '数据日期';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.account_type is '账户分类';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.third_type is '简易三分类';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.security_id is '债券代码';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.security_name is '债券名称';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.security_type is '债券类别代码';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.security_type_name is '债券类别名称';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.currency is '币种';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.position is '券面总额';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.residual_qty is '剩余本金';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.price_yield is '到期收益率';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.net_price is '市场净价/折溢摊净价';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.term_to_maturity is '剩余期限/年';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.mduration is '修正久期';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.floatingpl is '浮动盈亏';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.pfolio_id is '投组编号';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.pfolio_name is '投组名称';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.dirty_market_value is '全价市值';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.is_qualified is '是否合格债券';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.issuer_name is '发行人名称';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.issuer_label is '发行人ECIF客户号';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.dmp_time is '创建时间戳';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ctms_e_bond_cost_analyse_dtl.etl_timestamp is 'ETL处理时间戳';
