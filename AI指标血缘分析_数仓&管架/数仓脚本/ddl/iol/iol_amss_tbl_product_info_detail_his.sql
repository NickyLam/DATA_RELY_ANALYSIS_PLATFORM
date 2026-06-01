/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_tbl_product_info_detail_his
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_tbl_product_info_detail_his
whenever sqlerror continue none;
drop table ${iol_schema}.amss_tbl_product_info_detail_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_tbl_product_info_detail_his(
    id varchar2(64) -- 
    ,product_no varchar2(100) -- 
    ,product_nm varchar2(255) -- 
    ,product_brand varchar2(255) -- 
    ,supplier_nm varchar2(255) -- 
    ,product_type varchar2(255) -- 
    ,product_sort varchar2(255) -- 
    ,product_serial_no varchar2(200) -- 
    ,product_quality varchar2(200) -- 
    ,percent_gold varchar2(255) -- 
    ,percent_silver varchar2(255) -- 
    ,product_material varchar2(255) -- 
    ,product_technology varchar2(255) -- 
    ,weight_unit varchar2(20) -- 
    ,weight varchar2(60) -- 
    ,product_size varchar2(100) -- 
    ,product_unit_price varchar2(14) -- 
    ,product_num varchar2(16) -- 
    ,product_charge varchar2(16) -- 
    ,sale_limited_num varchar2(10) -- 
    ,product_status varchar2(125) -- 
    ,onsale_time varchar2(30) -- 
    ,offshelves_time varchar2(30) -- 
    ,create_time varchar2(20) -- 
    ,update_time varchar2(20) -- 
    ,adddata1 varchar2(100) -- 
    ,adddata2 varchar2(100) -- 
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
grant select on ${iol_schema}.amss_tbl_product_info_detail_his to ${iml_schema};
grant select on ${iol_schema}.amss_tbl_product_info_detail_his to ${icl_schema};
grant select on ${iol_schema}.amss_tbl_product_info_detail_his to ${idl_schema};
grant select on ${iol_schema}.amss_tbl_product_info_detail_his to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_tbl_product_info_detail_his is '贵金属产品历史表';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.id is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_no is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_nm is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_brand is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.supplier_nm is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_type is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_sort is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_serial_no is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_quality is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.percent_gold is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.percent_silver is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_material is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_technology is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.weight_unit is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.weight is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_size is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_unit_price is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_num is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_charge is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.sale_limited_num is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.product_status is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.onsale_time is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.offshelves_time is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.create_time is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.update_time is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.adddata1 is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.adddata2 is '';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.start_dt is '开始时间';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.end_dt is '结束时间';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.id_mark is '增删标志';
comment on column ${iol_schema}.amss_tbl_product_info_detail_his.etl_timestamp is 'ETL处理时间戳';
