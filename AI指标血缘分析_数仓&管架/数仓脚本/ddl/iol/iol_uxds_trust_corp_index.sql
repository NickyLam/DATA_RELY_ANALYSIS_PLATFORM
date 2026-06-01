/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_trust_corp_index
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_trust_corp_index
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_trust_corp_index purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_trust_corp_index(
    seq number(28,0) -- 记录唯一标识
    ,ctime date -- 记录创建时间
    ,mtime date -- 记录修改时间
    ,rtime date -- 记录通讯到用户端时间
    ,trust_company_code varchar2(60) -- 信托公司机构代码@关联到corp_basic_info.org_id
    ,ed date -- 截止日期
    ,total_use_of_trust_assets number(22,6) -- 信托资产运用合计@单位：万元
    ,total_trust_income number(22,6) -- 信托收入合计@单位：万元
    ,total_trust_fees number(22,6) -- 信托费用合计@单位：万元；信托费用合计=营业费用+营业税金及附加
    ,trust_gains_and_losses number(22,6) -- 信托损益@单位：万元
    ,return_on_capital number(18,3) -- 资本收益率@单位：%
    ,trust_rate_of_return number(18,3) -- 信托报酬率@单位：%
    ,profit_per_capita number(22,6) -- 人均利润@单位：万元
    ,trust_company_name varchar2(300) -- 信托公司名称
    ,operating_fee number(18,4) -- 营业费用
    ,operating_taxes_and_surcharge number(18,4) -- 营业税金及附加
    ,isvalid number(1,0) -- 是否有效
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
grant select on ${iol_schema}.uxds_trust_corp_index to ${iml_schema};
grant select on ${iol_schema}.uxds_trust_corp_index to ${icl_schema};
grant select on ${iol_schema}.uxds_trust_corp_index to ${idl_schema};
grant select on ${iol_schema}.uxds_trust_corp_index to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_trust_corp_index is '信托公司指标';
comment on column ${iol_schema}.uxds_trust_corp_index.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_trust_corp_index.ctime is '记录创建时间';
comment on column ${iol_schema}.uxds_trust_corp_index.mtime is '记录修改时间';
comment on column ${iol_schema}.uxds_trust_corp_index.rtime is '记录通讯到用户端时间';
comment on column ${iol_schema}.uxds_trust_corp_index.trust_company_code is '信托公司机构代码@关联到corp_basic_info.org_id';
comment on column ${iol_schema}.uxds_trust_corp_index.ed is '截止日期';
comment on column ${iol_schema}.uxds_trust_corp_index.total_use_of_trust_assets is '信托资产运用合计@单位：万元';
comment on column ${iol_schema}.uxds_trust_corp_index.total_trust_income is '信托收入合计@单位：万元';
comment on column ${iol_schema}.uxds_trust_corp_index.total_trust_fees is '信托费用合计@单位：万元；信托费用合计=营业费用+营业税金及附加';
comment on column ${iol_schema}.uxds_trust_corp_index.trust_gains_and_losses is '信托损益@单位：万元';
comment on column ${iol_schema}.uxds_trust_corp_index.return_on_capital is '资本收益率@单位：%';
comment on column ${iol_schema}.uxds_trust_corp_index.trust_rate_of_return is '信托报酬率@单位：%';
comment on column ${iol_schema}.uxds_trust_corp_index.profit_per_capita is '人均利润@单位：万元';
comment on column ${iol_schema}.uxds_trust_corp_index.trust_company_name is '信托公司名称';
comment on column ${iol_schema}.uxds_trust_corp_index.operating_fee is '营业费用';
comment on column ${iol_schema}.uxds_trust_corp_index.operating_taxes_and_surcharge is '营业税金及附加';
comment on column ${iol_schema}.uxds_trust_corp_index.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_trust_corp_index.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_trust_corp_index.etl_timestamp is 'ETL处理时间戳';
