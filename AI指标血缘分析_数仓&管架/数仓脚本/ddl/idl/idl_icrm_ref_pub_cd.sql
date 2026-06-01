/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ref_pub_cd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ref_pub_cd
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ref_pub_cd purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ref_pub_cd(
    etl_dt date -- 数据日期
    ,cd_id varchar2(60) -- 代码编号
    ,cd_tab_en_name varchar2(60) -- 代码表英文名称
    ,cd_tab_cn_descb varchar2(250) -- 代码表中文描述
    ,cd_val varchar2(30) -- 代码值
    ,cd_descb varchar2(1000) -- 代码描述
    ,data_std_flg varchar2(10) -- 数据标准标志
    ,quote_data_std varchar2(10) -- 引用数据标准
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
grant select on ${idl_schema}.icrm_ref_pub_cd to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ref_pub_cd is '公共代码表';
comment on column ${idl_schema}.icrm_ref_pub_cd.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ref_pub_cd.cd_id is '代码编号';
comment on column ${idl_schema}.icrm_ref_pub_cd.cd_tab_en_name is '代码表英文名称';
comment on column ${idl_schema}.icrm_ref_pub_cd.cd_tab_cn_descb is '代码表中文描述';
comment on column ${idl_schema}.icrm_ref_pub_cd.cd_val is '代码值';
comment on column ${idl_schema}.icrm_ref_pub_cd.cd_descb is '代码描述';
comment on column ${idl_schema}.icrm_ref_pub_cd.data_std_flg is '数据标准标志';
comment on column ${idl_schema}.icrm_ref_pub_cd.quote_data_std is '引用数据标准';
comment on column ${idl_schema}.icrm_ref_pub_cd.remark is '备注';
comment on column ${idl_schema}.icrm_ref_pub_cd.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_ref_pub_cd.etl_timestamp is '数据处理时间';
