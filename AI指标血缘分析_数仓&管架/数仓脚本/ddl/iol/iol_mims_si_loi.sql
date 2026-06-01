/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_loi
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_loi
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_loi purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_loi(
    sccode varchar2(48) -- 
    ,loino varchar2(90) -- 
    ,loitype varchar2(3) -- 
    ,loicountry varchar2(150) -- 
    ,orgname varchar2(150) -- 
    ,orgtype varchar2(3) -- 
    ,outratingresult varchar2(150) -- 
    ,outratingdate varchar2(15) -- 
    ,inratingresult varchar2(150) -- 
    ,intatingdate varchar2(15) -- 
    ,registcountry varchar2(150) -- 
    ,registcountryresult varchar2(150) -- 
    ,isstage varchar2(3) -- 
    ,iscancel varchar2(3) -- 
    ,loimoney number(20,2) -- 
    ,remark varchar2(4000) -- 
    ,tdcurrency varchar2(5) -- 
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
grant select on ${iol_schema}.mims_si_loi to ${iml_schema};
grant select on ${iol_schema}.mims_si_loi to ${icl_schema};
grant select on ${iol_schema}.mims_si_loi to ${idl_schema};
grant select on ${iol_schema}.mims_si_loi to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_loi is '保函';
comment on column ${iol_schema}.mims_si_loi.sccode is '';
comment on column ${iol_schema}.mims_si_loi.loino is '';
comment on column ${iol_schema}.mims_si_loi.loitype is '';
comment on column ${iol_schema}.mims_si_loi.loicountry is '';
comment on column ${iol_schema}.mims_si_loi.orgname is '';
comment on column ${iol_schema}.mims_si_loi.orgtype is '';
comment on column ${iol_schema}.mims_si_loi.outratingresult is '';
comment on column ${iol_schema}.mims_si_loi.outratingdate is '';
comment on column ${iol_schema}.mims_si_loi.inratingresult is '';
comment on column ${iol_schema}.mims_si_loi.intatingdate is '';
comment on column ${iol_schema}.mims_si_loi.registcountry is '';
comment on column ${iol_schema}.mims_si_loi.registcountryresult is '';
comment on column ${iol_schema}.mims_si_loi.isstage is '';
comment on column ${iol_schema}.mims_si_loi.iscancel is '';
comment on column ${iol_schema}.mims_si_loi.loimoney is '';
comment on column ${iol_schema}.mims_si_loi.remark is '';
comment on column ${iol_schema}.mims_si_loi.tdcurrency is '';
comment on column ${iol_schema}.mims_si_loi.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_loi.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_loi.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_loi.etl_timestamp is 'ETL处理时间戳';
