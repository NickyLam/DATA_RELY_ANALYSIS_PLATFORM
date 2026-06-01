/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdws_a_cm_hold
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdws_a_cm_hold
whenever sqlerror continue none;
drop table ${iol_schema}.bdws_a_cm_hold purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdws_a_cm_hold(
    hold_id varchar2(4000) -- 持有ID
    ,cust_id varchar2(4000) -- 客户ID
    ,zg_hold varchar2(4000) -- 资管信托持有
    ,hq_ck_hold varchar2(4000) -- 活期存款持有
    ,dq_ck_hold varchar2(4000) -- 定期存款持有
    ,big_ck_hold varchar2(4000) -- 大额存款持有
    ,dk_hold varchar2(4000) -- 贷款持有
    ,jj_hold varchar2(4000) -- 基金持有
    ,lc_hold varchar2(4000) -- 理财持有
    ,t0_lc_hold varchar2(4000) -- T0非保本理财产品持有
    ,bx_hold varchar2(4000) -- 保险持有
    ,gjs_hold varchar2(4000) -- 实物贵金属持有
    ,acct_hold varchar2(4000) -- 账户持有
    ,dsf_hold varchar2(4000) -- 三方存管持有
    ,et_date varchar2(4000) -- 业务日期
    ,dq_ck_once_hold varchar2(4000) -- 曾经持有定期存款
    ,big_ck_once_hold varchar2(4000) -- 曾经持有大额存单
    ,dk_once_hold varchar2(4000) -- 曾经有贷款
    ,jj_once_hold varchar2(4000) -- 曾经持有基金
    ,dsf_once_hold varchar2(4000) -- 曾经持有第三方存管
    ,lc_once_hold varchar2(4000) -- 曾经持有理财
    ,zg_once_hold varchar2(4000) -- 曾经持有资管信托
    ,t0_lc_once_hold varchar2(4000) -- 曾经持有T0理财
    ,dq_ck_history_hold varchar2(4000) -- 历史持有定期存款
    ,big_ck_history_hold varchar2(4000) -- 历史持有大额存单
    ,dk_history_hold varchar2(4000) -- 历史有贷款
    ,jj_history_hold varchar2(4000) -- 历史持有基金
    ,dsf_history_hold varchar2(4000) -- 历史持有第三方存管
    ,lc_history_hold varchar2(4000) -- 历史持有理财
    ,t0_lc_history_hold varchar2(4000) -- 历史持有T0理财
    ,zg_history_hold varchar2(4000) -- 历史持有资管信托
    ,acct_history_hold varchar2(4000) -- 历史持有账户
    ,if_xxc_dept_hold varchar2(4000) -- 是否持有新兴存
    ,if_tz_dept_hold varchar2(4000) -- 是否持有通知存款
    ,if_aj_lodn_hold varchar2(4000) -- 是否持有个人按揭贷款
    ,if_xf_lodn_hold varchar2(4000) -- 是否持有个人消费贷款
    ,if_jy_lodn_hold varchar2(4000) -- 是否持有个人经营贷款
    ,if_qt_lodn_hold varchar2(4000) -- 是否持有个人其它贷款
    ,if_bb_finc_hold varchar2(4000) -- 是否持有保本类型理财产品
    ,if_nbb_gd_finc_hold varchar2(4000) -- 是否持有非保本滚动类型理财产品
    ,if_nbb_fx_finc_hold varchar2(4000) -- 是否持有非保本分销类型理财产品
    ,if_nbb_qt_finc_hold varchar2(4000) -- 是否持有非保本其它类型理财产品
    ,if_hb_fund_hold varchar2(4000) -- 是否持有贷币型基金
    ,if_zq_fund_hold varchar2(4000) -- 是否持有债券型基金
    ,if_he_fund_hold varchar2(4000) -- 是否持有混合型基金
    ,if_gp_fund_hold varchar2(4000) -- 是否持有股票型基金
    ,if_qdii_fund_hold varchar2(4000) -- 是否持有QDII基金
    ,if_zsh_fund_hold varchar2(4000) -- 是否持有指数型基金
    ,if_shp_fund_hold varchar2(4000) -- 是否持有商品型基金
    ,ft_hold varchar2(4000) -- 家族信托持有
    ,ft_history_hold varchar2(4000) -- 历史持有家族信托
    ,ft_once_hold varchar2(4000) -- 曾经持有家族信托
    ,if_axc_dept_hold varchar2(4000) -- 是否持有安兴存
    ,comb_prod_once_hold varchar2(4000) -- 曾经持有组合宝
    ,comb_prod_history_hold varchar2(4000) -- 历史持有组合宝
    ,if_comb_prod_hold varchar2(4000) -- 是否持有组合宝
    ,if_jsy_dept_hold varchar2(4000) -- 是否持有华兴结算盈
    ,if_dollerxc_dept_hold varchar2(4000) -- 是否持有美元优选现钞
    ,if_dollerxh_dept_hold varchar2(4000) -- 是否持有美元优选现汇
    ,load_date varchar2(4000) -- 分区字段
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
grant select on ${iol_schema}.bdws_a_cm_hold to ${iml_schema};
grant select on ${iol_schema}.bdws_a_cm_hold to ${icl_schema};
grant select on ${iol_schema}.bdws_a_cm_hold to ${idl_schema};
grant select on ${iol_schema}.bdws_a_cm_hold to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdws_a_cm_hold is '客户持有';
comment on column ${iol_schema}.bdws_a_cm_hold.hold_id is '持有ID';
comment on column ${iol_schema}.bdws_a_cm_hold.cust_id is '客户ID';
comment on column ${iol_schema}.bdws_a_cm_hold.zg_hold is '资管信托持有';
comment on column ${iol_schema}.bdws_a_cm_hold.hq_ck_hold is '活期存款持有';
comment on column ${iol_schema}.bdws_a_cm_hold.dq_ck_hold is '定期存款持有';
comment on column ${iol_schema}.bdws_a_cm_hold.big_ck_hold is '大额存款持有';
comment on column ${iol_schema}.bdws_a_cm_hold.dk_hold is '贷款持有';
comment on column ${iol_schema}.bdws_a_cm_hold.jj_hold is '基金持有';
comment on column ${iol_schema}.bdws_a_cm_hold.lc_hold is '理财持有';
comment on column ${iol_schema}.bdws_a_cm_hold.t0_lc_hold is 'T0非保本理财产品持有';
comment on column ${iol_schema}.bdws_a_cm_hold.bx_hold is '保险持有';
comment on column ${iol_schema}.bdws_a_cm_hold.gjs_hold is '实物贵金属持有';
comment on column ${iol_schema}.bdws_a_cm_hold.acct_hold is '账户持有';
comment on column ${iol_schema}.bdws_a_cm_hold.dsf_hold is '三方存管持有';
comment on column ${iol_schema}.bdws_a_cm_hold.et_date is '业务日期';
comment on column ${iol_schema}.bdws_a_cm_hold.dq_ck_once_hold is '曾经持有定期存款';
comment on column ${iol_schema}.bdws_a_cm_hold.big_ck_once_hold is '曾经持有大额存单';
comment on column ${iol_schema}.bdws_a_cm_hold.dk_once_hold is '曾经有贷款';
comment on column ${iol_schema}.bdws_a_cm_hold.jj_once_hold is '曾经持有基金';
comment on column ${iol_schema}.bdws_a_cm_hold.dsf_once_hold is '曾经持有第三方存管';
comment on column ${iol_schema}.bdws_a_cm_hold.lc_once_hold is '曾经持有理财';
comment on column ${iol_schema}.bdws_a_cm_hold.zg_once_hold is '曾经持有资管信托';
comment on column ${iol_schema}.bdws_a_cm_hold.t0_lc_once_hold is '曾经持有T0理财';
comment on column ${iol_schema}.bdws_a_cm_hold.dq_ck_history_hold is '历史持有定期存款';
comment on column ${iol_schema}.bdws_a_cm_hold.big_ck_history_hold is '历史持有大额存单';
comment on column ${iol_schema}.bdws_a_cm_hold.dk_history_hold is '历史有贷款';
comment on column ${iol_schema}.bdws_a_cm_hold.jj_history_hold is '历史持有基金';
comment on column ${iol_schema}.bdws_a_cm_hold.dsf_history_hold is '历史持有第三方存管';
comment on column ${iol_schema}.bdws_a_cm_hold.lc_history_hold is '历史持有理财';
comment on column ${iol_schema}.bdws_a_cm_hold.t0_lc_history_hold is '历史持有T0理财';
comment on column ${iol_schema}.bdws_a_cm_hold.zg_history_hold is '历史持有资管信托';
comment on column ${iol_schema}.bdws_a_cm_hold.acct_history_hold is '历史持有账户';
comment on column ${iol_schema}.bdws_a_cm_hold.if_xxc_dept_hold is '是否持有新兴存';
comment on column ${iol_schema}.bdws_a_cm_hold.if_tz_dept_hold is '是否持有通知存款';
comment on column ${iol_schema}.bdws_a_cm_hold.if_aj_lodn_hold is '是否持有个人按揭贷款';
comment on column ${iol_schema}.bdws_a_cm_hold.if_xf_lodn_hold is '是否持有个人消费贷款';
comment on column ${iol_schema}.bdws_a_cm_hold.if_jy_lodn_hold is '是否持有个人经营贷款';
comment on column ${iol_schema}.bdws_a_cm_hold.if_qt_lodn_hold is '是否持有个人其它贷款';
comment on column ${iol_schema}.bdws_a_cm_hold.if_bb_finc_hold is '是否持有保本类型理财产品';
comment on column ${iol_schema}.bdws_a_cm_hold.if_nbb_gd_finc_hold is '是否持有非保本滚动类型理财产品';
comment on column ${iol_schema}.bdws_a_cm_hold.if_nbb_fx_finc_hold is '是否持有非保本分销类型理财产品';
comment on column ${iol_schema}.bdws_a_cm_hold.if_nbb_qt_finc_hold is '是否持有非保本其它类型理财产品';
comment on column ${iol_schema}.bdws_a_cm_hold.if_hb_fund_hold is '是否持有贷币型基金';
comment on column ${iol_schema}.bdws_a_cm_hold.if_zq_fund_hold is '是否持有债券型基金';
comment on column ${iol_schema}.bdws_a_cm_hold.if_he_fund_hold is '是否持有混合型基金';
comment on column ${iol_schema}.bdws_a_cm_hold.if_gp_fund_hold is '是否持有股票型基金';
comment on column ${iol_schema}.bdws_a_cm_hold.if_qdii_fund_hold is '是否持有QDII基金';
comment on column ${iol_schema}.bdws_a_cm_hold.if_zsh_fund_hold is '是否持有指数型基金';
comment on column ${iol_schema}.bdws_a_cm_hold.if_shp_fund_hold is '是否持有商品型基金';
comment on column ${iol_schema}.bdws_a_cm_hold.ft_hold is '家族信托持有';
comment on column ${iol_schema}.bdws_a_cm_hold.ft_history_hold is '历史持有家族信托';
comment on column ${iol_schema}.bdws_a_cm_hold.ft_once_hold is '曾经持有家族信托';
comment on column ${iol_schema}.bdws_a_cm_hold.if_axc_dept_hold is '是否持有安兴存';
comment on column ${iol_schema}.bdws_a_cm_hold.comb_prod_once_hold is '曾经持有组合宝';
comment on column ${iol_schema}.bdws_a_cm_hold.comb_prod_history_hold is '历史持有组合宝';
comment on column ${iol_schema}.bdws_a_cm_hold.if_comb_prod_hold is '是否持有组合宝';
comment on column ${iol_schema}.bdws_a_cm_hold.if_jsy_dept_hold is '是否持有华兴结算盈';
comment on column ${iol_schema}.bdws_a_cm_hold.if_dollerxc_dept_hold is '是否持有美元优选现钞';
comment on column ${iol_schema}.bdws_a_cm_hold.if_dollerxh_dept_hold is '是否持有美元优选现汇';
comment on column ${iol_schema}.bdws_a_cm_hold.load_date is '分区字段';
comment on column ${iol_schema}.bdws_a_cm_hold.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdws_a_cm_hold.etl_timestamp is 'ETL处理时间戳';
