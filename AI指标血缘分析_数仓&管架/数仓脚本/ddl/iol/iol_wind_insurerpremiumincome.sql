/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_insurerpremiumincome
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_insurerpremiumincome
whenever sqlerror continue none;
drop table ${iol_schema}.wind_insurerpremiumincome purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_insurerpremiumincome(
    object_id varchar2(57) -- 对象ID
    ,monthly varchar2(9) -- 月度
    ,insurance_company varchar2(60) -- 保险公司
    ,premium_category varchar2(15) -- 保费类别
    ,company_category varchar2(15) -- [内部]公司类别
    ,income number(20,4) -- 收入(万元)
    ,s_info_compcode varchar2(15) -- 保险公司id
    ,enterprise_annuity number(20,4) -- 企业年金缴费
    ,entrusted_assets number(20,4) -- 受托管理资产
    ,investment_assets number(20,4) -- 投资管理资产
    ,insured_inv_newly_added number(20,4) -- 保户投资款新增缴费
    ,inv_linked_insurance_added number(20,4) -- 投连险独立账户新增增缴费
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
grant select on ${iol_schema}.wind_insurerpremiumincome to ${iml_schema};
grant select on ${iol_schema}.wind_insurerpremiumincome to ${icl_schema};
grant select on ${iol_schema}.wind_insurerpremiumincome to ${idl_schema};
grant select on ${iol_schema}.wind_insurerpremiumincome to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_insurerpremiumincome is '保险公司保费收入';
comment on column ${iol_schema}.wind_insurerpremiumincome.object_id is '对象ID';
comment on column ${iol_schema}.wind_insurerpremiumincome.monthly is '月度';
comment on column ${iol_schema}.wind_insurerpremiumincome.insurance_company is '保险公司';
comment on column ${iol_schema}.wind_insurerpremiumincome.premium_category is '保费类别';
comment on column ${iol_schema}.wind_insurerpremiumincome.company_category is '[内部]公司类别';
comment on column ${iol_schema}.wind_insurerpremiumincome.income is '收入(万元)';
comment on column ${iol_schema}.wind_insurerpremiumincome.s_info_compcode is '保险公司id';
comment on column ${iol_schema}.wind_insurerpremiumincome.enterprise_annuity is '企业年金缴费';
comment on column ${iol_schema}.wind_insurerpremiumincome.entrusted_assets is '受托管理资产';
comment on column ${iol_schema}.wind_insurerpremiumincome.investment_assets is '投资管理资产';
comment on column ${iol_schema}.wind_insurerpremiumincome.insured_inv_newly_added is '保户投资款新增缴费';
comment on column ${iol_schema}.wind_insurerpremiumincome.inv_linked_insurance_added is '投连险独立账户新增增缴费';
comment on column ${iol_schema}.wind_insurerpremiumincome.start_dt is '开始时间';
comment on column ${iol_schema}.wind_insurerpremiumincome.end_dt is '结束时间';
comment on column ${iol_schema}.wind_insurerpremiumincome.id_mark is '增删标志';
comment on column ${iol_schema}.wind_insurerpremiumincome.etl_timestamp is 'ETL处理时间戳';
