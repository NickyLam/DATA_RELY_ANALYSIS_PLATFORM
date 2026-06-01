/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fkd_half_year_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fkd_half_year_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fkd_half_year_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_half_year_info(
    pk_no varchar2(32) -- 流水号
    ,halfyearamt number(16,2) -- 半年审额度
    ,outstndlmt number(16,2) -- 已用额度
    ,applytime varchar2(20) -- 半年审时间
    ,crdappamt number(16,2) -- 额度合同授信额度
    ,lmtserno varchar2(32) -- 额度合同号
    ,applydate date -- 半年审日期
    ,residuallmt number(16,2) -- 可用额度
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
grant select on ${iol_schema}.icms_fkd_half_year_info to ${iml_schema};
grant select on ${iol_schema}.icms_fkd_half_year_info to ${icl_schema};
grant select on ${iol_schema}.icms_fkd_half_year_info to ${idl_schema};
grant select on ${iol_schema}.icms_fkd_half_year_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fkd_half_year_info is '华兴快贷半年审信息';
comment on column ${iol_schema}.icms_fkd_half_year_info.pk_no is '流水号';
comment on column ${iol_schema}.icms_fkd_half_year_info.halfyearamt is '半年审额度';
comment on column ${iol_schema}.icms_fkd_half_year_info.outstndlmt is '已用额度';
comment on column ${iol_schema}.icms_fkd_half_year_info.applytime is '半年审时间';
comment on column ${iol_schema}.icms_fkd_half_year_info.crdappamt is '额度合同授信额度';
comment on column ${iol_schema}.icms_fkd_half_year_info.lmtserno is '额度合同号';
comment on column ${iol_schema}.icms_fkd_half_year_info.applydate is '半年审日期';
comment on column ${iol_schema}.icms_fkd_half_year_info.residuallmt is '可用额度';
comment on column ${iol_schema}.icms_fkd_half_year_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fkd_half_year_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fkd_half_year_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fkd_half_year_info.etl_timestamp is 'ETL处理时间戳';
