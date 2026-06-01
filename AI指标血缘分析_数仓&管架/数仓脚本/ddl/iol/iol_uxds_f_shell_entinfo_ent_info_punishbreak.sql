/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_punishbreak
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak(
    gendate date -- 
    ,serialnumber varchar2(4000) -- 
    ,sequenceid varchar2(4000) -- 
    ,gistunit varchar2(4000) -- 
    ,unperformpart varchar2(4000) -- 
    ,cardnum varchar2(4000) -- 
    ,performance varchar2(4000) -- 
    ,regdateclean varchar2(4000) -- 
    ,businessentity varchar2(4000) -- 
    ,gistid varchar2(4000) -- 
    ,casecode varchar2(4000) -- 
    ,duty varchar2(4000) -- 
    ,performedpart varchar2(4000) -- 
    ,ent_info_punishbreak varchar2(4000) -- 
    ,disrupttypename varchar2(4000) -- 
    ,areanameclean varchar2(4000) -- 
    ,inameclean varchar2(4000) -- 
    ,publishdateclean varchar2(4000) -- 
    ,type varchar2(4000) -- 
    ,courtname varchar2(4000) -- 
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
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak is '失信被执行人信息';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.gendate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.serialnumber is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.sequenceid is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.gistunit is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.unperformpart is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.cardnum is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.performance is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.regdateclean is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.businessentity is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.gistid is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.casecode is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.duty is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.performedpart is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.ent_info_punishbreak is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.disrupttypename is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.areanameclean is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.inameclean is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.publishdateclean is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.type is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.courtname is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_punishbreak.etl_timestamp is 'ETL处理时间戳';
