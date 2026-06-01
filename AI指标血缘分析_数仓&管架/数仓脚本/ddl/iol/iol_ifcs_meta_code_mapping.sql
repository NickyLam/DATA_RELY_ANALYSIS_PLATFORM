/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_meta_code_mapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_meta_code_mapping
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_meta_code_mapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_meta_code_mapping(
    meta_tab varchar2(384) -- 元数据表名
    ,meta_col varchar2(384) -- 元数据字段
    ,meta_code varchar2(30) -- 元数据代码
    ,code_val varchar2(768) -- 码值注解
    ,remark varchar2(4000) -- 备注
    ,data_std_code_val varchar2(30) -- 数据标准码值
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifcs_meta_code_mapping to ${iml_schema};
grant select on ${iol_schema}.ifcs_meta_code_mapping to ${icl_schema};
grant select on ${iol_schema}.ifcs_meta_code_mapping to ${idl_schema};
grant select on ${iol_schema}.ifcs_meta_code_mapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_meta_code_mapping is '元数据码值映射表';
comment on column ${iol_schema}.ifcs_meta_code_mapping.meta_tab is '元数据表名';
comment on column ${iol_schema}.ifcs_meta_code_mapping.meta_col is '元数据字段';
comment on column ${iol_schema}.ifcs_meta_code_mapping.meta_code is '元数据代码';
comment on column ${iol_schema}.ifcs_meta_code_mapping.code_val is '码值注解';
comment on column ${iol_schema}.ifcs_meta_code_mapping.remark is '备注';
comment on column ${iol_schema}.ifcs_meta_code_mapping.data_std_code_val is '数据标准码值';
comment on column ${iol_schema}.ifcs_meta_code_mapping.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_meta_code_mapping.etl_timestamp is 'ETL处理时间戳';
