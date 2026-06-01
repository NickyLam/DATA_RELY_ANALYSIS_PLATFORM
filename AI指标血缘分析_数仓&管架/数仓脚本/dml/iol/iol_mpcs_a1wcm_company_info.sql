/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1wcm_company_info
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
create table ${iol_schema}.mpcs_a1wcm_company_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1wcm_company_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1wcm_company_info_op purge;
drop table ${iol_schema}.mpcs_a1wcm_company_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1wcm_company_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1wcm_company_info where 0=1;

create table ${iol_schema}.mpcs_a1wcm_company_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1wcm_company_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1wcm_company_info_cl(
            company_id -- 企业ID
            ,company_name -- 企业名称
            ,company_auth_status -- 企业认证状态(00-初始化;01-认证成功;02-认证失败;99-认证中)
            ,company_dissolve_status -- 企业解散状态(00-未解散;01-解散失败;02-解散成功;99-解散中;)
            ,sys_serial_no -- 企业解散流水号
            ,business_license_type -- 企业证件类型(01-18位统一社会信用代码的多证合一营业执照;02-非18位统一社会信用代码的其他证件类型)
            ,business_license_no -- 企业证件号码
            ,company_short_name -- 企业简称
            ,company_scale -- 企业规模
            ,company_sector_type -- 企业行业类型
            ,company_province -- 企业所在省
            ,company_city -- 企业所在市
            ,company_region -- 企业所在区
            ,company_address -- 企业详细地址
            ,key_customer_flag -- 是否重点客户(Y-是;N-否)
            ,parent_company_id -- 上级企业ID
            ,company_level_path -- 企业层级路径
            ,company_level_type -- 企业等级分类(1-一级企业;2-二级企业;3-三级企业;4-四级企业)
            ,bank_branch_no -- 银行机构编号
            ,super_admin_employee_id -- 超管员工ID
            ,legal_name -- 法人姓名
            ,legal_cert_type -- 法人证件类型 (01-居民身份证;02-中国护照;03-港澳居民来往内地通行证;04-港澳居民居住证;05-台湾居民来往大陆通行证;06-台湾居民居住证;07-外国护照;08-外国人永久居留身份证;09-外国人工作许可证(A类);10-外国人工作许可证(B类);11-外国人工作许可证(C类))
            ,legal_cert_no -- 法人证件号码
            ,customer_type -- 客户类型(01-一般企业;02-金融机构;03-政府机构;04-事业单位;05-个体工商户;06-其他)
            ,bank_customer_manager_id -- 银行客户经理编号
            ,fee_flag -- 是否收取手续费(Y-是；N否)
            ,salary_service_fee_rule_id -- 代发手续费规则ID
            ,auth_type -- 认证类型(01-人工认证审核;02-企业网银认证;03-电子营业执照认证)
            ,auth_submit_timestamp -- 提交认证时间戳
            ,auth_first_succ_timestamp -- 首次认证成功时间戳
            ,allow_employee_search_flag -- 是否允许员工搜索到企业(Y-是;N-否)
            ,allow_company_association_flag -- 是否允许其他企业关联(Y-是;N-否)
            ,auth_fail_reason -- 认证失败原因
            ,legal_cert_front_path -- 法人证件图片正面路径
            ,legal_cert_back_path -- 法人证件图片背面路径
            ,legal_cert_other_path -- 法人证件图片其他面路径
            ,company_logo_path -- 企业LOGO图片路径
            ,business_license_image_path -- 营业执照图片路径
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,enable_status -- 停启用状态(0-启用;1-停用)
            ,auth_submit_employee_id -- 认证提交人ID
            ,batch_id -- 批次ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1wcm_company_info_op(
            company_id -- 企业ID
            ,company_name -- 企业名称
            ,company_auth_status -- 企业认证状态(00-初始化;01-认证成功;02-认证失败;99-认证中)
            ,company_dissolve_status -- 企业解散状态(00-未解散;01-解散失败;02-解散成功;99-解散中;)
            ,sys_serial_no -- 企业解散流水号
            ,business_license_type -- 企业证件类型(01-18位统一社会信用代码的多证合一营业执照;02-非18位统一社会信用代码的其他证件类型)
            ,business_license_no -- 企业证件号码
            ,company_short_name -- 企业简称
            ,company_scale -- 企业规模
            ,company_sector_type -- 企业行业类型
            ,company_province -- 企业所在省
            ,company_city -- 企业所在市
            ,company_region -- 企业所在区
            ,company_address -- 企业详细地址
            ,key_customer_flag -- 是否重点客户(Y-是;N-否)
            ,parent_company_id -- 上级企业ID
            ,company_level_path -- 企业层级路径
            ,company_level_type -- 企业等级分类(1-一级企业;2-二级企业;3-三级企业;4-四级企业)
            ,bank_branch_no -- 银行机构编号
            ,super_admin_employee_id -- 超管员工ID
            ,legal_name -- 法人姓名
            ,legal_cert_type -- 法人证件类型 (01-居民身份证;02-中国护照;03-港澳居民来往内地通行证;04-港澳居民居住证;05-台湾居民来往大陆通行证;06-台湾居民居住证;07-外国护照;08-外国人永久居留身份证;09-外国人工作许可证(A类);10-外国人工作许可证(B类);11-外国人工作许可证(C类))
            ,legal_cert_no -- 法人证件号码
            ,customer_type -- 客户类型(01-一般企业;02-金融机构;03-政府机构;04-事业单位;05-个体工商户;06-其他)
            ,bank_customer_manager_id -- 银行客户经理编号
            ,fee_flag -- 是否收取手续费(Y-是；N否)
            ,salary_service_fee_rule_id -- 代发手续费规则ID
            ,auth_type -- 认证类型(01-人工认证审核;02-企业网银认证;03-电子营业执照认证)
            ,auth_submit_timestamp -- 提交认证时间戳
            ,auth_first_succ_timestamp -- 首次认证成功时间戳
            ,allow_employee_search_flag -- 是否允许员工搜索到企业(Y-是;N-否)
            ,allow_company_association_flag -- 是否允许其他企业关联(Y-是;N-否)
            ,auth_fail_reason -- 认证失败原因
            ,legal_cert_front_path -- 法人证件图片正面路径
            ,legal_cert_back_path -- 法人证件图片背面路径
            ,legal_cert_other_path -- 法人证件图片其他面路径
            ,company_logo_path -- 企业LOGO图片路径
            ,business_license_image_path -- 营业执照图片路径
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,enable_status -- 停启用状态(0-启用;1-停用)
            ,auth_submit_employee_id -- 认证提交人ID
            ,batch_id -- 批次ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.company_id, o.company_id) as company_id -- 企业ID
    ,nvl(n.company_name, o.company_name) as company_name -- 企业名称
    ,nvl(n.company_auth_status, o.company_auth_status) as company_auth_status -- 企业认证状态(00-初始化;01-认证成功;02-认证失败;99-认证中)
    ,nvl(n.company_dissolve_status, o.company_dissolve_status) as company_dissolve_status -- 企业解散状态(00-未解散;01-解散失败;02-解散成功;99-解散中;)
    ,nvl(n.sys_serial_no, o.sys_serial_no) as sys_serial_no -- 企业解散流水号
    ,nvl(n.business_license_type, o.business_license_type) as business_license_type -- 企业证件类型(01-18位统一社会信用代码的多证合一营业执照;02-非18位统一社会信用代码的其他证件类型)
    ,nvl(n.business_license_no, o.business_license_no) as business_license_no -- 企业证件号码
    ,nvl(n.company_short_name, o.company_short_name) as company_short_name -- 企业简称
    ,nvl(n.company_scale, o.company_scale) as company_scale -- 企业规模
    ,nvl(n.company_sector_type, o.company_sector_type) as company_sector_type -- 企业行业类型
    ,nvl(n.company_province, o.company_province) as company_province -- 企业所在省
    ,nvl(n.company_city, o.company_city) as company_city -- 企业所在市
    ,nvl(n.company_region, o.company_region) as company_region -- 企业所在区
    ,nvl(n.company_address, o.company_address) as company_address -- 企业详细地址
    ,nvl(n.key_customer_flag, o.key_customer_flag) as key_customer_flag -- 是否重点客户(Y-是;N-否)
    ,nvl(n.parent_company_id, o.parent_company_id) as parent_company_id -- 上级企业ID
    ,nvl(n.company_level_path, o.company_level_path) as company_level_path -- 企业层级路径
    ,nvl(n.company_level_type, o.company_level_type) as company_level_type -- 企业等级分类(1-一级企业;2-二级企业;3-三级企业;4-四级企业)
    ,nvl(n.bank_branch_no, o.bank_branch_no) as bank_branch_no -- 银行机构编号
    ,nvl(n.super_admin_employee_id, o.super_admin_employee_id) as super_admin_employee_id -- 超管员工ID
    ,nvl(n.legal_name, o.legal_name) as legal_name -- 法人姓名
    ,nvl(n.legal_cert_type, o.legal_cert_type) as legal_cert_type -- 法人证件类型 (01-居民身份证;02-中国护照;03-港澳居民来往内地通行证;04-港澳居民居住证;05-台湾居民来往大陆通行证;06-台湾居民居住证;07-外国护照;08-外国人永久居留身份证;09-外国人工作许可证(A类);10-外国人工作许可证(B类);11-外国人工作许可证(C类))
    ,nvl(n.legal_cert_no, o.legal_cert_no) as legal_cert_no -- 法人证件号码
    ,nvl(n.customer_type, o.customer_type) as customer_type -- 客户类型(01-一般企业;02-金融机构;03-政府机构;04-事业单位;05-个体工商户;06-其他)
    ,nvl(n.bank_customer_manager_id, o.bank_customer_manager_id) as bank_customer_manager_id -- 银行客户经理编号
    ,nvl(n.fee_flag, o.fee_flag) as fee_flag -- 是否收取手续费(Y-是；N否)
    ,nvl(n.salary_service_fee_rule_id, o.salary_service_fee_rule_id) as salary_service_fee_rule_id -- 代发手续费规则ID
    ,nvl(n.auth_type, o.auth_type) as auth_type -- 认证类型(01-人工认证审核;02-企业网银认证;03-电子营业执照认证)
    ,nvl(n.auth_submit_timestamp, o.auth_submit_timestamp) as auth_submit_timestamp -- 提交认证时间戳
    ,nvl(n.auth_first_succ_timestamp, o.auth_first_succ_timestamp) as auth_first_succ_timestamp -- 首次认证成功时间戳
    ,nvl(n.allow_employee_search_flag, o.allow_employee_search_flag) as allow_employee_search_flag -- 是否允许员工搜索到企业(Y-是;N-否)
    ,nvl(n.allow_company_association_flag, o.allow_company_association_flag) as allow_company_association_flag -- 是否允许其他企业关联(Y-是;N-否)
    ,nvl(n.auth_fail_reason, o.auth_fail_reason) as auth_fail_reason -- 认证失败原因
    ,nvl(n.legal_cert_front_path, o.legal_cert_front_path) as legal_cert_front_path -- 法人证件图片正面路径
    ,nvl(n.legal_cert_back_path, o.legal_cert_back_path) as legal_cert_back_path -- 法人证件图片背面路径
    ,nvl(n.legal_cert_other_path, o.legal_cert_other_path) as legal_cert_other_path -- 法人证件图片其他面路径
    ,nvl(n.company_logo_path, o.company_logo_path) as company_logo_path -- 企业LOGO图片路径
    ,nvl(n.business_license_image_path, o.business_license_image_path) as business_license_image_path -- 营业执照图片路径
    ,nvl(n.create_timestamp, o.create_timestamp) as create_timestamp -- 创建时间戳
    ,nvl(n.update_timestamp, o.update_timestamp) as update_timestamp -- 更新时间戳
    ,nvl(n.enable_status, o.enable_status) as enable_status -- 停启用状态(0-启用;1-停用)
    ,nvl(n.auth_submit_employee_id, o.auth_submit_employee_id) as auth_submit_employee_id -- 认证提交人ID
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批次ID
    ,case when
            n.company_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.company_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.company_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1wcm_company_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1wcm_company_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.company_id = n.company_id
where (
        o.company_id is null
    )
    or (
        n.company_id is null
    )
    or (
        o.company_name <> n.company_name
        or o.company_auth_status <> n.company_auth_status
        or o.company_dissolve_status <> n.company_dissolve_status
        or o.sys_serial_no <> n.sys_serial_no
        or o.business_license_type <> n.business_license_type
        or o.business_license_no <> n.business_license_no
        or o.company_short_name <> n.company_short_name
        or o.company_scale <> n.company_scale
        or o.company_sector_type <> n.company_sector_type
        or o.company_province <> n.company_province
        or o.company_city <> n.company_city
        or o.company_region <> n.company_region
        or o.company_address <> n.company_address
        or o.key_customer_flag <> n.key_customer_flag
        or o.parent_company_id <> n.parent_company_id
        or o.company_level_path <> n.company_level_path
        or o.company_level_type <> n.company_level_type
        or o.bank_branch_no <> n.bank_branch_no
        or o.super_admin_employee_id <> n.super_admin_employee_id
        or o.legal_name <> n.legal_name
        or o.legal_cert_type <> n.legal_cert_type
        or o.legal_cert_no <> n.legal_cert_no
        or o.customer_type <> n.customer_type
        or o.bank_customer_manager_id <> n.bank_customer_manager_id
        or o.fee_flag <> n.fee_flag
        or o.salary_service_fee_rule_id <> n.salary_service_fee_rule_id
        or o.auth_type <> n.auth_type
        or o.auth_submit_timestamp <> n.auth_submit_timestamp
        or o.auth_first_succ_timestamp <> n.auth_first_succ_timestamp
        or o.allow_employee_search_flag <> n.allow_employee_search_flag
        or o.allow_company_association_flag <> n.allow_company_association_flag
        or o.auth_fail_reason <> n.auth_fail_reason
        or o.legal_cert_front_path <> n.legal_cert_front_path
        or o.legal_cert_back_path <> n.legal_cert_back_path
        or o.legal_cert_other_path <> n.legal_cert_other_path
        or o.company_logo_path <> n.company_logo_path
        or o.business_license_image_path <> n.business_license_image_path
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
        or o.enable_status <> n.enable_status
        or o.auth_submit_employee_id <> n.auth_submit_employee_id
        or o.batch_id <> n.batch_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1wcm_company_info_cl(
            company_id -- 企业ID
            ,company_name -- 企业名称
            ,company_auth_status -- 企业认证状态(00-初始化;01-认证成功;02-认证失败;99-认证中)
            ,company_dissolve_status -- 企业解散状态(00-未解散;01-解散失败;02-解散成功;99-解散中;)
            ,sys_serial_no -- 企业解散流水号
            ,business_license_type -- 企业证件类型(01-18位统一社会信用代码的多证合一营业执照;02-非18位统一社会信用代码的其他证件类型)
            ,business_license_no -- 企业证件号码
            ,company_short_name -- 企业简称
            ,company_scale -- 企业规模
            ,company_sector_type -- 企业行业类型
            ,company_province -- 企业所在省
            ,company_city -- 企业所在市
            ,company_region -- 企业所在区
            ,company_address -- 企业详细地址
            ,key_customer_flag -- 是否重点客户(Y-是;N-否)
            ,parent_company_id -- 上级企业ID
            ,company_level_path -- 企业层级路径
            ,company_level_type -- 企业等级分类(1-一级企业;2-二级企业;3-三级企业;4-四级企业)
            ,bank_branch_no -- 银行机构编号
            ,super_admin_employee_id -- 超管员工ID
            ,legal_name -- 法人姓名
            ,legal_cert_type -- 法人证件类型 (01-居民身份证;02-中国护照;03-港澳居民来往内地通行证;04-港澳居民居住证;05-台湾居民来往大陆通行证;06-台湾居民居住证;07-外国护照;08-外国人永久居留身份证;09-外国人工作许可证(A类);10-外国人工作许可证(B类);11-外国人工作许可证(C类))
            ,legal_cert_no -- 法人证件号码
            ,customer_type -- 客户类型(01-一般企业;02-金融机构;03-政府机构;04-事业单位;05-个体工商户;06-其他)
            ,bank_customer_manager_id -- 银行客户经理编号
            ,fee_flag -- 是否收取手续费(Y-是；N否)
            ,salary_service_fee_rule_id -- 代发手续费规则ID
            ,auth_type -- 认证类型(01-人工认证审核;02-企业网银认证;03-电子营业执照认证)
            ,auth_submit_timestamp -- 提交认证时间戳
            ,auth_first_succ_timestamp -- 首次认证成功时间戳
            ,allow_employee_search_flag -- 是否允许员工搜索到企业(Y-是;N-否)
            ,allow_company_association_flag -- 是否允许其他企业关联(Y-是;N-否)
            ,auth_fail_reason -- 认证失败原因
            ,legal_cert_front_path -- 法人证件图片正面路径
            ,legal_cert_back_path -- 法人证件图片背面路径
            ,legal_cert_other_path -- 法人证件图片其他面路径
            ,company_logo_path -- 企业LOGO图片路径
            ,business_license_image_path -- 营业执照图片路径
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,enable_status -- 停启用状态(0-启用;1-停用)
            ,auth_submit_employee_id -- 认证提交人ID
            ,batch_id -- 批次ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1wcm_company_info_op(
            company_id -- 企业ID
            ,company_name -- 企业名称
            ,company_auth_status -- 企业认证状态(00-初始化;01-认证成功;02-认证失败;99-认证中)
            ,company_dissolve_status -- 企业解散状态(00-未解散;01-解散失败;02-解散成功;99-解散中;)
            ,sys_serial_no -- 企业解散流水号
            ,business_license_type -- 企业证件类型(01-18位统一社会信用代码的多证合一营业执照;02-非18位统一社会信用代码的其他证件类型)
            ,business_license_no -- 企业证件号码
            ,company_short_name -- 企业简称
            ,company_scale -- 企业规模
            ,company_sector_type -- 企业行业类型
            ,company_province -- 企业所在省
            ,company_city -- 企业所在市
            ,company_region -- 企业所在区
            ,company_address -- 企业详细地址
            ,key_customer_flag -- 是否重点客户(Y-是;N-否)
            ,parent_company_id -- 上级企业ID
            ,company_level_path -- 企业层级路径
            ,company_level_type -- 企业等级分类(1-一级企业;2-二级企业;3-三级企业;4-四级企业)
            ,bank_branch_no -- 银行机构编号
            ,super_admin_employee_id -- 超管员工ID
            ,legal_name -- 法人姓名
            ,legal_cert_type -- 法人证件类型 (01-居民身份证;02-中国护照;03-港澳居民来往内地通行证;04-港澳居民居住证;05-台湾居民来往大陆通行证;06-台湾居民居住证;07-外国护照;08-外国人永久居留身份证;09-外国人工作许可证(A类);10-外国人工作许可证(B类);11-外国人工作许可证(C类))
            ,legal_cert_no -- 法人证件号码
            ,customer_type -- 客户类型(01-一般企业;02-金融机构;03-政府机构;04-事业单位;05-个体工商户;06-其他)
            ,bank_customer_manager_id -- 银行客户经理编号
            ,fee_flag -- 是否收取手续费(Y-是；N否)
            ,salary_service_fee_rule_id -- 代发手续费规则ID
            ,auth_type -- 认证类型(01-人工认证审核;02-企业网银认证;03-电子营业执照认证)
            ,auth_submit_timestamp -- 提交认证时间戳
            ,auth_first_succ_timestamp -- 首次认证成功时间戳
            ,allow_employee_search_flag -- 是否允许员工搜索到企业(Y-是;N-否)
            ,allow_company_association_flag -- 是否允许其他企业关联(Y-是;N-否)
            ,auth_fail_reason -- 认证失败原因
            ,legal_cert_front_path -- 法人证件图片正面路径
            ,legal_cert_back_path -- 法人证件图片背面路径
            ,legal_cert_other_path -- 法人证件图片其他面路径
            ,company_logo_path -- 企业LOGO图片路径
            ,business_license_image_path -- 营业执照图片路径
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,enable_status -- 停启用状态(0-启用;1-停用)
            ,auth_submit_employee_id -- 认证提交人ID
            ,batch_id -- 批次ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.company_id -- 企业ID
    ,o.company_name -- 企业名称
    ,o.company_auth_status -- 企业认证状态(00-初始化;01-认证成功;02-认证失败;99-认证中)
    ,o.company_dissolve_status -- 企业解散状态(00-未解散;01-解散失败;02-解散成功;99-解散中;)
    ,o.sys_serial_no -- 企业解散流水号
    ,o.business_license_type -- 企业证件类型(01-18位统一社会信用代码的多证合一营业执照;02-非18位统一社会信用代码的其他证件类型)
    ,o.business_license_no -- 企业证件号码
    ,o.company_short_name -- 企业简称
    ,o.company_scale -- 企业规模
    ,o.company_sector_type -- 企业行业类型
    ,o.company_province -- 企业所在省
    ,o.company_city -- 企业所在市
    ,o.company_region -- 企业所在区
    ,o.company_address -- 企业详细地址
    ,o.key_customer_flag -- 是否重点客户(Y-是;N-否)
    ,o.parent_company_id -- 上级企业ID
    ,o.company_level_path -- 企业层级路径
    ,o.company_level_type -- 企业等级分类(1-一级企业;2-二级企业;3-三级企业;4-四级企业)
    ,o.bank_branch_no -- 银行机构编号
    ,o.super_admin_employee_id -- 超管员工ID
    ,o.legal_name -- 法人姓名
    ,o.legal_cert_type -- 法人证件类型 (01-居民身份证;02-中国护照;03-港澳居民来往内地通行证;04-港澳居民居住证;05-台湾居民来往大陆通行证;06-台湾居民居住证;07-外国护照;08-外国人永久居留身份证;09-外国人工作许可证(A类);10-外国人工作许可证(B类);11-外国人工作许可证(C类))
    ,o.legal_cert_no -- 法人证件号码
    ,o.customer_type -- 客户类型(01-一般企业;02-金融机构;03-政府机构;04-事业单位;05-个体工商户;06-其他)
    ,o.bank_customer_manager_id -- 银行客户经理编号
    ,o.fee_flag -- 是否收取手续费(Y-是；N否)
    ,o.salary_service_fee_rule_id -- 代发手续费规则ID
    ,o.auth_type -- 认证类型(01-人工认证审核;02-企业网银认证;03-电子营业执照认证)
    ,o.auth_submit_timestamp -- 提交认证时间戳
    ,o.auth_first_succ_timestamp -- 首次认证成功时间戳
    ,o.allow_employee_search_flag -- 是否允许员工搜索到企业(Y-是;N-否)
    ,o.allow_company_association_flag -- 是否允许其他企业关联(Y-是;N-否)
    ,o.auth_fail_reason -- 认证失败原因
    ,o.legal_cert_front_path -- 法人证件图片正面路径
    ,o.legal_cert_back_path -- 法人证件图片背面路径
    ,o.legal_cert_other_path -- 法人证件图片其他面路径
    ,o.company_logo_path -- 企业LOGO图片路径
    ,o.business_license_image_path -- 营业执照图片路径
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 更新时间戳
    ,o.enable_status -- 停启用状态(0-启用;1-停用)
    ,o.auth_submit_employee_id -- 认证提交人ID
    ,o.batch_id -- 批次ID
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
from ${iol_schema}.mpcs_a1wcm_company_info_bk o
    left join ${iol_schema}.mpcs_a1wcm_company_info_op n
        on
            o.company_id = n.company_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1wcm_company_info_cl d
        on
            o.company_id = d.company_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a1wcm_company_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a1wcm_company_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a1wcm_company_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a1wcm_company_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a1wcm_company_info exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1wcm_company_info_cl;
alter table ${iol_schema}.mpcs_a1wcm_company_info exchange partition p_20991231 with table ${iol_schema}.mpcs_a1wcm_company_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1wcm_company_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1wcm_company_info_op purge;
drop table ${iol_schema}.mpcs_a1wcm_company_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1wcm_company_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1wcm_company_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
