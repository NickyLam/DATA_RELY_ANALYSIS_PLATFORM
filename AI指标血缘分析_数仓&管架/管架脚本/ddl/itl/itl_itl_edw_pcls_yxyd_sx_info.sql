/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pcls_yxyd_sx_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pcls_yxyd_sx_info
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pcls_yxyd_sx_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pcls_yxyd_sx_info(
    appl_dt number(22) -- 申请日期
    ,appl_cnt number(22) -- 申请通过笔数
    ,final_pass_cnt number(22) -- 申请通过笔数
    ,final_pass_percent number(38,6) -- 授信通过率（笔数）
    ,final_pass_credit number(22) -- 终审通过笔数
    ,final_pass_repay number(38,6) -- 终审通过率
    ,appl_pass_cnt number(22) -- 额度
    ,appl_pass_percent number(38,6) -- 定价
    ,tele_pass_cnt number(22) -- 电核通过笔数
    ,tele_pass_percent number(38,6) -- 电核通过率
    ,face_pass_cnt number(22) -- 面签通过笔数
    ,face_pass_percent number(38,6) -- 面签通过率
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_pcls_yxyd_sx_info to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pcls_yxyd_sx_info is '好易贷自营授信表';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.appl_dt is '申请日期';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.appl_cnt is '申请通过笔数';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.final_pass_cnt is '申请通过笔数';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.final_pass_percent is '授信通过率（笔数）';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.final_pass_credit is '终审通过笔数';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.final_pass_repay is '终审通过率';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.appl_pass_cnt is '额度';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.appl_pass_percent is '定价';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.tele_pass_cnt is '电核通过笔数';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.tele_pass_percent is '电核通过率';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.face_pass_cnt is '面签通过笔数';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.face_pass_percent is '面签通过率';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_sx_info.etl_timestamp is 'ETL处理时间戳';
