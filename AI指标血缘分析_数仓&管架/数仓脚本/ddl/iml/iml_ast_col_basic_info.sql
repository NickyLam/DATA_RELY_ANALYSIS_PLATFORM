/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_basic_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_basic_info(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,col_type_id varchar2(60) -- 押品类型编号
    ,col_mgmt_id varchar2(60) -- 押品管理员工编号
    ,col_mgmt_org_id varchar2(300) -- 押品所属机构名称
    ,setup_dt date -- 建立日期
    ,com_prot_flg varchar2(10) -- 共同财产标志
    ,asset_obg_lot number(18,6) -- 资产权利人所占份额
    ,guar_effect_way_cd varchar2(10) -- 担保生效方式代码
    ,trast_insure_flg varchar2(10) -- 办理保险标志
    ,col_rgst_trast_status_cd varchar2(10) -- 押品登记办理状态代码
    ,col_insure_trast_status_cd varchar2(10) -- 押品保险办理状态代码
    ,col_insto_status_cd varchar2(10) -- 权证状态类型代码
    ,col_rela_status_cd varchar2(10) -- 押品关联状态代码
    ,col_espec_status_cd varchar2(10) -- 押品状态代码
    ,wt_md_cash_ability_cd varchar2(10) -- 权重法变现能力代码
    ,obank_guar_flg varchar2(10) -- 他行担保标志
    ,gcust_flg varchar2(10) -- 代保管标志
    ,col_val number(30,2) -- 我行确认价值
    ,curr_cd varchar2(10) -- 币种代码
    ,val_estim_dt date -- 价值评估日期
    ,data_src_cd varchar2(10) -- 数据来源代码
    ,col_info_check_status_cd varchar2(10) -- 押品信息审核状态代码
    ,col_modif_apv_status_cd varchar2(10) -- 押品修改审批状态代码
    ,np_cash_ability_cd varchar2(10) -- 内评初级法变现能力代码
    ,get_key_info_flg varchar2(10) -- 取得关键信息标志
    ,modifbl_flg varchar2(10) -- 可修改标志
    ,col_name varchar2(375) -- 押品名称
    ,pledge_ctrl_f_adj_coef_cd varchar2(10) -- 质押物控制力调整系数代码
    ,modif_emply_id varchar2(60) -- 修改员工编号
    ,save_hxb_flg varchar2(10) -- 保存我行标志
    ,final_modif_dt date -- 最后修改日期
    ,prior_comp_weight_qtty number(30,8) -- 优先受偿权数额
    ,fst_flg varchar2(30) -- 第一顺位标志
    ,col_rgst_b_type_cd varchar2(30) -- 押品登记簿类型代码
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
grant select on ${iml_schema}.ast_col_basic_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_basic_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_basic_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_basic_info is '押品基本信息';
comment on column ${iml_schema}.ast_col_basic_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_basic_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_basic_info.col_type_id is '押品类型编号';
comment on column ${iml_schema}.ast_col_basic_info.col_mgmt_id is '押品管理员工编号';
comment on column ${iml_schema}.ast_col_basic_info.col_mgmt_org_id is '押品所属机构名称';
comment on column ${iml_schema}.ast_col_basic_info.setup_dt is '建立日期';
comment on column ${iml_schema}.ast_col_basic_info.com_prot_flg is '共同财产标志';
comment on column ${iml_schema}.ast_col_basic_info.asset_obg_lot is '资产权利人所占份额';
comment on column ${iml_schema}.ast_col_basic_info.guar_effect_way_cd is '担保生效方式代码';
comment on column ${iml_schema}.ast_col_basic_info.trast_insure_flg is '办理保险标志';
comment on column ${iml_schema}.ast_col_basic_info.col_rgst_trast_status_cd is '押品登记办理状态代码';
comment on column ${iml_schema}.ast_col_basic_info.col_insure_trast_status_cd is '押品保险办理状态代码';
comment on column ${iml_schema}.ast_col_basic_info.col_insto_status_cd is '权证状态类型代码';
comment on column ${iml_schema}.ast_col_basic_info.col_rela_status_cd is '押品关联状态代码';
comment on column ${iml_schema}.ast_col_basic_info.col_espec_status_cd is '押品状态代码';
comment on column ${iml_schema}.ast_col_basic_info.wt_md_cash_ability_cd is '权重法变现能力代码';
comment on column ${iml_schema}.ast_col_basic_info.obank_guar_flg is '他行担保标志';
comment on column ${iml_schema}.ast_col_basic_info.gcust_flg is '代保管标志';
comment on column ${iml_schema}.ast_col_basic_info.col_val is '我行确认价值';
comment on column ${iml_schema}.ast_col_basic_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_basic_info.val_estim_dt is '价值评估日期';
comment on column ${iml_schema}.ast_col_basic_info.data_src_cd is '数据来源代码';
comment on column ${iml_schema}.ast_col_basic_info.col_info_check_status_cd is '押品信息审核状态代码';
comment on column ${iml_schema}.ast_col_basic_info.col_modif_apv_status_cd is '押品修改审批状态代码';
comment on column ${iml_schema}.ast_col_basic_info.np_cash_ability_cd is '内评初级法变现能力代码';
comment on column ${iml_schema}.ast_col_basic_info.get_key_info_flg is '取得关键信息标志';
comment on column ${iml_schema}.ast_col_basic_info.modifbl_flg is '可修改标志';
comment on column ${iml_schema}.ast_col_basic_info.col_name is '押品名称';
comment on column ${iml_schema}.ast_col_basic_info.pledge_ctrl_f_adj_coef_cd is '质押物控制力调整系数代码';
comment on column ${iml_schema}.ast_col_basic_info.modif_emply_id is '修改员工编号';
comment on column ${iml_schema}.ast_col_basic_info.save_hxb_flg is '保存我行标志';
comment on column ${iml_schema}.ast_col_basic_info.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.ast_col_basic_info.prior_comp_weight_qtty is '优先受偿权数额';
comment on column ${iml_schema}.ast_col_basic_info.fst_flg is '第一顺位标志';
comment on column ${iml_schema}.ast_col_basic_info.col_rgst_b_type_cd is '押品登记簿类型代码';
comment on column ${iml_schema}.ast_col_basic_info.create_dt is '创建日期';
comment on column ${iml_schema}.ast_col_basic_info.update_dt is '更新日期';
comment on column ${iml_schema}.ast_col_basic_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_col_basic_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_basic_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_basic_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_basic_info.etl_timestamp is 'ETL处理时间戳';
