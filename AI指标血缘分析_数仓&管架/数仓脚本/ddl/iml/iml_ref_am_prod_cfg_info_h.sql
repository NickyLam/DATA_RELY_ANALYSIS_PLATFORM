/*
Purpose:    整合模型层-切片建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_am_prod_cfg_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_am_prod_cfg_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_am_prod_cfg_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_am_prod_cfg_info_h(
    finc_prod_id varchar2(100) -- 理财产品编号
    ,lp_id varchar2(100) -- 法人编号
    ,acctnt_cls varchar2(500) -- 会计分类
    ,asset_id varchar2(100) -- 资产编号
    ,stat_dt date -- 统计日期
    ,prod_type varchar2(500) -- 产品类型
    ,prod_name varchar2(500) -- 产品名称
    ,prod_value_dt date -- 产品起息日期
    ,prod_exp_dt date -- 产品到期日期
    ,paid_in_capital number(30,14) -- 实收资本
    ,cust_yld_rat number(18,8) -- 客户收益率
    ,asset_type varchar2(500) -- 资产类型
    ,asset_name varchar2(500) -- 资产名称
    ,fac_val number(30,14) -- 面值
    ,buy_net_price_cost number(30,14) -- 买入净价成本
    ,int_adj number(30,14) -- 利息调整
    ,fst_stl_amt number(30,14) -- 首期结算金额
    ,exp_stl_amt number(30,14) -- 到期结算金额
    ,int_recvbl number(30,14) -- 应收利息
    ,acru_int number(30,14) -- 应计利息
    ,bond_evltion_net_price number(30,14) -- 债券估值净价
    ,asset_impam_amt number(30,14) -- 资产减值金额
    ,evha_val_chag number(30,14) -- 公允价值变动
    ,fac_val_int_rat number(30,14) -- 票面利率
    ,actl_int_rat number(30,14) -- 实际利率
    ,repo_int_rat number(30,14) -- 回购利率
    ,asset_value_dt date -- 资产起息日期
    ,asset_matu_dt date -- 资产到期日期
    ,issue_price number(30,14) -- 发行价格
    ,pay_int_freq varchar2(500) -- 付息频率
    ,rpp_freq varchar2(500) -- 还本频率
    ,last_pay_int_dt date -- 上一付息日期
    ,int_accr_base varchar2(500) -- 计息基准
    ,pay_status varchar2(500) -- 支付状态
    ,last_int_accr_begin_dt date -- 上一计息起始日期
    ,last_int_accr_end_dt date -- 上一计息结束日期
    ,prft_type_cd varchar2(60) -- 收益类型代码
    ,g06_pente_bf_asset_cls_cd varchar2(60) -- G06穿透前资产分类代码
    ,g06_pente_post_asset_cls_cd varchar2(60) -- G06穿透后资产分类代码
    ,exp_yld_rat number(30,14) -- 到期收益率
    ,asset_level1_cls_cd varchar2(60) -- 资产一级分类代码
    ,asset_level2_cls_cd varchar2(60) -- 资产二级分类代码
    ,asset_level3_cls_cd varchar2(60) -- 资产三级分类代码
    ,asset_level4_cls_cd varchar2(60) -- 资产四级分类代码
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.ref_am_prod_cfg_info_h to ${icl_schema};
grant select on ${iml_schema}.ref_am_prod_cfg_info_h to ${idl_schema};
grant select on ${iml_schema}.ref_am_prod_cfg_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_am_prod_cfg_info_h is '资管产品配置信息历史';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.acctnt_cls is '会计分类';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.asset_id is '资产编号';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.stat_dt is '统计日期';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.prod_type is '产品类型';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.prod_name is '产品名称';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.prod_value_dt is '产品起息日期';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.prod_exp_dt is '产品到期日期';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.paid_in_capital is '实收资本';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.cust_yld_rat is '客户收益率';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.asset_type is '资产类型';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.asset_name is '资产名称';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.fac_val is '面值';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.buy_net_price_cost is '买入净价成本';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.int_adj is '利息调整';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.fst_stl_amt is '首期结算金额';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.exp_stl_amt is '到期结算金额';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.int_recvbl is '应收利息';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.acru_int is '应计利息';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.bond_evltion_net_price is '债券估值净价';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.asset_impam_amt is '资产减值金额';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.evha_val_chag is '公允价值变动';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.fac_val_int_rat is '票面利率';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.actl_int_rat is '实际利率';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.repo_int_rat is '回购利率';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.asset_value_dt is '资产起息日期';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.asset_matu_dt is '资产到期日期';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.issue_price is '发行价格';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.pay_int_freq is '付息频率';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.rpp_freq is '还本频率';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.last_pay_int_dt is '上一付息日期';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.int_accr_base is '计息基准';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.pay_status is '支付状态';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.last_int_accr_begin_dt is '上一计息起始日期';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.last_int_accr_end_dt is '上一计息结束日期';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.prft_type_cd is '收益类型代码';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.g06_pente_bf_asset_cls_cd is 'G06穿透前资产分类代码';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.g06_pente_post_asset_cls_cd is 'G06穿透后资产分类代码';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.exp_yld_rat is '到期收益率';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.asset_level1_cls_cd is '资产一级分类代码';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.asset_level2_cls_cd is '资产二级分类代码';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.asset_level3_cls_cd is '资产三级分类代码';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.asset_level4_cls_cd is '资产四级分类代码';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_am_prod_cfg_info_h.etl_timestamp is 'ETL处理时间戳';
