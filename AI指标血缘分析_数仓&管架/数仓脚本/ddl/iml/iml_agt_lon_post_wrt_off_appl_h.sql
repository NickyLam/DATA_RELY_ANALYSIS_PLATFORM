/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lon_post_wrt_off_appl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lon_post_wrt_off_appl_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lon_post_wrt_off_appl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lon_post_wrt_off_appl_h(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,wrt_off_flow_num varchar2(100) -- 核销流水号
    ,wrt_off_cate_cd varchar2(30) -- 核销类别代码
    ,wrt_off_batch_no varchar2(60) -- 核销批次号
    ,loan_bal number(30,2) -- 贷款余额
    ,pric_amt number(30,2) -- 本金金额
    ,wrt_off_amt number(30,2) -- 核销金额
    ,wrt_off_pric number(30,2) -- 核销本金
    ,wrt_off_in_bs_int number(30,2) -- 核销表内利息
    ,wrt_off_off_bs_int number(30,2) -- 核销表外利息
    ,curr_cd varchar2(30) -- 币种代码
    ,apv_wrt_off_dt date -- 审批核销日期
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,wrt_off_dt date -- 核销日期
    ,guar_recs_situ_and_rest_descb varchar2(4000) -- 担保追偿情况及结果描述
    ,brwer_recs_situ_and_rest_descb varchar2(4000) -- 借款人追偿情况及结果描述
    ,cust_id varchar2(100) -- 客户编号
    ,court_final_rule_num varchar2(100) -- 法院最终裁定文号
    ,court_final_rule_tm timestamp -- 法院最终裁定时间
    ,court_final_rule_doc_name varchar2(500) -- 法院最终裁定文件名称
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,bad_debt_form_rs_descb varchar2(4000) -- 呆账形成原因描述
    ,duty_idtfy_and_rest_descb varchar2(4000) -- 责任认定及处理结果描述
    ,acct_instit_id varchar2(100) -- 账务机构编号
    ,dubil_id_comb varchar2(4000) -- 借据编号集合
    ,mang_corp_name varchar2(500) -- 经营企业名称
    ,resv_debtor_recs_flg varchar2(10) -- 保留对债务人追索权标志
    ,cust_name varchar2(500) -- 客户名称
    ,cert_no varchar2(100) -- 证件号码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,gender_cd varchar2(30) -- 性别代码
    ,marriage_situ_cd varchar2(30) -- 婚姻状况代码
    ,bl_induty_type_cd varchar2(30) -- 所属行业类型代码
    ,bus_lics_revo_dt date -- 营业执照吊销日期
    ,advc_amt number(30) -- 垫付金额
    ,mini_loan_prod_id varchar2(100) -- 微贷产品编号
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
grant select on ${iml_schema}.agt_lon_post_wrt_off_appl_h to ${icl_schema};
grant select on ${iml_schema}.agt_lon_post_wrt_off_appl_h to ${idl_schema};
grant select on ${iml_schema}.agt_lon_post_wrt_off_appl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lon_post_wrt_off_appl_h is '贷后核销申请历史';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.wrt_off_flow_num is '核销流水号';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.wrt_off_cate_cd is '核销类别代码';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.wrt_off_batch_no is '核销批次号';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.loan_bal is '贷款余额';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.pric_amt is '本金金额';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.wrt_off_amt is '核销金额';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.wrt_off_pric is '核销本金';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.wrt_off_in_bs_int is '核销表内利息';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.wrt_off_off_bs_int is '核销表外利息';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.apv_wrt_off_dt is '审批核销日期';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.wrt_off_dt is '核销日期';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.guar_recs_situ_and_rest_descb is '担保追偿情况及结果描述';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.brwer_recs_situ_and_rest_descb is '借款人追偿情况及结果描述';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.court_final_rule_num is '法院最终裁定文号';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.court_final_rule_tm is '法院最终裁定时间';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.court_final_rule_doc_name is '法院最终裁定文件名称';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.bad_debt_form_rs_descb is '呆账形成原因描述';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.duty_idtfy_and_rest_descb is '责任认定及处理结果描述';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.dubil_id_comb is '借据编号集合';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.mang_corp_name is '经营企业名称';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.resv_debtor_recs_flg is '保留对债务人追索权标志';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.gender_cd is '性别代码';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.marriage_situ_cd is '婚姻状况代码';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.bl_induty_type_cd is '所属行业类型代码';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.bus_lics_revo_dt is '营业执照吊销日期';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.advc_amt is '垫付金额';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.mini_loan_prod_id is '微贷产品编号';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lon_post_wrt_off_appl_h.etl_timestamp is 'ETL处理时间戳';
