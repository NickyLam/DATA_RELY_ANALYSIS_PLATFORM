/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl cmm_dep_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.cmm_dep_acct_info
whenever sqlerror continue none;
drop table ${idl_schema}.cmm_dep_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.cmm_dep_acct_info(
    etl_dt date -- ETL处理日期
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,acct_name varchar2(375) -- 账户名称
    ,cust_acct_id varchar2(60) -- 客户账户编号
    ,cust_acct_sub_acct_num varchar2(5) -- 客户账户子户号
    ,cust_id varchar2(60) -- 客户编号
    ,subj_id varchar2(60) -- 科目编号
    ,dep_kind_cd varchar2(30) -- 储种代码
    ,acct_cls_cd varchar2(10) -- 账户分类代码
    ,acct_type_cd varchar2(10) -- 账户类型代码
    ,acct_attr_cd varchar2(10) -- 账户属性代码
    ,dep_term varchar2(15) -- 存期
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,ext_prod_id varchar2(60) -- 外部产品编号
    ,intnal_prod_id varchar2(60) -- 内部产品编号
    ,open_oa_apv_form_num varchar2(100) -- 开户OA审批单号
    ,dep_acct_status_cd varchar2(10) -- 存款账户状态代码
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,corp_acct_flg varchar2(10) -- 对公账户标志
    ,stop_pay_status_cd varchar2(10) -- 止付状态代码
    ,general_exch_flg varchar2(10) -- 通兑标志
    ,advise_dep_flg varchar2(10) -- 通知存款标志
    ,agt_dep_flg varchar2(10) -- 协议存款标志
    ,float_int_rat_flg varchar2(10) -- 浮动利率标志
    ,int_rat_float_way_cd varchar2(10) -- 利率浮动方式代码
    ,int_rat_adj_ped_corp_cd varchar2(10) -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq number(10) -- 利率调整周期频率
    ,rc_flg varchar2(10) -- 定活标志
    ,margin_flg varchar2(10) -- 保证金标志
    ,agree_dep_flg varchar2(10) -- 协定存款标志
    ,ibank_dep_flg varchar2(10) -- 同业存款标志
    ,dep_basic_acct_flg varchar2(10) -- 存款基本户标志
    ,ec_flg varchar2(10) -- 钞汇标志
    ,privavy_acct_flg varchar2(10) -- 隐私账户标志
    ,legal_acct_flg varchar2(10) -- 涉案账户标志
    ,auto_redt_flg varchar2(10) -- 自动转存标志
    ,redted_cnt varchar2(15) -- 已转存次数
    ,itg_dep_earliest_drawbl_dt date -- 智能存款最早可提支日期
    ,sleep_acct_flg varchar2(10) -- 睡眠户标志
    ,dormt_acct_flg varchar2(10) -- 不动户标志
    ,sal_acct_flg varchar2(10) -- 工资账户标志
    ,froz_flg varchar2(10) -- 冻结标志
    ,advd_draw_flg varchar2(10) -- 可提前支取标志
    ,tranbl_flg varchar2(10) -- 可转让标志
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,int_accr_flg varchar2(10) -- 计息标志
    ,int_set_way_cd varchar2(10) -- 结息方式代码
    ,int_accr_way_cd varchar2(10) -- 计息方式代码
    ,allow_od_flg varchar2(10) -- 允许透支标志
    ,curr_cd varchar2(10) -- 币种代码
    ,redt_way_cd varchar2(10) -- 转存方式代码
    ,open_acct_chn_type_cd varchar2(10) -- 开户渠道类型代码
    ,tran_chn_status_cd varchar2(10) -- 交易渠道状态代码
    ,open_acct_dt date -- 开户日期
    ,open_acct_tm timestamp -- 开户时间
    ,clos_acct_dt date -- 销户日期
    ,clos_acct_tm timestamp -- 销户时间
    ,actv_dt date -- 激活日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,final_activ_acct_dt date -- 最后动户日期
    ,agree_dep_value_dt date -- 协定存款起息日期
    ,agree_dep_exp_dt date -- 协定存款到期日期
    ,froz_dt date -- 冻结日期
    ,unfrz_dt date -- 解冻日期
    ,last_int_set_dt date -- 上次结息日期
    ,next_int_set_dt date -- 下次结息日期
    ,fir_value_dt date -- 首次起息日期
    ,agree_int_rat number(18,8) -- 协定利率
    ,base_rat_type_cd varchar2(10) -- 基准利率类型代码
    ,base_rat number(18,8) -- 基准利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,td_acru_int number(30,8) -- 当日应计利息
    ,currt_acru_int number(30,8) -- 当期应计利息
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,open_acct_teller_id varchar2(60) -- 开户柜员编号
    ,clos_acct_teller_id varchar2(60) -- 销户柜员编号
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,close_acct_org_id varchar2(60) -- 销户机构编号
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,loc_flg varchar2(10) -- 开立存款证实书标志
    ,expe_higt_yld_rat number(18,8) -- 预期最高收益率
    ,agree_dep_init_amt number(30,2) -- 协定存款起存金额
    ,open_acct_amt number(30,2) -- 开户金额
    ,currt_bal number(30,2) -- 当期余额
    ,aval_bal number(30,2) -- 可用余额
    ,froz_amt number(18,2) -- 冻结金额
    ,stop_pay_amt number(18,2) -- 止付金额
    ,cl_curr_currt_bal number(30,2) -- 折本币当期余额
    ,ear_d_bal number(30,2) -- 日初余额
    ,ear_m_bal number(30,2) -- 月初余额
    ,ear_s_bal number(30,2) -- 季初余额
    ,ear_y_bal number(30,2) -- 年初余额
    ,y_acm_bal number(30,2) -- 年累计余额
    ,s_acm_bal number(30,2) -- 季累计余额
    ,m_acm_bal number(30,2) -- 月累计余额
    ,cl_curr_ear_d_bal number(30,2) -- 折本币日初余额
    ,cl_curr_ear_m_bal number(30,2) -- 折本币月初余额
    ,cl_curr_ear_s_bal number(30,2) -- 折本币季初余额
    ,cl_curr_ear_y_bal number(30,2) -- 折本币年初余额
    ,cl_curr_y_acm_bal number(30,2) -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal number(30,2) -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal number(30,2) -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal number(30,2) -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal number(30,2) -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal number(30,2) -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal number(30,2) -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal number(30,2) -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal number(30,2) -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal number(30,2) -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal number(30,2) -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal number(30,2) -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal number(30,2) -- 折本币年初月累计余额
    ,cds_liab_acct_num varchar2(60) -- 负债账户编号
    ,corp_supv_acct_flg varchar2(10) -- 对公监管户标志
    ,y_avg_bal number(30,2) -- 年日均余额
    ,q_avg_bal number(30,2) -- 季日均余额
    ,m_avg_bal number(30,2) -- 月日均余额
    ,cl_curr_y_avg_bal number(30,2) -- 折本币年日均余额
    ,cl_curr_q_avg_bal number(30,2) -- 折本币季日均余额
    ,cl_curr_m_avg_bal number(30,2) -- 折本币月日均余额
    ,web_dep_flg varchar2(10) -- 网络存款标志
    ,bill_pool_margin_flg varchar2(10) -- 票据池保证金标志
    ,bill_pool_type_cd varchar2(10) -- 票据池类型代码
    ,old_acct_id varchar2(60) -- 旧账户编号
    ,int_paybl_subj_id varchar2(60) -- 应付利息科目编号
    ,int_paybl_adj_subj_id varchar2(60) -- 应付利息调整科目编号
    ,int_expns_subj_id varchar2(60) -- 利息支出科目编号
    ,int_expns_adj_subj_id varchar2(60) -- 利息支出调整科目编号
    ,open_flow_num varchar2(60) -- 开户流水号
    ,clos_flow_num varchar2(60) -- 销户流水号
    ,currt_int_paybl_adj number(30,8) -- 当期应付利息调整
    ,td_int_expns number(30,8) -- 当日利息支出
    ,td_int_expns_adj number(30,8) -- 当日利息支出调整
    ,long_hang_acct_flg varchar2(10) -- 久悬户标志
    ,acct_usage_cd varchar2(30) -- 账户用途代码
    ,agt_dep_earliest_drawbl_dt date -- 协议存款最早可提支日期
    ,lowt_bal number(30,2) -- 最低余额
    ,cash_flg varchar2(10) -- 取现标志
    ,cust_acct_card_no varchar2(60) -- 客户账户卡号
    ,dep_char_cd varchar2(10) -- 存款性质代码
    ,agree_dep_rels_dt date -- 协定存款解约日期
    ,mater_acct_flg varchar2(10) -- 母户标志
    ,delay_pay_int_flg varchar2(10) -- 延期付息标志
    ,delay_pay_int_days number(30,2) -- 延期付息天数
    ,old_cust_acct_sub_acct_num varchar2(10) -- 旧客户账户子户号
    ,dep_term_tenor_type_cd varchar2(10) -- 存期期限类型代码
    ,pd_id varchar2(60) -- 期次编号
    ,approval_id varchar2(100) -- 核准件编号
    ,general_exch_org_id varchar2(60) -- 通兑机构编号
    ,general_storage_flg varchar2(10) -- 通存标志
    ,vtual_acct_flg varchar2(10) -- 虚拟账户标志
    ,entry_flg varchar2(10) -- 记账标志
    ,turn_dormt_acct_dt date -- 转不动户日期
    ,over_term_exec_int_rat number(18,8) -- 超期执行利率
    ,final_tran_dt date -- 最后交易日期
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.cmm_dep_acct_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.cmm_dep_acct_info is '存款分户信息';
comment on column ${idl_schema}.cmm_dep_acct_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.cmm_dep_acct_info.lp_id is '法人编号';
comment on column ${idl_schema}.cmm_dep_acct_info.acct_id is '账户编号';
comment on column ${idl_schema}.cmm_dep_acct_info.acct_name is '账户名称';
comment on column ${idl_schema}.cmm_dep_acct_info.cust_acct_id is '客户账户编号';
comment on column ${idl_schema}.cmm_dep_acct_info.cust_acct_sub_acct_num is '客户账户子户号';
comment on column ${idl_schema}.cmm_dep_acct_info.cust_id is '客户编号';
comment on column ${idl_schema}.cmm_dep_acct_info.subj_id is '科目编号';
comment on column ${idl_schema}.cmm_dep_acct_info.dep_kind_cd is '储种代码';
comment on column ${idl_schema}.cmm_dep_acct_info.acct_cls_cd is '账户分类代码';
comment on column ${idl_schema}.cmm_dep_acct_info.acct_type_cd is '账户类型代码';
comment on column ${idl_schema}.cmm_dep_acct_info.acct_attr_cd is '账户属性代码';
comment on column ${idl_schema}.cmm_dep_acct_info.dep_term is '存期';
comment on column ${idl_schema}.cmm_dep_acct_info.std_prod_id is '标准产品编号';
comment on column ${idl_schema}.cmm_dep_acct_info.ext_prod_id is '外部产品编号';
comment on column ${idl_schema}.cmm_dep_acct_info.intnal_prod_id is '内部产品编号';
comment on column ${idl_schema}.cmm_dep_acct_info.open_oa_apv_form_num is '开户OA审批单号';
comment on column ${idl_schema}.cmm_dep_acct_info.dep_acct_status_cd is '存款账户状态代码';
comment on column ${idl_schema}.cmm_dep_acct_info.cust_type_cd is '客户类型代码';
comment on column ${idl_schema}.cmm_dep_acct_info.corp_acct_flg is '对公账户标志';
comment on column ${idl_schema}.cmm_dep_acct_info.stop_pay_status_cd is '止付状态代码';
comment on column ${idl_schema}.cmm_dep_acct_info.general_exch_flg is '通兑标志';
comment on column ${idl_schema}.cmm_dep_acct_info.advise_dep_flg is '通知存款标志';
comment on column ${idl_schema}.cmm_dep_acct_info.agt_dep_flg is '协议存款标志';
comment on column ${idl_schema}.cmm_dep_acct_info.float_int_rat_flg is '浮动利率标志';
comment on column ${idl_schema}.cmm_dep_acct_info.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${idl_schema}.cmm_dep_acct_info.int_rat_adj_ped_corp_cd is '利率调整周期单位代码';
comment on column ${idl_schema}.cmm_dep_acct_info.int_rat_adj_ped_freq is '利率调整周期频率';
comment on column ${idl_schema}.cmm_dep_acct_info.rc_flg is '定活标志';
comment on column ${idl_schema}.cmm_dep_acct_info.margin_flg is '保证金标志';
comment on column ${idl_schema}.cmm_dep_acct_info.agree_dep_flg is '协定存款标志';
comment on column ${idl_schema}.cmm_dep_acct_info.ibank_dep_flg is '同业存款标志';
comment on column ${idl_schema}.cmm_dep_acct_info.dep_basic_acct_flg is '存款基本户标志';
comment on column ${idl_schema}.cmm_dep_acct_info.ec_flg is '钞汇标志';
comment on column ${idl_schema}.cmm_dep_acct_info.privavy_acct_flg is '隐私账户标志';
comment on column ${idl_schema}.cmm_dep_acct_info.legal_acct_flg is '涉案账户标志';
comment on column ${idl_schema}.cmm_dep_acct_info.auto_redt_flg is '自动转存标志';
comment on column ${idl_schema}.cmm_dep_acct_info.redted_cnt is '已转存次数';
comment on column ${idl_schema}.cmm_dep_acct_info.itg_dep_earliest_drawbl_dt is '智能存款最早可提支日期';
comment on column ${idl_schema}.cmm_dep_acct_info.sleep_acct_flg is '睡眠户标志';
comment on column ${idl_schema}.cmm_dep_acct_info.dormt_acct_flg is '不动户标志';
comment on column ${idl_schema}.cmm_dep_acct_info.sal_acct_flg is '工资账户标志';
comment on column ${idl_schema}.cmm_dep_acct_info.froz_flg is '冻结标志';
comment on column ${idl_schema}.cmm_dep_acct_info.advd_draw_flg is '可提前支取标志';
comment on column ${idl_schema}.cmm_dep_acct_info.tranbl_flg is '可转让标志';
comment on column ${idl_schema}.cmm_dep_acct_info.int_accr_base_cd is '计息基准代码';
comment on column ${idl_schema}.cmm_dep_acct_info.int_accr_flg is '计息标志';
comment on column ${idl_schema}.cmm_dep_acct_info.int_set_way_cd is '结息方式代码';
comment on column ${idl_schema}.cmm_dep_acct_info.int_accr_way_cd is '计息方式代码';
comment on column ${idl_schema}.cmm_dep_acct_info.allow_od_flg is '允许透支标志';
comment on column ${idl_schema}.cmm_dep_acct_info.curr_cd is '币种代码';
comment on column ${idl_schema}.cmm_dep_acct_info.redt_way_cd is '转存方式代码';
comment on column ${idl_schema}.cmm_dep_acct_info.open_acct_chn_type_cd is '开户渠道类型代码';
comment on column ${idl_schema}.cmm_dep_acct_info.tran_chn_status_cd is '交易渠道状态代码';
comment on column ${idl_schema}.cmm_dep_acct_info.open_acct_dt is '开户日期';
comment on column ${idl_schema}.cmm_dep_acct_info.open_acct_tm is '开户时间';
comment on column ${idl_schema}.cmm_dep_acct_info.clos_acct_dt is '销户日期';
comment on column ${idl_schema}.cmm_dep_acct_info.clos_acct_tm is '销户时间';
comment on column ${idl_schema}.cmm_dep_acct_info.actv_dt is '激活日期';
comment on column ${idl_schema}.cmm_dep_acct_info.value_dt is '起息日期';
comment on column ${idl_schema}.cmm_dep_acct_info.exp_dt is '到期日期';
comment on column ${idl_schema}.cmm_dep_acct_info.final_activ_acct_dt is '最后动户日期';
comment on column ${idl_schema}.cmm_dep_acct_info.agree_dep_value_dt is '协定存款起息日期';
comment on column ${idl_schema}.cmm_dep_acct_info.agree_dep_exp_dt is '协定存款到期日期';
comment on column ${idl_schema}.cmm_dep_acct_info.froz_dt is '冻结日期';
comment on column ${idl_schema}.cmm_dep_acct_info.unfrz_dt is '解冻日期';
comment on column ${idl_schema}.cmm_dep_acct_info.last_int_set_dt is '上次结息日期';
comment on column ${idl_schema}.cmm_dep_acct_info.next_int_set_dt is '下次结息日期';
comment on column ${idl_schema}.cmm_dep_acct_info.fir_value_dt is '首次起息日期';
comment on column ${idl_schema}.cmm_dep_acct_info.agree_int_rat is '协定利率';
comment on column ${idl_schema}.cmm_dep_acct_info.base_rat_type_cd is '基准利率类型代码';
comment on column ${idl_schema}.cmm_dep_acct_info.base_rat is '基准利率';
comment on column ${idl_schema}.cmm_dep_acct_info.exec_int_rat is '执行利率';
comment on column ${idl_schema}.cmm_dep_acct_info.td_acru_int is '当日应计利息';
comment on column ${idl_schema}.cmm_dep_acct_info.currt_acru_int is '当期应计利息';
comment on column ${idl_schema}.cmm_dep_acct_info.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.cmm_dep_acct_info.open_acct_teller_id is '开户柜员编号';
comment on column ${idl_schema}.cmm_dep_acct_info.clos_acct_teller_id is '销户柜员编号';
comment on column ${idl_schema}.cmm_dep_acct_info.open_acct_org_id is '开户机构编号';
comment on column ${idl_schema}.cmm_dep_acct_info.close_acct_org_id is '销户机构编号';
comment on column ${idl_schema}.cmm_dep_acct_info.belong_org_id is '所属机构编号';
comment on column ${idl_schema}.cmm_dep_acct_info.loc_flg is '开立存款证实书标志';
comment on column ${idl_schema}.cmm_dep_acct_info.expe_higt_yld_rat is '预期最高收益率';
comment on column ${idl_schema}.cmm_dep_acct_info.agree_dep_init_amt is '协定存款起存金额';
comment on column ${idl_schema}.cmm_dep_acct_info.open_acct_amt is '开户金额';
comment on column ${idl_schema}.cmm_dep_acct_info.currt_bal is '当期余额';
comment on column ${idl_schema}.cmm_dep_acct_info.aval_bal is '可用余额';
comment on column ${idl_schema}.cmm_dep_acct_info.froz_amt is '冻结金额';
comment on column ${idl_schema}.cmm_dep_acct_info.stop_pay_amt is '止付金额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_currt_bal is '折本币当期余额';
comment on column ${idl_schema}.cmm_dep_acct_info.ear_d_bal is '日初余额';
comment on column ${idl_schema}.cmm_dep_acct_info.ear_m_bal is '月初余额';
comment on column ${idl_schema}.cmm_dep_acct_info.ear_s_bal is '季初余额';
comment on column ${idl_schema}.cmm_dep_acct_info.ear_y_bal is '年初余额';
comment on column ${idl_schema}.cmm_dep_acct_info.y_acm_bal is '年累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.s_acm_bal is '季累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.m_acm_bal is '月累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_d_bal is '折本币日初余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_m_bal is '折本币月初余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_s_bal is '折本币季初余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_y_bal is '折本币年初余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_y_acm_bal is '折本币年累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_d_y_acm_bal is '折本币日初年累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_m_y_acm_bal is '折本币月初年累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_s_y_acm_bal is '折本币季初年累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_y_y_acm_bal is '折本币年初年累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_s_acm_bal is '折本币季累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_d_s_acm_bal is '折本币日初季累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_s_s_acm_bal is '折本币季初季累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_y_s_acm_bal is '折本币年初季累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_m_acm_bal is '折本币月累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_d_m_acm_bal is '折本币日初月累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_m_m_acm_bal is '折本币月初月累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_ear_y_m_acm_bal is '折本币年初月累计余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cds_liab_acct_num is '负债账户编号';
comment on column ${idl_schema}.cmm_dep_acct_info.corp_supv_acct_flg is '对公监管户标志';
comment on column ${idl_schema}.cmm_dep_acct_info.y_avg_bal is '年日均余额';
comment on column ${idl_schema}.cmm_dep_acct_info.q_avg_bal is '季日均余额';
comment on column ${idl_schema}.cmm_dep_acct_info.m_avg_bal is '月日均余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_y_avg_bal is '折本币年日均余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_q_avg_bal is '折本币季日均余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cl_curr_m_avg_bal is '折本币月日均余额';
comment on column ${idl_schema}.cmm_dep_acct_info.web_dep_flg is '网络存款标志';
comment on column ${idl_schema}.cmm_dep_acct_info.bill_pool_margin_flg is '票据池保证金标志';
comment on column ${idl_schema}.cmm_dep_acct_info.bill_pool_type_cd is '票据池类型代码';
comment on column ${idl_schema}.cmm_dep_acct_info.old_acct_id is '旧账户编号';
comment on column ${idl_schema}.cmm_dep_acct_info.int_paybl_subj_id is '应付利息科目编号';
comment on column ${idl_schema}.cmm_dep_acct_info.int_paybl_adj_subj_id is '应付利息调整科目编号';
comment on column ${idl_schema}.cmm_dep_acct_info.int_expns_subj_id is '利息支出科目编号';
comment on column ${idl_schema}.cmm_dep_acct_info.int_expns_adj_subj_id is '利息支出调整科目编号';
comment on column ${idl_schema}.cmm_dep_acct_info.open_flow_num is '开户流水号';
comment on column ${idl_schema}.cmm_dep_acct_info.clos_flow_num is '销户流水号';
comment on column ${idl_schema}.cmm_dep_acct_info.currt_int_paybl_adj is '当期应付利息调整';
comment on column ${idl_schema}.cmm_dep_acct_info.td_int_expns is '当日利息支出';
comment on column ${idl_schema}.cmm_dep_acct_info.td_int_expns_adj is '当日利息支出调整';
comment on column ${idl_schema}.cmm_dep_acct_info.long_hang_acct_flg is '久悬户标志';
comment on column ${idl_schema}.cmm_dep_acct_info.acct_usage_cd is '账户用途代码';
comment on column ${idl_schema}.cmm_dep_acct_info.agt_dep_earliest_drawbl_dt is '协议存款最早可提支日期';
comment on column ${idl_schema}.cmm_dep_acct_info.lowt_bal is '最低余额';
comment on column ${idl_schema}.cmm_dep_acct_info.cash_flg is '取现标志';
comment on column ${idl_schema}.cmm_dep_acct_info.cust_acct_card_no is '客户账户卡号';
comment on column ${idl_schema}.cmm_dep_acct_info.dep_char_cd is '存款性质代码';
comment on column ${idl_schema}.cmm_dep_acct_info.agree_dep_rels_dt is '协定存款解约日期';
comment on column ${idl_schema}.cmm_dep_acct_info.mater_acct_flg is '母户标志';
comment on column ${idl_schema}.cmm_dep_acct_info.delay_pay_int_flg is '延期付息标志';
comment on column ${idl_schema}.cmm_dep_acct_info.delay_pay_int_days is '延期付息天数';
comment on column ${idl_schema}.cmm_dep_acct_info.old_cust_acct_sub_acct_num is '旧客户账户子户号';
comment on column ${idl_schema}.cmm_dep_acct_info.dep_term_tenor_type_cd is '存期期限类型代码';
comment on column ${idl_schema}.cmm_dep_acct_info.pd_id is '期次编号';
comment on column ${idl_schema}.cmm_dep_acct_info.approval_id is '核准件编号';
comment on column ${idl_schema}.cmm_dep_acct_info.general_exch_org_id is '通兑机构编号';
comment on column ${idl_schema}.cmm_dep_acct_info.general_storage_flg is '通存标志';
comment on column ${idl_schema}.cmm_dep_acct_info.vtual_acct_flg is '虚拟账户标志';
comment on column ${idl_schema}.cmm_dep_acct_info.entry_flg is '记账标志';
comment on column ${idl_schema}.cmm_dep_acct_info.turn_dormt_acct_dt is '转不动户日期';
comment on column ${idl_schema}.cmm_dep_acct_info.over_term_exec_int_rat is '超期执行利率';
comment on column ${idl_schema}.cmm_dep_acct_info.final_tran_dt is '最后交易日期';
comment on column ${idl_schema}.cmm_dep_acct_info.job_cd is '任务代码';
comment on column ${idl_schema}.cmm_dep_acct_info.etl_timestamp is 'ETL处理时间戳';