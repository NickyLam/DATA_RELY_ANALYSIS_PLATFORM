/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fzss_mod_fzs_customer_business_info
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
create table ${iol_schema}.fzss_mod_fzs_customer_business_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fzss_mod_fzs_customer_business_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_customer_business_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_customer_business_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_customer_business_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fzss_mod_fzs_customer_business_info where 0=1;

create table ${iol_schema}.fzss_mod_fzs_customer_business_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fzss_mod_fzs_customer_business_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fzss_mod_fzs_customer_business_info_cl(
            cust_id -- 客户ID 系统生成的唯一值 对公客户ID,（2+2+8位序号）
            ,corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,tran_net_member_code -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
            ,cust_role -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
            ,name -- 姓名
            ,member_type -- 会员身份类型
            ,member_name -- 会员名称
            ,gender -- 性别 [枚举: 0-未知的性别,1-男性,2-女性,9-未说明的性别,]
            ,id_address -- 证件地址
            ,work_corp_loc -- 地址
            ,mobile -- 联系方式
            ,care_typ_cd -- 职业 [枚举: 数标]
            ,nation -- 国籍 [枚举: 数标]
            ,id_type -- 证件类型 [枚举: 数标]
            ,id_no -- 证件号码
            ,cert_start_dt -- 证件有效期开始日期
            ,cert_due_dt -- 证件有效期结束日期
            ,indiv_business_flag -- 个体工商户标志 [枚举: 1：是 2：否(个人必输)]
            ,company_name -- 公司名称
            ,company_id_type -- 公司证件类型 [枚举: 数标]
            ,company_id_no -- 公司证件号码
            ,company_cert_start_dt -- 公司证件开始日期
            ,company_cert_due_dt -- 公司证件到期日期
            ,business_scope -- 公司经营范围说明
            ,shop_id -- 店铺id
            ,shop_name -- 店铺名称
            ,repr_flag -- 法人标志 [枚举: 1-是,2-否, 个体工商户必输]
            ,repr_name -- 法人名称
            ,repr_id_type -- 法人证件类型 [枚举: 数标]
            ,repr_id_no -- 法人证件号码
            ,repr_tel_no -- 法人联系方式
            ,repr_cert_start_dt -- 法人证件开始日期
            ,repr_cert_deul_dt -- 法人证件到期日期
            ,agency_client_name -- 经办人姓名
            ,agency_client_id_type -- 经办人证件类型 [枚举: 数标]
            ,agency_client_id_no -- 经办人证件号
            ,agency_client_mobile -- 经办人手机号
            ,beneficiary_name -- 受益人姓名 同法人
            ,beneficiary_id_type -- 受益人证件类型 [枚举: 数标] 同法人
            ,beneficiary_id_no -- 受益人证件号码 同法人
            ,beneficiary_id_start_dt -- 受益人证件开始日期 同法人
            ,beneficiary_id_expire_dt -- 受益人证件到期日期 同法人
            ,beneficiary_mobile -- 受益人联系方式 同法人
            ,img_no -- 电子凭证归档号
            ,ocr_status -- OCR认证状态 [枚举: 0-待认证,1-对比一致,2-对比不一致,3-认证中]
            ,content_type -- 影像类型 用,分隔,
            ,conent_id -- 影像ID 用,分隔,设计文件存储（进件和联网核查的图片）
            ,remark -- 备注
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fzss_mod_fzs_customer_business_info_op(
            cust_id -- 客户ID 系统生成的唯一值 对公客户ID,（2+2+8位序号）
            ,corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,tran_net_member_code -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
            ,cust_role -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
            ,name -- 姓名
            ,member_type -- 会员身份类型
            ,member_name -- 会员名称
            ,gender -- 性别 [枚举: 0-未知的性别,1-男性,2-女性,9-未说明的性别,]
            ,id_address -- 证件地址
            ,work_corp_loc -- 地址
            ,mobile -- 联系方式
            ,care_typ_cd -- 职业 [枚举: 数标]
            ,nation -- 国籍 [枚举: 数标]
            ,id_type -- 证件类型 [枚举: 数标]
            ,id_no -- 证件号码
            ,cert_start_dt -- 证件有效期开始日期
            ,cert_due_dt -- 证件有效期结束日期
            ,indiv_business_flag -- 个体工商户标志 [枚举: 1：是 2：否(个人必输)]
            ,company_name -- 公司名称
            ,company_id_type -- 公司证件类型 [枚举: 数标]
            ,company_id_no -- 公司证件号码
            ,company_cert_start_dt -- 公司证件开始日期
            ,company_cert_due_dt -- 公司证件到期日期
            ,business_scope -- 公司经营范围说明
            ,shop_id -- 店铺id
            ,shop_name -- 店铺名称
            ,repr_flag -- 法人标志 [枚举: 1-是,2-否, 个体工商户必输]
            ,repr_name -- 法人名称
            ,repr_id_type -- 法人证件类型 [枚举: 数标]
            ,repr_id_no -- 法人证件号码
            ,repr_tel_no -- 法人联系方式
            ,repr_cert_start_dt -- 法人证件开始日期
            ,repr_cert_deul_dt -- 法人证件到期日期
            ,agency_client_name -- 经办人姓名
            ,agency_client_id_type -- 经办人证件类型 [枚举: 数标]
            ,agency_client_id_no -- 经办人证件号
            ,agency_client_mobile -- 经办人手机号
            ,beneficiary_name -- 受益人姓名 同法人
            ,beneficiary_id_type -- 受益人证件类型 [枚举: 数标] 同法人
            ,beneficiary_id_no -- 受益人证件号码 同法人
            ,beneficiary_id_start_dt -- 受益人证件开始日期 同法人
            ,beneficiary_id_expire_dt -- 受益人证件到期日期 同法人
            ,beneficiary_mobile -- 受益人联系方式 同法人
            ,img_no -- 电子凭证归档号
            ,ocr_status -- OCR认证状态 [枚举: 0-待认证,1-对比一致,2-对比不一致,3-认证中]
            ,content_type -- 影像类型 用,分隔,
            ,conent_id -- 影像ID 用,分隔,设计文件存储（进件和联网核查的图片）
            ,remark -- 备注
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cust_id, o.cust_id) as cust_id -- 客户ID 系统生成的唯一值 对公客户ID,（2+2+8位序号）
    ,nvl(n.corp_id, o.corp_id) as corp_id -- 平台商户号
    ,nvl(n.mybank, o.mybank) as mybank -- 法人标识代码
    ,nvl(n.zone_no, o.zone_no) as zone_no -- 分行号
    ,nvl(n.tran_net_member_code, o.tran_net_member_code) as tran_net_member_code -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
    ,nvl(n.cust_role, o.cust_role) as cust_role -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
    ,nvl(n.name, o.name) as name -- 姓名
    ,nvl(n.member_type, o.member_type) as member_type -- 会员身份类型
    ,nvl(n.member_name, o.member_name) as member_name -- 会员名称
    ,nvl(n.gender, o.gender) as gender -- 性别 [枚举: 0-未知的性别,1-男性,2-女性,9-未说明的性别,]
    ,nvl(n.id_address, o.id_address) as id_address -- 证件地址
    ,nvl(n.work_corp_loc, o.work_corp_loc) as work_corp_loc -- 地址
    ,nvl(n.mobile, o.mobile) as mobile -- 联系方式
    ,nvl(n.care_typ_cd, o.care_typ_cd) as care_typ_cd -- 职业 [枚举: 数标]
    ,nvl(n.nation, o.nation) as nation -- 国籍 [枚举: 数标]
    ,nvl(n.id_type, o.id_type) as id_type -- 证件类型 [枚举: 数标]
    ,nvl(n.id_no, o.id_no) as id_no -- 证件号码
    ,nvl(n.cert_start_dt, o.cert_start_dt) as cert_start_dt -- 证件有效期开始日期
    ,nvl(n.cert_due_dt, o.cert_due_dt) as cert_due_dt -- 证件有效期结束日期
    ,nvl(n.indiv_business_flag, o.indiv_business_flag) as indiv_business_flag -- 个体工商户标志 [枚举: 1：是 2：否(个人必输)]
    ,nvl(n.company_name, o.company_name) as company_name -- 公司名称
    ,nvl(n.company_id_type, o.company_id_type) as company_id_type -- 公司证件类型 [枚举: 数标]
    ,nvl(n.company_id_no, o.company_id_no) as company_id_no -- 公司证件号码
    ,nvl(n.company_cert_start_dt, o.company_cert_start_dt) as company_cert_start_dt -- 公司证件开始日期
    ,nvl(n.company_cert_due_dt, o.company_cert_due_dt) as company_cert_due_dt -- 公司证件到期日期
    ,nvl(n.business_scope, o.business_scope) as business_scope -- 公司经营范围说明
    ,nvl(n.shop_id, o.shop_id) as shop_id -- 店铺id
    ,nvl(n.shop_name, o.shop_name) as shop_name -- 店铺名称
    ,nvl(n.repr_flag, o.repr_flag) as repr_flag -- 法人标志 [枚举: 1-是,2-否, 个体工商户必输]
    ,nvl(n.repr_name, o.repr_name) as repr_name -- 法人名称
    ,nvl(n.repr_id_type, o.repr_id_type) as repr_id_type -- 法人证件类型 [枚举: 数标]
    ,nvl(n.repr_id_no, o.repr_id_no) as repr_id_no -- 法人证件号码
    ,nvl(n.repr_tel_no, o.repr_tel_no) as repr_tel_no -- 法人联系方式
    ,nvl(n.repr_cert_start_dt, o.repr_cert_start_dt) as repr_cert_start_dt -- 法人证件开始日期
    ,nvl(n.repr_cert_deul_dt, o.repr_cert_deul_dt) as repr_cert_deul_dt -- 法人证件到期日期
    ,nvl(n.agency_client_name, o.agency_client_name) as agency_client_name -- 经办人姓名
    ,nvl(n.agency_client_id_type, o.agency_client_id_type) as agency_client_id_type -- 经办人证件类型 [枚举: 数标]
    ,nvl(n.agency_client_id_no, o.agency_client_id_no) as agency_client_id_no -- 经办人证件号
    ,nvl(n.agency_client_mobile, o.agency_client_mobile) as agency_client_mobile -- 经办人手机号
    ,nvl(n.beneficiary_name, o.beneficiary_name) as beneficiary_name -- 受益人姓名 同法人
    ,nvl(n.beneficiary_id_type, o.beneficiary_id_type) as beneficiary_id_type -- 受益人证件类型 [枚举: 数标] 同法人
    ,nvl(n.beneficiary_id_no, o.beneficiary_id_no) as beneficiary_id_no -- 受益人证件号码 同法人
    ,nvl(n.beneficiary_id_start_dt, o.beneficiary_id_start_dt) as beneficiary_id_start_dt -- 受益人证件开始日期 同法人
    ,nvl(n.beneficiary_id_expire_dt, o.beneficiary_id_expire_dt) as beneficiary_id_expire_dt -- 受益人证件到期日期 同法人
    ,nvl(n.beneficiary_mobile, o.beneficiary_mobile) as beneficiary_mobile -- 受益人联系方式 同法人
    ,nvl(n.img_no, o.img_no) as img_no -- 电子凭证归档号
    ,nvl(n.ocr_status, o.ocr_status) as ocr_status -- OCR认证状态 [枚举: 0-待认证,1-对比一致,2-对比不一致,3-认证中]
    ,nvl(n.content_type, o.content_type) as content_type -- 影像类型 用,分隔,
    ,nvl(n.conent_id, o.conent_id) as conent_id -- 影像ID 用,分隔,设计文件存储（进件和联网核查的图片）
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_timestamp, o.create_timestamp) as create_timestamp -- 创建时间戳
    ,nvl(n.update_timestamp, o.update_timestamp) as update_timestamp -- 更新时间戳
    ,case when
            n.cust_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cust_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cust_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fzss_mod_fzs_customer_business_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fzss_mod_fzs_customer_business_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cust_id = n.cust_id
