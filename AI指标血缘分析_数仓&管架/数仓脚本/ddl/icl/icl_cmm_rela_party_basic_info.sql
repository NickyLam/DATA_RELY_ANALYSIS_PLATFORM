/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_rela_party_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_rela_party_basic_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_rela_party_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_rela_party_basic_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,party_id varchar2(100) -- 当事人编号
    ,party_name varchar2(450) -- 当事人名称
    ,party_type_cd varchar2(60) -- 当事人类型代码
    ,party_cert_type_cd_1 varchar2(60) -- 当事人证件类型代码1
    ,party_cert_id_1 varchar2(100) -- 当事人证件编号1
    ,party_cert_type_cd_2 varchar2(60) -- 当事人证件类型代码2
    ,party_cert_id_2 varchar2(60) -- 当事人证件编号2
    ,party_belong_org_id varchar2(60) -- 当事人归属机构编号
    ,party_belong_dept_id varchar2(100) -- 当事人所属部门编号
    ,party_kins_rela_cd varchar2(30) -- 当事人亲属关系代码
    ,party_org_cd varchar2(60) -- 当事人组织代码
    ,party_belong_corp_name varchar2(150) -- 当事人所属公司名称
    ,party_post_name varchar2(150) -- 当事人职务名称
    ,party_ghb_post_name varchar2(450) -- 当事人本行职务名称
    ,party_share_ratio varchar2(150) -- 当事人持股比例
    ,party_dom_overs_flg varchar2(10) -- 当事人境内外标志
	  ,party_east_econ_type_cd varchar2(10) -- 当事人EAST经济类型代码
    ,party_east_non_info varchar2(10) -- 当事人EAST不良信息
    ,party_status_cd varchar2(30) -- 当事人关系有效标志
    ,party_effect_dt date -- 当事人关系生效日期
    ,party_invalid_dt date -- 当事人关系失效日期
    ,rela_type_cd varchar2(4000) -- 关系类型代码
    ,rela_status_cd varchar2(30) -- 关系状态代码
    ,rela_effect_dt date -- 关系生效日期
    ,rela_invalid_dt date -- 关系失效日期
    ,rela_party_id varchar2(100) -- 关联方编号
    ,rela_party_name varchar2(450) -- 关联方名称
    ,rela_party_cert_type_cd_1 varchar2(60) -- 关联方证件类型代码1
    ,rela_party_cert_id_1 varchar2(100) -- 关联方证件编号1
    ,rela_party_cert_type_cd_2 varchar2(60) -- 关联方证件类型代码2
    ,rela_party_cert_id_2 varchar2(60) -- 关联方证件编号2
    ,rela_party_belong_org_id varchar2(60) -- 关联方归属机构编号
    ,rela_party_belong_dept_id varchar2(60) -- 关联方所属部门编号
    ,rela_party_kins_rela_cd varchar2(30) -- 关联方亲属关系代码
    ,rela_party_org_cd varchar2(60) -- 关联方组织代码
    ,rela_party_belong_corp_name varchar2(450) -- 关联方所属公司名称
    ,rela_party_post_name varchar2(450) -- 关联方职务名称
    ,rela_party_ghb_post_name varchar2(450) -- 关联方本行职务名称
    ,rela_party_share_ratio varchar2(150) -- 关联方持股比例
    ,rela_party_dom_overs_flg varchar2(10) -- 关联方境内外标志
  	,rela_east_econ_type_cd	varchar2(10) -- 关联方EAST经济类型代码
    ,rela_east_non_info	varchar2(10) -- 关联方EAST不良信息
    ,rela_party_status_cd varchar2(30) -- 关联方关系有效标志
    ,rela_party_effect_dt date -- 关联方关系生效日期
    ,rela_party_invalid_dt date -- 关联方关系失效日期  
    ,shard_or_rela_party_type_cd varchar2(60) -- 股东或关联方类型代码
    ,shard_or_rela_party_bl_induty_cd varchar2(60) -- 股东或关联方所属行业代码
    ,shard_or_rela_party_rgst_addr varchar2(2000) -- 股东或关联方注册地址
    ,shard_or_rela_party_rela_type_cd varchar2(300) -- 股东或关联方关系类型代码
    ,mgmt_rela_type_cd varchar2(60) -- 管理关系类型代码
    ,create_tm timestamp(6) -- 创建时间
    ,final_update_tm timestamp(6) -- 最后更新时间
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_rela_party_basic_info to ${idl_schema};
grant select on ${icl_schema}.cmm_rela_party_basic_info to ${iel_schema};
grant select on ${icl_schema}.cmm_rela_party_basic_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_rela_party_basic_info is '关联方基本信息';
comment on column ${icl_schema}.cmm_rela_party_basic_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_rela_party_basic_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_id is '当事人编号';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_name is '当事人名称';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_type_cd is '当事人类型代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_cert_type_cd_1 is '当事人证件类型代码1';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_cert_id_1 is '当事人证件编号1';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_cert_type_cd_2 is '当事人证件类型代码2';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_cert_id_2 is '当事人证件编号2';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_belong_org_id is '当事人归属机构编号';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_belong_dept_id is '当事人所属部门编号';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_kins_rela_cd is '当事人亲属关系代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_org_cd is '当事人组织代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_belong_corp_name is '当事人所属公司名称';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_post_name is '当事人职务名称';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_ghb_post_name is '当事人本行职务名称';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_share_ratio is '当事人持股比例';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_dom_overs_flg is '当事人境内外标志';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_east_econ_type_cd is '当事人EAST经济类型代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_east_non_info is '当事人EAST不良信息';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_status_cd is '当事人关系有效标志';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_effect_dt is '当事人关系生效日期';
comment on column ${icl_schema}.cmm_rela_party_basic_info.party_invalid_dt is '当事人关系失效日期';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_type_cd is '关系类型代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_status_cd is '关系状态代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_effect_dt is '关系生效日期';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_invalid_dt is '关系失效日期';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_id is '关联方编号';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_name is '关联方名称';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_cert_type_cd_1 is '关联方证件类型代码1';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_cert_id_1 is '关联方证件编号1';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_cert_type_cd_2 is '关联方证件类型代码2';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_cert_id_2 is '关联方证件编号2';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_belong_org_id is '关联方归属机构编号';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_belong_dept_id is '关联方所属部门编号';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_kins_rela_cd is '关联方亲属关系代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_org_cd is '关联方组织代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_belong_corp_name is '关联方所属公司名称';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_post_name is '关联方职务名称';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_ghb_post_name is '关联方本行职务名称';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_share_ratio is '关联方持股比例';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_dom_overs_flg is '关联方境内外标志';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_east_econ_type_cd is '关联方EAST经济类型代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_east_non_info is '关联方EAST不良信息';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_status_cd is '关联方关系有效标志';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_effect_dt is '关联方关系生效日期';
comment on column ${icl_schema}.cmm_rela_party_basic_info.rela_party_invalid_dt is '关联方关系失效日期';
comment on column ${icl_schema}.cmm_rela_party_basic_info.shard_or_rela_party_type_cd is '股东或关联方类型代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.shard_or_rela_party_bl_induty_cd is '股东或关联方所属行业代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.shard_or_rela_party_rgst_addr is '股东或关联方注册地址';
comment on column ${icl_schema}.cmm_rela_party_basic_info.shard_or_rela_party_rela_type_cd is '股东或关联方关系类型代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.mgmt_rela_type_cd is '管理关系类型代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.create_tm is '创建时间';
comment on column ${icl_schema}.cmm_rela_party_basic_info.final_update_tm is '最后更新时间';
comment on column ${icl_schema}.cmm_rela_party_basic_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_rela_party_basic_info.etl_timestamp is '数据处理时间';
