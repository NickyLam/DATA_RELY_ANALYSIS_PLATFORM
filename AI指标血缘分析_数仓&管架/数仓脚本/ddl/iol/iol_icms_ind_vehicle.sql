/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_vehicle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_vehicle
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_vehicle purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_vehicle(
    serialno varchar2(64) -- 流水号
    ,inputdate date -- 登记日期
    ,mortgagestatus varchar2(8) -- 抵押情况抵押情况（代码：1-有抵押2-无抵押）
    ,remark varchar2(1000) -- 备注
    ,customerid varchar2(16) -- 客户编号
    ,vehicletype varchar2(160) -- 车辆品牌
    ,uptodate date -- 统计截止日期
    ,saledate date -- 卖出日期
    ,inputorgid varchar2(64) -- 登记单位
    ,updatedate date -- 更新日期
    ,mortgageamt number(24,6) -- 抵押金额
    ,updateorgid varchar2(64) -- 更新机构
    ,inputuserid varchar2(64) -- 登记人
    ,corporgid varchar2(64) -- 法人机构编号
    ,frameno varchar2(64) -- 车架号
    ,purchasedate date -- 买入日期
    ,mortgagetype varchar2(32) -- 抵押类型
    ,purchasesum number(24,6) -- 购买金额购买金额（单位：元）
    ,purchasestate varchar2(36) -- 付款情况付款情况（代码：1-已付清全款2-按揭中）
    ,updateuserid varchar2(64) -- 更新人
    ,migtflag varchar2(80) -- 
    ,vehiclestate varchar2(1000) -- 车辆概况
    ,mortgageenddate date -- 抵押结束日期
    ,engineno varchar2(64) -- 发动机号
    ,vehicleno varchar2(36) -- 车牌号
    ,mortgagestartdate date -- 抵押开始日期
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
grant select on ${iol_schema}.icms_ind_vehicle to ${iml_schema};
grant select on ${iol_schema}.icms_ind_vehicle to ${icl_schema};
grant select on ${iol_schema}.icms_ind_vehicle to ${idl_schema};
grant select on ${iol_schema}.icms_ind_vehicle to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_vehicle is '车辆资产车辆资产情况';
comment on column ${iol_schema}.icms_ind_vehicle.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_vehicle.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ind_vehicle.mortgagestatus is '抵押情况抵押情况（代码：1-有抵押2-无抵押）';
comment on column ${iol_schema}.icms_ind_vehicle.remark is '备注';
comment on column ${iol_schema}.icms_ind_vehicle.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_vehicle.vehicletype is '车辆品牌';
comment on column ${iol_schema}.icms_ind_vehicle.uptodate is '统计截止日期';
comment on column ${iol_schema}.icms_ind_vehicle.saledate is '卖出日期';
comment on column ${iol_schema}.icms_ind_vehicle.inputorgid is '登记单位';
comment on column ${iol_schema}.icms_ind_vehicle.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_vehicle.mortgageamt is '抵押金额';
comment on column ${iol_schema}.icms_ind_vehicle.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_vehicle.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_vehicle.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_vehicle.frameno is '车架号';
comment on column ${iol_schema}.icms_ind_vehicle.purchasedate is '买入日期';
comment on column ${iol_schema}.icms_ind_vehicle.mortgagetype is '抵押类型';
comment on column ${iol_schema}.icms_ind_vehicle.purchasesum is '购买金额购买金额（单位：元）';
comment on column ${iol_schema}.icms_ind_vehicle.purchasestate is '付款情况付款情况（代码：1-已付清全款2-按揭中）';
comment on column ${iol_schema}.icms_ind_vehicle.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_vehicle.migtflag is '';
comment on column ${iol_schema}.icms_ind_vehicle.vehiclestate is '车辆概况';
comment on column ${iol_schema}.icms_ind_vehicle.mortgageenddate is '抵押结束日期';
comment on column ${iol_schema}.icms_ind_vehicle.engineno is '发动机号';
comment on column ${iol_schema}.icms_ind_vehicle.vehicleno is '车牌号';
comment on column ${iol_schema}.icms_ind_vehicle.mortgagestartdate is '抵押开始日期';
comment on column ${iol_schema}.icms_ind_vehicle.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_vehicle.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_vehicle.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_vehicle.etl_timestamp is 'ETL处理时间戳';
