/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_user_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_user_inf
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_user_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_user_inf(
    cui_userno varchar2(32) -- 用户顺序号
    ,cui_ecifno varchar2(32) -- 全行统一客户号
    ,cui_userid varchar2(64) -- 用户登录ID
    ,cui_username varchar2(100) -- 用户名称
    ,cui_opendate varchar2(14) -- 开户日期
    ,cui_closedate varchar2(14) -- 销户日期
    ,cui_cettype varchar2(4) -- 证件类型
    ,cui_cetno varchar2(32) -- 证件号
    ,cui_email varchar2(50) -- Email
    ,cui_phone varchar2(32) -- 电话
    ,cui_mobilephone varchar2(32) -- 手机号
    ,cui_stt varchar2(1) -- 状态(0：开户；1：锁定；2：销户；7：密码被重置9：首次登录；其他状态自行扩展)
    ,cui_sex varchar2(1) -- 性别
    ,cui_senseflag varchar2(1) -- 敏感标识（默认：N；Y：保护；N：不保护）
    ,cui_adminflag varchar2(1) -- 管理员标志
    ,cui_customlabel varchar2(128) -- 用户标签
    ,cui_freezestate varchar2(1) -- 用户冻结状态（默认：0）
    ,cui_pausestate varchar2(1) -- 用户暂停状态（"默认：0；1：永久暂停；2：临时暂停"）
    ,cui_freezedate varchar2(14) -- 用户冻结日期
    ,cui_pausedate varchar2(14) -- 用户暂停日期
    ,cui_addressone varchar2(180) -- 备用地址1
    ,cui_addresstwo varchar2(180) -- 备用地址2
    ,cui_addressthree varchar2(180) -- 备用地址3
    ,cui_addressfour varchar2(180) -- 备用地址4
    ,cui_pauseremark varchar2(120) -- 暂停原因
    ,cui_customlogo varchar2(64) -- 头像
    ,cui_mgmtauthtype varchar2(3) -- 企业操作员授权状态
    ,cui_weixinsignflag varchar2(1) -- 微信签约状态(默认：0)
    ,cui_bkstype varchar2(1) -- 收款人名称展示方式(默认：1)
    ,legperenddaread varchar2(20) -- 法人证件是否到期提醒(存不提醒的证件号码)
    ,certinfoenddaread varchar2(512) -- 企业证件是否到期提醒(存不提醒的证件号码)
    ,acnoread varchar2(512) -- 账号是否到期提醒(存不提醒的账号)
    ,cui_mobilebank_open varchar2(1) -- 启停银企通功能，1:启 0:停
    ,cui_ebankuser varchar2(1) -- 网银用户，1:是 0:不是
    ,cui_isband_phone varchar2(1) -- 手机号是否绑定OA，1:是 0:否
    ,cui_isselect_band varchar2(1) -- 是否选择不绑定OA，1:是 0:否
    ,cui_isoa_adminflag varchar2(1) -- OA管理员，1:是 0:否
    ,cui_old_oauserno varchar2(32) -- 原OA用户编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbps_cpr_user_inf to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_user_inf to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_user_inf to ${idl_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_user_inf is '企业用户表';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_userno is '用户顺序号';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_ecifno is '全行统一客户号';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_userid is '用户登录ID';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_username is '用户名称';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_opendate is '开户日期';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_closedate is '销户日期';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_cettype is '证件类型';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_cetno is '证件号';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_email is 'Email';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_phone is '电话';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_mobilephone is '手机号';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_stt is '状态(0：开户；1：锁定；2：销户；7：密码被重置9：首次登录；其他状态自行扩展)';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_sex is '性别';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_senseflag is '敏感标识（默认：N；Y：保护；N：不保护）';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_adminflag is '管理员标志';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_customlabel is '用户标签';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_freezestate is '用户冻结状态（默认：0）';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_pausestate is '用户暂停状态（"默认：0；1：永久暂停；2：临时暂停"）';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_freezedate is '用户冻结日期';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_pausedate is '用户暂停日期';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_addressone is '备用地址1';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_addresstwo is '备用地址2';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_addressthree is '备用地址3';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_addressfour is '备用地址4';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_pauseremark is '暂停原因';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_customlogo is '头像';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_mgmtauthtype is '企业操作员授权状态';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_weixinsignflag is '微信签约状态(默认：0)';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_bkstype is '收款人名称展示方式(默认：1)';
comment on column ${iol_schema}.tbps_cpr_user_inf.legperenddaread is '法人证件是否到期提醒(存不提醒的证件号码)';
comment on column ${iol_schema}.tbps_cpr_user_inf.certinfoenddaread is '企业证件是否到期提醒(存不提醒的证件号码)';
comment on column ${iol_schema}.tbps_cpr_user_inf.acnoread is '账号是否到期提醒(存不提醒的账号)';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_mobilebank_open is '启停银企通功能，1:启 0:停';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_ebankuser is '网银用户，1:是 0:不是';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_isband_phone is '手机号是否绑定OA，1:是 0:否';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_isselect_band is '是否选择不绑定OA，1:是 0:否';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_isoa_adminflag is 'OA管理员，1:是 0:否';
comment on column ${iol_schema}.tbps_cpr_user_inf.cui_old_oauserno is '原OA用户编号';
comment on column ${iol_schema}.tbps_cpr_user_inf.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_user_inf.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_user_inf.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_user_inf.etl_timestamp is 'ETL处理时间戳';
