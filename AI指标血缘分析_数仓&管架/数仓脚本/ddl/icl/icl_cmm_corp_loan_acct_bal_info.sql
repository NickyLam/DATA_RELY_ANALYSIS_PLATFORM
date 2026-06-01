/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_corp_loan_acct_bal_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_corp_loan_acct_bal_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_loan_acct_bal_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_acct_bal_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,dubil_num varchar2(60) -- 借据号
    ,loan_num varchar2(60) -- 贷款号
    ,std_prod_id varchar2(500) -- 标准产品编号
    ,acru_non_acru_cd varchar2(10) -- 应计非应计代码
    ,dubil_amt number(30,2) -- 借据金额
    ,nomal_pric number(30,2) -- 正常本金
    ,ovdue_pric number(30,2) -- 逾期本金
    ,idle_pric number(30,2) -- 呆滞本金
    ,bad_debt_pric number(30,2) -- 呆账本金
    ,wrt_off_pric number(30,2) -- 核销本金
    ,wrt_off_int number(30,2) -- 核销利息
    ,in_bs_int number(30,2) -- 表内利息
    ,off_bs_int number(30,2) -- 表外利息
    ,pric_bal number(30,2) -- 本金余额
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
    ,nomal_pric_y_acm_bal number(30,2) -- 正常本金年累计余额
    ,nomal_pric_s_acm_bal number(30,2) -- 正常本金季累计余额
    ,nomal_pric_m_acm_bal number(30,2) -- 正常本金月累计余额
    ,nomal_pric_cl_curr_y_acm_bal number(30,2) -- 正常本金折本币年累计余额
    ,nomal_pric_cl_curr_s_acm_bal number(30,2) -- 正常本金折本币季累计余额
    ,nomal_pric_cl_curr_m_acm_bal number(30,2) -- 正常本金折本币月累计余额
    ,nomal_pric_y_avg_bal number(30,2) -- 正常本金年日均余额
    ,nomal_pric_q_avg_bal number(30,2) -- 正常本金季日均余额
    ,nomal_pric_m_avg_bal number(30,2) -- 正常本金月日均余额
    ,nomal_pric_cl_curr_y_avg_bal number(30,2) -- 正常本金折本币年日均余额
    ,nomal_pric_cl_curr_q_avg_bal number(30,2) -- 正常本金折本币季日均余额
    ,nomal_pric_cl_curr_m_avg_bal number(30,2) -- 正常本金折本币月日均余额
    ,ovdue_pric_y_acm_bal number(30,2) -- 逾期本金年累计余额
    ,ovdue_pric_s_acm_bal number(30,2) -- 逾期本金季累计余额
    ,ovdue_pric_m_acm_bal number(30,2) -- 逾期本金月累计余额
    ,ovdue_pric_cl_curr_y_acm_bal number(30,2) -- 逾期本金折本币年累计余额
    ,ovdue_pric_cl_curr_s_acm_bal number(30,2) -- 逾期本金折本币季累计余额
    ,ovdue_pric_cl_curr_m_acm_bal number(30,2) -- 逾期本金折本币月累计余额
    ,ovdue_pric_y_avg_bal number(30,2) -- 逾期本金年日均余额
    ,ovdue_pric_q_avg_bal number(30,2) -- 逾期本金季日均余额
    ,ovdue_pric_m_avg_bal number(30,2) -- 逾期本金月日均余额
    ,ovdue_pric_cl_curr_y_avg_bal number(30,2) -- 逾期本金折本币年日均余额
    ,ovdue_pric_cl_curr_q_avg_bal number(30,2) -- 逾期本金折本币季日均余额
    ,ovdue_pric_cl_curr_m_avg_bal number(30,2) -- 逾期本金折本币月日均余额
    ,idle_pric_y_acm_bal number(30,2) -- 呆滞本金年累计余额
    ,idle_pric_s_acm_bal number(30,2) -- 呆滞本金季累计余额
    ,idle_pric_m_acm_bal number(30,2) -- 呆滞本金月累计余额
    ,idle_pric_cl_curr_y_acm_bal number(30,2) -- 呆滞本金折本币年累计余额
    ,idle_pric_cl_curr_s_acm_bal number(30,2) -- 呆滞本金折本币季累计余额
    ,idle_pric_cl_curr_m_acm_bal number(30,2) -- 呆滞本金折本币月累计余额
    ,idle_pric_y_avg_bal number(30,2) -- 呆滞本金年日均余额
    ,idle_pric_q_avg_bal number(30,2) -- 呆滞本金季日均余额
    ,idle_pric_m_avg_bal number(30,2) -- 呆滞本金月日均余额
    ,idle_pric_dc_y_avg_bal number(30,2) -- 呆滞本金本币年日均余额
    ,idle_pric_dc_q_avg_bal number(30,2) -- 呆滞本金本币季日均余额
    ,idle_pric_dc_m_avg_bal number(30,2) -- 呆滞本金本币月日均余额
    ,bad_debt_pric_y_acm_bal number(30,2) -- 呆账本金年累计余额
    ,bad_debt_pric_s_acm_bal number(30,2) -- 呆账本金季累计余额
    ,bad_debt_pric_m_acm_bal number(30,2) -- 呆账本金月累计余额
    ,bad_debt_cl_curr_y_acm_bal number(30,2) -- 呆账本金折本币年累计余额
    ,bad_debt_cl_curr_s_acm_bal number(30,2) -- 呆账本金折本币季累计余额
    ,bad_debt_cl_curr_m_acm_bal number(30,2) -- 呆账本金折本币月累计余额
    ,bad_debt_pric_y_avg_bal number(30,2) -- 呆账本金年日均余额
    ,bad_debt_pric_q_avg_bal number(30,2) -- 呆账本金季日均余额
    ,bad_debt_pric_m_avg_bal number(30,2) -- 呆账本金月日均余额
    ,bad_debt_pric_dc_y_avg_bal number(30,2) -- 呆账本金本币年日均余额
    ,bad_debt_pric_dc_q_avg_bal number(30,2) -- 呆账本金本币季日均余额
    ,bad_debt_pric_dc_m_avg_bal number(30,2) -- 呆账本金本币月日均余额
    ,in_bs_int_y_acm_bal number(30,2) -- 表内利息年累计余额
    ,in_bs_int_s_acm_bal number(30,2) -- 表内利息季累计余额
    ,in_bs_int_m_acm_bal number(30,2) -- 表内利息月累计余额
    ,in_bs_int_cl_curr_y_acm_bal number(30,2) -- 表内利息折本币年累计余额
    ,in_bs_int_cl_curr_s_acm_bal number(30,2) -- 表内利息折本币季累计余额
    ,in_bs_int_cl_curr_m_acm_bal number(30,2) -- 表内利息折本币月累计余额
    ,in_bs_int_y_avg_bal number(30,2) -- 表内利息年日均余额
    ,in_bs_int_q_avg_bal number(30,2) -- 表内利息季日均余额
    ,in_bs_int_m_avg_bal number(30,2) -- 表内利息月日均余额
    ,in_bs_int_dc_y_avg_bal number(30,2) -- 表内利息本币年日均余额
    ,in_bs_int_dc_q_avg_bal number(30,2) -- 表内利息本币季日均余额
    ,in_bs_int_dc_m_avg_bal number(30,2) -- 表内利息本币月日均余额
    ,off_bs_int_y_acm_bal number(30,2) -- 表外利息年累计余额
    ,off_bs_int_s_acm_bal number(30,2) -- 表外利息季累计余额
    ,off_bs_int_m_acm_bal number(30,2) -- 表外利息月累计余额
    ,off_bs_int_cl_curr_y_acm_bal number(30,2) -- 表外利息折本币年累计余额
    ,off_bs_int_cl_curr_s_acm_bal number(30,2) -- 表外利息折本币季累计余额
    ,off_bs_int_cl_curr_m_acm_bal number(30,2) -- 表外利息折本币月累计余额
    ,off_bs_int_y_avg_bal number(30,2) -- 表外利息年日均余额
    ,off_bs_int_q_avg_bal number(30,2) -- 表外利息季日均余额
    ,off_bs_int_m_avg_bal number(30,2) -- 表外利息月日均余额
    ,off_bs_int_dc_y_avg_bal number(30,2) -- 表外利息本币年日均余额
    ,off_bs_int_dc_q_avg_bal number(30,2) -- 表外利息本币季日均余额
    ,off_bs_int_dc_m_avg_bal number(30,2) -- 表外利息本币月日均余额
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
grant select on ${icl_schema}.cmm_corp_loan_acct_bal_info to ${idl_schema};
grant select on ${icl_schema}.cmm_corp_loan_acct_bal_info to ${iel_schema};
grant select on ${icl_schema}.cmm_corp_loan_acct_bal_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_corp_loan_acct_bal_info is '对公贷款账户余额信息';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.dubil_num is '借据号';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.loan_num is '贷款号';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.acru_non_acru_cd is '应计非应计代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.dubil_amt is '借据金额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.nomal_pric is '正常本金';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ovdue_pric is '逾期本金';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.idle_pric is '呆滞本金';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.bad_debt_pric is '呆账本金';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.wrt_off_pric is '核销本金';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.wrt_off_int is '核销利息';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.in_bs_int is '表内利息';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.off_bs_int is '表外利息';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.pric_bal is '本金余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_currt_bal is '折本币当期余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ear_d_bal is '日初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ear_m_bal is '月初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ear_s_bal is '季初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ear_y_bal is '年初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.y_acm_bal is '年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.s_acm_bal is '季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.m_acm_bal is '月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_d_bal is '折本币日初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_m_bal is '折本币月初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_s_bal is '折本币季初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_y_bal is '折本币年初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_y_acm_bal is '折本币年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_d_y_acm_bal is '折本币日初年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_m_y_acm_bal is '折本币月初年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_s_y_acm_bal is '折本币季初年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_y_y_acm_bal is '折本币年初年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_s_acm_bal is '折本币季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_d_s_acm_bal is '折本币日初季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_s_s_acm_bal is '折本币季初季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_y_s_acm_bal is '折本币年初季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_m_acm_bal is '折本币月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_d_m_acm_bal is '折本币日初月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_m_m_acm_bal is '折本币月初月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_ear_y_m_acm_bal is '折本币年初月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.y_avg_bal is '年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.q_avg_bal is '季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.m_avg_bal is '月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_y_avg_bal is '折本币年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_q_avg_bal is '折本币季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.cl_curr_m_avg_bal is '折本币月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.nomal_pric_y_acm_bal is '正常本金年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.nomal_pric_s_acm_bal is '正常本金季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.nomal_pric_m_acm_bal is '正常本金月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.nomal_pric_cl_curr_y_acm_bal is '正常本金折本币年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.nomal_pric_cl_curr_s_acm_bal is '正常本金折本币季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.nomal_pric_cl_curr_m_acm_bal is '正常本金折本币月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.nomal_pric_y_avg_bal is '正常本金年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.nomal_pric_q_avg_bal is '正常本金季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.nomal_pric_m_avg_bal is '正常本金月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.nomal_pric_cl_curr_y_avg_bal is '正常本金折本币年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.nomal_pric_cl_curr_q_avg_bal is '正常本金折本币季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.nomal_pric_cl_curr_m_avg_bal is '正常本金折本币月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ovdue_pric_y_acm_bal is '逾期本金年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ovdue_pric_s_acm_bal is '逾期本金季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ovdue_pric_m_acm_bal is '逾期本金月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ovdue_pric_cl_curr_y_acm_bal is '逾期本金折本币年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ovdue_pric_cl_curr_s_acm_bal is '逾期本金折本币季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ovdue_pric_cl_curr_m_acm_bal is '逾期本金折本币月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ovdue_pric_y_avg_bal is '逾期本金年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ovdue_pric_q_avg_bal is '逾期本金季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ovdue_pric_m_avg_bal is '逾期本金月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ovdue_pric_cl_curr_y_avg_bal is '逾期本金折本币年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ovdue_pric_cl_curr_q_avg_bal is '逾期本金折本币季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.ovdue_pric_cl_curr_m_avg_bal is '逾期本金折本币月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.idle_pric_y_acm_bal is '呆滞本金年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.idle_pric_s_acm_bal is '呆滞本金季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.idle_pric_m_acm_bal is '呆滞本金月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.idle_pric_cl_curr_y_acm_bal is '呆滞本金折本币年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.idle_pric_cl_curr_s_acm_bal is '呆滞本金折本币季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.idle_pric_cl_curr_m_acm_bal is '呆滞本金折本币月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.idle_pric_y_avg_bal is '呆滞本金年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.idle_pric_q_avg_bal is '呆滞本金季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.idle_pric_m_avg_bal is '呆滞本金月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.idle_pric_dc_y_avg_bal is '呆滞本金本币年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.idle_pric_dc_q_avg_bal is '呆滞本金本币季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.idle_pric_dc_m_avg_bal is '呆滞本金本币月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.bad_debt_pric_y_acm_bal is '呆账本金年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.bad_debt_pric_s_acm_bal is '呆账本金季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.bad_debt_pric_m_acm_bal is '呆账本金月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.bad_debt_cl_curr_y_acm_bal is '呆账本金折本币年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.bad_debt_cl_curr_s_acm_bal is '呆账本金折本币季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.bad_debt_cl_curr_m_acm_bal is '呆账本金折本币月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.bad_debt_pric_y_avg_bal is '呆账本金年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.bad_debt_pric_q_avg_bal is '呆账本金季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.bad_debt_pric_m_avg_bal is '呆账本金月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.bad_debt_pric_dc_y_avg_bal is '呆账本金本币年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.bad_debt_pric_dc_q_avg_bal is '呆账本金本币季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.bad_debt_pric_dc_m_avg_bal is '呆账本金本币月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.in_bs_int_y_acm_bal is '表内利息年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.in_bs_int_s_acm_bal is '表内利息季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.in_bs_int_m_acm_bal is '表内利息月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.in_bs_int_cl_curr_y_acm_bal is '表内利息折本币年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.in_bs_int_cl_curr_s_acm_bal is '表内利息折本币季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.in_bs_int_cl_curr_m_acm_bal is '表内利息折本币月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.in_bs_int_y_avg_bal is '表内利息年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.in_bs_int_q_avg_bal is '表内利息季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.in_bs_int_m_avg_bal is '表内利息月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.in_bs_int_dc_y_avg_bal is '表内利息本币年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.in_bs_int_dc_q_avg_bal is '表内利息本币季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.in_bs_int_dc_m_avg_bal is '表内利息本币月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.off_bs_int_y_acm_bal is '表外利息年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.off_bs_int_s_acm_bal is '表外利息季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.off_bs_int_m_acm_bal is '表外利息月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.off_bs_int_cl_curr_y_acm_bal is '表外利息折本币年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.off_bs_int_cl_curr_s_acm_bal is '表外利息折本币季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.off_bs_int_cl_curr_m_acm_bal is '表外利息折本币月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.off_bs_int_y_avg_bal is '表外利息年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.off_bs_int_q_avg_bal is '表外利息季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.off_bs_int_m_avg_bal is '表外利息月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.off_bs_int_dc_y_avg_bal is '表外利息本币年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.off_bs_int_dc_q_avg_bal is '表外利息本币季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.off_bs_int_dc_m_avg_bal is '表外利息本币月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_corp_loan_acct_bal_info.etl_timestamp is 'ETL处理时间戳';
