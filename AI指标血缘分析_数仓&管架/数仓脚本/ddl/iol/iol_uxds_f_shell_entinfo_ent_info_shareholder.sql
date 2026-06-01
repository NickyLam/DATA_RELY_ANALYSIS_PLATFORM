/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_shareholder
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder(
    gendate date -- 
    ,serialnumber varchar2(4000) -- 
    ,sequenceid varchar2(4000) -- 
    ,subconam varchar2(4000) -- 
    ,regcapcur varchar2(4000) -- 
    ,creditcode varchar2(4000) -- 
    ,fundedratio varchar2(4000) -- 
    ,invtypecode varchar2(4000) -- 
    ,condate varchar2(4000) -- 
    ,shaname varchar2(4000) -- 
    ,currencycode varchar2(4000) -- 
    ,invtype varchar2(4000) -- 
    ,ent_info_shareholder varchar2(4000) -- 
    ,conform varchar2(4000) -- 
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
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder is '股东及出资信息';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.gendate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.serialnumber is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.sequenceid is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.subconam is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.regcapcur is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.creditcode is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.fundedratio is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.invtypecode is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.condate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.shaname is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.currencycode is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.invtype is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.ent_info_shareholder is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.conform is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_shareholder.etl_timestamp is 'ETL处理时间戳';
