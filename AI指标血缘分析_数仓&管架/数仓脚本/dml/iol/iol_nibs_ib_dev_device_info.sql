/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_dev_device_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.nibs_ib_dev_device_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nibs_ib_dev_device_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_dev_device_info_op purge;
drop table ${iol_schema}.nibs_ib_dev_device_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_dev_device_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_dev_device_info where 0=1;

create table ${iol_schema}.nibs_ib_dev_device_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_dev_device_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_dev_device_info_cl(
            devicenum -- 设备编号
            ,deviceid -- 设备标识id
            ,devmodelid -- 设备型号-关联
            ,devicetypenum -- 设备类型编号
            ,devicesatus -- 设备状态标识 0-待启用，1-正常
            ,deviceboxmsg -- 管理员1手机号
            ,devicemodulemsg -- 管理员2手机号
            ,existfalg -- 在离行标识 1-在行，2-离行
            ,installtype -- 安装方式 1-穿墙式，2-大堂式，3-壁挂式
            ,manufacturername -- 设备厂商--型号关联
            ,ascrbranch -- 所属机构
            ,virtualusernum -- 虚拟柜员号
            ,equipscrnresolut -- 设备分辨率
            ,adminuserone -- 管理员1
            ,adminusertwo -- 管理员2
            ,insustartdate -- 维保开始日期-yyyy-MM-dd
            ,insuenddate -- 维保结束日期-yyyy-MM-dd
            ,devicebuydate -- 设备购买日期-yyyy-MM-dd
            ,devicestartdate -- 设备启用日期-yyyy-MM-dd
            ,devicestopdate -- 设备停止日期-yyyy-MM-dd
            ,deviceservicestarttime -- 设备服务开始时间-HH:mm:ss
            ,deviceserviceendtime -- 设备服务结束时间-HH:mm:ss
            ,shutdowntime -- 定时关机时间-HH:mm:ss
            ,deviceip -- 设备ip
            ,selfbank -- 自助银行 1是 0否
            ,commstatus -- 通讯状态-0:未知、1:正常 2:异常
            ,operstatus -- 运行状态-0-正常，1-停止服务，2-部分服务，3-未知，4-P通讯故障，5-维护，6-关机，7-停用
            ,bankteller -- ATM清机申请绑定柜员号
            ,managementmode -- 管理模式|1非外包 2-外包
            ,installaddress -- 安装地址
            ,encryptionmode -- 加密方式 0-国密
            ,qjcom_id -- 清机公司编号
            ,seq -- 序号三位
            ,virtualtailboxid -- 虚拟尾箱号，与虚拟柜员是绑定关系
            ,authcode -- 中台装机码
            ,qjcomname -- 清机公司名称
            ,asycnfalg -- 中台同步标识 0-未同步 1-已经同步
            ,installcontel -- 装机联系电话
            ,virtualusertailboxid -- 虚拟柜员尾箱号
            ,serviceprovnum -- 服务商编号
            ,vchboxflg -- 凭证钱箱 0:否 1:是
            ,cshboxflg -- 现金钱箱 0:否 1:是
            ,virtualteller -- 实体柜员号
            ,devstate -- 设备状态1-正常
            ,devicestate -- 设备使用状态 : 0.领用、1：启用、2：停用、3：删除、9登记
            ,modifyuser -- 最后修改用户
            ,modifyuserbrno -- 最后维护人所属机构
            ,creatorbrno -- 创建人所属机构
            ,modifdate -- 最后修改日期
            ,modiftime -- 最后修改日期
            ,creauser -- 创建用户
            ,devactivationcode -- 设备激活码
            ,devcreatetime -- 创建时间
            ,creadate -- 创建日期 : YYYYMMDD
            ,devuniqueid -- 设备唯一标识，C端生成
            ,devicemac -- 设备的mac地址
            ,imeicode -- IEME编号
            ,backcode -- 背夹序号
            ,keyname -- 秘钥名称
            ,checkvalue -- 校检值
            ,keyvalue -- 秘钥
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_dev_device_info_op(
            devicenum -- 设备编号
            ,deviceid -- 设备标识id
            ,devmodelid -- 设备型号-关联
            ,devicetypenum -- 设备类型编号
            ,devicesatus -- 设备状态标识 0-待启用，1-正常
            ,deviceboxmsg -- 管理员1手机号
            ,devicemodulemsg -- 管理员2手机号
            ,existfalg -- 在离行标识 1-在行，2-离行
            ,installtype -- 安装方式 1-穿墙式，2-大堂式，3-壁挂式
            ,manufacturername -- 设备厂商--型号关联
            ,ascrbranch -- 所属机构
            ,virtualusernum -- 虚拟柜员号
            ,equipscrnresolut -- 设备分辨率
            ,adminuserone -- 管理员1
            ,adminusertwo -- 管理员2
            ,insustartdate -- 维保开始日期-yyyy-MM-dd
            ,insuenddate -- 维保结束日期-yyyy-MM-dd
            ,devicebuydate -- 设备购买日期-yyyy-MM-dd
            ,devicestartdate -- 设备启用日期-yyyy-MM-dd
            ,devicestopdate -- 设备停止日期-yyyy-MM-dd
            ,deviceservicestarttime -- 设备服务开始时间-HH:mm:ss
            ,deviceserviceendtime -- 设备服务结束时间-HH:mm:ss
            ,shutdowntime -- 定时关机时间-HH:mm:ss
            ,deviceip -- 设备ip
            ,selfbank -- 自助银行 1是 0否
            ,commstatus -- 通讯状态-0:未知、1:正常 2:异常
            ,operstatus -- 运行状态-0-正常，1-停止服务，2-部分服务，3-未知，4-P通讯故障，5-维护，6-关机，7-停用
            ,bankteller -- ATM清机申请绑定柜员号
            ,managementmode -- 管理模式|1非外包 2-外包
            ,installaddress -- 安装地址
            ,encryptionmode -- 加密方式 0-国密
            ,qjcom_id -- 清机公司编号
            ,seq -- 序号三位
            ,virtualtailboxid -- 虚拟尾箱号，与虚拟柜员是绑定关系
            ,authcode -- 中台装机码
            ,qjcomname -- 清机公司名称
            ,asycnfalg -- 中台同步标识 0-未同步 1-已经同步
            ,installcontel -- 装机联系电话
            ,virtualusertailboxid -- 虚拟柜员尾箱号
            ,serviceprovnum -- 服务商编号
            ,vchboxflg -- 凭证钱箱 0:否 1:是
            ,cshboxflg -- 现金钱箱 0:否 1:是
            ,virtualteller -- 实体柜员号
            ,devstate -- 设备状态1-正常
            ,devicestate -- 设备使用状态 : 0.领用、1：启用、2：停用、3：删除、9登记
            ,modifyuser -- 最后修改用户
            ,modifyuserbrno -- 最后维护人所属机构
            ,creatorbrno -- 创建人所属机构
            ,modifdate -- 最后修改日期
            ,modiftime -- 最后修改日期
            ,creauser -- 创建用户
            ,devactivationcode -- 设备激活码
            ,devcreatetime -- 创建时间
            ,creadate -- 创建日期 : YYYYMMDD
            ,devuniqueid -- 设备唯一标识，C端生成
            ,devicemac -- 设备的mac地址
            ,imeicode -- IEME编号
            ,backcode -- 背夹序号
            ,keyname -- 秘钥名称
            ,checkvalue -- 校检值
            ,keyvalue -- 秘钥
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.devicenum, o.devicenum) as devicenum -- 设备编号
    ,nvl(n.deviceid, o.deviceid) as deviceid -- 设备标识id
    ,nvl(n.devmodelid, o.devmodelid) as devmodelid -- 设备型号-关联
    ,nvl(n.devicetypenum, o.devicetypenum) as devicetypenum -- 设备类型编号
    ,nvl(n.devicesatus, o.devicesatus) as devicesatus -- 设备状态标识 0-待启用，1-正常
    ,nvl(n.deviceboxmsg, o.deviceboxmsg) as deviceboxmsg -- 管理员1手机号
    ,nvl(n.devicemodulemsg, o.devicemodulemsg) as devicemodulemsg -- 管理员2手机号
    ,nvl(n.existfalg, o.existfalg) as existfalg -- 在离行标识 1-在行，2-离行
    ,nvl(n.installtype, o.installtype) as installtype -- 安装方式 1-穿墙式，2-大堂式，3-壁挂式
    ,nvl(n.manufacturername, o.manufacturername) as manufacturername -- 设备厂商--型号关联
    ,nvl(n.ascrbranch, o.ascrbranch) as ascrbranch -- 所属机构
    ,nvl(n.virtualusernum, o.virtualusernum) as virtualusernum -- 虚拟柜员号
    ,nvl(n.equipscrnresolut, o.equipscrnresolut) as equipscrnresolut -- 设备分辨率
    ,nvl(n.adminuserone, o.adminuserone) as adminuserone -- 管理员1
    ,nvl(n.adminusertwo, o.adminusertwo) as adminusertwo -- 管理员2
    ,nvl(n.insustartdate, o.insustartdate) as insustartdate -- 维保开始日期-yyyy-MM-dd
    ,nvl(n.insuenddate, o.insuenddate) as insuenddate -- 维保结束日期-yyyy-MM-dd
    ,nvl(n.devicebuydate, o.devicebuydate) as devicebuydate -- 设备购买日期-yyyy-MM-dd
    ,nvl(n.devicestartdate, o.devicestartdate) as devicestartdate -- 设备启用日期-yyyy-MM-dd
    ,nvl(n.devicestopdate, o.devicestopdate) as devicestopdate -- 设备停止日期-yyyy-MM-dd
    ,nvl(n.deviceservicestarttime, o.deviceservicestarttime) as deviceservicestarttime -- 设备服务开始时间-HH:mm:ss
    ,nvl(n.deviceserviceendtime, o.deviceserviceendtime) as deviceserviceendtime -- 设备服务结束时间-HH:mm:ss
    ,nvl(n.shutdowntime, o.shutdowntime) as shutdowntime -- 定时关机时间-HH:mm:ss
    ,nvl(n.deviceip, o.deviceip) as deviceip -- 设备ip
    ,nvl(n.selfbank, o.selfbank) as selfbank -- 自助银行 1是 0否
    ,nvl(n.commstatus, o.commstatus) as commstatus -- 通讯状态-0:未知、1:正常 2:异常
    ,nvl(n.operstatus, o.operstatus) as operstatus -- 运行状态-0-正常，1-停止服务，2-部分服务，3-未知，4-P通讯故障，5-维护，6-关机，7-停用
    ,nvl(n.bankteller, o.bankteller) as bankteller -- ATM清机申请绑定柜员号
    ,nvl(n.managementmode, o.managementmode) as managementmode -- 管理模式|1非外包 2-外包
    ,nvl(n.installaddress, o.installaddress) as installaddress -- 安装地址
    ,nvl(n.encryptionmode, o.encryptionmode) as encryptionmode -- 加密方式 0-国密
    ,nvl(n.qjcom_id, o.qjcom_id) as qjcom_id -- 清机公司编号
    ,nvl(n.seq, o.seq) as seq -- 序号三位
    ,nvl(n.virtualtailboxid, o.virtualtailboxid) as virtualtailboxid -- 虚拟尾箱号，与虚拟柜员是绑定关系
    ,nvl(n.authcode, o.authcode) as authcode -- 中台装机码
    ,nvl(n.qjcomname, o.qjcomname) as qjcomname -- 清机公司名称
    ,nvl(n.asycnfalg, o.asycnfalg) as asycnfalg -- 中台同步标识 0-未同步 1-已经同步
    ,nvl(n.installcontel, o.installcontel) as installcontel -- 装机联系电话
    ,nvl(n.virtualusertailboxid, o.virtualusertailboxid) as virtualusertailboxid -- 虚拟柜员尾箱号
    ,nvl(n.serviceprovnum, o.serviceprovnum) as serviceprovnum -- 服务商编号
    ,nvl(n.vchboxflg, o.vchboxflg) as vchboxflg -- 凭证钱箱 0:否 1:是
    ,nvl(n.cshboxflg, o.cshboxflg) as cshboxflg -- 现金钱箱 0:否 1:是
    ,nvl(n.virtualteller, o.virtualteller) as virtualteller -- 实体柜员号
    ,nvl(n.devstate, o.devstate) as devstate -- 设备状态1-正常
    ,nvl(n.devicestate, o.devicestate) as devicestate -- 设备使用状态 : 0.领用、1：启用、2：停用、3：删除、9登记
    ,nvl(n.modifyuser, o.modifyuser) as modifyuser -- 最后修改用户
    ,nvl(n.modifyuserbrno, o.modifyuserbrno) as modifyuserbrno -- 最后维护人所属机构
    ,nvl(n.creatorbrno, o.creatorbrno) as creatorbrno -- 创建人所属机构
    ,nvl(n.modifdate, o.modifdate) as modifdate -- 最后修改日期
    ,nvl(n.modiftime, o.modiftime) as modiftime -- 最后修改日期
    ,nvl(n.creauser, o.creauser) as creauser -- 创建用户
    ,nvl(n.devactivationcode, o.devactivationcode) as devactivationcode -- 设备激活码
    ,nvl(n.devcreatetime, o.devcreatetime) as devcreatetime -- 创建时间
    ,nvl(n.creadate, o.creadate) as creadate -- 创建日期 : YYYYMMDD
    ,nvl(n.devuniqueid, o.devuniqueid) as devuniqueid -- 设备唯一标识，C端生成
    ,nvl(n.devicemac, o.devicemac) as devicemac -- 设备的mac地址
    ,nvl(n.imeicode, o.imeicode) as imeicode -- IEME编号
    ,nvl(n.backcode, o.backcode) as backcode -- 背夹序号
    ,nvl(n.keyname, o.keyname) as keyname -- 秘钥名称
    ,nvl(n.checkvalue, o.checkvalue) as checkvalue -- 校检值
    ,nvl(n.keyvalue, o.keyvalue) as keyvalue -- 秘钥
    ,case when
            n.devicenum is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.devicenum is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.devicenum is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nibs_ib_dev_device_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nibs_ib_dev_device_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.devicenum = n.devicenum
where (
        o.devicenum is null
    )
    or (
        n.devicenum is null
    )
    or (
        o.deviceid <> n.deviceid
        or o.devmodelid <> n.devmodelid
        or o.devicetypenum <> n.devicetypenum
        or o.devicesatus <> n.devicesatus
        or o.deviceboxmsg <> n.deviceboxmsg
        or o.devicemodulemsg <> n.devicemodulemsg
        or o.existfalg <> n.existfalg
        or o.installtype <> n.installtype
        or o.manufacturername <> n.manufacturername
        or o.ascrbranch <> n.ascrbranch
        or o.virtualusernum <> n.virtualusernum
        or o.equipscrnresolut <> n.equipscrnresolut
        or o.adminuserone <> n.adminuserone
        or o.adminusertwo <> n.adminusertwo
        or o.insustartdate <> n.insustartdate
        or o.insuenddate <> n.insuenddate
        or o.devicebuydate <> n.devicebuydate
        or o.devicestartdate <> n.devicestartdate
        or o.devicestopdate <> n.devicestopdate
        or o.deviceservicestarttime <> n.deviceservicestarttime
        or o.deviceserviceendtime <> n.deviceserviceendtime
        or o.shutdowntime <> n.shutdowntime
        or o.deviceip <> n.deviceip
        or o.selfbank <> n.selfbank
        or o.commstatus <> n.commstatus
        or o.operstatus <> n.operstatus
        or o.bankteller <> n.bankteller
        or o.managementmode <> n.managementmode
        or o.installaddress <> n.installaddress
        or o.encryptionmode <> n.encryptionmode
        or o.qjcom_id <> n.qjcom_id
        or o.seq <> n.seq
        or o.virtualtailboxid <> n.virtualtailboxid
        or o.authcode <> n.authcode
        or o.qjcomname <> n.qjcomname
        or o.asycnfalg <> n.asycnfalg
        or o.installcontel <> n.installcontel
        or o.virtualusertailboxid <> n.virtualusertailboxid
        or o.serviceprovnum <> n.serviceprovnum
        or o.vchboxflg <> n.vchboxflg
        or o.cshboxflg <> n.cshboxflg
        or o.virtualteller <> n.virtualteller
        or o.devstate <> n.devstate
        or o.devicestate <> n.devicestate
        or o.modifyuser <> n.modifyuser
        or o.modifyuserbrno <> n.modifyuserbrno
        or o.creatorbrno <> n.creatorbrno
        or o.modifdate <> n.modifdate
        or o.modiftime <> n.modiftime
        or o.creauser <> n.creauser
        or o.devactivationcode <> n.devactivationcode
        or o.devcreatetime <> n.devcreatetime
        or o.creadate <> n.creadate
        or o.devuniqueid <> n.devuniqueid
        or o.devicemac <> n.devicemac
        or o.imeicode <> n.imeicode
        or o.backcode <> n.backcode
        or o.keyname <> n.keyname
        or o.checkvalue <> n.checkvalue
        or o.keyvalue <> n.keyvalue
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_dev_device_info_cl(
            devicenum -- 设备编号
            ,deviceid -- 设备标识id
            ,devmodelid -- 设备型号-关联
            ,devicetypenum -- 设备类型编号
            ,devicesatus -- 设备状态标识 0-待启用，1-正常
            ,deviceboxmsg -- 管理员1手机号
            ,devicemodulemsg -- 管理员2手机号
            ,existfalg -- 在离行标识 1-在行，2-离行
            ,installtype -- 安装方式 1-穿墙式，2-大堂式，3-壁挂式
            ,manufacturername -- 设备厂商--型号关联
            ,ascrbranch -- 所属机构
            ,virtualusernum -- 虚拟柜员号
            ,equipscrnresolut -- 设备分辨率
            ,adminuserone -- 管理员1
            ,adminusertwo -- 管理员2
            ,insustartdate -- 维保开始日期-yyyy-MM-dd
            ,insuenddate -- 维保结束日期-yyyy-MM-dd
            ,devicebuydate -- 设备购买日期-yyyy-MM-dd
            ,devicestartdate -- 设备启用日期-yyyy-MM-dd
            ,devicestopdate -- 设备停止日期-yyyy-MM-dd
            ,deviceservicestarttime -- 设备服务开始时间-HH:mm:ss
            ,deviceserviceendtime -- 设备服务结束时间-HH:mm:ss
            ,shutdowntime -- 定时关机时间-HH:mm:ss
            ,deviceip -- 设备ip
            ,selfbank -- 自助银行 1是 0否
            ,commstatus -- 通讯状态-0:未知、1:正常 2:异常
            ,operstatus -- 运行状态-0-正常，1-停止服务，2-部分服务，3-未知，4-P通讯故障，5-维护，6-关机，7-停用
            ,bankteller -- ATM清机申请绑定柜员号
            ,managementmode -- 管理模式|1非外包 2-外包
            ,installaddress -- 安装地址
            ,encryptionmode -- 加密方式 0-国密
            ,qjcom_id -- 清机公司编号
            ,seq -- 序号三位
            ,virtualtailboxid -- 虚拟尾箱号，与虚拟柜员是绑定关系
            ,authcode -- 中台装机码
            ,qjcomname -- 清机公司名称
            ,asycnfalg -- 中台同步标识 0-未同步 1-已经同步
            ,installcontel -- 装机联系电话
            ,virtualusertailboxid -- 虚拟柜员尾箱号
            ,serviceprovnum -- 服务商编号
            ,vchboxflg -- 凭证钱箱 0:否 1:是
            ,cshboxflg -- 现金钱箱 0:否 1:是
            ,virtualteller -- 实体柜员号
            ,devstate -- 设备状态1-正常
            ,devicestate -- 设备使用状态 : 0.领用、1：启用、2：停用、3：删除、9登记
            ,modifyuser -- 最后修改用户
            ,modifyuserbrno -- 最后维护人所属机构
            ,creatorbrno -- 创建人所属机构
            ,modifdate -- 最后修改日期
            ,modiftime -- 最后修改日期
            ,creauser -- 创建用户
            ,devactivationcode -- 设备激活码
            ,devcreatetime -- 创建时间
            ,creadate -- 创建日期 : YYYYMMDD
            ,devuniqueid -- 设备唯一标识，C端生成
            ,devicemac -- 设备的mac地址
            ,imeicode -- IEME编号
            ,backcode -- 背夹序号
            ,keyname -- 秘钥名称
            ,checkvalue -- 校检值
            ,keyvalue -- 秘钥
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_dev_device_info_op(
            devicenum -- 设备编号
            ,deviceid -- 设备标识id
            ,devmodelid -- 设备型号-关联
            ,devicetypenum -- 设备类型编号
            ,devicesatus -- 设备状态标识 0-待启用，1-正常
            ,deviceboxmsg -- 管理员1手机号
            ,devicemodulemsg -- 管理员2手机号
            ,existfalg -- 在离行标识 1-在行，2-离行
            ,installtype -- 安装方式 1-穿墙式，2-大堂式，3-壁挂式
            ,manufacturername -- 设备厂商--型号关联
            ,ascrbranch -- 所属机构
            ,virtualusernum -- 虚拟柜员号
            ,equipscrnresolut -- 设备分辨率
            ,adminuserone -- 管理员1
            ,adminusertwo -- 管理员2
            ,insustartdate -- 维保开始日期-yyyy-MM-dd
            ,insuenddate -- 维保结束日期-yyyy-MM-dd
            ,devicebuydate -- 设备购买日期-yyyy-MM-dd
            ,devicestartdate -- 设备启用日期-yyyy-MM-dd
            ,devicestopdate -- 设备停止日期-yyyy-MM-dd
            ,deviceservicestarttime -- 设备服务开始时间-HH:mm:ss
            ,deviceserviceendtime -- 设备服务结束时间-HH:mm:ss
            ,shutdowntime -- 定时关机时间-HH:mm:ss
            ,deviceip -- 设备ip
            ,selfbank -- 自助银行 1是 0否
            ,commstatus -- 通讯状态-0:未知、1:正常 2:异常
            ,operstatus -- 运行状态-0-正常，1-停止服务，2-部分服务，3-未知，4-P通讯故障，5-维护，6-关机，7-停用
            ,bankteller -- ATM清机申请绑定柜员号
            ,managementmode -- 管理模式|1非外包 2-外包
            ,installaddress -- 安装地址
            ,encryptionmode -- 加密方式 0-国密
            ,qjcom_id -- 清机公司编号
            ,seq -- 序号三位
            ,virtualtailboxid -- 虚拟尾箱号，与虚拟柜员是绑定关系
            ,authcode -- 中台装机码
            ,qjcomname -- 清机公司名称
            ,asycnfalg -- 中台同步标识 0-未同步 1-已经同步
            ,installcontel -- 装机联系电话
            ,virtualusertailboxid -- 虚拟柜员尾箱号
            ,serviceprovnum -- 服务商编号
            ,vchboxflg -- 凭证钱箱 0:否 1:是
            ,cshboxflg -- 现金钱箱 0:否 1:是
            ,virtualteller -- 实体柜员号
            ,devstate -- 设备状态1-正常
            ,devicestate -- 设备使用状态 : 0.领用、1：启用、2：停用、3：删除、9登记
            ,modifyuser -- 最后修改用户
            ,modifyuserbrno -- 最后维护人所属机构
            ,creatorbrno -- 创建人所属机构
            ,modifdate -- 最后修改日期
            ,modiftime -- 最后修改日期
            ,creauser -- 创建用户
            ,devactivationcode -- 设备激活码
            ,devcreatetime -- 创建时间
            ,creadate -- 创建日期 : YYYYMMDD
            ,devuniqueid -- 设备唯一标识，C端生成
            ,devicemac -- 设备的mac地址
            ,imeicode -- IEME编号
            ,backcode -- 背夹序号
            ,keyname -- 秘钥名称
            ,checkvalue -- 校检值
            ,keyvalue -- 秘钥
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.devicenum -- 设备编号
    ,o.deviceid -- 设备标识id
    ,o.devmodelid -- 设备型号-关联
    ,o.devicetypenum -- 设备类型编号
    ,o.devicesatus -- 设备状态标识 0-待启用，1-正常
    ,o.deviceboxmsg -- 管理员1手机号
    ,o.devicemodulemsg -- 管理员2手机号
    ,o.existfalg -- 在离行标识 1-在行，2-离行
    ,o.installtype -- 安装方式 1-穿墙式，2-大堂式，3-壁挂式
    ,o.manufacturername -- 设备厂商--型号关联
    ,o.ascrbranch -- 所属机构
    ,o.virtualusernum -- 虚拟柜员号
    ,o.equipscrnresolut -- 设备分辨率
    ,o.adminuserone -- 管理员1
    ,o.adminusertwo -- 管理员2
    ,o.insustartdate -- 维保开始日期-yyyy-MM-dd
    ,o.insuenddate -- 维保结束日期-yyyy-MM-dd
    ,o.devicebuydate -- 设备购买日期-yyyy-MM-dd
    ,o.devicestartdate -- 设备启用日期-yyyy-MM-dd
    ,o.devicestopdate -- 设备停止日期-yyyy-MM-dd
    ,o.deviceservicestarttime -- 设备服务开始时间-HH:mm:ss
    ,o.deviceserviceendtime -- 设备服务结束时间-HH:mm:ss
    ,o.shutdowntime -- 定时关机时间-HH:mm:ss
    ,o.deviceip -- 设备ip
    ,o.selfbank -- 自助银行 1是 0否
    ,o.commstatus -- 通讯状态-0:未知、1:正常 2:异常
    ,o.operstatus -- 运行状态-0-正常，1-停止服务，2-部分服务，3-未知，4-P通讯故障，5-维护，6-关机，7-停用
    ,o.bankteller -- ATM清机申请绑定柜员号
    ,o.managementmode -- 管理模式|1非外包 2-外包
    ,o.installaddress -- 安装地址
    ,o.encryptionmode -- 加密方式 0-国密
    ,o.qjcom_id -- 清机公司编号
    ,o.seq -- 序号三位
    ,o.virtualtailboxid -- 虚拟尾箱号，与虚拟柜员是绑定关系
    ,o.authcode -- 中台装机码
    ,o.qjcomname -- 清机公司名称
    ,o.asycnfalg -- 中台同步标识 0-未同步 1-已经同步
    ,o.installcontel -- 装机联系电话
    ,o.virtualusertailboxid -- 虚拟柜员尾箱号
    ,o.serviceprovnum -- 服务商编号
    ,o.vchboxflg -- 凭证钱箱 0:否 1:是
    ,o.cshboxflg -- 现金钱箱 0:否 1:是
    ,o.virtualteller -- 实体柜员号
    ,o.devstate -- 设备状态1-正常
    ,o.devicestate -- 设备使用状态 : 0.领用、1：启用、2：停用、3：删除、9登记
    ,o.modifyuser -- 最后修改用户
    ,o.modifyuserbrno -- 最后维护人所属机构
    ,o.creatorbrno -- 创建人所属机构
    ,o.modifdate -- 最后修改日期
    ,o.modiftime -- 最后修改日期
    ,o.creauser -- 创建用户
    ,o.devactivationcode -- 设备激活码
    ,o.devcreatetime -- 创建时间
    ,o.creadate -- 创建日期 : YYYYMMDD
    ,o.devuniqueid -- 设备唯一标识，C端生成
    ,o.devicemac -- 设备的mac地址
    ,o.imeicode -- IEME编号
    ,o.backcode -- 背夹序号
    ,o.keyname -- 秘钥名称
    ,o.checkvalue -- 校检值
    ,o.keyvalue -- 秘钥
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.nibs_ib_dev_device_info_bk o
    left join ${iol_schema}.nibs_ib_dev_device_info_op n
        on
            o.devicenum = n.devicenum
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nibs_ib_dev_device_info_cl d
        on
            o.devicenum = d.devicenum
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nibs_ib_dev_device_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nibs_ib_dev_device_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nibs_ib_dev_device_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nibs_ib_dev_device_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nibs_ib_dev_device_info exchange partition p_${batch_date} with table ${iol_schema}.nibs_ib_dev_device_info_cl;
alter table ${iol_schema}.nibs_ib_dev_device_info exchange partition p_20991231 with table ${iol_schema}.nibs_ib_dev_device_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_dev_device_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_dev_device_info_op purge;
drop table ${iol_schema}.nibs_ib_dev_device_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nibs_ib_dev_device_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_dev_device_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
