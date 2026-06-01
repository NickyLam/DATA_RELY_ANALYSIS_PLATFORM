/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pcls_yxyd_sj_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pcls_yxyd_sj_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pcls_yxyd_sj_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pcls_yxyd_sj_info(
    etl_dt date
    ,rj_rule_big varchar2(4000)
    ,rj_rule varchar2(4000)
    ,t_1_cnt int
    ,t_2_cnt int
    ,t_3_cnt int
    ,t_4_cnt int
    ,t_5_cnt int
    ,t_6_cnt int
    ,t_7_cnt int
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pcls_yxyd_sj_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pcls_yxyd_sj_info is '好易贷自营首拒表';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sj_info.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sj_info.rj_rule_big is '首拒原因（大类）';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sj_info.rj_rule is '首拒原因';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sj_info.t_1_cnt is 'T-1申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sj_info.t_2_cnt is 'T-2申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sj_info.t_3_cnt is 'T-3申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sj_info.t_4_cnt is 'T-4申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sj_info.t_5_cnt is 'T-5申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sj_info.t_6_cnt is 'T-6申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_sj_info.t_7_cnt is 'T-7申请笔数';
