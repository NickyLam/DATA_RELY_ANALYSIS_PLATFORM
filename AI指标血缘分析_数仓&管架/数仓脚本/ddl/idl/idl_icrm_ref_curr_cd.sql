/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ref_curr_cd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ref_curr_cd
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ref_curr_cd purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ref_curr_cd(
    etl_dt date -- 数据日期
    ,cd_val varchar2(10) -- 代码值
    ,cd_descb varchar2(1000) -- 代码描述
    ,data_std_flg varchar2(10) -- 数据标准标志
    ,quote_data_std varchar2(60) -- 引用数据标准
    ,remark varchar2(100) -- 备注
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_ref_curr_cd to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ref_curr_cd is '币种代码表';
comment on column ${idl_schema}.icrm_ref_curr_cd.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ref_curr_cd.cd_val is '代码值';
comment on column ${idl_schema}.icrm_ref_curr_cd.cd_descb is '代码描述';
comment on column ${idl_schema}.icrm_ref_curr_cd.data_std_flg is '数据标准标志';
comment on column ${idl_schema}.icrm_ref_curr_cd.quote_data_std is '引用数据标准';
comment on column ${idl_schema}.icrm_ref_curr_cd.remark is '备注';
comment on column ${idl_schema}.icrm_ref_curr_cd.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_ref_curr_cd.etl_timestamp is '数据处理时间';
