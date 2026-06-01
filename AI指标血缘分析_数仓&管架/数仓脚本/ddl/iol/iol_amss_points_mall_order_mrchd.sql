/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_points_mall_order_mrchd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_points_mall_order_mrchd
whenever sqlerror continue none;
drop table ${iol_schema}.amss_points_mall_order_mrchd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_points_mall_order_mrchd(
    id varchar2(32) -- 
    ,serial_num varchar2(32) -- 
    ,provt_name varchar2(256) -- 
    ,mrchd_encd varchar2(32) -- 
    ,mrchd_name varchar2(256) -- 
    ,mrchd_qtty number(18,2) -- 
    ,mrchd_desc varchar2(128) -- 
    ,form_mechd_fee number(18,2) -- 
    ,physics_flag number(10,0) -- 
    ,create_time timestamp -- 
    ,update_time timestamp -- 
    ,create_emp varchar2(32) -- 
    ,update_emp varchar2(32) -- 
    ,cnsm_type varchar2(15) -- 
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
grant select on ${iol_schema}.amss_points_mall_order_mrchd to ${iml_schema};
grant select on ${iol_schema}.amss_points_mall_order_mrchd to ${icl_schema};
grant select on ${iol_schema}.amss_points_mall_order_mrchd to ${idl_schema};
grant select on ${iol_schema}.amss_points_mall_order_mrchd to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_points_mall_order_mrchd is '积分商城-交易商品信息';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.id is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.serial_num is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.provt_name is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.mrchd_encd is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.mrchd_name is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.mrchd_qtty is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.mrchd_desc is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.form_mechd_fee is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.physics_flag is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.create_time is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.update_time is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.create_emp is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.update_emp is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.cnsm_type is '';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.start_dt is '开始时间';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.end_dt is '结束时间';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.id_mark is '增删标志';
comment on column ${iol_schema}.amss_points_mall_order_mrchd.etl_timestamp is 'ETL处理时间戳';
