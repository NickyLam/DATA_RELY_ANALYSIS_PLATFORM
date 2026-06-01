/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_mst_customer_info_add
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
create table ${iol_schema}.fams_mst_customer_info_add_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_mst_customer_info_add
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_mst_customer_info_add_op purge;
drop table ${iol_schema}.fams_mst_customer_info_add_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_mst_customer_info_add_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_mst_customer_info_add where 0=1;

create table ${iol_schema}.fams_mst_customer_info_add_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_mst_customer_info_add where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_mst_customer_info_add_cl(
            customer_id -- 客户代码
            ,party_type3 -- 机构类型（技术领域），高新技术企业、其他
            ,party_type2 -- 机构类型（经济类型），国有企业、集体企业、民营企业、其他企业
            ,party_type1 -- 机构类型（规模），大型企业、中小微企业
            ,industry -- 国标一级分类
            ,industry2 -- 国标二级分类
            ,insititute_code -- 组织机构代码/统一社会信用代码
            ,is_gov -- 是否政府融资平台
            ,main_capital -- 核心资本（万元），存的是万元
            ,register_capital -- 注册资本（万元），存的是万元
            ,province -- 所属省
            ,city -- 所属市
            ,county -- 所属县
            ,holding_type -- 控股类型
            ,customer_obj_type -- 客户主体类型，我国中央政府、境外主权国家或经济实体区域政府、中国人民银行、境外中央银行等
            ,is_listed_company -- 是否上市公司
            ,is_group_customer -- 是否集团客户
            ,parent_customer_id -- 所属集团客户编号
            ,parent_customer_name -- 所属集团客户名称
            ,is_private -- 是否民营企业
            ,is_escape_dept -- 是否为逃废债企业
            ,credit_type -- 授信策略
            ,is_credit_related_trd -- 是否授信类关联交易
            ,struct_adjust_type -- 产业结构调整类型
            ,indus_upgrate_type -- 工业转型升级标识
            ,busi_scope -- 经营范围
            ,main_busi -- 主营业务
            ,sex -- 性别
            ,person_id -- 身份证
            ,m_phone -- 移动电话
            ,phone -- 办公电话
            ,position -- 职位
            ,company_name -- 工作单位
            ,address -- 住址
            ,mail -- 电子邮箱
            ,property -- 财产状况
            ,company_nature -- 企业性质
            ,link_id1 -- 外部代码1，存万得代码
            ,link_id2 -- 外部代码2，对于平安存客户编号
            ,link_id3 -- 外部代码3
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,hs_type -- 核算分类
            ,is_fin_licence -- 是否持有金融牌照
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_mst_customer_info_add_op(
            customer_id -- 客户代码
            ,party_type3 -- 机构类型（技术领域），高新技术企业、其他
            ,party_type2 -- 机构类型（经济类型），国有企业、集体企业、民营企业、其他企业
            ,party_type1 -- 机构类型（规模），大型企业、中小微企业
            ,industry -- 国标一级分类
            ,industry2 -- 国标二级分类
            ,insititute_code -- 组织机构代码/统一社会信用代码
            ,is_gov -- 是否政府融资平台
            ,main_capital -- 核心资本（万元），存的是万元
            ,register_capital -- 注册资本（万元），存的是万元
            ,province -- 所属省
            ,city -- 所属市
            ,county -- 所属县
            ,holding_type -- 控股类型
            ,customer_obj_type -- 客户主体类型，我国中央政府、境外主权国家或经济实体区域政府、中国人民银行、境外中央银行等
            ,is_listed_company -- 是否上市公司
            ,is_group_customer -- 是否集团客户
            ,parent_customer_id -- 所属集团客户编号
            ,parent_customer_name -- 所属集团客户名称
            ,is_private -- 是否民营企业
            ,is_escape_dept -- 是否为逃废债企业
            ,credit_type -- 授信策略
            ,is_credit_related_trd -- 是否授信类关联交易
            ,struct_adjust_type -- 产业结构调整类型
            ,indus_upgrate_type -- 工业转型升级标识
            ,busi_scope -- 经营范围
            ,main_busi -- 主营业务
            ,sex -- 性别
            ,person_id -- 身份证
            ,m_phone -- 移动电话
            ,phone -- 办公电话
            ,position -- 职位
            ,company_name -- 工作单位
            ,address -- 住址
            ,mail -- 电子邮箱
            ,property -- 财产状况
            ,company_nature -- 企业性质
            ,link_id1 -- 外部代码1，存万得代码
            ,link_id2 -- 外部代码2，对于平安存客户编号
            ,link_id3 -- 外部代码3
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,hs_type -- 核算分类
            ,is_fin_licence -- 是否持有金融牌照
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customer_id, o.customer_id) as customer_id -- 客户代码
    ,nvl(n.party_type3, o.party_type3) as party_type3 -- 机构类型（技术领域），高新技术企业、其他
    ,nvl(n.party_type2, o.party_type2) as party_type2 -- 机构类型（经济类型），国有企业、集体企业、民营企业、其他企业
    ,nvl(n.party_type1, o.party_type1) as party_type1 -- 机构类型（规模），大型企业、中小微企业
    ,nvl(n.industry, o.industry) as industry -- 国标一级分类
    ,nvl(n.industry2, o.industry2) as industry2 -- 国标二级分类
    ,nvl(n.insititute_code, o.insititute_code) as insititute_code -- 组织机构代码/统一社会信用代码
    ,nvl(n.is_gov, o.is_gov) as is_gov -- 是否政府融资平台
    ,nvl(n.main_capital, o.main_capital) as main_capital -- 核心资本（万元），存的是万元
    ,nvl(n.register_capital, o.register_capital) as register_capital -- 注册资本（万元），存的是万元
    ,nvl(n.province, o.province) as province -- 所属省
    ,nvl(n.city, o.city) as city -- 所属市
    ,nvl(n.county, o.county) as county -- 所属县
    ,nvl(n.holding_type, o.holding_type) as holding_type -- 控股类型
    ,nvl(n.customer_obj_type, o.customer_obj_type) as customer_obj_type -- 客户主体类型，我国中央政府、境外主权国家或经济实体区域政府、中国人民银行、境外中央银行等
    ,nvl(n.is_listed_company, o.is_listed_company) as is_listed_company -- 是否上市公司
    ,nvl(n.is_group_customer, o.is_group_customer) as is_group_customer -- 是否集团客户
    ,nvl(n.parent_customer_id, o.parent_customer_id) as parent_customer_id -- 所属集团客户编号
    ,nvl(n.parent_customer_name, o.parent_customer_name) as parent_customer_name -- 所属集团客户名称
    ,nvl(n.is_private, o.is_private) as is_private -- 是否民营企业
    ,nvl(n.is_escape_dept, o.is_escape_dept) as is_escape_dept -- 是否为逃废债企业
    ,nvl(n.credit_type, o.credit_type) as credit_type -- 授信策略
    ,nvl(n.is_credit_related_trd, o.is_credit_related_trd) as is_credit_related_trd -- 是否授信类关联交易
    ,nvl(n.struct_adjust_type, o.struct_adjust_type) as struct_adjust_type -- 产业结构调整类型
    ,nvl(n.indus_upgrate_type, o.indus_upgrate_type) as indus_upgrate_type -- 工业转型升级标识
    ,nvl(n.busi_scope, o.busi_scope) as busi_scope -- 经营范围
    ,nvl(n.main_busi, o.main_busi) as main_busi -- 主营业务
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.person_id, o.person_id) as person_id -- 身份证
    ,nvl(n.m_phone, o.m_phone) as m_phone -- 移动电话
    ,nvl(n.phone, o.phone) as phone -- 办公电话
    ,nvl(n.position, o.position) as position -- 职位
    ,nvl(n.company_name, o.company_name) as company_name -- 工作单位
    ,nvl(n.address, o.address) as address -- 住址
    ,nvl(n.mail, o.mail) as mail -- 电子邮箱
    ,nvl(n.property, o.property) as property -- 财产状况
    ,nvl(n.company_nature, o.company_nature) as company_nature -- 企业性质
    ,nvl(n.link_id1, o.link_id1) as link_id1 -- 外部代码1，存万得代码
    ,nvl(n.link_id2, o.link_id2) as link_id2 -- 外部代码2，对于平安存客户编号
    ,nvl(n.link_id3, o.link_id3) as link_id3 -- 外部代码3
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.hs_type, o.hs_type) as hs_type -- 核算分类
    ,nvl(n.is_fin_licence, o.is_fin_licence) as is_fin_licence -- 是否持有金融牌照
    ,case when
            n.customer_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customer_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customer_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_mst_customer_info_add_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_mst_customer_info_add where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customer_id = n.customer_id
