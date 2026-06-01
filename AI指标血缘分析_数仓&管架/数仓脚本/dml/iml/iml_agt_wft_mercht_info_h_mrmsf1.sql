/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wft_mercht_info_h_mrmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_wft_mercht_info_h add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mrmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wft_mercht_info_h partition for ('mrmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_op purge;
drop table ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,mercht_type_descb -- 商户类型描述
    ,wft_org_id -- 威富通机构编号
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_type_descb -- 企业证件类型描述
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_effect_dt -- 企业证件生效日期
    ,corp_cert_invalid_dt -- 企业证件失效日期
    ,mang_range -- 经营范围
    ,rgst_addr -- 注册地址
    ,legal_rep_name -- 法定代表人名称
    ,legal_rep_gender_cd -- 法定代表人性别代码
    ,legal_rep_gender_descb -- 法定代表人性别描述
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_type -- 法定代表人证件类型
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,legal_rep_cert_effect_dt -- 法定代表人证件生效日期
    ,legal_rep_cert_invalid_dt -- 法定代表人证件失效日期
    ,legal_rep_mobile_no -- 法定代表人手机号码
    ,bnft_owner_name -- 受益所有人名称
    ,bnft_owner_cert_type_cd -- 受益所有人证件类型代码
    ,bnft_owner_cert_type_descb -- 受益所有人证件类型描述
    ,bnft_owner_cert_no -- 受益所有人证件号码
    ,bnft_owner_cert_effect_dt -- 受益所有人证件生效日期
    ,bnft_owner_cert_invalid_dt -- 受益所有人证件失效日期
    ,bnft_owner_dtl_addr -- 受益所有人详细地址
    ,hold_shard_name -- 控股股东名称
    ,hold_shard_cert_type_cd -- 控股股东证件类型代码
    ,hold_shard_cert_type_descb -- 控股股东证件类型描述
    ,hold_shard_cert_no -- 控股股东证件号码
    ,hold_shard_cert_effect_dt -- 控股股东证件生效日期
    ,hold_shard_cert_invalid_dt -- 控股股东证件失效日期
    ,auth_trast_ps_name -- 授权办理人名称
    ,auth_trast_ps_cert_type_cd -- 授权办理人证件类型代码
    ,auth_trast_ps_cert_type_descb -- 授权办理人证件类型描述
    ,auth_trast_ps_cert_no -- 授权办理人证件号码
    ,auth_trast_ps_cert_effect_dt -- 授权办理人证件生效日期
    ,auth_trast_ps_cert_invalid_dt -- 授权办理人证件失效日期
    ,belong_org_id -- 所属机构编号
    ,mercht_check_status_descb -- 商户审核状态描述
    ,mercht_actv_status_descb -- 商户激活状态描述
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_type_cd -- 结算账户类型
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_open_bank_name -- 结算账户开户行名称
    ,init_create_dt -- 最初创建日期
    ,final_modif_dt -- 最后修改日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wft_mercht_info_h partition for ('mrmsf1')
where 0=1
;

create table ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wft_mercht_info_h partition for ('mrmsf1') where 0=1;

create table ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wft_mercht_info_h partition for ('mrmsf1') where 0=1;

-- 3.1 get new data into table
-- mrms_bth_wft_cms_merchant-1
insert into ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,mercht_type_descb -- 商户类型描述
    ,wft_org_id -- 威富通机构编号
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_type_descb -- 企业证件类型描述
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_effect_dt -- 企业证件生效日期
    ,corp_cert_invalid_dt -- 企业证件失效日期
    ,mang_range -- 经营范围
    ,rgst_addr -- 注册地址
    ,legal_rep_name -- 法定代表人名称
    ,legal_rep_gender_cd -- 法定代表人性别代码
    ,legal_rep_gender_descb -- 法定代表人性别描述
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_type -- 法定代表人证件类型
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,legal_rep_cert_effect_dt -- 法定代表人证件生效日期
    ,legal_rep_cert_invalid_dt -- 法定代表人证件失效日期
    ,legal_rep_mobile_no -- 法定代表人手机号码
    ,bnft_owner_name -- 受益所有人名称
    ,bnft_owner_cert_type_cd -- 受益所有人证件类型代码
    ,bnft_owner_cert_type_descb -- 受益所有人证件类型描述
    ,bnft_owner_cert_no -- 受益所有人证件号码
    ,bnft_owner_cert_effect_dt -- 受益所有人证件生效日期
    ,bnft_owner_cert_invalid_dt -- 受益所有人证件失效日期
    ,bnft_owner_dtl_addr -- 受益所有人详细地址
    ,hold_shard_name -- 控股股东名称
    ,hold_shard_cert_type_cd -- 控股股东证件类型代码
    ,hold_shard_cert_type_descb -- 控股股东证件类型描述
    ,hold_shard_cert_no -- 控股股东证件号码
    ,hold_shard_cert_effect_dt -- 控股股东证件生效日期
    ,hold_shard_cert_invalid_dt -- 控股股东证件失效日期
    ,auth_trast_ps_name -- 授权办理人名称
    ,auth_trast_ps_cert_type_cd -- 授权办理人证件类型代码
    ,auth_trast_ps_cert_type_descb -- 授权办理人证件类型描述
    ,auth_trast_ps_cert_no -- 授权办理人证件号码
    ,auth_trast_ps_cert_effect_dt -- 授权办理人证件生效日期
    ,auth_trast_ps_cert_invalid_dt -- 授权办理人证件失效日期
    ,belong_org_id -- 所属机构编号
    ,mercht_check_status_descb -- 商户审核状态描述
    ,mercht_actv_status_descb -- 商户激活状态描述
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_type_cd -- 结算账户类型
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_open_bank_name -- 结算账户开户行名称
    ,init_create_dt -- 最初创建日期
    ,final_modif_dt -- 最后修改日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300052'||P1.MERCHANT -- 协议编号
    ,'9999' -- 法人编号
    ,P1.MERCHANT -- 商户编号
    ,P1.MERCHANT_NAME -- 商户名称
    ,P1.MERCHANT_TYPE -- 商户类型描述
    ,P1.BRANCH_NO -- 威富通机构编号
    ,nvl(trim(P1.COMPANY_ID_TYPE_VALUE),'0000') -- 企业证件类型代码
    ,P1.COMPANY_ID_TYPE -- 企业证件类型描述
    ,P1.COMPANY_ID -- 企业证件号码
    ,${iml_schema}.dateformat_min(P1.COMPANY_ID_START_DATE) -- 企业证件生效日期
    ,${iml_schema}.dateformat_max2(P1.COMPANY_ID_END_DATE) -- 企业证件失效日期
    ,P1.BUSINESS_SCOPE -- 经营范围
    ,P1.REGISTER_ADDRESS -- 注册地址
    ,P1.LEGAL_REPRESENTATIVE_NAME -- 法定代表人名称
    ,nvl(trim(P1.LEGAL_REPRESENTATIVE_SEX_VALUE),'0') -- 法定代表人性别代码
    ,P1.LEGAL_REPRESENTATIVE_SEX -- 法定代表人性别描述
    ,nvl(trim(P1.LEGAL_REPRESENTATIVE_ID_TYPE_VALUE),'0000') -- 法定代表人证件类型代码
    ,P1.LEGAL_REPRESENTATIVE_ID_TYPE -- 法定代表人证件类型
    ,P1.LEGAL_REPRESENTATIVE_ID -- 法定代表人证件号码
    ,${iml_schema}.dateformat_min(P1.LEGAL_REPRESENTATIVE_ID_START_DATE) -- 法定代表人证件生效日期
    ,${iml_schema}.dateformat_max2(P1.LEGAL_REPRESENTATIVE_ID_END_DATE) -- 法定代表人证件失效日期
    ,P1.LEGAL_REPRESENTATIVE_PHONE -- 法定代表人手机号码
    ,P1.BENEFICIAL_OWNER_NAME -- 受益所有人名称
    ,nvl(trim(P1.BENEFICIAL_OWNER_ID_TYPE_VALUE),'0000') -- 受益所有人证件类型代码
    ,P1.BENEFICIAL_OWNER_ID_TYPE -- 受益所有人证件类型描述
    ,P1.BENEFICIAL_OWNER_ID -- 受益所有人证件号码
    ,${iml_schema}.dateformat_min(P1.BENEFICIAL_OWNER_ID_START_DATE) -- 受益所有人证件生效日期
    ,${iml_schema}.dateformat_max2(P1.BENEFICIAL_OWNER_ID_END_DATE) -- 受益所有人证件失效日期
    ,P1.BENEFICIAL_OWNER_ADDRESS -- 受益所有人详细地址
    ,P1.CONTROL_SHAREHOLDER_NAME -- 控股股东名称
    ,nvl(trim(P1.CONTROL_SHAREHOLDER_ID_TYPE_VALUE),'0000') -- 控股股东证件类型代码
    ,P1.CONTROL_SHAREHOLDER_ID_TYPE -- 控股股东证件类型描述
    ,P1.CONTROL_SHAREHOLDER_ID -- 控股股东证件号码
    ,${iml_schema}.dateformat_min(P1.CONTROL_SHAREHOLDER_ID_START_DATE) -- 控股股东证件生效日期
    ,${iml_schema}.dateformat_max2(P1.CONTROL_SHAREHOLDER_ID_END_DATE) -- 控股股东证件失效日期
    ,P1.AUTHOR_AGENT_NAME -- 授权办理人名称
    ,nvl(trim(P1.AUTHOR_AGENT_ID_TYPE_VALUE),'0000') -- 授权办理人证件类型代码
    ,P1.AUTHOR_AGENT_ID_TYPE -- 授权办理人证件类型描述
    ,P1.AUTHOR_AGENT_ID -- 授权办理人证件号码
    ,${iml_schema}.dateformat_min(P1.AUTHOR_AGENT_ID_START_DATE) -- 授权办理人证件生效日期
    ,${iml_schema}.dateformat_max2(P1.AUTHOR_AGENT_ID_END_DATE) -- 授权办理人证件失效日期
    ,P1.GHBANK_BRANCH_NO -- 所属机构编号
    ,P1.REMARK1 -- 商户审核状态描述
    ,P1.REMARK2 -- 商户激活状态描述
    ,P1.SETTLE_ACCNO_NAME -- 结算账户名称
    ,nvl(trim(P1.SETTLE_ACCNO_TYPE),'-') -- 结算账户类型
    ,P1.SETTLE_ACCNO -- 结算账户编号
    ,P1.SETTLE_BANK_NAME -- 结算账户开户行名称
    ,${iml_schema}.dateformat_min(P1.CREATE_DATE) -- 最初创建日期
    ,${iml_schema}.dateformat_max2(P1.UPDATE_DATE) -- 最后修改日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_bth_wft_cms_merchant' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_bth_wft_cms_merchant p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,mercht_type_descb -- 商户类型描述
    ,wft_org_id -- 威富通机构编号
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_type_descb -- 企业证件类型描述
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_effect_dt -- 企业证件生效日期
    ,corp_cert_invalid_dt -- 企业证件失效日期
    ,mang_range -- 经营范围
    ,rgst_addr -- 注册地址
    ,legal_rep_name -- 法定代表人名称
    ,legal_rep_gender_cd -- 法定代表人性别代码
    ,legal_rep_gender_descb -- 法定代表人性别描述
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_type -- 法定代表人证件类型
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,legal_rep_cert_effect_dt -- 法定代表人证件生效日期
    ,legal_rep_cert_invalid_dt -- 法定代表人证件失效日期
    ,legal_rep_mobile_no -- 法定代表人手机号码
    ,bnft_owner_name -- 受益所有人名称
    ,bnft_owner_cert_type_cd -- 受益所有人证件类型代码
    ,bnft_owner_cert_type_descb -- 受益所有人证件类型描述
    ,bnft_owner_cert_no -- 受益所有人证件号码
    ,bnft_owner_cert_effect_dt -- 受益所有人证件生效日期
    ,bnft_owner_cert_invalid_dt -- 受益所有人证件失效日期
    ,bnft_owner_dtl_addr -- 受益所有人详细地址
    ,hold_shard_name -- 控股股东名称
    ,hold_shard_cert_type_cd -- 控股股东证件类型代码
    ,hold_shard_cert_type_descb -- 控股股东证件类型描述
    ,hold_shard_cert_no -- 控股股东证件号码
    ,hold_shard_cert_effect_dt -- 控股股东证件生效日期
    ,hold_shard_cert_invalid_dt -- 控股股东证件失效日期
    ,auth_trast_ps_name -- 授权办理人名称
    ,auth_trast_ps_cert_type_cd -- 授权办理人证件类型代码
    ,auth_trast_ps_cert_type_descb -- 授权办理人证件类型描述
    ,auth_trast_ps_cert_no -- 授权办理人证件号码
    ,auth_trast_ps_cert_effect_dt -- 授权办理人证件生效日期
    ,auth_trast_ps_cert_invalid_dt -- 授权办理人证件失效日期
    ,belong_org_id -- 所属机构编号
    ,mercht_check_status_descb -- 商户审核状态描述
    ,mercht_actv_status_descb -- 商户激活状态描述
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_type_cd -- 结算账户类型
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_open_bank_name -- 结算账户开户行名称
    ,init_create_dt -- 最初创建日期
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,mercht_type_descb -- 商户类型描述
    ,wft_org_id -- 威富通机构编号
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_type_descb -- 企业证件类型描述
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_effect_dt -- 企业证件生效日期
    ,corp_cert_invalid_dt -- 企业证件失效日期
    ,mang_range -- 经营范围
    ,rgst_addr -- 注册地址
    ,legal_rep_name -- 法定代表人名称
    ,legal_rep_gender_cd -- 法定代表人性别代码
    ,legal_rep_gender_descb -- 法定代表人性别描述
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_type -- 法定代表人证件类型
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,legal_rep_cert_effect_dt -- 法定代表人证件生效日期
    ,legal_rep_cert_invalid_dt -- 法定代表人证件失效日期
    ,legal_rep_mobile_no -- 法定代表人手机号码
    ,bnft_owner_name -- 受益所有人名称
    ,bnft_owner_cert_type_cd -- 受益所有人证件类型代码
    ,bnft_owner_cert_type_descb -- 受益所有人证件类型描述
    ,bnft_owner_cert_no -- 受益所有人证件号码
    ,bnft_owner_cert_effect_dt -- 受益所有人证件生效日期
    ,bnft_owner_cert_invalid_dt -- 受益所有人证件失效日期
    ,bnft_owner_dtl_addr -- 受益所有人详细地址
    ,hold_shard_name -- 控股股东名称
    ,hold_shard_cert_type_cd -- 控股股东证件类型代码
    ,hold_shard_cert_type_descb -- 控股股东证件类型描述
    ,hold_shard_cert_no -- 控股股东证件号码
    ,hold_shard_cert_effect_dt -- 控股股东证件生效日期
    ,hold_shard_cert_invalid_dt -- 控股股东证件失效日期
    ,auth_trast_ps_name -- 授权办理人名称
    ,auth_trast_ps_cert_type_cd -- 授权办理人证件类型代码
    ,auth_trast_ps_cert_type_descb -- 授权办理人证件类型描述
    ,auth_trast_ps_cert_no -- 授权办理人证件号码
    ,auth_trast_ps_cert_effect_dt -- 授权办理人证件生效日期
    ,auth_trast_ps_cert_invalid_dt -- 授权办理人证件失效日期
    ,belong_org_id -- 所属机构编号
    ,mercht_check_status_descb -- 商户审核状态描述
    ,mercht_actv_status_descb -- 商户激活状态描述
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_type_cd -- 结算账户类型
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_open_bank_name -- 结算账户开户行名称
    ,init_create_dt -- 最初创建日期
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.mercht_name, o.mercht_name) as mercht_name -- 商户名称
    ,nvl(n.mercht_type_descb, o.mercht_type_descb) as mercht_type_descb -- 商户类型描述
    ,nvl(n.wft_org_id, o.wft_org_id) as wft_org_id -- 威富通机构编号
    ,nvl(n.corp_cert_type_cd, o.corp_cert_type_cd) as corp_cert_type_cd -- 企业证件类型代码
    ,nvl(n.corp_cert_type_descb, o.corp_cert_type_descb) as corp_cert_type_descb -- 企业证件类型描述
    ,nvl(n.corp_cert_no, o.corp_cert_no) as corp_cert_no -- 企业证件号码
    ,nvl(n.corp_cert_effect_dt, o.corp_cert_effect_dt) as corp_cert_effect_dt -- 企业证件生效日期
    ,nvl(n.corp_cert_invalid_dt, o.corp_cert_invalid_dt) as corp_cert_invalid_dt -- 企业证件失效日期
    ,nvl(n.mang_range, o.mang_range) as mang_range -- 经营范围
    ,nvl(n.rgst_addr, o.rgst_addr) as rgst_addr -- 注册地址
    ,nvl(n.legal_rep_name, o.legal_rep_name) as legal_rep_name -- 法定代表人名称
    ,nvl(n.legal_rep_gender_cd, o.legal_rep_gender_cd) as legal_rep_gender_cd -- 法定代表人性别代码
    ,nvl(n.legal_rep_gender_descb, o.legal_rep_gender_descb) as legal_rep_gender_descb -- 法定代表人性别描述
    ,nvl(n.legal_rep_cert_type_cd, o.legal_rep_cert_type_cd) as legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,nvl(n.legal_rep_cert_type, o.legal_rep_cert_type) as legal_rep_cert_type -- 法定代表人证件类型
    ,nvl(n.legal_rep_cert_no, o.legal_rep_cert_no) as legal_rep_cert_no -- 法定代表人证件号码
    ,nvl(n.legal_rep_cert_effect_dt, o.legal_rep_cert_effect_dt) as legal_rep_cert_effect_dt -- 法定代表人证件生效日期
    ,nvl(n.legal_rep_cert_invalid_dt, o.legal_rep_cert_invalid_dt) as legal_rep_cert_invalid_dt -- 法定代表人证件失效日期
    ,nvl(n.legal_rep_mobile_no, o.legal_rep_mobile_no) as legal_rep_mobile_no -- 法定代表人手机号码
    ,nvl(n.bnft_owner_name, o.bnft_owner_name) as bnft_owner_name -- 受益所有人名称
    ,nvl(n.bnft_owner_cert_type_cd, o.bnft_owner_cert_type_cd) as bnft_owner_cert_type_cd -- 受益所有人证件类型代码
    ,nvl(n.bnft_owner_cert_type_descb, o.bnft_owner_cert_type_descb) as bnft_owner_cert_type_descb -- 受益所有人证件类型描述
    ,nvl(n.bnft_owner_cert_no, o.bnft_owner_cert_no) as bnft_owner_cert_no -- 受益所有人证件号码
    ,nvl(n.bnft_owner_cert_effect_dt, o.bnft_owner_cert_effect_dt) as bnft_owner_cert_effect_dt -- 受益所有人证件生效日期
    ,nvl(n.bnft_owner_cert_invalid_dt, o.bnft_owner_cert_invalid_dt) as bnft_owner_cert_invalid_dt -- 受益所有人证件失效日期
    ,nvl(n.bnft_owner_dtl_addr, o.bnft_owner_dtl_addr) as bnft_owner_dtl_addr -- 受益所有人详细地址
    ,nvl(n.hold_shard_name, o.hold_shard_name) as hold_shard_name -- 控股股东名称
    ,nvl(n.hold_shard_cert_type_cd, o.hold_shard_cert_type_cd) as hold_shard_cert_type_cd -- 控股股东证件类型代码
    ,nvl(n.hold_shard_cert_type_descb, o.hold_shard_cert_type_descb) as hold_shard_cert_type_descb -- 控股股东证件类型描述
    ,nvl(n.hold_shard_cert_no, o.hold_shard_cert_no) as hold_shard_cert_no -- 控股股东证件号码
    ,nvl(n.hold_shard_cert_effect_dt, o.hold_shard_cert_effect_dt) as hold_shard_cert_effect_dt -- 控股股东证件生效日期
    ,nvl(n.hold_shard_cert_invalid_dt, o.hold_shard_cert_invalid_dt) as hold_shard_cert_invalid_dt -- 控股股东证件失效日期
    ,nvl(n.auth_trast_ps_name, o.auth_trast_ps_name) as auth_trast_ps_name -- 授权办理人名称
    ,nvl(n.auth_trast_ps_cert_type_cd, o.auth_trast_ps_cert_type_cd) as auth_trast_ps_cert_type_cd -- 授权办理人证件类型代码
    ,nvl(n.auth_trast_ps_cert_type_descb, o.auth_trast_ps_cert_type_descb) as auth_trast_ps_cert_type_descb -- 授权办理人证件类型描述
    ,nvl(n.auth_trast_ps_cert_no, o.auth_trast_ps_cert_no) as auth_trast_ps_cert_no -- 授权办理人证件号码
    ,nvl(n.auth_trast_ps_cert_effect_dt, o.auth_trast_ps_cert_effect_dt) as auth_trast_ps_cert_effect_dt -- 授权办理人证件生效日期
    ,nvl(n.auth_trast_ps_cert_invalid_dt, o.auth_trast_ps_cert_invalid_dt) as auth_trast_ps_cert_invalid_dt -- 授权办理人证件失效日期
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.mercht_check_status_descb, o.mercht_check_status_descb) as mercht_check_status_descb -- 商户审核状态描述
    ,nvl(n.mercht_actv_status_descb, o.mercht_actv_status_descb) as mercht_actv_status_descb -- 商户激活状态描述
    ,nvl(n.stl_acct_name, o.stl_acct_name) as stl_acct_name -- 结算账户名称
    ,nvl(n.stl_acct_type_cd, o.stl_acct_type_cd) as stl_acct_type_cd -- 结算账户类型
    ,nvl(n.stl_acct_id, o.stl_acct_id) as stl_acct_id -- 结算账户编号
    ,nvl(n.stl_acct_open_bank_name, o.stl_acct_open_bank_name) as stl_acct_open_bank_name -- 结算账户开户行名称
    ,nvl(n.init_create_dt, o.init_create_dt) as init_create_dt -- 最初创建日期
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_tm n
    full join (select * from ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.mercht_id <> n.mercht_id
        or o.mercht_name <> n.mercht_name
        or o.mercht_type_descb <> n.mercht_type_descb
        or o.wft_org_id <> n.wft_org_id
        or o.corp_cert_type_cd <> n.corp_cert_type_cd
        or o.corp_cert_type_descb <> n.corp_cert_type_descb
        or o.corp_cert_no <> n.corp_cert_no
        or o.corp_cert_effect_dt <> n.corp_cert_effect_dt
        or o.corp_cert_invalid_dt <> n.corp_cert_invalid_dt
        or o.mang_range <> n.mang_range
        or o.rgst_addr <> n.rgst_addr
        or o.legal_rep_name <> n.legal_rep_name
        or o.legal_rep_gender_cd <> n.legal_rep_gender_cd
        or o.legal_rep_gender_descb <> n.legal_rep_gender_descb
        or o.legal_rep_cert_type_cd <> n.legal_rep_cert_type_cd
        or o.legal_rep_cert_type <> n.legal_rep_cert_type
        or o.legal_rep_cert_no <> n.legal_rep_cert_no
        or o.legal_rep_cert_effect_dt <> n.legal_rep_cert_effect_dt
        or o.legal_rep_cert_invalid_dt <> n.legal_rep_cert_invalid_dt
        or o.legal_rep_mobile_no <> n.legal_rep_mobile_no
        or o.bnft_owner_name <> n.bnft_owner_name
        or o.bnft_owner_cert_type_cd <> n.bnft_owner_cert_type_cd
        or o.bnft_owner_cert_type_descb <> n.bnft_owner_cert_type_descb
        or o.bnft_owner_cert_no <> n.bnft_owner_cert_no
        or o.bnft_owner_cert_effect_dt <> n.bnft_owner_cert_effect_dt
        or o.bnft_owner_cert_invalid_dt <> n.bnft_owner_cert_invalid_dt
        or o.bnft_owner_dtl_addr <> n.bnft_owner_dtl_addr
        or o.hold_shard_name <> n.hold_shard_name
        or o.hold_shard_cert_type_cd <> n.hold_shard_cert_type_cd
        or o.hold_shard_cert_type_descb <> n.hold_shard_cert_type_descb
        or o.hold_shard_cert_no <> n.hold_shard_cert_no
        or o.hold_shard_cert_effect_dt <> n.hold_shard_cert_effect_dt
        or o.hold_shard_cert_invalid_dt <> n.hold_shard_cert_invalid_dt
        or o.auth_trast_ps_name <> n.auth_trast_ps_name
        or o.auth_trast_ps_cert_type_cd <> n.auth_trast_ps_cert_type_cd
        or o.auth_trast_ps_cert_type_descb <> n.auth_trast_ps_cert_type_descb
        or o.auth_trast_ps_cert_no <> n.auth_trast_ps_cert_no
        or o.auth_trast_ps_cert_effect_dt <> n.auth_trast_ps_cert_effect_dt
        or o.auth_trast_ps_cert_invalid_dt <> n.auth_trast_ps_cert_invalid_dt
        or o.belong_org_id <> n.belong_org_id
        or o.mercht_check_status_descb <> n.mercht_check_status_descb
        or o.mercht_actv_status_descb <> n.mercht_actv_status_descb
        or o.stl_acct_name <> n.stl_acct_name
        or o.stl_acct_type_cd <> n.stl_acct_type_cd
        or o.stl_acct_id <> n.stl_acct_id
        or o.stl_acct_open_bank_name <> n.stl_acct_open_bank_name
        or o.init_create_dt <> n.init_create_dt
        or o.final_modif_dt <> n.final_modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,mercht_type_descb -- 商户类型描述
    ,wft_org_id -- 威富通机构编号
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_type_descb -- 企业证件类型描述
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_effect_dt -- 企业证件生效日期
    ,corp_cert_invalid_dt -- 企业证件失效日期
    ,mang_range -- 经营范围
    ,rgst_addr -- 注册地址
    ,legal_rep_name -- 法定代表人名称
    ,legal_rep_gender_cd -- 法定代表人性别代码
    ,legal_rep_gender_descb -- 法定代表人性别描述
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_type -- 法定代表人证件类型
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,legal_rep_cert_effect_dt -- 法定代表人证件生效日期
    ,legal_rep_cert_invalid_dt -- 法定代表人证件失效日期
    ,legal_rep_mobile_no -- 法定代表人手机号码
    ,bnft_owner_name -- 受益所有人名称
    ,bnft_owner_cert_type_cd -- 受益所有人证件类型代码
    ,bnft_owner_cert_type_descb -- 受益所有人证件类型描述
    ,bnft_owner_cert_no -- 受益所有人证件号码
    ,bnft_owner_cert_effect_dt -- 受益所有人证件生效日期
    ,bnft_owner_cert_invalid_dt -- 受益所有人证件失效日期
    ,bnft_owner_dtl_addr -- 受益所有人详细地址
    ,hold_shard_name -- 控股股东名称
    ,hold_shard_cert_type_cd -- 控股股东证件类型代码
    ,hold_shard_cert_type_descb -- 控股股东证件类型描述
    ,hold_shard_cert_no -- 控股股东证件号码
    ,hold_shard_cert_effect_dt -- 控股股东证件生效日期
    ,hold_shard_cert_invalid_dt -- 控股股东证件失效日期
    ,auth_trast_ps_name -- 授权办理人名称
    ,auth_trast_ps_cert_type_cd -- 授权办理人证件类型代码
    ,auth_trast_ps_cert_type_descb -- 授权办理人证件类型描述
    ,auth_trast_ps_cert_no -- 授权办理人证件号码
    ,auth_trast_ps_cert_effect_dt -- 授权办理人证件生效日期
    ,auth_trast_ps_cert_invalid_dt -- 授权办理人证件失效日期
    ,belong_org_id -- 所属机构编号
    ,mercht_check_status_descb -- 商户审核状态描述
    ,mercht_actv_status_descb -- 商户激活状态描述
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_type_cd -- 结算账户类型
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_open_bank_name -- 结算账户开户行名称
    ,init_create_dt -- 最初创建日期
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,mercht_type_descb -- 商户类型描述
    ,wft_org_id -- 威富通机构编号
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_type_descb -- 企业证件类型描述
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_effect_dt -- 企业证件生效日期
    ,corp_cert_invalid_dt -- 企业证件失效日期
    ,mang_range -- 经营范围
    ,rgst_addr -- 注册地址
    ,legal_rep_name -- 法定代表人名称
    ,legal_rep_gender_cd -- 法定代表人性别代码
    ,legal_rep_gender_descb -- 法定代表人性别描述
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_type -- 法定代表人证件类型
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,legal_rep_cert_effect_dt -- 法定代表人证件生效日期
    ,legal_rep_cert_invalid_dt -- 法定代表人证件失效日期
    ,legal_rep_mobile_no -- 法定代表人手机号码
    ,bnft_owner_name -- 受益所有人名称
    ,bnft_owner_cert_type_cd -- 受益所有人证件类型代码
    ,bnft_owner_cert_type_descb -- 受益所有人证件类型描述
    ,bnft_owner_cert_no -- 受益所有人证件号码
    ,bnft_owner_cert_effect_dt -- 受益所有人证件生效日期
    ,bnft_owner_cert_invalid_dt -- 受益所有人证件失效日期
    ,bnft_owner_dtl_addr -- 受益所有人详细地址
    ,hold_shard_name -- 控股股东名称
    ,hold_shard_cert_type_cd -- 控股股东证件类型代码
    ,hold_shard_cert_type_descb -- 控股股东证件类型描述
    ,hold_shard_cert_no -- 控股股东证件号码
    ,hold_shard_cert_effect_dt -- 控股股东证件生效日期
    ,hold_shard_cert_invalid_dt -- 控股股东证件失效日期
    ,auth_trast_ps_name -- 授权办理人名称
    ,auth_trast_ps_cert_type_cd -- 授权办理人证件类型代码
    ,auth_trast_ps_cert_type_descb -- 授权办理人证件类型描述
    ,auth_trast_ps_cert_no -- 授权办理人证件号码
    ,auth_trast_ps_cert_effect_dt -- 授权办理人证件生效日期
    ,auth_trast_ps_cert_invalid_dt -- 授权办理人证件失效日期
    ,belong_org_id -- 所属机构编号
    ,mercht_check_status_descb -- 商户审核状态描述
    ,mercht_actv_status_descb -- 商户激活状态描述
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_type_cd -- 结算账户类型
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_open_bank_name -- 结算账户开户行名称
    ,init_create_dt -- 最初创建日期
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.mercht_id -- 商户编号
    ,o.mercht_name -- 商户名称
    ,o.mercht_type_descb -- 商户类型描述
    ,o.wft_org_id -- 威富通机构编号
    ,o.corp_cert_type_cd -- 企业证件类型代码
    ,o.corp_cert_type_descb -- 企业证件类型描述
    ,o.corp_cert_no -- 企业证件号码
    ,o.corp_cert_effect_dt -- 企业证件生效日期
    ,o.corp_cert_invalid_dt -- 企业证件失效日期
    ,o.mang_range -- 经营范围
    ,o.rgst_addr -- 注册地址
    ,o.legal_rep_name -- 法定代表人名称
    ,o.legal_rep_gender_cd -- 法定代表人性别代码
    ,o.legal_rep_gender_descb -- 法定代表人性别描述
    ,o.legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,o.legal_rep_cert_type -- 法定代表人证件类型
    ,o.legal_rep_cert_no -- 法定代表人证件号码
    ,o.legal_rep_cert_effect_dt -- 法定代表人证件生效日期
    ,o.legal_rep_cert_invalid_dt -- 法定代表人证件失效日期
    ,o.legal_rep_mobile_no -- 法定代表人手机号码
    ,o.bnft_owner_name -- 受益所有人名称
    ,o.bnft_owner_cert_type_cd -- 受益所有人证件类型代码
    ,o.bnft_owner_cert_type_descb -- 受益所有人证件类型描述
    ,o.bnft_owner_cert_no -- 受益所有人证件号码
    ,o.bnft_owner_cert_effect_dt -- 受益所有人证件生效日期
    ,o.bnft_owner_cert_invalid_dt -- 受益所有人证件失效日期
    ,o.bnft_owner_dtl_addr -- 受益所有人详细地址
    ,o.hold_shard_name -- 控股股东名称
    ,o.hold_shard_cert_type_cd -- 控股股东证件类型代码
    ,o.hold_shard_cert_type_descb -- 控股股东证件类型描述
    ,o.hold_shard_cert_no -- 控股股东证件号码
    ,o.hold_shard_cert_effect_dt -- 控股股东证件生效日期
    ,o.hold_shard_cert_invalid_dt -- 控股股东证件失效日期
    ,o.auth_trast_ps_name -- 授权办理人名称
    ,o.auth_trast_ps_cert_type_cd -- 授权办理人证件类型代码
    ,o.auth_trast_ps_cert_type_descb -- 授权办理人证件类型描述
    ,o.auth_trast_ps_cert_no -- 授权办理人证件号码
    ,o.auth_trast_ps_cert_effect_dt -- 授权办理人证件生效日期
    ,o.auth_trast_ps_cert_invalid_dt -- 授权办理人证件失效日期
    ,o.belong_org_id -- 所属机构编号
    ,o.mercht_check_status_descb -- 商户审核状态描述
    ,o.mercht_actv_status_descb -- 商户激活状态描述
    ,o.stl_acct_name -- 结算账户名称
    ,o.stl_acct_type_cd -- 结算账户类型
    ,o.stl_acct_id -- 结算账户编号
    ,o.stl_acct_open_bank_name -- 结算账户开户行名称
    ,o.init_create_dt -- 最初创建日期
    ,o.final_modif_dt -- 最后修改日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_bk o
    left join ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_wft_mercht_info_h;
--alter table ${iml_schema}.agt_wft_mercht_info_h truncate partition for ('mrmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_wft_mercht_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mrmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_wft_mercht_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_wft_mercht_info_h modify partition p_mrmsf1 
add subpartition p_mrmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_wft_mercht_info_h exchange subpartition p_mrmsf1_${batch_date} with table ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_cl;
alter table ${iml_schema}.agt_wft_mercht_info_h exchange subpartition p_mrmsf1_20991231 with table ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wft_mercht_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_op purge;
drop table ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_wft_mercht_info_h_mrmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wft_mercht_info_h', partname => 'p_mrmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
