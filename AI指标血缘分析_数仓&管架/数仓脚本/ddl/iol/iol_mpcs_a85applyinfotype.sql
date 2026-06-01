/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a85applyinfotype
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a85applyinfotype
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a85applyinfotype purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a85applyinfotype(
    transtime varchar2(30) -- 操作时间
    ,custno varchar2(30) -- 客户号
    ,serviceid varchar2(30) -- 卡产品标识
    ,userid varchar2(30) -- 用户userid
    ,username varchar2(150) -- 用户姓名
    ,idtype varchar2(15) -- 证件类型
    ,idvalue varchar2(60) -- 证件号码
    ,msisdn varchar2(30) -- 手机号
    ,email varchar2(30) -- 邮箱
    ,pan varchar2(60) -- 主账号
    ,validdate varchar2(30) -- 有效期
    ,cvn2 varchar2(60) -- cvn2（信用卡）
    ,pin varchar2(60) -- pin（借记卡）
    ,state varchar2(12) -- 初始00000000从左到右为云卡激活,挂失/冻结,锁定,换卡,注销 0初始化 1处理中 2成功 3失败 4解挂/解锁中
    ,cpsid varchar2(75) -- cpsid
    ,applydate varchar2(30) -- 申请日期
    ,activatedate varchar2(30) -- 激活日期
    ,validatelukcount varchar2(15) -- 当前已下载的luk数量
    ,tokenpan varchar2(30) -- 云卡标记
    ,expiredate varchar2(30) -- 云卡有效期
    ,status varchar2(30) -- 云卡状态 1-初始化 21 可用 22暂停 31注销
    ,statustime varchar2(30) -- 
    ,panstatus varchar2(60) -- 操作标识 0 正常 1主帐号挂失 2主账号锁定 3主帐号注销
    ,locked varchar2(30) -- 发卡行锁定标志，true为发卡行锁定，false为未锁定
    ,lost varchar2(30) -- 持卡人挂失标志，true为已挂失，false为未挂失
    ,devicemodel varchar2(75) -- 设备型号
    ,devicesn varchar2(75) -- 设备序列号
    ,ostype varchar2(75) -- 操作系统类型
    ,osversion varchar2(75) -- 操作系统版本
    ,deviceid varchar2(30) -- 安卓id
    ,imei varchar2(75) -- imei
    ,walletname varchar2(75) -- 移动应用名称
    ,walletsignature varchar2(75) -- 移动应用签名
    ,walletversion varchar2(75) -- 移动应用版本
    ,ifpwd varchar2(2) -- 小额免密标识 0-免密 1-验密
    ,remark1 varchar2(75) -- 
    ,remark2 varchar2(75) -- 
    ,remark3 varchar2(300) -- 
    ,remark4 varchar2(300) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a85applyinfotype to ${iml_schema};
grant select on ${iol_schema}.mpcs_a85applyinfotype to ${icl_schema};
grant select on ${iol_schema}.mpcs_a85applyinfotype to ${idl_schema};
grant select on ${iol_schema}.mpcs_a85applyinfotype to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a85applyinfotype is 'HCE账户登记表';
comment on column ${iol_schema}.mpcs_a85applyinfotype.transtime is '操作时间';
comment on column ${iol_schema}.mpcs_a85applyinfotype.custno is '客户号';
comment on column ${iol_schema}.mpcs_a85applyinfotype.serviceid is '卡产品标识';
comment on column ${iol_schema}.mpcs_a85applyinfotype.userid is '用户userid';
comment on column ${iol_schema}.mpcs_a85applyinfotype.username is '用户姓名';
comment on column ${iol_schema}.mpcs_a85applyinfotype.idtype is '证件类型';
comment on column ${iol_schema}.mpcs_a85applyinfotype.idvalue is '证件号码';
comment on column ${iol_schema}.mpcs_a85applyinfotype.msisdn is '手机号';
comment on column ${iol_schema}.mpcs_a85applyinfotype.email is '邮箱';
comment on column ${iol_schema}.mpcs_a85applyinfotype.pan is '主账号';
comment on column ${iol_schema}.mpcs_a85applyinfotype.validdate is '有效期';
comment on column ${iol_schema}.mpcs_a85applyinfotype.cvn2 is 'cvn2（信用卡）';
comment on column ${iol_schema}.mpcs_a85applyinfotype.pin is 'pin（借记卡）';
comment on column ${iol_schema}.mpcs_a85applyinfotype.state is '初始00000000从左到右为云卡激活,挂失/冻结,锁定,换卡,注销 0初始化 1处理中 2成功 3失败 4解挂/解锁中';
comment on column ${iol_schema}.mpcs_a85applyinfotype.cpsid is 'cpsid';
comment on column ${iol_schema}.mpcs_a85applyinfotype.applydate is '申请日期';
comment on column ${iol_schema}.mpcs_a85applyinfotype.activatedate is '激活日期';
comment on column ${iol_schema}.mpcs_a85applyinfotype.validatelukcount is '当前已下载的luk数量';
comment on column ${iol_schema}.mpcs_a85applyinfotype.tokenpan is '云卡标记';
comment on column ${iol_schema}.mpcs_a85applyinfotype.expiredate is '云卡有效期';
comment on column ${iol_schema}.mpcs_a85applyinfotype.status is '云卡状态 1-初始化 21 可用 22暂停 31注销';
comment on column ${iol_schema}.mpcs_a85applyinfotype.statustime is '';
comment on column ${iol_schema}.mpcs_a85applyinfotype.panstatus is '操作标识 0 正常 1主帐号挂失 2主账号锁定 3主帐号注销';
comment on column ${iol_schema}.mpcs_a85applyinfotype.locked is '发卡行锁定标志，true为发卡行锁定，false为未锁定';
comment on column ${iol_schema}.mpcs_a85applyinfotype.lost is '持卡人挂失标志，true为已挂失，false为未挂失';
comment on column ${iol_schema}.mpcs_a85applyinfotype.devicemodel is '设备型号';
comment on column ${iol_schema}.mpcs_a85applyinfotype.devicesn is '设备序列号';
comment on column ${iol_schema}.mpcs_a85applyinfotype.ostype is '操作系统类型';
comment on column ${iol_schema}.mpcs_a85applyinfotype.osversion is '操作系统版本';
comment on column ${iol_schema}.mpcs_a85applyinfotype.deviceid is '安卓id';
comment on column ${iol_schema}.mpcs_a85applyinfotype.imei is 'imei';
comment on column ${iol_schema}.mpcs_a85applyinfotype.walletname is '移动应用名称';
comment on column ${iol_schema}.mpcs_a85applyinfotype.walletsignature is '移动应用签名';
comment on column ${iol_schema}.mpcs_a85applyinfotype.walletversion is '移动应用版本';
comment on column ${iol_schema}.mpcs_a85applyinfotype.ifpwd is '小额免密标识 0-免密 1-验密';
comment on column ${iol_schema}.mpcs_a85applyinfotype.remark1 is '';
comment on column ${iol_schema}.mpcs_a85applyinfotype.remark2 is '';
comment on column ${iol_schema}.mpcs_a85applyinfotype.remark3 is '';
comment on column ${iol_schema}.mpcs_a85applyinfotype.remark4 is '';
comment on column ${iol_schema}.mpcs_a85applyinfotype.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a85applyinfotype.etl_timestamp is 'ETL处理时间戳';
