/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dep_acct_lmt_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dep_acct_lmt_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dep_acct_lmt_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_lmt_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,tran_lmt_type_cd varchar2(30) -- 交易限制类型代码
    ,lmt_id varchar2(100) -- 限制编号
    ,acct_lmt_status_cd varchar2(30) -- 账户限制状态代码
    ,lmt_acct_range_cd varchar2(30) -- 限制账户范围代码
    ,acct_lmt_amt number(30,2) -- 账户限制金额
    ,sub_lmt_cate_cd varchar2(30) -- 子限制类别代码
    ,actl_ctrl_amt number(30,2) -- 实际控制金额
    ,actl_effect_dt date -- 实际生效日期
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,dep_tenor number(10) -- 存款期限
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,acct_aldy_check_flg varchar2(10) -- 账户已复核标志
    ,acct_check_dt date -- 账户复核日期
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,tran_cd varchar2(30) -- 交易码
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,tran_amt number(30,2) -- 交易金额
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,cntpty_acct_prod_id varchar2(100) -- 交易对手账户产品编号
    ,cntpty_acct_id varchar2(100) -- 交易对手账户编号
    ,cntpty_acct_name varchar2(1000) -- 交易对手账户名称
    ,cntpty_cust_acct_num varchar2(60) -- 交易对手客户账号
    ,cntpty_curr_cd varchar2(30) -- 交易对手币种代码
    ,cntpty_open_acct_org_id varchar2(100) -- 交易对手开户机构编号
    ,vouch_type_cd varchar2(30) -- 凭证类型代码
    ,begin_check_id varchar2(100) -- 起始支票编号
    ,begin_amt number(30,2) -- 起始金额
    ,termnt_check_id varchar2(100) -- 终止支票编号
    ,stop_amt number(30,2) -- 截止金额
    ,aldy_paid_amt number(30,2) -- 已还金额
    ,pay_amt number(30,2) -- 支付金额
    ,tot_pay_cnt number(10) -- 总支付笔数
    ,aldy_pay_cnt number(10) -- 已支付笔数
    ,interp_flg varchar2(10) -- 中断标志
    ,pm_flg varchar2(10) -- 抵质押标志
    ,mtg_acct_id varchar2(100) -- 抵押账户编号
    ,mtg_cust_acct_num varchar2(60) -- 抵押客户账号
    ,mtg_acct_curr_cd varchar2(30) -- 抵押账户币种代码
    ,mtg_acct_type_cd varchar2(30) -- 抵押账户类型代码
    ,matn_way_cd varchar2(30) -- 维护方式代码
    ,stl_flow_id varchar2(100) -- 结算流水编号
    ,check_entry_code varchar2(60) -- 对账编码
    ,revs_flg varchar2(10) -- 冲正标志
    ,wait_to_froz_seq_num varchar2(60) -- 轮候冻结序号
    ,full_amt_froz_flg varchar2(10) -- 全额冻结标志
    ,ct_froz_flg varchar2(10) -- 续冻标志
    ,froz_org_name varchar2(500) -- 冻结机关名称
    ,froz_org_law_doc_num varchar2(250) -- 冻结机关法律文书号码
    ,froz_lev varchar2(30) -- 冻结级别
    ,unfrz_org_name varchar2(500) -- 解冻机关名称
    ,unfrz_org_law_doc_num varchar2(250) -- 解冻机关法律文书号码
    ,unloss_tm timestamp -- 解挂时间
    ,unloss_teller_id varchar2(100) -- 解挂柜员编号
    ,can_deduct_amt number(30,2) -- 可扣划金额
    ,deduct_law_doc_num varchar2(60) -- 扣划法律文书号码
    ,auth_org_name varchar2(500) -- 有权机关名称
    ,exec_org_cd varchar2(30) -- 执行机关代码
    ,asit_exec_item varchar2(500) -- 协助执行事项
    ,enforc_ps_1_name varchar2(500) -- 执法人1名称
    ,enforc_ps_1_cert_a_type_cd varchar2(30) -- 执法人1证件A类型代码
    ,enforc_ps_1_cert_a_no varchar2(250) -- 执法人1证件A号码
    ,enforc_ps_1_cert_b_type_cd varchar2(30) -- 执法人1证件B类型代码
    ,enforc_ps_1_cert_b_no varchar2(250) -- 执法人1证件B号码
    ,enforc_ps_2_name varchar2(500) -- 执法人2名称
    ,enforc_ps_2_cert_a_type_cd varchar2(30) -- 执法人2证件A类型代码
    ,enforc_ps_2_cert_a_no varchar2(60) -- 执法人2证件A号码
    ,enforc_ps_2_cert_b_type_cd varchar2(30) -- 执法人2证件B类型代码
    ,enforc_ps_2_cert_b_no varchar2(60) -- 执法人2证件B号码
    ,operr_1_name varchar2(500) -- 经办人1名称
    ,operr_1_cert_a_type_cd varchar2(30) -- 经办人1证件A类型代码
    ,operr_1_cert_a_no varchar2(60) -- 经办人1证件A号码
    ,operr_1_cert_b_type_cd varchar2(30) -- 经办人1证件B类型代码
    ,operr_1_cert_b_no varchar2(60) -- 经办人1证件B号码
    ,operr_2_name varchar2(500) -- 经办人2名称
    ,operr_2_cert_a_type_cd varchar2(30) -- 经办人2证件A类型代码
    ,operr_2_cert_a_no varchar2(60) -- 经办人2证件A号码
    ,operr_2_cert_b_type_cd varchar2(30) -- 经办人2证件B类型代码
    ,operr_2_cert_b_no varchar2(60) -- 经办人2证件B号码
    ,proof_cate_cd varchar2(30) -- 证明人证件类型代码
    ,src_module_type_cd varchar2(30) -- 源模块类型代码
    ,sign_chn_id varchar2(100) -- 签约渠道编号
    ,sign_teller_id varchar2(60) -- 签约柜员编号
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,final_modif_dt date -- 最后修改日期
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
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
grant select on ${iml_schema}.agt_dep_acct_lmt_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_dep_acct_lmt_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_dep_acct_lmt_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dep_acct_lmt_info_h is '存款账户限制信息历史';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.tran_lmt_type_cd is '交易限制类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.lmt_id is '限制编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.acct_lmt_status_cd is '账户限制状态代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.lmt_acct_range_cd is '限制账户范围代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.acct_lmt_amt is '账户限制金额';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.sub_lmt_cate_cd is '子限制类别代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.actl_ctrl_amt is '实际控制金额';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.actl_effect_dt is '实际生效日期';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.dep_tenor is '存款期限';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.acct_aldy_check_flg is '账户已复核标志';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.acct_check_dt is '账户复核日期';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.tran_cd is '交易码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.tran_amt is '交易金额';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.cntpty_acct_prod_id is '交易对手账户产品编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.cntpty_acct_id is '交易对手账户编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.cntpty_acct_name is '交易对手账户名称';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.cntpty_cust_acct_num is '交易对手客户账号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.cntpty_curr_cd is '交易对手币种代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.cntpty_open_acct_org_id is '交易对手开户机构编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.vouch_type_cd is '凭证类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.begin_check_id is '起始支票编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.begin_amt is '起始金额';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.termnt_check_id is '终止支票编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.stop_amt is '截止金额';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.aldy_paid_amt is '已还金额';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.pay_amt is '支付金额';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.tot_pay_cnt is '总支付笔数';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.aldy_pay_cnt is '已支付笔数';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.interp_flg is '中断标志';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.pm_flg is '抵质押标志';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.mtg_acct_id is '抵押账户编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.mtg_cust_acct_num is '抵押客户账号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.mtg_acct_curr_cd is '抵押账户币种代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.mtg_acct_type_cd is '抵押账户类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.matn_way_cd is '维护方式代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.stl_flow_id is '结算流水编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.check_entry_code is '对账编码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.revs_flg is '冲正标志';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.wait_to_froz_seq_num is '轮候冻结序号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.full_amt_froz_flg is '全额冻结标志';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.ct_froz_flg is '续冻标志';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.froz_org_name is '冻结机关名称';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.froz_org_law_doc_num is '冻结机关法律文书号码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.froz_lev is '冻结级别';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.unfrz_org_name is '解冻机关名称';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.unfrz_org_law_doc_num is '解冻机关法律文书号码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.unloss_tm is '解挂时间';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.unloss_teller_id is '解挂柜员编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.can_deduct_amt is '可扣划金额';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.deduct_law_doc_num is '扣划法律文书号码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.auth_org_name is '有权机关名称';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.exec_org_cd is '执行机关代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.asit_exec_item is '协助执行事项';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.enforc_ps_1_name is '执法人1名称';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.enforc_ps_1_cert_a_type_cd is '执法人1证件A类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.enforc_ps_1_cert_a_no is '执法人1证件A号码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.enforc_ps_1_cert_b_type_cd is '执法人1证件B类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.enforc_ps_1_cert_b_no is '执法人1证件B号码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.enforc_ps_2_name is '执法人2名称';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.enforc_ps_2_cert_a_type_cd is '执法人2证件A类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.enforc_ps_2_cert_a_no is '执法人2证件A号码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.enforc_ps_2_cert_b_type_cd is '执法人2证件B类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.enforc_ps_2_cert_b_no is '执法人2证件B号码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.operr_1_name is '经办人1名称';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.operr_1_cert_a_type_cd is '经办人1证件A类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.operr_1_cert_a_no is '经办人1证件A号码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.operr_1_cert_b_type_cd is '经办人1证件B类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.operr_1_cert_b_no is '经办人1证件B号码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.operr_2_name is '经办人2名称';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.operr_2_cert_a_type_cd is '经办人2证件A类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.operr_2_cert_a_no is '经办人2证件A号码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.operr_2_cert_b_type_cd is '经办人2证件B类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.operr_2_cert_b_no is '经办人2证件B号码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.proof_cate_cd is '证明人证件类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.src_module_type_cd is '源模块类型代码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.sign_chn_id is '签约渠道编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.sign_teller_id is '签约柜员编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dep_acct_lmt_info_h.etl_timestamp is 'ETL处理时间戳';
