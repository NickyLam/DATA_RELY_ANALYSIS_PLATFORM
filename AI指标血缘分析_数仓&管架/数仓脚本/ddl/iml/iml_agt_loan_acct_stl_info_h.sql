/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_acct_stl_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_acct_stl_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_acct_stl_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_stl_info_h(
    agt_id varchar2(250) -- 协议编号
    ,tran_stl_id varchar2(100) -- 交易结算编号
    ,lp_id varchar2(100) -- 法人编号
    ,loan_num varchar2(60) -- 贷款号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,evt_cate_id varchar2(100) -- 事件类别编号
    ,callbk_id varchar2(100) -- 回收编号
    ,stl_acct_cls_cd varchar2(30) -- 结算账户分类代码
    ,stl_method_cd varchar2(30) -- 结算方法代码
    ,acpt_pay_idf_cd varchar2(30) -- 收付标识代码
    ,tran_cd varchar2(30) -- 交易码
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,stl_cust_id varchar2(100) -- 结算客户编号
    ,hxb_stl_flg varchar2(10) -- 我行结算标志
    ,stl_bk_bank_no varchar2(60) -- 结算行行号
    ,stl_org_id varchar2(100) -- 结算机构编号
    ,stl_acct_id varchar2(100) -- 结算账户编号
    ,stl_cust_acct_num varchar2(60) -- 结算客户账号
    ,stl_acct_name varchar2(500) -- 结算账户名称
    ,stl_acct_prod_id varchar2(100) -- 结算账户产品编号
    ,stl_acct_curr_cd varchar2(30) -- 结算账户币种代码
    ,stl_acct_sub_acct_num varchar2(60) -- 结算账户子账号
    ,stl_curr_cd varchar2(30) -- 结算币种代码
    ,stl_amt number(30,2) -- 结算金额
    ,stl_exch_rat number(18,8) -- 结算汇率
    ,stl_exch_way_cd varchar2(30) -- 结算汇兑方式代码
    ,prior_level varchar2(30) -- 优先等级
    ,stl_wt number(30,2) -- 结算权重
    ,auto_lock_flg varchar2(10) -- 自动锁定标志
    ,entr_pay_id varchar2(100) -- 受托支付编号
    ,froz_id varchar2(100) -- 冻结编号
    ,recv_bank_no varchar2(60) -- 收款行行号
    ,recv_bank_name varchar2(500) -- 收款行名称
    ,entred_ps_acct_froz_way_cd varchar2(30) -- 受托人账户冻结方式代码
    ,out_line_flg varchar2(10) -- 行内标志
    ,prft_cut_ratio number(18,6) -- 分润比例
    ,contri_ratio number(18,6) -- 出资比例
    ,sel_sup_flg varchar2(10) -- 自营标志
    ,stl_acct_bind_mobile_no varchar2(60) -- 结算账户绑定手机号码
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_tm timestamp -- 交易时间
    ,realtm_chase_capt_flg varchar2(10) -- 实时追缴标志
    ,acct_cls_cd varchar2(30) -- 账户分类代码
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
    ,final_modif_dt date -- 最后修改日期
    ,on_acct_seq_num varchar2(60) -- 挂账序号
    ,on_acct_type_cd varchar2(30) -- 挂账类型代码
    ,acct_attr_descb varchar2(375) -- 账户属性描述
    ,acct_attr_cd varchar2(10) -- 存款账户类型代码
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
grant select on ${iml_schema}.agt_loan_acct_stl_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_acct_stl_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_acct_stl_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_acct_stl_info_h is '贷款账户结算信息历史';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.tran_stl_id is '交易结算编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.loan_num is '贷款号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.evt_cate_id is '事件类别编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.callbk_id is '回收编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_acct_cls_cd is '结算账户分类代码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_method_cd is '结算方法代码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.acpt_pay_idf_cd is '收付标识代码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.tran_cd is '交易码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_cust_id is '结算客户编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.hxb_stl_flg is '我行结算标志';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_bk_bank_no is '结算行行号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_org_id is '结算机构编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_acct_id is '结算账户编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_cust_acct_num is '结算客户账号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_acct_name is '结算账户名称';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_acct_prod_id is '结算账户产品编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_acct_curr_cd is '结算账户币种代码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_acct_sub_acct_num is '结算账户子账号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_curr_cd is '结算币种代码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_amt is '结算金额';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_exch_rat is '结算汇率';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_exch_way_cd is '结算汇兑方式代码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.prior_level is '优先等级';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_wt is '结算权重';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.auto_lock_flg is '自动锁定标志';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.entr_pay_id is '受托支付编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.froz_id is '冻结编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.recv_bank_no is '收款行行号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.recv_bank_name is '收款行名称';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.entred_ps_acct_froz_way_cd is '受托人账户冻结方式代码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.out_line_flg is '行内标志';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.prft_cut_ratio is '分润比例';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.contri_ratio is '出资比例';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.sel_sup_flg is '自营标志';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.stl_acct_bind_mobile_no is '结算账户绑定手机号码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.realtm_chase_capt_flg is '实时追缴标志';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.acct_cls_cd is '账户分类代码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.on_acct_seq_num is '挂账序号';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.on_acct_type_cd is '挂账类型代码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.acct_attr_descb is '账户属性描述';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.acct_attr_cd is '存款账户类型代码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_acct_stl_info_h.etl_timestamp is 'ETL处理时间戳';
