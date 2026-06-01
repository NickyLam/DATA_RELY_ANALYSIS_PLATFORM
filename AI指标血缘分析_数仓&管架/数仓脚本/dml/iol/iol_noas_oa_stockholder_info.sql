/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_noas_oa_stockholder_info
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
create table ${iol_schema}.noas_oa_stockholder_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.noas_oa_stockholder_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_stockholder_info_op purge;
drop table ${iol_schema}.noas_oa_stockholder_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_stockholder_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_stockholder_info where 0=1;

create table ${iol_schema}.noas_oa_stockholder_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_stockholder_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_stockholder_info_cl(
            stock_info_id -- 
            ,stockholder_id -- 
            ,stockholder_name -- 
            ,certificate_type -- 
            ,certificate_code -- 
            ,organization_code -- 
            ,stockholder_type -- 
            ,stockholder_property -- 
            ,stock_own_amount -- 
            ,stock_limit_amount -- 
            ,stock_pledge_amount -- 
            ,stock_freeze_amount -- 
            ,address -- 
            ,post_code -- 
            ,linkman -- 
            ,phone -- 
            ,stock_certificate_code -- 
            ,interest_account -- 
            ,interest_account_name -- 
            ,interest_account_bank -- 
            ,stockholder_begin_date -- 
            ,stockholder_end_date -- 
            ,is_privillege_make_sure -- 
            ,status -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,dominant_stockholder -- 是否为控股股东
            ,national_economy_code -- 国民经济行业代码
            ,nature_of_ownership -- 所有制性质
            ,final_beneficiary -- 最终受益人
            ,actual_controller -- 实际控制人
            ,holding_organization -- 实际控制人管理机构
            ,indirector -- 是否派驻董监高
            ,controller_ratio -- 实际控制人及一致行动人持股比例
            ,main_stockholder -- 
            ,stock_statistic_type -- 
            ,east_stockholder_type -- EAST股东或关联方类型
            ,stockholder_certificate_type -- EAST股东或关联方证件类别
            ,stockholder_registration_place -- EAST股东或关联方注册地
            ,stockholder_share_bank_amount -- EAST作为主要股东参股商业银行的数量
            ,stockholder_hold_bank_amount -- EAST作为主要股东控股商业银行的数量
            ,bad_information -- EAST不良信息
            ,is_power_restraint -- EAST是否限权
            ,capital_source -- EAST入股资金来源
            ,fund_account -- EAST入股资金账号
            ,pledge_proportion -- EAST质押比例
            ,last_time_change_date -- EAST最近一次变动日期
            ,east_remark -- EAST备注
            ,foreign_stockholder -- G08外资股东
            ,nationality -- G08国别(地区)
            ,parent_company_place -- G08母公司所在国家(地区)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_stockholder_info_op(
            stock_info_id -- 
            ,stockholder_id -- 
            ,stockholder_name -- 
            ,certificate_type -- 
            ,certificate_code -- 
            ,organization_code -- 
            ,stockholder_type -- 
            ,stockholder_property -- 
            ,stock_own_amount -- 
            ,stock_limit_amount -- 
            ,stock_pledge_amount -- 
            ,stock_freeze_amount -- 
            ,address -- 
            ,post_code -- 
            ,linkman -- 
            ,phone -- 
            ,stock_certificate_code -- 
            ,interest_account -- 
            ,interest_account_name -- 
            ,interest_account_bank -- 
            ,stockholder_begin_date -- 
            ,stockholder_end_date -- 
            ,is_privillege_make_sure -- 
            ,status -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,dominant_stockholder -- 是否为控股股东
            ,national_economy_code -- 国民经济行业代码
            ,nature_of_ownership -- 所有制性质
            ,final_beneficiary -- 最终受益人
            ,actual_controller -- 实际控制人
            ,holding_organization -- 实际控制人管理机构
            ,indirector -- 是否派驻董监高
            ,controller_ratio -- 实际控制人及一致行动人持股比例
            ,main_stockholder -- 
            ,stock_statistic_type -- 
            ,east_stockholder_type -- EAST股东或关联方类型
            ,stockholder_certificate_type -- EAST股东或关联方证件类别
            ,stockholder_registration_place -- EAST股东或关联方注册地
            ,stockholder_share_bank_amount -- EAST作为主要股东参股商业银行的数量
            ,stockholder_hold_bank_amount -- EAST作为主要股东控股商业银行的数量
            ,bad_information -- EAST不良信息
            ,is_power_restraint -- EAST是否限权
            ,capital_source -- EAST入股资金来源
            ,fund_account -- EAST入股资金账号
            ,pledge_proportion -- EAST质押比例
            ,last_time_change_date -- EAST最近一次变动日期
            ,east_remark -- EAST备注
            ,foreign_stockholder -- G08外资股东
            ,nationality -- G08国别(地区)
            ,parent_company_place -- G08母公司所在国家(地区)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stock_info_id, o.stock_info_id) as stock_info_id -- 
    ,nvl(n.stockholder_id, o.stockholder_id) as stockholder_id -- 
    ,nvl(n.stockholder_name, o.stockholder_name) as stockholder_name -- 
    ,nvl(n.certificate_type, o.certificate_type) as certificate_type -- 
    ,nvl(n.certificate_code, o.certificate_code) as certificate_code -- 
    ,nvl(n.organization_code, o.organization_code) as organization_code -- 
    ,nvl(n.stockholder_type, o.stockholder_type) as stockholder_type -- 
    ,nvl(n.stockholder_property, o.stockholder_property) as stockholder_property -- 
    ,nvl(n.stock_own_amount, o.stock_own_amount) as stock_own_amount -- 
    ,nvl(n.stock_limit_amount, o.stock_limit_amount) as stock_limit_amount -- 
    ,nvl(n.stock_pledge_amount, o.stock_pledge_amount) as stock_pledge_amount -- 
    ,nvl(n.stock_freeze_amount, o.stock_freeze_amount) as stock_freeze_amount -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.post_code, o.post_code) as post_code -- 
    ,nvl(n.linkman, o.linkman) as linkman -- 
    ,nvl(n.phone, o.phone) as phone -- 
    ,nvl(n.stock_certificate_code, o.stock_certificate_code) as stock_certificate_code -- 
    ,nvl(n.interest_account, o.interest_account) as interest_account -- 
    ,nvl(n.interest_account_name, o.interest_account_name) as interest_account_name -- 
    ,nvl(n.interest_account_bank, o.interest_account_bank) as interest_account_bank -- 
    ,nvl(n.stockholder_begin_date, o.stockholder_begin_date) as stockholder_begin_date -- 
    ,nvl(n.stockholder_end_date, o.stockholder_end_date) as stockholder_end_date -- 
    ,nvl(n.is_privillege_make_sure, o.is_privillege_make_sure) as is_privillege_make_sure -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 
    ,nvl(n.dominant_stockholder, o.dominant_stockholder) as dominant_stockholder -- 是否为控股股东
    ,nvl(n.national_economy_code, o.national_economy_code) as national_economy_code -- 国民经济行业代码
    ,nvl(n.nature_of_ownership, o.nature_of_ownership) as nature_of_ownership -- 所有制性质
    ,nvl(n.final_beneficiary, o.final_beneficiary) as final_beneficiary -- 最终受益人
    ,nvl(n.actual_controller, o.actual_controller) as actual_controller -- 实际控制人
    ,nvl(n.holding_organization, o.holding_organization) as holding_organization -- 实际控制人管理机构
    ,nvl(n.indirector, o.indirector) as indirector -- 是否派驻董监高
    ,nvl(n.controller_ratio, o.controller_ratio) as controller_ratio -- 实际控制人及一致行动人持股比例
    ,nvl(n.main_stockholder, o.main_stockholder) as main_stockholder -- 
    ,nvl(n.stock_statistic_type, o.stock_statistic_type) as stock_statistic_type -- 
    ,nvl(n.east_stockholder_type, o.east_stockholder_type) as east_stockholder_type -- EAST股东或关联方类型
    ,nvl(n.stockholder_certificate_type, o.stockholder_certificate_type) as stockholder_certificate_type -- EAST股东或关联方证件类别
    ,nvl(n.stockholder_registration_place, o.stockholder_registration_place) as stockholder_registration_place -- EAST股东或关联方注册地
    ,nvl(n.stockholder_share_bank_amount, o.stockholder_share_bank_amount) as stockholder_share_bank_amount -- EAST作为主要股东参股商业银行的数量
    ,nvl(n.stockholder_hold_bank_amount, o.stockholder_hold_bank_amount) as stockholder_hold_bank_amount -- EAST作为主要股东控股商业银行的数量
    ,nvl(n.bad_information, o.bad_information) as bad_information -- EAST不良信息
    ,nvl(n.is_power_restraint, o.is_power_restraint) as is_power_restraint -- EAST是否限权
    ,nvl(n.capital_source, o.capital_source) as capital_source -- EAST入股资金来源
    ,nvl(n.fund_account, o.fund_account) as fund_account -- EAST入股资金账号
    ,nvl(n.pledge_proportion, o.pledge_proportion) as pledge_proportion -- EAST质押比例
    ,nvl(n.last_time_change_date, o.last_time_change_date) as last_time_change_date -- EAST最近一次变动日期
    ,nvl(n.east_remark, o.east_remark) as east_remark -- EAST备注
    ,nvl(n.foreign_stockholder, o.foreign_stockholder) as foreign_stockholder -- G08外资股东
    ,nvl(n.nationality, o.nationality) as nationality -- G08国别(地区)
    ,nvl(n.parent_company_place, o.parent_company_place) as parent_company_place -- G08母公司所在国家(地区)
    ,case when
            n.stock_info_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stock_info_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stock_info_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.noas_oa_stockholder_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.noas_oa_stockholder_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stock_info_id = n.stock_info_id
