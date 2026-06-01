/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pcls_byte_sj_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pcls_byte_sj_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pcls_byte_sj_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pcls_byte_sj_info(
    etl_dt date
    ,reject_reason_big varchar2(4000)
    ,sx_reject_reason_tag varchar2(4000)
    ,reject_reason_small varchar2(4000)
    ,t_1_cnt number(20)
    ,t_2_cnt number(21)
    ,t_3_cnt number(22)
    ,t_4_cnt number(23)
    ,t_5_cnt number(24)
    ,t_6_cnt number(25)
    ,t_7_cnt number(26)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pcls_byte_sj_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pcls_byte_sj_info is '字节小微首拒表';
comment on column ${msl_schema}.msl_edw_pcls_byte_sj_info.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pcls_byte_sj_info.reject_reason_big is '首拒原因（大类）';
comment on column ${msl_schema}.msl_edw_pcls_byte_sj_info.sx_reject_reason_tag is '首拒原因（小类）';
comment on column ${msl_schema}.msl_edw_pcls_byte_sj_info.reject_reason_small is '首拒原因';
comment on column ${msl_schema}.msl_edw_pcls_byte_sj_info.t_1_cnt is 't-1申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_byte_sj_info.t_2_cnt is 't-2申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_byte_sj_info.t_3_cnt is 't-3申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_byte_sj_info.t_4_cnt is 't-4申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_byte_sj_info.t_5_cnt is 't-5申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_byte_sj_info.t_6_cnt is 't-6申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_byte_sj_info.t_7_cnt is 't-7申请笔数';
