/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol atms_dev_catalog_table
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.atms_dev_catalog_table
whenever sqlerror continue none;
drop table ${iol_schema}.atms_dev_catalog_table purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_dev_catalog_table(
    no varchar2(5) -- 编号 10001 自动存取款机(crs) 10002 自动存款机(cdm) 10003 自动取款机(atm) 10004 bsm/查询机 10005   大额机/智能终端/现钞机 10006   回单机 10007   填单机 10008   发卡机 10009   叫号机 10010   广告屏
    ,name varchar2(30) -- 设备类型
    ,enname varchar2(30) -- 描述
    ,monitor_type varchar2(2) -- 监控类型[1:传统现金自助设备][2:发卡机][3:非现金自助设备] [4:多媒体渠道][5:新型现金自助设备][6:回单机][7:填单机][8:叫号机] [其它 不需要监控的设备]
    ,channel_type varchar2(2) -- 渠道类型[1:现金渠道][2:回单渠道][4:stm渠道]
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
grant select on ${iol_schema}.atms_dev_catalog_table to ${iml_schema};
grant select on ${iol_schema}.atms_dev_catalog_table to ${icl_schema};
grant select on ${iol_schema}.atms_dev_catalog_table to ${idl_schema};
grant select on ${iol_schema}.atms_dev_catalog_table to ${iel_schema};

-- comment
comment on table ${iol_schema}.atms_dev_catalog_table is '';
comment on column ${iol_schema}.atms_dev_catalog_table.no is '编号 10001 自动存取款机(crs) 10002 自动存款机(cdm) 10003 自动取款机(atm) 10004 bsm/查询机 10005   大额机/智能终端/现钞机 10006   回单机 10007   填单机 10008   发卡机 10009   叫号机 10010   广告屏';
comment on column ${iol_schema}.atms_dev_catalog_table.name is '设备类型';
comment on column ${iol_schema}.atms_dev_catalog_table.enname is '描述';
comment on column ${iol_schema}.atms_dev_catalog_table.monitor_type is '监控类型[1:传统现金自助设备][2:发卡机][3:非现金自助设备] [4:多媒体渠道][5:新型现金自助设备][6:回单机][7:填单机][8:叫号机] [其它 不需要监控的设备]';
comment on column ${iol_schema}.atms_dev_catalog_table.channel_type is '渠道类型[1:现金渠道][2:回单渠道][4:stm渠道]';
comment on column ${iol_schema}.atms_dev_catalog_table.start_dt is '开始时间';
comment on column ${iol_schema}.atms_dev_catalog_table.end_dt is '结束时间';
comment on column ${iol_schema}.atms_dev_catalog_table.id_mark is '增删标志';
comment on column ${iol_schema}.atms_dev_catalog_table.etl_timestamp is 'ETL处理时间戳';
