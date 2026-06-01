/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fkd_car_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fkd_car_list
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fkd_car_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_car_list(
    serialno varchar2(32) -- 主键
    ,carmodel varchar2(50) -- 车辆型号
    ,cartype varchar2(2) -- 车辆类型
    ,prefirstpayamt number(24,2) -- 预计首付金额
    ,dealername varchar2(100) -- 经销商名称
    ,dealercertno varchar2(100) -- 经销商证件号
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,carprice number(17,2) -- 车辆价格
    ,relativeserialno varchar2(33) -- 业务流水号
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
grant select on ${iol_schema}.icms_fkd_car_list to ${iml_schema};
grant select on ${iol_schema}.icms_fkd_car_list to ${icl_schema};
grant select on ${iol_schema}.icms_fkd_car_list to ${idl_schema};
grant select on ${iol_schema}.icms_fkd_car_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fkd_car_list is '房快贷车辆列表';
comment on column ${iol_schema}.icms_fkd_car_list.serialno is '主键';
comment on column ${iol_schema}.icms_fkd_car_list.carmodel is '车辆型号';
comment on column ${iol_schema}.icms_fkd_car_list.cartype is '车辆类型';
comment on column ${iol_schema}.icms_fkd_car_list.prefirstpayamt is '预计首付金额';
comment on column ${iol_schema}.icms_fkd_car_list.dealername is '经销商名称';
comment on column ${iol_schema}.icms_fkd_car_list.dealercertno is '经销商证件号';
comment on column ${iol_schema}.icms_fkd_car_list.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_fkd_car_list.carprice is '车辆价格';
comment on column ${iol_schema}.icms_fkd_car_list.relativeserialno is '业务流水号';
comment on column ${iol_schema}.icms_fkd_car_list.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fkd_car_list.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fkd_car_list.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fkd_car_list.etl_timestamp is 'ETL处理时间戳';
