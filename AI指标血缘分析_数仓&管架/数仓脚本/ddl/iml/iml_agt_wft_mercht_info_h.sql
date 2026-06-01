/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wft_mercht_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wft_mercht_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wft_mercht_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wft_mercht_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,mercht_id varchar2(100) -- 商户编号
    ,mercht_name varchar2(750) -- 商户名称
    ,mercht_type_descb varchar2(750) -- 商户类型描述
    ,wft_org_id varchar2(100) -- 威富通机构编号
    ,corp_cert_type_cd varchar2(60) -- 企业证件类型代码
    ,corp_cert_type_descb varchar2(750) -- 企业证件类型描述
    ,corp_cert_no varchar2(500) -- 企业证件号码
    ,corp_cert_effect_dt date -- 企业证件生效日期
    ,corp_cert_invalid_dt date -- 企业证件失效日期
    ,mang_range varchar2(4000) -- 经营范围
    ,rgst_addr varchar2(1500) -- 注册地址
    ,legal_rep_name varchar2(750) -- 法定代表人名称
    ,legal_rep_gender_cd varchar2(60) -- 法定代表人性别代码
    ,legal_rep_gender_descb varchar2(750) -- 法定代表人性别描述
    ,legal_rep_cert_type_cd varchar2(60) -- 法定代表人证件类型代码
    ,legal_rep_cert_type varchar2(375) -- 法定代表人证件类型
    ,legal_rep_cert_no varchar2(250) -- 法定代表人证件号码
    ,legal_rep_cert_effect_dt date -- 法定代表人证件生效日期
    ,legal_rep_cert_invalid_dt date -- 法定代表人证件失效日期
    ,legal_rep_mobile_no varchar2(250) -- 法定代表人手机号码
    ,bnft_owner_name varchar2(750) -- 受益所有人名称
    ,bnft_owner_cert_type_cd varchar2(60) -- 受益所有人证件类型代码
    ,bnft_owner_cert_type_descb varchar2(750) -- 受益所有人证件类型描述
    ,bnft_owner_cert_no varchar2(250) -- 受益所有人证件号码
    ,bnft_owner_cert_effect_dt date -- 受益所有人证件生效日期
    ,bnft_owner_cert_invalid_dt date -- 受益所有人证件失效日期
    ,bnft_owner_dtl_addr varchar2(1500) -- 受益所有人详细地址
    ,hold_shard_name varchar2(750) -- 控股股东名称
    ,hold_shard_cert_type_cd varchar2(60) -- 控股股东证件类型代码
    ,hold_shard_cert_type_descb varchar2(750) -- 控股股东证件类型描述
    ,hold_shard_cert_no varchar2(250) -- 控股股东证件号码
    ,hold_shard_cert_effect_dt date -- 控股股东证件生效日期
    ,hold_shard_cert_invalid_dt date -- 控股股东证件失效日期
    ,auth_trast_ps_name varchar2(750) -- 授权办理人名称
    ,auth_trast_ps_cert_type_cd varchar2(60) -- 授权办理人证件类型代码
    ,auth_trast_ps_cert_type_descb varchar2(750) -- 授权办理人证件类型描述
    ,auth_trast_ps_cert_no varchar2(250) -- 授权办理人证件号码
    ,auth_trast_ps_cert_effect_dt date -- 授权办理人证件生效日期
    ,auth_trast_ps_cert_invalid_dt date -- 授权办理人证件失效日期
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,mercht_check_status_descb varchar2(750) -- 商户审核状态描述
    ,mercht_actv_status_descb varchar2(750) -- 商户激活状态描述
    ,stl_acct_name varchar2(500) -- 结算账户名称
    ,stl_acct_type_cd varchar2(250) -- 结算账户类型
    ,stl_acct_id varchar2(250) -- 结算账户编号
    ,stl_acct_open_bank_name varchar2(500) -- 结算账户开户行名称
    ,init_create_dt date -- 最初创建日期
    ,final_modif_dt date -- 最后修改日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_wft_mercht_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_wft_mercht_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_wft_mercht_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wft_mercht_info_h is '威富通商户信息历史';
