/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_fkd_vehic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_fkd_vehic_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_fkd_vehic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_fkd_vehic_info(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,vehic_list_id varchar2(60) -- 车辆列表编号
    ,bus_flow_num varchar2(60) -- 业务流水号
    ,vehic_type_cd varchar2(100) -- 车辆类型代码
    ,expect_first_pay_amt number(30,2) -- 预计首付金额
    ,vehic_model varchar2(60) -- 车辆型号
    ,vehic_price number(30,2) -- 车辆价格
    ,seller_name varchar2(500) -- 经销商名称
    ,seller_cert_no varchar2(250) -- 经销商证件号码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_fkd_vehic_info to ${icl_schema};
grant select on ${iml_schema}.ast_fkd_vehic_info to ${idl_schema};
grant select on ${iml_schema}.ast_fkd_vehic_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_fkd_vehic_info is '房快贷车辆信息';
comment on column ${iml_schema}.ast_fkd_vehic_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_fkd_vehic_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_fkd_vehic_info.vehic_list_id is '车辆列表编号';
comment on column ${iml_schema}.ast_fkd_vehic_info.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.ast_fkd_vehic_info.vehic_type_cd is '车辆类型代码';
comment on column ${iml_schema}.ast_fkd_vehic_info.expect_first_pay_amt is '预计首付金额';
comment on column ${iml_schema}.ast_fkd_vehic_info.vehic_model is '车辆型号';
comment on column ${iml_schema}.ast_fkd_vehic_info.vehic_price is '车辆价格';
comment on column ${iml_schema}.ast_fkd_vehic_info.seller_name is '经销商名称';
comment on column ${iml_schema}.ast_fkd_vehic_info.seller_cert_no is '经销商证件号码';
comment on column ${iml_schema}.ast_fkd_vehic_info.start_dt is '开始时间';
comment on column ${iml_schema}.ast_fkd_vehic_info.end_dt is '结束时间';
comment on column ${iml_schema}.ast_fkd_vehic_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_fkd_vehic_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_fkd_vehic_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_fkd_vehic_info.etl_timestamp is 'ETL处理时间戳';
