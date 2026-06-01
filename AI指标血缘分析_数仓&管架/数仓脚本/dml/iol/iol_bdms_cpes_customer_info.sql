/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_customer_info
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
create table ${iol_schema}.bdms_cpes_customer_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_customer_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_customer_info_op purge;
drop table ${iol_schema}.bdms_cpes_customer_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_customer_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_customer_info where 0=1;

create table ${iol_schema}.bdms_cpes_customer_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_customer_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_customer_info_cl(
            id -- ID
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,cpp_cust_no -- 贴现通申请人客户号
            ,cpp_cust_name -- 贴现通申请人客户名称
            ,cpp_social_no -- 贴现通申请人社会信用代码
            ,cpp_reg_brh -- 登记机构
            ,cpp_status -- 状态： DRS01 正常 DRS02 失效
            ,cpp_corp_scale -- 规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
            ,cpp_ind_cls -- 行业分类：详见《中国票据交易系统直连接口规范（概述分册）》的Industry
            ,cpp_arc_flag -- 是否涉农企业: 0 否 1 是
            ,cpp_grn_flag -- 是否绿色企业: 0 否 1 是
            ,cpp_sci_flag -- 是否科技企业: 0 否 1 是
            ,cpp_pop_flag -- 是否民营企业: 0 否 1 是
            ,cpp_province -- 省份：参见附录省份代码
            ,cpp_create_date -- 创建日期
            ,src_type -- 来源类型： 00 机构端 01 网银端 02 数据导入
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,cpp_signature -- 中证码
            ,cpp_address -- 住所/地址
            ,cpp_ctgy -- 类型
            ,cpp_corp_type -- 企业所有制形式
            ,cpp_reg_cap -- 注册资本(万元)
            ,cpp_busi_in -- 营业收入(万元)
            ,cpp_yotal_asset -- 资产总额
            ,cpp_employees -- 从业人员(人)
            ,cpp_fctv_date -- 营业期限（自）
            ,cpp_xpry_date -- 营业期限（至）
            ,cpp_busi_scope -- 经营范围
            ,cpp_note -- 企业备注
            ,cpp_agent_name -- 经办人名称
            ,cpp_agent_no -- 经办人身份证号
            ,cpp_agent_tel -- 经办人电话
            ,cpp_agent_email -- 经办人邮箱
            ,cpp_legal_name -- 法定代表人姓名
            ,cpp_legal_nation -- 法定代表人国籍
            ,cpp_doc_type -- 法定代表人证件类型
            ,cpp_legal_no -- 法定代表人证件号码
            ,cpp_legal_doc_date -- 法定代表人证件签发日期
            ,cpp_legal_docdue_date -- 法定代表人证件到期日期
            ,cpp_legal_doc_city -- 法定代表人证件签发城市
            ,cpp_inv_type -- 发票种类
            ,cpp_tax_type -- 纳税人类别
            ,cpp_tax_tel -- 纳税人电话
            ,cpp_tax_bank_name -- 纳税人开户行名
            ,cpp_tax_bank_no -- 纳税人帐号
            ,is_need_inv -- 是否需要开票
            ,cpp_tax_name -- 纳税人名称
            ,cpp_taxer_code -- 纳税人识别号
            ,cpp_taxer_adr -- 纳税人地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_customer_info_op(
            id -- ID
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,cpp_cust_no -- 贴现通申请人客户号
            ,cpp_cust_name -- 贴现通申请人客户名称
            ,cpp_social_no -- 贴现通申请人社会信用代码
            ,cpp_reg_brh -- 登记机构
            ,cpp_status -- 状态： DRS01 正常 DRS02 失效
            ,cpp_corp_scale -- 规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
            ,cpp_ind_cls -- 行业分类：详见《中国票据交易系统直连接口规范（概述分册）》的Industry
            ,cpp_arc_flag -- 是否涉农企业: 0 否 1 是
            ,cpp_grn_flag -- 是否绿色企业: 0 否 1 是
            ,cpp_sci_flag -- 是否科技企业: 0 否 1 是
            ,cpp_pop_flag -- 是否民营企业: 0 否 1 是
            ,cpp_province -- 省份：参见附录省份代码
            ,cpp_create_date -- 创建日期
            ,src_type -- 来源类型： 00 机构端 01 网银端 02 数据导入
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,cpp_signature -- 中证码
            ,cpp_address -- 住所/地址
            ,cpp_ctgy -- 类型
            ,cpp_corp_type -- 企业所有制形式
            ,cpp_reg_cap -- 注册资本(万元)
            ,cpp_busi_in -- 营业收入(万元)
            ,cpp_yotal_asset -- 资产总额
            ,cpp_employees -- 从业人员(人)
            ,cpp_fctv_date -- 营业期限（自）
            ,cpp_xpry_date -- 营业期限（至）
            ,cpp_busi_scope -- 经营范围
            ,cpp_note -- 企业备注
            ,cpp_agent_name -- 经办人名称
            ,cpp_agent_no -- 经办人身份证号
            ,cpp_agent_tel -- 经办人电话
            ,cpp_agent_email -- 经办人邮箱
            ,cpp_legal_name -- 法定代表人姓名
            ,cpp_legal_nation -- 法定代表人国籍
            ,cpp_doc_type -- 法定代表人证件类型
            ,cpp_legal_no -- 法定代表人证件号码
            ,cpp_legal_doc_date -- 法定代表人证件签发日期
            ,cpp_legal_docdue_date -- 法定代表人证件到期日期
            ,cpp_legal_doc_city -- 法定代表人证件签发城市
            ,cpp_inv_type -- 发票种类
            ,cpp_tax_type -- 纳税人类别
            ,cpp_tax_tel -- 纳税人电话
            ,cpp_tax_bank_name -- 纳税人开户行名
            ,cpp_tax_bank_no -- 纳税人帐号
            ,is_need_inv -- 是否需要开票
            ,cpp_tax_name -- 纳税人名称
            ,cpp_taxer_code -- 纳税人识别号
            ,cpp_taxer_adr -- 纳税人地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 机构号
    ,nvl(n.cpp_cust_no, o.cpp_cust_no) as cpp_cust_no -- 贴现通申请人客户号
    ,nvl(n.cpp_cust_name, o.cpp_cust_name) as cpp_cust_name -- 贴现通申请人客户名称
    ,nvl(n.cpp_social_no, o.cpp_social_no) as cpp_social_no -- 贴现通申请人社会信用代码
    ,nvl(n.cpp_reg_brh, o.cpp_reg_brh) as cpp_reg_brh -- 登记机构
    ,nvl(n.cpp_status, o.cpp_status) as cpp_status -- 状态： DRS01 正常 DRS02 失效
    ,nvl(n.cpp_corp_scale, o.cpp_corp_scale) as cpp_corp_scale -- 规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
    ,nvl(n.cpp_ind_cls, o.cpp_ind_cls) as cpp_ind_cls -- 行业分类：详见《中国票据交易系统直连接口规范（概述分册）》的Industry
    ,nvl(n.cpp_arc_flag, o.cpp_arc_flag) as cpp_arc_flag -- 是否涉农企业: 0 否 1 是
    ,nvl(n.cpp_grn_flag, o.cpp_grn_flag) as cpp_grn_flag -- 是否绿色企业: 0 否 1 是
    ,nvl(n.cpp_sci_flag, o.cpp_sci_flag) as cpp_sci_flag -- 是否科技企业: 0 否 1 是
    ,nvl(n.cpp_pop_flag, o.cpp_pop_flag) as cpp_pop_flag -- 是否民营企业: 0 否 1 是
    ,nvl(n.cpp_province, o.cpp_province) as cpp_province -- 省份：参见附录省份代码
    ,nvl(n.cpp_create_date, o.cpp_create_date) as cpp_create_date -- 创建日期
    ,nvl(n.src_type, o.src_type) as src_type -- 来源类型： 00 机构端 01 网银端 02 数据导入
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.cpp_signature, o.cpp_signature) as cpp_signature -- 中证码
    ,nvl(n.cpp_address, o.cpp_address) as cpp_address -- 住所/地址
    ,nvl(n.cpp_ctgy, o.cpp_ctgy) as cpp_ctgy -- 类型
    ,nvl(n.cpp_corp_type, o.cpp_corp_type) as cpp_corp_type -- 企业所有制形式
    ,nvl(n.cpp_reg_cap, o.cpp_reg_cap) as cpp_reg_cap -- 注册资本(万元)
    ,nvl(n.cpp_busi_in, o.cpp_busi_in) as cpp_busi_in -- 营业收入(万元)
    ,nvl(n.cpp_yotal_asset, o.cpp_yotal_asset) as cpp_yotal_asset -- 资产总额
    ,nvl(n.cpp_employees, o.cpp_employees) as cpp_employees -- 从业人员(人)
    ,nvl(n.cpp_fctv_date, o.cpp_fctv_date) as cpp_fctv_date -- 营业期限（自）
    ,nvl(n.cpp_xpry_date, o.cpp_xpry_date) as cpp_xpry_date -- 营业期限（至）
    ,nvl(n.cpp_busi_scope, o.cpp_busi_scope) as cpp_busi_scope -- 经营范围
    ,nvl(n.cpp_note, o.cpp_note) as cpp_note -- 企业备注
    ,nvl(n.cpp_agent_name, o.cpp_agent_name) as cpp_agent_name -- 经办人名称
    ,nvl(n.cpp_agent_no, o.cpp_agent_no) as cpp_agent_no -- 经办人身份证号
    ,nvl(n.cpp_agent_tel, o.cpp_agent_tel) as cpp_agent_tel -- 经办人电话
    ,nvl(n.cpp_agent_email, o.cpp_agent_email) as cpp_agent_email -- 经办人邮箱
    ,nvl(n.cpp_legal_name, o.cpp_legal_name) as cpp_legal_name -- 法定代表人姓名
    ,nvl(n.cpp_legal_nation, o.cpp_legal_nation) as cpp_legal_nation -- 法定代表人国籍
    ,nvl(n.cpp_doc_type, o.cpp_doc_type) as cpp_doc_type -- 法定代表人证件类型
    ,nvl(n.cpp_legal_no, o.cpp_legal_no) as cpp_legal_no -- 法定代表人证件号码
    ,nvl(n.cpp_legal_doc_date, o.cpp_legal_doc_date) as cpp_legal_doc_date -- 法定代表人证件签发日期
    ,nvl(n.cpp_legal_docdue_date, o.cpp_legal_docdue_date) as cpp_legal_docdue_date -- 法定代表人证件到期日期
    ,nvl(n.cpp_legal_doc_city, o.cpp_legal_doc_city) as cpp_legal_doc_city -- 法定代表人证件签发城市
    ,nvl(n.cpp_inv_type, o.cpp_inv_type) as cpp_inv_type -- 发票种类
    ,nvl(n.cpp_tax_type, o.cpp_tax_type) as cpp_tax_type -- 纳税人类别
    ,nvl(n.cpp_tax_tel, o.cpp_tax_tel) as cpp_tax_tel -- 纳税人电话
    ,nvl(n.cpp_tax_bank_name, o.cpp_tax_bank_name) as cpp_tax_bank_name -- 纳税人开户行名
    ,nvl(n.cpp_tax_bank_no, o.cpp_tax_bank_no) as cpp_tax_bank_no -- 纳税人帐号
    ,nvl(n.is_need_inv, o.is_need_inv) as is_need_inv -- 是否需要开票
    ,nvl(n.cpp_tax_name, o.cpp_tax_name) as cpp_tax_name -- 纳税人名称
    ,nvl(n.cpp_taxer_code, o.cpp_taxer_code) as cpp_taxer_code -- 纳税人识别号
    ,nvl(n.cpp_taxer_adr, o.cpp_taxer_adr) as cpp_taxer_adr -- 纳税人地址
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
from (select * from ${iol_schema}.bdms_cpes_customer_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_customer_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.top_branch_no <> n.top_branch_no
        or o.branch_no <> n.branch_no
        or o.cpp_cust_no <> n.cpp_cust_no
        or o.cpp_cust_name <> n.cpp_cust_name
        or o.cpp_social_no <> n.cpp_social_no
        or o.cpp_reg_brh <> n.cpp_reg_brh
        or o.cpp_status <> n.cpp_status
        or o.cpp_corp_scale <> n.cpp_corp_scale
        or o.cpp_ind_cls <> n.cpp_ind_cls
        or o.cpp_arc_flag <> n.cpp_arc_flag
        or o.cpp_grn_flag <> n.cpp_grn_flag
        or o.cpp_sci_flag <> n.cpp_sci_flag
        or o.cpp_pop_flag <> n.cpp_pop_flag
        or o.cpp_province <> n.cpp_province
        or o.cpp_create_date <> n.cpp_create_date
        or o.src_type <> n.src_type
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.cpp_signature <> n.cpp_signature
        or o.cpp_address <> n.cpp_address
        or o.cpp_ctgy <> n.cpp_ctgy
        or o.cpp_corp_type <> n.cpp_corp_type
        or o.cpp_reg_cap <> n.cpp_reg_cap
        or o.cpp_busi_in <> n.cpp_busi_in
        or o.cpp_yotal_asset <> n.cpp_yotal_asset
        or o.cpp_employees <> n.cpp_employees
        or o.cpp_fctv_date <> n.cpp_fctv_date
        or o.cpp_xpry_date <> n.cpp_xpry_date
        or o.cpp_busi_scope <> n.cpp_busi_scope
        or o.cpp_note <> n.cpp_note
        or o.cpp_agent_name <> n.cpp_agent_name
        or o.cpp_agent_no <> n.cpp_agent_no
        or o.cpp_agent_tel <> n.cpp_agent_tel
        or o.cpp_agent_email <> n.cpp_agent_email
        or o.cpp_legal_name <> n.cpp_legal_name
        or o.cpp_legal_nation <> n.cpp_legal_nation
        or o.cpp_doc_type <> n.cpp_doc_type
        or o.cpp_legal_no <> n.cpp_legal_no
        or o.cpp_legal_doc_date <> n.cpp_legal_doc_date
        or o.cpp_legal_docdue_date <> n.cpp_legal_docdue_date
        or o.cpp_legal_doc_city <> n.cpp_legal_doc_city
        or o.cpp_inv_type <> n.cpp_inv_type
        or o.cpp_tax_type <> n.cpp_tax_type
        or o.cpp_tax_tel <> n.cpp_tax_tel
        or o.cpp_tax_bank_name <> n.cpp_tax_bank_name
        or o.cpp_tax_bank_no <> n.cpp_tax_bank_no
        or o.is_need_inv <> n.is_need_inv
        or o.cpp_tax_name <> n.cpp_tax_name
        or o.cpp_taxer_code <> n.cpp_taxer_code
        or o.cpp_taxer_adr <> n.cpp_taxer_adr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_customer_info_cl(
            id -- ID
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,cpp_cust_no -- 贴现通申请人客户号
            ,cpp_cust_name -- 贴现通申请人客户名称
            ,cpp_social_no -- 贴现通申请人社会信用代码
            ,cpp_reg_brh -- 登记机构
            ,cpp_status -- 状态： DRS01 正常 DRS02 失效
            ,cpp_corp_scale -- 规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
            ,cpp_ind_cls -- 行业分类：详见《中国票据交易系统直连接口规范（概述分册）》的Industry
            ,cpp_arc_flag -- 是否涉农企业: 0 否 1 是
            ,cpp_grn_flag -- 是否绿色企业: 0 否 1 是
            ,cpp_sci_flag -- 是否科技企业: 0 否 1 是
            ,cpp_pop_flag -- 是否民营企业: 0 否 1 是
            ,cpp_province -- 省份：参见附录省份代码
            ,cpp_create_date -- 创建日期
            ,src_type -- 来源类型： 00 机构端 01 网银端 02 数据导入
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,cpp_signature -- 中证码
            ,cpp_address -- 住所/地址
            ,cpp_ctgy -- 类型
            ,cpp_corp_type -- 企业所有制形式
            ,cpp_reg_cap -- 注册资本(万元)
            ,cpp_busi_in -- 营业收入(万元)
            ,cpp_yotal_asset -- 资产总额
            ,cpp_employees -- 从业人员(人)
            ,cpp_fctv_date -- 营业期限（自）
            ,cpp_xpry_date -- 营业期限（至）
            ,cpp_busi_scope -- 经营范围
            ,cpp_note -- 企业备注
            ,cpp_agent_name -- 经办人名称
            ,cpp_agent_no -- 经办人身份证号
            ,cpp_agent_tel -- 经办人电话
            ,cpp_agent_email -- 经办人邮箱
            ,cpp_legal_name -- 法定代表人姓名
            ,cpp_legal_nation -- 法定代表人国籍
            ,cpp_doc_type -- 法定代表人证件类型
            ,cpp_legal_no -- 法定代表人证件号码
            ,cpp_legal_doc_date -- 法定代表人证件签发日期
            ,cpp_legal_docdue_date -- 法定代表人证件到期日期
            ,cpp_legal_doc_city -- 法定代表人证件签发城市
            ,cpp_inv_type -- 发票种类
            ,cpp_tax_type -- 纳税人类别
            ,cpp_tax_tel -- 纳税人电话
            ,cpp_tax_bank_name -- 纳税人开户行名
            ,cpp_tax_bank_no -- 纳税人帐号
            ,is_need_inv -- 是否需要开票
            ,cpp_tax_name -- 纳税人名称
            ,cpp_taxer_code -- 纳税人识别号
            ,cpp_taxer_adr -- 纳税人地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_customer_info_op(
            id -- ID
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,cpp_cust_no -- 贴现通申请人客户号
            ,cpp_cust_name -- 贴现通申请人客户名称
            ,cpp_social_no -- 贴现通申请人社会信用代码
            ,cpp_reg_brh -- 登记机构
            ,cpp_status -- 状态： DRS01 正常 DRS02 失效
            ,cpp_corp_scale -- 规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
            ,cpp_ind_cls -- 行业分类：详见《中国票据交易系统直连接口规范（概述分册）》的Industry
            ,cpp_arc_flag -- 是否涉农企业: 0 否 1 是
            ,cpp_grn_flag -- 是否绿色企业: 0 否 1 是
            ,cpp_sci_flag -- 是否科技企业: 0 否 1 是
            ,cpp_pop_flag -- 是否民营企业: 0 否 1 是
            ,cpp_province -- 省份：参见附录省份代码
            ,cpp_create_date -- 创建日期
            ,src_type -- 来源类型： 00 机构端 01 网银端 02 数据导入
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,cpp_signature -- 中证码
            ,cpp_address -- 住所/地址
            ,cpp_ctgy -- 类型
            ,cpp_corp_type -- 企业所有制形式
            ,cpp_reg_cap -- 注册资本(万元)
            ,cpp_busi_in -- 营业收入(万元)
            ,cpp_yotal_asset -- 资产总额
            ,cpp_employees -- 从业人员(人)
            ,cpp_fctv_date -- 营业期限（自）
            ,cpp_xpry_date -- 营业期限（至）
            ,cpp_busi_scope -- 经营范围
            ,cpp_note -- 企业备注
            ,cpp_agent_name -- 经办人名称
            ,cpp_agent_no -- 经办人身份证号
            ,cpp_agent_tel -- 经办人电话
            ,cpp_agent_email -- 经办人邮箱
            ,cpp_legal_name -- 法定代表人姓名
            ,cpp_legal_nation -- 法定代表人国籍
            ,cpp_doc_type -- 法定代表人证件类型
            ,cpp_legal_no -- 法定代表人证件号码
            ,cpp_legal_doc_date -- 法定代表人证件签发日期
            ,cpp_legal_docdue_date -- 法定代表人证件到期日期
            ,cpp_legal_doc_city -- 法定代表人证件签发城市
            ,cpp_inv_type -- 发票种类
            ,cpp_tax_type -- 纳税人类别
            ,cpp_tax_tel -- 纳税人电话
            ,cpp_tax_bank_name -- 纳税人开户行名
            ,cpp_tax_bank_no -- 纳税人帐号
            ,is_need_inv -- 是否需要开票
            ,cpp_tax_name -- 纳税人名称
            ,cpp_taxer_code -- 纳税人识别号
            ,cpp_taxer_adr -- 纳税人地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.top_branch_no -- 总行机构号
    ,o.branch_no -- 机构号
    ,o.cpp_cust_no -- 贴现通申请人客户号
    ,o.cpp_cust_name -- 贴现通申请人客户名称
    ,o.cpp_social_no -- 贴现通申请人社会信用代码
    ,o.cpp_reg_brh -- 登记机构
    ,o.cpp_status -- 状态： DRS01 正常 DRS02 失效
    ,o.cpp_corp_scale -- 规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
    ,o.cpp_ind_cls -- 行业分类：详见《中国票据交易系统直连接口规范（概述分册）》的Industry
    ,o.cpp_arc_flag -- 是否涉农企业: 0 否 1 是
    ,o.cpp_grn_flag -- 是否绿色企业: 0 否 1 是
    ,o.cpp_sci_flag -- 是否科技企业: 0 否 1 是
    ,o.cpp_pop_flag -- 是否民营企业: 0 否 1 是
    ,o.cpp_province -- 省份：参见附录省份代码
    ,o.cpp_create_date -- 创建日期
    ,o.src_type -- 来源类型： 00 机构端 01 网银端 02 数据导入
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.cpp_signature -- 中证码
    ,o.cpp_address -- 住所/地址
    ,o.cpp_ctgy -- 类型
    ,o.cpp_corp_type -- 企业所有制形式
    ,o.cpp_reg_cap -- 注册资本(万元)
    ,o.cpp_busi_in -- 营业收入(万元)
    ,o.cpp_yotal_asset -- 资产总额
    ,o.cpp_employees -- 从业人员(人)
    ,o.cpp_fctv_date -- 营业期限（自）
    ,o.cpp_xpry_date -- 营业期限（至）
    ,o.cpp_busi_scope -- 经营范围
    ,o.cpp_note -- 企业备注
    ,o.cpp_agent_name -- 经办人名称
    ,o.cpp_agent_no -- 经办人身份证号
    ,o.cpp_agent_tel -- 经办人电话
    ,o.cpp_agent_email -- 经办人邮箱
    ,o.cpp_legal_name -- 法定代表人姓名
    ,o.cpp_legal_nation -- 法定代表人国籍
    ,o.cpp_doc_type -- 法定代表人证件类型
    ,o.cpp_legal_no -- 法定代表人证件号码
    ,o.cpp_legal_doc_date -- 法定代表人证件签发日期
    ,o.cpp_legal_docdue_date -- 法定代表人证件到期日期
    ,o.cpp_legal_doc_city -- 法定代表人证件签发城市
    ,o.cpp_inv_type -- 发票种类
    ,o.cpp_tax_type -- 纳税人类别
    ,o.cpp_tax_tel -- 纳税人电话
    ,o.cpp_tax_bank_name -- 纳税人开户行名
    ,o.cpp_tax_bank_no -- 纳税人帐号
    ,o.is_need_inv -- 是否需要开票
    ,o.cpp_tax_name -- 纳税人名称
    ,o.cpp_taxer_code -- 纳税人识别号
    ,o.cpp_taxer_adr -- 纳税人地址
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
from ${iol_schema}.bdms_cpes_customer_info_bk o
    left join ${iol_schema}.bdms_cpes_customer_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_customer_info_cl d
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
--truncate table ${iol_schema}.bdms_cpes_customer_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_customer_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_customer_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_customer_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_customer_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_customer_info_cl;
alter table ${iol_schema}.bdms_cpes_customer_info exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_customer_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_customer_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_customer_info_op purge;
drop table ${iol_schema}.bdms_cpes_customer_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_customer_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_customer_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
