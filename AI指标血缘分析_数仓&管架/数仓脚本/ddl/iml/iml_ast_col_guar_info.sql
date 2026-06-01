/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_guar_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_guar_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_guar_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_guar_info(
    col_id varchar2(100) -- 押品编号
    ,lp_id varchar2(100) -- 法人编号
    ,col_name varchar2(500) -- 押品名称
    ,col_type_cd varchar2(60) -- 押品类型代码
    ,guar_guar_form_cd varchar2(30) -- 保证担保形式代码
    ,guar_way_cd varchar2(30) -- 担保方式代码
    ,guar_status_cd varchar2(60) -- 担保状态代码
    ,guar_amt number(30,8) -- 担保金额
    ,guar_curr_cd varchar2(30) -- 担保币种代码
    ,guar_corp_margin_amt number(30,8) -- 担保公司保证金金额
    ,stage_guar_flg varchar2(10) -- 阶段性担保标志
    ,estim_org_name varchar2(500) -- 评估机构名称
    ,estim_val number(30,8) -- 评估价值
    ,evltion_dt date -- 估值日期
    ,rel_esat_cert_id varchar2(1000) -- 不动产证号
    ,rel_esat_arch_area number(30,2) -- 不动产建筑面积
    ,mtg_addr varchar2(1000) -- 抵押物地址
    ,log_id varchar2(100) -- 保函编号
    ,log_type_cd varchar2(30) -- 保函类型代码
    ,log_amt number(30,2) -- 保函金额
    ,log_curr_cd varchar2(30) -- 保函币种代码
    ,log_issue_cty_cd varchar2(30) -- 保函开证国家代码
    ,open_org_name varchar2(500) -- 开立机构名称
    ,open_org_type_cd varchar2(30) -- 开立机构类型代码
    ,irevbl_flg varchar2(10) -- 不可撤销标志
    ,finc_turn_margin_col_id varchar2(100) -- 理财转保证金押品编号
    ,guartor_type_cd varchar2(30) -- 保证人类型代码
    ,guartor_id varchar2(100) -- 保证人编号
    ,guartor_name varchar2(500) -- 保证人名称
    ,guartor_cert_type_cd varchar2(30) -- 保证人证件类型代码
    ,guartor_cert_no varchar2(60) -- 保证人证件号码
    ,guartor_guar_indep_cd varchar2(30) -- 保证人担保独立性代码
    ,guartor_rgst_cty_cd varchar2(30) -- 保证人注册地国家代码
    ,guartor_rgst_ext_rating_cd varchar2(30) -- 保证人注册地外部评级代码
    ,guartor_ext_rating_dt date -- 保证人外部评级日期
    ,guartor_ext_rating_cd varchar2(30) -- 保证人外部评级代码
    ,guartor_intnal_rating_dt date -- 保证人内部评级日期
    ,guartor_intnal_rating_cd varchar2(30) -- 保证人内部评级代码
    ,guartor_ownsp_type_cd varchar2(30) -- 保证人所有制类型代码
    ,guartor_net_asset number(30,8) -- 保证人净资产
    ,net_asset_curr_cd varchar2(30) -- 净资产币种代码
    ,guar_insure_policy_num varchar2(250) -- 保证保险保单号码
    ,guar_aim_cd varchar2(30) -- 保证目的代码
    ,resdnt_flg varchar2(10) -- 居民标志
    ,remark varchar2(500) -- 备注
    ,rgst_dt date -- 登记日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,last_update_dt date -- 最后更新日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(250) -- 更新机构编号
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
grant select on ${iml_schema}.ast_col_guar_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_guar_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_guar_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_guar_info is '押品保证信息';
comment on column ${iml_schema}.ast_col_guar_info.col_id is '押品编号';
comment on column ${iml_schema}.ast_col_guar_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_guar_info.col_name is '押品名称';
comment on column ${iml_schema}.ast_col_guar_info.col_type_cd is '押品类型代码';
comment on column ${iml_schema}.ast_col_guar_info.guar_guar_form_cd is '保证担保形式代码';
comment on column ${iml_schema}.ast_col_guar_info.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.ast_col_guar_info.guar_status_cd is '担保状态代码';
comment on column ${iml_schema}.ast_col_guar_info.guar_amt is '担保金额';
comment on column ${iml_schema}.ast_col_guar_info.guar_curr_cd is '担保币种代码';
comment on column ${iml_schema}.ast_col_guar_info.guar_corp_margin_amt is '担保公司保证金金额';
comment on column ${iml_schema}.ast_col_guar_info.stage_guar_flg is '阶段性担保标志';
comment on column ${iml_schema}.ast_col_guar_info.estim_org_name is '评估机构名称';
comment on column ${iml_schema}.ast_col_guar_info.estim_val is '评估价值';
comment on column ${iml_schema}.ast_col_guar_info.evltion_dt is '估值日期';
comment on column ${iml_schema}.ast_col_guar_info.rel_esat_cert_id is '不动产证号';
comment on column ${iml_schema}.ast_col_guar_info.rel_esat_arch_area is '不动产建筑面积';
comment on column ${iml_schema}.ast_col_guar_info.mtg_addr is '抵押物地址';
comment on column ${iml_schema}.ast_col_guar_info.log_id is '保函编号';
comment on column ${iml_schema}.ast_col_guar_info.log_type_cd is '保函类型代码';
comment on column ${iml_schema}.ast_col_guar_info.log_amt is '保函金额';
comment on column ${iml_schema}.ast_col_guar_info.log_curr_cd is '保函币种代码';
comment on column ${iml_schema}.ast_col_guar_info.log_issue_cty_cd is '保函开证国家代码';
comment on column ${iml_schema}.ast_col_guar_info.open_org_name is '开立机构名称';
comment on column ${iml_schema}.ast_col_guar_info.open_org_type_cd is '开立机构类型代码';
comment on column ${iml_schema}.ast_col_guar_info.irevbl_flg is '不可撤销标志';
comment on column ${iml_schema}.ast_col_guar_info.finc_turn_margin_col_id is '理财转保证金押品编号';
comment on column ${iml_schema}.ast_col_guar_info.guartor_type_cd is '保证人类型代码';
comment on column ${iml_schema}.ast_col_guar_info.guartor_id is '保证人编号';
comment on column ${iml_schema}.ast_col_guar_info.guartor_name is '保证人名称';
comment on column ${iml_schema}.ast_col_guar_info.guartor_cert_type_cd is '保证人证件类型代码';
comment on column ${iml_schema}.ast_col_guar_info.guartor_cert_no is '保证人证件号码';
comment on column ${iml_schema}.ast_col_guar_info.guartor_guar_indep_cd is '保证人担保独立性代码';
comment on column ${iml_schema}.ast_col_guar_info.guartor_rgst_cty_cd is '保证人注册地国家代码';
comment on column ${iml_schema}.ast_col_guar_info.guartor_rgst_ext_rating_cd is '保证人注册地外部评级代码';
comment on column ${iml_schema}.ast_col_guar_info.guartor_ext_rating_dt is '保证人外部评级日期';
comment on column ${iml_schema}.ast_col_guar_info.guartor_ext_rating_cd is '保证人外部评级代码';
comment on column ${iml_schema}.ast_col_guar_info.guartor_intnal_rating_dt is '保证人内部评级日期';
comment on column ${iml_schema}.ast_col_guar_info.guartor_intnal_rating_cd is '保证人内部评级代码';
comment on column ${iml_schema}.ast_col_guar_info.guartor_ownsp_type_cd is '保证人所有制类型代码';
comment on column ${iml_schema}.ast_col_guar_info.guartor_net_asset is '保证人净资产';
comment on column ${iml_schema}.ast_col_guar_info.net_asset_curr_cd is '净资产币种代码';
comment on column ${iml_schema}.ast_col_guar_info.guar_insure_policy_num is '保证保险保单号码';
comment on column ${iml_schema}.ast_col_guar_info.guar_aim_cd is '保证目的代码';
comment on column ${iml_schema}.ast_col_guar_info.resdnt_flg is '居民标志';
comment on column ${iml_schema}.ast_col_guar_info.remark is '备注';
comment on column ${iml_schema}.ast_col_guar_info.rgst_dt is '登记日期';
comment on column ${iml_schema}.ast_col_guar_info.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.ast_col_guar_info.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.ast_col_guar_info.last_update_dt is '最后更新日期';
comment on column ${iml_schema}.ast_col_guar_info.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.ast_col_guar_info.update_org_id is '更新机构编号';
comment on column ${iml_schema}.ast_col_guar_info.start_dt is '开始时间';
comment on column ${iml_schema}.ast_col_guar_info.end_dt is '结束时间';
comment on column ${iml_schema}.ast_col_guar_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_guar_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_guar_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_guar_info.etl_timestamp is 'ETL处理时间戳';
