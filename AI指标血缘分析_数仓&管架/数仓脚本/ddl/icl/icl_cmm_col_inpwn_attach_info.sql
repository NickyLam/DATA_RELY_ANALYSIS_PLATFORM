/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_col_inpwn_attach_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_col_inpwn_attach_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_col_inpwn_attach_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_col_inpwn_attach_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,col_id varchar2(60) -- 押品编号
    ,col_name varchar2(300) -- 押品名称
    ,wat_id varchar2(300) -- 权证编号
    ,inpwn_qtty number(30,2) -- 质押数量
    ,col_cost number(30,2) -- 押品原值
    ,other_comnt varchar2(600) -- 其他说明
    ,spcl_info_type_cd varchar2(30) -- 专项信息类型代码
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_col_inpwn_attach_info to ${idl_schema};
grant select on ${icl_schema}.cmm_col_inpwn_attach_info to ${iel_schema};
grant select on ${icl_schema}.cmm_col_inpwn_attach_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_col_inpwn_attach_info is '押品质押补充信息';
comment on column ${icl_schema}.cmm_col_inpwn_attach_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_col_inpwn_attach_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_col_inpwn_attach_info.col_id is '押品编号';
comment on column ${icl_schema}.cmm_col_inpwn_attach_info.col_name is '押品名称';
comment on column ${icl_schema}.cmm_col_inpwn_attach_info.wat_id is '权证编号';
comment on column ${icl_schema}.cmm_col_inpwn_attach_info.inpwn_qtty is '质押数量';
comment on column ${icl_schema}.cmm_col_inpwn_attach_info.col_cost is '押品原值';
comment on column ${icl_schema}.cmm_col_inpwn_attach_info.other_comnt is '其他说明';
comment on column ${icl_schema}.cmm_col_inpwn_attach_info.spcl_info_type_cd is '专项信息类型代码';
comment on column ${icl_schema}.cmm_col_inpwn_attach_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_col_inpwn_attach_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_col_inpwn_attach_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_col_inpwn_attach_info.etl_timestamp is 'ETL处理时间戳';
