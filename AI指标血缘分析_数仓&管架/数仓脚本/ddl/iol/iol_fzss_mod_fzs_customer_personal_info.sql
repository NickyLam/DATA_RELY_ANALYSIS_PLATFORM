/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fzss_mod_fzs_customer_personal_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fzss_mod_fzs_customer_personal_info
whenever sqlerror continue none;
drop table ${iol_schema}.fzss_mod_fzs_customer_personal_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_customer_personal_info(
    cust_id varchar2(32) -- 客户ID 系统生成的唯一值 对私客户ID,（2+1+8位序号）
    ,corp_id varchar2(10) -- 平台商户号
    ,mybank varchar2(20) -- 法人标识代码
    ,zone_no varchar2(6) -- 分行号
    ,tran_net_member_code varchar2(32) -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
    ,cust_role varchar2(1) -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
    ,name varchar2(256) -- 姓名
    ,member_type varchar2(2) -- 会员身份类型 [枚举: 1-自然人 2-个体工商户 3-企业 9-其他]
    ,member_name varchar2(256) -- 会员名称
    ,gender varchar2(1) -- 性别 [枚举: 0-未知的性别,1-男性,2-女性,9-未说明的性别,]
    ,id_address varchar2(1024) -- 证件地址
    ,work_corp_loc varchar2(2000) -- 地址
    ,mobile varchar2(36) -- 联系方式
    ,care_typ_cd varchar2(5) -- 职业 字典值以核心数据字典为准
    ,nation varchar2(3) -- 国籍 字典值以核心数据字典为准
    ,id_type varchar2(4) -- 证件类型 [枚举: 1010-居民身份证,1082-澳门居民身份证,1081-香港居民身份证,1080-港澳台居民身份证件,1052-外国护照,1051-中国护照,2000-组织证件类型,2313-营业执照（统一社会信用代码）,数据字典：CD01012] 字典值以核心数据字典为准
    ,id_no varchar2(60) -- 证件号码
    ,cert_start_dt varchar2(8) -- 证件有效期开始日期
    ,cert_due_dt varchar2(20) -- 证件有效期结束日期
    ,ocr_status varchar2(1) -- OCR认证状态 [枚举: 0-待认证,1-对比一致,2-对比不一致,3-认证中] 这个状态位暂时只作为展示作用
    ,content_type varchar2(50) -- 影像类型 用,分隔,
    ,conent_id varchar2(660) -- 影像ID 用,分隔,设计文件存储（进件和联网核查的图片）
    ,remark varchar2(600) -- 备注
    ,create_timestamp timestamp -- 创建时间戳
    ,update_timestamp timestamp -- 更新时间戳
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
grant select on ${iol_schema}.fzss_mod_fzs_customer_personal_info to ${iml_schema};
grant select on ${iol_schema}.fzss_mod_fzs_customer_personal_info to ${icl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_customer_personal_info to ${idl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_customer_personal_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fzss_mod_fzs_customer_personal_info is '个人客户信息表';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.cust_id is '客户ID 系统生成的唯一值 对私客户ID,（2+1+8位序号）';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.corp_id is '平台商户号';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.mybank is '法人标识代码';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.zone_no is '分行号';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.tran_net_member_code is '平台用户编号 [枚举: 用户编号（平台侧唯一值）]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.cust_role is '会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.name is '姓名';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.member_type is '会员身份类型 [枚举: 1-自然人 2-个体工商户 3-企业 9-其他]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.member_name is '会员名称';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.gender is '性别 [枚举: 0-未知的性别,1-男性,2-女性,9-未说明的性别,]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.id_address is '证件地址';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.work_corp_loc is '地址';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.mobile is '联系方式';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.care_typ_cd is '职业 字典值以核心数据字典为准';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.nation is '国籍 字典值以核心数据字典为准';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.id_type is '证件类型 [枚举: 1010-居民身份证,1082-澳门居民身份证,1081-香港居民身份证,1080-港澳台居民身份证件,1052-外国护照,1051-中国护照,2000-组织证件类型,2313-营业执照（统一社会信用代码）,数据字典：CD01012] 字典值以核心数据字典为准';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.id_no is '证件号码';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.cert_start_dt is '证件有效期开始日期';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.cert_due_dt is '证件有效期结束日期';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.ocr_status is 'OCR认证状态 [枚举: 0-待认证,1-对比一致,2-对比不一致,3-认证中] 这个状态位暂时只作为展示作用';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.content_type is '影像类型 用,分隔,';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.conent_id is '影像ID 用,分隔,设计文件存储（进件和联网核查的图片）';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.remark is '备注';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.start_dt is '开始时间';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.end_dt is '结束时间';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.id_mark is '增删标志';
comment on column ${iol_schema}.fzss_mod_fzs_customer_personal_info.etl_timestamp is 'ETL处理时间戳';
