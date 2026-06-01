/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl cmm_dep_acct_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.cmm_dep_acct_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.cmm_dep_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.cmm_dep_acct_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,lp_id  -- 法人编号
    ,acct_id  -- 账户编号
    ,acct_name  -- 账户名称
    ,cust_acct_id  -- 客户账户编号
    ,cust_acct_sub_acct_num  -- 客户账户子户号
    ,cust_id  -- 客户编号
    ,subj_id  -- 科目编号
    ,dep_kind_cd  -- 储种代码
    ,acct_cls_cd  -- 账户分类代码
    ,acct_type_cd  -- 账户类型代码
    ,acct_attr_cd  -- 账户属性代码
    ,dep_term  -- 存期
    ,std_prod_id  -- 标准产品编号
    ,ext_prod_id  -- 外部产品编号
    ,intnal_prod_id  -- 内部产品编号
    ,open_oa_apv_form_num  -- 开户OA审批单号
    ,dep_acct_status_cd  -- 存款账户状态代码
    ,cust_type_cd  -- 客户类型代码
    ,corp_acct_flg  -- 对公账户标志
    ,stop_pay_status_cd  -- 止付状态代码
    ,general_exch_flg  -- 通兑标志
    ,advise_dep_flg  -- 通知存款标志
    ,agt_dep_flg  -- 协议存款标志
    ,float_int_rat_flg  -- 浮动利率标志
    ,int_rat_float_way_cd  -- 利率浮动方式代码
    ,int_rat_adj_ped_corp_cd  -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq  -- 利率调整周期频率
    ,rc_flg  -- 定活标志
    ,margin_flg  -- 保证金标志
    ,agree_dep_flg  -- 协定存款标志
    ,ibank_dep_flg  -- 同业存款标志
    ,dep_basic_acct_flg  -- 存款基本户标志
    ,ec_flg  -- 钞汇标志
    ,privavy_acct_flg  -- 隐私账户标志
    ,legal_acct_flg  -- 涉案账户标志
    ,auto_redt_flg  -- 自动转存标志
    ,redted_cnt  -- 已转存次数
    ,itg_dep_earliest_drawbl_dt  -- 智能存款最早可提支日期
    ,sleep_acct_flg  -- 睡眠户标志
    ,dormt_acct_flg  -- 不动户标志
    ,sal_acct_flg  -- 工资账户标志
    ,froz_flg  -- 冻结标志
    ,advd_draw_flg  -- 可提前支取标志
    ,tranbl_flg  -- 可转让标志
    ,int_accr_base_cd  -- 计息基准代码
    ,int_accr_flg  -- 计息标志
    ,int_set_way_cd  -- 结息方式代码
    ,int_accr_way_cd  -- 计息方式代码
    ,allow_od_flg  -- 允许透支标志
    ,curr_cd  -- 币种代码
    ,redt_way_cd  -- 转存方式代码
    ,open_acct_chn_type_cd  -- 开户渠道类型代码
    ,tran_chn_status_cd  -- 交易渠道状态代码
    ,open_acct_dt  -- 开户日期
    ,open_acct_tm  -- 开户时间
    ,clos_acct_dt  -- 销户日期
    ,clos_acct_tm  -- 销户时间
    ,actv_dt  -- 激活日期
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,final_activ_acct_dt  -- 最后动户日期
    ,agree_dep_value_dt  -- 协定存款起息日期
    ,agree_dep_exp_dt  -- 协定存款到期日期
    ,froz_dt  -- 冻结日期
    ,unfrz_dt  -- 解冻日期
    ,last_int_set_dt  -- 上次结息日期
    ,next_int_set_dt  -- 下次结息日期
    ,fir_value_dt  -- 首次起息日期
    ,agree_int_rat  -- 协定利率
    ,base_rat_type_cd  -- 基准利率类型代码
    ,base_rat  -- 基准利率
    ,exec_int_rat  -- 执行利率
    ,td_acru_int  -- 当日应计利息
    ,currt_acru_int  -- 当期应计利息
    ,cust_mgr_id  -- 客户经理编号
    ,open_acct_teller_id  -- 开户柜员编号
    ,clos_acct_teller_id  -- 销户柜员编号
    ,open_acct_org_id  -- 开户机构编号
    ,close_acct_org_id  -- 销户机构编号
    ,belong_org_id  -- 所属机构编号
    ,loc_flg  -- 开立存款证实书标志
    ,expe_higt_yld_rat  -- 预期最高收益率
    ,agree_dep_init_amt  -- 协定存款起存金额
    ,open_acct_amt  -- 开户金额
    ,currt_bal  -- 当期余额
    ,aval_bal  -- 可用余额
    ,froz_amt  -- 冻结金额
    ,stop_pay_amt  -- 止付金额
    ,cl_curr_currt_bal  -- 折本币当期余额
    ,ear_d_bal  -- 日初余额
    ,ear_m_bal  -- 月初余额
    ,ear_s_bal  -- 季初余额
    ,ear_y_bal  -- 年初余额
    ,y_acm_bal  -- 年累计余额
    ,s_acm_bal  -- 季累计余额
    ,m_acm_bal  -- 月累计余额
    ,cl_curr_ear_d_bal  -- 折本币日初余额
    ,cl_curr_ear_m_bal  -- 折本币月初余额
    ,cl_curr_ear_s_bal  -- 折本币季初余额
    ,cl_curr_ear_y_bal  -- 折本币年初余额
    ,cl_curr_y_acm_bal  -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal  -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal  -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
    ,cds_liab_acct_num  -- 负债账户编号
    ,corp_supv_acct_flg  -- 对公监管户标志
    ,y_avg_bal  -- 年日均余额
    ,q_avg_bal  -- 季日均余额
    ,m_avg_bal  -- 月日均余额
    ,cl_curr_y_avg_bal  -- 折本币年日均余额
    ,cl_curr_q_avg_bal  -- 折本币季日均余额
    ,cl_curr_m_avg_bal  -- 折本币月日均余额
    ,web_dep_flg  -- 网络存款标志
    ,bill_pool_margin_flg  -- 票据池保证金标志
    ,bill_pool_type_cd  -- 票据池类型代码
    ,old_acct_id  -- 旧账户编号
    ,int_paybl_subj_id  -- 应付利息科目编号
    ,int_paybl_adj_subj_id  -- 应付利息调整科目编号
    ,int_expns_subj_id  -- 利息支出科目编号
    ,int_expns_adj_subj_id  -- 利息支出调整科目编号
    ,open_flow_num  -- 开户流水号
    ,clos_flow_num  -- 销户流水号
    ,currt_int_paybl_adj  -- 当期应付利息调整
    ,td_int_expns  -- 当日利息支出
    ,td_int_expns_adj  -- 当日利息支出调整
    ,long_hang_acct_flg  -- 久悬户标志
    ,acct_usage_cd  -- 账户用途代码
    ,agt_dep_earliest_drawbl_dt  -- 协议存款最早可提支日期
    ,lowt_bal  -- 最低余额
    ,cash_flg  -- 取现标志
    ,cust_acct_card_no  -- 客户账户卡号
    ,dep_char_cd  -- 存款性质代码
    ,agree_dep_rels_dt  -- 协定存款解约日期
    ,mater_acct_flg  -- 母户标志
    ,delay_pay_int_flg  -- 延期付息标志
    ,delay_pay_int_days  -- 延期付息天数
    ,old_cust_acct_sub_acct_num  -- 旧客户账户子户号
    ,dep_term_tenor_type_cd  -- 存期期限类型代码
    ,pd_id  -- 期次编号
    ,approval_id  -- 核准件编号
    ,general_exch_org_id  -- 通兑机构编号
    ,general_storage_flg  -- 通存标志
    ,vtual_acct_flg  -- 虚拟账户标志
    ,entry_flg  -- 记账标志
    ,turn_dormt_acct_dt  -- 转不动户日期
    ,over_term_exec_int_rat  -- 超期执行利率
    ,final_tran_dt  -- 最后交易日期
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- ETL处理日期
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id  -- 法人编号
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id  -- 账户编号
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name  -- 账户名称
    ,replace(replace(t.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id  -- 客户账户编号
    ,replace(replace(t.cust_acct_sub_acct_num,chr(13),''),chr(10),'') as cust_acct_sub_acct_num  -- 客户账户子户号
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id  -- 客户编号
    ,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id  -- 科目编号
    ,replace(replace(t.dep_kind_cd,chr(13),''),chr(10),'') as dep_kind_cd  -- 储种代码
    ,replace(replace(t.acct_cls_cd,chr(13),''),chr(10),'') as acct_cls_cd  -- 账户分类代码
    ,replace(replace(t.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd  -- 账户类型代码
    ,replace(replace(t.acct_attr_cd,chr(13),''),chr(10),'') as acct_attr_cd  -- 账户属性代码
    ,replace(replace(t.dep_term,chr(13),''),chr(10),'') as dep_term  -- 存期
    ,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id  -- 标准产品编号
    ,replace(replace(t.ext_prod_id,chr(13),''),chr(10),'') as ext_prod_id  -- 外部产品编号
    ,replace(replace(t.intnal_prod_id,chr(13),''),chr(10),'') as intnal_prod_id  -- 内部产品编号
    ,replace(replace(t.open_oa_apv_form_num,chr(13),''),chr(10),'') as open_oa_apv_form_num  -- 开户OA审批单号
    ,replace(replace(t.dep_acct_status_cd,chr(13),''),chr(10),'') as dep_acct_status_cd  -- 存款账户状态代码
    ,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd  -- 客户类型代码
    ,replace(replace(t.corp_acct_flg,chr(13),''),chr(10),'') as corp_acct_flg  -- 对公账户标志
    ,replace(replace(t.stop_pay_status_cd,chr(13),''),chr(10),'') as stop_pay_status_cd  -- 止付状态代码
    ,replace(replace(t.general_exch_flg,chr(13),''),chr(10),'') as general_exch_flg  -- 通兑标志
    ,replace(replace(t.advise_dep_flg,chr(13),''),chr(10),'') as advise_dep_flg  -- 通知存款标志
    ,replace(replace(t.agt_dep_flg,chr(13),''),chr(10),'') as agt_dep_flg  -- 协议存款标志
    ,replace(replace(t.float_int_rat_flg,chr(13),''),chr(10),'') as float_int_rat_flg  -- 浮动利率标志
    ,replace(replace(t.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd  -- 利率浮动方式代码
    ,replace(replace(t.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd  -- 利率调整周期单位代码
    ,t.int_rat_adj_ped_freq as int_rat_adj_ped_freq  -- 利率调整周期频率
    ,replace(replace(t.rc_flg,chr(13),''),chr(10),'') as rc_flg  -- 定活标志
    ,replace(replace(t.margin_flg,chr(13),''),chr(10),'') as margin_flg  -- 保证金标志
    ,replace(replace(t.agree_dep_flg,chr(13),''),chr(10),'') as agree_dep_flg  -- 协定存款标志
    ,replace(replace(t.ibank_dep_flg,chr(13),''),chr(10),'') as ibank_dep_flg  -- 同业存款标志
    ,replace(replace(t.dep_basic_acct_flg,chr(13),''),chr(10),'') as dep_basic_acct_flg  -- 存款基本户标志
    ,replace(replace(t.ec_flg,chr(13),''),chr(10),'') as ec_flg  -- 钞汇标志
    ,replace(replace(t.privavy_acct_flg,chr(13),''),chr(10),'') as privavy_acct_flg  -- 隐私账户标志
    ,replace(replace(t.legal_acct_flg,chr(13),''),chr(10),'') as legal_acct_flg  -- 涉案账户标志
    ,replace(replace(t.auto_redt_flg,chr(13),''),chr(10),'') as auto_redt_flg  -- 自动转存标志
    ,replace(replace(t.redted_cnt,chr(13),''),chr(10),'') as redted_cnt  -- 已转存次数
    ,t.itg_dep_earliest_drawbl_dt as itg_dep_earliest_drawbl_dt  -- 智能存款最早可提支日期
    ,replace(replace(t.sleep_acct_flg,chr(13),''),chr(10),'') as sleep_acct_flg  -- 睡眠户标志
    ,replace(replace(t.dormt_acct_flg,chr(13),''),chr(10),'') as dormt_acct_flg  -- 不动户标志
    ,replace(replace(t.sal_acct_flg,chr(13),''),chr(10),'') as sal_acct_flg  -- 工资账户标志
    ,replace(replace(t.froz_flg,chr(13),''),chr(10),'') as froz_flg  -- 冻结标志
    ,replace(replace(t.advd_draw_flg,chr(13),''),chr(10),'') as advd_draw_flg  -- 可提前支取标志
    ,replace(replace(t.tranbl_flg,chr(13),''),chr(10),'') as tranbl_flg  -- 可转让标志
    ,replace(replace(t.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd  -- 计息基准代码
    ,replace(replace(t.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg  -- 计息标志
    ,replace(replace(t.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd  -- 结息方式代码
    ,replace(replace(t.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd  -- 计息方式代码
    ,replace(replace(t.allow_od_flg,chr(13),''),chr(10),'') as allow_od_flg  -- 允许透支标志
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd  -- 币种代码
    ,replace(replace(t.redt_way_cd,chr(13),''),chr(10),'') as redt_way_cd  -- 转存方式代码
    ,replace(replace(t.open_acct_chn_type_cd,chr(13),''),chr(10),'') as open_acct_chn_type_cd  -- 开户渠道类型代码
    ,replace(replace(t.tran_chn_status_cd,chr(13),''),chr(10),'') as tran_chn_status_cd  -- 交易渠道状态代码
    ,t.open_acct_dt as open_acct_dt  -- 开户日期
    ,t.open_acct_tm as open_acct_tm  -- 开户时间
    ,t.clos_acct_dt as clos_acct_dt  -- 销户日期
    ,t.clos_acct_tm as clos_acct_tm  -- 销户时间
    ,t.actv_dt as actv_dt  -- 激活日期
    ,t.value_dt as value_dt  -- 起息日期
    ,t.exp_dt as exp_dt  -- 到期日期
    ,t.final_activ_acct_dt as final_activ_acct_dt  -- 最后动户日期
    ,t.agree_dep_value_dt as agree_dep_value_dt  -- 协定存款起息日期
    ,t.agree_dep_exp_dt as agree_dep_exp_dt  -- 协定存款到期日期
    ,t.froz_dt as froz_dt  -- 冻结日期
    ,t.unfrz_dt as unfrz_dt  -- 解冻日期
    ,t.last_int_set_dt as last_int_set_dt  -- 上次结息日期
    ,t.next_int_set_dt as next_int_set_dt  -- 下次结息日期
    ,t.fir_value_dt as fir_value_dt  -- 首次起息日期
    ,t.agree_int_rat as agree_int_rat  -- 协定利率
    ,replace(replace(t.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd  -- 基准利率类型代码
    ,t.base_rat as base_rat  -- 基准利率
    ,t.exec_int_rat as exec_int_rat  -- 执行利率
    ,t.td_acru_int as td_acru_int  -- 当日应计利息
    ,t.currt_acru_int as currt_acru_int  -- 当期应计利息
    ,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id  -- 客户经理编号
    ,replace(replace(t.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id  -- 开户柜员编号
    ,replace(replace(t.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id  -- 销户柜员编号
    ,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id  -- 开户机构编号
    ,replace(replace(t.close_acct_org_id,chr(13),''),chr(10),'') as close_acct_org_id  -- 销户机构编号
    ,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id  -- 所属机构编号
    ,replace(replace(t.loc_flg,chr(13),''),chr(10),'') as loc_flg  -- 开立存款证实书标志
    ,t.expe_higt_yld_rat as expe_higt_yld_rat  -- 预期最高收益率
    ,t.agree_dep_init_amt as agree_dep_init_amt  -- 协定存款起存金额
    ,t.open_acct_amt as open_acct_amt  -- 开户金额
    ,t.currt_bal as currt_bal  -- 当期余额
    ,t.aval_bal as aval_bal  -- 可用余额
    ,t.froz_amt as froz_amt  -- 冻结金额
    ,t.stop_pay_amt as stop_pay_amt  -- 止付金额
    ,t.cl_curr_currt_bal as cl_curr_currt_bal  -- 折本币当期余额
    ,t.ear_d_bal as ear_d_bal  -- 日初余额
    ,t.ear_m_bal as ear_m_bal  -- 月初余额
    ,t.ear_s_bal as ear_s_bal  -- 季初余额
    ,t.ear_y_bal as ear_y_bal  -- 年初余额
    ,t.y_acm_bal as y_acm_bal  -- 年累计余额
    ,t.s_acm_bal as s_acm_bal  -- 季累计余额
    ,t.m_acm_bal as m_acm_bal  -- 月累计余额
    ,t.cl_curr_ear_d_bal as cl_curr_ear_d_bal  -- 折本币日初余额
    ,t.cl_curr_ear_m_bal as cl_curr_ear_m_bal  -- 折本币月初余额
    ,t.cl_curr_ear_s_bal as cl_curr_ear_s_bal  -- 折本币季初余额
    ,t.cl_curr_ear_y_bal as cl_curr_ear_y_bal  -- 折本币年初余额
    ,t.cl_curr_y_acm_bal as cl_curr_y_acm_bal  -- 折本币年累计余额
    ,t.cl_curr_ear_d_y_acm_bal as cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
    ,t.cl_curr_ear_m_y_acm_bal as cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
    ,t.cl_curr_ear_s_y_acm_bal as cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
    ,t.cl_curr_ear_y_y_acm_bal as cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
    ,t.cl_curr_s_acm_bal as cl_curr_s_acm_bal  -- 折本币季累计余额
    ,t.cl_curr_ear_d_s_acm_bal as cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
    ,t.cl_curr_ear_s_s_acm_bal as cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
    ,t.cl_curr_ear_y_s_acm_bal as cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
    ,t.cl_curr_m_acm_bal as cl_curr_m_acm_bal  -- 折本币月累计余额
    ,t.cl_curr_ear_d_m_acm_bal as cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
    ,t.cl_curr_ear_m_m_acm_bal as cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
    ,t.cl_curr_ear_y_m_acm_bal as cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
    ,replace(replace(t.cds_liab_acct_num,chr(13),''),chr(10),'') as cds_liab_acct_num  -- 负债账户编号
    ,replace(replace(t.corp_supv_acct_flg,chr(13),''),chr(10),'') as corp_supv_acct_flg  -- 对公监管户标志
    ,t.y_avg_bal as y_avg_bal  -- 年日均余额
    ,t.q_avg_bal as q_avg_bal  -- 季日均余额
    ,t.m_avg_bal as m_avg_bal  -- 月日均余额
    ,t.cl_curr_y_avg_bal as cl_curr_y_avg_bal  -- 折本币年日均余额
    ,t.cl_curr_q_avg_bal as cl_curr_q_avg_bal  -- 折本币季日均余额
    ,t.cl_curr_m_avg_bal as cl_curr_m_avg_bal  -- 折本币月日均余额
    ,replace(replace(t.web_dep_flg,chr(13),''),chr(10),'') as web_dep_flg  -- 网络存款标志
    ,replace(replace(t.bill_pool_margin_flg,chr(13),''),chr(10),'') as bill_pool_margin_flg  -- 票据池保证金标志
    ,replace(replace(t.bill_pool_type_cd,chr(13),''),chr(10),'') as bill_pool_type_cd  -- 票据池类型代码
    ,replace(replace(t.old_acct_id,chr(13),''),chr(10),'') as old_acct_id  -- 旧账户编号
    ,replace(replace(t.int_paybl_subj_id,chr(13),''),chr(10),'') as int_paybl_subj_id  -- 应付利息科目编号
    ,replace(replace(t.int_paybl_adj_subj_id,chr(13),''),chr(10),'') as int_paybl_adj_subj_id  -- 应付利息调整科目编号
    ,replace(replace(t.int_expns_subj_id,chr(13),''),chr(10),'') as int_expns_subj_id  -- 利息支出科目编号
    ,replace(replace(t.int_expns_adj_subj_id,chr(13),''),chr(10),'') as int_expns_adj_subj_id  -- 利息支出调整科目编号
    ,replace(replace(t.open_flow_num,chr(13),''),chr(10),'') as open_flow_num  -- 开户流水号
    ,replace(replace(t.clos_flow_num,chr(13),''),chr(10),'') as clos_flow_num  -- 销户流水号
    ,t.currt_int_paybl_adj as currt_int_paybl_adj  -- 当期应付利息调整
    ,t.td_int_expns as td_int_expns  -- 当日利息支出
    ,t.td_int_expns_adj as td_int_expns_adj  -- 当日利息支出调整
    ,replace(replace(t.long_hang_acct_flg,chr(13),''),chr(10),'') as long_hang_acct_flg  -- 久悬户标志
    ,replace(replace(t.acct_usage_cd,chr(13),''),chr(10),'') as acct_usage_cd  -- 账户用途代码
    ,t.agt_dep_earliest_drawbl_dt as agt_dep_earliest_drawbl_dt  -- 协议存款最早可提支日期
    ,t.lowt_bal as lowt_bal  -- 最低余额
    ,replace(replace(t.cash_flg,chr(13),''),chr(10),'') as cash_flg  -- 取现标志
    ,replace(replace(t.cust_acct_card_no,chr(13),''),chr(10),'') as cust_acct_card_no  -- 客户账户卡号
    ,replace(replace(t.dep_char_cd,chr(13),''),chr(10),'') as dep_char_cd  -- 存款性质代码
    ,t.agree_dep_rels_dt as agree_dep_rels_dt  -- 协定存款解约日期
    ,replace(replace(t.mater_acct_flg,chr(13),''),chr(10),'') as mater_acct_flg  -- 母户标志
    ,replace(replace(t.delay_pay_int_flg,chr(13),''),chr(10),'') as delay_pay_int_flg  -- 延期付息标志
    ,t.delay_pay_int_days as delay_pay_int_days  -- 延期付息天数
    ,replace(replace(t.old_cust_acct_sub_acct_num,chr(13),''),chr(10),'') as old_cust_acct_sub_acct_num  -- 旧客户账户子户号
    ,replace(replace(t.dep_term_tenor_type_cd,chr(13),''),chr(10),'') as dep_term_tenor_type_cd  -- 存期期限类型代码
    ,replace(replace(t.pd_id,chr(13),''),chr(10),'') as pd_id  -- 期次编号
    ,replace(replace(t.approval_id,chr(13),''),chr(10),'') as approval_id  -- 核准件编号
    ,replace(replace(t.general_exch_org_id,chr(13),''),chr(10),'') as general_exch_org_id  -- 通兑机构编号
    ,replace(replace(t.general_storage_flg,chr(13),''),chr(10),'') as general_storage_flg  -- 通存标志
    ,replace(replace(t.vtual_acct_flg,chr(13),''),chr(10),'') as vtual_acct_flg  -- 虚拟账户标志
    ,replace(replace(t.entry_flg,chr(13),''),chr(10),'') as entry_flg  -- 记账标志
    ,t.turn_dormt_acct_dt as turn_dormt_acct_dt  -- 转不动户日期
    ,t.over_term_exec_int_rat as over_term_exec_int_rat  -- 超期执行利率
    ,t.final_tran_dt as final_tran_dt  -- 最后交易日期
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 时间戳
 from ${icl_schema}.cmm_dep_acct_info t--存款分户信息
where t.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.cmm_dep_acct_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'cmm_dep_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);