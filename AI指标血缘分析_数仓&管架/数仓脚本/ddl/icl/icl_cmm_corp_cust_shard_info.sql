/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_corp_cust_shard_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_corp_cust_shard_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_cust_shard_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_cust_shard_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) -- 客户编号
    ,shard_cust_id varchar2(100) -- 股东客户编号
    ,rela_ps_id varchar2(100) -- 关联人编号
    ,shard_name varchar2(750) -- 股东名称
    ,shard_type_cd varchar2(60) -- 股东类型代码
    ,shard_orgnz_type_cd varchar2(60) -- 股东组织机构类型代码
    ,shard_local_nation_cd varchar2(10) -- 国家和地区代码
    ,shard_orgnz_cd varchar2(60) -- 股东组织机构代码
    ,shard_bus_lics_id varchar2(60) -- 股东营业执照编号
    ,contrior_econ_compnt_cd varchar2(60) -- 企业出资人经济成分代码
    ,nature_ps_shard_cert_type_cd varchar2(20) -- 自然人股东证件类型代码
    ,nature_ps_shard_cert_no varchar2(60) -- 自然人股东证件号码
    ,ghb_shard_flg varchar2(10) -- 本行股东标志
    ,unify_soci_crdt_cd varchar2(60) -- 统一社会信用代码
    ,share_ratio number(18,6) -- 持股比例
    ,shard_hold_shares_qtty number(30,6) -- 股东持股数量
    ,shard_contri_ratio number(30,6) -- 股东出资比例
    ,contri_way_cd varchar2(10) -- 出资方式代码
    ,contri_curr_cd varchar2(10) -- 出资币种代码
    ,contri_amt number(30,2) -- 出资金额
    ,contrior_type_cd varchar2(30) -- 出资人类型代码
    ,contrior_idti_cate_cd varchar2(30) -- 出资人身份类别代码
    ,hold_dt date -- 入股日期
    ,shard_valid_flg varchar2(10) -- 股东有效标志
    ,actl_ctrler_flg varchar2(10) -- 实际控制人标志
    ,update_dt date -- 更新日期
    ,src_sys_cd varchar2(10) -- 来源系统代码
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_corp_cust_shard_info to ${idl_schema};
grant select on ${icl_schema}.cmm_corp_cust_shard_info to ${iel_schema};
grant select on ${icl_schema}.cmm_corp_cust_shard_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_corp_cust_shard_info is '对公客户股东信息';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.shard_cust_id is '股东客户编号';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.rela_ps_id is '关联人编号';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.shard_name is '股东名称';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.shard_type_cd is '股东类型代码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.shard_orgnz_type_cd is '股东组织机构类型代码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.shard_local_nation_cd is '股东所在国家和地区代码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.shard_orgnz_cd is '股东组织机构代码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.shard_bus_lics_id is '股东营业执照编号';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.contrior_econ_compnt_cd is '企业出资人经济成分代码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.nature_ps_shard_cert_type_cd is '自然人股东证件类型代码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.nature_ps_shard_cert_no is '自然人股东证件号码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.ghb_shard_flg is '本行股东标志';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.unify_soci_crdt_cd is '统一社会信用代码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.share_ratio is '持股比例';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.shard_hold_shares_qtty is '股东持股数量';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.shard_contri_ratio is '股东出资比例';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.contri_way_cd is '出资方式代码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.contri_curr_cd is '出资币种代码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.contri_amt is '出资金额';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.contrior_type_cd is '出资人类型代码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.contrior_idti_cate_cd is '出资人身份类别代码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.hold_dt is '入股日期';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.shard_valid_flg is '股东有效标志';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.actl_ctrler_flg is '实际控制人标志';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.update_dt is '更新日期';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.src_sys_cd is '来源系统代码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_corp_cust_shard_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_corp_cust_shard_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_corp_cust_shard_info.etl_timestamp is 'ETL处理时间戳';
