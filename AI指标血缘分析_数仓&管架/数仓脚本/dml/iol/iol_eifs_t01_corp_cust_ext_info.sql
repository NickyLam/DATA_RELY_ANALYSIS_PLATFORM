/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t01_corp_cust_ext_info
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
create table ${iol_schema}.eifs_t01_corp_cust_ext_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t01_corp_cust_ext_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_corp_cust_ext_info_op purge;
drop table ${iol_schema}.eifs_t01_corp_cust_ext_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_corp_cust_ext_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_corp_cust_ext_info where 0=1;

create table ${iol_schema}.eifs_t01_corp_cust_ext_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_corp_cust_ext_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_corp_cust_ext_info_cl(
            party_id -- 参与人id
            ,cust_card_level_cd -- 客户持卡等级
            ,cust_asset_level_cd -- 客户资产等级
            ,cust_risk_level_cd -- 风险等级
            ,bad_rec_reason -- 不良记录原因
            ,blklist_cust_ind -- 黑名单客户标志
            ,up_blklist_dt -- 黑名单登记日期
            ,blklist_type -- 上黑名单原因
            ,credit_limit_flag_cd -- 综合授信额度
            ,used_crdt_limit -- 已用授信额度
            ,avail_crdt_limit -- 可用授信额度
            ,loan_card_num -- 贷款卡号
            ,resdnt_char_cd -- 居民性质
            ,group_cust_ind -- 集团客户标志
            ,belong_group_num -- 所属集团编号
            ,belong_group_name -- 所属集团名称
            ,eco_type -- 所有制（经济）性质
            ,list_corp_ind -- 上市公司标志
            ,shares_code -- 股票代码
            ,listed_address -- 上市地
            ,national_treatment -- 国民待遇
            ,first_credit_rela_time -- 首次建立信贷关系年月
            ,admin_number -- 管理人员人数
            ,lei -- lei代码
            ,lei_role -- lei角色
            ,dig_econ -- 数字经济
            ,new_str_eme -- 战略性新兴产业
            ,int_crdt_rating_cd -- 内部信用评级
            ,org_status_cd -- 机构状态
            ,eco_type_cd -- 经济类型
            ,rgst_dt -- 注册日期
            ,indus_type_cd_level5_cls -- 行业类型(五级分类)
            ,indus_type_cd_crdt_rating -- 行业类型(信用评级)
            ,open_cap -- 开办资金
            ,lmt_or_encrge_indus_cd -- 限制或鼓励行业
            ,loan_card_num_status -- 贷款卡号状态
            ,indus_type_cd_nat_stan -- 行业类型-国标
            ,industry_type -- 产业类型
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,owner_type -- 所有制类型
            ,legal_name -- 法人机构名称
            ,legal_org_type -- 法人机构类别
            ,legal_cust_num -- 法人机构客户号
            ,superior_cust_num -- 上级机构客户编号
            ,technology_org_type -- 科技型企业分类
            ,technology_org_affirm_ts -- 科技型企业认定时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,belong_type_cd -- 所属类别
            ,self_info_flag -- 自助维护标志
            ,beneficiary_status -- 受益人识别状态
            ,beneficiary_attr -- 受益所有人属性
            ,beneficial_owner -- 受益所有人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_corp_cust_ext_info_op(
            party_id -- 参与人id
            ,cust_card_level_cd -- 客户持卡等级
            ,cust_asset_level_cd -- 客户资产等级
            ,cust_risk_level_cd -- 风险等级
            ,bad_rec_reason -- 不良记录原因
            ,blklist_cust_ind -- 黑名单客户标志
            ,up_blklist_dt -- 黑名单登记日期
            ,blklist_type -- 上黑名单原因
            ,credit_limit_flag_cd -- 综合授信额度
            ,used_crdt_limit -- 已用授信额度
            ,avail_crdt_limit -- 可用授信额度
            ,loan_card_num -- 贷款卡号
            ,resdnt_char_cd -- 居民性质
            ,group_cust_ind -- 集团客户标志
            ,belong_group_num -- 所属集团编号
            ,belong_group_name -- 所属集团名称
            ,eco_type -- 所有制（经济）性质
            ,list_corp_ind -- 上市公司标志
            ,shares_code -- 股票代码
            ,listed_address -- 上市地
            ,national_treatment -- 国民待遇
            ,first_credit_rela_time -- 首次建立信贷关系年月
            ,admin_number -- 管理人员人数
            ,lei -- lei代码
            ,lei_role -- lei角色
            ,dig_econ -- 数字经济
            ,new_str_eme -- 战略性新兴产业
            ,int_crdt_rating_cd -- 内部信用评级
            ,org_status_cd -- 机构状态
            ,eco_type_cd -- 经济类型
            ,rgst_dt -- 注册日期
            ,indus_type_cd_level5_cls -- 行业类型(五级分类)
            ,indus_type_cd_crdt_rating -- 行业类型(信用评级)
            ,open_cap -- 开办资金
            ,lmt_or_encrge_indus_cd -- 限制或鼓励行业
            ,loan_card_num_status -- 贷款卡号状态
            ,indus_type_cd_nat_stan -- 行业类型-国标
            ,industry_type -- 产业类型
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,owner_type -- 所有制类型
            ,legal_name -- 法人机构名称
            ,legal_org_type -- 法人机构类别
            ,legal_cust_num -- 法人机构客户号
            ,superior_cust_num -- 上级机构客户编号
            ,technology_org_type -- 科技型企业分类
            ,technology_org_affirm_ts -- 科技型企业认定时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,belong_type_cd -- 所属类别
            ,self_info_flag -- 自助维护标志
            ,beneficiary_status -- 受益人识别状态
            ,beneficiary_attr -- 受益所有人属性
            ,beneficial_owner -- 受益所有人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 参与人id
    ,nvl(n.cust_card_level_cd, o.cust_card_level_cd) as cust_card_level_cd -- 客户持卡等级
    ,nvl(n.cust_asset_level_cd, o.cust_asset_level_cd) as cust_asset_level_cd -- 客户资产等级
    ,nvl(n.cust_risk_level_cd, o.cust_risk_level_cd) as cust_risk_level_cd -- 风险等级
    ,nvl(n.bad_rec_reason, o.bad_rec_reason) as bad_rec_reason -- 不良记录原因
    ,nvl(n.blklist_cust_ind, o.blklist_cust_ind) as blklist_cust_ind -- 黑名单客户标志
    ,nvl(n.up_blklist_dt, o.up_blklist_dt) as up_blklist_dt -- 黑名单登记日期
    ,nvl(n.blklist_type, o.blklist_type) as blklist_type -- 上黑名单原因
    ,nvl(n.credit_limit_flag_cd, o.credit_limit_flag_cd) as credit_limit_flag_cd -- 综合授信额度
    ,nvl(n.used_crdt_limit, o.used_crdt_limit) as used_crdt_limit -- 已用授信额度
    ,nvl(n.avail_crdt_limit, o.avail_crdt_limit) as avail_crdt_limit -- 可用授信额度
    ,nvl(n.loan_card_num, o.loan_card_num) as loan_card_num -- 贷款卡号
    ,nvl(n.resdnt_char_cd, o.resdnt_char_cd) as resdnt_char_cd -- 居民性质
    ,nvl(n.group_cust_ind, o.group_cust_ind) as group_cust_ind -- 集团客户标志
    ,nvl(n.belong_group_num, o.belong_group_num) as belong_group_num -- 所属集团编号
    ,nvl(n.belong_group_name, o.belong_group_name) as belong_group_name -- 所属集团名称
    ,nvl(n.eco_type, o.eco_type) as eco_type -- 所有制（经济）性质
    ,nvl(n.list_corp_ind, o.list_corp_ind) as list_corp_ind -- 上市公司标志
    ,nvl(n.shares_code, o.shares_code) as shares_code -- 股票代码
    ,nvl(n.listed_address, o.listed_address) as listed_address -- 上市地
    ,nvl(n.national_treatment, o.national_treatment) as national_treatment -- 国民待遇
    ,nvl(n.first_credit_rela_time, o.first_credit_rela_time) as first_credit_rela_time -- 首次建立信贷关系年月
    ,nvl(n.admin_number, o.admin_number) as admin_number -- 管理人员人数
    ,nvl(n.lei, o.lei) as lei -- lei代码
    ,nvl(n.lei_role, o.lei_role) as lei_role -- lei角色
    ,nvl(n.dig_econ, o.dig_econ) as dig_econ -- 数字经济
    ,nvl(n.new_str_eme, o.new_str_eme) as new_str_eme -- 战略性新兴产业
    ,nvl(n.int_crdt_rating_cd, o.int_crdt_rating_cd) as int_crdt_rating_cd -- 内部信用评级
    ,nvl(n.org_status_cd, o.org_status_cd) as org_status_cd -- 机构状态
    ,nvl(n.eco_type_cd, o.eco_type_cd) as eco_type_cd -- 经济类型
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 注册日期
    ,nvl(n.indus_type_cd_level5_cls, o.indus_type_cd_level5_cls) as indus_type_cd_level5_cls -- 行业类型(五级分类)
    ,nvl(n.indus_type_cd_crdt_rating, o.indus_type_cd_crdt_rating) as indus_type_cd_crdt_rating -- 行业类型(信用评级)
    ,nvl(n.open_cap, o.open_cap) as open_cap -- 开办资金
    ,nvl(n.lmt_or_encrge_indus_cd, o.lmt_or_encrge_indus_cd) as lmt_or_encrge_indus_cd -- 限制或鼓励行业
    ,nvl(n.loan_card_num_status, o.loan_card_num_status) as loan_card_num_status -- 贷款卡号状态
    ,nvl(n.indus_type_cd_nat_stan, o.indus_type_cd_nat_stan) as indus_type_cd_nat_stan -- 行业类型-国标
    ,nvl(n.industry_type, o.industry_type) as industry_type -- 产业类型
    ,nvl(n.create_te, o.create_te) as create_te -- 创建柜员
    ,nvl(n.create_org, o.create_org) as create_org -- 创建机构号
    ,nvl(n.init_system_id, o.init_system_id) as init_system_id -- 创建渠道
    ,nvl(n.init_created_ts, o.init_created_ts) as init_created_ts -- 源系统创建时间
    ,nvl(n.created_ts, o.created_ts) as created_ts -- 进入ecif的时间
    ,nvl(n.updated_ts, o.updated_ts) as updated_ts -- 在ecif中失效的时间
    ,nvl(n.last_updated_te, o.last_updated_te) as last_updated_te -- 最新更新柜员
    ,nvl(n.last_updated_org, o.last_updated_org) as last_updated_org -- 最新更新机构号
    ,nvl(n.last_system_id, o.last_system_id) as last_system_id -- 最新更新渠道
    ,nvl(n.last_updated_ts, o.last_updated_ts) as last_updated_ts -- 最新更新时间
    ,nvl(n.owner_type, o.owner_type) as owner_type -- 所有制类型
    ,nvl(n.legal_name, o.legal_name) as legal_name -- 法人机构名称
    ,nvl(n.legal_org_type, o.legal_org_type) as legal_org_type -- 法人机构类别
    ,nvl(n.legal_cust_num, o.legal_cust_num) as legal_cust_num -- 法人机构客户号
    ,nvl(n.superior_cust_num, o.superior_cust_num) as superior_cust_num -- 上级机构客户编号
    ,nvl(n.technology_org_type, o.technology_org_type) as technology_org_type -- 科技型企业分类
    ,nvl(n.technology_org_affirm_ts, o.technology_org_affirm_ts) as technology_org_affirm_ts -- 科技型企业认定时间
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号
    ,nvl(n.belong_type_cd, o.belong_type_cd) as belong_type_cd -- 所属类别
    ,nvl(n.self_info_flag, o.self_info_flag) as self_info_flag -- 自助维护标志
    ,nvl(n.beneficiary_status, o.beneficiary_status) as beneficiary_status -- 受益人识别状态
    ,nvl(n.beneficiary_attr, o.beneficiary_attr) as beneficiary_attr -- 受益所有人属性
    ,nvl(n.beneficial_owner, o.beneficial_owner) as beneficial_owner -- 受益所有人
    ,case when
            n.party_id is null
            and n.updated_ts is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.updated_ts is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.updated_ts is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t01_corp_cust_ext_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t01_corp_cust_ext_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.party_id = n.party_id
            and o.updated_ts = n.updated_ts
where (
        o.party_id is null
        and o.updated_ts is null
    )
    or (
        n.party_id is null
        and n.updated_ts is null
    )
    or (
        o.cust_card_level_cd <> n.cust_card_level_cd
        or o.cust_asset_level_cd <> n.cust_asset_level_cd
        or o.cust_risk_level_cd <> n.cust_risk_level_cd
        or o.bad_rec_reason <> n.bad_rec_reason
        or o.blklist_cust_ind <> n.blklist_cust_ind
        or o.up_blklist_dt <> n.up_blklist_dt
        or o.blklist_type <> n.blklist_type
        or o.credit_limit_flag_cd <> n.credit_limit_flag_cd
        or o.used_crdt_limit <> n.used_crdt_limit
        or o.avail_crdt_limit <> n.avail_crdt_limit
        or o.loan_card_num <> n.loan_card_num
        or o.resdnt_char_cd <> n.resdnt_char_cd
        or o.group_cust_ind <> n.group_cust_ind
        or o.belong_group_num <> n.belong_group_num
        or o.belong_group_name <> n.belong_group_name
        or o.eco_type <> n.eco_type
        or o.list_corp_ind <> n.list_corp_ind
        or o.shares_code <> n.shares_code
        or o.listed_address <> n.listed_address
        or o.national_treatment <> n.national_treatment
        or o.first_credit_rela_time <> n.first_credit_rela_time
        or o.admin_number <> n.admin_number
        or o.lei <> n.lei
        or o.lei_role <> n.lei_role
        or o.dig_econ <> n.dig_econ
        or o.new_str_eme <> n.new_str_eme
        or o.int_crdt_rating_cd <> n.int_crdt_rating_cd
        or o.org_status_cd <> n.org_status_cd
        or o.eco_type_cd <> n.eco_type_cd
        or o.rgst_dt <> n.rgst_dt
        or o.indus_type_cd_level5_cls <> n.indus_type_cd_level5_cls
        or o.indus_type_cd_crdt_rating <> n.indus_type_cd_crdt_rating
        or o.open_cap <> n.open_cap
        or o.lmt_or_encrge_indus_cd <> n.lmt_or_encrge_indus_cd
        or o.loan_card_num_status <> n.loan_card_num_status
        or o.indus_type_cd_nat_stan <> n.indus_type_cd_nat_stan
        or o.industry_type <> n.industry_type
        or o.create_te <> n.create_te
        or o.create_org <> n.create_org
        or o.init_system_id <> n.init_system_id
        or o.init_created_ts <> n.init_created_ts
        or o.created_ts <> n.created_ts
        or o.last_updated_te <> n.last_updated_te
        or o.last_updated_org <> n.last_updated_org
        or o.last_system_id <> n.last_system_id
        or o.last_updated_ts <> n.last_updated_ts
        or o.owner_type <> n.owner_type
        or o.legal_name <> n.legal_name
        or o.legal_org_type <> n.legal_org_type
        or o.legal_cust_num <> n.legal_cust_num
        or o.superior_cust_num <> n.superior_cust_num
        or o.technology_org_type <> n.technology_org_type
        or o.technology_org_affirm_ts <> n.technology_org_affirm_ts
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
        or o.belong_type_cd <> n.belong_type_cd
        or o.self_info_flag <> n.self_info_flag
        or o.beneficiary_status <> n.beneficiary_status
        or o.beneficiary_attr <> n.beneficiary_attr
        or o.beneficial_owner <> n.beneficial_owner
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_corp_cust_ext_info_cl(
            party_id -- 参与人id
            ,cust_card_level_cd -- 客户持卡等级
            ,cust_asset_level_cd -- 客户资产等级
            ,cust_risk_level_cd -- 风险等级
            ,bad_rec_reason -- 不良记录原因
            ,blklist_cust_ind -- 黑名单客户标志
            ,up_blklist_dt -- 黑名单登记日期
            ,blklist_type -- 上黑名单原因
            ,credit_limit_flag_cd -- 综合授信额度
            ,used_crdt_limit -- 已用授信额度
            ,avail_crdt_limit -- 可用授信额度
            ,loan_card_num -- 贷款卡号
            ,resdnt_char_cd -- 居民性质
            ,group_cust_ind -- 集团客户标志
            ,belong_group_num -- 所属集团编号
            ,belong_group_name -- 所属集团名称
            ,eco_type -- 所有制（经济）性质
            ,list_corp_ind -- 上市公司标志
            ,shares_code -- 股票代码
            ,listed_address -- 上市地
            ,national_treatment -- 国民待遇
            ,first_credit_rela_time -- 首次建立信贷关系年月
            ,admin_number -- 管理人员人数
            ,lei -- lei代码
            ,lei_role -- lei角色
            ,dig_econ -- 数字经济
            ,new_str_eme -- 战略性新兴产业
            ,int_crdt_rating_cd -- 内部信用评级
            ,org_status_cd -- 机构状态
            ,eco_type_cd -- 经济类型
            ,rgst_dt -- 注册日期
            ,indus_type_cd_level5_cls -- 行业类型(五级分类)
            ,indus_type_cd_crdt_rating -- 行业类型(信用评级)
            ,open_cap -- 开办资金
            ,lmt_or_encrge_indus_cd -- 限制或鼓励行业
            ,loan_card_num_status -- 贷款卡号状态
            ,indus_type_cd_nat_stan -- 行业类型-国标
            ,industry_type -- 产业类型
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,owner_type -- 所有制类型
            ,legal_name -- 法人机构名称
            ,legal_org_type -- 法人机构类别
            ,legal_cust_num -- 法人机构客户号
            ,superior_cust_num -- 上级机构客户编号
            ,technology_org_type -- 科技型企业分类
            ,technology_org_affirm_ts -- 科技型企业认定时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,belong_type_cd -- 所属类别
            ,self_info_flag -- 自助维护标志
            ,beneficiary_status -- 受益人识别状态
            ,beneficiary_attr -- 受益所有人属性
            ,beneficial_owner -- 受益所有人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_corp_cust_ext_info_op(
            party_id -- 参与人id
            ,cust_card_level_cd -- 客户持卡等级
            ,cust_asset_level_cd -- 客户资产等级
            ,cust_risk_level_cd -- 风险等级
            ,bad_rec_reason -- 不良记录原因
            ,blklist_cust_ind -- 黑名单客户标志
            ,up_blklist_dt -- 黑名单登记日期
            ,blklist_type -- 上黑名单原因
            ,credit_limit_flag_cd -- 综合授信额度
            ,used_crdt_limit -- 已用授信额度
            ,avail_crdt_limit -- 可用授信额度
            ,loan_card_num -- 贷款卡号
            ,resdnt_char_cd -- 居民性质
            ,group_cust_ind -- 集团客户标志
            ,belong_group_num -- 所属集团编号
            ,belong_group_name -- 所属集团名称
            ,eco_type -- 所有制（经济）性质
            ,list_corp_ind -- 上市公司标志
            ,shares_code -- 股票代码
            ,listed_address -- 上市地
            ,national_treatment -- 国民待遇
            ,first_credit_rela_time -- 首次建立信贷关系年月
            ,admin_number -- 管理人员人数
            ,lei -- lei代码
            ,lei_role -- lei角色
            ,dig_econ -- 数字经济
            ,new_str_eme -- 战略性新兴产业
            ,int_crdt_rating_cd -- 内部信用评级
            ,org_status_cd -- 机构状态
            ,eco_type_cd -- 经济类型
            ,rgst_dt -- 注册日期
            ,indus_type_cd_level5_cls -- 行业类型(五级分类)
            ,indus_type_cd_crdt_rating -- 行业类型(信用评级)
            ,open_cap -- 开办资金
            ,lmt_or_encrge_indus_cd -- 限制或鼓励行业
            ,loan_card_num_status -- 贷款卡号状态
            ,indus_type_cd_nat_stan -- 行业类型-国标
            ,industry_type -- 产业类型
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,owner_type -- 所有制类型
            ,legal_name -- 法人机构名称
            ,legal_org_type -- 法人机构类别
            ,legal_cust_num -- 法人机构客户号
            ,superior_cust_num -- 上级机构客户编号
            ,technology_org_type -- 科技型企业分类
            ,technology_org_affirm_ts -- 科技型企业认定时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,belong_type_cd -- 所属类别
            ,self_info_flag -- 自助维护标志
            ,beneficiary_status -- 受益人识别状态
            ,beneficiary_attr -- 受益所有人属性
            ,beneficial_owner -- 受益所有人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 参与人id
    ,o.cust_card_level_cd -- 客户持卡等级
    ,o.cust_asset_level_cd -- 客户资产等级
    ,o.cust_risk_level_cd -- 风险等级
    ,o.bad_rec_reason -- 不良记录原因
    ,o.blklist_cust_ind -- 黑名单客户标志
    ,o.up_blklist_dt -- 黑名单登记日期
    ,o.blklist_type -- 上黑名单原因
    ,o.credit_limit_flag_cd -- 综合授信额度
    ,o.used_crdt_limit -- 已用授信额度
    ,o.avail_crdt_limit -- 可用授信额度
    ,o.loan_card_num -- 贷款卡号
    ,o.resdnt_char_cd -- 居民性质
    ,o.group_cust_ind -- 集团客户标志
    ,o.belong_group_num -- 所属集团编号
    ,o.belong_group_name -- 所属集团名称
    ,o.eco_type -- 所有制（经济）性质
    ,o.list_corp_ind -- 上市公司标志
    ,o.shares_code -- 股票代码
    ,o.listed_address -- 上市地
    ,o.national_treatment -- 国民待遇
    ,o.first_credit_rela_time -- 首次建立信贷关系年月
    ,o.admin_number -- 管理人员人数
    ,o.lei -- lei代码
    ,o.lei_role -- lei角色
    ,o.dig_econ -- 数字经济
    ,o.new_str_eme -- 战略性新兴产业
    ,o.int_crdt_rating_cd -- 内部信用评级
    ,o.org_status_cd -- 机构状态
    ,o.eco_type_cd -- 经济类型
    ,o.rgst_dt -- 注册日期
    ,o.indus_type_cd_level5_cls -- 行业类型(五级分类)
    ,o.indus_type_cd_crdt_rating -- 行业类型(信用评级)
    ,o.open_cap -- 开办资金
    ,o.lmt_or_encrge_indus_cd -- 限制或鼓励行业
    ,o.loan_card_num_status -- 贷款卡号状态
    ,o.indus_type_cd_nat_stan -- 行业类型-国标
    ,o.industry_type -- 产业类型
    ,o.create_te -- 创建柜员
    ,o.create_org -- 创建机构号
    ,o.init_system_id -- 创建渠道
    ,o.init_created_ts -- 源系统创建时间
    ,o.created_ts -- 进入ecif的时间
    ,o.updated_ts -- 在ecif中失效的时间
    ,o.last_updated_te -- 最新更新柜员
    ,o.last_updated_org -- 最新更新机构号
    ,o.last_system_id -- 最新更新渠道
    ,o.last_updated_ts -- 最新更新时间
    ,o.owner_type -- 所有制类型
    ,o.legal_name -- 法人机构名称
    ,o.legal_org_type -- 法人机构类别
    ,o.legal_cust_num -- 法人机构客户号
    ,o.superior_cust_num -- 上级机构客户编号
    ,o.technology_org_type -- 科技型企业分类
    ,o.technology_org_affirm_ts -- 科技型企业认定时间
    ,o.src_sys_num -- 来源系统编号
    ,o.last_updated_src_sys_num -- 最新更新源系统编号
    ,o.belong_type_cd -- 所属类别
    ,o.self_info_flag -- 自助维护标志
    ,o.beneficiary_status -- 受益人识别状态
    ,o.beneficiary_attr -- 受益所有人属性
    ,o.beneficial_owner -- 受益所有人
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
from ${iol_schema}.eifs_t01_corp_cust_ext_info_bk o
    left join ${iol_schema}.eifs_t01_corp_cust_ext_info_op n
        on
            o.party_id = n.party_id
            and o.updated_ts = n.updated_ts
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t01_corp_cust_ext_info_cl d
        on
            o.party_id = d.party_id
            and o.updated_ts = d.updated_ts
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t01_corp_cust_ext_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t01_corp_cust_ext_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t01_corp_cust_ext_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t01_corp_cust_ext_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t01_corp_cust_ext_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t01_corp_cust_ext_info_cl;
alter table ${iol_schema}.eifs_t01_corp_cust_ext_info exchange partition p_20991231 with table ${iol_schema}.eifs_t01_corp_cust_ext_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t01_corp_cust_ext_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_corp_cust_ext_info_op purge;
drop table ${iol_schema}.eifs_t01_corp_cust_ext_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t01_corp_cust_ext_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t01_corp_cust_ext_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
