/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_retl_loan_appl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_retl_loan_appl_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_retl_loan_appl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_appl_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,loan_appl_flow_num varchar2(60) -- 贷款申请流水号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_name varchar2(500) -- 客户姓名
    ,prod_id varchar2(60) -- 产品编号
    ,prod_name varchar2(500) -- 产品名称
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,belong_brch_id varchar2(60) -- 所属分行编号
    ,access_chn_id varchar2(60) -- 接入渠道编号
    ,chn_id varchar2(60) -- 渠道编号
    ,loan_usage_cd varchar2(10) -- 贷款用途代码
    ,loan_usage_subclass_cd varchar2(10) -- 贷款用途细类代码
    ,spec_usage varchar2(1000) -- 具体用途
    ,repay_src_cd varchar2(300) -- 还款来源代码
    ,ghb_emply_flg varchar2(10) -- 本行员工标志
    ,final_jud_advise_sucs_flg varchar2(10) -- 终审通知成功标志
    ,distr_advise_sucs_flg varchar2(2) -- 放款通知成功标志
    ,blip_doc_flg varchar2(10) -- 有影像文件标志
    ,open_acct_sucs_flg varchar2(10) -- 开户成功标志
    ,netw_vrfction_status_flg varchar2(10) -- 联网核查状态标志
    ,crdtc_que_situ_flg varchar2(20) -- 征信查询情况标志
    ,espec_loan_flg varchar2(60) -- 特殊贷款标志
    ,main_debit_ps_cert_type_cd varchar2(10) -- 主借人证件类型代码
    ,main_debit_ps_cert_id varchar2(60) -- 主借人证件编号
    ,tax_num varchar2(250) -- 纳税人识别号
    ,acct_instit_id varchar2(100) -- 账务机构编号
    ,enter_clear_bk_no varchar2(60) -- 入账账户清算银行行号
    ,recver_acct_id varchar2(500) -- 收款人帐户编号
    ,recver_name varchar2(500) -- 收款人名称
    ,mgmt_org_id varchar2(20) -- 管理机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,housing_cnt_cd varchar2(10) -- 住房套数代码
    ,house_first_pay_amt number(30,2) -- 房屋首付额
    ,house_tot_price number(30,2) -- 房屋总价
    ,appl_amt number(30,8) -- 申请金额
    ,crdt_amt number(30,8) -- 授信金额
    ,score_val varchar2(10) -- 评分分值
    ,first_trial_apv_status_cd varchar2(30) -- 初审审批状态代码
    ,first_trial_appl_dt date -- 初审申请日期
    ,first_trial_appl_tm varchar2(20) -- 初审申请时间
    ,first_trial_end_tm timestamp(6) -- 初审结束时间
    ,final_jud_appl_dt date -- 终审申请日期
    ,final_jud_appl_tm varchar2(20) -- 终审申请时间
    ,final_jud_apv_lmt number(30,2) -- 终审审批额度
    ,final_jud_apv_status_cd varchar2(30) -- 终审审批状态代码
    ,apv_opinion varchar2(4000) -- 审批意见
    ,apv_concus varchar2(15) -- 审批结论
    ,final_jud_end_tm timestamp(6) -- 终审结束时间
    ,refuse_rs varchar2(4000) -- 拒绝原因
    ,fir_buy_flg varchar2(10) -- 首次购房标志
    ,house_arch_area number(30,2) -- 房屋建筑面积
    ,house_first_pay_ratio number(30,8) -- 房屋首付比例
    ,loan_ratio number(30,8) -- 贷款比例
    ,estim_price number(30,8) -- 评估价格
    ,idtfy_price number(30,8) -- 认定价格
    ,acct_flg varchar2(10) -- 白户标志
    ,crdt_lmt_use_flg varchar2(10) -- 授信额度标志
    ,camp_chn_id varchar2(60) -- 营销渠道编号
    ,camp_corp_id varchar2(60) -- 营销单位编号
    ,camp_corp_name varchar2(1000) -- 营销单位名称
    ,camp_chn_name varchar2(1000) -- 营销渠道名称
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_retl_loan_appl_info to ${idl_schema};
grant select on ${icl_schema}.cmm_retl_loan_appl_info to ${iel_schema};
grant select on ${icl_schema}.cmm_retl_loan_appl_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_retl_loan_appl_info is '零售贷款申请信息';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.loan_appl_flow_num is '贷款申请流水号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.bus_flow_num is '业务流水号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.cust_name is '客户姓名';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.prod_name is '产品名称';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.belong_brch_id is '所属分行编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.access_chn_id is '接入渠道编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.chn_id is '渠道编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.loan_usage_cd is '贷款用途代码';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.loan_usage_subclass_cd is '贷款用途细类代码';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.spec_usage is '具体用途';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.repay_src_cd is '还款来源代码';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.ghb_emply_flg is '本行员工标志';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.final_jud_advise_sucs_flg is '终审通知成功标志';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.distr_advise_sucs_flg is '放款通知成功标志';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.blip_doc_flg is '有影像文件标志';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.open_acct_sucs_flg is '开户成功标志';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.netw_vrfction_status_flg is '联网核查状态标志';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.crdtc_que_situ_flg is '征信查询情况标志';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.espec_loan_flg is '特殊贷款标志';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.main_debit_ps_cert_type_cd is '主借人证件类型代码';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.main_debit_ps_cert_id is '主借人证件编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.tax_num is '纳税人识别号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.enter_clear_bk_no is '入账账户清算银行行号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.recver_acct_id is '收款人帐户编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.recver_name is '收款人名称';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.mgmt_org_id is '管理机构编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.rgst_teller_id is '登记柜员编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.housing_cnt_cd is '住房套数代码';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.house_first_pay_amt is '房屋首付额';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.house_tot_price is '房屋总价';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.appl_amt is '申请金额';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.crdt_amt is '授信金额';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.score_val is '评分分值';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.first_trial_apv_status_cd is '初审审批状态代码';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.first_trial_appl_dt is '初审申请日期';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.first_trial_appl_tm is '初审申请时间';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.first_trial_end_tm is '初审结束时间';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.final_jud_appl_dt is '终审申请日期';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.final_jud_appl_tm is '终审申请时间';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.final_jud_apv_lmt is '终审审批额度';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.final_jud_apv_status_cd is '终审审批状态代码';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.apv_opinion is '审批意见';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.apv_concus is '审批结论';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.final_jud_end_tm is '终审结束时间';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.refuse_rs is '拒绝原因';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.fir_buy_flg is '首次购房标志';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.house_arch_area is '房屋建筑面积';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.house_first_pay_ratio is '房屋首付比例';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.loan_ratio is '贷款比例';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.estim_price is '评估价格';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.idtfy_price is '认定价格';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.acct_flg is '白户标志';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.crdt_lmt_use_flg is '授信额度标志';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.camp_chn_id is '营销渠道编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.camp_corp_id is '营销单位编号';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.camp_corp_name is '营销单位名称';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.camp_chn_name is '营销渠道名称';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_retl_loan_appl_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_retl_loan_appl_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_retl_loan_appl_info.etl_timestamp is 'ETL处理时间戳';
