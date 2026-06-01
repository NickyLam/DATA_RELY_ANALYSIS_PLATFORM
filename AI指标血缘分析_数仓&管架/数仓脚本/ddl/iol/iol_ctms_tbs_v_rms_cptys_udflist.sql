/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_rms_cptys_udflist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist(
    entyid varchar2(33) -- 交易对手编号
    ,udf_code varchar2(48) -- 自定义字段编号
    ,udf_desc varchar2(96) -- 自定义字段名称
    ,udf_type varchar2(2) -- 自定义字段类型
    ,udf_value varchar2(384) -- 自定义字段值
    ,udf_valuedesc varchar2(384) -- 自定义字段枚举值名称
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ctms_tbs_v_rms_cptys_udflist to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_rms_cptys_udflist to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_rms_cptys_udflist to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_rms_cptys_udflist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist is '交易对手自定义字段值视图';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys_udflist.entyid is '交易对手编号';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys_udflist.udf_code is '自定义字段编号';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys_udflist.udf_desc is '自定义字段名称';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys_udflist.udf_type is '自定义字段类型';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys_udflist.udf_value is '自定义字段值';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys_udflist.udf_valuedesc is '自定义字段枚举值名称';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys_udflist.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys_udflist.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys_udflist.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys_udflist.etl_timestamp is 'ETL处理时间戳';
