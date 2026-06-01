/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ast_col_nature_ps_guar
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.ast_col_nature_ps_guar
whenever sqlerror continue none;
drop table ${idl_schema}.ast_col_nature_ps_guar purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.ast_col_nature_ps_guar(
    etl_dt date -- 数据日期   
    ,asset_id varchar2(60) -- 资产编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,guartor_type_cd varchar2(10) -- 保证人类型代码   
    ,guartor_id varchar2(100) -- 保证人编号   
    ,guartor_name varchar2(100) -- 保证人名称   
    ,guartor_cert_no varchar2(60) -- 保证人证件号码   
    ,guartor_cert_type_cd varchar2(10) -- 保证人证件类型代码   
    ,guartor_nat_std_indus_cls_cd varchar2(100) -- 保证人国标行业分类代码   
    ,guartor_net_asset_amt number(30,2) -- 保证人净资产金额   
    ,guartor_econ_compnt_cd varchar2(10) -- 保证人经济成分代码   
    ,guartor_guar_indep_cd varchar2(10) -- 保证人担保独立性代码   
    ,guartor_rgst_cd varchar2(100) -- 保证人注册地代码   
    ,guartor_rgst_ext_rating_cd varchar2(100) -- 保证人注册地外部评级结果代码   
    ,guartor_ext_rating_dt date -- 保证人外部评级日期   
    ,guartor_ext_rating_rest_cd varchar2(100) -- 保证人外部评级结果代码   
    ,guartor_intnal_rating_dt date -- 保证人内部评级日期   
    ,guartor_intnal_rating_rest_cd varchar2(100) -- 保证人内部评级结果代码   
    ,guar_aim_cd varchar2(10) -- 保证目的代码   
    ,stage_guar_flg varchar2(10) -- 阶段性担保标志   
    ,other_comnt varchar2(4000) -- 其他说明   
    ,curr_cd varchar2(10) -- 币种代码   
    ,resdnt_flg varchar2(10) -- 是否居民标志   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识
    ,job_cd varchar2(10) -- 任务编码   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.ast_col_nature_ps_guar to ${iel_schema};

-- comment
comment on table ${idl_schema}.ast_col_nature_ps_guar is '押品自然人保证';
comment on column ${idl_schema}.ast_col_nature_ps_guar.etl_dt is '数据日期';
comment on column ${idl_schema}.ast_col_nature_ps_guar.asset_id is '资产编号';
comment on column ${idl_schema}.ast_col_nature_ps_guar.lp_id is '法人编号';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_type_cd is '保证人类型代码';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_id is '保证人编号';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_name is '保证人名称';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_cert_no is '保证人证件号码';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_cert_type_cd is '保证人证件类型代码';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_nat_std_indus_cls_cd is '保证人国标行业分类代码';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_net_asset_amt is '保证人净资产金额';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_econ_compnt_cd is '保证人经济成分代码';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_guar_indep_cd is '保证人担保独立性代码';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_rgst_cd is '保证人注册地代码';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_rgst_ext_rating_cd is '保证人注册地外部评级结果代码';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_ext_rating_dt is '保证人外部评级日期';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_ext_rating_rest_cd is '保证人外部评级结果代码';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_intnal_rating_dt is '保证人内部评级日期';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guartor_intnal_rating_rest_cd is '保证人内部评级结果代码';
comment on column ${idl_schema}.ast_col_nature_ps_guar.guar_aim_cd is '保证目的代码';
comment on column ${idl_schema}.ast_col_nature_ps_guar.stage_guar_flg is '阶段性担保标志';
comment on column ${idl_schema}.ast_col_nature_ps_guar.other_comnt is '其他说明';
comment on column ${idl_schema}.ast_col_nature_ps_guar.curr_cd is '币种代码';
comment on column ${idl_schema}.ast_col_nature_ps_guar.resdnt_flg is '是否居民标志';
comment on column ${idl_schema}.ast_col_nature_ps_guar.create_dt is '创建日期';
comment on column ${idl_schema}.ast_col_nature_ps_guar.update_dt is '更新日期';
comment on column ${idl_schema}.ast_col_nature_ps_guar.id_mark is '删除标识';