/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_actual_control_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_actual_control_result
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_actual_control_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_actual_control_result(
    gendate date -- 
    ,serialnumber varchar2(4000) -- 
    ,sequenceid varchar2(4000) -- 
    ,regno varchar2(4000) -- 
    ,path_links varchar2(4000) -- 
    ,creditcode varchar2(4000) -- 
    ,distinguish varchar2(4000) -- 
    ,entid varchar2(4000) -- 
    ,controller_name varchar2(4000) -- 
    ,path_nodes varchar2(4000) -- 
    ,layer varchar2(4000) -- 
    ,result varchar2(4000) -- 
    ,controller_type varchar2(4000) -- 
    ,final_cgzb varchar2(4000) -- 
    ,control_power varchar2(4000) -- 
    ,controller_id varchar2(4000) -- 
    ,entname varchar2(4000) -- 
    ,flat_path_links varchar2(4000) -- 
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
grant select on ${iol_schema}.uxds_f_shell_actual_control_result to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_actual_control_result to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_actual_control_result to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_actual_control_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_actual_control_result is '疑似控制人结果';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.gendate is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.serialnumber is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.sequenceid is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.regno is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.path_links is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.creditcode is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.distinguish is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.entid is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.controller_name is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.path_nodes is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.layer is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.result is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.controller_type is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.final_cgzb is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.control_power is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.controller_id is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.entname is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.flat_path_links is '';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_actual_control_result.etl_timestamp is 'ETL处理时间戳';
