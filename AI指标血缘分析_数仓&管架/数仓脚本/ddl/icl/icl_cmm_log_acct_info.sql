/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_log_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_log_acct_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_log_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_log_acct_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,cust_id varchar2(60) -- 客户编号
    ,bus_id varchar2(60) -- 业务编号
    ,log_cont_id varchar2(60) -- 保函合同编号
    ,log_acct_num varchar2(100) -- 保函账号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,out_acct_acct_num varchar2(60) -- 出账账号
    ,stl_acct_num varchar2(60) -- 结算账号
    ,crdt_contr_no varchar2(60) -- 信贷合同号
    ,recvbl_num varchar2(60) -- 收款账号
    ,subj_cd varchar2(60) -- 科目代码
    ,log_kind_cd varchar2(12) -- 保函种类代码
    ,fin_log_flg varchar2(10) -- 融资性保函标志
    ,overs_log_flg varchar2(10) -- 境外保函标志
    ,advc_flg varchar2(10) -- 垫款标志
    ,advc_dubil_id varchar2(60) -- 垫款借据编号
    ,log_status varchar2(10) -- 保函状态
    ,wrtoff_way varchar2(10) -- 注销方式
    ,guar_way_cd varchar2(10) -- 担保方式代码
    ,tenor varchar2(10) -- 期限
    ,benefc_name varchar2(150) -- 受益人名称
    ,benefc_acct_num varchar2(60) -- 受益人账号
    ,benefc_open_bank_name varchar2(100) -- 受益人开户行名称
    ,benefc_cty_cd varchar2(10) -- 受益人国家代码
    ,oper_teller_id varchar2(60) -- 经办柜员编号
    ,oper_teller_name varchar2(250) -- 经办柜员名称
    ,check_teller_id varchar2(60) -- 复核柜员编号
    ,check_teller_name varchar2(250) -- 复核柜员名称
    ,open_bk_bic varchar2(90) -- 代开行BIC
    ,advise_bank_bic varchar2(90) -- 通知行BIC
    ,final_bnft_bk_bic varchar2(90) -- 最终受益行BIC
    ,tran_cmplt_tm timestamp(6) -- 交易完成时间
    ,usd_tran_amt number(30,2) -- 折美元交易金额
    ,guar_org_id varchar2(60) -- 担保机构编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,oper_org_id varchar2(60) -- 经办机构编号
    ,open_dt date -- 开立日期
    ,wrtoff_dt date -- 注销日期
    ,start_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,open_flow varchar2(90) -- 开立流水
    ,wrtoff_flow varchar2(90) -- 注销流水
    ,curr_cd varchar2(10) -- 币种代码
    ,nomal_int_rat number(18,8) -- 正常利率
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,advc_int_rat number(18,8) -- 垫款利率
    ,comm_fee_rat number(18,8) -- 手续费费率
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,compens_amt number(30,2) -- 赔付金额
    ,advc_amt number(30,2) -- 垫款金额
    ,margin_acct_num varchar2(60) -- 保证金账号
    ,margin_sub_acct_num varchar2(60) -- 保证金子户号
    ,margin_curr varchar2(10) -- 保证金币种
    ,margin_ratio number(18,2) -- 保证金比例
    ,margin_amt number(30,2) -- 保证金金额
    ,log_amt number(30,2) -- 保函金额
    ,currt_bal number(30,2) -- 当期余额
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
    ,y_avg_bal number(30,2) -- 年日均余额
    ,q_avg_bal number(30,2) -- 季日均余额
    ,m_avg_bal number(30,2) -- 月日均余额
    ,cl_curr_y_avg_bal number(30,2) -- 折本币年日均余额
    ,cl_curr_q_avg_bal number(30,2) -- 折本币季日均余额
    ,cl_curr_m_avg_bal number(30,2) -- 折本币月日均余额
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
grant select on ${icl_schema}.cmm_log_acct_info to ${idl_schema};
grant select on ${icl_schema}.cmm_log_acct_info to ${iel_schema};
grant select on ${icl_schema}.cmm_log_acct_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_log_acct_info is '保函账户信息';
comment on column ${icl_schema}.cmm_log_acct_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_log_acct_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_log_acct_info.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_log_acct_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_log_acct_info.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_log_acct_info.log_cont_id is '保函合同编号';
comment on column ${icl_schema}.cmm_log_acct_info.log_acct_num is '保函账号';
comment on column ${icl_schema}.cmm_log_acct_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_log_acct_info.out_acct_acct_num is '出账账号';
comment on column ${icl_schema}.cmm_log_acct_info.stl_acct_num is '结算账号';
comment on column ${icl_schema}.cmm_log_acct_info.crdt_contr_no is '信贷合同号';
comment on column ${icl_schema}.cmm_log_acct_info.recvbl_num is '收款账号';
comment on column ${icl_schema}.cmm_log_acct_info.subj_cd is '科目代码';
comment on column ${icl_schema}.cmm_log_acct_info.log_kind_cd is '保函种类代码';
comment on column ${icl_schema}.cmm_log_acct_info.fin_log_flg is '融资性保函标志';
comment on column ${icl_schema}.cmm_log_acct_info.overs_log_flg is '境外保函标志';
comment on column ${icl_schema}.cmm_log_acct_info.advc_flg is '垫款标志';
comment on column ${icl_schema}.cmm_log_acct_info.advc_dubil_id is '垫款借据编号';
comment on column ${icl_schema}.cmm_log_acct_info.log_status is '保函状态';
comment on column ${icl_schema}.cmm_log_acct_info.wrtoff_way is '注销方式';
comment on column ${icl_schema}.cmm_log_acct_info.guar_way_cd is '担保方式代码';
comment on column ${icl_schema}.cmm_log_acct_info.tenor is '期限';
comment on column ${icl_schema}.cmm_log_acct_info.benefc_name is '受益人名称';
comment on column ${icl_schema}.cmm_log_acct_info.benefc_acct_num is '受益人账号';
comment on column ${icl_schema}.cmm_log_acct_info.benefc_open_bank_name is '受益人开户行名称';
comment on column ${icl_schema}.cmm_log_acct_info.benefc_cty_cd is '受益人国家代码';
comment on column ${icl_schema}.cmm_log_acct_info.oper_teller_id is '经办柜员编号';
comment on column ${icl_schema}.cmm_log_acct_info.oper_teller_name is '经办柜员名称';
comment on column ${icl_schema}.cmm_log_acct_info.check_teller_id is '复核柜员编号';
comment on column ${icl_schema}.cmm_log_acct_info.check_teller_name is '复核柜员名称';
comment on column ${icl_schema}.cmm_log_acct_info.open_bk_bic is '代开行BIC';
comment on column ${icl_schema}.cmm_log_acct_info.advise_bank_bic is '通知行BIC';
comment on column ${icl_schema}.cmm_log_acct_info.final_bnft_bk_bic is '最终受益行BIC';
comment on column ${icl_schema}.cmm_log_acct_info.tran_cmplt_tm is '交易完成时间';
comment on column ${icl_schema}.cmm_log_acct_info.usd_tran_amt is '折美元交易金额';
comment on column ${icl_schema}.cmm_log_acct_info.guar_org_id is '担保机构编号';
comment on column ${icl_schema}.cmm_log_acct_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_log_acct_info.mgmt_org_id is '管理机构编号';
comment on column ${icl_schema}.cmm_log_acct_info.oper_org_id is '经办机构编号';
comment on column ${icl_schema}.cmm_log_acct_info.open_dt is '开立日期';
comment on column ${icl_schema}.cmm_log_acct_info.wrtoff_dt is '注销日期';
comment on column ${icl_schema}.cmm_log_acct_info.start_dt is '起始日期';
comment on column ${icl_schema}.cmm_log_acct_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_log_acct_info.open_flow is '开立流水';
comment on column ${icl_schema}.cmm_log_acct_info.wrtoff_flow is '注销流水';
comment on column ${icl_schema}.cmm_log_acct_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_log_acct_info.nomal_int_rat is '正常利率';
comment on column ${icl_schema}.cmm_log_acct_info.ovdue_int_rat is '逾期利率';
comment on column ${icl_schema}.cmm_log_acct_info.advc_int_rat is '垫款利率';
comment on column ${icl_schema}.cmm_log_acct_info.comm_fee_rat is '手续费费率';
comment on column ${icl_schema}.cmm_log_acct_info.comm_fee_amt is '手续费金额';
comment on column ${icl_schema}.cmm_log_acct_info.compens_amt is '赔付金额';
comment on column ${icl_schema}.cmm_log_acct_info.advc_amt is '垫款金额';
comment on column ${icl_schema}.cmm_log_acct_info.margin_acct_num is '保证金账号';
comment on column ${icl_schema}.cmm_log_acct_info.margin_sub_acct_num is '保证金子户号';
comment on column ${icl_schema}.cmm_log_acct_info.margin_curr is '保证金币种';
comment on column ${icl_schema}.cmm_log_acct_info.margin_ratio is '保证金比例';
comment on column ${icl_schema}.cmm_log_acct_info.margin_amt is '保证金金额';
comment on column ${icl_schema}.cmm_log_acct_info.log_amt is '保函金额';
comment on column ${icl_schema}.cmm_log_acct_info.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_currt_bal is '折本币当期余额';
comment on column ${icl_schema}.cmm_log_acct_info.ear_d_bal is '日初余额';
comment on column ${icl_schema}.cmm_log_acct_info.ear_m_bal is '月初余额';
comment on column ${icl_schema}.cmm_log_acct_info.ear_s_bal is '季初余额';
comment on column ${icl_schema}.cmm_log_acct_info.ear_y_bal is '年初余额';
comment on column ${icl_schema}.cmm_log_acct_info.y_acm_bal is '年累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.s_acm_bal is '季累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.m_acm_bal is '月累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_d_bal is '折本币日初余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_m_bal is '折本币月初余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_s_bal is '折本币季初余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_y_bal is '折本币年初余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_y_acm_bal is '折本币年累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_d_y_acm_bal is '折本币日初年累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_m_y_acm_bal is '折本币月初年累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_s_y_acm_bal is '折本币季初年累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_y_y_acm_bal is '折本币年初年累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_s_acm_bal is '折本币季累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_d_s_acm_bal is '折本币日初季累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_s_s_acm_bal is '折本币季初季累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_y_s_acm_bal is '折本币年初季累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_m_acm_bal is '折本币月累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_d_m_acm_bal is '折本币日初月累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_m_m_acm_bal is '折本币月初月累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_ear_y_m_acm_bal is '折本币年初月累计余额';
comment on column ${icl_schema}.cmm_log_acct_info.y_avg_bal is '年日均余额';
comment on column ${icl_schema}.cmm_log_acct_info.q_avg_bal is '季日均余额';
comment on column ${icl_schema}.cmm_log_acct_info.m_avg_bal is '月日均余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_y_avg_bal is '折本币年日均余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_q_avg_bal is '折本币季日均余额';
comment on column ${icl_schema}.cmm_log_acct_info.cl_curr_m_avg_bal is '折本币月日均余额';
comment on column ${icl_schema}.cmm_log_acct_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_log_acct_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_log_acct_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_log_acct_info.etl_timestamp is 'ETL处理时间戳';
