/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_abs_prod_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_abs_prod_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_abs_prod_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_abs_prod_info_h(
    prod_id varchar2(100) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,abs_prod_id varchar2(100) -- ABS产品编号
    ,prod_name varchar2(300) -- 产品名称
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,prod_status_cd varchar2(30) -- 产品状态代码
    ,prod_bus_status_cd varchar2(30) -- 产品业务状态代码
    ,prod_mode_cd varchar2(30) -- 产品模式代码
    ,pre_issue_tot number(30,2) -- 预发行总额
    ,asset_tot number(30,2) -- 资产总额
    ,cfm_issue_tot number(30,2) -- 确认发行总额
    ,curr_cd varchar2(30) -- 币种代码
    ,supt_clearup_repo_flg varchar2(10) -- 支持清仓回购标志
    ,asset_pool_id varchar2(100) -- 资产池编号
    ,trust_effect_dt date -- 信托生效日期
    ,trust_exp_dt date -- 信托到期日期
    ,incre_crdt_way_cd varchar2(30) -- 增信方式代码
    ,issue_dt date -- 发行日期
    ,trust_propty_dlvy_dt date -- 信托财产交付日期
    ,turn_pay_drift_days number(10) -- 转付偏移天数
    ,ts_flg varchar2(10) -- 暂存标志
    ,rgstrat_id varchar2(100) -- 登记人编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_tm timestamp -- 登记时间
    ,setment_way_cd varchar2(60) -- 交收方式代码
    ,deflt_rat number(30,8) -- 违约率
    ,repay_rat number(30,8) -- 早偿率
    ,ovdue_rat number(30,8) -- 逾期率
    ,ten_asset_deflt_rat number(30,8) -- 前十大资产违约率
    ,cashflow_meas_flg varchar2(10) -- 现金流测算标志
    ,asset_tran_cosdetn number(30,8) -- 资产转让对价
    ,tran_cosdetn_calc_way_cd varchar2(30) -- 转让对价计算方式代码
    ,tran_contr_id varchar2(100) -- 转让合同编号
    ,tran_comm_fee number(30,2) -- 转让手续费
    ,repo_int_rat number(18,8) -- 回购利率
    ,tran_cont_begin_dt date -- 转让合同起始日期
    ,tran_cont_exp_dt date -- 转让合同到期日期
    ,def_coll_ped_flg varchar2(10) -- 自定义归集周期标志
    ,tran_plat_cd varchar2(30) -- 交易平台代码
    ,tran_org_type_cd varchar2(30) -- 交易机构类型代码
    ,update_fee_plan_flg varchar2(10) -- 更新费用计划标志
    ,cntpty_tran_dt date -- 交易对手转账日期
    ,cntpty_pay_amt number(30,8) -- 交易对手已支付金额
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_abs_prod_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_abs_prod_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_abs_prod_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_abs_prod_info_h is '资产证券化产品信息历史';
comment on column ${iml_schema}.prd_abs_prod_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_abs_prod_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_abs_prod_info_h.abs_prod_id is 'ABS产品编号';
comment on column ${iml_schema}.prd_abs_prod_info_h.prod_name is '产品名称';
comment on column ${iml_schema}.prd_abs_prod_info_h.prod_type_cd is '产品类型代码';
comment on column ${iml_schema}.prd_abs_prod_info_h.prod_status_cd is '产品状态代码';
comment on column ${iml_schema}.prd_abs_prod_info_h.prod_bus_status_cd is '产品业务状态代码';
comment on column ${iml_schema}.prd_abs_prod_info_h.prod_mode_cd is '产品模式代码';
comment on column ${iml_schema}.prd_abs_prod_info_h.pre_issue_tot is '预发行总额';
comment on column ${iml_schema}.prd_abs_prod_info_h.asset_tot is '资产总额';
comment on column ${iml_schema}.prd_abs_prod_info_h.cfm_issue_tot is '确认发行总额';
comment on column ${iml_schema}.prd_abs_prod_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_abs_prod_info_h.supt_clearup_repo_flg is '支持清仓回购标志';
comment on column ${iml_schema}.prd_abs_prod_info_h.asset_pool_id is '资产池编号';
comment on column ${iml_schema}.prd_abs_prod_info_h.trust_effect_dt is '信托生效日期';
comment on column ${iml_schema}.prd_abs_prod_info_h.trust_exp_dt is '信托到期日期';
comment on column ${iml_schema}.prd_abs_prod_info_h.incre_crdt_way_cd is '增信方式代码';
comment on column ${iml_schema}.prd_abs_prod_info_h.issue_dt is '发行日期';
comment on column ${iml_schema}.prd_abs_prod_info_h.trust_propty_dlvy_dt is '信托财产交付日期';
comment on column ${iml_schema}.prd_abs_prod_info_h.turn_pay_drift_days is '转付偏移天数';
comment on column ${iml_schema}.prd_abs_prod_info_h.ts_flg is '暂存标志';
comment on column ${iml_schema}.prd_abs_prod_info_h.rgstrat_id is '登记人编号';
comment on column ${iml_schema}.prd_abs_prod_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.prd_abs_prod_info_h.rgst_tm is '登记时间';
comment on column ${iml_schema}.prd_abs_prod_info_h.setment_way_cd is '交收方式代码';
comment on column ${iml_schema}.prd_abs_prod_info_h.deflt_rat is '违约率';
comment on column ${iml_schema}.prd_abs_prod_info_h.repay_rat is '早偿率';
comment on column ${iml_schema}.prd_abs_prod_info_h.ovdue_rat is '逾期率';
comment on column ${iml_schema}.prd_abs_prod_info_h.ten_asset_deflt_rat is '前十大资产违约率';
comment on column ${iml_schema}.prd_abs_prod_info_h.cashflow_meas_flg is '现金流测算标志';
comment on column ${iml_schema}.prd_abs_prod_info_h.asset_tran_cosdetn is '资产转让对价';
comment on column ${iml_schema}.prd_abs_prod_info_h.tran_cosdetn_calc_way_cd is '转让对价计算方式代码';
comment on column ${iml_schema}.prd_abs_prod_info_h.tran_contr_id is '转让合同编号';
comment on column ${iml_schema}.prd_abs_prod_info_h.tran_comm_fee is '转让手续费';
comment on column ${iml_schema}.prd_abs_prod_info_h.repo_int_rat is '回购利率';
comment on column ${iml_schema}.prd_abs_prod_info_h.tran_cont_begin_dt is '转让合同起始日期';
comment on column ${iml_schema}.prd_abs_prod_info_h.tran_cont_exp_dt is '转让合同到期日期';
comment on column ${iml_schema}.prd_abs_prod_info_h.def_coll_ped_flg is '自定义归集周期标志';
comment on column ${iml_schema}.prd_abs_prod_info_h.tran_plat_cd is '交易平台代码';
comment on column ${iml_schema}.prd_abs_prod_info_h.tran_org_type_cd is '交易机构类型代码';
comment on column ${iml_schema}.prd_abs_prod_info_h.update_fee_plan_flg is '更新费用计划标志';
comment on column ${iml_schema}.prd_abs_prod_info_h.cntpty_tran_dt is '交易对手转账日期';
comment on column ${iml_schema}.prd_abs_prod_info_h.cntpty_pay_amt is '交易对手已支付金额';
comment on column ${iml_schema}.prd_abs_prod_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_abs_prod_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_abs_prod_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_abs_prod_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_abs_prod_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_abs_prod_info_h.etl_timestamp is 'ETL处理时间戳';
