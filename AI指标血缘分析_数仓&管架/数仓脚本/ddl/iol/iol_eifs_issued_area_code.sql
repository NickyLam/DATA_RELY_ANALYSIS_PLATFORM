/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_issued_area_code
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_issued_area_code
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_issued_area_code purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_issued_area_code(
    area_code varchar2(6) -- 4位地区代码
    ,area_code2 varchar2(45) -- 6位地区代码
    ,state_province_geo_id varchar2(383) -- 省
    ,city varchar2(383) -- 市
    ,county varchar2(383) -- 县
    ,area_code3 varchar2(45) -- 人行地区代码
    ,address varchar2(383) -- 省||市||县（合并）
    ,last_updated_stamp timestamp -- 
    ,last_updated_tx_stamp timestamp -- 
    ,created_stamp timestamp -- 
    ,created_tx_stamp timestamp -- 
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
grant select on ${iol_schema}.eifs_issued_area_code to ${iml_schema};
grant select on ${iol_schema}.eifs_issued_area_code to ${icl_schema};
grant select on ${iol_schema}.eifs_issued_area_code to ${idl_schema};
grant select on ${iol_schema}.eifs_issued_area_code to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_issued_area_code is '发证机关所在地信息表';
comment on column ${iol_schema}.eifs_issued_area_code.area_code is '4位地区代码';
comment on column ${iol_schema}.eifs_issued_area_code.area_code2 is '6位地区代码';
comment on column ${iol_schema}.eifs_issued_area_code.state_province_geo_id is '省';
comment on column ${iol_schema}.eifs_issued_area_code.city is '市';
comment on column ${iol_schema}.eifs_issued_area_code.county is '县';
comment on column ${iol_schema}.eifs_issued_area_code.area_code3 is '人行地区代码';
comment on column ${iol_schema}.eifs_issued_area_code.address is '省||市||县（合并）';
comment on column ${iol_schema}.eifs_issued_area_code.last_updated_stamp is '';
comment on column ${iol_schema}.eifs_issued_area_code.last_updated_tx_stamp is '';
comment on column ${iol_schema}.eifs_issued_area_code.created_stamp is '';
comment on column ${iol_schema}.eifs_issued_area_code.created_tx_stamp is '';
comment on column ${iol_schema}.eifs_issued_area_code.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_issued_area_code.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_issued_area_code.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_issued_area_code.etl_timestamp is 'ETL处理时间戳';
