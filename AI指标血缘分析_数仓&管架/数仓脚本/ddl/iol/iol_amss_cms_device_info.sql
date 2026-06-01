/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_cms_device_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_cms_device_info
whenever sqlerror continue none;
drop table ${iol_schema}.amss_cms_device_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_device_info(
    id number(20,0) -- ID.ID
    ,sn_id varchar2(128) -- 设备编号.设备编号
    ,sn_name varchar2(128) -- 设备名称.设备名称
    ,vn_info varchar2(16) -- 厂商编号.厂商编号
    ,vn_name varchar2(64) -- 厂商名称.厂商名称
    ,device_type varchar2(32) -- 设备类型.设备类型
    ,device_type_name varchar2(64) -- 设备类型名称.设备类型名称
    ,device_model varchar2(32) -- 设备型号.设备型号
    ,device_busi_type varchar2(16) -- 受理终端类型.受理终端类型
    ,channel_id varchar2(32) -- 所属机构.所属机构
    ,channel_nm varchar2(64) -- 所属机构名称.所属机构名称
    ,pay_accept_org_id varchar2(32) -- 所属受理机构.所属受理机构编号
    ,sn_bind_opr_id varchar2(32) -- 绑定操作员.绑定解绑操作员
    ,sn_bind_time timestamp -- 绑定时间.绑定解绑时间
    ,sn_unbind_opr_id varchar2(32) -- 解绑操作员.解绑操作员
    ,sn_unbind_time timestamp -- 解绑时间.解绑时间
    ,init_type number(2,0) -- 录入方式.录入方式 0-批量入库，1-单台入库
    ,init_batch_no varchar2(64) -- 录入批次.录入批次
    ,sn_bind_status number(2,0) -- 设备绑定状态.设备绑定状态，0-未绑定，1-已绑定，2-已解绑
    ,term_no varchar2(8) -- 终端号.终端号
    ,mch_id varchar2(32) -- 商户号.商户号
    ,mch_name varchar2(128) -- 商户名称.商户名称
    ,term_status varchar2(22) -- 终端状态.终端状态 0-未启用，1-启用，2-禁用，3-注销
    ,audit_status number(2,0) -- 审核状态.审核状态 0-待审核，1-审核通过，2-审核未通过，3-修改待审核，4-修改审核未通过
    ,create_user_id varchar2(32) -- 创建操作员.创建操作员
    ,create_time timestamp -- 创建时间.创建时间
    ,update_time timestamp -- 更新时间.更新时间
    ,province varchar2(64) -- 终端所在省份.终端所在省份
    ,city varchar2(64) -- 终端所在城市.终端所在城市
    ,county varchar2(64) -- 终端所在区县.终端所在区县
    ,term_addr varchar2(256) -- 终端布放地址.终端布放地址，省-市-区-详细地址，注：取值范围可参考《省市区结构说明》。示例：上海市-上海市-浦东新区-五星路
    ,term_redius varchar2(16) -- 终端半径.终端半径
    ,longitude number(10,7) -- 经度.经度
    ,latitude number(10,7) -- 纬度.纬度
    ,is_address_bind number(2,0) -- 是否绑定地址.是否绑定地址
    ,term_busi_info varchar2(256) -- 终端业务信息.终端业务信息
    ,term_init_time timestamp -- 终端初始化时间.终端初始化时间
    ,pos_sign_status number(2,0) -- 终端签到状态.终端签到状态0-签退，1-签到
    ,pos_signin_time timestamp -- 终端签到时间.终端签到时间
    ,pos_signout_time timestamp -- 终端签退时间.终端签退时间
    ,pos_batch_no number(32,0) -- 批次号.批次号
    ,pos_batch_time timestamp -- 批次签到时间.批次签到时间
    ,tmk varchar2(64) -- 主密钥密文.主密钥密文
    ,tmk_cv varchar2(32) -- 主密钥校验值.主密钥校验值
    ,tpk_lmk varchar2(32) -- PIN密钥-LMK.PIN密钥-LMK加密
    ,tpk_zmk varchar2(32) -- PIN密钥-ZMK.PIN密钥-ZMK加密
    ,tpk_kcv varchar2(32) -- PIN密钥-CKV.PIN密钥-CKV校验值
    ,trk_lmk varchar2(32) -- 磁道密钥-LMK.磁道密钥-LMK加密
    ,trk_zmk varchar2(32) -- 磁道密钥-ZMK.磁道密钥-ZMK加密
    ,trk_kcv varchar2(32) -- 磁道密钥-CKV.磁道密钥-CKV校验值
    ,tak_lmk varchar2(32) -- MAC密钥-LMK.MAC密钥-LMK加密
    ,tak_zmk varchar2(32) -- MAC密钥-ZMK.MAC密钥-ZMK加密
    ,tak_kcv varchar2(32) -- MAC密钥-CKV.MAC密钥-CKV校验值
    ,old_tak_lmk varchar2(32) -- 原MAC密钥-LMK.原MAC密钥-LMK加密
    ,old_tak_zmk varchar2(32) -- 原MAC密钥-ZMK.原MAC密钥-ZMK加密
    ,old_tak_kcv varchar2(32) -- 原MAC密钥-CKV.原MAC密钥-CKV校验值
    ,sign_type varchar2(32) -- 签名方式.签名方式
    ,device_pub_key varchar2(512) -- 设备公钥.设备公钥
    ,sn_sign_key varchar2(256) -- 设备签名密钥.设备签名密钥
    ,version varchar2(16) -- 版本信息.版本信息
    ,merchant_qr_url varchar2(512) -- spay商户收款地址.spay商户收款地址
    ,notify_url varchar2(512) -- 通知地址.通知地址
    ,is_support_nfc number(2,0) -- 是否支持NFC.是否支持NFC，1-支持，其他不支持
    ,cert_id varchar2(32) -- 证书ID.待确认
    ,bind_type number(2,0) -- 绑定方式.绑定方式1-app绑定，2-批量导入
    ,mch_short_name varchar2(128) -- 商户简称.商户简称
    ,active_code varchar2(128) -- 激活编码.激活编码
    ,third_client_id varchar2(128) -- 微收银厂商商户号.微收银厂商商户号
    ,partner varchar2(64) -- 交易识别码.交易识别码
    ,mch_terminal_id varchar2(16) -- 商户侧终端编号.商户侧终端编号
    ,origin number(2,0) -- 来源.来源 1-自有；2-APP
    ,union_device_info varchar2(4) -- 银联终端类型.银联终端类型
    ,thi_device_info varchar2(256) -- 
    ,physics_flag number(4,0) -- 物理标识.1:正常;2:删除
    ,tusn varchar2(40) -- 设备tusn
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
grant select on ${iol_schema}.amss_cms_device_info to ${iml_schema};
grant select on ${iol_schema}.amss_cms_device_info to ${icl_schema};
grant select on ${iol_schema}.amss_cms_device_info to ${idl_schema};
grant select on ${iol_schema}.amss_cms_device_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_cms_device_info is '设备信息表';
comment on column ${iol_schema}.amss_cms_device_info.id is 'ID.ID';
comment on column ${iol_schema}.amss_cms_device_info.sn_id is '设备编号.设备编号';
comment on column ${iol_schema}.amss_cms_device_info.sn_name is '设备名称.设备名称';
comment on column ${iol_schema}.amss_cms_device_info.vn_info is '厂商编号.厂商编号';
comment on column ${iol_schema}.amss_cms_device_info.vn_name is '厂商名称.厂商名称';
comment on column ${iol_schema}.amss_cms_device_info.device_type is '设备类型.设备类型';
comment on column ${iol_schema}.amss_cms_device_info.device_type_name is '设备类型名称.设备类型名称';
comment on column ${iol_schema}.amss_cms_device_info.device_model is '设备型号.设备型号';
comment on column ${iol_schema}.amss_cms_device_info.device_busi_type is '受理终端类型.受理终端类型';
comment on column ${iol_schema}.amss_cms_device_info.channel_id is '所属机构.所属机构';
comment on column ${iol_schema}.amss_cms_device_info.channel_nm is '所属机构名称.所属机构名称';
comment on column ${iol_schema}.amss_cms_device_info.pay_accept_org_id is '所属受理机构.所属受理机构编号';
comment on column ${iol_schema}.amss_cms_device_info.sn_bind_opr_id is '绑定操作员.绑定解绑操作员';
comment on column ${iol_schema}.amss_cms_device_info.sn_bind_time is '绑定时间.绑定解绑时间';
comment on column ${iol_schema}.amss_cms_device_info.sn_unbind_opr_id is '解绑操作员.解绑操作员';
comment on column ${iol_schema}.amss_cms_device_info.sn_unbind_time is '解绑时间.解绑时间';
comment on column ${iol_schema}.amss_cms_device_info.init_type is '录入方式.录入方式 0-批量入库，1-单台入库';
comment on column ${iol_schema}.amss_cms_device_info.init_batch_no is '录入批次.录入批次';
comment on column ${iol_schema}.amss_cms_device_info.sn_bind_status is '设备绑定状态.设备绑定状态，0-未绑定，1-已绑定，2-已解绑';
comment on column ${iol_schema}.amss_cms_device_info.term_no is '终端号.终端号';
comment on column ${iol_schema}.amss_cms_device_info.mch_id is '商户号.商户号';
comment on column ${iol_schema}.amss_cms_device_info.mch_name is '商户名称.商户名称';
comment on column ${iol_schema}.amss_cms_device_info.term_status is '终端状态.终端状态 0-未启用，1-启用，2-禁用，3-注销';
comment on column ${iol_schema}.amss_cms_device_info.audit_status is '审核状态.审核状态 0-待审核，1-审核通过，2-审核未通过，3-修改待审核，4-修改审核未通过';
comment on column ${iol_schema}.amss_cms_device_info.create_user_id is '创建操作员.创建操作员';
comment on column ${iol_schema}.amss_cms_device_info.create_time is '创建时间.创建时间';
comment on column ${iol_schema}.amss_cms_device_info.update_time is '更新时间.更新时间';
comment on column ${iol_schema}.amss_cms_device_info.province is '终端所在省份.终端所在省份';
comment on column ${iol_schema}.amss_cms_device_info.city is '终端所在城市.终端所在城市';
comment on column ${iol_schema}.amss_cms_device_info.county is '终端所在区县.终端所在区县';
comment on column ${iol_schema}.amss_cms_device_info.term_addr is '终端布放地址.终端布放地址，省-市-区-详细地址，注：取值范围可参考《省市区结构说明》。示例：上海市-上海市-浦东新区-五星路';
comment on column ${iol_schema}.amss_cms_device_info.term_redius is '终端半径.终端半径';
comment on column ${iol_schema}.amss_cms_device_info.longitude is '经度.经度';
comment on column ${iol_schema}.amss_cms_device_info.latitude is '纬度.纬度';
comment on column ${iol_schema}.amss_cms_device_info.is_address_bind is '是否绑定地址.是否绑定地址';
comment on column ${iol_schema}.amss_cms_device_info.term_busi_info is '终端业务信息.终端业务信息';
comment on column ${iol_schema}.amss_cms_device_info.term_init_time is '终端初始化时间.终端初始化时间';
comment on column ${iol_schema}.amss_cms_device_info.pos_sign_status is '终端签到状态.终端签到状态0-签退，1-签到';
comment on column ${iol_schema}.amss_cms_device_info.pos_signin_time is '终端签到时间.终端签到时间';
comment on column ${iol_schema}.amss_cms_device_info.pos_signout_time is '终端签退时间.终端签退时间';
comment on column ${iol_schema}.amss_cms_device_info.pos_batch_no is '批次号.批次号';
comment on column ${iol_schema}.amss_cms_device_info.pos_batch_time is '批次签到时间.批次签到时间';
comment on column ${iol_schema}.amss_cms_device_info.tmk is '主密钥密文.主密钥密文';
comment on column ${iol_schema}.amss_cms_device_info.tmk_cv is '主密钥校验值.主密钥校验值';
comment on column ${iol_schema}.amss_cms_device_info.tpk_lmk is 'PIN密钥-LMK.PIN密钥-LMK加密';
comment on column ${iol_schema}.amss_cms_device_info.tpk_zmk is 'PIN密钥-ZMK.PIN密钥-ZMK加密';
comment on column ${iol_schema}.amss_cms_device_info.tpk_kcv is 'PIN密钥-CKV.PIN密钥-CKV校验值';
comment on column ${iol_schema}.amss_cms_device_info.trk_lmk is '磁道密钥-LMK.磁道密钥-LMK加密';
comment on column ${iol_schema}.amss_cms_device_info.trk_zmk is '磁道密钥-ZMK.磁道密钥-ZMK加密';
comment on column ${iol_schema}.amss_cms_device_info.trk_kcv is '磁道密钥-CKV.磁道密钥-CKV校验值';
comment on column ${iol_schema}.amss_cms_device_info.tak_lmk is 'MAC密钥-LMK.MAC密钥-LMK加密';
comment on column ${iol_schema}.amss_cms_device_info.tak_zmk is 'MAC密钥-ZMK.MAC密钥-ZMK加密';
comment on column ${iol_schema}.amss_cms_device_info.tak_kcv is 'MAC密钥-CKV.MAC密钥-CKV校验值';
comment on column ${iol_schema}.amss_cms_device_info.old_tak_lmk is '原MAC密钥-LMK.原MAC密钥-LMK加密';
comment on column ${iol_schema}.amss_cms_device_info.old_tak_zmk is '原MAC密钥-ZMK.原MAC密钥-ZMK加密';
comment on column ${iol_schema}.amss_cms_device_info.old_tak_kcv is '原MAC密钥-CKV.原MAC密钥-CKV校验值';
comment on column ${iol_schema}.amss_cms_device_info.sign_type is '签名方式.签名方式';
comment on column ${iol_schema}.amss_cms_device_info.device_pub_key is '设备公钥.设备公钥';
comment on column ${iol_schema}.amss_cms_device_info.sn_sign_key is '设备签名密钥.设备签名密钥';
comment on column ${iol_schema}.amss_cms_device_info.version is '版本信息.版本信息';
comment on column ${iol_schema}.amss_cms_device_info.merchant_qr_url is 'spay商户收款地址.spay商户收款地址';
comment on column ${iol_schema}.amss_cms_device_info.notify_url is '通知地址.通知地址';
comment on column ${iol_schema}.amss_cms_device_info.is_support_nfc is '是否支持NFC.是否支持NFC，1-支持，其他不支持';
comment on column ${iol_schema}.amss_cms_device_info.cert_id is '证书ID.待确认';
comment on column ${iol_schema}.amss_cms_device_info.bind_type is '绑定方式.绑定方式1-app绑定，2-批量导入';
comment on column ${iol_schema}.amss_cms_device_info.mch_short_name is '商户简称.商户简称';
comment on column ${iol_schema}.amss_cms_device_info.active_code is '激活编码.激活编码';
comment on column ${iol_schema}.amss_cms_device_info.third_client_id is '微收银厂商商户号.微收银厂商商户号';
comment on column ${iol_schema}.amss_cms_device_info.partner is '交易识别码.交易识别码';
comment on column ${iol_schema}.amss_cms_device_info.mch_terminal_id is '商户侧终端编号.商户侧终端编号';
comment on column ${iol_schema}.amss_cms_device_info.origin is '来源.来源 1-自有；2-APP';
comment on column ${iol_schema}.amss_cms_device_info.union_device_info is '银联终端类型.银联终端类型';
comment on column ${iol_schema}.amss_cms_device_info.thi_device_info is '';
comment on column ${iol_schema}.amss_cms_device_info.physics_flag is '物理标识.1:正常;2:删除';
comment on column ${iol_schema}.amss_cms_device_info.tusn is '设备tusn';
comment on column ${iol_schema}.amss_cms_device_info.start_dt is '开始时间';
comment on column ${iol_schema}.amss_cms_device_info.end_dt is '结束时间';
comment on column ${iol_schema}.amss_cms_device_info.id_mark is '增删标志';
comment on column ${iol_schema}.amss_cms_device_info.etl_timestamp is 'ETL处理时间戳';
