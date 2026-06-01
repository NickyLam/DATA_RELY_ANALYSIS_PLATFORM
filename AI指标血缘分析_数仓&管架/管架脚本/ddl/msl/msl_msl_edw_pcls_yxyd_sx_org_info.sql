/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pcls_yxyd_sx_org_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info(
    etl_dt date
    ,bank_nm varchar2(4000)
    ,appl_cnt number(20)
    ,monthcreated1 varchar2(4000)
    ,appl_pass_cnt number(20)
    ,appl_pass_percent number(38,6)
    ,final_pass_cnt number(22)
    ,final_pass_percent number(38,6)
    ,final_pass_credit number(22)
    ,final_pass_repay number(38,6)
    ,tele_pass_cnt number(22)
    ,tele_pass_percent number(38,6)
    ,face_pass_cnt number(22)
    ,face_pass_percent number(38,6)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info is '分行好易贷自营授信表';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.bank_nm is '分行名称';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.appl_cnt is '申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.monthcreated1 is '申请月';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.appl_pass_cnt is '申请通过笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.appl_pass_percent is '授信通过率（笔数）';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.final_pass_cnt is '终审通过笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.final_pass_percent is '终审通过率';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.final_pass_credit is '额度';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.final_pass_repay is '定价';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.tele_pass_cnt is '电核通过笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.tele_pass_percent is '电核通过率';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.face_pass_cnt is '面签通过笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sx_org_info.face_pass_percent is '面签通过率';
