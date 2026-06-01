/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cms_device_info
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
create table ${iol_schema}.amss_cms_device_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_cms_device_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_device_info_op purge;
drop table ${iol_schema}.amss_cms_device_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_device_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_device_info where 0=1;

create table ${iol_schema}.amss_cms_device_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_device_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_device_info_cl(
            id -- ID.ID
            ,sn_id -- 设备编号.设备编号
            ,sn_name -- 设备名称.设备名称
            ,vn_info -- 厂商编号.厂商编号
            ,vn_name -- 厂商名称.厂商名称
            ,device_type -- 设备类型.设备类型
            ,device_type_name -- 设备类型名称.设备类型名称
            ,device_model -- 设备型号.设备型号
            ,device_busi_type -- 受理终端类型.受理终端类型
            ,channel_id -- 所属机构.所属机构
            ,channel_nm -- 所属机构名称.所属机构名称
            ,pay_accept_org_id -- 所属受理机构.所属受理机构编号
            ,sn_bind_opr_id -- 绑定操作员.绑定解绑操作员
            ,sn_bind_time -- 绑定时间.绑定解绑时间
            ,sn_unbind_opr_id -- 解绑操作员.解绑操作员
            ,sn_unbind_time -- 解绑时间.解绑时间
            ,init_type -- 录入方式.录入方式 0-批量入库，1-单台入库
            ,init_batch_no -- 录入批次.录入批次
            ,sn_bind_status -- 设备绑定状态.设备绑定状态，0-未绑定，1-已绑定，2-已解绑
            ,term_no -- 终端号.终端号
            ,mch_id -- 商户号.商户号
            ,mch_name -- 商户名称.商户名称
            ,term_status -- 终端状态.终端状态 0-未启用，1-启用，2-禁用，3-注销
            ,audit_status -- 审核状态.审核状态 0-待审核，1-审核通过，2-审核未通过，3-修改待审核，4-修改审核未通过
            ,create_user_id -- 创建操作员.创建操作员
            ,create_time -- 创建时间.创建时间
            ,update_time -- 更新时间.更新时间
            ,province -- 终端所在省份.终端所在省份
            ,city -- 终端所在城市.终端所在城市
            ,county -- 终端所在区县.终端所在区县
            ,term_addr -- 终端布放地址.终端布放地址，省-市-区-详细地址，注：取值范围可参考《省市区结构说明》。示例：上海市-上海市-浦东新区-五星路
            ,term_redius -- 终端半径.终端半径
            ,longitude -- 经度.经度
            ,latitude -- 纬度.纬度
            ,is_address_bind -- 是否绑定地址.是否绑定地址
            ,term_busi_info -- 终端业务信息.终端业务信息
            ,term_init_time -- 终端初始化时间.终端初始化时间
            ,pos_sign_status -- 终端签到状态.终端签到状态0-签退，1-签到
            ,pos_signin_time -- 终端签到时间.终端签到时间
            ,pos_signout_time -- 终端签退时间.终端签退时间
            ,pos_batch_no -- 批次号.批次号
            ,pos_batch_time -- 批次签到时间.批次签到时间
            ,tmk -- 主密钥密文.主密钥密文
            ,tmk_cv -- 主密钥校验值.主密钥校验值
            ,tpk_lmk -- PIN密钥-LMK.PIN密钥-LMK加密
            ,tpk_zmk -- PIN密钥-ZMK.PIN密钥-ZMK加密
            ,tpk_kcv -- PIN密钥-CKV.PIN密钥-CKV校验值
            ,trk_lmk -- 磁道密钥-LMK.磁道密钥-LMK加密
            ,trk_zmk -- 磁道密钥-ZMK.磁道密钥-ZMK加密
            ,trk_kcv -- 磁道密钥-CKV.磁道密钥-CKV校验值
            ,tak_lmk -- MAC密钥-LMK.MAC密钥-LMK加密
            ,tak_zmk -- MAC密钥-ZMK.MAC密钥-ZMK加密
            ,tak_kcv -- MAC密钥-CKV.MAC密钥-CKV校验值
            ,old_tak_lmk -- 原MAC密钥-LMK.原MAC密钥-LMK加密
            ,old_tak_zmk -- 原MAC密钥-ZMK.原MAC密钥-ZMK加密
            ,old_tak_kcv -- 原MAC密钥-CKV.原MAC密钥-CKV校验值
            ,sign_type -- 签名方式.签名方式
            ,device_pub_key -- 设备公钥.设备公钥
            ,sn_sign_key -- 设备签名密钥.设备签名密钥
            ,version -- 版本信息.版本信息
            ,merchant_qr_url -- spay商户收款地址.spay商户收款地址
            ,notify_url -- 通知地址.通知地址
            ,is_support_nfc -- 是否支持NFC.是否支持NFC，1-支持，其他不支持
            ,cert_id -- 证书ID.待确认
            ,bind_type -- 绑定方式.绑定方式1-app绑定，2-批量导入
            ,mch_short_name -- 商户简称.商户简称
            ,active_code -- 激活编码.激活编码
            ,third_client_id -- 微收银厂商商户号.微收银厂商商户号
            ,partner -- 交易识别码.交易识别码
            ,mch_terminal_id -- 商户侧终端编号.商户侧终端编号
            ,origin -- 来源.来源 1-自有；2-APP
            ,union_device_info -- 银联终端类型.银联终端类型
            ,thi_device_info -- 
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,tusn -- 设备tusn
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_device_info_op(
            id -- ID.ID
            ,sn_id -- 设备编号.设备编号
            ,sn_name -- 设备名称.设备名称
            ,vn_info -- 厂商编号.厂商编号
            ,vn_name -- 厂商名称.厂商名称
            ,device_type -- 设备类型.设备类型
            ,device_type_name -- 设备类型名称.设备类型名称
            ,device_model -- 设备型号.设备型号
            ,device_busi_type -- 受理终端类型.受理终端类型
            ,channel_id -- 所属机构.所属机构
            ,channel_nm -- 所属机构名称.所属机构名称
            ,pay_accept_org_id -- 所属受理机构.所属受理机构编号
            ,sn_bind_opr_id -- 绑定操作员.绑定解绑操作员
            ,sn_bind_time -- 绑定时间.绑定解绑时间
            ,sn_unbind_opr_id -- 解绑操作员.解绑操作员
            ,sn_unbind_time -- 解绑时间.解绑时间
            ,init_type -- 录入方式.录入方式 0-批量入库，1-单台入库
            ,init_batch_no -- 录入批次.录入批次
            ,sn_bind_status -- 设备绑定状态.设备绑定状态，0-未绑定，1-已绑定，2-已解绑
            ,term_no -- 终端号.终端号
            ,mch_id -- 商户号.商户号
            ,mch_name -- 商户名称.商户名称
            ,term_status -- 终端状态.终端状态 0-未启用，1-启用，2-禁用，3-注销
            ,audit_status -- 审核状态.审核状态 0-待审核，1-审核通过，2-审核未通过，3-修改待审核，4-修改审核未通过
            ,create_user_id -- 创建操作员.创建操作员
            ,create_time -- 创建时间.创建时间
            ,update_time -- 更新时间.更新时间
            ,province -- 终端所在省份.终端所在省份
            ,city -- 终端所在城市.终端所在城市
            ,county -- 终端所在区县.终端所在区县
            ,term_addr -- 终端布放地址.终端布放地址，省-市-区-详细地址，注：取值范围可参考《省市区结构说明》。示例：上海市-上海市-浦东新区-五星路
            ,term_redius -- 终端半径.终端半径
            ,longitude -- 经度.经度
            ,latitude -- 纬度.纬度
            ,is_address_bind -- 是否绑定地址.是否绑定地址
            ,term_busi_info -- 终端业务信息.终端业务信息
            ,term_init_time -- 终端初始化时间.终端初始化时间
            ,pos_sign_status -- 终端签到状态.终端签到状态0-签退，1-签到
            ,pos_signin_time -- 终端签到时间.终端签到时间
            ,pos_signout_time -- 终端签退时间.终端签退时间
            ,pos_batch_no -- 批次号.批次号
            ,pos_batch_time -- 批次签到时间.批次签到时间
            ,tmk -- 主密钥密文.主密钥密文
            ,tmk_cv -- 主密钥校验值.主密钥校验值
            ,tpk_lmk -- PIN密钥-LMK.PIN密钥-LMK加密
            ,tpk_zmk -- PIN密钥-ZMK.PIN密钥-ZMK加密
            ,tpk_kcv -- PIN密钥-CKV.PIN密钥-CKV校验值
            ,trk_lmk -- 磁道密钥-LMK.磁道密钥-LMK加密
            ,trk_zmk -- 磁道密钥-ZMK.磁道密钥-ZMK加密
            ,trk_kcv -- 磁道密钥-CKV.磁道密钥-CKV校验值
            ,tak_lmk -- MAC密钥-LMK.MAC密钥-LMK加密
            ,tak_zmk -- MAC密钥-ZMK.MAC密钥-ZMK加密
            ,tak_kcv -- MAC密钥-CKV.MAC密钥-CKV校验值
            ,old_tak_lmk -- 原MAC密钥-LMK.原MAC密钥-LMK加密
            ,old_tak_zmk -- 原MAC密钥-ZMK.原MAC密钥-ZMK加密
            ,old_tak_kcv -- 原MAC密钥-CKV.原MAC密钥-CKV校验值
            ,sign_type -- 签名方式.签名方式
            ,device_pub_key -- 设备公钥.设备公钥
            ,sn_sign_key -- 设备签名密钥.设备签名密钥
            ,version -- 版本信息.版本信息
            ,merchant_qr_url -- spay商户收款地址.spay商户收款地址
            ,notify_url -- 通知地址.通知地址
            ,is_support_nfc -- 是否支持NFC.是否支持NFC，1-支持，其他不支持
            ,cert_id -- 证书ID.待确认
            ,bind_type -- 绑定方式.绑定方式1-app绑定，2-批量导入
            ,mch_short_name -- 商户简称.商户简称
            ,active_code -- 激活编码.激活编码
            ,third_client_id -- 微收银厂商商户号.微收银厂商商户号
            ,partner -- 交易识别码.交易识别码
            ,mch_terminal_id -- 商户侧终端编号.商户侧终端编号
            ,origin -- 来源.来源 1-自有；2-APP
            ,union_device_info -- 银联终端类型.银联终端类型
            ,thi_device_info -- 
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,tusn -- 设备tusn
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID.ID
    ,nvl(n.sn_id, o.sn_id) as sn_id -- 设备编号.设备编号
    ,nvl(n.sn_name, o.sn_name) as sn_name -- 设备名称.设备名称
    ,nvl(n.vn_info, o.vn_info) as vn_info -- 厂商编号.厂商编号
    ,nvl(n.vn_name, o.vn_name) as vn_name -- 厂商名称.厂商名称
    ,nvl(n.device_type, o.device_type) as device_type -- 设备类型.设备类型
    ,nvl(n.device_type_name, o.device_type_name) as device_type_name -- 设备类型名称.设备类型名称
    ,nvl(n.device_model, o.device_model) as device_model -- 设备型号.设备型号
    ,nvl(n.device_busi_type, o.device_busi_type) as device_busi_type -- 受理终端类型.受理终端类型
    ,nvl(n.channel_id, o.channel_id) as channel_id -- 所属机构.所属机构
    ,nvl(n.channel_nm, o.channel_nm) as channel_nm -- 所属机构名称.所属机构名称
    ,nvl(n.pay_accept_org_id, o.pay_accept_org_id) as pay_accept_org_id -- 所属受理机构.所属受理机构编号
    ,nvl(n.sn_bind_opr_id, o.sn_bind_opr_id) as sn_bind_opr_id -- 绑定操作员.绑定解绑操作员
    ,nvl(n.sn_bind_time, o.sn_bind_time) as sn_bind_time -- 绑定时间.绑定解绑时间
    ,nvl(n.sn_unbind_opr_id, o.sn_unbind_opr_id) as sn_unbind_opr_id -- 解绑操作员.解绑操作员
    ,nvl(n.sn_unbind_time, o.sn_unbind_time) as sn_unbind_time -- 解绑时间.解绑时间
    ,nvl(n.init_type, o.init_type) as init_type -- 录入方式.录入方式 0-批量入库，1-单台入库
    ,nvl(n.init_batch_no, o.init_batch_no) as init_batch_no -- 录入批次.录入批次
    ,nvl(n.sn_bind_status, o.sn_bind_status) as sn_bind_status -- 设备绑定状态.设备绑定状态，0-未绑定，1-已绑定，2-已解绑
    ,nvl(n.term_no, o.term_no) as term_no -- 终端号.终端号
    ,nvl(n.mch_id, o.mch_id) as mch_id -- 商户号.商户号
    ,nvl(n.mch_name, o.mch_name) as mch_name -- 商户名称.商户名称
    ,nvl(n.term_status, o.term_status) as term_status -- 终端状态.终端状态 0-未启用，1-启用，2-禁用，3-注销
    ,nvl(n.audit_status, o.audit_status) as audit_status -- 审核状态.审核状态 0-待审核，1-审核通过，2-审核未通过，3-修改待审核，4-修改审核未通过
    ,nvl(n.create_user_id, o.create_user_id) as create_user_id -- 创建操作员.创建操作员
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间.创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间.更新时间
    ,nvl(n.province, o.province) as province -- 终端所在省份.终端所在省份
    ,nvl(n.city, o.city) as city -- 终端所在城市.终端所在城市
    ,nvl(n.county, o.county) as county -- 终端所在区县.终端所在区县
    ,nvl(n.term_addr, o.term_addr) as term_addr -- 终端布放地址.终端布放地址，省-市-区-详细地址，注：取值范围可参考《省市区结构说明》。示例：上海市-上海市-浦东新区-五星路
    ,nvl(n.term_redius, o.term_redius) as term_redius -- 终端半径.终端半径
    ,nvl(n.longitude, o.longitude) as longitude -- 经度.经度
    ,nvl(n.latitude, o.latitude) as latitude -- 纬度.纬度
    ,nvl(n.is_address_bind, o.is_address_bind) as is_address_bind -- 是否绑定地址.是否绑定地址
    ,nvl(n.term_busi_info, o.term_busi_info) as term_busi_info -- 终端业务信息.终端业务信息
    ,nvl(n.term_init_time, o.term_init_time) as term_init_time -- 终端初始化时间.终端初始化时间
    ,nvl(n.pos_sign_status, o.pos_sign_status) as pos_sign_status -- 终端签到状态.终端签到状态0-签退，1-签到
    ,nvl(n.pos_signin_time, o.pos_signin_time) as pos_signin_time -- 终端签到时间.终端签到时间
    ,nvl(n.pos_signout_time, o.pos_signout_time) as pos_signout_time -- 终端签退时间.终端签退时间
    ,nvl(n.pos_batch_no, o.pos_batch_no) as pos_batch_no -- 批次号.批次号
    ,nvl(n.pos_batch_time, o.pos_batch_time) as pos_batch_time -- 批次签到时间.批次签到时间
    ,nvl(n.tmk, o.tmk) as tmk -- 主密钥密文.主密钥密文
    ,nvl(n.tmk_cv, o.tmk_cv) as tmk_cv -- 主密钥校验值.主密钥校验值
    ,nvl(n.tpk_lmk, o.tpk_lmk) as tpk_lmk -- PIN密钥-LMK.PIN密钥-LMK加密
    ,nvl(n.tpk_zmk, o.tpk_zmk) as tpk_zmk -- PIN密钥-ZMK.PIN密钥-ZMK加密
    ,nvl(n.tpk_kcv, o.tpk_kcv) as tpk_kcv -- PIN密钥-CKV.PIN密钥-CKV校验值
    ,nvl(n.trk_lmk, o.trk_lmk) as trk_lmk -- 磁道密钥-LMK.磁道密钥-LMK加密
    ,nvl(n.trk_zmk, o.trk_zmk) as trk_zmk -- 磁道密钥-ZMK.磁道密钥-ZMK加密
    ,nvl(n.trk_kcv, o.trk_kcv) as trk_kcv -- 磁道密钥-CKV.磁道密钥-CKV校验值
    ,nvl(n.tak_lmk, o.tak_lmk) as tak_lmk -- MAC密钥-LMK.MAC密钥-LMK加密
    ,nvl(n.tak_zmk, o.tak_zmk) as tak_zmk -- MAC密钥-ZMK.MAC密钥-ZMK加密
    ,nvl(n.tak_kcv, o.tak_kcv) as tak_kcv -- MAC密钥-CKV.MAC密钥-CKV校验值
    ,nvl(n.old_tak_lmk, o.old_tak_lmk) as old_tak_lmk -- 原MAC密钥-LMK.原MAC密钥-LMK加密
    ,nvl(n.old_tak_zmk, o.old_tak_zmk) as old_tak_zmk -- 原MAC密钥-ZMK.原MAC密钥-ZMK加密
    ,nvl(n.old_tak_kcv, o.old_tak_kcv) as old_tak_kcv -- 原MAC密钥-CKV.原MAC密钥-CKV校验值
    ,nvl(n.sign_type, o.sign_type) as sign_type -- 签名方式.签名方式
    ,nvl(n.device_pub_key, o.device_pub_key) as device_pub_key -- 设备公钥.设备公钥
    ,nvl(n.sn_sign_key, o.sn_sign_key) as sn_sign_key -- 设备签名密钥.设备签名密钥
    ,nvl(n.version, o.version) as version -- 版本信息.版本信息
    ,nvl(n.merchant_qr_url, o.merchant_qr_url) as merchant_qr_url -- spay商户收款地址.spay商户收款地址
    ,nvl(n.notify_url, o.notify_url) as notify_url -- 通知地址.通知地址
    ,nvl(n.is_support_nfc, o.is_support_nfc) as is_support_nfc -- 是否支持NFC.是否支持NFC，1-支持，其他不支持
    ,nvl(n.cert_id, o.cert_id) as cert_id -- 证书ID.待确认
    ,nvl(n.bind_type, o.bind_type) as bind_type -- 绑定方式.绑定方式1-app绑定，2-批量导入
    ,nvl(n.mch_short_name, o.mch_short_name) as mch_short_name -- 商户简称.商户简称
    ,nvl(n.active_code, o.active_code) as active_code -- 激活编码.激活编码
    ,nvl(n.third_client_id, o.third_client_id) as third_client_id -- 微收银厂商商户号.微收银厂商商户号
    ,nvl(n.partner, o.partner) as partner -- 交易识别码.交易识别码
    ,nvl(n.mch_terminal_id, o.mch_terminal_id) as mch_terminal_id -- 商户侧终端编号.商户侧终端编号
    ,nvl(n.origin, o.origin) as origin -- 来源.来源 1-自有；2-APP
    ,nvl(n.union_device_info, o.union_device_info) as union_device_info -- 银联终端类型.银联终端类型
    ,nvl(n.thi_device_info, o.thi_device_info) as thi_device_info -- 
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理标识.1:正常;2:删除
    ,nvl(n.tusn, o.tusn) as tusn -- 设备tusn
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_cms_device_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_cms_device_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.sn_id <> n.sn_id
        or o.sn_name <> n.sn_name
        or o.vn_info <> n.vn_info
        or o.vn_name <> n.vn_name
        or o.device_type <> n.device_type
        or o.device_type_name <> n.device_type_name
        or o.device_model <> n.device_model
        or o.device_busi_type <> n.device_busi_type
        or o.channel_id <> n.channel_id
        or o.channel_nm <> n.channel_nm
        or o.pay_accept_org_id <> n.pay_accept_org_id
        or o.sn_bind_opr_id <> n.sn_bind_opr_id
        or o.sn_bind_time <> n.sn_bind_time
        or o.sn_unbind_opr_id <> n.sn_unbind_opr_id
        or o.sn_unbind_time <> n.sn_unbind_time
        or o.init_type <> n.init_type
        or o.init_batch_no <> n.init_batch_no
        or o.sn_bind_status <> n.sn_bind_status
        or o.term_no <> n.term_no
        or o.mch_id <> n.mch_id
        or o.mch_name <> n.mch_name
        or o.term_status <> n.term_status
        or o.audit_status <> n.audit_status
        or o.create_user_id <> n.create_user_id
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.province <> n.province
        or o.city <> n.city
        or o.county <> n.county
        or o.term_addr <> n.term_addr
        or o.term_redius <> n.term_redius
        or o.longitude <> n.longitude
        or o.latitude <> n.latitude
        or o.is_address_bind <> n.is_address_bind
        or o.term_busi_info <> n.term_busi_info
        or o.term_init_time <> n.term_init_time
        or o.pos_sign_status <> n.pos_sign_status
        or o.pos_signin_time <> n.pos_signin_time
        or o.pos_signout_time <> n.pos_signout_time
        or o.pos_batch_no <> n.pos_batch_no
        or o.pos_batch_time <> n.pos_batch_time
        or o.tmk <> n.tmk
        or o.tmk_cv <> n.tmk_cv
        or o.tpk_lmk <> n.tpk_lmk
        or o.tpk_zmk <> n.tpk_zmk
        or o.tpk_kcv <> n.tpk_kcv
        or o.trk_lmk <> n.trk_lmk
        or o.trk_zmk <> n.trk_zmk
        or o.trk_kcv <> n.trk_kcv
        or o.tak_lmk <> n.tak_lmk
        or o.tak_zmk <> n.tak_zmk
        or o.tak_kcv <> n.tak_kcv
        or o.old_tak_lmk <> n.old_tak_lmk
        or o.old_tak_zmk <> n.old_tak_zmk
        or o.old_tak_kcv <> n.old_tak_kcv
        or o.sign_type <> n.sign_type
        or o.device_pub_key <> n.device_pub_key
        or o.sn_sign_key <> n.sn_sign_key
        or o.version <> n.version
        or o.merchant_qr_url <> n.merchant_qr_url
        or o.notify_url <> n.notify_url
        or o.is_support_nfc <> n.is_support_nfc
        or o.cert_id <> n.cert_id
        or o.bind_type <> n.bind_type
        or o.mch_short_name <> n.mch_short_name
        or o.active_code <> n.active_code
        or o.third_client_id <> n.third_client_id
        or o.partner <> n.partner
        or o.mch_terminal_id <> n.mch_terminal_id
        or o.origin <> n.origin
        or o.union_device_info <> n.union_device_info
        or o.thi_device_info <> n.thi_device_info
        or o.physics_flag <> n.physics_flag
        or o.tusn <> n.tusn
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_device_info_cl(
            id -- ID.ID
            ,sn_id -- 设备编号.设备编号
            ,sn_name -- 设备名称.设备名称
            ,vn_info -- 厂商编号.厂商编号
            ,vn_name -- 厂商名称.厂商名称
            ,device_type -- 设备类型.设备类型
            ,device_type_name -- 设备类型名称.设备类型名称
            ,device_model -- 设备型号.设备型号
            ,device_busi_type -- 受理终端类型.受理终端类型
            ,channel_id -- 所属机构.所属机构
            ,channel_nm -- 所属机构名称.所属机构名称
            ,pay_accept_org_id -- 所属受理机构.所属受理机构编号
            ,sn_bind_opr_id -- 绑定操作员.绑定解绑操作员
            ,sn_bind_time -- 绑定时间.绑定解绑时间
            ,sn_unbind_opr_id -- 解绑操作员.解绑操作员
            ,sn_unbind_time -- 解绑时间.解绑时间
            ,init_type -- 录入方式.录入方式 0-批量入库，1-单台入库
            ,init_batch_no -- 录入批次.录入批次
            ,sn_bind_status -- 设备绑定状态.设备绑定状态，0-未绑定，1-已绑定，2-已解绑
            ,term_no -- 终端号.终端号
            ,mch_id -- 商户号.商户号
            ,mch_name -- 商户名称.商户名称
            ,term_status -- 终端状态.终端状态 0-未启用，1-启用，2-禁用，3-注销
            ,audit_status -- 审核状态.审核状态 0-待审核，1-审核通过，2-审核未通过，3-修改待审核，4-修改审核未通过
            ,create_user_id -- 创建操作员.创建操作员
            ,create_time -- 创建时间.创建时间
            ,update_time -- 更新时间.更新时间
            ,province -- 终端所在省份.终端所在省份
            ,city -- 终端所在城市.终端所在城市
            ,county -- 终端所在区县.终端所在区县
            ,term_addr -- 终端布放地址.终端布放地址，省-市-区-详细地址，注：取值范围可参考《省市区结构说明》。示例：上海市-上海市-浦东新区-五星路
            ,term_redius -- 终端半径.终端半径
            ,longitude -- 经度.经度
            ,latitude -- 纬度.纬度
            ,is_address_bind -- 是否绑定地址.是否绑定地址
            ,term_busi_info -- 终端业务信息.终端业务信息
            ,term_init_time -- 终端初始化时间.终端初始化时间
            ,pos_sign_status -- 终端签到状态.终端签到状态0-签退，1-签到
            ,pos_signin_time -- 终端签到时间.终端签到时间
            ,pos_signout_time -- 终端签退时间.终端签退时间
            ,pos_batch_no -- 批次号.批次号
            ,pos_batch_time -- 批次签到时间.批次签到时间
            ,tmk -- 主密钥密文.主密钥密文
            ,tmk_cv -- 主密钥校验值.主密钥校验值
            ,tpk_lmk -- PIN密钥-LMK.PIN密钥-LMK加密
            ,tpk_zmk -- PIN密钥-ZMK.PIN密钥-ZMK加密
            ,tpk_kcv -- PIN密钥-CKV.PIN密钥-CKV校验值
            ,trk_lmk -- 磁道密钥-LMK.磁道密钥-LMK加密
            ,trk_zmk -- 磁道密钥-ZMK.磁道密钥-ZMK加密
            ,trk_kcv -- 磁道密钥-CKV.磁道密钥-CKV校验值
            ,tak_lmk -- MAC密钥-LMK.MAC密钥-LMK加密
            ,tak_zmk -- MAC密钥-ZMK.MAC密钥-ZMK加密
            ,tak_kcv -- MAC密钥-CKV.MAC密钥-CKV校验值
            ,old_tak_lmk -- 原MAC密钥-LMK.原MAC密钥-LMK加密
            ,old_tak_zmk -- 原MAC密钥-ZMK.原MAC密钥-ZMK加密
            ,old_tak_kcv -- 原MAC密钥-CKV.原MAC密钥-CKV校验值
            ,sign_type -- 签名方式.签名方式
            ,device_pub_key -- 设备公钥.设备公钥
            ,sn_sign_key -- 设备签名密钥.设备签名密钥
            ,version -- 版本信息.版本信息
            ,merchant_qr_url -- spay商户收款地址.spay商户收款地址
            ,notify_url -- 通知地址.通知地址
            ,is_support_nfc -- 是否支持NFC.是否支持NFC，1-支持，其他不支持
            ,cert_id -- 证书ID.待确认
            ,bind_type -- 绑定方式.绑定方式1-app绑定，2-批量导入
            ,mch_short_name -- 商户简称.商户简称
            ,active_code -- 激活编码.激活编码
            ,third_client_id -- 微收银厂商商户号.微收银厂商商户号
            ,partner -- 交易识别码.交易识别码
            ,mch_terminal_id -- 商户侧终端编号.商户侧终端编号
            ,origin -- 来源.来源 1-自有；2-APP
            ,union_device_info -- 银联终端类型.银联终端类型
            ,thi_device_info -- 
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,tusn -- 设备tusn
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_device_info_op(
            id -- ID.ID
            ,sn_id -- 设备编号.设备编号
            ,sn_name -- 设备名称.设备名称
            ,vn_info -- 厂商编号.厂商编号
            ,vn_name -- 厂商名称.厂商名称
            ,device_type -- 设备类型.设备类型
            ,device_type_name -- 设备类型名称.设备类型名称
            ,device_model -- 设备型号.设备型号
            ,device_busi_type -- 受理终端类型.受理终端类型
            ,channel_id -- 所属机构.所属机构
            ,channel_nm -- 所属机构名称.所属机构名称
            ,pay_accept_org_id -- 所属受理机构.所属受理机构编号
            ,sn_bind_opr_id -- 绑定操作员.绑定解绑操作员
            ,sn_bind_time -- 绑定时间.绑定解绑时间
            ,sn_unbind_opr_id -- 解绑操作员.解绑操作员
            ,sn_unbind_time -- 解绑时间.解绑时间
            ,init_type -- 录入方式.录入方式 0-批量入库，1-单台入库
            ,init_batch_no -- 录入批次.录入批次
            ,sn_bind_status -- 设备绑定状态.设备绑定状态，0-未绑定，1-已绑定，2-已解绑
            ,term_no -- 终端号.终端号
            ,mch_id -- 商户号.商户号
            ,mch_name -- 商户名称.商户名称
            ,term_status -- 终端状态.终端状态 0-未启用，1-启用，2-禁用，3-注销
            ,audit_status -- 审核状态.审核状态 0-待审核，1-审核通过，2-审核未通过，3-修改待审核，4-修改审核未通过
            ,create_user_id -- 创建操作员.创建操作员
            ,create_time -- 创建时间.创建时间
            ,update_time -- 更新时间.更新时间
            ,province -- 终端所在省份.终端所在省份
            ,city -- 终端所在城市.终端所在城市
            ,county -- 终端所在区县.终端所在区县
            ,term_addr -- 终端布放地址.终端布放地址，省-市-区-详细地址，注：取值范围可参考《省市区结构说明》。示例：上海市-上海市-浦东新区-五星路
            ,term_redius -- 终端半径.终端半径
            ,longitude -- 经度.经度
            ,latitude -- 纬度.纬度
            ,is_address_bind -- 是否绑定地址.是否绑定地址
            ,term_busi_info -- 终端业务信息.终端业务信息
            ,term_init_time -- 终端初始化时间.终端初始化时间
            ,pos_sign_status -- 终端签到状态.终端签到状态0-签退，1-签到
            ,pos_signin_time -- 终端签到时间.终端签到时间
            ,pos_signout_time -- 终端签退时间.终端签退时间
            ,pos_batch_no -- 批次号.批次号
            ,pos_batch_time -- 批次签到时间.批次签到时间
            ,tmk -- 主密钥密文.主密钥密文
            ,tmk_cv -- 主密钥校验值.主密钥校验值
            ,tpk_lmk -- PIN密钥-LMK.PIN密钥-LMK加密
            ,tpk_zmk -- PIN密钥-ZMK.PIN密钥-ZMK加密
            ,tpk_kcv -- PIN密钥-CKV.PIN密钥-CKV校验值
            ,trk_lmk -- 磁道密钥-LMK.磁道密钥-LMK加密
            ,trk_zmk -- 磁道密钥-ZMK.磁道密钥-ZMK加密
            ,trk_kcv -- 磁道密钥-CKV.磁道密钥-CKV校验值
            ,tak_lmk -- MAC密钥-LMK.MAC密钥-LMK加密
            ,tak_zmk -- MAC密钥-ZMK.MAC密钥-ZMK加密
            ,tak_kcv -- MAC密钥-CKV.MAC密钥-CKV校验值
            ,old_tak_lmk -- 原MAC密钥-LMK.原MAC密钥-LMK加密
            ,old_tak_zmk -- 原MAC密钥-ZMK.原MAC密钥-ZMK加密
            ,old_tak_kcv -- 原MAC密钥-CKV.原MAC密钥-CKV校验值
            ,sign_type -- 签名方式.签名方式
            ,device_pub_key -- 设备公钥.设备公钥
            ,sn_sign_key -- 设备签名密钥.设备签名密钥
            ,version -- 版本信息.版本信息
            ,merchant_qr_url -- spay商户收款地址.spay商户收款地址
            ,notify_url -- 通知地址.通知地址
            ,is_support_nfc -- 是否支持NFC.是否支持NFC，1-支持，其他不支持
            ,cert_id -- 证书ID.待确认
            ,bind_type -- 绑定方式.绑定方式1-app绑定，2-批量导入
            ,mch_short_name -- 商户简称.商户简称
            ,active_code -- 激活编码.激活编码
            ,third_client_id -- 微收银厂商商户号.微收银厂商商户号
            ,partner -- 交易识别码.交易识别码
            ,mch_terminal_id -- 商户侧终端编号.商户侧终端编号
            ,origin -- 来源.来源 1-自有；2-APP
            ,union_device_info -- 银联终端类型.银联终端类型
            ,thi_device_info -- 
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,tusn -- 设备tusn
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID.ID
    ,o.sn_id -- 设备编号.设备编号
    ,o.sn_name -- 设备名称.设备名称
    ,o.vn_info -- 厂商编号.厂商编号
    ,o.vn_name -- 厂商名称.厂商名称
    ,o.device_type -- 设备类型.设备类型
    ,o.device_type_name -- 设备类型名称.设备类型名称
    ,o.device_model -- 设备型号.设备型号
    ,o.device_busi_type -- 受理终端类型.受理终端类型
    ,o.channel_id -- 所属机构.所属机构
    ,o.channel_nm -- 所属机构名称.所属机构名称
    ,o.pay_accept_org_id -- 所属受理机构.所属受理机构编号
    ,o.sn_bind_opr_id -- 绑定操作员.绑定解绑操作员
    ,o.sn_bind_time -- 绑定时间.绑定解绑时间
    ,o.sn_unbind_opr_id -- 解绑操作员.解绑操作员
    ,o.sn_unbind_time -- 解绑时间.解绑时间
    ,o.init_type -- 录入方式.录入方式 0-批量入库，1-单台入库
    ,o.init_batch_no -- 录入批次.录入批次
    ,o.sn_bind_status -- 设备绑定状态.设备绑定状态，0-未绑定，1-已绑定，2-已解绑
    ,o.term_no -- 终端号.终端号
    ,o.mch_id -- 商户号.商户号
    ,o.mch_name -- 商户名称.商户名称
    ,o.term_status -- 终端状态.终端状态 0-未启用，1-启用，2-禁用，3-注销
    ,o.audit_status -- 审核状态.审核状态 0-待审核，1-审核通过，2-审核未通过，3-修改待审核，4-修改审核未通过
    ,o.create_user_id -- 创建操作员.创建操作员
    ,o.create_time -- 创建时间.创建时间
    ,o.update_time -- 更新时间.更新时间
    ,o.province -- 终端所在省份.终端所在省份
    ,o.city -- 终端所在城市.终端所在城市
    ,o.county -- 终端所在区县.终端所在区县
    ,o.term_addr -- 终端布放地址.终端布放地址，省-市-区-详细地址，注：取值范围可参考《省市区结构说明》。示例：上海市-上海市-浦东新区-五星路
    ,o.term_redius -- 终端半径.终端半径
    ,o.longitude -- 经度.经度
    ,o.latitude -- 纬度.纬度
    ,o.is_address_bind -- 是否绑定地址.是否绑定地址
    ,o.term_busi_info -- 终端业务信息.终端业务信息
    ,o.term_init_time -- 终端初始化时间.终端初始化时间
    ,o.pos_sign_status -- 终端签到状态.终端签到状态0-签退，1-签到
    ,o.pos_signin_time -- 终端签到时间.终端签到时间
    ,o.pos_signout_time -- 终端签退时间.终端签退时间
    ,o.pos_batch_no -- 批次号.批次号
    ,o.pos_batch_time -- 批次签到时间.批次签到时间
    ,o.tmk -- 主密钥密文.主密钥密文
    ,o.tmk_cv -- 主密钥校验值.主密钥校验值
    ,o.tpk_lmk -- PIN密钥-LMK.PIN密钥-LMK加密
    ,o.tpk_zmk -- PIN密钥-ZMK.PIN密钥-ZMK加密
    ,o.tpk_kcv -- PIN密钥-CKV.PIN密钥-CKV校验值
    ,o.trk_lmk -- 磁道密钥-LMK.磁道密钥-LMK加密
    ,o.trk_zmk -- 磁道密钥-ZMK.磁道密钥-ZMK加密
    ,o.trk_kcv -- 磁道密钥-CKV.磁道密钥-CKV校验值
    ,o.tak_lmk -- MAC密钥-LMK.MAC密钥-LMK加密
    ,o.tak_zmk -- MAC密钥-ZMK.MAC密钥-ZMK加密
    ,o.tak_kcv -- MAC密钥-CKV.MAC密钥-CKV校验值
    ,o.old_tak_lmk -- 原MAC密钥-LMK.原MAC密钥-LMK加密
    ,o.old_tak_zmk -- 原MAC密钥-ZMK.原MAC密钥-ZMK加密
    ,o.old_tak_kcv -- 原MAC密钥-CKV.原MAC密钥-CKV校验值
    ,o.sign_type -- 签名方式.签名方式
    ,o.device_pub_key -- 设备公钥.设备公钥
    ,o.sn_sign_key -- 设备签名密钥.设备签名密钥
    ,o.version -- 版本信息.版本信息
    ,o.merchant_qr_url -- spay商户收款地址.spay商户收款地址
    ,o.notify_url -- 通知地址.通知地址
    ,o.is_support_nfc -- 是否支持NFC.是否支持NFC，1-支持，其他不支持
    ,o.cert_id -- 证书ID.待确认
    ,o.bind_type -- 绑定方式.绑定方式1-app绑定，2-批量导入
    ,o.mch_short_name -- 商户简称.商户简称
    ,o.active_code -- 激活编码.激活编码
    ,o.third_client_id -- 微收银厂商商户号.微收银厂商商户号
    ,o.partner -- 交易识别码.交易识别码
    ,o.mch_terminal_id -- 商户侧终端编号.商户侧终端编号
    ,o.origin -- 来源.来源 1-自有；2-APP
    ,o.union_device_info -- 银联终端类型.银联终端类型
    ,o.thi_device_info -- 
    ,o.physics_flag -- 物理标识.1:正常;2:删除
    ,o.tusn -- 设备tusn
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
from ${iol_schema}.amss_cms_device_info_bk o
    left join ${iol_schema}.amss_cms_device_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_cms_device_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_cms_device_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_cms_device_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_cms_device_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_cms_device_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_cms_device_info exchange partition p_${batch_date} with table ${iol_schema}.amss_cms_device_info_cl;
alter table ${iol_schema}.amss_cms_device_info exchange partition p_20991231 with table ${iol_schema}.amss_cms_device_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_cms_device_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_device_info_op purge;
drop table ${iol_schema}.amss_cms_device_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_cms_device_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_cms_device_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
