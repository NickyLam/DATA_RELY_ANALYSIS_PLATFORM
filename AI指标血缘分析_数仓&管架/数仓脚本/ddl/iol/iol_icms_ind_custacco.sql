/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_custacco
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_custacco
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_custacco purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_custacco(
    customerid varchar2(32) -- 
    ,serialno varchar2(32) -- 
    ,relativeaccount varchar2(8) -- 
    ,accountname varchar2(80) -- 
    ,accountbank varchar2(8) -- 
    ,updatedate varchar2(20) -- 
    ,updateorgid varchar2(32) -- 
    ,accountnumber varchar2(32) -- 
    ,inputuserid varchar2(32) -- 
    ,inputdate varchar2(20) -- 
    ,inputorgid varchar2(32) -- 
    ,accumulate number(16,6) -- 
    ,updateuserid varchar2(32) -- 
    ,accounttype varchar2(8) -- 
    ,remark varchar2(200) -- 
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
grant select on ${iol_schema}.icms_ind_custacco to ${iml_schema};
grant select on ${iol_schema}.icms_ind_custacco to ${icl_schema};
grant select on ${iol_schema}.icms_ind_custacco to ${idl_schema};
grant select on ${iol_schema}.icms_ind_custacco to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_custacco is '个体经营户存款信息表';
comment on column ${iol_schema}.icms_ind_custacco.customerid is '';
comment on column ${iol_schema}.icms_ind_custacco.serialno is '';
comment on column ${iol_schema}.icms_ind_custacco.relativeaccount is '';
comment on column ${iol_schema}.icms_ind_custacco.accountname is '';
comment on column ${iol_schema}.icms_ind_custacco.accountbank is '';
comment on column ${iol_schema}.icms_ind_custacco.updatedate is '';
comment on column ${iol_schema}.icms_ind_custacco.updateorgid is '';
comment on column ${iol_schema}.icms_ind_custacco.accountnumber is '';
comment on column ${iol_schema}.icms_ind_custacco.inputuserid is '';
comment on column ${iol_schema}.icms_ind_custacco.inputdate is '';
comment on column ${iol_schema}.icms_ind_custacco.inputorgid is '';
comment on column ${iol_schema}.icms_ind_custacco.accumulate is '';
comment on column ${iol_schema}.icms_ind_custacco.updateuserid is '';
comment on column ${iol_schema}.icms_ind_custacco.accounttype is '';
comment on column ${iol_schema}.icms_ind_custacco.remark is '';
comment on column ${iol_schema}.icms_ind_custacco.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_custacco.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_custacco.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_custacco.etl_timestamp is 'ETL处理时间戳';
