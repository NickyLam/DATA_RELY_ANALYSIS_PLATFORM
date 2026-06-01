/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_issuer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_issuer
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_issuer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_issuer(
    issuer_id varchar2(60) -- 发行人ID
    ,status varchar2(2) -- 状态
    ,issuer_name_zh varchar2(96) -- 中文名称
    ,issuer_name_en varchar2(96) -- 英文名称
    ,modify_date date -- 修改日期
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
grant select on ${iol_schema}.ctms_tbs_vs_issuer to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_issuer to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_issuer to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_issuer to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_issuer is '债券发行人信息';
comment on column ${iol_schema}.ctms_tbs_vs_issuer.issuer_id is '发行人ID';
comment on column ${iol_schema}.ctms_tbs_vs_issuer.status is '状态';
comment on column ${iol_schema}.ctms_tbs_vs_issuer.issuer_name_zh is '中文名称';
comment on column ${iol_schema}.ctms_tbs_vs_issuer.issuer_name_en is '英文名称';
comment on column ${iol_schema}.ctms_tbs_vs_issuer.modify_date is '修改日期';
comment on column ${iol_schema}.ctms_tbs_vs_issuer.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_issuer.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_issuer.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_issuer.etl_timestamp is 'ETL处理时间戳';
