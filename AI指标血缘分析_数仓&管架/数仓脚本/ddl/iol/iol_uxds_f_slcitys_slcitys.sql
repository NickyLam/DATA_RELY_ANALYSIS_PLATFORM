/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_slcitys_slcitys
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_slcitys_slcitys
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_slcitys_slcitys purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_slcitys_slcitys(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,slcitys varchar2(4000) -- 关联标签
    ,id varchar2(4000) -- 编码ID
    ,name varchar2(4000) -- 显示名称
    ,pid varchar2(4000) -- 父级名称
    ,gbcode varchar2(4000) -- 国标码
    ,type varchar2(4000) -- 类型
    ,genmonth varchar2(4000) -- 
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
grant select on ${iol_schema}.uxds_f_slcitys_slcitys to ${iml_schema};
grant select on ${iol_schema}.uxds_f_slcitys_slcitys to ${icl_schema};
grant select on ${iol_schema}.uxds_f_slcitys_slcitys to ${idl_schema};
grant select on ${iol_schema}.uxds_f_slcitys_slcitys to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_slcitys_slcitys is 'slCitys_slCitys';
comment on column ${iol_schema}.uxds_f_slcitys_slcitys.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_slcitys_slcitys.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_slcitys_slcitys.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_slcitys_slcitys.slcitys is '关联标签';
comment on column ${iol_schema}.uxds_f_slcitys_slcitys.id is '编码ID';
comment on column ${iol_schema}.uxds_f_slcitys_slcitys.name is '显示名称';
comment on column ${iol_schema}.uxds_f_slcitys_slcitys.pid is '父级名称';
comment on column ${iol_schema}.uxds_f_slcitys_slcitys.gbcode is '国标码';
comment on column ${iol_schema}.uxds_f_slcitys_slcitys.type is '类型';
comment on column ${iol_schema}.uxds_f_slcitys_slcitys.genmonth is '';
comment on column ${iol_schema}.uxds_f_slcitys_slcitys.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_slcitys_slcitys.etl_timestamp is 'ETL处理时间戳';
