/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareauditopinion
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareauditopinion
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareauditopinion purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareauditopinion(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,s_stmnote_audit_category number(9,0) -- 审计结果类别代码
    ,s_stmnote_audit_agency varchar2(150) -- 会计师事务所
    ,s_stmnote_audit_cpa varchar2(150) -- 签字会计师
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
grant select on ${iol_schema}.wind_ashareauditopinion to ${iml_schema};
grant select on ${iol_schema}.wind_ashareauditopinion to ${icl_schema};
grant select on ${iol_schema}.wind_ashareauditopinion to ${idl_schema};
grant select on ${iol_schema}.wind_ashareauditopinion to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareauditopinion is '中国A股审计意见';
comment on column ${iol_schema}.wind_ashareauditopinion.object_id is '对象ID';
comment on column ${iol_schema}.wind_ashareauditopinion.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_ashareauditopinion.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_ashareauditopinion.report_period is '报告期';
comment on column ${iol_schema}.wind_ashareauditopinion.s_stmnote_audit_category is '审计结果类别代码';
comment on column ${iol_schema}.wind_ashareauditopinion.s_stmnote_audit_agency is '会计师事务所';
comment on column ${iol_schema}.wind_ashareauditopinion.s_stmnote_audit_cpa is '签字会计师';
comment on column ${iol_schema}.wind_ashareauditopinion.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_ashareauditopinion.etl_timestamp is 'ETL处理时间戳';
