/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_bscinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_bscinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_bscinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_bscinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,pbc_cr_ecn_tpcd varchar2(5) -- 经济类型 :ec010d01
    ,org_inst_tp varchar2(3) -- 组织机构类型 :ec010d02
    ,pbc_cr_entp_sz varchar2(2) -- 企业规模 :ec010d03
    ,bliy_cd varchar2(8) -- 所属行业 :ec010d04
    ,rgs_adr varchar2(675) -- 登记地址 :ec010q01
    ,fd_yr varchar2(6) -- 成立年份 :ec010r01
    ,lc_avldt_codt date -- 登记证书有效截止日期 :ec010r02
    ,oprt_adr varchar2(675) -- 办公/经营地址 :ec010q02
    ,pbc_cr_exstn_st varchar2(2) -- 存续状态 :ec010d05
    ,cmps_stff_num number(22) -- 组成人员个数（主要组成人员个数):ec030s01
    ,cmps_stff_inf_udt_dt date -- 组成人员信息更新日期:ec030r01
    ,act_ctrlr_num number(22) -- 实际控制人个数:ec050s01
    ,act_ctrlr_inf_udt_dt date -- 实际控制人信息更新日期:ec050r01
    ,rgst_cptl number(38,0) -- 注册资本:ec020j01
    ,main_fndd_psn_num number(22) -- 主要出资人个数:ec020s01
    ,rgstcptlandmfpifudtdt date -- 注册资本及主要出资人信息更新日期:ec020r01
    ,pbc_cr_supr_inst_tp varchar2(2) -- 人行征信上级机构类型（上级机构类型):ec040d01
    ,entp_cr_supr_inst_nm varchar2(360) -- 企业征信上级机构名称（上级机构名称):ec040q01
    ,entpsuprinstidntidrtp varchar2(3) -- 企业上级机构身份标识类型:ec040d02
    ,supr_inst_idnt_idr_cd varchar2(180) -- 上级机构身份标识码:ec040i01
    ,supr_inst_inf_udt_dt date -- 上级机构信息更新日期:ec040r01
    ,crt_dt_tm date -- 创建日期时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cqss_e_r_bscinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_bscinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_bscinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_bscinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_bscinf is '基本信息';
comment on column ${iol_schema}.cqss_e_r_bscinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_bscinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_bscinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_bscinf.pbc_cr_ecn_tpcd is '经济类型 :ec010d01';
comment on column ${iol_schema}.cqss_e_r_bscinf.org_inst_tp is '组织机构类型 :ec010d02';
comment on column ${iol_schema}.cqss_e_r_bscinf.pbc_cr_entp_sz is '企业规模 :ec010d03';
comment on column ${iol_schema}.cqss_e_r_bscinf.bliy_cd is '所属行业 :ec010d04';
comment on column ${iol_schema}.cqss_e_r_bscinf.rgs_adr is '登记地址 :ec010q01';
comment on column ${iol_schema}.cqss_e_r_bscinf.fd_yr is '成立年份 :ec010r01';
comment on column ${iol_schema}.cqss_e_r_bscinf.lc_avldt_codt is '登记证书有效截止日期 :ec010r02';
comment on column ${iol_schema}.cqss_e_r_bscinf.oprt_adr is '办公/经营地址 :ec010q02';
comment on column ${iol_schema}.cqss_e_r_bscinf.pbc_cr_exstn_st is '存续状态 :ec010d05';
comment on column ${iol_schema}.cqss_e_r_bscinf.cmps_stff_num is '组成人员个数（主要组成人员个数):ec030s01';
comment on column ${iol_schema}.cqss_e_r_bscinf.cmps_stff_inf_udt_dt is '组成人员信息更新日期:ec030r01';
comment on column ${iol_schema}.cqss_e_r_bscinf.act_ctrlr_num is '实际控制人个数:ec050s01';
comment on column ${iol_schema}.cqss_e_r_bscinf.act_ctrlr_inf_udt_dt is '实际控制人信息更新日期:ec050r01';
comment on column ${iol_schema}.cqss_e_r_bscinf.rgst_cptl is '注册资本:ec020j01';
comment on column ${iol_schema}.cqss_e_r_bscinf.main_fndd_psn_num is '主要出资人个数:ec020s01';
comment on column ${iol_schema}.cqss_e_r_bscinf.rgstcptlandmfpifudtdt is '注册资本及主要出资人信息更新日期:ec020r01';
comment on column ${iol_schema}.cqss_e_r_bscinf.pbc_cr_supr_inst_tp is '人行征信上级机构类型（上级机构类型):ec040d01';
comment on column ${iol_schema}.cqss_e_r_bscinf.entp_cr_supr_inst_nm is '企业征信上级机构名称（上级机构名称):ec040q01';
comment on column ${iol_schema}.cqss_e_r_bscinf.entpsuprinstidntidrtp is '企业上级机构身份标识类型:ec040d02';
comment on column ${iol_schema}.cqss_e_r_bscinf.supr_inst_idnt_idr_cd is '上级机构身份标识码:ec040i01';
comment on column ${iol_schema}.cqss_e_r_bscinf.supr_inst_inf_udt_dt is '上级机构信息更新日期:ec040r01';
comment on column ${iol_schema}.cqss_e_r_bscinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_bscinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_bscinf.etl_timestamp is 'ETL处理时间戳';
