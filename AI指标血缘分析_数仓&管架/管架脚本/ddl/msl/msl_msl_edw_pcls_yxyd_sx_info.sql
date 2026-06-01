/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pcls_yxyd_sx_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pcls_yxyd_sx_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pcls_yxyd_sx_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pcls_yxyd_sx_info(
    etl_dt date
    ,appl_dt number(22)
    ,appl_cnt number(22)
    ,final_pass_cnt number(22)
    ,final_pass_percent number(38,6)
    ,final_pass_credit number(22)
    ,final_pass_repay number(38,6)
    ,appl_pass_cnt number(22)
    ,appl_pass_percent number(38,6)
    ,tele_pass_cnt number(22)
    ,tele_pass_percent number(38,6)
    ,face_pass_cnt number(22)
    ,face_pass_percent number(38,6)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pcls_yxyd_sx_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pcls_yxyd_sx_info is '好易贷自营授信表';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_info.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_info.appl_dt is '申请日期';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_info.appl_cnt is '申请通过笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_info.final_pass_cnt is '申请通过笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_info.final_pass_percent is '授信通过率（笔数）';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_info.final_pass_credit is '终审通过笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_info.final_pass_repay is '终审通过率';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_info.appl_pass_cnt is '额度';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_info.appl_pass_percent is '定价';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_info.tele_pass_cnt is '电核通过笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_info.tele_pass_percent is '电核通过率';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_info.face_pass_cnt is '面签通过笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_info.face_pass_percent is '面签通过率';