where (
        o.stock_info_id is null
    )
    or (
        n.stock_info_id is null
    )
    or (
        o.stockholder_id <> n.stockholder_id
        or o.stockholder_name <> n.stockholder_name
        or o.certificate_type <> n.certificate_type
        or o.certificate_code <> n.certificate_code
        or o.organization_code <> n.organization_code
        or o.stockholder_type <> n.stockholder_type
        or o.stockholder_property <> n.stockholder_property
        or o.stock_own_amount <> n.stock_own_amount
        or o.stock_limit_amount <> n.stock_limit_amount
        or o.stock_pledge_amount <> n.stock_pledge_amount
        or o.stock_freeze_amount <> n.stock_freeze_amount
        or o.address <> n.address
        or o.post_code <> n.post_code
        or o.linkman <> n.linkman
        or o.phone <> n.phone
        or o.stock_certificate_code <> n.stock_certificate_code
        or o.interest_account <> n.interest_account
        or o.interest_account_name <> n.interest_account_name
        or o.interest_account_bank <> n.interest_account_bank
        or o.stockholder_begin_date <> n.stockholder_begin_date
        or o.stockholder_end_date <> n.stockholder_end_date
        or o.is_privillege_make_sure <> n.is_privillege_make_sure
        or o.status <> n.status
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.dominant_stockholder <> n.dominant_stockholder
        or o.national_economy_code <> n.national_economy_code
        or o.nature_of_ownership <> n.nature_of_ownership
        or o.final_beneficiary <> n.final_beneficiary
        or o.actual_controller <> n.actual_controller
        or o.holding_organization <> n.holding_organization
        or o.indirector <> n.indirector
        or o.controller_ratio <> n.controller_ratio
        or o.main_stockholder <> n.main_stockholder
        or o.stock_statistic_type <> n.stock_statistic_type
        or o.east_stockholder_type <> n.east_stockholder_type
        or o.stockholder_certificate_type <> n.stockholder_certificate_type
        or o.stockholder_registration_place <> n.stockholder_registration_place
        or o.stockholder_share_bank_amount <> n.stockholder_share_bank_amount
        or o.stockholder_hold_bank_amount <> n.stockholder_hold_bank_amount
        or o.bad_information <> n.bad_information
        or o.is_power_restraint <> n.is_power_restraint
        or o.capital_source <> n.capital_source
        or o.fund_account <> n.fund_account
        or o.pledge_proportion <> n.pledge_proportion
        or o.last_time_change_date <> n.last_time_change_date
        or o.east_remark <> n.east_remark
        or o.foreign_stockholder <> n.foreign_stockholder
        or o.nationality <> n.nationality
        or o.parent_company_place <> n.parent_company_place
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_stockholder_info_cl(
            stock_info_id -- 
            ,stockholder_id -- 
            ,stockholder_name -- 
            ,certificate_type -- 
            ,certificate_code -- 
            ,organization_code -- 
            ,stockholder_type -- 
            ,stockholder_property -- 
            ,stock_own_amount -- 
            ,stock_limit_amount -- 
            ,stock_pledge_amount -- 
            ,stock_freeze_amount -- 
            ,address -- 
            ,post_code -- 
            ,linkman -- 
            ,phone -- 
            ,stock_certificate_code -- 
            ,interest_account -- 
            ,interest_account_name -- 
            ,interest_account_bank -- 
            ,stockholder_begin_date -- 
            ,stockholder_end_date -- 
            ,is_privillege_make_sure -- 
            ,status -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,dominant_stockholder -- 是否为控股股东
            ,national_economy_code -- 国民经济行业代码
            ,nature_of_ownership -- 所有制性质
            ,final_beneficiary -- 最终受益人
            ,actual_controller -- 实际控制人
            ,holding_organization -- 实际控制人管理机构
            ,indirector -- 是否派驻董监高
            ,controller_ratio -- 实际控制人及一致行动人持股比例
            ,main_stockholder -- 
            ,stock_statistic_type -- 
            ,east_stockholder_type -- EAST股东或关联方类型
            ,stockholder_certificate_type -- EAST股东或关联方证件类别
            ,stockholder_registration_place -- EAST股东或关联方注册地
            ,stockholder_share_bank_amount -- EAST作为主要股东参股商业银行的数量
            ,stockholder_hold_bank_amount -- EAST作为主要股东控股商业银行的数量
            ,bad_information -- EAST不良信息
            ,is_power_restraint -- EAST是否限权
            ,capital_source -- EAST入股资金来源
            ,fund_account -- EAST入股资金账号
            ,pledge_proportion -- EAST质押比例
            ,last_time_change_date -- EAST最近一次变动日期
            ,east_remark -- EAST备注
            ,foreign_stockholder -- G08外资股东
            ,nationality -- G08国别(地区)
            ,parent_company_place -- G08母公司所在国家(地区)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_stockholder_info_op(
            stock_info_id -- 
            ,stockholder_id -- 
            ,stockholder_name -- 
            ,certificate_type -- 
            ,certificate_code -- 
            ,organization_code -- 
            ,stockholder_type -- 
            ,stockholder_property -- 
            ,stock_own_amount -- 
            ,stock_limit_amount -- 
            ,stock_pledge_amount -- 
            ,stock_freeze_amount -- 
            ,address -- 
            ,post_code -- 
            ,linkman -- 
            ,phone -- 
            ,stock_certificate_code -- 
            ,interest_account -- 
            ,interest_account_name -- 
            ,interest_account_bank -- 
            ,stockholder_begin_date -- 
            ,stockholder_end_date -- 
            ,is_privillege_make_sure -- 
            ,status -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,dominant_stockholder -- 是否为控股股东
            ,national_economy_code -- 国民经济行业代码
            ,nature_of_ownership -- 所有制性质
            ,final_beneficiary -- 最终受益人
            ,actual_controller -- 实际控制人
            ,holding_organization -- 实际控制人管理机构
            ,indirector -- 是否派驻董监高
            ,controller_ratio -- 实际控制人及一致行动人持股比例
            ,main_stockholder -- 
            ,stock_statistic_type -- 
            ,east_stockholder_type -- EAST股东或关联方类型
            ,stockholder_certificate_type -- EAST股东或关联方证件类别
            ,stockholder_registration_place -- EAST股东或关联方注册地
            ,stockholder_share_bank_amount -- EAST作为主要股东参股商业银行的数量
            ,stockholder_hold_bank_amount -- EAST作为主要股东控股商业银行的数量
            ,bad_information -- EAST不良信息
            ,is_power_restraint -- EAST是否限权
            ,capital_source -- EAST入股资金来源
            ,fund_account -- EAST入股资金账号
            ,pledge_proportion -- EAST质押比例
            ,last_time_change_date -- EAST最近一次变动日期
            ,east_remark -- EAST备注
            ,foreign_stockholder -- G08外资股东
            ,nationality -- G08国别(地区)
            ,parent_company_place -- G08母公司所在国家(地区)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stock_info_id -- 
    ,o.stockholder_id -- 
    ,o.stockholder_name -- 
    ,o.certificate_type -- 
    ,o.certificate_code -- 
    ,o.organization_code -- 
    ,o.stockholder_type -- 
    ,o.stockholder_property -- 
    ,o.stock_own_amount -- 
    ,o.stock_limit_amount -- 
    ,o.stock_pledge_amount -- 
    ,o.stock_freeze_amount -- 
    ,o.address -- 
    ,o.post_code -- 
    ,o.linkman -- 
    ,o.phone -- 
    ,o.stock_certificate_code -- 
    ,o.interest_account -- 
    ,o.interest_account_name -- 
    ,o.interest_account_bank -- 
    ,o.stockholder_begin_date -- 
    ,o.stockholder_end_date -- 
    ,o.is_privillege_make_sure -- 
    ,o.status -- 
    ,o.last_updated_stamp -- 
    ,o.last_updated_tx_stamp -- 
    ,o.created_stamp -- 
    ,o.created_tx_stamp -- 
    ,o.dominant_stockholder -- 是否为控股股东
    ,o.national_economy_code -- 国民经济行业代码
    ,o.nature_of_ownership -- 所有制性质
    ,o.final_beneficiary -- 最终受益人
    ,o.actual_controller -- 实际控制人
    ,o.holding_organization -- 实际控制人管理机构
    ,o.indirector -- 是否派驻董监高
    ,o.controller_ratio -- 实际控制人及一致行动人持股比例
    ,o.main_stockholder -- 
    ,o.stock_statistic_type -- 
    ,o.east_stockholder_type -- EAST股东或关联方类型
    ,o.stockholder_certificate_type -- EAST股东或关联方证件类别
    ,o.stockholder_registration_place -- EAST股东或关联方注册地
    ,o.stockholder_share_bank_amount -- EAST作为主要股东参股商业银行的数量
    ,o.stockholder_hold_bank_amount -- EAST作为主要股东控股商业银行的数量
    ,o.bad_information -- EAST不良信息
    ,o.is_power_restraint -- EAST是否限权
    ,o.capital_source -- EAST入股资金来源
    ,o.fund_account -- EAST入股资金账号
    ,o.pledge_proportion -- EAST质押比例
    ,o.last_time_change_date -- EAST最近一次变动日期
    ,o.east_remark -- EAST备注
    ,o.foreign_stockholder -- G08外资股东
    ,o.nationality -- G08国别(地区)
    ,o.parent_company_place -- G08母公司所在国家(地区)
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
from ${iol_schema}.noas_oa_stockholder_info_bk o
    left join ${iol_schema}.noas_oa_stockholder_info_op n
        on
            o.stock_info_id = n.stock_info_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.noas_oa_stockholder_info_cl d
        on
            o.stock_info_id = d.stock_info_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.noas_oa_stockholder_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('noas_oa_stockholder_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.noas_oa_stockholder_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.noas_oa_stockholder_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.noas_oa_stockholder_info exchange partition p_${batch_date} with table ${iol_schema}.noas_oa_stockholder_info_cl;
alter table ${iol_schema}.noas_oa_stockholder_info exchange partition p_20991231 with table ${iol_schema}.noas_oa_stockholder_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.noas_oa_stockholder_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_stockholder_info_op purge;
drop table ${iol_schema}.noas_oa_stockholder_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.noas_oa_stockholder_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'noas_oa_stockholder_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
