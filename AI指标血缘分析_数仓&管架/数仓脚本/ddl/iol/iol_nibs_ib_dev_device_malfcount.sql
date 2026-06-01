/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_dev_device_malfcount
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_dev_device_malfcount
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_dev_device_malfcount purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_dev_device_malfcount(
    devicenum varchar2(30) -- 设备编号
    ,maindate date -- 日期-yyyymmdd
    ,typefalg varchar2(2) -- 0-正常，1-停止服务，2-部分服务，3-未知，4-P通讯故障，5-维护，6-关机，7-停用
    ,branchnum varchar2(30) -- 机构号
    ,opensalf varchar2(10) -- 开机率
    ,malfsalf varchar2(10) -- 故障率
    ,note1 varchar2(100) -- 备用1
    ,note2 varchar2(100) -- 备用2
    ,note3 varchar2(100) -- 备用3
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
grant select on ${iol_schema}.nibs_ib_dev_device_malfcount to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_dev_device_malfcount to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_dev_device_malfcount to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_dev_device_malfcount to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_dev_device_malfcount is '设备开机故障信息';
comment on column ${iol_schema}.nibs_ib_dev_device_malfcount.devicenum is '设备编号';
comment on column ${iol_schema}.nibs_ib_dev_device_malfcount.maindate is '日期-yyyymmdd';
comment on column ${iol_schema}.nibs_ib_dev_device_malfcount.typefalg is '0-正常，1-停止服务，2-部分服务，3-未知，4-P通讯故障，5-维护，6-关机，7-停用';
comment on column ${iol_schema}.nibs_ib_dev_device_malfcount.branchnum is '机构号';
comment on column ${iol_schema}.nibs_ib_dev_device_malfcount.opensalf is '开机率';
comment on column ${iol_schema}.nibs_ib_dev_device_malfcount.malfsalf is '故障率';
comment on column ${iol_schema}.nibs_ib_dev_device_malfcount.note1 is '备用1';
comment on column ${iol_schema}.nibs_ib_dev_device_malfcount.note2 is '备用2';
comment on column ${iol_schema}.nibs_ib_dev_device_malfcount.note3 is '备用3';
comment on column ${iol_schema}.nibs_ib_dev_device_malfcount.start_dt is '开始时间';
comment on column ${iol_schema}.nibs_ib_dev_device_malfcount.end_dt is '结束时间';
comment on column ${iol_schema}.nibs_ib_dev_device_malfcount.id_mark is '增删标志';
comment on column ${iol_schema}.nibs_ib_dev_device_malfcount.etl_timestamp is 'ETL处理时间戳';
