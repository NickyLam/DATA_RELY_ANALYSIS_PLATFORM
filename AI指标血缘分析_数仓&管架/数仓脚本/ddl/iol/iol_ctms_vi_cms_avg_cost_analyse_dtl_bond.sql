/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_vi_cms_avg_cost_analyse_dtl_bond
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond(
    query_end_date varchar2(12) -- 数据日期
    ,security_id varchar2(24) -- 债券代码
    ,security_name varchar2(192) -- 债券名称
    ,start_date varchar2(12) -- 起息日
    ,end_date varchar2(12) -- 到期日
    ,position number(17,2) -- 面额
    ,residualqty number(17,2) -- 剩余本金
    ,averagecost number(17,2) -- 平均成本
    ,dpaprice number(17,2) -- 折溢摊净价
    ,accruedinterest number(17,2) -- 应计利息
    ,assettype varchar2(2) -- 资产负债分类
    ,cname varchar2(384) -- 债券代码 名称
    ,currency varchar2(12) -- 币别
    ,mduration number(27,12) -- 修正久期
    ,pvbp number(27,12) -- DV01
    ,pfolio_id number(5,0) -- 投组id
    ,pfolio_name varchar2(384) -- 交易投组名称
    ,buztype varchar2(75) -- 投组三分类
    ,keepfolder_id number(22,0) -- 账户ID
    ,keepfolder_code varchar2(30) -- 账户代码
    ,keepfolder_shortname varchar2(75) -- 账户名称
    ,org_id varchar2(30) -- 部门机构
    ,product_code varchar2(18) -- 标准产品
    ,yield number(27,12) -- 到期收益率
    ,security_term_to_maturity varchar2(192) -- 待偿期
    ,security_type varchar2(24) -- 债券类型
    ,couponinterestamt number(23,8) -- 利息收入
    ,dpa number(23,8) -- 折溢摊
    ,spread number(23,8) -- 买卖价差
    ,urpl number(23,8) -- 浮动盈亏
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
grant select on ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond to ${iml_schema};
grant select on ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond to ${icl_schema};
grant select on ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond to ${idl_schema};
grant select on ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond is '平均成本损益分析';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.query_end_date is '数据日期';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.security_id is '债券代码';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.security_name is '债券名称';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.start_date is '起息日';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.end_date is '到期日';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.position is '面额';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.residualqty is '剩余本金';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.averagecost is '平均成本';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.dpaprice is '折溢摊净价';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.accruedinterest is '应计利息';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.assettype is '资产负债分类';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.cname is '债券代码 名称';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.currency is '币别';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.mduration is '修正久期';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.pvbp is 'DV01';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.pfolio_id is '投组id';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.pfolio_name is '交易投组名称';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.buztype is '投组三分类';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.keepfolder_code is '账户代码';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.org_id is '部门机构';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.product_code is '标准产品';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.yield is '到期收益率';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.security_term_to_maturity is '待偿期';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.security_type is '债券类型';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.couponinterestamt is '利息收入';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.dpa is '折溢摊';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.spread is '买卖价差';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.urpl is '浮动盈亏';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond.etl_timestamp is 'ETL处理时间戳';
