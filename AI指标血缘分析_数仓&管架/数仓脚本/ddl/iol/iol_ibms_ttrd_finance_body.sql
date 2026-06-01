/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_finance_body
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_finance_body
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_finance_body purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_finance_body(
    id number(22,0) -- 主键
    ,i_code varchar2(90) -- 
    ,a_type varchar2(30) -- 
    ,m_type varchar2(30) -- 
    ,actual_financier_id varchar2(90) -- 融资人客户号
    ,financier_name varchar2(383) -- 融资人名称
    ,financier_nature varchar2(150) -- 融资人客户性质
    ,parent_group varchar2(383) -- 融资人所属集团
    ,province_id varchar2(8) -- 
    ,comp_area_province varchar2(30) -- 融资人注册地（省）
    ,city_id varchar2(8) -- 
    ,comp_area_city varchar2(30) -- 融资人注册地（市）
    ,invest_amount number(31,4) -- 投资金额（元）
    ,financier_relevance_info varchar2(3000) -- 实际融资人关联方信息(华兴需求)
    ,business_category varchar2(3) -- 行业归属
    ,business_category_name varchar2(75) -- 行业归属名称
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
grant select on ${iol_schema}.ibms_ttrd_finance_body to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_finance_body to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_finance_body to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_finance_body to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_finance_body is '融资主体表';
comment on column ${iol_schema}.ibms_ttrd_finance_body.id is '主键';
comment on column ${iol_schema}.ibms_ttrd_finance_body.i_code is '';
comment on column ${iol_schema}.ibms_ttrd_finance_body.a_type is '';
comment on column ${iol_schema}.ibms_ttrd_finance_body.m_type is '';
comment on column ${iol_schema}.ibms_ttrd_finance_body.actual_financier_id is '融资人客户号';
comment on column ${iol_schema}.ibms_ttrd_finance_body.financier_name is '融资人名称';
comment on column ${iol_schema}.ibms_ttrd_finance_body.financier_nature is '融资人客户性质';
comment on column ${iol_schema}.ibms_ttrd_finance_body.parent_group is '融资人所属集团';
comment on column ${iol_schema}.ibms_ttrd_finance_body.province_id is '';
comment on column ${iol_schema}.ibms_ttrd_finance_body.comp_area_province is '融资人注册地（省）';
comment on column ${iol_schema}.ibms_ttrd_finance_body.city_id is '';
comment on column ${iol_schema}.ibms_ttrd_finance_body.comp_area_city is '融资人注册地（市）';
comment on column ${iol_schema}.ibms_ttrd_finance_body.invest_amount is '投资金额（元）';
comment on column ${iol_schema}.ibms_ttrd_finance_body.financier_relevance_info is '实际融资人关联方信息(华兴需求)';
comment on column ${iol_schema}.ibms_ttrd_finance_body.business_category is '行业归属';
comment on column ${iol_schema}.ibms_ttrd_finance_body.business_category_name is '行业归属名称';
comment on column ${iol_schema}.ibms_ttrd_finance_body.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_finance_body.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_finance_body.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_finance_body.etl_timestamp is 'ETL处理时间戳';
