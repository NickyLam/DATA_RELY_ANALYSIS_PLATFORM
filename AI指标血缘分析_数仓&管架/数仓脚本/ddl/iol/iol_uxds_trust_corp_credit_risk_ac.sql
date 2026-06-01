/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_trust_corp_credit_risk_ac
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_trust_corp_credit_risk_ac
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_trust_corp_credit_risk_ac purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_trust_corp_credit_risk_ac(
    seq number(20,0) -- 记录唯一标识
    ,ctime date -- 记录创建日期
    ,mtime date -- 记录修改日期
    ,rtime date -- 记录通讯到用户端日期
    ,org_id varchar2(300) -- 机构id
    ,org_name varchar2(3000) -- 机构名称
    ,ed date -- 截止日期
    ,normal_category number(18,4) -- 正常类
    ,concern_category number(18,4) -- 关注类
    ,seondary_category number(18,4) -- 次级类
    ,suspicious_category number(18,4) -- 可疑类
    ,loss_category number(18,4) -- 损失类
    ,credit_risk_total_asset number(18,4) -- 信用风险资产合计
    ,total_bad_assets number(18,4) -- 不良资产合计
    ,bad_assets_ratio number(18,4) -- 不良资产率(%)
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
grant select on ${iol_schema}.uxds_trust_corp_credit_risk_ac to ${iml_schema};
grant select on ${iol_schema}.uxds_trust_corp_credit_risk_ac to ${icl_schema};
grant select on ${iol_schema}.uxds_trust_corp_credit_risk_ac to ${idl_schema};
grant select on ${iol_schema}.uxds_trust_corp_credit_risk_ac to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_trust_corp_credit_risk_ac is '信托公司信用风险资产分类情况';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.ctime is '记录创建日期';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.mtime is '记录修改日期';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.rtime is '记录通讯到用户端日期';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.org_id is '机构id';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.org_name is '机构名称';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.ed is '截止日期';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.normal_category is '正常类';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.concern_category is '关注类';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.seondary_category is '次级类';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.suspicious_category is '可疑类';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.loss_category is '损失类';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.credit_risk_total_asset is '信用风险资产合计';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.total_bad_assets is '不良资产合计';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.bad_assets_ratio is '不良资产率(%)';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_trust_corp_credit_risk_ac.etl_timestamp is 'ETL处理时间戳';
