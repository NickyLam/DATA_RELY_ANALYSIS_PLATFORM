/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_discnt_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_discnt_acct_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_discnt_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_discnt_acct_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,bill_num varchar2(60) -- 票据号码
    ,cust_acct_id varchar2(60) -- 客户账户编号
    ,cust_id varchar2(60) -- 客户编号
    ,out_acct_flow_num varchar2(60) -- 出账流水号
    ,dubil_id varchar2(60) -- 借据编号
    ,discnt_entry_acct_id varchar2(60) -- 贴现记账账户编号
    ,int_adj_acct_id varchar2(60) -- 利息调整账户编号
    ,int_income_expns_acct_id varchar2(60) -- 利息收入支出账户编号
    ,pay_int_acct_id varchar2(60) -- 付息账户编号
    ,subj_id varchar2(60) -- 科目编号
    ,int_subj_id varchar2(60) -- 利息科目编号
    ,bus_breed_id varchar2(60) -- 业务品种编号
    ,discnt_bus_kind_cd varchar2(10) -- 贴现业务种类代码
    ,bs_type_cd varchar2(10) -- 买卖类型代码
    ,bill_med_cd varchar2(10) -- 票据介质代码
    ,bill_type_cd varchar2(10) -- 票据类型代码
    ,bs_way_cd varchar2(10) -- 买卖方式代码
    ,clear_way_cd varchar2(10) -- 清算方式代码
    ,discnt_status_cd varchar2(10) -- 贴现状态代码
    ,int_adj_entry_cd varchar2(10) -- 利息调整记账代码
    ,pay_int_way_cd varchar2(10) -- 付息方式代码
    ,curr_cd varchar2(10) -- 币种代码
    ,oper_teller_id varchar2(60) -- 经办柜员编号
    ,rgst_teller_id varchar2(61) -- 登记柜员编号
    ,discnt_org_id varchar2(60) -- 贴现机构编号
    ,draw_org_id varchar2(60) -- 出票机构编号
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,discnt_value_dt date -- 贴现起息日期
    ,discnt_exp_dt date -- 贴现到期日期
    ,draw_dt date -- 出票日期
    ,discnt_dt date -- 贴现日期
    ,discnt_flow_num varchar2(60) -- 贴现流水号
    ,close_dt date -- 关闭日期
    ,termnt_dt date -- 终止日期
    ,close_flow_num varchar2(60) -- 关闭流水号
    ,last_int_adj_day date -- 上一利息调整日
    ,next_int_adj_day date -- 下一利息调整日
    ,int_accr_days number(10,0) -- 计息天数
    ,pay_int_amt number(30,2) -- 付息金额
    ,int_recvbl number(30,2) -- 应收利息
    ,int_adj_bal number(30,2) -- 利息调整余额
    ,wrt_off_amt number(30,2) -- 核销金额
    ,fac_val_amt number(30,2) -- 票面金额
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
grant select on ${icl_schema}.cmm_discnt_acct_info to ${idl_schema};
grant select on ${icl_schema}.cmm_discnt_acct_info to ${iel_schema};
grant select on ${icl_schema}.cmm_discnt_acct_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_discnt_acct_info is '贴现账户信息';
comment on column ${icl_schema}.cmm_discnt_acct_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_discnt_acct_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.bill_num is '票据号码';
comment on column ${icl_schema}.cmm_discnt_acct_info.cust_acct_id is '客户账户编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.out_acct_flow_num is '出账流水号';
comment on column ${icl_schema}.cmm_discnt_acct_info.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.discnt_entry_acct_id is '贴现记账账户编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.int_adj_acct_id is '利息调整账户编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.int_income_expns_acct_id is '利息收入支出账户编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.pay_int_acct_id is '付息账户编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.int_subj_id is '利息科目编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.bus_breed_id is '业务品种编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.discnt_bus_kind_cd is '贴现业务种类代码';
comment on column ${icl_schema}.cmm_discnt_acct_info.bs_type_cd is '买卖类型代码';
comment on column ${icl_schema}.cmm_discnt_acct_info.bill_med_cd is '票据介质代码';
comment on column ${icl_schema}.cmm_discnt_acct_info.bill_type_cd is '票据类型代码';
comment on column ${icl_schema}.cmm_discnt_acct_info.bs_way_cd is '买卖方式代码';
comment on column ${icl_schema}.cmm_discnt_acct_info.clear_way_cd is '清算方式代码';
comment on column ${icl_schema}.cmm_discnt_acct_info.discnt_status_cd is '贴现状态代码';
comment on column ${icl_schema}.cmm_discnt_acct_info.int_adj_entry_cd is '利息调整记账代码';
comment on column ${icl_schema}.cmm_discnt_acct_info.pay_int_way_cd is '付息方式代码';
comment on column ${icl_schema}.cmm_discnt_acct_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_discnt_acct_info.oper_teller_id is '经办柜员编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.rgst_teller_id is '登记柜员编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.discnt_org_id is '贴现机构编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.draw_org_id is '出票机构编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.mgmt_org_id is '管理机构编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_discnt_acct_info.discnt_value_dt is '贴现起息日期';
comment on column ${icl_schema}.cmm_discnt_acct_info.discnt_exp_dt is '贴现到期日期';
comment on column ${icl_schema}.cmm_discnt_acct_info.draw_dt is '出票日期';
comment on column ${icl_schema}.cmm_discnt_acct_info.discnt_dt is '贴现日期';
comment on column ${icl_schema}.cmm_discnt_acct_info.discnt_flow_num is '贴现流水号';
comment on column ${icl_schema}.cmm_discnt_acct_info.close_dt is '关闭日期';
comment on column ${icl_schema}.cmm_discnt_acct_info.termnt_dt is '终止日期';
comment on column ${icl_schema}.cmm_discnt_acct_info.close_flow_num is '关闭流水号';
comment on column ${icl_schema}.cmm_discnt_acct_info.last_int_adj_day is '上一利息调整日';
comment on column ${icl_schema}.cmm_discnt_acct_info.next_int_adj_day is '下一利息调整日';
comment on column ${icl_schema}.cmm_discnt_acct_info.int_accr_days is '计息天数';
comment on column ${icl_schema}.cmm_discnt_acct_info.pay_int_amt is '付息金额';
comment on column ${icl_schema}.cmm_discnt_acct_info.int_recvbl is '应收利息';
comment on column ${icl_schema}.cmm_discnt_acct_info.int_adj_bal is '利息调整余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.wrt_off_amt is '核销金额';
comment on column ${icl_schema}.cmm_discnt_acct_info.fac_val_amt is '票面金额';
comment on column ${icl_schema}.cmm_discnt_acct_info.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_currt_bal is '折本币当期余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.ear_d_bal is '日初余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.ear_m_bal is '月初余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.ear_s_bal is '季初余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.ear_y_bal is '年初余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.y_acm_bal is '年累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.s_acm_bal is '季累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.m_acm_bal is '月累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_d_bal is '折本币日初余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_m_bal is '折本币月初余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_s_bal is '折本币季初余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_y_bal is '折本币年初余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_y_acm_bal is '折本币年累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_d_y_acm_bal is '折本币日初年累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_m_y_acm_bal is '折本币月初年累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_s_y_acm_bal is '折本币季初年累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_y_y_acm_bal is '折本币年初年累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_s_acm_bal is '折本币季累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_d_s_acm_bal is '折本币日初季累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_s_s_acm_bal is '折本币季初季累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_y_s_acm_bal is '折本币年初季累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_m_acm_bal is '折本币月累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_d_m_acm_bal is '折本币日初月累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_m_m_acm_bal is '折本币月初月累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_ear_y_m_acm_bal is '折本币年初月累计余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.y_avg_bal is '年日均余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.q_avg_bal is '季日均余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.m_avg_bal is '月日均余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_y_avg_bal is '折本币年日均余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_q_avg_bal is '折本币季日均余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.cl_curr_m_avg_bal is '折本币月日均余额';
comment on column ${icl_schema}.cmm_discnt_acct_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_discnt_acct_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_discnt_acct_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_discnt_acct_info.etl_timestamp is 'ETL处理时间戳';
