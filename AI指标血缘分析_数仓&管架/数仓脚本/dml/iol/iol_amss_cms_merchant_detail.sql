/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cms_merchant_detail
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
create table ${iol_schema}.amss_cms_merchant_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_cms_merchant_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_merchant_detail_op purge;
drop table ${iol_schema}.amss_cms_merchant_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_merchant_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_merchant_detail where 0=1;

create table ${iol_schema}.amss_cms_merchant_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_merchant_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_merchant_detail_cl(
            merchant_detail_id -- 商户详细信息ID.使用 商户编号 做商户详细信息的ID
            ,merchant_short_name -- 商户简称.
            ,industr_id -- 行业类别.关联行业类别表
            ,province -- 省份.
            ,city -- 城市.
            ,county -- 区/县.
            ,address -- 地址.
            ,tel -- 电话.
            ,email -- 邮箱.
            ,web_site -- 网址.
            ,principal -- 负责人.
            ,id_code -- 负责人身份证.
            ,principal_mobile -- 负责人手机.
            ,customer_phone -- 客服电话.
            ,fax -- 传真.
            ,license_photo -- 营业执照.
            ,indentity_photo -- 身份证照片.
            ,protocol_photo -- 商户协议照片.
            ,org_photo -- 组织机构代码证照片.
            ,other_doc -- 其他资料.资料包，以zip和rar格式上传和下载
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
            ,remark -- 备注.
            ,fld_s1 -- 门头照路径
            ,fld_s2 -- 营业执照注册号/统一社会信用代码图片路径
            ,fld_s3 -- 营业场所照片路径
            ,fld_n1 -- 性别
            ,fld_n2 -- (subjectType)商户主体类型
            ,fld_n3 -- 数值型保留字段3.
            ,fld_d1 -- 日期型保留字段1.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,interface_refund_audit -- 接口退款审核
            ,id_code_type -- 证件类型
            ,business_license_name -- 营业执照名称
            ,account_code_photo -- 银行卡/开户许可证图片路径
            ,fld_n4 -- (fixedPlace)小微商户是否有固定经营场所
            ,fld_n5 -- 注册资本金
            ,fld_n6 -- 
            ,fld_n7 -- 
            ,fld_n8 -- 
            ,fld_s4 -- (alipayAccount)保存支付宝账号
            ,fld_s5 -- (contacts)保存联系人
            ,fld_s6 -- (businessScope)经营范围
            ,fld_s7 -- (actualBusinessAddress)实际经营地址
            ,fld_s8 -- (registeredAddress)注册地址
            ,id_code_expire -- 身份证到期日.
            ,business_license_expire -- 营业执照到期日.
            ,lcaddress -- 商户定位地址
            ,questionnaire -- 调查表
            ,approval_form -- 审批表
            ,thi_doc_id -- 第三方文档ID
            ,nationality_num -- 国籍编号
            ,principal_profession -- 负责人职业
            ,id_code_begin_time -- 证件有效期开始时间
            ,business_license_begin_time -- 营业执照有效期开始时间
            ,contacts_idcode -- 联系人证件号码
            ,manage_type -- 经营类型
            ,company_prove -- 单位证明函照片
            ,indoor_photo -- 内景照
            ,checkstand_photo -- 收银台照
            ,manager_principal_photo -- 客户经理与法人合照
            ,register_ip -- 登记ip
            ,icp_number -- ICP备案号
            ,merchant_label -- 商户标签
            ,line_flag -- 条码标识:1公司线，2机构线,3零售线，4数金线
            ,online_verifi_photo -- 联网核查照
            ,sign_photo -- 签名照
            ,protocol_pdf -- 影像平台协议PDF地址
            ,customer_no -- Ecif客户编号
            ,handling_customer_manager_name -- 经办客户经理
            ,handling_customer_manager_id -- 经办客户经理工号
            ,handling_bank_branch -- 经办支行
            ,customer_id -- 客户号
            ,trade_able_hours_begin -- 可交易开始时间
            ,trade_able_hours_end -- 可交易结束时间
            ,points_offer -- 是否积分优惠
            ,support_farmer_station -- 
            ,support_farmer -- 
            ,thi_mch_id -- 第三方商户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_merchant_detail_op(
            merchant_detail_id -- 商户详细信息ID.使用 商户编号 做商户详细信息的ID
            ,merchant_short_name -- 商户简称.
            ,industr_id -- 行业类别.关联行业类别表
            ,province -- 省份.
            ,city -- 城市.
            ,county -- 区/县.
            ,address -- 地址.
            ,tel -- 电话.
            ,email -- 邮箱.
            ,web_site -- 网址.
            ,principal -- 负责人.
            ,id_code -- 负责人身份证.
            ,principal_mobile -- 负责人手机.
            ,customer_phone -- 客服电话.
            ,fax -- 传真.
            ,license_photo -- 营业执照.
            ,indentity_photo -- 身份证照片.
            ,protocol_photo -- 商户协议照片.
            ,org_photo -- 组织机构代码证照片.
            ,other_doc -- 其他资料.资料包，以zip和rar格式上传和下载
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
            ,remark -- 备注.
            ,fld_s1 -- 门头照路径
            ,fld_s2 -- 营业执照注册号/统一社会信用代码图片路径
            ,fld_s3 -- 营业场所照片路径
            ,fld_n1 -- 性别
            ,fld_n2 -- (subjectType)商户主体类型
            ,fld_n3 -- 数值型保留字段3.
            ,fld_d1 -- 日期型保留字段1.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,interface_refund_audit -- 接口退款审核
            ,id_code_type -- 证件类型
            ,business_license_name -- 营业执照名称
            ,account_code_photo -- 银行卡/开户许可证图片路径
            ,fld_n4 -- (fixedPlace)小微商户是否有固定经营场所
            ,fld_n5 -- 注册资本金
            ,fld_n6 -- 
            ,fld_n7 -- 
            ,fld_n8 -- 
            ,fld_s4 -- (alipayAccount)保存支付宝账号
            ,fld_s5 -- (contacts)保存联系人
            ,fld_s6 -- (businessScope)经营范围
            ,fld_s7 -- (actualBusinessAddress)实际经营地址
            ,fld_s8 -- (registeredAddress)注册地址
            ,id_code_expire -- 身份证到期日.
            ,business_license_expire -- 营业执照到期日.
            ,lcaddress -- 商户定位地址
            ,questionnaire -- 调查表
            ,approval_form -- 审批表
            ,thi_doc_id -- 第三方文档ID
            ,nationality_num -- 国籍编号
            ,principal_profession -- 负责人职业
            ,id_code_begin_time -- 证件有效期开始时间
            ,business_license_begin_time -- 营业执照有效期开始时间
            ,contacts_idcode -- 联系人证件号码
            ,manage_type -- 经营类型
            ,company_prove -- 单位证明函照片
            ,indoor_photo -- 内景照
            ,checkstand_photo -- 收银台照
            ,manager_principal_photo -- 客户经理与法人合照
            ,register_ip -- 登记ip
            ,icp_number -- ICP备案号
            ,merchant_label -- 商户标签
            ,line_flag -- 条码标识:1公司线，2机构线,3零售线，4数金线
            ,online_verifi_photo -- 联网核查照
            ,sign_photo -- 签名照
            ,protocol_pdf -- 影像平台协议PDF地址
            ,customer_no -- Ecif客户编号
            ,handling_customer_manager_name -- 经办客户经理
            ,handling_customer_manager_id -- 经办客户经理工号
            ,handling_bank_branch -- 经办支行
            ,customer_id -- 客户号
            ,trade_able_hours_begin -- 可交易开始时间
            ,trade_able_hours_end -- 可交易结束时间
            ,points_offer -- 是否积分优惠
            ,support_farmer_station -- 
            ,support_farmer -- 
            ,thi_mch_id -- 第三方商户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.merchant_detail_id, o.merchant_detail_id) as merchant_detail_id -- 商户详细信息ID.使用 商户编号 做商户详细信息的ID
    ,nvl(n.merchant_short_name, o.merchant_short_name) as merchant_short_name -- 商户简称.
    ,nvl(n.industr_id, o.industr_id) as industr_id -- 行业类别.关联行业类别表
    ,nvl(n.province, o.province) as province -- 省份.
    ,nvl(n.city, o.city) as city -- 城市.
    ,nvl(n.county, o.county) as county -- 区/县.
    ,nvl(n.address, o.address) as address -- 地址.
    ,nvl(n.tel, o.tel) as tel -- 电话.
    ,nvl(n.email, o.email) as email -- 邮箱.
    ,nvl(n.web_site, o.web_site) as web_site -- 网址.
    ,nvl(n.principal, o.principal) as principal -- 负责人.
    ,nvl(n.id_code, o.id_code) as id_code -- 负责人身份证.
    ,nvl(n.principal_mobile, o.principal_mobile) as principal_mobile -- 负责人手机.
    ,nvl(n.customer_phone, o.customer_phone) as customer_phone -- 客服电话.
    ,nvl(n.fax, o.fax) as fax -- 传真.
    ,nvl(n.license_photo, o.license_photo) as license_photo -- 营业执照.
    ,nvl(n.indentity_photo, o.indentity_photo) as indentity_photo -- 身份证照片.
    ,nvl(n.protocol_photo, o.protocol_photo) as protocol_photo -- 商户协议照片.
    ,nvl(n.org_photo, o.org_photo) as org_photo -- 组织机构代码证照片.
    ,nvl(n.other_doc, o.other_doc) as other_doc -- 其他资料.资料包，以zip和rar格式上传和下载
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理标识.1:正常;2:删除
    ,nvl(n.data_source, o.data_source) as data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
    ,nvl(n.remark, o.remark) as remark -- 备注.
    ,nvl(n.fld_s1, o.fld_s1) as fld_s1 -- 门头照路径
    ,nvl(n.fld_s2, o.fld_s2) as fld_s2 -- 营业执照注册号/统一社会信用代码图片路径
    ,nvl(n.fld_s3, o.fld_s3) as fld_s3 -- 营业场所照片路径
    ,nvl(n.fld_n1, o.fld_n1) as fld_n1 -- 性别
    ,nvl(n.fld_n2, o.fld_n2) as fld_n2 -- (subjectType)商户主体类型
    ,nvl(n.fld_n3, o.fld_n3) as fld_n3 -- 数值型保留字段3.
    ,nvl(n.fld_d1, o.fld_d1) as fld_d1 -- 日期型保留字段1.
    ,nvl(n.create_user, o.create_user) as create_user -- 创建用户.
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人.
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间.
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间.
    ,nvl(n.interface_refund_audit, o.interface_refund_audit) as interface_refund_audit -- 接口退款审核
    ,nvl(n.id_code_type, o.id_code_type) as id_code_type -- 证件类型
    ,nvl(n.business_license_name, o.business_license_name) as business_license_name -- 营业执照名称
    ,nvl(n.account_code_photo, o.account_code_photo) as account_code_photo -- 银行卡/开户许可证图片路径
    ,nvl(n.fld_n4, o.fld_n4) as fld_n4 -- (fixedPlace)小微商户是否有固定经营场所
    ,nvl(n.fld_n5, o.fld_n5) as fld_n5 -- 注册资本金
    ,nvl(n.fld_n6, o.fld_n6) as fld_n6 -- 
    ,nvl(n.fld_n7, o.fld_n7) as fld_n7 -- 
    ,nvl(n.fld_n8, o.fld_n8) as fld_n8 -- 
    ,nvl(n.fld_s4, o.fld_s4) as fld_s4 -- (alipayAccount)保存支付宝账号
    ,nvl(n.fld_s5, o.fld_s5) as fld_s5 -- (contacts)保存联系人
    ,nvl(n.fld_s6, o.fld_s6) as fld_s6 -- (businessScope)经营范围
    ,nvl(n.fld_s7, o.fld_s7) as fld_s7 -- (actualBusinessAddress)实际经营地址
    ,nvl(n.fld_s8, o.fld_s8) as fld_s8 -- (registeredAddress)注册地址
    ,nvl(n.id_code_expire, o.id_code_expire) as id_code_expire -- 身份证到期日.
    ,nvl(n.business_license_expire, o.business_license_expire) as business_license_expire -- 营业执照到期日.
    ,nvl(n.lcaddress, o.lcaddress) as lcaddress -- 商户定位地址
    ,nvl(n.questionnaire, o.questionnaire) as questionnaire -- 调查表
    ,nvl(n.approval_form, o.approval_form) as approval_form -- 审批表
    ,nvl(n.thi_doc_id, o.thi_doc_id) as thi_doc_id -- 第三方文档ID
    ,nvl(n.nationality_num, o.nationality_num) as nationality_num -- 国籍编号
    ,nvl(n.principal_profession, o.principal_profession) as principal_profession -- 负责人职业
    ,nvl(n.id_code_begin_time, o.id_code_begin_time) as id_code_begin_time -- 证件有效期开始时间
    ,nvl(n.business_license_begin_time, o.business_license_begin_time) as business_license_begin_time -- 营业执照有效期开始时间
    ,nvl(n.contacts_idcode, o.contacts_idcode) as contacts_idcode -- 联系人证件号码
    ,nvl(n.manage_type, o.manage_type) as manage_type -- 经营类型
    ,nvl(n.company_prove, o.company_prove) as company_prove -- 单位证明函照片
    ,nvl(n.indoor_photo, o.indoor_photo) as indoor_photo -- 内景照
    ,nvl(n.checkstand_photo, o.checkstand_photo) as checkstand_photo -- 收银台照
    ,nvl(n.manager_principal_photo, o.manager_principal_photo) as manager_principal_photo -- 客户经理与法人合照
    ,nvl(n.register_ip, o.register_ip) as register_ip -- 登记ip
    ,nvl(n.icp_number, o.icp_number) as icp_number -- ICP备案号
    ,nvl(n.merchant_label, o.merchant_label) as merchant_label -- 商户标签
    ,nvl(n.line_flag, o.line_flag) as line_flag -- 条码标识:1公司线，2机构线,3零售线，4数金线
    ,nvl(n.online_verifi_photo, o.online_verifi_photo) as online_verifi_photo -- 联网核查照
    ,nvl(n.sign_photo, o.sign_photo) as sign_photo -- 签名照
    ,nvl(n.protocol_pdf, o.protocol_pdf) as protocol_pdf -- 影像平台协议PDF地址
    ,nvl(n.customer_no, o.customer_no) as customer_no -- Ecif客户编号
    ,nvl(n.handling_customer_manager_name, o.handling_customer_manager_name) as handling_customer_manager_name -- 经办客户经理
    ,nvl(n.handling_customer_manager_id, o.handling_customer_manager_id) as handling_customer_manager_id -- 经办客户经理工号
    ,nvl(n.handling_bank_branch, o.handling_bank_branch) as handling_bank_branch -- 经办支行
    ,nvl(n.customer_id, o.customer_id) as customer_id -- 客户号
    ,nvl(n.trade_able_hours_begin, o.trade_able_hours_begin) as trade_able_hours_begin -- 可交易开始时间
    ,nvl(n.trade_able_hours_end, o.trade_able_hours_end) as trade_able_hours_end -- 可交易结束时间
    ,nvl(n.points_offer, o.points_offer) as points_offer -- 是否积分优惠
    ,nvl(n.support_farmer_station, o.support_farmer_station) as support_farmer_station -- 
    ,nvl(n.support_farmer, o.support_farmer) as support_farmer -- 
    ,nvl(n.thi_mch_id, o.thi_mch_id) as thi_mch_id -- 第三方商户号
    ,case when
            n.merchant_detail_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.merchant_detail_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.merchant_detail_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_cms_merchant_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_cms_merchant_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.merchant_detail_id = n.merchant_detail_id
where (
        o.merchant_detail_id is null
    )
    or (
        n.merchant_detail_id is null
    )
    or (
        o.merchant_short_name <> n.merchant_short_name
        or o.industr_id <> n.industr_id
        or o.province <> n.province
        or o.city <> n.city
        or o.county <> n.county
        or o.address <> n.address
        or o.tel <> n.tel
        or o.email <> n.email
        or o.web_site <> n.web_site
        or o.principal <> n.principal
        or o.id_code <> n.id_code
        or o.principal_mobile <> n.principal_mobile
        or o.customer_phone <> n.customer_phone
        or o.fax <> n.fax
        or o.license_photo <> n.license_photo
        or o.indentity_photo <> n.indentity_photo
        or o.protocol_photo <> n.protocol_photo
        or o.org_photo <> n.org_photo
        or o.other_doc <> n.other_doc
        or o.physics_flag <> n.physics_flag
        or o.data_source <> n.data_source
        or o.remark <> n.remark
        or o.fld_s1 <> n.fld_s1
        or o.fld_s2 <> n.fld_s2
        or o.fld_s3 <> n.fld_s3
        or o.fld_n1 <> n.fld_n1
        or o.fld_n2 <> n.fld_n2
        or o.fld_n3 <> n.fld_n3
        or o.fld_d1 <> n.fld_d1
        or o.create_user <> n.create_user
        or o.create_emp <> n.create_emp
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.interface_refund_audit <> n.interface_refund_audit
        or o.id_code_type <> n.id_code_type
        or o.business_license_name <> n.business_license_name
        or o.account_code_photo <> n.account_code_photo
        or o.fld_n4 <> n.fld_n4
        or o.fld_n5 <> n.fld_n5
        or o.fld_n6 <> n.fld_n6
        or o.fld_n7 <> n.fld_n7
        or o.fld_n8 <> n.fld_n8
        or o.fld_s4 <> n.fld_s4
        or o.fld_s5 <> n.fld_s5
        or o.fld_s6 <> n.fld_s6
        or o.fld_s7 <> n.fld_s7
        or o.fld_s8 <> n.fld_s8
        or o.id_code_expire <> n.id_code_expire
        or o.business_license_expire <> n.business_license_expire
        or o.lcaddress <> n.lcaddress
        or o.questionnaire <> n.questionnaire
        or o.approval_form <> n.approval_form
        or o.thi_doc_id <> n.thi_doc_id
        or o.nationality_num <> n.nationality_num
        or o.principal_profession <> n.principal_profession
        or o.id_code_begin_time <> n.id_code_begin_time
        or o.business_license_begin_time <> n.business_license_begin_time
        or o.contacts_idcode <> n.contacts_idcode
        or o.manage_type <> n.manage_type
        or o.company_prove <> n.company_prove
        or o.indoor_photo <> n.indoor_photo
        or o.checkstand_photo <> n.checkstand_photo
        or o.manager_principal_photo <> n.manager_principal_photo
        or o.register_ip <> n.register_ip
        or o.icp_number <> n.icp_number
        or o.merchant_label <> n.merchant_label
        or o.line_flag <> n.line_flag
        or o.online_verifi_photo <> n.online_verifi_photo
        or o.sign_photo <> n.sign_photo
        or o.protocol_pdf <> n.protocol_pdf
        or o.customer_no <> n.customer_no
        or o.handling_customer_manager_name <> n.handling_customer_manager_name
        or o.handling_customer_manager_id <> n.handling_customer_manager_id
        or o.handling_bank_branch <> n.handling_bank_branch
        or o.customer_id <> n.customer_id
        or o.trade_able_hours_begin <> n.trade_able_hours_begin
        or o.trade_able_hours_end <> n.trade_able_hours_end
        or o.points_offer <> n.points_offer
        or o.support_farmer_station <> n.support_farmer_station
        or o.support_farmer <> n.support_farmer
        or o.thi_mch_id <> n.thi_mch_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_merchant_detail_cl(
            merchant_detail_id -- 商户详细信息ID.使用 商户编号 做商户详细信息的ID
            ,merchant_short_name -- 商户简称.
            ,industr_id -- 行业类别.关联行业类别表
            ,province -- 省份.
            ,city -- 城市.
            ,county -- 区/县.
            ,address -- 地址.
            ,tel -- 电话.
            ,email -- 邮箱.
            ,web_site -- 网址.
            ,principal -- 负责人.
            ,id_code -- 负责人身份证.
            ,principal_mobile -- 负责人手机.
            ,customer_phone -- 客服电话.
            ,fax -- 传真.
            ,license_photo -- 营业执照.
            ,indentity_photo -- 身份证照片.
            ,protocol_photo -- 商户协议照片.
            ,org_photo -- 组织机构代码证照片.
            ,other_doc -- 其他资料.资料包，以zip和rar格式上传和下载
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
            ,remark -- 备注.
            ,fld_s1 -- 门头照路径
            ,fld_s2 -- 营业执照注册号/统一社会信用代码图片路径
            ,fld_s3 -- 营业场所照片路径
            ,fld_n1 -- 性别
            ,fld_n2 -- (subjectType)商户主体类型
            ,fld_n3 -- 数值型保留字段3.
            ,fld_d1 -- 日期型保留字段1.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,interface_refund_audit -- 接口退款审核
            ,id_code_type -- 证件类型
            ,business_license_name -- 营业执照名称
            ,account_code_photo -- 银行卡/开户许可证图片路径
            ,fld_n4 -- (fixedPlace)小微商户是否有固定经营场所
            ,fld_n5 -- 注册资本金
            ,fld_n6 -- 
            ,fld_n7 -- 
            ,fld_n8 -- 
            ,fld_s4 -- (alipayAccount)保存支付宝账号
            ,fld_s5 -- (contacts)保存联系人
            ,fld_s6 -- (businessScope)经营范围
            ,fld_s7 -- (actualBusinessAddress)实际经营地址
            ,fld_s8 -- (registeredAddress)注册地址
            ,id_code_expire -- 身份证到期日.
            ,business_license_expire -- 营业执照到期日.
            ,lcaddress -- 商户定位地址
            ,questionnaire -- 调查表
            ,approval_form -- 审批表
            ,thi_doc_id -- 第三方文档ID
            ,nationality_num -- 国籍编号
            ,principal_profession -- 负责人职业
            ,id_code_begin_time -- 证件有效期开始时间
            ,business_license_begin_time -- 营业执照有效期开始时间
            ,contacts_idcode -- 联系人证件号码
            ,manage_type -- 经营类型
            ,company_prove -- 单位证明函照片
            ,indoor_photo -- 内景照
            ,checkstand_photo -- 收银台照
            ,manager_principal_photo -- 客户经理与法人合照
            ,register_ip -- 登记ip
            ,icp_number -- ICP备案号
            ,merchant_label -- 商户标签
            ,line_flag -- 条码标识:1公司线，2机构线,3零售线，4数金线
            ,online_verifi_photo -- 联网核查照
            ,sign_photo -- 签名照
            ,protocol_pdf -- 影像平台协议PDF地址
            ,customer_no -- Ecif客户编号
            ,handling_customer_manager_name -- 经办客户经理
            ,handling_customer_manager_id -- 经办客户经理工号
            ,handling_bank_branch -- 经办支行
            ,customer_id -- 客户号
            ,trade_able_hours_begin -- 可交易开始时间
            ,trade_able_hours_end -- 可交易结束时间
            ,points_offer -- 是否积分优惠
            ,support_farmer_station -- 
            ,support_farmer -- 
            ,thi_mch_id -- 第三方商户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_merchant_detail_op(
            merchant_detail_id -- 商户详细信息ID.使用 商户编号 做商户详细信息的ID
            ,merchant_short_name -- 商户简称.
            ,industr_id -- 行业类别.关联行业类别表
            ,province -- 省份.
            ,city -- 城市.
            ,county -- 区/县.
            ,address -- 地址.
            ,tel -- 电话.
            ,email -- 邮箱.
            ,web_site -- 网址.
            ,principal -- 负责人.
            ,id_code -- 负责人身份证.
            ,principal_mobile -- 负责人手机.
            ,customer_phone -- 客服电话.
            ,fax -- 传真.
            ,license_photo -- 营业执照.
            ,indentity_photo -- 身份证照片.
            ,protocol_photo -- 商户协议照片.
            ,org_photo -- 组织机构代码证照片.
            ,other_doc -- 其他资料.资料包，以zip和rar格式上传和下载
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
            ,remark -- 备注.
            ,fld_s1 -- 门头照路径
            ,fld_s2 -- 营业执照注册号/统一社会信用代码图片路径
            ,fld_s3 -- 营业场所照片路径
            ,fld_n1 -- 性别
            ,fld_n2 -- (subjectType)商户主体类型
            ,fld_n3 -- 数值型保留字段3.
            ,fld_d1 -- 日期型保留字段1.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,interface_refund_audit -- 接口退款审核
            ,id_code_type -- 证件类型
            ,business_license_name -- 营业执照名称
            ,account_code_photo -- 银行卡/开户许可证图片路径
            ,fld_n4 -- (fixedPlace)小微商户是否有固定经营场所
            ,fld_n5 -- 注册资本金
            ,fld_n6 -- 
            ,fld_n7 -- 
            ,fld_n8 -- 
            ,fld_s4 -- (alipayAccount)保存支付宝账号
            ,fld_s5 -- (contacts)保存联系人
            ,fld_s6 -- (businessScope)经营范围
            ,fld_s7 -- (actualBusinessAddress)实际经营地址
            ,fld_s8 -- (registeredAddress)注册地址
            ,id_code_expire -- 身份证到期日.
            ,business_license_expire -- 营业执照到期日.
            ,lcaddress -- 商户定位地址
            ,questionnaire -- 调查表
            ,approval_form -- 审批表
            ,thi_doc_id -- 第三方文档ID
            ,nationality_num -- 国籍编号
            ,principal_profession -- 负责人职业
            ,id_code_begin_time -- 证件有效期开始时间
            ,business_license_begin_time -- 营业执照有效期开始时间
            ,contacts_idcode -- 联系人证件号码
            ,manage_type -- 经营类型
            ,company_prove -- 单位证明函照片
            ,indoor_photo -- 内景照
            ,checkstand_photo -- 收银台照
            ,manager_principal_photo -- 客户经理与法人合照
            ,register_ip -- 登记ip
            ,icp_number -- ICP备案号
            ,merchant_label -- 商户标签
            ,line_flag -- 条码标识:1公司线，2机构线,3零售线，4数金线
            ,online_verifi_photo -- 联网核查照
            ,sign_photo -- 签名照
            ,protocol_pdf -- 影像平台协议PDF地址
            ,customer_no -- Ecif客户编号
            ,handling_customer_manager_name -- 经办客户经理
            ,handling_customer_manager_id -- 经办客户经理工号
            ,handling_bank_branch -- 经办支行
            ,customer_id -- 客户号
            ,trade_able_hours_begin -- 可交易开始时间
            ,trade_able_hours_end -- 可交易结束时间
            ,points_offer -- 是否积分优惠
            ,support_farmer_station -- 
            ,support_farmer -- 
            ,thi_mch_id -- 第三方商户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.merchant_detail_id -- 商户详细信息ID.使用 商户编号 做商户详细信息的ID
    ,o.merchant_short_name -- 商户简称.
    ,o.industr_id -- 行业类别.关联行业类别表
    ,o.province -- 省份.
    ,o.city -- 城市.
    ,o.county -- 区/县.
    ,o.address -- 地址.
    ,o.tel -- 电话.
    ,o.email -- 邮箱.
    ,o.web_site -- 网址.
    ,o.principal -- 负责人.
    ,o.id_code -- 负责人身份证.
    ,o.principal_mobile -- 负责人手机.
    ,o.customer_phone -- 客服电话.
    ,o.fax -- 传真.
    ,o.license_photo -- 营业执照.
    ,o.indentity_photo -- 身份证照片.
    ,o.protocol_photo -- 商户协议照片.
    ,o.org_photo -- 组织机构代码证照片.
    ,o.other_doc -- 其他资料.资料包，以zip和rar格式上传和下载
    ,o.physics_flag -- 物理标识.1:正常;2:删除
    ,o.data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
    ,o.remark -- 备注.
    ,o.fld_s1 -- 门头照路径
    ,o.fld_s2 -- 营业执照注册号/统一社会信用代码图片路径
    ,o.fld_s3 -- 营业场所照片路径
    ,o.fld_n1 -- 性别
    ,o.fld_n2 -- (subjectType)商户主体类型
    ,o.fld_n3 -- 数值型保留字段3.
    ,o.fld_d1 -- 日期型保留字段1.
    ,o.create_user -- 创建用户.
    ,o.create_emp -- 创建人.
    ,o.create_time -- 创建时间.
    ,o.update_time -- 更新时间.
    ,o.interface_refund_audit -- 接口退款审核
    ,o.id_code_type -- 证件类型
    ,o.business_license_name -- 营业执照名称
    ,o.account_code_photo -- 银行卡/开户许可证图片路径
    ,o.fld_n4 -- (fixedPlace)小微商户是否有固定经营场所
    ,o.fld_n5 -- 注册资本金
    ,o.fld_n6 -- 
    ,o.fld_n7 -- 
    ,o.fld_n8 -- 
    ,o.fld_s4 -- (alipayAccount)保存支付宝账号
    ,o.fld_s5 -- (contacts)保存联系人
    ,o.fld_s6 -- (businessScope)经营范围
    ,o.fld_s7 -- (actualBusinessAddress)实际经营地址
    ,o.fld_s8 -- (registeredAddress)注册地址
    ,o.id_code_expire -- 身份证到期日.
    ,o.business_license_expire -- 营业执照到期日.
    ,o.lcaddress -- 商户定位地址
    ,o.questionnaire -- 调查表
    ,o.approval_form -- 审批表
    ,o.thi_doc_id -- 第三方文档ID
    ,o.nationality_num -- 国籍编号
    ,o.principal_profession -- 负责人职业
    ,o.id_code_begin_time -- 证件有效期开始时间
    ,o.business_license_begin_time -- 营业执照有效期开始时间
    ,o.contacts_idcode -- 联系人证件号码
    ,o.manage_type -- 经营类型
    ,o.company_prove -- 单位证明函照片
    ,o.indoor_photo -- 内景照
    ,o.checkstand_photo -- 收银台照
    ,o.manager_principal_photo -- 客户经理与法人合照
    ,o.register_ip -- 登记ip
    ,o.icp_number -- ICP备案号
    ,o.merchant_label -- 商户标签
    ,o.line_flag -- 条码标识:1公司线，2机构线,3零售线，4数金线
    ,o.online_verifi_photo -- 联网核查照
    ,o.sign_photo -- 签名照
    ,o.protocol_pdf -- 影像平台协议PDF地址
    ,o.customer_no -- Ecif客户编号
    ,o.handling_customer_manager_name -- 经办客户经理
    ,o.handling_customer_manager_id -- 经办客户经理工号
    ,o.handling_bank_branch -- 经办支行
    ,o.customer_id -- 客户号
    ,o.trade_able_hours_begin -- 可交易开始时间
    ,o.trade_able_hours_end -- 可交易结束时间
    ,o.points_offer -- 是否积分优惠
    ,o.support_farmer_station -- 
    ,o.support_farmer -- 
    ,o.thi_mch_id -- 第三方商户号
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
from ${iol_schema}.amss_cms_merchant_detail_bk o
    left join ${iol_schema}.amss_cms_merchant_detail_op n
        on
            o.merchant_detail_id = n.merchant_detail_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_cms_merchant_detail_cl d
        on
            o.merchant_detail_id = d.merchant_detail_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_cms_merchant_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_cms_merchant_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_cms_merchant_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_cms_merchant_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_cms_merchant_detail exchange partition p_${batch_date} with table ${iol_schema}.amss_cms_merchant_detail_cl;
alter table ${iol_schema}.amss_cms_merchant_detail exchange partition p_20991231 with table ${iol_schema}.amss_cms_merchant_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_cms_merchant_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_merchant_detail_op purge;
drop table ${iol_schema}.amss_cms_merchant_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_cms_merchant_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_cms_merchant_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
