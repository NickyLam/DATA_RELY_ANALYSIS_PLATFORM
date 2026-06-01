/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbinsurefront
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbinsurefront
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbinsurefront purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsurefront(
    trans_code varchar2(9) -- 
    ,ta_code varchar2(14) -- 
    ,prd_code varchar2(30) -- 
    ,title_name varchar2(30) -- 
    ,field_name varchar2(30) -- 
    ,input_type varchar2(2) -- 
    ,attr_type varchar2(2) -- 
    ,spec_type varchar2(2) -- 
    ,show_value varchar2(2) -- 
    ,fix_value varchar2(15) -- 
    ,fix_valuename varchar2(75) -- 
    ,required varchar2(2) -- 
    ,hs_key varchar2(30) -- 
    ,order_no varchar2(8) -- 
    ,belongtype varchar2(2) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbinsurefront to ${iml_schema};
grant select on ${iol_schema}.ifms_tbinsurefront to ${icl_schema};
grant select on ${iol_schema}.ifms_tbinsurefront to ${idl_schema};
grant select on ${iol_schema}.ifms_tbinsurefront to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbinsurefront is '保险产品属性表';
comment on column ${iol_schema}.ifms_tbinsurefront.trans_code is '';
comment on column ${iol_schema}.ifms_tbinsurefront.ta_code is '';
comment on column ${iol_schema}.ifms_tbinsurefront.prd_code is '';
comment on column ${iol_schema}.ifms_tbinsurefront.title_name is '';
comment on column ${iol_schema}.ifms_tbinsurefront.field_name is '';
comment on column ${iol_schema}.ifms_tbinsurefront.input_type is '';
comment on column ${iol_schema}.ifms_tbinsurefront.attr_type is '';
comment on column ${iol_schema}.ifms_tbinsurefront.spec_type is '';
comment on column ${iol_schema}.ifms_tbinsurefront.show_value is '';
comment on column ${iol_schema}.ifms_tbinsurefront.fix_value is '';
comment on column ${iol_schema}.ifms_tbinsurefront.fix_valuename is '';
comment on column ${iol_schema}.ifms_tbinsurefront.required is '';
comment on column ${iol_schema}.ifms_tbinsurefront.hs_key is '';
comment on column ${iol_schema}.ifms_tbinsurefront.order_no is '';
comment on column ${iol_schema}.ifms_tbinsurefront.belongtype is '';
comment on column ${iol_schema}.ifms_tbinsurefront.reserve1 is '';
comment on column ${iol_schema}.ifms_tbinsurefront.reserve2 is '';
comment on column ${iol_schema}.ifms_tbinsurefront.reserve3 is '';
comment on column ${iol_schema}.ifms_tbinsurefront.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbinsurefront.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbinsurefront.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbinsurefront.etl_timestamp is 'ETL处理时间戳';
