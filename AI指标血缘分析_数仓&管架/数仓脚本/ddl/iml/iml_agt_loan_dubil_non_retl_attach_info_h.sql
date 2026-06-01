/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_dubil_non_retl_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h(
    agt_id varchar2(250) -- 协议编号
    ,dubil_id varchar2(100) -- 借据编号
    ,fee_rat number(18,6) -- 费率
    ,ped number(10) -- 周期
    ,int_accr_way_cd varchar2(30) -- 计息方式代码
    ,pre_recv_int_flg varchar2(10) -- 预收息标志
    ,loan_type_cd varchar2(30) -- 贷款类型代码
    ,surp_perds number(10) -- 剩余期数
    ,eh_issue_deduct_amt number(30,2) -- 每期扣款金额
    ,acm_rtn_pric number(30,2) -- 累计归还本金
    ,acm_rtn_int number(30,2) -- 累计归还利息
    ,int_expns_fee_id varchar2(100) -- 利息支出费用编号
    ,comm_fee_expns_fee_id varchar2(100) -- 手续费支出费用编号
    ,next_term_rpp_dt date -- 下一期还本日期
    ,next_term_rpp_amt number(30,2) -- 下一期还本金额
    ,next_term_repay_int_dt date -- 下一期还息日期
    ,next_term_repay_int_amt number(30,2) -- 下一期还息金额
    ,advc_amt number(30,2) -- 垫款金额
    ,attach_rgst_dubil_flg varchar2(10) -- 补登借据标志
    ,bill_uniq_ind_no varchar2(60) -- 票据唯一标识号
    ,bill_id varchar2(100) -- 票据编号
    ,bill_type_cd varchar2(30) -- 票据类型代码
    ,bill_kind_cd varchar2(30) -- 票据种类代码
    ,acpt_bank_no varchar2(60) -- 承兑行行号
    ,acpt_bank_name varchar2(500) -- 承兑行名称
    ,transf_type_cd varchar2(30) -- 转让类型代码
    ,discount_int_rat number(18,8) -- 转贴现利率
    ,dir_paste_bank_no varchar2(60) -- 直贴行行号
    ,dir_paste_bank_name varchar2(500) -- 直贴行名称
    ,benefc_open_bank_no varchar2(60) -- 受益人开户行行号
    ,benefc_open_bank_name varchar2(500) -- 受益人开户行名称
    ,benefc_name varchar2(500) -- 受益人名称
    ,bnft_bank_name varchar2(500) -- 受益行名称
    ,open_flow_num varchar2(100) -- 开立流水号
    ,open_dt date -- 开立日期
    ,wrtoff_type_cd varchar2(30) -- 注销类型代码
    ,wrtoff_flow_num varchar2(100) -- 注销流水号
    ,wrtoff_dt date -- 注销日期
    ,sell_status_cd varchar2(30) -- 卖出状态代码
    ,attach_rgst_check_teller_id varchar2(100) -- 补登复核柜员编号
    ,refac_batch_pkg_id varchar2(100) -- 支小再批次包编号
    ,refac_batch_exp_dt date -- 支小再批次到期日期
    ,refac_status_cd varchar2(30) -- 支小再状态代码
    ,refac_invalid_tm timestamp -- 支小再失效时间
    ,edu_hea_flg varchar2(10) -- 文教健康标志
    ,asset_id varchar2(250) -- 资产编号
    ,acct_b_cate_cd varchar2(60) -- 账簿类别代码
    ,matn_flg varchar2(10) -- 维护标志
    ,bus_org_id varchar2(100) -- 业务机构编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,batch_data_src_cd varchar2(30) -- 批量数据来源代码
    ,dep_agt_id varchar2(100) -- 存款协议编号
    ,benefc_cust_id varchar2(100) -- 受益人客户编号
    ,deduct_dt date -- 扣款日期
    ,int_adj number(30,8) -- 利息调整
    ,col_int_type_cd varchar2(30) -- 收息类型代码
    ,acru_int number(30,8) -- 应计利息
    ,ibank_no varchar2(100) -- 联行号
    ,rels_lmt_flg varchar2(10) -- 释放额度标志
    ,accept_recv_flg varchar2(10) -- 收票签收标志
    ,suit_fee number(30,8) -- 诉讼费
    ,ibank_syn_bus_sys_tran_dt date -- 同业综合业务系统交易日期
    ,syn_loan_seq_num varchar2(60) -- 银团贷款序号
    ,oc_curr_cd varchar2(30) -- 原币币种代码
    ,oc_amt number(30,8) -- 原币金额
    ,init_asset_uniq_idf varchar2(100) -- 原资产唯一标识
    ,final_modif_dt date -- 最后修改日期
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
grant select on ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h is '贷款借据非零售附属信息历史';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.fee_rat is '费率';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.ped is '周期';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.pre_recv_int_flg is '预收息标志';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.loan_type_cd is '贷款类型代码';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.surp_perds is '剩余期数';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.eh_issue_deduct_amt is '每期扣款金额';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.acm_rtn_pric is '累计归还本金';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.acm_rtn_int is '累计归还利息';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.int_expns_fee_id is '利息支出费用编号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.comm_fee_expns_fee_id is '手续费支出费用编号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.next_term_rpp_dt is '下一期还本日期';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.next_term_rpp_amt is '下一期还本金额';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.next_term_repay_int_dt is '下一期还息日期';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.next_term_repay_int_amt is '下一期还息金额';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.advc_amt is '垫款金额';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.attach_rgst_dubil_flg is '补登借据标志';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.bill_uniq_ind_no is '票据唯一标识号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.bill_id is '票据编号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.bill_kind_cd is '票据种类代码';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.acpt_bank_no is '承兑行行号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.acpt_bank_name is '承兑行名称';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.transf_type_cd is '转让类型代码';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.discount_int_rat is '转贴现利率';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.dir_paste_bank_no is '直贴行行号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.dir_paste_bank_name is '直贴行名称';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.benefc_open_bank_no is '受益人开户行行号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.benefc_open_bank_name is '受益人开户行名称';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.benefc_name is '受益人名称';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.bnft_bank_name is '受益行名称';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.open_flow_num is '开立流水号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.open_dt is '开立日期';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.wrtoff_type_cd is '注销类型代码';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.wrtoff_flow_num is '注销流水号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.wrtoff_dt is '注销日期';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.sell_status_cd is '卖出状态代码';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.attach_rgst_check_teller_id is '补登复核柜员编号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.refac_batch_pkg_id is '支小再批次包编号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.refac_batch_exp_dt is '支小再批次到期日期';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.refac_status_cd is '支小再状态代码';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.refac_invalid_tm is '支小再失效时间';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.edu_hea_flg is '文教健康标志';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.asset_id is '资产编号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.acct_b_cate_cd is '账簿类别代码';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.matn_flg is '维护标志';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.bus_org_id is '业务机构编号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.batch_data_src_cd is '批量数据来源代码';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.dep_agt_id is '存款协议编号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.benefc_cust_id is '受益人客户编号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.deduct_dt is '扣款日期';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.int_adj is '利息调整';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.col_int_type_cd is '收息类型代码';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.acru_int is '应计利息';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.ibank_no is '联行号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.rels_lmt_flg is '释放额度标志';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.accept_recv_flg is '收票签收标志';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.suit_fee is '诉讼费';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.ibank_syn_bus_sys_tran_dt is '同业综合业务系统交易日期';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.syn_loan_seq_num is '银团贷款序号';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.oc_curr_cd is '原币币种代码';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.oc_amt is '原币金额';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.init_asset_uniq_idf is '原资产唯一标识';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h.etl_timestamp is 'ETL处理时间戳';
