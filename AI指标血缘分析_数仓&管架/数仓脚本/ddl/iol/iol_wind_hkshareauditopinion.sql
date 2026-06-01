/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hkshareauditopinion
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hkshareauditopinion
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hkshareauditopinion purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkshareauditopinion(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司id
    ,ann_dt varchar2(12) -- 公告日期
    ,begin_dt varchar2(12) -- 起始日期
    ,end_dt_ora varchar2(12) -- 截止日期
    ,audit_std number(9,0) -- 会计准则类型代码
    ,s_stmnote_audit_agency varchar2(450) -- 审计机构名称
    ,s_stmnote_audit_category varchar2(60) -- 审计意见类型
    ,audit_ctnt varchar2(4000) -- 非标审计意见内容
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
grant select on ${iol_schema}.wind_hkshareauditopinion to ${iml_schema};
grant select on ${iol_schema}.wind_hkshareauditopinion to ${icl_schema};
grant select on ${iol_schema}.wind_hkshareauditopinion to ${idl_schema};
grant select on ${iol_schema}.wind_hkshareauditopinion to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hkshareauditopinion is '香港股票财报审计意见';
comment on column ${iol_schema}.wind_hkshareauditopinion.object_id is '对象ID';
comment on column ${iol_schema}.wind_hkshareauditopinion.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_hkshareauditopinion.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_hkshareauditopinion.begin_dt is '起始日期';
comment on column ${iol_schema}.wind_hkshareauditopinion.end_dt_ora is '截止日期';
comment on column ${iol_schema}.wind_hkshareauditopinion.audit_std is '会计准则类型代码';
comment on column ${iol_schema}.wind_hkshareauditopinion.s_stmnote_audit_agency is '审计机构名称';
comment on column ${iol_schema}.wind_hkshareauditopinion.s_stmnote_audit_category is '审计意见类型';
comment on column ${iol_schema}.wind_hkshareauditopinion.audit_ctnt is '非标审计意见内容';
comment on column ${iol_schema}.wind_hkshareauditopinion.start_dt is '开始时间';
comment on column ${iol_schema}.wind_hkshareauditopinion.end_dt is '结束时间';
comment on column ${iol_schema}.wind_hkshareauditopinion.id_mark is '增删标志';
comment on column ${iol_schema}.wind_hkshareauditopinion.etl_timestamp is 'ETL处理时间戳';