comment on column ${iml_schema}.agt_wft_mercht_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wft_mercht_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wft_mercht_info_h.mercht_id is '商户编号';
comment on column ${iml_schema}.agt_wft_mercht_info_h.mercht_name is '商户名称';
comment on column ${iml_schema}.agt_wft_mercht_info_h.mercht_type_descb is '商户类型描述';
comment on column ${iml_schema}.agt_wft_mercht_info_h.wft_org_id is '威富通机构编号';
comment on column ${iml_schema}.agt_wft_mercht_info_h.corp_cert_type_cd is '企业证件类型代码';
comment on column ${iml_schema}.agt_wft_mercht_info_h.corp_cert_type_descb is '企业证件类型描述';
comment on column ${iml_schema}.agt_wft_mercht_info_h.corp_cert_no is '企业证件号码';
comment on column ${iml_schema}.agt_wft_mercht_info_h.corp_cert_effect_dt is '企业证件生效日期';
comment on column ${iml_schema}.agt_wft_mercht_info_h.corp_cert_invalid_dt is '企业证件失效日期';
comment on column ${iml_schema}.agt_wft_mercht_info_h.mang_range is '经营范围';
comment on column ${iml_schema}.agt_wft_mercht_info_h.rgst_addr is '注册地址';
comment on column ${iml_schema}.agt_wft_mercht_info_h.legal_rep_name is '法定代表人名称';
comment on column ${iml_schema}.agt_wft_mercht_info_h.legal_rep_gender_cd is '法定代表人性别代码';
comment on column ${iml_schema}.agt_wft_mercht_info_h.legal_rep_gender_descb is '法定代表人性别描述';
comment on column ${iml_schema}.agt_wft_mercht_info_h.legal_rep_cert_type_cd is '法定代表人证件类型代码';
comment on column ${iml_schema}.agt_wft_mercht_info_h.legal_rep_cert_type is '法定代表人证件类型';
comment on column ${iml_schema}.agt_wft_mercht_info_h.legal_rep_cert_no is '法定代表人证件号码';
comment on column ${iml_schema}.agt_wft_mercht_info_h.legal_rep_cert_effect_dt is '法定代表人证件生效日期';
comment on column ${iml_schema}.agt_wft_mercht_info_h.legal_rep_cert_invalid_dt is '法定代表人证件失效日期';
comment on column ${iml_schema}.agt_wft_mercht_info_h.legal_rep_mobile_no is '法定代表人手机号码';
comment on column ${iml_schema}.agt_wft_mercht_info_h.bnft_owner_name is '受益所有人名称';
comment on column ${iml_schema}.agt_wft_mercht_info_h.bnft_owner_cert_type_cd is '受益所有人证件类型代码';
comment on column ${iml_schema}.agt_wft_mercht_info_h.bnft_owner_cert_type_descb is '受益所有人证件类型描述';
comment on column ${iml_schema}.agt_wft_mercht_info_h.bnft_owner_cert_no is '受益所有人证件号码';
comment on column ${iml_schema}.agt_wft_mercht_info_h.bnft_owner_cert_effect_dt is '受益所有人证件生效日期';
comment on column ${iml_schema}.agt_wft_mercht_info_h.bnft_owner_cert_invalid_dt is '受益所有人证件失效日期';
comment on column ${iml_schema}.agt_wft_mercht_info_h.bnft_owner_dtl_addr is '受益所有人详细地址';
comment on column ${iml_schema}.agt_wft_mercht_info_h.hold_shard_name is '控股股东名称';
comment on column ${iml_schema}.agt_wft_mercht_info_h.hold_shard_cert_type_cd is '控股股东证件类型代码';
comment on column ${iml_schema}.agt_wft_mercht_info_h.hold_shard_cert_type_descb is '控股股东证件类型描述';
comment on column ${iml_schema}.agt_wft_mercht_info_h.hold_shard_cert_no is '控股股东证件号码';
comment on column ${iml_schema}.agt_wft_mercht_info_h.hold_shard_cert_effect_dt is '控股股东证件生效日期';
comment on column ${iml_schema}.agt_wft_mercht_info_h.hold_shard_cert_invalid_dt is '控股股东证件失效日期';
comment on column ${iml_schema}.agt_wft_mercht_info_h.auth_trast_ps_name is '授权办理人名称';
comment on column ${iml_schema}.agt_wft_mercht_info_h.auth_trast_ps_cert_type_cd is '授权办理人证件类型代码';
comment on column ${iml_schema}.agt_wft_mercht_info_h.auth_trast_ps_cert_type_descb is '授权办理人证件类型描述';
comment on column ${iml_schema}.agt_wft_mercht_info_h.auth_trast_ps_cert_no is '授权办理人证件号码';
comment on column ${iml_schema}.agt_wft_mercht_info_h.auth_trast_ps_cert_effect_dt is '授权办理人证件生效日期';
comment on column ${iml_schema}.agt_wft_mercht_info_h.auth_trast_ps_cert_invalid_dt is '授权办理人证件失效日期';
comment on column ${iml_schema}.agt_wft_mercht_info_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_wft_mercht_info_h.mercht_check_status_descb is '商户审核状态描述';
comment on column ${iml_schema}.agt_wft_mercht_info_h.mercht_actv_status_descb is '商户激活状态描述';
comment on column ${iml_schema}.agt_wft_mercht_info_h.stl_acct_name is '结算账户名称';
comment on column ${iml_schema}.agt_wft_mercht_info_h.stl_acct_type_cd is '结算账户类型';
comment on column ${iml_schema}.agt_wft_mercht_info_h.stl_acct_id is '结算账户编号';
comment on column ${iml_schema}.agt_wft_mercht_info_h.stl_acct_open_bank_name is '结算账户开户行名称';
comment on column ${iml_schema}.agt_wft_mercht_info_h.init_create_dt is '最初创建日期';
comment on column ${iml_schema}.agt_wft_mercht_info_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_wft_mercht_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wft_mercht_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wft_mercht_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wft_mercht_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wft_mercht_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wft_mercht_info_h.etl_timestamp is 'ETL处理时间戳';