where (
        o.customer_id is null
    )
    or (
        n.customer_id is null
    )
    or (
        o.party_type3 <> n.party_type3
        or o.party_type2 <> n.party_type2
        or o.party_type1 <> n.party_type1
        or o.industry <> n.industry
        or o.industry2 <> n.industry2
        or o.insititute_code <> n.insititute_code
        or o.is_gov <> n.is_gov
        or o.main_capital <> n.main_capital
        or o.register_capital <> n.register_capital
        or o.province <> n.province
        or o.city <> n.city
        or o.county <> n.county
        or o.holding_type <> n.holding_type
        or o.customer_obj_type <> n.customer_obj_type
        or o.is_listed_company <> n.is_listed_company
        or o.is_group_customer <> n.is_group_customer
        or o.parent_customer_id <> n.parent_customer_id
        or o.parent_customer_name <> n.parent_customer_name
        or o.is_private <> n.is_private
        or o.is_escape_dept <> n.is_escape_dept
        or o.credit_type <> n.credit_type
        or o.is_credit_related_trd <> n.is_credit_related_trd
        or o.struct_adjust_type <> n.struct_adjust_type
        or o.indus_upgrate_type <> n.indus_upgrate_type
        or o.busi_scope <> n.busi_scope
        or o.main_busi <> n.main_busi
        or o.sex <> n.sex
        or o.person_id <> n.person_id
        or o.m_phone <> n.m_phone
        or o.phone <> n.phone
        or o.position <> n.position
        or o.company_name <> n.company_name
        or o.address <> n.address
        or o.mail <> n.mail
        or o.property <> n.property
        or o.company_nature <> n.company_nature
        or o.link_id1 <> n.link_id1
        or o.link_id2 <> n.link_id2
        or o.link_id3 <> n.link_id3
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.hs_type <> n.hs_type
        or o.is_fin_licence <> n.is_fin_licence
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_mst_customer_info_add_cl(
            customer_id -- 客户代码
            ,party_type3 -- 机构类型（技术领域），高新技术企业、其他
            ,party_type2 -- 机构类型（经济类型），国有企业、集体企业、民营企业、其他企业
            ,party_type1 -- 机构类型（规模），大型企业、中小微企业
            ,industry -- 国标一级分类
            ,industry2 -- 国标二级分类
            ,insititute_code -- 组织机构代码/统一社会信用代码
            ,is_gov -- 是否政府融资平台
            ,main_capital -- 核心资本（万元），存的是万元
            ,register_capital -- 注册资本（万元），存的是万元
            ,province -- 所属省
            ,city -- 所属市
            ,county -- 所属县
            ,holding_type -- 控股类型
            ,customer_obj_type -- 客户主体类型，我国中央政府、境外主权国家或经济实体区域政府、中国人民银行、境外中央银行等
            ,is_listed_company -- 是否上市公司
            ,is_group_customer -- 是否集团客户
            ,parent_customer_id -- 所属集团客户编号
            ,parent_customer_name -- 所属集团客户名称
            ,is_private -- 是否民营企业
            ,is_escape_dept -- 是否为逃废债企业
            ,credit_type -- 授信策略
            ,is_credit_related_trd -- 是否授信类关联交易
            ,struct_adjust_type -- 产业结构调整类型
            ,indus_upgrate_type -- 工业转型升级标识
            ,busi_scope -- 经营范围
            ,main_busi -- 主营业务
            ,sex -- 性别
            ,person_id -- 身份证
            ,m_phone -- 移动电话
            ,phone -- 办公电话
            ,position -- 职位
            ,company_name -- 工作单位
            ,address -- 住址
            ,mail -- 电子邮箱
            ,property -- 财产状况
            ,company_nature -- 企业性质
            ,link_id1 -- 外部代码1，存万得代码
            ,link_id2 -- 外部代码2，对于平安存客户编号
            ,link_id3 -- 外部代码3
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,hs_type -- 核算分类
            ,is_fin_licence -- 是否持有金融牌照
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_mst_customer_info_add_op(
            customer_id -- 客户代码
            ,party_type3 -- 机构类型（技术领域），高新技术企业、其他
            ,party_type2 -- 机构类型（经济类型），国有企业、集体企业、民营企业、其他企业
            ,party_type1 -- 机构类型（规模），大型企业、中小微企业
            ,industry -- 国标一级分类
            ,industry2 -- 国标二级分类
            ,insititute_code -- 组织机构代码/统一社会信用代码
            ,is_gov -- 是否政府融资平台
            ,main_capital -- 核心资本（万元），存的是万元
            ,register_capital -- 注册资本（万元），存的是万元
            ,province -- 所属省
            ,city -- 所属市
            ,county -- 所属县
            ,holding_type -- 控股类型
            ,customer_obj_type -- 客户主体类型，我国中央政府、境外主权国家或经济实体区域政府、中国人民银行、境外中央银行等
            ,is_listed_company -- 是否上市公司
            ,is_group_customer -- 是否集团客户
            ,parent_customer_id -- 所属集团客户编号
            ,parent_customer_name -- 所属集团客户名称
            ,is_private -- 是否民营企业
            ,is_escape_dept -- 是否为逃废债企业
            ,credit_type -- 授信策略
            ,is_credit_related_trd -- 是否授信类关联交易
            ,struct_adjust_type -- 产业结构调整类型
            ,indus_upgrate_type -- 工业转型升级标识
            ,busi_scope -- 经营范围
            ,main_busi -- 主营业务
            ,sex -- 性别
            ,person_id -- 身份证
            ,m_phone -- 移动电话
            ,phone -- 办公电话
            ,position -- 职位
            ,company_name -- 工作单位
            ,address -- 住址
            ,mail -- 电子邮箱
            ,property -- 财产状况
            ,company_nature -- 企业性质
            ,link_id1 -- 外部代码1，存万得代码
            ,link_id2 -- 外部代码2，对于平安存客户编号
            ,link_id3 -- 外部代码3
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,hs_type -- 核算分类
            ,is_fin_licence -- 是否持有金融牌照
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customer_id -- 客户代码
    ,o.party_type3 -- 机构类型（技术领域），高新技术企业、其他
    ,o.party_type2 -- 机构类型（经济类型），国有企业、集体企业、民营企业、其他企业
    ,o.party_type1 -- 机构类型（规模），大型企业、中小微企业
    ,o.industry -- 国标一级分类
    ,o.industry2 -- 国标二级分类
    ,o.insititute_code -- 组织机构代码/统一社会信用代码
    ,o.is_gov -- 是否政府融资平台
    ,o.main_capital -- 核心资本（万元），存的是万元
    ,o.register_capital -- 注册资本（万元），存的是万元
    ,o.province -- 所属省
    ,o.city -- 所属市
    ,o.county -- 所属县
    ,o.holding_type -- 控股类型
    ,o.customer_obj_type -- 客户主体类型，我国中央政府、境外主权国家或经济实体区域政府、中国人民银行、境外中央银行等
    ,o.is_listed_company -- 是否上市公司
    ,o.is_group_customer -- 是否集团客户
    ,o.parent_customer_id -- 所属集团客户编号
    ,o.parent_customer_name -- 所属集团客户名称
    ,o.is_private -- 是否民营企业
    ,o.is_escape_dept -- 是否为逃废债企业
    ,o.credit_type -- 授信策略
    ,o.is_credit_related_trd -- 是否授信类关联交易
    ,o.struct_adjust_type -- 产业结构调整类型
    ,o.indus_upgrate_type -- 工业转型升级标识
    ,o.busi_scope -- 经营范围
    ,o.main_busi -- 主营业务
    ,o.sex -- 性别
    ,o.person_id -- 身份证
    ,o.m_phone -- 移动电话
    ,o.phone -- 办公电话
    ,o.position -- 职位
    ,o.company_name -- 工作单位
    ,o.address -- 住址
    ,o.mail -- 电子邮箱
    ,o.property -- 财产状况
    ,o.company_nature -- 企业性质
    ,o.link_id1 -- 外部代码1，存万得代码
    ,o.link_id2 -- 外部代码2，对于平安存客户编号
    ,o.link_id3 -- 外部代码3
    ,o.remark -- 备注
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.hs_type -- 核算分类
    ,o.is_fin_licence -- 是否持有金融牌照
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
from ${iol_schema}.fams_mst_customer_info_add_bk o
    left join ${iol_schema}.fams_mst_customer_info_add_op n
        on
            o.customer_id = n.customer_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_mst_customer_info_add_cl d
        on
            o.customer_id = d.customer_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_mst_customer_info_add;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_mst_customer_info_add') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_mst_customer_info_add drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_mst_customer_info_add add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_mst_customer_info_add exchange partition p_${batch_date} with table ${iol_schema}.fams_mst_customer_info_add_cl;
alter table ${iol_schema}.fams_mst_customer_info_add exchange partition p_20991231 with table ${iol_schema}.fams_mst_customer_info_add_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_mst_customer_info_add to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_mst_customer_info_add_op purge;
drop table ${iol_schema}.fams_mst_customer_info_add_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_mst_customer_info_add_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_mst_customer_info_add',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
