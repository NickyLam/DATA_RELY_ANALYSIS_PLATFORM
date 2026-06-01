/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_bth_wft_cms_merchant
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
create table ${iol_schema}.mrms_bth_wft_cms_merchant_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_bth_wft_cms_merchant
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_bth_wft_cms_merchant_op purge;
drop table ${iol_schema}.mrms_bth_wft_cms_merchant_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_bth_wft_cms_merchant_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_bth_wft_cms_merchant where 0=1;

create table ${iol_schema}.mrms_bth_wft_cms_merchant_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_bth_wft_cms_merchant where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_bth_wft_cms_merchant_cl(
            merchant -- 商户编号
            ,merchant_name -- 商户名称
            ,branch_no -- 威富通机构编号
            ,branch_name -- 威富通机构名称
            ,merchant_type -- 商户类型:大商户,普通商户,直营商户,加盟商户
            ,company_id_type -- 企业证件类型:统一社会信用代码证号,营业执照
            ,company_id -- 企业证件号码
            ,company_id_start_date -- 企业证件有效期开始日
            ,company_id_end_date -- 企业证件有效期结束日
            ,business_scope -- 经营范围
            ,register_address -- 注册地址
            ,legal_representative_name -- 法定代表人姓名
            ,legal_representative_sex -- 法定代表人性别:男，女
            ,legal_representative_id_type -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,legal_representative_id -- 法定代表人证件号码
            ,legal_representative_id_start_date -- 法定代表人证件有效期开始日
            ,legal_representative_id_end_date -- 法定代表人证件有效期到期日
            ,legal_representative_phone -- 法定代表人手机号码
            ,beneficial_owner_name -- 受益所有人姓名
            ,beneficial_owner_id_type -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,beneficial_owner_id -- 受益所有人证件号码
            ,beneficial_owner_id_start_date -- 受益所有人证件有效期开始日
            ,beneficial_owner_id_end_date -- 受益所有人证件有效期到期日
            ,beneficial_owner_address -- 受益所有人详细地址
            ,control_shareholder_name -- 控股股东名称
            ,control_shareholder_id_type -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,control_shareholder_id -- 控股股东证件号码
            ,control_shareholder_id_start_date -- 控股股东证件有效期起始日
            ,control_shareholder_id_end_date -- 控股股东证件有效期到期日
            ,author_agent_name -- 授权办理人姓名
            ,author_agent_id_type -- 授权办理人证件类型
            ,author_agent_id -- 授权办理人证件号码
            ,author_agent_id_start_date -- 授权办理人证件有效期起始日
            ,author_agent_id_end_date -- 授权办理人证件有效期到期日
            ,company_id_type_value -- 企业证件类:统一社会信用代码证号,营业执照
            ,legal_representative_sex_value -- 法定代表人性别:男:1,女:2,未知的性别:0,未说明的性别:9
            ,legal_representative_id_type_value -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,beneficial_owner_id_type_value -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,control_shareholder_id_type_value -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,author_agent_id_type_value -- 授权办理人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,ghbank_branch_no -- 华兴银行机构编号
            ,ghbank_branch_name -- 华兴银行机构全称
            ,merchant_okfile -- 商户信息OK文件
            ,merchant_txtfile -- 商户信息明细文件
            ,remark1 -- 商户审核状态:未审核,审核通过,审核不通过,需再次审核
            ,remark2 -- 商户激活状态:未激活,激活成功,激活失败,需再次激活,冻结,注销
            ,remark3 -- 备注3
            ,remark4 -- 备注4
            ,remark5 -- 备注5
            ,remark6 -- 备注6
            ,remark7 -- 备注7
            ,remark8 -- 备注8
            ,create_date -- 创建时间:timestamp(yyyy-MM-dd HH24MiSS)
            ,update_date -- 更新时间:timestamp(yyyy-MM-dd HH24MiSS)
            ,settle_accno_name -- 结算账户名称
            ,settle_accno_type -- 结算账户类型
            ,settle_bank_name -- 结算账户开户行
            ,settle_accno -- 结算账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_bth_wft_cms_merchant_op(
            merchant -- 商户编号
            ,merchant_name -- 商户名称
            ,branch_no -- 威富通机构编号
            ,branch_name -- 威富通机构名称
            ,merchant_type -- 商户类型:大商户,普通商户,直营商户,加盟商户
            ,company_id_type -- 企业证件类型:统一社会信用代码证号,营业执照
            ,company_id -- 企业证件号码
            ,company_id_start_date -- 企业证件有效期开始日
            ,company_id_end_date -- 企业证件有效期结束日
            ,business_scope -- 经营范围
            ,register_address -- 注册地址
            ,legal_representative_name -- 法定代表人姓名
            ,legal_representative_sex -- 法定代表人性别:男，女
            ,legal_representative_id_type -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,legal_representative_id -- 法定代表人证件号码
            ,legal_representative_id_start_date -- 法定代表人证件有效期开始日
            ,legal_representative_id_end_date -- 法定代表人证件有效期到期日
            ,legal_representative_phone -- 法定代表人手机号码
            ,beneficial_owner_name -- 受益所有人姓名
            ,beneficial_owner_id_type -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,beneficial_owner_id -- 受益所有人证件号码
            ,beneficial_owner_id_start_date -- 受益所有人证件有效期开始日
            ,beneficial_owner_id_end_date -- 受益所有人证件有效期到期日
            ,beneficial_owner_address -- 受益所有人详细地址
            ,control_shareholder_name -- 控股股东名称
            ,control_shareholder_id_type -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,control_shareholder_id -- 控股股东证件号码
            ,control_shareholder_id_start_date -- 控股股东证件有效期起始日
            ,control_shareholder_id_end_date -- 控股股东证件有效期到期日
            ,author_agent_name -- 授权办理人姓名
            ,author_agent_id_type -- 授权办理人证件类型
            ,author_agent_id -- 授权办理人证件号码
            ,author_agent_id_start_date -- 授权办理人证件有效期起始日
            ,author_agent_id_end_date -- 授权办理人证件有效期到期日
            ,company_id_type_value -- 企业证件类:统一社会信用代码证号,营业执照
            ,legal_representative_sex_value -- 法定代表人性别:男:1,女:2,未知的性别:0,未说明的性别:9
            ,legal_representative_id_type_value -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,beneficial_owner_id_type_value -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,control_shareholder_id_type_value -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,author_agent_id_type_value -- 授权办理人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,ghbank_branch_no -- 华兴银行机构编号
            ,ghbank_branch_name -- 华兴银行机构全称
            ,merchant_okfile -- 商户信息OK文件
            ,merchant_txtfile -- 商户信息明细文件
            ,remark1 -- 商户审核状态:未审核,审核通过,审核不通过,需再次审核
            ,remark2 -- 商户激活状态:未激活,激活成功,激活失败,需再次激活,冻结,注销
            ,remark3 -- 备注3
            ,remark4 -- 备注4
            ,remark5 -- 备注5
            ,remark6 -- 备注6
            ,remark7 -- 备注7
            ,remark8 -- 备注8
            ,create_date -- 创建时间:timestamp(yyyy-MM-dd HH24MiSS)
            ,update_date -- 更新时间:timestamp(yyyy-MM-dd HH24MiSS)
            ,settle_accno_name -- 结算账户名称
            ,settle_accno_type -- 结算账户类型
            ,settle_bank_name -- 结算账户开户行
            ,settle_accno -- 结算账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.merchant, o.merchant) as merchant -- 商户编号
    ,nvl(n.merchant_name, o.merchant_name) as merchant_name -- 商户名称
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 威富通机构编号
    ,nvl(n.branch_name, o.branch_name) as branch_name -- 威富通机构名称
    ,nvl(n.merchant_type, o.merchant_type) as merchant_type -- 商户类型:大商户,普通商户,直营商户,加盟商户
    ,nvl(n.company_id_type, o.company_id_type) as company_id_type -- 企业证件类型:统一社会信用代码证号,营业执照
    ,nvl(n.company_id, o.company_id) as company_id -- 企业证件号码
    ,nvl(n.company_id_start_date, o.company_id_start_date) as company_id_start_date -- 企业证件有效期开始日
    ,nvl(n.company_id_end_date, o.company_id_end_date) as company_id_end_date -- 企业证件有效期结束日
    ,nvl(n.business_scope, o.business_scope) as business_scope -- 经营范围
    ,nvl(n.register_address, o.register_address) as register_address -- 注册地址
    ,nvl(n.legal_representative_name, o.legal_representative_name) as legal_representative_name -- 法定代表人姓名
    ,nvl(n.legal_representative_sex, o.legal_representative_sex) as legal_representative_sex -- 法定代表人性别:男，女
    ,nvl(n.legal_representative_id_type, o.legal_representative_id_type) as legal_representative_id_type -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,nvl(n.legal_representative_id, o.legal_representative_id) as legal_representative_id -- 法定代表人证件号码
    ,nvl(n.legal_representative_id_start_date, o.legal_representative_id_start_date) as legal_representative_id_start_date -- 法定代表人证件有效期开始日
    ,nvl(n.legal_representative_id_end_date, o.legal_representative_id_end_date) as legal_representative_id_end_date -- 法定代表人证件有效期到期日
    ,nvl(n.legal_representative_phone, o.legal_representative_phone) as legal_representative_phone -- 法定代表人手机号码
    ,nvl(n.beneficial_owner_name, o.beneficial_owner_name) as beneficial_owner_name -- 受益所有人姓名
    ,nvl(n.beneficial_owner_id_type, o.beneficial_owner_id_type) as beneficial_owner_id_type -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,nvl(n.beneficial_owner_id, o.beneficial_owner_id) as beneficial_owner_id -- 受益所有人证件号码
    ,nvl(n.beneficial_owner_id_start_date, o.beneficial_owner_id_start_date) as beneficial_owner_id_start_date -- 受益所有人证件有效期开始日
    ,nvl(n.beneficial_owner_id_end_date, o.beneficial_owner_id_end_date) as beneficial_owner_id_end_date -- 受益所有人证件有效期到期日
    ,nvl(n.beneficial_owner_address, o.beneficial_owner_address) as beneficial_owner_address -- 受益所有人详细地址
    ,nvl(n.control_shareholder_name, o.control_shareholder_name) as control_shareholder_name -- 控股股东名称
    ,nvl(n.control_shareholder_id_type, o.control_shareholder_id_type) as control_shareholder_id_type -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,nvl(n.control_shareholder_id, o.control_shareholder_id) as control_shareholder_id -- 控股股东证件号码
    ,nvl(n.control_shareholder_id_start_date, o.control_shareholder_id_start_date) as control_shareholder_id_start_date -- 控股股东证件有效期起始日
    ,nvl(n.control_shareholder_id_end_date, o.control_shareholder_id_end_date) as control_shareholder_id_end_date -- 控股股东证件有效期到期日
    ,nvl(n.author_agent_name, o.author_agent_name) as author_agent_name -- 授权办理人姓名
    ,nvl(n.author_agent_id_type, o.author_agent_id_type) as author_agent_id_type -- 授权办理人证件类型
    ,nvl(n.author_agent_id, o.author_agent_id) as author_agent_id -- 授权办理人证件号码
    ,nvl(n.author_agent_id_start_date, o.author_agent_id_start_date) as author_agent_id_start_date -- 授权办理人证件有效期起始日
    ,nvl(n.author_agent_id_end_date, o.author_agent_id_end_date) as author_agent_id_end_date -- 授权办理人证件有效期到期日
    ,nvl(n.company_id_type_value, o.company_id_type_value) as company_id_type_value -- 企业证件类:统一社会信用代码证号,营业执照
    ,nvl(n.legal_representative_sex_value, o.legal_representative_sex_value) as legal_representative_sex_value -- 法定代表人性别:男:1,女:2,未知的性别:0,未说明的性别:9
    ,nvl(n.legal_representative_id_type_value, o.legal_representative_id_type_value) as legal_representative_id_type_value -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,nvl(n.beneficial_owner_id_type_value, o.beneficial_owner_id_type_value) as beneficial_owner_id_type_value -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,nvl(n.control_shareholder_id_type_value, o.control_shareholder_id_type_value) as control_shareholder_id_type_value -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,nvl(n.author_agent_id_type_value, o.author_agent_id_type_value) as author_agent_id_type_value -- 授权办理人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,nvl(n.ghbank_branch_no, o.ghbank_branch_no) as ghbank_branch_no -- 华兴银行机构编号
    ,nvl(n.ghbank_branch_name, o.ghbank_branch_name) as ghbank_branch_name -- 华兴银行机构全称
    ,nvl(n.merchant_okfile, o.merchant_okfile) as merchant_okfile -- 商户信息OK文件
    ,nvl(n.merchant_txtfile, o.merchant_txtfile) as merchant_txtfile -- 商户信息明细文件
    ,nvl(n.remark1, o.remark1) as remark1 -- 商户审核状态:未审核,审核通过,审核不通过,需再次审核
    ,nvl(n.remark2, o.remark2) as remark2 -- 商户激活状态:未激活,激活成功,激活失败,需再次激活,冻结,注销
    ,nvl(n.remark3, o.remark3) as remark3 -- 备注3
    ,nvl(n.remark4, o.remark4) as remark4 -- 备注4
    ,nvl(n.remark5, o.remark5) as remark5 -- 备注5
    ,nvl(n.remark6, o.remark6) as remark6 -- 备注6
    ,nvl(n.remark7, o.remark7) as remark7 -- 备注7
    ,nvl(n.remark8, o.remark8) as remark8 -- 备注8
    ,nvl(n.create_date, o.create_date) as create_date -- 创建时间:timestamp(yyyy-MM-dd HH24MiSS)
    ,nvl(n.update_date, o.update_date) as update_date -- 更新时间:timestamp(yyyy-MM-dd HH24MiSS)
    ,nvl(n.settle_accno_name, o.settle_accno_name) as settle_accno_name -- 结算账户名称
    ,nvl(n.settle_accno_type, o.settle_accno_type) as settle_accno_type -- 结算账户类型
    ,nvl(n.settle_bank_name, o.settle_bank_name) as settle_bank_name -- 结算账户开户行
    ,nvl(n.settle_accno, o.settle_accno) as settle_accno -- 结算账号
    ,case when
            n.merchant is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.merchant is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.merchant is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_bth_wft_cms_merchant_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_bth_wft_cms_merchant where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.merchant = n.merchant
where (
        o.merchant is null
    )
    or (
        n.merchant is null
    )
    or (
        o.merchant_name <> n.merchant_name
        or o.branch_no <> n.branch_no
        or o.branch_name <> n.branch_name
        or o.merchant_type <> n.merchant_type
        or o.company_id_type <> n.company_id_type
        or o.company_id <> n.company_id
        or o.company_id_start_date <> n.company_id_start_date
        or o.company_id_end_date <> n.company_id_end_date
        or o.business_scope <> n.business_scope
        or o.register_address <> n.register_address
        or o.legal_representative_name <> n.legal_representative_name
        or o.legal_representative_sex <> n.legal_representative_sex
        or o.legal_representative_id_type <> n.legal_representative_id_type
        or o.legal_representative_id <> n.legal_representative_id
        or o.legal_representative_id_start_date <> n.legal_representative_id_start_date
        or o.legal_representative_id_end_date <> n.legal_representative_id_end_date
        or o.legal_representative_phone <> n.legal_representative_phone
        or o.beneficial_owner_name <> n.beneficial_owner_name
        or o.beneficial_owner_id_type <> n.beneficial_owner_id_type
        or o.beneficial_owner_id <> n.beneficial_owner_id
        or o.beneficial_owner_id_start_date <> n.beneficial_owner_id_start_date
        or o.beneficial_owner_id_end_date <> n.beneficial_owner_id_end_date
        or o.beneficial_owner_address <> n.beneficial_owner_address
        or o.control_shareholder_name <> n.control_shareholder_name
        or o.control_shareholder_id_type <> n.control_shareholder_id_type
        or o.control_shareholder_id <> n.control_shareholder_id
        or o.control_shareholder_id_start_date <> n.control_shareholder_id_start_date
        or o.control_shareholder_id_end_date <> n.control_shareholder_id_end_date
        or o.author_agent_name <> n.author_agent_name
        or o.author_agent_id_type <> n.author_agent_id_type
        or o.author_agent_id <> n.author_agent_id
        or o.author_agent_id_start_date <> n.author_agent_id_start_date
        or o.author_agent_id_end_date <> n.author_agent_id_end_date
        or o.company_id_type_value <> n.company_id_type_value
        or o.legal_representative_sex_value <> n.legal_representative_sex_value
        or o.legal_representative_id_type_value <> n.legal_representative_id_type_value
        or o.beneficial_owner_id_type_value <> n.beneficial_owner_id_type_value
        or o.control_shareholder_id_type_value <> n.control_shareholder_id_type_value
        or o.author_agent_id_type_value <> n.author_agent_id_type_value
        or o.ghbank_branch_no <> n.ghbank_branch_no
        or o.ghbank_branch_name <> n.ghbank_branch_name
        or o.merchant_okfile <> n.merchant_okfile
        or o.merchant_txtfile <> n.merchant_txtfile
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.remark3 <> n.remark3
        or o.remark4 <> n.remark4
        or o.remark5 <> n.remark5
        or o.remark6 <> n.remark6
        or o.remark7 <> n.remark7
        or o.remark8 <> n.remark8
        or o.create_date <> n.create_date
        or o.update_date <> n.update_date
        or o.settle_accno_name <> n.settle_accno_name
        or o.settle_accno_type <> n.settle_accno_type
        or o.settle_bank_name <> n.settle_bank_name
        or o.settle_accno <> n.settle_accno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_bth_wft_cms_merchant_cl(
            merchant -- 商户编号
            ,merchant_name -- 商户名称
            ,branch_no -- 威富通机构编号
            ,branch_name -- 威富通机构名称
            ,merchant_type -- 商户类型:大商户,普通商户,直营商户,加盟商户
            ,company_id_type -- 企业证件类型:统一社会信用代码证号,营业执照
            ,company_id -- 企业证件号码
            ,company_id_start_date -- 企业证件有效期开始日
            ,company_id_end_date -- 企业证件有效期结束日
            ,business_scope -- 经营范围
            ,register_address -- 注册地址
            ,legal_representative_name -- 法定代表人姓名
            ,legal_representative_sex -- 法定代表人性别:男，女
            ,legal_representative_id_type -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,legal_representative_id -- 法定代表人证件号码
            ,legal_representative_id_start_date -- 法定代表人证件有效期开始日
            ,legal_representative_id_end_date -- 法定代表人证件有效期到期日
            ,legal_representative_phone -- 法定代表人手机号码
            ,beneficial_owner_name -- 受益所有人姓名
            ,beneficial_owner_id_type -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,beneficial_owner_id -- 受益所有人证件号码
            ,beneficial_owner_id_start_date -- 受益所有人证件有效期开始日
            ,beneficial_owner_id_end_date -- 受益所有人证件有效期到期日
            ,beneficial_owner_address -- 受益所有人详细地址
            ,control_shareholder_name -- 控股股东名称
            ,control_shareholder_id_type -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,control_shareholder_id -- 控股股东证件号码
            ,control_shareholder_id_start_date -- 控股股东证件有效期起始日
            ,control_shareholder_id_end_date -- 控股股东证件有效期到期日
            ,author_agent_name -- 授权办理人姓名
            ,author_agent_id_type -- 授权办理人证件类型
            ,author_agent_id -- 授权办理人证件号码
            ,author_agent_id_start_date -- 授权办理人证件有效期起始日
            ,author_agent_id_end_date -- 授权办理人证件有效期到期日
            ,company_id_type_value -- 企业证件类:统一社会信用代码证号,营业执照
            ,legal_representative_sex_value -- 法定代表人性别:男:1,女:2,未知的性别:0,未说明的性别:9
            ,legal_representative_id_type_value -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,beneficial_owner_id_type_value -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,control_shareholder_id_type_value -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,author_agent_id_type_value -- 授权办理人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,ghbank_branch_no -- 华兴银行机构编号
            ,ghbank_branch_name -- 华兴银行机构全称
            ,merchant_okfile -- 商户信息OK文件
            ,merchant_txtfile -- 商户信息明细文件
            ,remark1 -- 商户审核状态:未审核,审核通过,审核不通过,需再次审核
            ,remark2 -- 商户激活状态:未激活,激活成功,激活失败,需再次激活,冻结,注销
            ,remark3 -- 备注3
            ,remark4 -- 备注4
            ,remark5 -- 备注5
            ,remark6 -- 备注6
            ,remark7 -- 备注7
            ,remark8 -- 备注8
            ,create_date -- 创建时间:timestamp(yyyy-MM-dd HH24MiSS)
            ,update_date -- 更新时间:timestamp(yyyy-MM-dd HH24MiSS)
            ,settle_accno_name -- 结算账户名称
            ,settle_accno_type -- 结算账户类型
            ,settle_bank_name -- 结算账户开户行
            ,settle_accno -- 结算账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_bth_wft_cms_merchant_op(
            merchant -- 商户编号
            ,merchant_name -- 商户名称
            ,branch_no -- 威富通机构编号
            ,branch_name -- 威富通机构名称
            ,merchant_type -- 商户类型:大商户,普通商户,直营商户,加盟商户
            ,company_id_type -- 企业证件类型:统一社会信用代码证号,营业执照
            ,company_id -- 企业证件号码
            ,company_id_start_date -- 企业证件有效期开始日
            ,company_id_end_date -- 企业证件有效期结束日
            ,business_scope -- 经营范围
            ,register_address -- 注册地址
            ,legal_representative_name -- 法定代表人姓名
            ,legal_representative_sex -- 法定代表人性别:男，女
            ,legal_representative_id_type -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,legal_representative_id -- 法定代表人证件号码
            ,legal_representative_id_start_date -- 法定代表人证件有效期开始日
            ,legal_representative_id_end_date -- 法定代表人证件有效期到期日
            ,legal_representative_phone -- 法定代表人手机号码
            ,beneficial_owner_name -- 受益所有人姓名
            ,beneficial_owner_id_type -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,beneficial_owner_id -- 受益所有人证件号码
            ,beneficial_owner_id_start_date -- 受益所有人证件有效期开始日
            ,beneficial_owner_id_end_date -- 受益所有人证件有效期到期日
            ,beneficial_owner_address -- 受益所有人详细地址
            ,control_shareholder_name -- 控股股东名称
            ,control_shareholder_id_type -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,control_shareholder_id -- 控股股东证件号码
            ,control_shareholder_id_start_date -- 控股股东证件有效期起始日
            ,control_shareholder_id_end_date -- 控股股东证件有效期到期日
            ,author_agent_name -- 授权办理人姓名
            ,author_agent_id_type -- 授权办理人证件类型
            ,author_agent_id -- 授权办理人证件号码
            ,author_agent_id_start_date -- 授权办理人证件有效期起始日
            ,author_agent_id_end_date -- 授权办理人证件有效期到期日
            ,company_id_type_value -- 企业证件类:统一社会信用代码证号,营业执照
            ,legal_representative_sex_value -- 法定代表人性别:男:1,女:2,未知的性别:0,未说明的性别:9
            ,legal_representative_id_type_value -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,beneficial_owner_id_type_value -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,control_shareholder_id_type_value -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,author_agent_id_type_value -- 授权办理人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,ghbank_branch_no -- 华兴银行机构编号
            ,ghbank_branch_name -- 华兴银行机构全称
            ,merchant_okfile -- 商户信息OK文件
            ,merchant_txtfile -- 商户信息明细文件
            ,remark1 -- 商户审核状态:未审核,审核通过,审核不通过,需再次审核
            ,remark2 -- 商户激活状态:未激活,激活成功,激活失败,需再次激活,冻结,注销
            ,remark3 -- 备注3
            ,remark4 -- 备注4
            ,remark5 -- 备注5
            ,remark6 -- 备注6
            ,remark7 -- 备注7
            ,remark8 -- 备注8
            ,create_date -- 创建时间:timestamp(yyyy-MM-dd HH24MiSS)
            ,update_date -- 更新时间:timestamp(yyyy-MM-dd HH24MiSS)
            ,settle_accno_name -- 结算账户名称
            ,settle_accno_type -- 结算账户类型
            ,settle_bank_name -- 结算账户开户行
            ,settle_accno -- 结算账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.merchant -- 商户编号
    ,o.merchant_name -- 商户名称
    ,o.branch_no -- 威富通机构编号
    ,o.branch_name -- 威富通机构名称
    ,o.merchant_type -- 商户类型:大商户,普通商户,直营商户,加盟商户
    ,o.company_id_type -- 企业证件类型:统一社会信用代码证号,营业执照
    ,o.company_id -- 企业证件号码
    ,o.company_id_start_date -- 企业证件有效期开始日
    ,o.company_id_end_date -- 企业证件有效期结束日
    ,o.business_scope -- 经营范围
    ,o.register_address -- 注册地址
    ,o.legal_representative_name -- 法定代表人姓名
    ,o.legal_representative_sex -- 法定代表人性别:男，女
    ,o.legal_representative_id_type -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,o.legal_representative_id -- 法定代表人证件号码
    ,o.legal_representative_id_start_date -- 法定代表人证件有效期开始日
    ,o.legal_representative_id_end_date -- 法定代表人证件有效期到期日
    ,o.legal_representative_phone -- 法定代表人手机号码
    ,o.beneficial_owner_name -- 受益所有人姓名
    ,o.beneficial_owner_id_type -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,o.beneficial_owner_id -- 受益所有人证件号码
    ,o.beneficial_owner_id_start_date -- 受益所有人证件有效期开始日
    ,o.beneficial_owner_id_end_date -- 受益所有人证件有效期到期日
    ,o.beneficial_owner_address -- 受益所有人详细地址
    ,o.control_shareholder_name -- 控股股东名称
    ,o.control_shareholder_id_type -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,o.control_shareholder_id -- 控股股东证件号码
    ,o.control_shareholder_id_start_date -- 控股股东证件有效期起始日
    ,o.control_shareholder_id_end_date -- 控股股东证件有效期到期日
    ,o.author_agent_name -- 授权办理人姓名
    ,o.author_agent_id_type -- 授权办理人证件类型
    ,o.author_agent_id -- 授权办理人证件号码
    ,o.author_agent_id_start_date -- 授权办理人证件有效期起始日
    ,o.author_agent_id_end_date -- 授权办理人证件有效期到期日
    ,o.company_id_type_value -- 企业证件类:统一社会信用代码证号,营业执照
    ,o.legal_representative_sex_value -- 法定代表人性别:男:1,女:2,未知的性别:0,未说明的性别:9
    ,o.legal_representative_id_type_value -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,o.beneficial_owner_id_type_value -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,o.control_shareholder_id_type_value -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,o.author_agent_id_type_value -- 授权办理人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,o.ghbank_branch_no -- 华兴银行机构编号
    ,o.ghbank_branch_name -- 华兴银行机构全称
    ,o.merchant_okfile -- 商户信息OK文件
    ,o.merchant_txtfile -- 商户信息明细文件
    ,o.remark1 -- 商户审核状态:未审核,审核通过,审核不通过,需再次审核
    ,o.remark2 -- 商户激活状态:未激活,激活成功,激活失败,需再次激活,冻结,注销
    ,o.remark3 -- 备注3
    ,o.remark4 -- 备注4
    ,o.remark5 -- 备注5
    ,o.remark6 -- 备注6
    ,o.remark7 -- 备注7
    ,o.remark8 -- 备注8
    ,o.create_date -- 创建时间:timestamp(yyyy-MM-dd HH24MiSS)
    ,o.update_date -- 更新时间:timestamp(yyyy-MM-dd HH24MiSS)
    ,o.settle_accno_name -- 结算账户名称
    ,o.settle_accno_type -- 结算账户类型
    ,o.settle_bank_name -- 结算账户开户行
    ,o.settle_accno -- 结算账号
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
from ${iol_schema}.mrms_bth_wft_cms_merchant_bk o
    left join ${iol_schema}.mrms_bth_wft_cms_merchant_op n
        on
            o.merchant = n.merchant
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_bth_wft_cms_merchant_cl d
        on
            o.merchant = d.merchant
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mrms_bth_wft_cms_merchant;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mrms_bth_wft_cms_merchant') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mrms_bth_wft_cms_merchant drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mrms_bth_wft_cms_merchant add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mrms_bth_wft_cms_merchant exchange partition p_${batch_date} with table ${iol_schema}.mrms_bth_wft_cms_merchant_cl;
alter table ${iol_schema}.mrms_bth_wft_cms_merchant exchange partition p_20991231 with table ${iol_schema}.mrms_bth_wft_cms_merchant_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_bth_wft_cms_merchant to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_bth_wft_cms_merchant_op purge;
drop table ${iol_schema}.mrms_bth_wft_cms_merchant_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_bth_wft_cms_merchant_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_bth_wft_cms_merchant',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
