/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_appl_mini_loan_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h(
    appl_id varchar2(100) -- 申请编号
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,adv_repay_applit_name varchar2(500) -- 提前还款申请人名称
    ,fst_estate_avg number(30,2) -- 第一房产均价
    ,secd_estate_avg number(30,2) -- 第二房产均价
    ,fst_estate_cert_num varchar2(100) -- 第一房产证号
    ,secd_estate_cert_num varchar2(100) -- 第二房产证号
    ,fst_estate_cert_addr_dist_cd varchar2(30) -- 第一房产证地址区划代码
    ,secd_estate_cert_addr_dist_cd varchar2(30) -- 第二房产证地址区划代码
    ,fst_estate_area number(30,2) -- 第一房产面积
    ,secd_estate_area number(30,2) -- 第二房产面积
    ,fst_estate_mtg_flg varchar2(10) -- 第一房产抵押标志
    ,secd_estate_mtg_flg varchar2(10) -- 第二房产抵押标志
    ,fst_estate_cert_dtl_addr varchar2(500) -- 第一房产证详细地址
    ,secd_estate_cert_dtl_addr varchar2(500) -- 第二房产证详细地址
    ,fst_estate_house_char_cd varchar2(30) -- 第一房产房屋性质代码
    ,secd_estate_house_char_cd varchar2(30) -- 第二房产房屋性质代码
    ,fst_estate_own_prop_number number(10) -- 第一房产共有产权人数
    ,secd_estate_own_prop_number number(10) -- 第二房产共有产权人数
    ,fst_estate_brwer_prop_lot number(30,2) -- 第一房产借款人产权份额
    ,secd_estate_brwer_prop_lot number(30,2) -- 第二房产借款人产权份额
    ,indv_loan_comm_fee_rat number(18,6) -- 个人贷款手续费率
    ,comm_fee_mode_pay_cd varchar2(30) -- 手续费支付方式代码
    ,promis_fee_rat number(18,6) -- 承诺费率
    ,distr_mode_pay_cd varchar2(30) -- 放款支付方式代码
    ,guar_inten_cd varchar2(30) -- 担保意向代码
    ,recv_bank_name varchar2(500) -- 收款行名称
    ,recv_bank_no varchar2(100) -- 收款行行号
    ,secd_repay_acct_name varchar2(500) -- 第二还款账户名称
    ,secd_repay_acct_id varchar2(100) -- 第二还款账户编号
    ,major_guartor_name varchar2(500) -- 主要担保人名称
    ,major_guartor_id varchar2(100) -- 主要担保人编号
    ,entr_pay_acct_name varchar2(500) -- 受托支付账户名称
    ,entr_pay_acct_id varchar2(100) -- 受托支付账户编号
    ,init_loan_amt number(30,2) -- 原贷款金额
    ,loan_usage_tran_amt number(30,2) -- 贷款用途交易金额
    ,loan_deduct_way_cd varchar2(30) -- 贷款扣款方式代码
    ,loan_int_set_way_cd varchar2(30) -- 贷款结息方式代码
    ,enter_acct_org_id varchar2(100) -- 入账机构编号
    ,first_trial_teller_id varchar2(100) -- 初审柜员编号
    ,occu_lmt number(30,2) -- 已占用额度
    ,resv_pric number(30,2) -- 保留本金
    ,occu_margin_amt number(30,2) -- 已占用保证金金额
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,latest_apv_amt number(30,2) -- 最新审批金额
    ,stud_loan_deflt_prod_id varchar2(100) -- 助贷默认产品编号
    ,modif_prod_id_flg varchar2(10) -- 变更产品编号标志
    ,ky_l_flg varchar2(10) -- 快易贷标志
    ,lmt_cont_id varchar2(100) -- 额度合同编号
    ,apv_lev_cd varchar2(30) -- 审批级别代码
    ,force_manu_apv_flg varchar2(10) -- 强制人工审批标志
    ,camp_chn_id varchar2(100) -- 营销渠道编号
    ,camp_corp_id varchar2(100) -- 营销单位编号
    ,init_withhold_mgmt_fee_sign_flg varchar2(10) -- 发起代扣管理费签约标志
    ,guar_corp_id varchar2(100) -- 担保公司编号
    ,intror_id varchar2(100) -- 介绍人编号
    ,guar_corp_occu_lmt number(30,2) -- 担保公司已占用额度
    ,camp_corp_name varchar2(1000) -- 营销单位名称
    ,camp_chn_name varchar2(1000) -- 营销渠道名称
    ,recvbl_open_acct_org_id varchar2(100) -- 收款开户机构编号
    ,loan_usage_descb varchar2(2000) -- 贷款用途描述
    ,loan_prop_id varchar2(100) -- 贷款方案编号
    ,sign_org_id varchar2(100) -- 签约机构编号
    ,prtcpt_deduct_flg varchar2(10) -- 参与批扣标志
    ,repay_comnt varchar2(500) -- 还款说明
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
grant select on ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h is '贷款申请微贷附属信息历史';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.adv_repay_applit_name is '提前还款申请人名称';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.fst_estate_avg is '第一房产均价';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.secd_estate_avg is '第二房产均价';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.fst_estate_cert_num is '第一房产证号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.secd_estate_cert_num is '第二房产证号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.fst_estate_cert_addr_dist_cd is '第一房产证地址区划代码';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.secd_estate_cert_addr_dist_cd is '第二房产证地址区划代码';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.fst_estate_area is '第一房产面积';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.secd_estate_area is '第二房产面积';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.fst_estate_mtg_flg is '第一房产抵押标志';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.secd_estate_mtg_flg is '第二房产抵押标志';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.fst_estate_cert_dtl_addr is '第一房产证详细地址';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.secd_estate_cert_dtl_addr is '第二房产证详细地址';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.fst_estate_house_char_cd is '第一房产房屋性质代码';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.secd_estate_house_char_cd is '第二房产房屋性质代码';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.fst_estate_own_prop_number is '第一房产共有产权人数';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.secd_estate_own_prop_number is '第二房产共有产权人数';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.fst_estate_brwer_prop_lot is '第一房产借款人产权份额';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.secd_estate_brwer_prop_lot is '第二房产借款人产权份额';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.indv_loan_comm_fee_rat is '个人贷款手续费率';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.comm_fee_mode_pay_cd is '手续费支付方式代码';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.promis_fee_rat is '承诺费率';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.distr_mode_pay_cd is '放款支付方式代码';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.guar_inten_cd is '担保意向代码';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.recv_bank_name is '收款行名称';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.recv_bank_no is '收款行行号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.secd_repay_acct_name is '第二还款账户名称';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.secd_repay_acct_id is '第二还款账户编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.major_guartor_name is '主要担保人名称';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.major_guartor_id is '主要担保人编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.entr_pay_acct_name is '受托支付账户名称';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.entr_pay_acct_id is '受托支付账户编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.init_loan_amt is '原贷款金额';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.loan_usage_tran_amt is '贷款用途交易金额';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.loan_deduct_way_cd is '贷款扣款方式代码';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.loan_int_set_way_cd is '贷款结息方式代码';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.enter_acct_org_id is '入账机构编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.first_trial_teller_id is '初审柜员编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.occu_lmt is '已占用额度';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.resv_pric is '保留本金';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.occu_margin_amt is '已占用保证金金额';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.comm_fee_amt is '手续费金额';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.latest_apv_amt is '最新审批金额';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.stud_loan_deflt_prod_id is '助贷默认产品编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.modif_prod_id_flg is '变更产品编号标志';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.ky_l_flg is '快易贷标志';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.lmt_cont_id is '额度合同编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.apv_lev_cd is '审批级别代码';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.force_manu_apv_flg is '强制人工审批标志';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.camp_chn_id is '营销渠道编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.camp_corp_id is '营销单位编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.init_withhold_mgmt_fee_sign_flg is '发起代扣管理费签约标志';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.guar_corp_id is '担保公司编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.intror_id is '介绍人编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.guar_corp_occu_lmt is '担保公司已占用额度';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.camp_corp_name is '营销单位名称';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.camp_chn_name is '营销渠道名称';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.recvbl_open_acct_org_id is '收款开户机构编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.loan_usage_descb is '贷款用途描述';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.loan_prop_id is '贷款方案编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.sign_org_id is '签约机构编号';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.prtcpt_deduct_flg is '参与批扣标志';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.repay_comnt is '还款说明';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h.etl_timestamp is 'ETL处理时间戳';
