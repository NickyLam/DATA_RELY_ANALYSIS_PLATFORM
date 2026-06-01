/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_bond_ext_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_bond_ext_info
whenever sqlerror continue none;
drop table ${iml_schema}.prd_bond_ext_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_ext_info(
    bond_id varchar2(60) -- 债券编号
    ,lp_id varchar2(60) -- 法人编号
    ,net_dlvy_flg varchar2(10) -- 净交割标志
    ,trust_org_cd varchar2(30) -- 托管机构代码
    ,asset_type_cd varchar2(20) -- 资产类型代码
    ,stock_cd varchar2(30) -- 股票代码
    ,stock_name varchar2(150) -- 股票名称
    ,rpp_proc_way_cd varchar2(10) -- 还本处理方式代码
    ,deflt_flg varchar2(10) -- 违约标志
    ,subtn_bond_flg varchar2(10) -- 永续债标志
    ,issue_main_belong_cty_rg_cd varchar2(100) -- 发行主体所属国家地区代码
    ,issue_rg_cd varchar2(250) -- 发行地区代码
    ,actl_mang_land_cty_rg_cd varchar2(100) -- 实际经营地国家和地区代码
    ,loc_gov_cls_cd varchar2(30) -- 地方政府债分类代码
    ,stc_flg varchar2(10) -- STC标志
    ,prior_level_flg varchar2(10) -- 优先档次标志
    ,irevbl_guar_flg varchar2(10) -- 不可撤销担保标志
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_bond_ext_info to ${icl_schema};
grant select on ${iml_schema}.prd_bond_ext_info to ${idl_schema};
grant select on ${iml_schema}.prd_bond_ext_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_bond_ext_info is '债券扩展信息';
comment on column ${iml_schema}.prd_bond_ext_info.bond_id is '债券编号';
comment on column ${iml_schema}.prd_bond_ext_info.lp_id is '法人编号';
comment on column ${iml_schema}.prd_bond_ext_info.net_dlvy_flg is '净交割标志';
comment on column ${iml_schema}.prd_bond_ext_info.trust_org_cd is '托管机构代码';
comment on column ${iml_schema}.prd_bond_ext_info.asset_type_cd is '资产类型代码';
comment on column ${iml_schema}.prd_bond_ext_info.stock_cd is '股票代码';
comment on column ${iml_schema}.prd_bond_ext_info.stock_name is '股票名称';
comment on column ${iml_schema}.prd_bond_ext_info.rpp_proc_way_cd is '还本处理方式代码';
comment on column ${iml_schema}.prd_bond_ext_info.deflt_flg is '违约标志';
comment on column ${iml_schema}.prd_bond_ext_info.subtn_bond_flg is '永续债标志';
comment on column ${iml_schema}.prd_bond_ext_info.issue_main_belong_cty_rg_cd is '发行主体所属国家地区代码';
comment on column ${iml_schema}.prd_bond_ext_info.issue_rg_cd is '发行地区代码';
comment on column ${iml_schema}.prd_bond_ext_info.actl_mang_land_cty_rg_cd is '实际经营地国家和地区代码';
comment on column ${iml_schema}.prd_bond_ext_info.loc_gov_cls_cd is '地方政府债分类代码';
comment on column ${iml_schema}.prd_bond_ext_info.stc_flg is 'STC标志';
comment on column ${iml_schema}.prd_bond_ext_info.prior_level_flg is '优先档次标志';
comment on column ${iml_schema}.prd_bond_ext_info.irevbl_guar_flg is '不可撤销担保标志';
comment on column ${iml_schema}.prd_bond_ext_info.create_dt is '创建日期';
comment on column ${iml_schema}.prd_bond_ext_info.update_dt is '更新日期';
comment on column ${iml_schema}.prd_bond_ext_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_bond_ext_info.id_mark is '增删标志';
comment on column ${iml_schema}.prd_bond_ext_info.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_bond_ext_info.job_cd is '任务编码';
comment on column ${iml_schema}.prd_bond_ext_info.etl_timestamp is 'ETL处理时间戳';
