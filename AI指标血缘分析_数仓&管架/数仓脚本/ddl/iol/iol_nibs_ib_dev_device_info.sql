/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_dev_device_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_dev_device_info
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_dev_device_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_dev_device_info(
    devicenum varchar2(32) -- 设备编号
    ,deviceid varchar2(60) -- 设备标识id
    ,devmodelid varchar2(60) -- 设备型号-关联
    ,devicetypenum varchar2(60) -- 设备类型编号
    ,devicesatus varchar2(1) -- 设备状态标识 0-待启用，1-正常
    ,deviceboxmsg varchar2(255) -- 管理员1手机号
    ,devicemodulemsg varchar2(255) -- 管理员2手机号
    ,existfalg varchar2(1) -- 在离行标识 1-在行，2-离行
    ,installtype varchar2(1) -- 安装方式 1-穿墙式，2-大堂式，3-壁挂式
    ,manufacturername varchar2(60) -- 设备厂商--型号关联
    ,ascrbranch varchar2(12) -- 所属机构
    ,virtualusernum varchar2(30) -- 虚拟柜员号
    ,equipscrnresolut varchar2(20) -- 设备分辨率
    ,adminuserone varchar2(12) -- 管理员1
    ,adminusertwo varchar2(12) -- 管理员2
    ,insustartdate varchar2(12) -- 维保开始日期-yyyy-MM-dd
    ,insuenddate varchar2(12) -- 维保结束日期-yyyy-MM-dd
    ,devicebuydate varchar2(12) -- 设备购买日期-yyyy-MM-dd
    ,devicestartdate varchar2(12) -- 设备启用日期-yyyy-MM-dd
    ,devicestopdate varchar2(12) -- 设备停止日期-yyyy-MM-dd
    ,deviceservicestarttime varchar2(10) -- 设备服务开始时间-HH:mm:ss
    ,deviceserviceendtime varchar2(10) -- 设备服务结束时间-HH:mm:ss
    ,shutdowntime varchar2(10) -- 定时关机时间-HH:mm:ss
    ,deviceip varchar2(30) -- 设备ip
    ,selfbank varchar2(1) -- 自助银行 1是 0否
    ,commstatus varchar2(1) -- 通讯状态-0:未知、1:正常 2:异常
    ,operstatus varchar2(1) -- 运行状态-0-正常，1-停止服务，2-部分服务，3-未知，4-P通讯故障，5-维护，6-关机，7-停用
    ,bankteller varchar2(32) -- ATM清机申请绑定柜员号
    ,managementmode varchar2(2) -- 管理模式|1非外包 2-外包
    ,installaddress varchar2(255) -- 安装地址
    ,encryptionmode varchar2(2) -- 加密方式 0-国密
    ,qjcom_id varchar2(4) -- 清机公司编号
    ,seq varchar2(4) -- 序号三位
    ,virtualtailboxid varchar2(30) -- 虚拟尾箱号，与虚拟柜员是绑定关系
    ,authcode varchar2(255) -- 中台装机码
    ,qjcomname varchar2(255) -- 清机公司名称
    ,asycnfalg varchar2(2) -- 中台同步标识 0-未同步 1-已经同步
    ,installcontel varchar2(30) -- 装机联系电话
    ,virtualusertailboxid varchar2(30) -- 虚拟柜员尾箱号
    ,serviceprovnum varchar2(60) -- 服务商编号
    ,vchboxflg varchar2(2) -- 凭证钱箱 0:否 1:是
    ,cshboxflg varchar2(2) -- 现金钱箱 0:否 1:是
    ,virtualteller varchar2(12) -- 实体柜员号
    ,devstate varchar2(2) -- 设备状态1-正常
    ,devicestate varchar2(1) -- 设备使用状态 : 0.领用、1：启用、2：停用、3：删除、9登记
    ,modifyuser varchar2(12) -- 最后修改用户
    ,modifyuserbrno varchar2(10) -- 最后维护人所属机构
    ,creatorbrno varchar2(10) -- 创建人所属机构
    ,modifdate varchar2(8) -- 最后修改日期
    ,modiftime varchar2(6) -- 最后修改日期
    ,creauser varchar2(12) -- 创建用户
    ,devactivationcode varchar2(40) -- 设备激活码
    ,devcreatetime varchar2(6) -- 创建时间
    ,creadate varchar2(8) -- 创建日期 : YYYYMMDD
    ,devuniqueid varchar2(100) -- 设备唯一标识，C端生成
    ,devicemac varchar2(30) -- 设备的mac地址
    ,imeicode varchar2(50) -- IEME编号
    ,backcode varchar2(50) -- 背夹序号
    ,keyname varchar2(50) -- 秘钥名称
    ,checkvalue varchar2(50) -- 校检值
    ,keyvalue varchar2(50) -- 秘钥
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
grant select on ${iol_schema}.nibs_ib_dev_device_info to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_dev_device_info to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_dev_device_info to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_dev_device_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_dev_device_info is '设备信息表';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devicenum is '设备编号';
comment on column ${iol_schema}.nibs_ib_dev_device_info.deviceid is '设备标识id';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devmodelid is '设备型号-关联';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devicetypenum is '设备类型编号';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devicesatus is '设备状态标识 0-待启用，1-正常';
comment on column ${iol_schema}.nibs_ib_dev_device_info.deviceboxmsg is '管理员1手机号';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devicemodulemsg is '管理员2手机号';
comment on column ${iol_schema}.nibs_ib_dev_device_info.existfalg is '在离行标识 1-在行，2-离行';
comment on column ${iol_schema}.nibs_ib_dev_device_info.installtype is '安装方式 1-穿墙式，2-大堂式，3-壁挂式';
comment on column ${iol_schema}.nibs_ib_dev_device_info.manufacturername is '设备厂商--型号关联';
comment on column ${iol_schema}.nibs_ib_dev_device_info.ascrbranch is '所属机构';
comment on column ${iol_schema}.nibs_ib_dev_device_info.virtualusernum is '虚拟柜员号';
comment on column ${iol_schema}.nibs_ib_dev_device_info.equipscrnresolut is '设备分辨率';
comment on column ${iol_schema}.nibs_ib_dev_device_info.adminuserone is '管理员1';
comment on column ${iol_schema}.nibs_ib_dev_device_info.adminusertwo is '管理员2';
comment on column ${iol_schema}.nibs_ib_dev_device_info.insustartdate is '维保开始日期-yyyy-MM-dd';
comment on column ${iol_schema}.nibs_ib_dev_device_info.insuenddate is '维保结束日期-yyyy-MM-dd';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devicebuydate is '设备购买日期-yyyy-MM-dd';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devicestartdate is '设备启用日期-yyyy-MM-dd';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devicestopdate is '设备停止日期-yyyy-MM-dd';
comment on column ${iol_schema}.nibs_ib_dev_device_info.deviceservicestarttime is '设备服务开始时间-HH:mm:ss';
comment on column ${iol_schema}.nibs_ib_dev_device_info.deviceserviceendtime is '设备服务结束时间-HH:mm:ss';
comment on column ${iol_schema}.nibs_ib_dev_device_info.shutdowntime is '定时关机时间-HH:mm:ss';
comment on column ${iol_schema}.nibs_ib_dev_device_info.deviceip is '设备ip';
comment on column ${iol_schema}.nibs_ib_dev_device_info.selfbank is '自助银行 1是 0否';
comment on column ${iol_schema}.nibs_ib_dev_device_info.commstatus is '通讯状态-0:未知、1:正常 2:异常';
comment on column ${iol_schema}.nibs_ib_dev_device_info.operstatus is '运行状态-0-正常，1-停止服务，2-部分服务，3-未知，4-P通讯故障，5-维护，6-关机，7-停用';
comment on column ${iol_schema}.nibs_ib_dev_device_info.bankteller is 'ATM清机申请绑定柜员号';
comment on column ${iol_schema}.nibs_ib_dev_device_info.managementmode is '管理模式|1非外包 2-外包';
comment on column ${iol_schema}.nibs_ib_dev_device_info.installaddress is '安装地址';
comment on column ${iol_schema}.nibs_ib_dev_device_info.encryptionmode is '加密方式 0-国密';
comment on column ${iol_schema}.nibs_ib_dev_device_info.qjcom_id is '清机公司编号';
comment on column ${iol_schema}.nibs_ib_dev_device_info.seq is '序号三位';
comment on column ${iol_schema}.nibs_ib_dev_device_info.virtualtailboxid is '虚拟尾箱号，与虚拟柜员是绑定关系';
comment on column ${iol_schema}.nibs_ib_dev_device_info.authcode is '中台装机码';
comment on column ${iol_schema}.nibs_ib_dev_device_info.qjcomname is '清机公司名称';
comment on column ${iol_schema}.nibs_ib_dev_device_info.asycnfalg is '中台同步标识 0-未同步 1-已经同步';
comment on column ${iol_schema}.nibs_ib_dev_device_info.installcontel is '装机联系电话';
comment on column ${iol_schema}.nibs_ib_dev_device_info.virtualusertailboxid is '虚拟柜员尾箱号';
comment on column ${iol_schema}.nibs_ib_dev_device_info.serviceprovnum is '服务商编号';
comment on column ${iol_schema}.nibs_ib_dev_device_info.vchboxflg is '凭证钱箱 0:否 1:是';
comment on column ${iol_schema}.nibs_ib_dev_device_info.cshboxflg is '现金钱箱 0:否 1:是';
comment on column ${iol_schema}.nibs_ib_dev_device_info.virtualteller is '实体柜员号';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devstate is '设备状态1-正常';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devicestate is '设备使用状态 : 0.领用、1：启用、2：停用、3：删除、9登记';
comment on column ${iol_schema}.nibs_ib_dev_device_info.modifyuser is '最后修改用户';
comment on column ${iol_schema}.nibs_ib_dev_device_info.modifyuserbrno is '最后维护人所属机构';
comment on column ${iol_schema}.nibs_ib_dev_device_info.creatorbrno is '创建人所属机构';
comment on column ${iol_schema}.nibs_ib_dev_device_info.modifdate is '最后修改日期';
comment on column ${iol_schema}.nibs_ib_dev_device_info.modiftime is '最后修改日期';
comment on column ${iol_schema}.nibs_ib_dev_device_info.creauser is '创建用户';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devactivationcode is '设备激活码';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devcreatetime is '创建时间';
comment on column ${iol_schema}.nibs_ib_dev_device_info.creadate is '创建日期 : YYYYMMDD';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devuniqueid is '设备唯一标识，C端生成';
comment on column ${iol_schema}.nibs_ib_dev_device_info.devicemac is '设备的mac地址';
comment on column ${iol_schema}.nibs_ib_dev_device_info.imeicode is 'IEME编号';
comment on column ${iol_schema}.nibs_ib_dev_device_info.backcode is '背夹序号';
comment on column ${iol_schema}.nibs_ib_dev_device_info.keyname is '秘钥名称';
comment on column ${iol_schema}.nibs_ib_dev_device_info.checkvalue is '校检值';
comment on column ${iol_schema}.nibs_ib_dev_device_info.keyvalue is '秘钥';
comment on column ${iol_schema}.nibs_ib_dev_device_info.start_dt is '开始时间';
comment on column ${iol_schema}.nibs_ib_dev_device_info.end_dt is '结束时间';
comment on column ${iol_schema}.nibs_ib_dev_device_info.id_mark is '增删标志';
comment on column ${iol_schema}.nibs_ib_dev_device_info.etl_timestamp is 'ETL处理时间戳';
