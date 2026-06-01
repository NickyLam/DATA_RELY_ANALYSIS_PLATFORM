/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a56tsmcustinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a56tsmcustinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a56tsmcustinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a56tsmcustinfo(
    seid varchar2(48) -- 安全载体标识
    ,appid varchar2(48) -- 
    ,appversion varchar2(15) -- 
    ,processid varchar2(45) -- 申请单号
    ,acctno varchar2(53) -- 账号
    ,pin varchar2(24) -- 密码
    ,acctstate varchar2(2) -- tsm账户状态：0-正常， 1-预开立, 2-锁定， 3-挂失， 4-删除（销户）
    ,accttype varchar2(3) -- 账户类型（01-借记卡， 02- 贷记卡， 06-纯电子现金卡）
    ,custno varchar2(30) -- 客户号
    ,idtype varchar2(3) -- 证件类型
    ,idno varchar2(30) -- 证件号
    ,acctname varchar2(120) -- 姓名
    ,mobile varchar2(18) -- 手机号
    ,mobilestate varchar2(6) -- 11-预销户退订, 12-销户退订, 13-过户退订, 14-改号退订, 21-欠费停机, 22-用户挂失停机, 23-用户主动停机, 31-续费恢复, 32-解挂后恢复, 33-主动停机后复机, 41-mocam注册通知
    ,bindacctno varchar2(53) -- 开卡时上送的验证卡号
    ,relacctno varchar2(53) -- tsm电子现金账户关联转出账户卡号
    ,relacctnotype varchar2(3) -- tsm电子现金账户关联转出账户卡号类型
    ,relacctnoold varchar2(53) -- tsm电子现金账户关联转出账户卡号（更换前卡号，没有更换过则为空）
    ,relacctnomdl varchar2(2) -- 更换关联转出账号通知（0-已通知，1-待通知银联tsm，为空表示未更换卡号）
    ,sharedtype varchar2(2) -- 是否共享账户（0-否， 1-是）：共享账户是指新申请应用的后台账户与用于申请该应用所使用的卡片信息的后台账户对应为同一个
    ,chnlid varchar2(23) -- 渠道码
    ,opendate varchar2(23) -- 开卡日期
    ,expirydata varchar2(23) -- 账户有效期
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
grant select on ${iol_schema}.mpcs_a56tsmcustinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a56tsmcustinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a56tsmcustinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a56tsmcustinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a56tsmcustinfo is 'TSM客户信息表';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.seid is '安全载体标识';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.appid is '';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.appversion is '';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.processid is '申请单号';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.acctno is '账号';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.pin is '密码';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.acctstate is 'tsm账户状态：0-正常， 1-预开立, 2-锁定， 3-挂失， 4-删除（销户）';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.accttype is '账户类型（01-借记卡， 02- 贷记卡， 06-纯电子现金卡）';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.custno is '客户号';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.idtype is '证件类型';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.idno is '证件号';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.acctname is '姓名';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.mobile is '手机号';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.mobilestate is '11-预销户退订, 12-销户退订, 13-过户退订, 14-改号退订, 21-欠费停机, 22-用户挂失停机, 23-用户主动停机, 31-续费恢复, 32-解挂后恢复, 33-主动停机后复机, 41-mocam注册通知';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.bindacctno is '开卡时上送的验证卡号';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.relacctno is 'tsm电子现金账户关联转出账户卡号';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.relacctnotype is 'tsm电子现金账户关联转出账户卡号类型';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.relacctnoold is 'tsm电子现金账户关联转出账户卡号（更换前卡号，没有更换过则为空）';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.relacctnomdl is '更换关联转出账号通知（0-已通知，1-待通知银联tsm，为空表示未更换卡号）';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.sharedtype is '是否共享账户（0-否， 1-是）：共享账户是指新申请应用的后台账户与用于申请该应用所使用的卡片信息的后台账户对应为同一个';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.chnlid is '渠道码';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.opendate is '开卡日期';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.expirydata is '账户有效期';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a56tsmcustinfo.etl_timestamp is 'ETL处理时间戳';
