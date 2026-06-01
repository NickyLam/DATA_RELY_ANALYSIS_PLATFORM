/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol noas_oa_stockholder_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.noas_oa_stockholder_info
whenever sqlerror continue none;
drop table ${iol_schema}.noas_oa_stockholder_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_stockholder_info(
    stock_info_id varchar2(30) -- 
    ,stockholder_id varchar2(30) -- 
    ,stockholder_name varchar2(383) -- 
    ,certificate_type varchar2(15) -- 
    ,certificate_code varchar2(383) -- 
    ,organization_code varchar2(383) -- 
    ,stockholder_type varchar2(15) -- 
    ,stockholder_property varchar2(15) -- 
    ,stock_own_amount number(20,0) -- 
    ,stock_limit_amount number(20,0) -- 
    ,stock_pledge_amount number(20,0) -- 
    ,stock_freeze_amount number(20,0) -- 
    ,address varchar2(600) -- 
    ,post_code varchar2(15) -- 
    ,linkman varchar2(383) -- 
    ,phone varchar2(90) -- 
    ,stock_certificate_code varchar2(383) -- 
    ,interest_account varchar2(383) -- 
    ,interest_account_name varchar2(383) -- 
    ,interest_account_bank varchar2(383) -- 
    ,stockholder_begin_date date -- 
    ,stockholder_end_date date -- 
    ,is_privillege_make_sure varchar2(2) -- 
    ,status varchar2(2) -- 
    ,last_updated_stamp timestamp -- 
    ,last_updated_tx_stamp timestamp -- 
    ,created_stamp timestamp -- 
    ,created_tx_stamp timestamp -- 
    ,dominant_stockholder varchar2(30) -- 是否为控股股东
    ,national_economy_code varchar2(383) -- 国民经济行业代码
    ,nature_of_ownership varchar2(30) -- 所有制性质
    ,final_beneficiary varchar2(383) -- 最终受益人
    ,actual_controller varchar2(383) -- 实际控制人
    ,holding_organization varchar2(30) -- 实际控制人管理机构
    ,indirector varchar2(30) -- 是否派驻董监高
    ,controller_ratio varchar2(15) -- 实际控制人及一致行动人持股比例
    ,main_stockholder varchar2(30) -- 
    ,stock_statistic_type varchar2(15) -- 
    ,east_stockholder_type varchar2(15) -- east股东或关联方类型
    ,stockholder_certificate_type varchar2(15) -- east股东或关联方证件类别
    ,stockholder_registration_place varchar2(600) -- east股东或关联方注册地
    ,stockholder_share_bank_amount number(20,0) -- east作为主要股东参股商业银行的数量
    ,stockholder_hold_bank_amount number(20,0) -- east作为主要股东控股商业银行的数量
    ,bad_information varchar2(600) -- east不良信息
    ,is_power_restraint varchar2(30) -- east是否限权
    ,capital_source varchar2(15) -- east入股资金来源
    ,fund_account varchar2(383) -- east入股资金账号
    ,pledge_proportion varchar2(90) -- east质押比例
    ,last_time_change_date date -- east最近一次变动日期
    ,east_remark varchar2(600) -- east备注
    ,foreign_stockholder varchar2(30) -- g08外资股东
    ,nationality varchar2(383) -- g08国别(地区)
    ,parent_company_place varchar2(383) -- g08母公司所在国家(地区)
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
grant select on ${iol_schema}.noas_oa_stockholder_info to ${iml_schema};
grant select on ${iol_schema}.noas_oa_stockholder_info to ${icl_schema};
grant select on ${iol_schema}.noas_oa_stockholder_info to ${idl_schema};
grant select on ${iol_schema}.noas_oa_stockholder_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.noas_oa_stockholder_info is '股东信息表';
comment on column ${iol_schema}.noas_oa_stockholder_info.stock_info_id is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.stockholder_id is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.stockholder_name is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.certificate_type is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.certificate_code is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.organization_code is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.stockholder_type is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.stockholder_property is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.stock_own_amount is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.stock_limit_amount is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.stock_pledge_amount is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.stock_freeze_amount is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.address is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.post_code is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.linkman is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.phone is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.stock_certificate_code is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.interest_account is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.interest_account_name is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.interest_account_bank is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.stockholder_begin_date is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.stockholder_end_date is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.is_privillege_make_sure is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.status is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.last_updated_stamp is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.last_updated_tx_stamp is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.created_stamp is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.created_tx_stamp is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.dominant_stockholder is '是否为控股股东';
comment on column ${iol_schema}.noas_oa_stockholder_info.national_economy_code is '国民经济行业代码';
comment on column ${iol_schema}.noas_oa_stockholder_info.nature_of_ownership is '所有制性质';
comment on column ${iol_schema}.noas_oa_stockholder_info.final_beneficiary is '最终受益人';
comment on column ${iol_schema}.noas_oa_stockholder_info.actual_controller is '实际控制人';
comment on column ${iol_schema}.noas_oa_stockholder_info.holding_organization is '实际控制人管理机构';
comment on column ${iol_schema}.noas_oa_stockholder_info.indirector is '是否派驻董监高';
comment on column ${iol_schema}.noas_oa_stockholder_info.controller_ratio is '实际控制人及一致行动人持股比例';
comment on column ${iol_schema}.noas_oa_stockholder_info.main_stockholder is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.stock_statistic_type is '';
comment on column ${iol_schema}.noas_oa_stockholder_info.east_stockholder_type is 'east股东或关联方类型';
comment on column ${iol_schema}.noas_oa_stockholder_info.stockholder_certificate_type is 'east股东或关联方证件类别';
comment on column ${iol_schema}.noas_oa_stockholder_info.stockholder_registration_place is 'east股东或关联方注册地';
comment on column ${iol_schema}.noas_oa_stockholder_info.stockholder_share_bank_amount is 'east作为主要股东参股商业银行的数量';
comment on column ${iol_schema}.noas_oa_stockholder_info.stockholder_hold_bank_amount is 'east作为主要股东控股商业银行的数量';
comment on column ${iol_schema}.noas_oa_stockholder_info.bad_information is 'east不良信息';
comment on column ${iol_schema}.noas_oa_stockholder_info.is_power_restraint is 'east是否限权';
comment on column ${iol_schema}.noas_oa_stockholder_info.capital_source is 'east入股资金来源';
comment on column ${iol_schema}.noas_oa_stockholder_info.fund_account is 'east入股资金账号';
comment on column ${iol_schema}.noas_oa_stockholder_info.pledge_proportion is 'east质押比例';
comment on column ${iol_schema}.noas_oa_stockholder_info.last_time_change_date is 'east最近一次变动日期';
comment on column ${iol_schema}.noas_oa_stockholder_info.east_remark is 'east备注';
comment on column ${iol_schema}.noas_oa_stockholder_info.foreign_stockholder is 'g08外资股东';
comment on column ${iol_schema}.noas_oa_stockholder_info.nationality is 'g08国别(地区)';
comment on column ${iol_schema}.noas_oa_stockholder_info.parent_company_place is 'g08母公司所在国家(地区)';
comment on column ${iol_schema}.noas_oa_stockholder_info.start_dt is '开始时间';
comment on column ${iol_schema}.noas_oa_stockholder_info.end_dt is '结束时间';
comment on column ${iol_schema}.noas_oa_stockholder_info.id_mark is '增删标志';
comment on column ${iol_schema}.noas_oa_stockholder_info.etl_timestamp is 'ETL处理时间戳';
