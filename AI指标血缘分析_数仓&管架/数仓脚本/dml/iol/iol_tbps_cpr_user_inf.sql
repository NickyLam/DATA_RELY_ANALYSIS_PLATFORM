/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_user_inf
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
create table ${iol_schema}.tbps_cpr_user_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_user_inf;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_user_inf_op purge;
drop table ${iol_schema}.tbps_cpr_user_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_user_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_user_inf where 0=1;

create table ${iol_schema}.tbps_cpr_user_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_user_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_user_inf_cl(
            cui_userno -- 用户顺序号
            ,cui_ecifno -- 全行统一客户号
            ,cui_userid -- 用户登录ID
            ,cui_username -- 用户名称
            ,cui_opendate -- 开户日期
            ,cui_closedate -- 销户日期
            ,cui_cettype -- 证件类型
            ,cui_cetno -- 证件号
            ,cui_email -- Email
            ,cui_phone -- 电话
            ,cui_mobilephone -- 手机号
            ,cui_stt -- 状态(0：开户；1：锁定；2：销户；7：密码被重置9：首次登录；其他状态自行扩展)
            ,cui_sex -- 性别
            ,cui_senseflag -- 敏感标识（默认：N；Y：保护；N：不保护）
            ,cui_adminflag -- 管理员标志
            ,cui_customlabel -- 用户标签
            ,cui_freezestate -- 用户冻结状态（默认：0）
            ,cui_pausestate -- 用户暂停状态（"默认：0；1：永久暂停；2：临时暂停"）
            ,cui_freezedate -- 用户冻结日期
            ,cui_pausedate -- 用户暂停日期
            ,cui_addressone -- 备用地址1
            ,cui_addresstwo -- 备用地址2
            ,cui_addressthree -- 备用地址3
            ,cui_addressfour -- 备用地址4
            ,cui_pauseremark -- 暂停原因
            ,cui_customlogo -- 头像
            ,cui_mgmtauthtype -- 企业操作员授权状态
            ,cui_weixinsignflag -- 微信签约状态(默认：0)
            ,cui_bkstype -- 收款人名称展示方式(默认：1)
            ,legperenddaread -- 法人证件是否到期提醒(存不提醒的证件号码)
            ,certinfoenddaread -- 企业证件是否到期提醒(存不提醒的证件号码)
            ,acnoread -- 账号是否到期提醒(存不提醒的账号)
            ,cui_mobilebank_open -- 启停银企通功能，1:启 0:停
            ,cui_ebankuser -- 网银用户，1:是 0:不是
            ,cui_isband_phone -- 手机号是否绑定OA，1:是 0:否
            ,cui_isselect_band -- 是否选择不绑定OA，1:是 0:否
            ,cui_isoa_adminflag -- OA管理员，1:是 0:否
            ,cui_old_oauserno -- 原OA用户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_user_inf_op(
            cui_userno -- 用户顺序号
            ,cui_ecifno -- 全行统一客户号
            ,cui_userid -- 用户登录ID
            ,cui_username -- 用户名称
            ,cui_opendate -- 开户日期
            ,cui_closedate -- 销户日期
            ,cui_cettype -- 证件类型
            ,cui_cetno -- 证件号
            ,cui_email -- Email
            ,cui_phone -- 电话
            ,cui_mobilephone -- 手机号
            ,cui_stt -- 状态(0：开户；1：锁定；2：销户；7：密码被重置9：首次登录；其他状态自行扩展)
            ,cui_sex -- 性别
            ,cui_senseflag -- 敏感标识（默认：N；Y：保护；N：不保护）
            ,cui_adminflag -- 管理员标志
            ,cui_customlabel -- 用户标签
            ,cui_freezestate -- 用户冻结状态（默认：0）
            ,cui_pausestate -- 用户暂停状态（"默认：0；1：永久暂停；2：临时暂停"）
            ,cui_freezedate -- 用户冻结日期
            ,cui_pausedate -- 用户暂停日期
            ,cui_addressone -- 备用地址1
            ,cui_addresstwo -- 备用地址2
            ,cui_addressthree -- 备用地址3
            ,cui_addressfour -- 备用地址4
            ,cui_pauseremark -- 暂停原因
            ,cui_customlogo -- 头像
            ,cui_mgmtauthtype -- 企业操作员授权状态
            ,cui_weixinsignflag -- 微信签约状态(默认：0)
            ,cui_bkstype -- 收款人名称展示方式(默认：1)
            ,legperenddaread -- 法人证件是否到期提醒(存不提醒的证件号码)
            ,certinfoenddaread -- 企业证件是否到期提醒(存不提醒的证件号码)
            ,acnoread -- 账号是否到期提醒(存不提醒的账号)
            ,cui_mobilebank_open -- 启停银企通功能，1:启 0:停
            ,cui_ebankuser -- 网银用户，1:是 0:不是
            ,cui_isband_phone -- 手机号是否绑定OA，1:是 0:否
            ,cui_isselect_band -- 是否选择不绑定OA，1:是 0:否
            ,cui_isoa_adminflag -- OA管理员，1:是 0:否
            ,cui_old_oauserno -- 原OA用户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cui_userno, o.cui_userno) as cui_userno -- 用户顺序号
    ,nvl(n.cui_ecifno, o.cui_ecifno) as cui_ecifno -- 全行统一客户号
    ,nvl(n.cui_userid, o.cui_userid) as cui_userid -- 用户登录ID
    ,nvl(n.cui_username, o.cui_username) as cui_username -- 用户名称
    ,nvl(n.cui_opendate, o.cui_opendate) as cui_opendate -- 开户日期
    ,nvl(n.cui_closedate, o.cui_closedate) as cui_closedate -- 销户日期
    ,nvl(n.cui_cettype, o.cui_cettype) as cui_cettype -- 证件类型
    ,nvl(n.cui_cetno, o.cui_cetno) as cui_cetno -- 证件号
    ,nvl(n.cui_email, o.cui_email) as cui_email -- Email
    ,nvl(n.cui_phone, o.cui_phone) as cui_phone -- 电话
    ,nvl(n.cui_mobilephone, o.cui_mobilephone) as cui_mobilephone -- 手机号
    ,nvl(n.cui_stt, o.cui_stt) as cui_stt -- 状态(0：开户；1：锁定；2：销户；7：密码被重置9：首次登录；其他状态自行扩展)
    ,nvl(n.cui_sex, o.cui_sex) as cui_sex -- 性别
    ,nvl(n.cui_senseflag, o.cui_senseflag) as cui_senseflag -- 敏感标识（默认：N；Y：保护；N：不保护）
    ,nvl(n.cui_adminflag, o.cui_adminflag) as cui_adminflag -- 管理员标志
    ,nvl(n.cui_customlabel, o.cui_customlabel) as cui_customlabel -- 用户标签
    ,nvl(n.cui_freezestate, o.cui_freezestate) as cui_freezestate -- 用户冻结状态（默认：0）
    ,nvl(n.cui_pausestate, o.cui_pausestate) as cui_pausestate -- 用户暂停状态（"默认：0；1：永久暂停；2：临时暂停"）
    ,nvl(n.cui_freezedate, o.cui_freezedate) as cui_freezedate -- 用户冻结日期
    ,nvl(n.cui_pausedate, o.cui_pausedate) as cui_pausedate -- 用户暂停日期
    ,nvl(n.cui_addressone, o.cui_addressone) as cui_addressone -- 备用地址1
    ,nvl(n.cui_addresstwo, o.cui_addresstwo) as cui_addresstwo -- 备用地址2
    ,nvl(n.cui_addressthree, o.cui_addressthree) as cui_addressthree -- 备用地址3
    ,nvl(n.cui_addressfour, o.cui_addressfour) as cui_addressfour -- 备用地址4
    ,nvl(n.cui_pauseremark, o.cui_pauseremark) as cui_pauseremark -- 暂停原因
    ,nvl(n.cui_customlogo, o.cui_customlogo) as cui_customlogo -- 头像
    ,nvl(n.cui_mgmtauthtype, o.cui_mgmtauthtype) as cui_mgmtauthtype -- 企业操作员授权状态
    ,nvl(n.cui_weixinsignflag, o.cui_weixinsignflag) as cui_weixinsignflag -- 微信签约状态(默认：0)
    ,nvl(n.cui_bkstype, o.cui_bkstype) as cui_bkstype -- 收款人名称展示方式(默认：1)
    ,nvl(n.legperenddaread, o.legperenddaread) as legperenddaread -- 法人证件是否到期提醒(存不提醒的证件号码)
    ,nvl(n.certinfoenddaread, o.certinfoenddaread) as certinfoenddaread -- 企业证件是否到期提醒(存不提醒的证件号码)
    ,nvl(n.acnoread, o.acnoread) as acnoread -- 账号是否到期提醒(存不提醒的账号)
    ,nvl(n.cui_mobilebank_open, o.cui_mobilebank_open) as cui_mobilebank_open -- 启停银企通功能，1:启 0:停
    ,nvl(n.cui_ebankuser, o.cui_ebankuser) as cui_ebankuser -- 网银用户，1:是 0:不是
    ,nvl(n.cui_isband_phone, o.cui_isband_phone) as cui_isband_phone -- 手机号是否绑定OA，1:是 0:否
    ,nvl(n.cui_isselect_band, o.cui_isselect_band) as cui_isselect_band -- 是否选择不绑定OA，1:是 0:否
    ,nvl(n.cui_isoa_adminflag, o.cui_isoa_adminflag) as cui_isoa_adminflag -- OA管理员，1:是 0:否
    ,nvl(n.cui_old_oauserno, o.cui_old_oauserno) as cui_old_oauserno -- 原OA用户编号
    ,case when
            n.cui_userno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cui_userno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cui_userno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_user_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_user_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cui_userno = n.cui_userno
where (
        o.cui_userno is null
    )
    or (
        n.cui_userno is null
    )
    or (
        o.cui_ecifno <> n.cui_ecifno
        or o.cui_userid <> n.cui_userid
        or o.cui_username <> n.cui_username
        or o.cui_opendate <> n.cui_opendate
        or o.cui_closedate <> n.cui_closedate
        or o.cui_cettype <> n.cui_cettype
        or o.cui_cetno <> n.cui_cetno
        or o.cui_email <> n.cui_email
        or o.cui_phone <> n.cui_phone
        or o.cui_mobilephone <> n.cui_mobilephone
        or o.cui_stt <> n.cui_stt
        or o.cui_sex <> n.cui_sex
        or o.cui_senseflag <> n.cui_senseflag
        or o.cui_adminflag <> n.cui_adminflag
        or o.cui_customlabel <> n.cui_customlabel
        or o.cui_freezestate <> n.cui_freezestate
        or o.cui_pausestate <> n.cui_pausestate
        or o.cui_freezedate <> n.cui_freezedate
        or o.cui_pausedate <> n.cui_pausedate
        or o.cui_addressone <> n.cui_addressone
        or o.cui_addresstwo <> n.cui_addresstwo
        or o.cui_addressthree <> n.cui_addressthree
        or o.cui_addressfour <> n.cui_addressfour
        or o.cui_pauseremark <> n.cui_pauseremark
        or o.cui_customlogo <> n.cui_customlogo
        or o.cui_mgmtauthtype <> n.cui_mgmtauthtype
        or o.cui_weixinsignflag <> n.cui_weixinsignflag
        or o.cui_bkstype <> n.cui_bkstype
        or o.legperenddaread <> n.legperenddaread
        or o.certinfoenddaread <> n.certinfoenddaread
        or o.acnoread <> n.acnoread
        or o.cui_mobilebank_open <> n.cui_mobilebank_open
        or o.cui_ebankuser <> n.cui_ebankuser
        or o.cui_isband_phone <> n.cui_isband_phone
        or o.cui_isselect_band <> n.cui_isselect_band
        or o.cui_isoa_adminflag <> n.cui_isoa_adminflag
        or o.cui_old_oauserno <> n.cui_old_oauserno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_user_inf_cl(
            cui_userno -- 用户顺序号
            ,cui_ecifno -- 全行统一客户号
            ,cui_userid -- 用户登录ID
            ,cui_username -- 用户名称
            ,cui_opendate -- 开户日期
            ,cui_closedate -- 销户日期
            ,cui_cettype -- 证件类型
            ,cui_cetno -- 证件号
            ,cui_email -- Email
            ,cui_phone -- 电话
            ,cui_mobilephone -- 手机号
            ,cui_stt -- 状态(0：开户；1：锁定；2：销户；7：密码被重置9：首次登录；其他状态自行扩展)
            ,cui_sex -- 性别
            ,cui_senseflag -- 敏感标识（默认：N；Y：保护；N：不保护）
            ,cui_adminflag -- 管理员标志
            ,cui_customlabel -- 用户标签
            ,cui_freezestate -- 用户冻结状态（默认：0）
            ,cui_pausestate -- 用户暂停状态（"默认：0；1：永久暂停；2：临时暂停"）
            ,cui_freezedate -- 用户冻结日期
            ,cui_pausedate -- 用户暂停日期
            ,cui_addressone -- 备用地址1
            ,cui_addresstwo -- 备用地址2
            ,cui_addressthree -- 备用地址3
            ,cui_addressfour -- 备用地址4
            ,cui_pauseremark -- 暂停原因
            ,cui_customlogo -- 头像
            ,cui_mgmtauthtype -- 企业操作员授权状态
            ,cui_weixinsignflag -- 微信签约状态(默认：0)
            ,cui_bkstype -- 收款人名称展示方式(默认：1)
            ,legperenddaread -- 法人证件是否到期提醒(存不提醒的证件号码)
            ,certinfoenddaread -- 企业证件是否到期提醒(存不提醒的证件号码)
            ,acnoread -- 账号是否到期提醒(存不提醒的账号)
            ,cui_mobilebank_open -- 启停银企通功能，1:启 0:停
            ,cui_ebankuser -- 网银用户，1:是 0:不是
            ,cui_isband_phone -- 手机号是否绑定OA，1:是 0:否
            ,cui_isselect_band -- 是否选择不绑定OA，1:是 0:否
            ,cui_isoa_adminflag -- OA管理员，1:是 0:否
            ,cui_old_oauserno -- 原OA用户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_user_inf_op(
            cui_userno -- 用户顺序号
            ,cui_ecifno -- 全行统一客户号
            ,cui_userid -- 用户登录ID
            ,cui_username -- 用户名称
            ,cui_opendate -- 开户日期
            ,cui_closedate -- 销户日期
            ,cui_cettype -- 证件类型
            ,cui_cetno -- 证件号
            ,cui_email -- Email
            ,cui_phone -- 电话
            ,cui_mobilephone -- 手机号
            ,cui_stt -- 状态(0：开户；1：锁定；2：销户；7：密码被重置9：首次登录；其他状态自行扩展)
            ,cui_sex -- 性别
            ,cui_senseflag -- 敏感标识（默认：N；Y：保护；N：不保护）
            ,cui_adminflag -- 管理员标志
            ,cui_customlabel -- 用户标签
            ,cui_freezestate -- 用户冻结状态（默认：0）
            ,cui_pausestate -- 用户暂停状态（"默认：0；1：永久暂停；2：临时暂停"）
            ,cui_freezedate -- 用户冻结日期
            ,cui_pausedate -- 用户暂停日期
            ,cui_addressone -- 备用地址1
            ,cui_addresstwo -- 备用地址2
            ,cui_addressthree -- 备用地址3
            ,cui_addressfour -- 备用地址4
            ,cui_pauseremark -- 暂停原因
            ,cui_customlogo -- 头像
            ,cui_mgmtauthtype -- 企业操作员授权状态
            ,cui_weixinsignflag -- 微信签约状态(默认：0)
            ,cui_bkstype -- 收款人名称展示方式(默认：1)
            ,legperenddaread -- 法人证件是否到期提醒(存不提醒的证件号码)
            ,certinfoenddaread -- 企业证件是否到期提醒(存不提醒的证件号码)
            ,acnoread -- 账号是否到期提醒(存不提醒的账号)
            ,cui_mobilebank_open -- 启停银企通功能，1:启 0:停
            ,cui_ebankuser -- 网银用户，1:是 0:不是
            ,cui_isband_phone -- 手机号是否绑定OA，1:是 0:否
            ,cui_isselect_band -- 是否选择不绑定OA，1:是 0:否
            ,cui_isoa_adminflag -- OA管理员，1:是 0:否
            ,cui_old_oauserno -- 原OA用户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cui_userno -- 用户顺序号
    ,o.cui_ecifno -- 全行统一客户号
    ,o.cui_userid -- 用户登录ID
    ,o.cui_username -- 用户名称
    ,o.cui_opendate -- 开户日期
    ,o.cui_closedate -- 销户日期
    ,o.cui_cettype -- 证件类型
    ,o.cui_cetno -- 证件号
    ,o.cui_email -- Email
    ,o.cui_phone -- 电话
    ,o.cui_mobilephone -- 手机号
    ,o.cui_stt -- 状态(0：开户；1：锁定；2：销户；7：密码被重置9：首次登录；其他状态自行扩展)
    ,o.cui_sex -- 性别
    ,o.cui_senseflag -- 敏感标识（默认：N；Y：保护；N：不保护）
    ,o.cui_adminflag -- 管理员标志
    ,o.cui_customlabel -- 用户标签
    ,o.cui_freezestate -- 用户冻结状态（默认：0）
    ,o.cui_pausestate -- 用户暂停状态（"默认：0；1：永久暂停；2：临时暂停"）
    ,o.cui_freezedate -- 用户冻结日期
    ,o.cui_pausedate -- 用户暂停日期
    ,o.cui_addressone -- 备用地址1
    ,o.cui_addresstwo -- 备用地址2
    ,o.cui_addressthree -- 备用地址3
    ,o.cui_addressfour -- 备用地址4
    ,o.cui_pauseremark -- 暂停原因
    ,o.cui_customlogo -- 头像
    ,o.cui_mgmtauthtype -- 企业操作员授权状态
    ,o.cui_weixinsignflag -- 微信签约状态(默认：0)
    ,o.cui_bkstype -- 收款人名称展示方式(默认：1)
    ,o.legperenddaread -- 法人证件是否到期提醒(存不提醒的证件号码)
    ,o.certinfoenddaread -- 企业证件是否到期提醒(存不提醒的证件号码)
    ,o.acnoread -- 账号是否到期提醒(存不提醒的账号)
    ,o.cui_mobilebank_open -- 启停银企通功能，1:启 0:停
    ,o.cui_ebankuser -- 网银用户，1:是 0:不是
    ,o.cui_isband_phone -- 手机号是否绑定OA，1:是 0:否
    ,o.cui_isselect_band -- 是否选择不绑定OA，1:是 0:否
    ,o.cui_isoa_adminflag -- OA管理员，1:是 0:否
    ,o.cui_old_oauserno -- 原OA用户编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbps_cpr_user_inf_bk o
    left join ${iol_schema}.tbps_cpr_user_inf_op n
        on
            o.cui_userno = n.cui_userno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_user_inf_cl d
        on
            o.cui_userno = d.cui_userno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbps_cpr_user_inf;

-- 4.2 exchange partition
alter table ${iol_schema}.tbps_cpr_user_inf exchange partition p_19000101 with table ${iol_schema}.tbps_cpr_user_inf_cl;
alter table ${iol_schema}.tbps_cpr_user_inf exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_user_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_user_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_user_inf_op purge;
drop table ${iol_schema}.tbps_cpr_user_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_user_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_user_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
