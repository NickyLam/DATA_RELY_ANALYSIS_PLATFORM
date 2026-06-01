/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_writeoff_basis
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_writeoff_basis
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_writeoff_basis purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_writeoff_basis(
    serialno varchar2(64) -- 依据序号
    ,inputorgid varchar2(64) -- 登记机构
    ,updateorgid varchar2(64) -- 更新机构
    ,tmsp date -- 时间戳
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate date -- 登记日期
    ,basiscontent varchar2(2000) -- 内容
    ,updatedate date -- 更新日期
    ,updateuserid varchar2(64) -- 更新人
    ,classify varchar2(160) -- 分类
    ,keyword varchar2(1000) -- 关键词
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
grant select on ${iol_schema}.icms_ap_writeoff_basis to ${iml_schema};
grant select on ${iol_schema}.icms_ap_writeoff_basis to ${icl_schema};
grant select on ${iol_schema}.icms_ap_writeoff_basis to ${idl_schema};
grant select on ${iol_schema}.icms_ap_writeoff_basis to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_writeoff_basis is '核销依据表';
comment on column ${iol_schema}.icms_ap_writeoff_basis.serialno is '依据序号';
comment on column ${iol_schema}.icms_ap_writeoff_basis.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_writeoff_basis.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_writeoff_basis.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_writeoff_basis.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_writeoff_basis.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_writeoff_basis.basiscontent is '内容';
comment on column ${iol_schema}.icms_ap_writeoff_basis.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_writeoff_basis.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_writeoff_basis.classify is '分类';
comment on column ${iol_schema}.icms_ap_writeoff_basis.keyword is '关键词';
comment on column ${iol_schema}.icms_ap_writeoff_basis.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_ap_writeoff_basis.etl_timestamp is 'ETL处理时间戳';
