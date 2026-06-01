/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_cty_rg_cd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_cty_rg_cd
whenever sqlerror continue none;
drop table ${iml_schema}.ref_cty_rg_cd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_cty_rg_cd(
    cd_val varchar2(10) -- 代码值
    ,cd_descb varchar2(100) -- 代码描述
	,valid_flg varchar2(10) --有效标志
	,invalid_dt date --失效日期
    ,data_std_flg varchar2(10) -- 数据标准标志
    ,quote_data_std varchar2(60) -- 引用数据标准
    ,remark varchar2(100) -- 备注
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
;

-- grant
grant select on ${iml_schema}.ref_cty_rg_cd to ${icl_schema};
grant select on ${iml_schema}.ref_cty_rg_cd to ${idl_schema};
grant select on ${iml_schema}.ref_cty_rg_cd to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_cty_rg_cd is '国家和地区代码表';
comment on column ${iml_schema}.ref_cty_rg_cd.cd_val is '代码值';
comment on column ${iml_schema}.ref_cty_rg_cd.cd_descb is '代码描述';
comment on column ${iml_schema}.ref_cty_rg_cd.valid_flg is '有效标志';
comment on column ${iml_schema}.ref_cty_rg_cd.invalid_dt is '失效日期';
comment on column ${iml_schema}.ref_cty_rg_cd.data_std_flg is '数据标准标志';
comment on column ${iml_schema}.ref_cty_rg_cd.quote_data_std is '引用数据标准';
comment on column ${iml_schema}.ref_cty_rg_cd.remark is '备注';
comment on column ${iml_schema}.ref_cty_rg_cd.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_cty_rg_cd.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_cty_rg_cd.job_cd is '任务编码';
comment on column ${iml_schema}.ref_cty_rg_cd.etl_timestamp is 'ETL处理时间戳';
