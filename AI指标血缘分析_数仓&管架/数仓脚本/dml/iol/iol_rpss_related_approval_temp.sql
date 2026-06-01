/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rpss_related_approval_temp
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
create table ${iol_schema}.rpss_related_approval_temp_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rpss_related_approval_temp
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rpss_related_approval_temp_op purge;
drop table ${iol_schema}.rpss_related_approval_temp_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rpss_related_approval_temp_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rpss_related_approval_temp where 0=1;

create table ${iol_schema}.rpss_related_approval_temp_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rpss_related_approval_temp where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rpss_related_approval_temp_cl(
            last_updated_stamp -- 最后更新时间
            ,approval_person -- 审批人
            ,status_id -- 状态
            ,registration_org -- 登记机构
            ,registration_date -- 登记时间
            ,thru_date -- 失效时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,related_duty -- 在关联单位担任的职务
            ,certificate_no -- 证件号码1
            ,certificate_no_dg_t -- 对公证件号码2
            ,certificate_no_dg -- 对公证件号码1
            ,approval_date -- 审批时间
            ,relation_type -- 与上一层的管理方关系
            ,domestic_or_foreign_dg_t -- 对公证件类型境内外2
            ,domestic_or_foreign_dg -- 对公证件类型境内外1
            ,domestic_or_foreign_t -- 证件类型境内外2
            ,domestic_or_foreign -- 证件类型境内外1
            ,product_name -- 金融产品全称
            ,product_issue_no -- 产品批准/注册/备案号
            ,product_register_no -- 产品代码
            ,product_type -- 产品分类
            ,register_org -- 产品登记机构
            ,product_owner -- 产品管理人全称
            ,product_owner_unisc_code -- 产品管理人统一社会信用代码
            ,product_custodian -- 产品托管人全称
            ,product_custodian_unisc_code -- 产品托管人统一社会信用代码
            ,from_date -- 有效开始日期
            ,certificate_type_id_dg -- 对公证件类型1
            ,organization -- 所属机构
            ,reject_reason -- 拒绝原因
            ,group_name -- 单位归属的企业集团全称
            ,comments -- 备注
            ,related_unit -- 关联单位全称
            ,registrant -- 登记人
            ,registration_org_apl -- 审批机构
            ,certificate_type_id -- 证件类型1
            ,created_tx_stamp -- 创建业务时间
            ,shareholding_ratio -- 持股比例
            ,unit_name -- 关联方名称(对公)
            ,kinship -- 近亲属
            ,belong_org -- 归属机构
            ,related_relationship_type_id -- 关联关系
            ,department -- 所属部门
            ,certificate_type_id_dg_t -- 对公证件类型2
            ,relation -- 担任职务或关联关系
            ,mainten_org -- 维护机构
            ,duty -- 本行岗位或职务
            ,related_id -- 关联方编号
            ,created_stamp -- 创建时间
            ,related_id_from -- 上级关联方编号
            ,certificate_type_id_t -- 证件类型2
            ,person_name -- 姓名
            ,certificate_no_t -- 证件号码2
            ,hold_related_type -- 股东或关联方类型
            ,hold_related_industry -- 股东或关联方所属行业
            ,hold_related_reg_address -- 股东或关联方注册地
            ,hold_related_rel_type -- 股东或关联方关系类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rpss_related_approval_temp_op(
            last_updated_stamp -- 最后更新时间
            ,approval_person -- 审批人
            ,status_id -- 状态
            ,registration_org -- 登记机构
            ,registration_date -- 登记时间
            ,thru_date -- 失效时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,related_duty -- 在关联单位担任的职务
            ,certificate_no -- 证件号码1
            ,certificate_no_dg_t -- 对公证件号码2
            ,certificate_no_dg -- 对公证件号码1
            ,approval_date -- 审批时间
            ,relation_type -- 与上一层的管理方关系
            ,domestic_or_foreign_dg_t -- 对公证件类型境内外2
            ,domestic_or_foreign_dg -- 对公证件类型境内外1
            ,domestic_or_foreign_t -- 证件类型境内外2
            ,domestic_or_foreign -- 证件类型境内外1
            ,product_name -- 金融产品全称
            ,product_issue_no -- 产品批准/注册/备案号
            ,product_register_no -- 产品代码
            ,product_type -- 产品分类
            ,register_org -- 产品登记机构
            ,product_owner -- 产品管理人全称
            ,product_owner_unisc_code -- 产品管理人统一社会信用代码
            ,product_custodian -- 产品托管人全称
            ,product_custodian_unisc_code -- 产品托管人统一社会信用代码
            ,from_date -- 有效开始日期
            ,certificate_type_id_dg -- 对公证件类型1
            ,organization -- 所属机构
            ,reject_reason -- 拒绝原因
            ,group_name -- 单位归属的企业集团全称
            ,comments -- 备注
            ,related_unit -- 关联单位全称
            ,registrant -- 登记人
            ,registration_org_apl -- 审批机构
            ,certificate_type_id -- 证件类型1
            ,created_tx_stamp -- 创建业务时间
            ,shareholding_ratio -- 持股比例
            ,unit_name -- 关联方名称(对公)
            ,kinship -- 近亲属
            ,belong_org -- 归属机构
            ,related_relationship_type_id -- 关联关系
            ,department -- 所属部门
            ,certificate_type_id_dg_t -- 对公证件类型2
            ,relation -- 担任职务或关联关系
            ,mainten_org -- 维护机构
            ,duty -- 本行岗位或职务
            ,related_id -- 关联方编号
            ,created_stamp -- 创建时间
            ,related_id_from -- 上级关联方编号
            ,certificate_type_id_t -- 证件类型2
            ,person_name -- 姓名
            ,certificate_no_t -- 证件号码2
            ,hold_related_type -- 股东或关联方类型
            ,hold_related_industry -- 股东或关联方所属行业
            ,hold_related_reg_address -- 股东或关联方注册地
            ,hold_related_rel_type -- 股东或关联方关系类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 最后更新时间
    ,nvl(n.approval_person, o.approval_person) as approval_person -- 审批人
    ,nvl(n.status_id, o.status_id) as status_id -- 状态
    ,nvl(n.registration_org, o.registration_org) as registration_org -- 登记机构
    ,nvl(n.registration_date, o.registration_date) as registration_date -- 登记时间
    ,nvl(n.thru_date, o.thru_date) as thru_date -- 失效时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 最后更新事务时间
    ,nvl(n.related_duty, o.related_duty) as related_duty -- 在关联单位担任的职务
    ,nvl(n.certificate_no, o.certificate_no) as certificate_no -- 证件号码1
    ,nvl(n.certificate_no_dg_t, o.certificate_no_dg_t) as certificate_no_dg_t -- 对公证件号码2
    ,nvl(n.certificate_no_dg, o.certificate_no_dg) as certificate_no_dg -- 对公证件号码1
    ,nvl(n.approval_date, o.approval_date) as approval_date -- 审批时间
    ,nvl(n.relation_type, o.relation_type) as relation_type -- 与上一层的管理方关系
    ,nvl(n.domestic_or_foreign_dg_t, o.domestic_or_foreign_dg_t) as domestic_or_foreign_dg_t -- 对公证件类型境内外2
    ,nvl(n.domestic_or_foreign_dg, o.domestic_or_foreign_dg) as domestic_or_foreign_dg -- 对公证件类型境内外1
    ,nvl(n.domestic_or_foreign_t, o.domestic_or_foreign_t) as domestic_or_foreign_t -- 证件类型境内外2
    ,nvl(n.domestic_or_foreign, o.domestic_or_foreign) as domestic_or_foreign -- 证件类型境内外1
    ,nvl(n.product_name, o.product_name) as product_name -- 金融产品全称
    ,nvl(n.product_issue_no, o.product_issue_no) as product_issue_no -- 产品批准/注册/备案号
    ,nvl(n.product_register_no, o.product_register_no) as product_register_no -- 产品代码
    ,nvl(n.product_type, o.product_type) as product_type -- 产品分类
    ,nvl(n.register_org, o.register_org) as register_org -- 产品登记机构
    ,nvl(n.product_owner, o.product_owner) as product_owner -- 产品管理人全称
    ,nvl(n.product_owner_unisc_code, o.product_owner_unisc_code) as product_owner_unisc_code -- 产品管理人统一社会信用代码
    ,nvl(n.product_custodian, o.product_custodian) as product_custodian -- 产品托管人全称
    ,nvl(n.product_custodian_unisc_code, o.product_custodian_unisc_code) as product_custodian_unisc_code -- 产品托管人统一社会信用代码
    ,nvl(n.from_date, o.from_date) as from_date -- 有效开始日期
    ,nvl(n.certificate_type_id_dg, o.certificate_type_id_dg) as certificate_type_id_dg -- 对公证件类型1
    ,nvl(n.organization, o.organization) as organization -- 所属机构
    ,nvl(n.reject_reason, o.reject_reason) as reject_reason -- 拒绝原因
    ,nvl(n.group_name, o.group_name) as group_name -- 单位归属的企业集团全称
    ,nvl(n.comments, o.comments) as comments -- 备注
    ,nvl(n.related_unit, o.related_unit) as related_unit -- 关联单位全称
    ,nvl(n.registrant, o.registrant) as registrant -- 登记人
    ,nvl(n.registration_org_apl, o.registration_org_apl) as registration_org_apl -- 审批机构
    ,nvl(n.certificate_type_id, o.certificate_type_id) as certificate_type_id -- 证件类型1
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 创建业务时间
    ,nvl(n.shareholding_ratio, o.shareholding_ratio) as shareholding_ratio -- 持股比例
    ,nvl(n.unit_name, o.unit_name) as unit_name -- 关联方名称(对公)
    ,nvl(n.kinship, o.kinship) as kinship -- 近亲属
    ,nvl(n.belong_org, o.belong_org) as belong_org -- 归属机构
    ,nvl(n.related_relationship_type_id, o.related_relationship_type_id) as related_relationship_type_id -- 关联关系
    ,nvl(n.department, o.department) as department -- 所属部门
    ,nvl(n.certificate_type_id_dg_t, o.certificate_type_id_dg_t) as certificate_type_id_dg_t -- 对公证件类型2
    ,nvl(n.relation, o.relation) as relation -- 担任职务或关联关系
    ,nvl(n.mainten_org, o.mainten_org) as mainten_org -- 维护机构
    ,nvl(n.duty, o.duty) as duty -- 本行岗位或职务
    ,nvl(n.related_id, o.related_id) as related_id -- 关联方编号
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 创建时间
    ,nvl(n.related_id_from, o.related_id_from) as related_id_from -- 上级关联方编号
    ,nvl(n.certificate_type_id_t, o.certificate_type_id_t) as certificate_type_id_t -- 证件类型2
    ,nvl(n.person_name, o.person_name) as person_name -- 姓名
    ,nvl(n.certificate_no_t, o.certificate_no_t) as certificate_no_t -- 证件号码2
    ,nvl(n.hold_related_type, o.hold_related_type) as hold_related_type -- 股东或关联方类型
    ,nvl(n.hold_related_industry, o.hold_related_industry) as hold_related_industry -- 股东或关联方所属行业
    ,nvl(n.hold_related_reg_address, o.hold_related_reg_address) as hold_related_reg_address -- 股东或关联方注册地
    ,nvl(n.hold_related_rel_type, o.hold_related_rel_type) as hold_related_rel_type -- 股东或关联方关系类型
    ,case when
            n.registration_date is null
            and n.related_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.registration_date is null
            and n.related_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.registration_date is null
            and n.related_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rpss_related_approval_temp_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rpss_related_approval_temp where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.registration_date = n.registration_date
            and o.related_id = n.related_id
where (
        o.registration_date is null
        and o.related_id is null
    )
    or (
        n.registration_date is null
        and n.related_id is null
    )
    or (
        o.last_updated_stamp <> n.last_updated_stamp
        or o.approval_person <> n.approval_person
        or o.status_id <> n.status_id
        or o.registration_org <> n.registration_org
        or o.thru_date <> n.thru_date
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.related_duty <> n.related_duty
        or o.certificate_no <> n.certificate_no
        or o.certificate_no_dg_t <> n.certificate_no_dg_t
        or o.certificate_no_dg <> n.certificate_no_dg
        or o.approval_date <> n.approval_date
        or o.relation_type <> n.relation_type
        or o.domestic_or_foreign_dg_t <> n.domestic_or_foreign_dg_t
        or o.domestic_or_foreign_dg <> n.domestic_or_foreign_dg
        or o.domestic_or_foreign_t <> n.domestic_or_foreign_t
        or o.domestic_or_foreign <> n.domestic_or_foreign
        or o.product_name <> n.product_name
        or o.product_issue_no <> n.product_issue_no
        or o.product_register_no <> n.product_register_no
        or o.product_type <> n.product_type
        or o.register_org <> n.register_org
        or o.product_owner <> n.product_owner
        or o.product_owner_unisc_code <> n.product_owner_unisc_code
        or o.product_custodian <> n.product_custodian
        or o.product_custodian_unisc_code <> n.product_custodian_unisc_code
        or o.from_date <> n.from_date
        or o.certificate_type_id_dg <> n.certificate_type_id_dg
        or o.organization <> n.organization
        or o.reject_reason <> n.reject_reason
        or o.group_name <> n.group_name
        or o.comments <> n.comments
        or o.related_unit <> n.related_unit
        or o.registrant <> n.registrant
        or o.registration_org_apl <> n.registration_org_apl
        or o.certificate_type_id <> n.certificate_type_id
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.shareholding_ratio <> n.shareholding_ratio
        or o.unit_name <> n.unit_name
        or o.kinship <> n.kinship
        or o.belong_org <> n.belong_org
        or o.related_relationship_type_id <> n.related_relationship_type_id
        or o.department <> n.department
        or o.certificate_type_id_dg_t <> n.certificate_type_id_dg_t
        or o.relation <> n.relation
        or o.mainten_org <> n.mainten_org
        or o.duty <> n.duty
        or o.created_stamp <> n.created_stamp
        or o.related_id_from <> n.related_id_from
        or o.certificate_type_id_t <> n.certificate_type_id_t
        or o.person_name <> n.person_name
        or o.certificate_no_t <> n.certificate_no_t
        or o.hold_related_type <> n.hold_related_type
        or o.hold_related_industry <> n.hold_related_industry
        or o.hold_related_reg_address <> n.hold_related_reg_address
        or o.hold_related_rel_type <> n.hold_related_rel_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rpss_related_approval_temp_cl(
            last_updated_stamp -- 最后更新时间
            ,approval_person -- 审批人
            ,status_id -- 状态
            ,registration_org -- 登记机构
            ,registration_date -- 登记时间
            ,thru_date -- 失效时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,related_duty -- 在关联单位担任的职务
            ,certificate_no -- 证件号码1
            ,certificate_no_dg_t -- 对公证件号码2
            ,certificate_no_dg -- 对公证件号码1
            ,approval_date -- 审批时间
            ,relation_type -- 与上一层的管理方关系
            ,domestic_or_foreign_dg_t -- 对公证件类型境内外2
            ,domestic_or_foreign_dg -- 对公证件类型境内外1
            ,domestic_or_foreign_t -- 证件类型境内外2
            ,domestic_or_foreign -- 证件类型境内外1
            ,product_name -- 金融产品全称
            ,product_issue_no -- 产品批准/注册/备案号
            ,product_register_no -- 产品代码
            ,product_type -- 产品分类
            ,register_org -- 产品登记机构
            ,product_owner -- 产品管理人全称
            ,product_owner_unisc_code -- 产品管理人统一社会信用代码
            ,product_custodian -- 产品托管人全称
            ,product_custodian_unisc_code -- 产品托管人统一社会信用代码
            ,from_date -- 有效开始日期
            ,certificate_type_id_dg -- 对公证件类型1
            ,organization -- 所属机构
            ,reject_reason -- 拒绝原因
            ,group_name -- 单位归属的企业集团全称
            ,comments -- 备注
            ,related_unit -- 关联单位全称
            ,registrant -- 登记人
            ,registration_org_apl -- 审批机构
            ,certificate_type_id -- 证件类型1
            ,created_tx_stamp -- 创建业务时间
            ,shareholding_ratio -- 持股比例
            ,unit_name -- 关联方名称(对公)
            ,kinship -- 近亲属
            ,belong_org -- 归属机构
            ,related_relationship_type_id -- 关联关系
            ,department -- 所属部门
            ,certificate_type_id_dg_t -- 对公证件类型2
            ,relation -- 担任职务或关联关系
            ,mainten_org -- 维护机构
            ,duty -- 本行岗位或职务
            ,related_id -- 关联方编号
            ,created_stamp -- 创建时间
            ,related_id_from -- 上级关联方编号
            ,certificate_type_id_t -- 证件类型2
            ,person_name -- 姓名
            ,certificate_no_t -- 证件号码2
            ,hold_related_type -- 股东或关联方类型
            ,hold_related_industry -- 股东或关联方所属行业
            ,hold_related_reg_address -- 股东或关联方注册地
            ,hold_related_rel_type -- 股东或关联方关系类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rpss_related_approval_temp_op(
            last_updated_stamp -- 最后更新时间
            ,approval_person -- 审批人
            ,status_id -- 状态
            ,registration_org -- 登记机构
            ,registration_date -- 登记时间
            ,thru_date -- 失效时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,related_duty -- 在关联单位担任的职务
            ,certificate_no -- 证件号码1
            ,certificate_no_dg_t -- 对公证件号码2
            ,certificate_no_dg -- 对公证件号码1
            ,approval_date -- 审批时间
            ,relation_type -- 与上一层的管理方关系
            ,domestic_or_foreign_dg_t -- 对公证件类型境内外2
            ,domestic_or_foreign_dg -- 对公证件类型境内外1
            ,domestic_or_foreign_t -- 证件类型境内外2
            ,domestic_or_foreign -- 证件类型境内外1
            ,product_name -- 金融产品全称
            ,product_issue_no -- 产品批准/注册/备案号
            ,product_register_no -- 产品代码
            ,product_type -- 产品分类
            ,register_org -- 产品登记机构
            ,product_owner -- 产品管理人全称
            ,product_owner_unisc_code -- 产品管理人统一社会信用代码
            ,product_custodian -- 产品托管人全称
            ,product_custodian_unisc_code -- 产品托管人统一社会信用代码
            ,from_date -- 有效开始日期
            ,certificate_type_id_dg -- 对公证件类型1
            ,organization -- 所属机构
            ,reject_reason -- 拒绝原因
            ,group_name -- 单位归属的企业集团全称
            ,comments -- 备注
            ,related_unit -- 关联单位全称
            ,registrant -- 登记人
            ,registration_org_apl -- 审批机构
            ,certificate_type_id -- 证件类型1
            ,created_tx_stamp -- 创建业务时间
            ,shareholding_ratio -- 持股比例
            ,unit_name -- 关联方名称(对公)
            ,kinship -- 近亲属
            ,belong_org -- 归属机构
            ,related_relationship_type_id -- 关联关系
            ,department -- 所属部门
            ,certificate_type_id_dg_t -- 对公证件类型2
            ,relation -- 担任职务或关联关系
            ,mainten_org -- 维护机构
            ,duty -- 本行岗位或职务
            ,related_id -- 关联方编号
            ,created_stamp -- 创建时间
            ,related_id_from -- 上级关联方编号
            ,certificate_type_id_t -- 证件类型2
            ,person_name -- 姓名
            ,certificate_no_t -- 证件号码2
            ,hold_related_type -- 股东或关联方类型
            ,hold_related_industry -- 股东或关联方所属行业
            ,hold_related_reg_address -- 股东或关联方注册地
            ,hold_related_rel_type -- 股东或关联方关系类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.last_updated_stamp -- 最后更新时间
    ,o.approval_person -- 审批人
    ,o.status_id -- 状态
    ,o.registration_org -- 登记机构
    ,o.registration_date -- 登记时间
    ,o.thru_date -- 失效时间
    ,o.last_updated_tx_stamp -- 最后更新事务时间
    ,o.related_duty -- 在关联单位担任的职务
    ,o.certificate_no -- 证件号码1
    ,o.certificate_no_dg_t -- 对公证件号码2
    ,o.certificate_no_dg -- 对公证件号码1
    ,o.approval_date -- 审批时间
    ,o.relation_type -- 与上一层的管理方关系
    ,o.domestic_or_foreign_dg_t -- 对公证件类型境内外2
    ,o.domestic_or_foreign_dg -- 对公证件类型境内外1
    ,o.domestic_or_foreign_t -- 证件类型境内外2
    ,o.domestic_or_foreign -- 证件类型境内外1
    ,o.product_name -- 金融产品全称
    ,o.product_issue_no -- 产品批准/注册/备案号
    ,o.product_register_no -- 产品代码
    ,o.product_type -- 产品分类
    ,o.register_org -- 产品登记机构
    ,o.product_owner -- 产品管理人全称
    ,o.product_owner_unisc_code -- 产品管理人统一社会信用代码
    ,o.product_custodian -- 产品托管人全称
    ,o.product_custodian_unisc_code -- 产品托管人统一社会信用代码
    ,o.from_date -- 有效开始日期
    ,o.certificate_type_id_dg -- 对公证件类型1
    ,o.organization -- 所属机构
    ,o.reject_reason -- 拒绝原因
    ,o.group_name -- 单位归属的企业集团全称
    ,o.comments -- 备注
    ,o.related_unit -- 关联单位全称
    ,o.registrant -- 登记人
    ,o.registration_org_apl -- 审批机构
    ,o.certificate_type_id -- 证件类型1
    ,o.created_tx_stamp -- 创建业务时间
    ,o.shareholding_ratio -- 持股比例
    ,o.unit_name -- 关联方名称(对公)
    ,o.kinship -- 近亲属
    ,o.belong_org -- 归属机构
    ,o.related_relationship_type_id -- 关联关系
    ,o.department -- 所属部门
    ,o.certificate_type_id_dg_t -- 对公证件类型2
    ,o.relation -- 担任职务或关联关系
    ,o.mainten_org -- 维护机构
    ,o.duty -- 本行岗位或职务
    ,o.related_id -- 关联方编号
    ,o.created_stamp -- 创建时间
    ,o.related_id_from -- 上级关联方编号
    ,o.certificate_type_id_t -- 证件类型2
    ,o.person_name -- 姓名
    ,o.certificate_no_t -- 证件号码2
    ,o.hold_related_type -- 股东或关联方类型
    ,o.hold_related_industry -- 股东或关联方所属行业
    ,o.hold_related_reg_address -- 股东或关联方注册地
    ,o.hold_related_rel_type -- 股东或关联方关系类型
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
from ${iol_schema}.rpss_related_approval_temp_bk o
    left join ${iol_schema}.rpss_related_approval_temp_op n
        on
            o.registration_date = n.registration_date
            and o.related_id = n.related_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rpss_related_approval_temp_cl d
        on
            o.registration_date = d.registration_date
            and o.related_id = d.related_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rpss_related_approval_temp;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rpss_related_approval_temp') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rpss_related_approval_temp drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rpss_related_approval_temp add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rpss_related_approval_temp exchange partition p_${batch_date} with table ${iol_schema}.rpss_related_approval_temp_cl;
alter table ${iol_schema}.rpss_related_approval_temp exchange partition p_20991231 with table ${iol_schema}.rpss_related_approval_temp_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rpss_related_approval_temp to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rpss_related_approval_temp_op purge;
drop table ${iol_schema}.rpss_related_approval_temp_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rpss_related_approval_temp_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rpss_related_approval_temp',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
