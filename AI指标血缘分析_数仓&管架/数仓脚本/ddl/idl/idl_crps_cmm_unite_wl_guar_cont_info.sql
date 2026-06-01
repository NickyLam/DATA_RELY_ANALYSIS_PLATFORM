/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_cmm_unite_wl_guar_cont_info
CreateDate: 20231111
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.crps_cmm_unite_wl_guar_cont_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.crps_cmm_unite_wl_guar_cont_info(
etl_dt date --数据日期
,lp_id varchar2(60) --法人编号
,guar_cont_id varchar2(100) --担保合同编号
,guar_cont_type_cd varchar2(30) --担保合同类型代码
,guar_way_cd varchar2(30) --担保方式代码
,guar_kind_cd varchar2(30) --保证种类代码
,status_cd varchar2(30) --状态代码
,curr_cd varchar2(30) --币种代码
,sign_dt date --签订日期
,effect_dt date --生效日期
,exp_dt date --到期日期
,cust_id varchar2(100) --客户编号
,guartor_cust_id varchar2(100) --担保人客户编号
,guartor_name varchar2(500) --担保人名称
,guartor_cert_type_cd varchar2(30) --担保人证件类型代码
,guartor_cert_no varchar2(60) --担保人证件号码
,guar_amt number(30,2) --担保金额
,gover_fin_guar_corp_guar_flg varchar2(10) --政府性融资担保公司保证标志
,rev_guar_flg varchar2(10) --反担保标志
,guar_org_name varchar2(500) --担保机构名称
,guar_item_promis_id varchar2(100) --担保事项承诺书编号
,rgst_org_id varchar2(100) --登记机构编号
,rgstrat_id varchar2(100) --登记人编号
,rgst_dt date --登记日期

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.crps_cmm_unite_wl_guar_cont_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.crps_cmm_unite_wl_guar_cont_info is '联合网贷担保合同信息';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.etl_dt is '数据日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.lp_id is '法人编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.guar_cont_id is '担保合同编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.guar_cont_type_cd is '担保合同类型代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.guar_way_cd is '担保方式代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.guar_kind_cd is '保证种类代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.status_cd is '状态代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.curr_cd is '币种代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.sign_dt is '签订日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.effect_dt is '生效日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.exp_dt is '到期日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.cust_id is '客户编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.guartor_cust_id is '担保人客户编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.guartor_name is '担保人名称';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.guartor_cert_type_cd is '担保人证件类型代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.guartor_cert_no is '担保人证件号码';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.guar_amt is '担保金额';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.gover_fin_guar_corp_guar_flg is '政府性融资担保公司保证标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.rev_guar_flg is '反担保标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.guar_org_name is '担保机构名称';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.guar_item_promis_id is '担保事项承诺书编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.rgst_org_id is '登记机构编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.rgstrat_id is '登记人编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_guar_cont_info.rgst_dt is '登记日期';