where (
        o.cust_id is null
    )
    or (
        n.cust_id is null
    )
    or (
        o.corp_id <> n.corp_id
        or o.mybank <> n.mybank
        or o.zone_no <> n.zone_no
        or o.tran_net_member_code <> n.tran_net_member_code
        or o.cust_role <> n.cust_role
        or o.name <> n.name
        or o.member_type <> n.member_type
        or o.member_name <> n.member_name
        or o.gender <> n.gender
        or o.id_address <> n.id_address
        or o.work_corp_loc <> n.work_corp_loc
        or o.mobile <> n.mobile
        or o.care_typ_cd <> n.care_typ_cd
        or o.nation <> n.nation
        or o.id_type <> n.id_type
        or o.id_no <> n.id_no
        or o.cert_start_dt <> n.cert_start_dt
        or o.cert_due_dt <> n.cert_due_dt
        or o.indiv_business_flag <> n.indiv_business_flag
        or o.company_name <> n.company_name
        or o.company_id_type <> n.company_id_type
        or o.company_id_no <> n.company_id_no
        or o.company_cert_start_dt <> n.company_cert_start_dt
        or o.company_cert_due_dt <> n.company_cert_due_dt
        or o.business_scope <> n.business_scope
        or o.shop_id <> n.shop_id
        or o.shop_name <> n.shop_name
        or o.repr_flag <> n.repr_flag
        or o.repr_name <> n.repr_name
        or o.repr_id_type <> n.repr_id_type
        or o.repr_id_no <> n.repr_id_no
        or o.repr_tel_no <> n.repr_tel_no
        or o.repr_cert_start_dt <> n.repr_cert_start_dt
        or o.repr_cert_deul_dt <> n.repr_cert_deul_dt
        or o.agency_client_name <> n.agency_client_name
        or o.agency_client_id_type <> n.agency_client_id_type
        or o.agency_client_id_no <> n.agency_client_id_no
        or o.agency_client_mobile <> n.agency_client_mobile
        or o.beneficiary_name <> n.beneficiary_name
        or o.beneficiary_id_type <> n.beneficiary_id_type
        or o.beneficiary_id_no <> n.beneficiary_id_no
        or o.beneficiary_id_start_dt <> n.beneficiary_id_start_dt
        or o.beneficiary_id_expire_dt <> n.beneficiary_id_expire_dt
        or o.beneficiary_mobile <> n.beneficiary_mobile
        or o.img_no <> n.img_no
        or o.ocr_status <> n.ocr_status
        or o.content_type <> n.content_type
        or o.conent_id <> n.conent_id
        or o.remark <> n.remark
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fzss_mod_fzs_customer_business_info_cl(
            cust_id -- 客户ID 系统生成的唯一值 对公客户ID,（2+2+8位序号）
            ,corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,tran_net_member_code -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
            ,cust_role -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
            ,name -- 姓名
            ,member_type -- 会员身份类型
            ,member_name -- 会员名称
            ,gender -- 性别 [枚举: 0-未知的性别,1-男性,2-女性,9-未说明的性别,]
            ,id_address -- 证件地址
            ,work_corp_loc -- 地址
            ,mobile -- 联系方式
            ,care_typ_cd -- 职业 [枚举: 数标]
            ,nation -- 国籍 [枚举: 数标]
            ,id_type -- 证件类型 [枚举: 数标]
            ,id_no -- 证件号码
            ,cert_start_dt -- 证件有效期开始日期
            ,cert_due_dt -- 证件有效期结束日期
            ,indiv_business_flag -- 个体工商户标志 [枚举: 1：是 2：否(个人必输)]
            ,company_name -- 公司名称
            ,company_id_type -- 公司证件类型 [枚举: 数标]
            ,company_id_no -- 公司证件号码
            ,company_cert_start_dt -- 公司证件开始日期
            ,company_cert_due_dt -- 公司证件到期日期
            ,business_scope -- 公司经营范围说明
            ,shop_id -- 店铺id
            ,shop_name -- 店铺名称
            ,repr_flag -- 法人标志 [枚举: 1-是,2-否, 个体工商户必输]
            ,repr_name -- 法人名称
            ,repr_id_type -- 法人证件类型 [枚举: 数标]
            ,repr_id_no -- 法人证件号码
            ,repr_tel_no -- 法人联系方式
            ,repr_cert_start_dt -- 法人证件开始日期
            ,repr_cert_deul_dt -- 法人证件到期日期
            ,agency_client_name -- 经办人姓名
            ,agency_client_id_type -- 经办人证件类型 [枚举: 数标]
            ,agency_client_id_no -- 经办人证件号
            ,agency_client_mobile -- 经办人手机号
            ,beneficiary_name -- 受益人姓名 同法人
            ,beneficiary_id_type -- 受益人证件类型 [枚举: 数标] 同法人
            ,beneficiary_id_no -- 受益人证件号码 同法人
            ,beneficiary_id_start_dt -- 受益人证件开始日期 同法人
            ,beneficiary_id_expire_dt -- 受益人证件到期日期 同法人
            ,beneficiary_mobile -- 受益人联系方式 同法人
            ,img_no -- 电子凭证归档号
            ,ocr_status -- OCR认证状态 [枚举: 0-待认证,1-对比一致,2-对比不一致,3-认证中]
            ,content_type -- 影像类型 用,分隔,
            ,conent_id -- 影像ID 用,分隔,设计文件存储（进件和联网核查的图片）
            ,remark -- 备注
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fzss_mod_fzs_customer_business_info_op(
            cust_id -- 客户ID 系统生成的唯一值 对公客户ID,（2+2+8位序号）
            ,corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,tran_net_member_code -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
            ,cust_role -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
            ,name -- 姓名
            ,member_type -- 会员身份类型
            ,member_name -- 会员名称
            ,gender -- 性别 [枚举: 0-未知的性别,1-男性,2-女性,9-未说明的性别,]
            ,id_address -- 证件地址
            ,work_corp_loc -- 地址
            ,mobile -- 联系方式
            ,care_typ_cd -- 职业 [枚举: 数标]
            ,nation -- 国籍 [枚举: 数标]
            ,id_type -- 证件类型 [枚举: 数标]
            ,id_no -- 证件号码
            ,cert_start_dt -- 证件有效期开始日期
            ,cert_due_dt -- 证件有效期结束日期
            ,indiv_business_flag -- 个体工商户标志 [枚举: 1：是 2：否(个人必输)]
            ,company_name -- 公司名称
            ,company_id_type -- 公司证件类型 [枚举: 数标]
            ,company_id_no -- 公司证件号码
            ,company_cert_start_dt -- 公司证件开始日期
            ,company_cert_due_dt -- 公司证件到期日期
            ,business_scope -- 公司经营范围说明
            ,shop_id -- 店铺id
            ,shop_name -- 店铺名称
            ,repr_flag -- 法人标志 [枚举: 1-是,2-否, 个体工商户必输]
            ,repr_name -- 法人名称
            ,repr_id_type -- 法人证件类型 [枚举: 数标]
            ,repr_id_no -- 法人证件号码
            ,repr_tel_no -- 法人联系方式
            ,repr_cert_start_dt -- 法人证件开始日期
            ,repr_cert_deul_dt -- 法人证件到期日期
            ,agency_client_name -- 经办人姓名
            ,agency_client_id_type -- 经办人证件类型 [枚举: 数标]
            ,agency_client_id_no -- 经办人证件号
            ,agency_client_mobile -- 经办人手机号
            ,beneficiary_name -- 受益人姓名 同法人
            ,beneficiary_id_type -- 受益人证件类型 [枚举: 数标] 同法人
            ,beneficiary_id_no -- 受益人证件号码 同法人
            ,beneficiary_id_start_dt -- 受益人证件开始日期 同法人
            ,beneficiary_id_expire_dt -- 受益人证件到期日期 同法人
            ,beneficiary_mobile -- 受益人联系方式 同法人
            ,img_no -- 电子凭证归档号
            ,ocr_status -- OCR认证状态 [枚举: 0-待认证,1-对比一致,2-对比不一致,3-认证中]
            ,content_type -- 影像类型 用,分隔,
            ,conent_id -- 影像ID 用,分隔,设计文件存储（进件和联网核查的图片）
            ,remark -- 备注
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cust_id -- 客户ID 系统生成的唯一值 对公客户ID,（2+2+8位序号）
    ,o.corp_id -- 平台商户号
    ,o.mybank -- 法人标识代码
    ,o.zone_no -- 分行号
    ,o.tran_net_member_code -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
    ,o.cust_role -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
    ,o.name -- 姓名
    ,o.member_type -- 会员身份类型
    ,o.member_name -- 会员名称
    ,o.gender -- 性别 [枚举: 0-未知的性别,1-男性,2-女性,9-未说明的性别,]
    ,o.id_address -- 证件地址
    ,o.work_corp_loc -- 地址
    ,o.mobile -- 联系方式
    ,o.care_typ_cd -- 职业 [枚举: 数标]
    ,o.nation -- 国籍 [枚举: 数标]
    ,o.id_type -- 证件类型 [枚举: 数标]
    ,o.id_no -- 证件号码
    ,o.cert_start_dt -- 证件有效期开始日期
    ,o.cert_due_dt -- 证件有效期结束日期
    ,o.indiv_business_flag -- 个体工商户标志 [枚举: 1：是 2：否(个人必输)]
    ,o.company_name -- 公司名称
    ,o.company_id_type -- 公司证件类型 [枚举: 数标]
    ,o.company_id_no -- 公司证件号码
    ,o.company_cert_start_dt -- 公司证件开始日期
    ,o.company_cert_due_dt -- 公司证件到期日期
    ,o.business_scope -- 公司经营范围说明
    ,o.shop_id -- 店铺id
    ,o.shop_name -- 店铺名称
    ,o.repr_flag -- 法人标志 [枚举: 1-是,2-否, 个体工商户必输]
    ,o.repr_name -- 法人名称
    ,o.repr_id_type -- 法人证件类型 [枚举: 数标]
    ,o.repr_id_no -- 法人证件号码
    ,o.repr_tel_no -- 法人联系方式
    ,o.repr_cert_start_dt -- 法人证件开始日期
    ,o.repr_cert_deul_dt -- 法人证件到期日期
    ,o.agency_client_name -- 经办人姓名
    ,o.agency_client_id_type -- 经办人证件类型 [枚举: 数标]
    ,o.agency_client_id_no -- 经办人证件号
    ,o.agency_client_mobile -- 经办人手机号
    ,o.beneficiary_name -- 受益人姓名 同法人
    ,o.beneficiary_id_type -- 受益人证件类型 [枚举: 数标] 同法人
    ,o.beneficiary_id_no -- 受益人证件号码 同法人
    ,o.beneficiary_id_start_dt -- 受益人证件开始日期 同法人
    ,o.beneficiary_id_expire_dt -- 受益人证件到期日期 同法人
    ,o.beneficiary_mobile -- 受益人联系方式 同法人
    ,o.img_no -- 电子凭证归档号
    ,o.ocr_status -- OCR认证状态 [枚举: 0-待认证,1-对比一致,2-对比不一致,3-认证中]
    ,o.content_type -- 影像类型 用,分隔,
    ,o.conent_id -- 影像ID 用,分隔,设计文件存储（进件和联网核查的图片）
    ,o.remark -- 备注
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 更新时间戳
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
from ${iol_schema}.fzss_mod_fzs_customer_business_info_bk o
    left join ${iol_schema}.fzss_mod_fzs_customer_business_info_op n
        on
            o.cust_id = n.cust_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fzss_mod_fzs_customer_business_info_cl d
        on
            o.cust_id = d.cust_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fzss_mod_fzs_customer_business_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fzss_mod_fzs_customer_business_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fzss_mod_fzs_customer_business_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fzss_mod_fzs_customer_business_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fzss_mod_fzs_customer_business_info exchange partition p_${batch_date} with table ${iol_schema}.fzss_mod_fzs_customer_business_info_cl;
alter table ${iol_schema}.fzss_mod_fzs_customer_business_info exchange partition p_20991231 with table ${iol_schema}.fzss_mod_fzs_customer_business_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fzss_mod_fzs_customer_business_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_customer_business_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_customer_business_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fzss_mod_fzs_customer_business_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fzss_mod_fzs_customer_business_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
