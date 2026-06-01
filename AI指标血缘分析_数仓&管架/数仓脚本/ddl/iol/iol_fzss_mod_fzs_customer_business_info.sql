/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fzss_mod_fzs_customer_business_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fzss_mod_fzs_customer_business_info
whenever sqlerror continue none;
drop table ${iol_schema}.fzss_mod_fzs_customer_business_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_customer_business_info(
    cust_id varchar2(32) -- 客户ID 系统生成的唯一值 对公客户ID,（2+2+8位序号）
    ,corp_id varchar2(10) -- 平台商户号
    ,mybank varchar2(20) -- 法人标识代码
    ,zone_no varchar2(6) -- 分行号
    ,tran_net_member_code varchar2(32) -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
    ,cust_role varchar2(1) -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
    ,name varchar2(256) -- 姓名
    ,member_type varchar2(2) -- 会员身份类型
    ,member_name varchar2(256) -- 会员名称
    ,gender varchar2(1) -- 性别 [枚举: 0-未知的性别,1-男性,2-女性,9-未说明的性别,]
    ,id_address varchar2(1024) -- 证件地址
    ,work_corp_loc varchar2(2000) -- 地址
    ,mobile varchar2(36) -- 联系方式
    ,care_typ_cd varchar2(5) -- 职业 [枚举: 数标]
    ,nation varchar2(3) -- 国籍 [枚举: 数标]
    ,id_type varchar2(4) -- 证件类型 [枚举: 数标]
    ,id_no varchar2(60) -- 证件号码
    ,cert_start_dt varchar2(8) -- 证件有效期开始日期
    ,cert_due_dt varchar2(20) -- 证件有效期结束日期
    ,indiv_business_flag varchar2(1) -- 个体工商户标志 [枚举: 1：是 2：否(个人必输)]
    ,company_name varchar2(256) -- 公司名称
    ,company_id_type varchar2(4) -- 公司证件类型 [枚举: 数标]
    ,company_id_no varchar2(60) -- 公司证件号码
    ,company_cert_start_dt varchar2(8) -- 公司证件开始日期
    ,company_cert_due_dt varchar2(20) -- 公司证件到期日期
    ,business_scope varchar2(4000) -- 公司经营范围说明
    ,shop_id varchar2(32) -- 店铺id
    ,shop_name varchar2(256) -- 店铺名称
    ,repr_flag varchar2(1) -- 法人标志 [枚举: 1-是,2-否, 个体工商户必输]
    ,repr_name varchar2(256) -- 法人名称
    ,repr_id_type varchar2(4) -- 法人证件类型 [枚举: 数标]
    ,repr_id_no varchar2(60) -- 法人证件号码
    ,repr_tel_no varchar2(36) -- 法人联系方式
    ,repr_cert_start_dt varchar2(8) -- 法人证件开始日期
    ,repr_cert_deul_dt varchar2(20) -- 法人证件到期日期
    ,agency_client_name varchar2(256) -- 经办人姓名
    ,agency_client_id_type varchar2(4) -- 经办人证件类型 [枚举: 数标]
    ,agency_client_id_no varchar2(60) -- 经办人证件号
    ,agency_client_mobile varchar2(36) -- 经办人手机号
    ,beneficiary_name varchar2(256) -- 受益人姓名 同法人
    ,beneficiary_id_type varchar2(4) -- 受益人证件类型 [枚举: 数标] 同法人
    ,beneficiary_id_no varchar2(60) -- 受益人证件号码 同法人
    ,beneficiary_id_start_dt varchar2(8) -- 受益人证件开始日期 同法人
    ,beneficiary_id_expire_dt varchar2(20) -- 受益人证件到期日期 同法人
    ,beneficiary_mobile varchar2(36) -- 受益人联系方式 同法人
    ,img_no varchar2(50) -- 电子凭证归档号
    ,ocr_status varchar2(1) -- OCR认证状态 [枚举: 0-待认证,1-对比一致,2-对比不一致,3-认证中]
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
grant select on ${iol_schema}.fzss_mod_fzs_customer_business_info to ${iml_schema};
grant select on ${iol_schema}.fzss_mod_fzs_customer_business_info to ${icl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_customer_business_info to ${idl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_customer_business_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fzss_mod_fzs_customer_business_info is '企业客户信息表';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.cust_id is '客户ID 系统生成的唯一值 对公客户ID,（2+2+8位序号）';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.corp_id is '平台商户号';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.mybank is '法人标识代码';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.zone_no is '分行号';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.tran_net_member_code is '平台用户编号 [枚举: 用户编号（平台侧唯一值）]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.cust_role is '会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.name is '姓名';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.member_type is '会员身份类型';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.member_name is '会员名称';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.gender is '性别 [枚举: 0-未知的性别,1-男性,2-女性,9-未说明的性别,]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.id_address is '证件地址';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.work_corp_loc is '地址';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.mobile is '联系方式';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.care_typ_cd is '职业 [枚举: 数标]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.nation is '国籍 [枚举: 数标]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.id_type is '证件类型 [枚举: 数标]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.id_no is '证件号码';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.cert_start_dt is '证件有效期开始日期';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.cert_due_dt is '证件有效期结束日期';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.indiv_business_flag is '个体工商户标志 [枚举: 1：是 2：否(个人必输)]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.company_name is '公司名称';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.company_id_type is '公司证件类型 [枚举: 数标]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.company_id_no is '公司证件号码';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.company_cert_start_dt is '公司证件开始日期';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.company_cert_due_dt is '公司证件到期日期';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.business_scope is '公司经营范围说明';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.shop_id is '店铺id';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.shop_name is '店铺名称';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.repr_flag is '法人标志 [枚举: 1-是,2-否, 个体工商户必输]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.repr_name is '法人名称';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.repr_id_type is '法人证件类型 [枚举: 数标]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.repr_id_no is '法人证件号码';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.repr_tel_no is '法人联系方式';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.repr_cert_start_dt is '法人证件开始日期';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.repr_cert_deul_dt is '法人证件到期日期';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.agency_client_name is '经办人姓名';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.agency_client_id_type is '经办人证件类型 [枚举: 数标]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.agency_client_id_no is '经办人证件号';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.agency_client_mobile is '经办人手机号';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.beneficiary_name is '受益人姓名 同法人';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.beneficiary_id_type is '受益人证件类型 [枚举: 数标] 同法人';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.beneficiary_id_no is '受益人证件号码 同法人';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.beneficiary_id_start_dt is '受益人证件开始日期 同法人';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.beneficiary_id_expire_dt is '受益人证件到期日期 同法人';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.beneficiary_mobile is '受益人联系方式 同法人';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.img_no is '电子凭证归档号';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.ocr_status is 'OCR认证状态 [枚举: 0-待认证,1-对比一致,2-对比不一致,3-认证中]';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.content_type is '影像类型 用,分隔,';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.conent_id is '影像ID 用,分隔,设计文件存储（进件和联网核查的图片）';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.remark is '备注';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.start_dt is '开始时间';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.end_dt is '结束时间';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.id_mark is '增删标志';
comment on column ${iol_schema}.fzss_mod_fzs_customer_business_info.etl_timestamp is 'ETL处理时间戳';
