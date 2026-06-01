/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_partner_equipment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_partner_equipment
whenever sqlerror continue none;
drop table ${iol_schema}.icms_partner_equipment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_partner_equipment(
    serialno varchar2(64) -- 流水号
    ,manufacturename varchar2(160) -- 设备制造商名称
    ,menudate date -- 出产日期
    ,cooperatemode varchar2(36) -- 合作模式合作模式(代码：1-经销商模式2-生产商模式3-经销商模式+生产商模式)
    ,corporgid varchar2(64) -- 法人机构编号
    ,inputorgid varchar2(64) -- 登记机构
    ,updateorgid varchar2(64) -- 更新机构
    ,equipmodel varchar2(64) -- 设备型号
    ,equipdesc varchar2(1000) -- 设备描述
    ,equiptype varchar2(36) -- 设备类型
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,updateuserid varchar2(64) -- 更新人
    ,manucountry varchar2(160) -- 出产国
    ,equipmentname varchar2(160) -- 设备名称
    ,inputuserid varchar2(64) -- 登记人
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
grant select on ${iol_schema}.icms_partner_equipment to ${iml_schema};
grant select on ${iol_schema}.icms_partner_equipment to ${icl_schema};
grant select on ${iol_schema}.icms_partner_equipment to ${idl_schema};
grant select on ${iol_schema}.icms_partner_equipment to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_partner_equipment is '设备信息设备信息';
comment on column ${iol_schema}.icms_partner_equipment.serialno is '流水号';
comment on column ${iol_schema}.icms_partner_equipment.manufacturename is '设备制造商名称';
comment on column ${iol_schema}.icms_partner_equipment.menudate is '出产日期';
comment on column ${iol_schema}.icms_partner_equipment.cooperatemode is '合作模式合作模式(代码：1-经销商模式2-生产商模式3-经销商模式+生产商模式)';
comment on column ${iol_schema}.icms_partner_equipment.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_partner_equipment.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_partner_equipment.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_partner_equipment.equipmodel is '设备型号';
comment on column ${iol_schema}.icms_partner_equipment.equipdesc is '设备描述';
comment on column ${iol_schema}.icms_partner_equipment.equiptype is '设备类型';
comment on column ${iol_schema}.icms_partner_equipment.inputdate is '登记日期';
comment on column ${iol_schema}.icms_partner_equipment.updatedate is '更新日期';
comment on column ${iol_schema}.icms_partner_equipment.updateuserid is '更新人';
comment on column ${iol_schema}.icms_partner_equipment.manucountry is '出产国';
comment on column ${iol_schema}.icms_partner_equipment.equipmentname is '设备名称';
comment on column ${iol_schema}.icms_partner_equipment.inputuserid is '登记人';
comment on column ${iol_schema}.icms_partner_equipment.start_dt is '开始时间';
comment on column ${iol_schema}.icms_partner_equipment.end_dt is '结束时间';
comment on column ${iol_schema}.icms_partner_equipment.id_mark is '增删标志';
comment on column ${iol_schema}.icms_partner_equipment.etl_timestamp is 'ETL处理时间戳';
