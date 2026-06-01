/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1wcm_company_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1wcm_company_info
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1wcm_company_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1wcm_company_info(
    company_id varchar2(192) -- 企业ID
    ,company_name varchar2(768) -- 企业名称
    ,company_auth_status varchar2(12) -- 企业认证状态(00-初始化;01-认证成功;02-认证失败;99-认证中)
    ,company_dissolve_status varchar2(12) -- 企业解散状态(00-未解散;01-解散失败;02-解散成功;99-解散中;)
    ,sys_serial_no varchar2(192) -- 企业解散流水号
    ,business_license_type varchar2(12) -- 企业证件类型(01-18位统一社会信用代码的多证合一营业执照;02-非18位统一社会信用代码的其他证件类型)
    ,business_license_no varchar2(192) -- 企业证件号码
    ,company_short_name varchar2(768) -- 企业简称
    ,company_scale varchar2(12) -- 企业规模
    ,company_sector_type varchar2(12) -- 企业行业类型
    ,company_province varchar2(96) -- 企业所在省
    ,company_city varchar2(96) -- 企业所在市
    ,company_region varchar2(96) -- 企业所在区
    ,company_address varchar2(1536) -- 企业详细地址
    ,key_customer_flag varchar2(6) -- 是否重点客户(Y-是;N-否)
    ,parent_company_id varchar2(192) -- 上级企业ID
    ,company_level_path varchar2(3072) -- 企业层级路径
    ,company_level_type varchar2(12) -- 企业等级分类(1-一级企业;2-二级企业;3-三级企业;4-四级企业)
    ,bank_branch_no varchar2(192) -- 银行机构编号
    ,super_admin_employee_id varchar2(192) -- 超管员工ID
    ,legal_name varchar2(192) -- 法人姓名
    ,legal_cert_type varchar2(12) -- 法人证件类型 (01-居民身份证;02-中国护照;03-港澳居民来往内地通行证;04-港澳居民居住证;05-台湾居民来往大陆通行证;06-台湾居民居住证;07-外国护照;08-外国人永久居留身份证;09-外国人工作许可证(A类);10-外国人工作许可证(B类);11-外国人工作许可证(C类))
    ,legal_cert_no varchar2(192) -- 法人证件号码
    ,customer_type varchar2(12) -- 客户类型(01-一般企业;02-金融机构;03-政府机构;04-事业单位;05-个体工商户;06-其他)
    ,bank_customer_manager_id varchar2(192) -- 银行客户经理编号
    ,fee_flag varchar2(6) -- 是否收取手续费(Y-是；N否)
    ,salary_service_fee_rule_id varchar2(192) -- 代发手续费规则ID
    ,auth_type varchar2(12) -- 认证类型(01-人工认证审核;02-企业网银认证;03-电子营业执照认证)
    ,auth_submit_timestamp varchar2(144) -- 提交认证时间戳
    ,auth_first_succ_timestamp varchar2(144) -- 首次认证成功时间戳
    ,allow_employee_search_flag varchar2(6) -- 是否允许员工搜索到企业(Y-是;N-否)
    ,allow_company_association_flag varchar2(6) -- 是否允许其他企业关联(Y-是;N-否)
    ,auth_fail_reason varchar2(1536) -- 认证失败原因
    ,legal_cert_front_path varchar2(1536) -- 法人证件图片正面路径
    ,legal_cert_back_path varchar2(1536) -- 法人证件图片背面路径
    ,legal_cert_other_path varchar2(3072) -- 法人证件图片其他面路径
    ,company_logo_path varchar2(1536) -- 企业LOGO图片路径
    ,business_license_image_path varchar2(1536) -- 营业执照图片路径
    ,create_timestamp varchar2(144) -- 创建时间戳
    ,update_timestamp varchar2(144) -- 更新时间戳
    ,enable_status varchar2(6) -- 停启用状态(0-启用;1-停用)
    ,auth_submit_employee_id varchar2(192) -- 认证提交人ID
    ,batch_id varchar2(192) -- 批次ID
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
grant select on ${iol_schema}.mpcs_a1wcm_company_info to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1wcm_company_info to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1wcm_company_info to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1wcm_company_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1wcm_company_info is '企业信息表';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_id is '企业ID';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_name is '企业名称';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_auth_status is '企业认证状态(00-初始化;01-认证成功;02-认证失败;99-认证中)';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_dissolve_status is '企业解散状态(00-未解散;01-解散失败;02-解散成功;99-解散中;)';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.sys_serial_no is '企业解散流水号';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.business_license_type is '企业证件类型(01-18位统一社会信用代码的多证合一营业执照;02-非18位统一社会信用代码的其他证件类型)';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.business_license_no is '企业证件号码';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_short_name is '企业简称';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_scale is '企业规模';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_sector_type is '企业行业类型';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_province is '企业所在省';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_city is '企业所在市';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_region is '企业所在区';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_address is '企业详细地址';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.key_customer_flag is '是否重点客户(Y-是;N-否)';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.parent_company_id is '上级企业ID';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_level_path is '企业层级路径';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_level_type is '企业等级分类(1-一级企业;2-二级企业;3-三级企业;4-四级企业)';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.bank_branch_no is '银行机构编号';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.super_admin_employee_id is '超管员工ID';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.legal_name is '法人姓名';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.legal_cert_type is '法人证件类型 (01-居民身份证;02-中国护照;03-港澳居民来往内地通行证;04-港澳居民居住证;05-台湾居民来往大陆通行证;06-台湾居民居住证;07-外国护照;08-外国人永久居留身份证;09-外国人工作许可证(A类);10-外国人工作许可证(B类);11-外国人工作许可证(C类))';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.legal_cert_no is '法人证件号码';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.customer_type is '客户类型(01-一般企业;02-金融机构;03-政府机构;04-事业单位;05-个体工商户;06-其他)';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.bank_customer_manager_id is '银行客户经理编号';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.fee_flag is '是否收取手续费(Y-是；N否)';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.salary_service_fee_rule_id is '代发手续费规则ID';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.auth_type is '认证类型(01-人工认证审核;02-企业网银认证;03-电子营业执照认证)';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.auth_submit_timestamp is '提交认证时间戳';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.auth_first_succ_timestamp is '首次认证成功时间戳';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.allow_employee_search_flag is '是否允许员工搜索到企业(Y-是;N-否)';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.allow_company_association_flag is '是否允许其他企业关联(Y-是;N-否)';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.auth_fail_reason is '认证失败原因';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.legal_cert_front_path is '法人证件图片正面路径';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.legal_cert_back_path is '法人证件图片背面路径';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.legal_cert_other_path is '法人证件图片其他面路径';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.company_logo_path is '企业LOGO图片路径';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.business_license_image_path is '营业执照图片路径';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.enable_status is '停启用状态(0-启用;1-停用)';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.auth_submit_employee_id is '认证提交人ID';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.batch_id is '批次ID';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1wcm_company_info.etl_timestamp is 'ETL处理时间戳';
