/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_vw_pty_indv_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_vw_pty_indv_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_vw_pty_indv_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_vw_pty_indv_info(
    acc_id varchar2(30) -- 
    ,acc_name varchar2(450) -- 
    ,acc_idtype varchar2(30) -- 
    ,acc_idno varchar2(383) -- 
    ,industry varchar2(30) -- 
    ,acc_type varchar2(90) -- 
    ,resident_nature varchar2(2) -- 
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
grant select on ${iol_schema}.eifs_vw_pty_indv_info to ${iml_schema};
grant select on ${iol_schema}.eifs_vw_pty_indv_info to ${icl_schema};
grant select on ${iol_schema}.eifs_vw_pty_indv_info to ${idl_schema};
grant select on ${iol_schema}.eifs_vw_pty_indv_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_vw_pty_indv_info is '';
comment on column ${iol_schema}.eifs_vw_pty_indv_info.acc_id is '';
comment on column ${iol_schema}.eifs_vw_pty_indv_info.acc_name is '';
comment on column ${iol_schema}.eifs_vw_pty_indv_info.acc_idtype is '';
comment on column ${iol_schema}.eifs_vw_pty_indv_info.acc_idno is '';
comment on column ${iol_schema}.eifs_vw_pty_indv_info.industry is '';
comment on column ${iol_schema}.eifs_vw_pty_indv_info.acc_type is '';
comment on column ${iol_schema}.eifs_vw_pty_indv_info.resident_nature is '';
comment on column ${iol_schema}.eifs_vw_pty_indv_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_vw_pty_indv_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_vw_pty_indv_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_vw_pty_indv_info.etl_timestamp is 'ETL处理时间戳';
