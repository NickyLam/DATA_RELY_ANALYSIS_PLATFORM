/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_cash_calc_rule
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_cash_calc_rule
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_cash_calc_rule purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_cash_calc_rule(
    cash_id varchar2(32) -- 现金流代码
    ,eff_date date -- 生效日期
    ,calc_type varchar2(50) -- 计算类型，固定利率、浮动利率
    ,base_type varchar2(50) -- 基数类型，本金、资产净值、实收资本等
    ,base_date_type varchar2(50) -- 基数日期类型，上一工作日、上一自然日、当日、上一开放日等
    ,basis varchar2(50) -- 计息基础，a/360，a/365等
    ,yield number(30,14) -- 生效利率
    ,is_initial varchar2(50) -- 是否初始利率
    ,finprod_id varchar2(50) -- 金融产品代码
    ,finprod_type varchar2(50) -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,finprod_type2 varchar2(50) -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,branch number(10) -- 分支序号
    ,remark varchar2(1000) -- 备注
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
grant select on ${iol_schema}.fams_fin_cash_calc_rule to ${iml_schema};
grant select on ${iol_schema}.fams_fin_cash_calc_rule to ${icl_schema};
grant select on ${iol_schema}.fams_fin_cash_calc_rule to ${idl_schema};
grant select on ${iol_schema}.fams_fin_cash_calc_rule to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_cash_calc_rule is '现金流计算规则表';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.cash_id is '现金流代码';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.eff_date is '生效日期';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.calc_type is '计算类型，固定利率、浮动利率';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.base_type is '基数类型，本金、资产净值、实收资本等';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.base_date_type is '基数日期类型，上一工作日、上一自然日、当日、上一开放日等';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.basis is '计息基础，a/360，a/365等';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.yield is '生效利率';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.is_initial is '是否初始利率';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.finprod_type is '金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.finprod_type2 is '金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.branch is '分支序号';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.remark is '备注';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fin_cash_calc_rule.etl_timestamp is 'ETL处理时间戳';
