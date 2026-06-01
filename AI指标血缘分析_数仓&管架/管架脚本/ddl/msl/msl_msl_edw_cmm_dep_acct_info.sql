/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_cmm_dep_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_cmm_dep_acct_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_cmm_dep_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_cmm_dep_acct_info(
    etl_dt date
    ,lp_id varchar2(60)
    ,acct_id varchar2(60)
    ,acct_name varchar2(250)
    ,cust_acct_id varchar2(60)
    ,cust_acct_sub_acct_num varchar2(5)
    ,cust_id varchar2(60)
    ,subj_id varchar2(60)
    ,dep_kind_cd varchar2(30)
    ,acct_cls_cd varchar2(10)
    ,acct_type_cd varchar2(10)
    ,acct_attr_cd varchar2(10)
    ,dep_term varchar2(10)
    ,std_prod_id varchar2(60)
    ,ext_prod_id varchar2(60)
    ,intnal_prod_id varchar2(60)
    ,open_oa_apv_form_num varchar2(100)
    ,dep_acct_status_cd varchar2(10)
    ,cust_type_cd varchar2(10)
    ,corp_acct_flg varchar2(10)
    ,stop_pay_status_cd varchar2(10)
    ,general_exch_flg varchar2(10)
    ,advise_dep_flg varchar2(10)
    ,agt_dep_flg varchar2(10)
    ,float_int_rat_flg varchar2(10)
    ,int_rat_float_way_cd varchar2(10)
    ,int_rat_adj_ped_corp_cd varchar2(10)
    ,int_rat_adj_ped_freq number(10)
    ,rc_flg varchar2(10)
    ,margin_flg varchar2(10)
    ,agree_dep_flg varchar2(10)
    ,ibank_dep_flg varchar2(10)
    ,dep_basic_acct_flg varchar2(10)
    ,ec_flg varchar2(10)
    ,privavy_acct_flg varchar2(10)
    ,legal_acct_flg varchar2(10)
    ,auto_redt_flg varchar2(10)
    ,redted_cnt varchar2(10)
    ,itg_dep_earliest_drawbl_dt date
    ,sleep_acct_flg varchar2(10)
    ,dormt_acct_flg varchar2(10)
    ,sal_acct_flg varchar2(10)
    ,froz_flg varchar2(10)
    ,advd_draw_flg varchar2(10)
    ,tranbl_flg varchar2(10)
    ,int_accr_base_cd varchar2(10)
    ,int_accr_flg varchar2(10)
    ,int_set_way_cd varchar2(10)
    ,int_accr_way_cd varchar2(10)
    ,allow_od_flg varchar2(10)
    ,curr_cd varchar2(10)
    ,redt_way_cd varchar2(10)
    ,open_acct_chn_type_cd varchar2(10)
    ,tran_chn_status_cd varchar2(10)
    ,open_acct_dt date
    ,open_acct_tm timestamp
    ,clos_acct_dt date
    ,clos_acct_tm timestamp
    ,actv_dt date
    ,value_dt date
    ,exp_dt date
    ,final_activ_acct_dt date
    ,agree_dep_value_dt date
    ,agree_dep_exp_dt date
    ,froz_dt date
    ,unfrz_dt date
    ,last_int_set_dt date
    ,next_int_set_dt date
    ,fir_value_dt date
    ,agree_int_rat number(18,8)
    ,base_rat_type_cd varchar2(10)
    ,base_rat number(18,8)
    ,exec_int_rat number(18,8)
    ,td_acru_int number(30,8)
    ,currt_acru_int number(30,8)
    ,cust_mgr_id varchar2(60)
    ,open_acct_teller_id varchar2(60)
    ,clos_acct_teller_id varchar2(60)
    ,open_acct_org_id varchar2(60)
    ,close_acct_org_id varchar2(60)
    ,belong_org_id varchar2(60)
    ,loc_flg varchar2(10)
    ,expe_higt_yld_rat number(18,8)
    ,agree_dep_init_amt number(30,2)
    ,open_acct_amt number(30,2)
    ,currt_bal number(30,2)
    ,aval_bal number(30,2)
    ,froz_amt number(18,2)
    ,stop_pay_amt number(18,2)
    ,cl_curr_currt_bal number(30,2)
    ,ear_d_bal number(30,2)
    ,ear_m_bal number(30,2)
    ,ear_s_bal number(30,2)
    ,ear_y_bal number(30,2)
    ,y_acm_bal number(30,2)
    ,s_acm_bal number(30,2)
    ,m_acm_bal number(30,2)
    ,cl_curr_ear_d_bal number(30,2)
    ,cl_curr_ear_m_bal number(30,2)
    ,cl_curr_ear_s_bal number(30,2)
    ,cl_curr_ear_y_bal number(30,2)
    ,cl_curr_y_acm_bal number(30,2)
    ,cl_curr_ear_d_y_acm_bal number(30,2)
    ,cl_curr_ear_m_y_acm_bal number(30,2)
    ,cl_curr_ear_s_y_acm_bal number(30,2)
    ,cl_curr_ear_y_y_acm_bal number(30,2)
    ,cl_curr_s_acm_bal number(30,2)
    ,cl_curr_ear_d_s_acm_bal number(30,2)
    ,cl_curr_ear_s_s_acm_bal number(30,2)
    ,cl_curr_ear_y_s_acm_bal number(30,2)
    ,cl_curr_m_acm_bal number(30,2)
    ,cl_curr_ear_d_m_acm_bal number(30,2)
    ,cl_curr_ear_m_m_acm_bal number(30,2)
    ,cl_curr_ear_y_m_acm_bal number(30,2)
    ,cds_liab_acct_num varchar2(60)
    ,corp_supv_acct_flg varchar2(10)
    ,y_avg_bal number(30,2)
    ,q_avg_bal number(30,2)
    ,m_avg_bal number(30,2)
    ,cl_curr_y_avg_bal number(30,2)
    ,cl_curr_q_avg_bal number(30,2)
    ,cl_curr_m_avg_bal number(30,2)
    ,web_dep_flg varchar2(10)
    ,bill_pool_margin_flg varchar2(10)
    ,bill_pool_type_cd varchar2(10)
    ,old_acct_id varchar2(60)
    ,int_paybl_subj_id varchar2(60)
    ,int_paybl_adj_subj_id varchar2(60)
    ,int_expns_subj_id varchar2(60)
    ,int_expns_adj_subj_id varchar2(60)
    ,open_flow_num varchar2(60)
    ,clos_flow_num varchar2(60)
    ,currt_int_paybl_adj number(30,8)
    ,td_int_expns number(30,8)
    ,td_int_expns_adj number(30,8)
    ,long_hang_acct_flg varchar2(10)
    ,acct_usage_cd varchar2(30)
    ,agt_dep_earliest_drawbl_dt date
    ,lowt_bal number(30,2)
    ,cash_flg varchar2(10)
    ,cust_acct_card_no varchar2(60)
    ,dep_char_cd varchar2(10)
    ,agree_dep_rels_dt date
    ,mater_acct_flg varchar2(10)
    ,delay_pay_int_flg varchar2(10)
    ,delay_pay_int_days number(30,2)
    ,old_cust_acct_sub_acct_num varchar2(10)
    ,dep_term_tenor_type_cd varchar2(10)
    ,pd_id varchar2(60)
    ,approval_id varchar2(100)
    ,general_exch_org_id varchar2(60)
    ,general_storage_flg varchar2(10)
    ,vtual_acct_flg varchar2(10)
    ,entry_flg varchar2(10)
    ,turn_dormt_acct_dt date
    ,main_acct_id varchar2(60)
    ,card_no varchar2(60)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_cmm_dep_acct_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_cmm_dep_acct_info is '存款分户信息';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.acct_id is '账户编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.acct_name is '账户名称';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cust_acct_id is '客户账户编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cust_acct_sub_acct_num is '客户账户子户号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cust_id is '客户编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.subj_id is '科目编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.dep_kind_cd is '储种代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.acct_cls_cd is '账户分类代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.acct_type_cd is '账户类型代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.acct_attr_cd is '账户属性代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.dep_term is '存期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.std_prod_id is '标准产品编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.ext_prod_id is '外部产品编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.intnal_prod_id is '内部产品编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.open_oa_apv_form_num is '开户OA审批单号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.dep_acct_status_cd is '存款账户状态代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cust_type_cd is '客户类型代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.corp_acct_flg is '对公账户标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.stop_pay_status_cd is '止付状态代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.general_exch_flg is '通兑标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.advise_dep_flg is '通知存款标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.agt_dep_flg is '协议存款标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.float_int_rat_flg is '浮动利率标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.int_rat_adj_ped_corp_cd is '利率调整周期单位代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.int_rat_adj_ped_freq is '利率调整周期频率';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.rc_flg is '定活标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.margin_flg is '保证金标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.agree_dep_flg is '协定存款标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.ibank_dep_flg is '同业存款标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.dep_basic_acct_flg is '存款基本户标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.ec_flg is '钞汇标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.privavy_acct_flg is '隐私账户标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.legal_acct_flg is '涉案账户标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.auto_redt_flg is '自动转存标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.redted_cnt is '已转存次数';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.itg_dep_earliest_drawbl_dt is '智能存款最早可提支日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.sleep_acct_flg is '睡眠户标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.dormt_acct_flg is '不动户标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.sal_acct_flg is '工资账户标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.froz_flg is '冻结标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.advd_draw_flg is '可提前支取标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.tranbl_flg is '可转让标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.int_accr_base_cd is '计息基准代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.int_accr_flg is '计息标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.int_set_way_cd is '结息方式代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.int_accr_way_cd is '计息方式代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.allow_od_flg is '允许透支标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.curr_cd is '币种代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.redt_way_cd is '转存方式代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.open_acct_chn_type_cd is '开户渠道类型代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.tran_chn_status_cd is '交易渠道状态代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.open_acct_dt is '开户日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.open_acct_tm is '开户时间';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.clos_acct_dt is '销户日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.clos_acct_tm is '销户时间';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.actv_dt is '激活日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.value_dt is '起息日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.exp_dt is '到期日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.final_activ_acct_dt is '最后动户日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.agree_dep_value_dt is '协定存款起息日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.agree_dep_exp_dt is '协定存款到期日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.froz_dt is '冻结日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.unfrz_dt is '解冻日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.last_int_set_dt is '上次结息日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.next_int_set_dt is '下次结息日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.fir_value_dt is '首次起息日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.agree_int_rat is '协定利率';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.base_rat_type_cd is '基准利率类型代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.base_rat is '基准利率';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.exec_int_rat is '执行利率';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.td_acru_int is '当日应计利息';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.currt_acru_int is '当期应计利息';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cust_mgr_id is '客户经理编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.open_acct_teller_id is '开户柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.clos_acct_teller_id is '销户柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.open_acct_org_id is '开户机构编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.close_acct_org_id is '销户机构编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.belong_org_id is '所属机构编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.loc_flg is '开立存款证实书标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.expe_higt_yld_rat is '预期最高收益率';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.agree_dep_init_amt is '协定存款起存金额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.open_acct_amt is '开户金额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.currt_bal is '当期余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.aval_bal is '可用余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.froz_amt is '冻结金额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.stop_pay_amt is '止付金额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_currt_bal is '折本币当期余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.ear_d_bal is '日初余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.ear_m_bal is '月初余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.ear_s_bal is '季初余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.ear_y_bal is '年初余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.y_acm_bal is '年累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.s_acm_bal is '季累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.m_acm_bal is '月累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_d_bal is '折本币日初余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_m_bal is '折本币月初余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_s_bal is '折本币季初余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_y_bal is '折本币年初余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_y_acm_bal is '折本币年累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_d_y_acm_bal is '折本币日初年累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_m_y_acm_bal is '折本币月初年累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_s_y_acm_bal is '折本币季初年累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_y_y_acm_bal is '折本币年初年累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_s_acm_bal is '折本币季累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_d_s_acm_bal is '折本币日初季累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_s_s_acm_bal is '折本币季初季累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_y_s_acm_bal is '折本币年初季累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_m_acm_bal is '折本币月累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_d_m_acm_bal is '折本币日初月累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_m_m_acm_bal is '折本币月初月累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_ear_y_m_acm_bal is '折本币年初月累计余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cds_liab_acct_num is '负债账户编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.corp_supv_acct_flg is '对公监管户标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.y_avg_bal is '年日均余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.q_avg_bal is '季日均余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.m_avg_bal is '月日均余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_y_avg_bal is '折本币年日均余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_q_avg_bal is '折本币季日均余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cl_curr_m_avg_bal is '折本币月日均余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.web_dep_flg is '网络存款标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.bill_pool_margin_flg is '票据池保证金标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.bill_pool_type_cd is '票据池类型代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.old_acct_id is '旧账户编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.int_paybl_subj_id is '应付利息科目编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.int_paybl_adj_subj_id is '应付利息调整科目编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.int_expns_subj_id is '利息支出科目编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.int_expns_adj_subj_id is '利息支出调整科目编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.open_flow_num is '开户流水号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.clos_flow_num is '销户流水号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.currt_int_paybl_adj is '当期应付利息调整';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.td_int_expns is '当日利息支出';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.td_int_expns_adj is '当日利息支出调整';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.long_hang_acct_flg is '久悬户标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.acct_usage_cd is '账户用途代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.agt_dep_earliest_drawbl_dt is '协议存款最早可提支日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.lowt_bal is '最低余额';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cash_flg is '取现标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.cust_acct_card_no is '客户账户卡号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.dep_char_cd is '存款性质代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.agree_dep_rels_dt is '协定存款解约日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.mater_acct_flg is '母户标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.delay_pay_int_flg is '延期付息标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.delay_pay_int_days is '延期付息天数';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.old_cust_acct_sub_acct_num is '旧客户账户子户号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.dep_term_tenor_type_cd is '存期期限类型代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.pd_id is '期次编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.approval_id is '核准件编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.general_exch_org_id is '通兑机构编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.general_storage_flg is '通存标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.vtual_acct_flg is '虚拟账户标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.entry_flg is '记账标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.turn_dormt_acct_dt is '转不动户日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.main_acct_id is '主账户编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_acct_info.card_no is '卡号';
