/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_col_guartor_rating_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_col_guartor_rating_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_col_guartor_rating_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_col_guartor_rating_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,col_id varchar2(60) -- 押品编号
    ,guartor_id varchar2(100) -- 保证人编号
    ,guartor_cert_type_cd varchar2(10)  -- 保证人证件类型代码
    ,guartor_cert_no varchar2(100) -- 保证人证件号码
    ,guartor_name varchar2(150) -- 保证人名称
    ,guartor_type_cd varchar2(10) -- 保证人类型代码
    ,guartor_intnal_rating_dt date -- 保证人内部评级日期
    ,guartor_intnal_rating_rest varchar2(150) -- 保证人内部评级结果
    ,guartor_ext_rating_dt date -- 保证人外部评级日期
    ,guartor_ext_rating_rest varchar2(150) -- 保证人外部评级结果
    ,guar_aim_cd varchar2(10) -- 保证目的代码
    ,curr_cd varchar2(10) -- 币种代码
    ,guartor_econ_compnt_cd varchar2(10) -- 保证人经济成分代码
    ,guartor_nat_std_indus_cls_cd varchar2(100) -- 保证人国标行业分类代码
    ,guartor_guar_indep_cd varchar2(10) -- 保证人担保独立性代码
    ,stage_guar_flg varchar2(10) -- 阶段性担保标志
    ,guartor_net_asset_amt number(30,2) -- 保证人净资产金额
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
grant select on ${icl_schema}.cmm_col_guartor_rating_info to ${idl_schema};
grant select on ${icl_schema}.cmm_col_guartor_rating_info to ${iel_schema};
grant select on ${icl_schema}.cmm_col_guartor_rating_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_col_guartor_rating_info is '押品保证人评级信息';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.col_id is '押品编号';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guartor_id is '保证人编号';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guartor_cert_type_cd is '保证人证件类型代码';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guartor_cert_no is '保证人证件号码';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guartor_name is '保证人名称';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guartor_type_cd is '保证人类型代码';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guartor_intnal_rating_dt is '保证人内部评级日期';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guartor_intnal_rating_rest is '保证人内部评级结果';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guartor_ext_rating_dt is '保证人外部评级日期';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guartor_ext_rating_rest is '保证人外部评级结果';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guar_aim_cd is '保证目的代码';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guartor_econ_compnt_cd is '保证人经济成分代码';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guartor_nat_std_indus_cls_cd is '保证人国标行业分类代码';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guartor_guar_indep_cd is '保证人担保独立性代码';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.stage_guar_flg is '阶段性担保标志';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.guartor_net_asset_amt is '保证人净资产金额';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_col_guartor_rating_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_col_guartor_rating_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_col_guartor_rating_info.etl_timestamp is 'ETL处理时间戳';
