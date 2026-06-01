/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_cmm_ba_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_cmm_ba_acct_info
whenever sqlerror continue none;
drop table ${idl_schema}.aml_cmm_ba_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_cmm_ba_acct_info(
    etl_dt date          -- 数据日期
    ,lp_id varchar2(60)  -- 法人编号
    ,acct_id varchar2(60)  -- 账户编号
    ,bill_num varchar2(60)  -- 票据号码
    ,acpt_org_id varchar2(60)  -- 承兑机构编号
    ,stl_acct_num varchar2(60)  -- 结算账号
    ,subj_id varchar2(60)  -- 科目编号
    ,bill_med_cd varchar2(10)  -- 票据介质代码
    ,bill_type_cd varchar2(10)  -- 票据类型代码
    ,margin_acct_num varchar2(60)  -- 保证金账号
    ,margin_dep_term varchar2(10)  -- 保证金存期
    ,draw_dt date          -- 出票日期
    ,close_dt date          -- 关闭日期
    ,close_flow varchar2(60)  -- 关闭流水
    ,exp_dt date          -- 到期日期
    ,bill_status varchar2(10)  -- 票据状态
    ,close_way varchar2(10)  -- 关闭方式
    ,pymc_acct_num varchar2(60)  -- 备款账号
    ,pymc_dt date          -- 备款日期
    ,pymc_flow varchar2(60)  -- 备款流水
    ,pymc_way varchar2(10)  -- 备款方式
    ,advc_flg varchar2(10)  -- 垫款标志
    ,advc_dubil_id varchar2(60)  -- 垫款借据编号
    ,advc_exec_int_rat number(18,8)  -- 垫款执行利率
    ,advc_int_rat_cu_ratio number(18,6)  -- 垫款利率上浮比例
    ,int_rat_base_type_cd varchar2(30)  -- 利率基准类型代码
    ,fac_val_curr varchar2(10)  -- 票面币种
    ,margin_curr varchar2(10)  -- 保证金币种
    ,margin_ratio number(18,2)  -- 保证金比例
    ,margin_amt number(18,2)  -- 保证金金额
    ,advc_amt number(18,2)  -- 垫款金额
    ,comm_fee number(18,2)  -- 手续费
    ,fac_val_amt number(18,2)  -- 票面金额
    ,currt_bal number(30,2)  -- 当期余额
    ,cl_curr_currt_bal number(30,2)  -- 折本币当期余额
    ,ear_d_bal number(30,2)  -- 日初余额
    ,ear_m_bal number(30,2)  -- 月初余额
    ,ear_s_bal number(30,2)  -- 季初余额
    ,ear_y_bal number(30,2)  -- 年初余额
    ,y_acm_bal number(30,2)  -- 年累计余额
    ,s_acm_bal number(30,2)  -- 季累计余额
    ,m_acm_bal number(30,2)  -- 月累计余额
    ,cl_curr_ear_d_bal number(30,2)  -- 折本币日初余额
    ,cl_curr_ear_m_bal number(30,2)  -- 折本币月初余额
    ,cl_curr_ear_s_bal number(30,2)  -- 折本币季初余额
    ,cl_curr_ear_y_bal number(30,2)  -- 折本币年初余额
    ,cl_curr_y_acm_bal number(30,2)  -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal number(30,2)  -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal number(30,2)  -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal number(30,2)  -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal number(30,2)  -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal number(30,2)  -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal number(30,2)  -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal number(30,2)  -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal number(30,2)  -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal number(30,2)  -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal number(30,2)  -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal number(30,2)  -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal number(30,2)  -- 折本币年初月累计余额
    ,job_cd varchar2(10)  -- 任务代码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_cmm_ba_acct_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_cmm_ba_acct_info is '银承账户信息';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.lp_id is '法人编号';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.acct_id is '账户编号';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.bill_num is '票据号码';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.acpt_org_id is '承兑机构编号';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.stl_acct_num is '结算账号';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.subj_id is '科目编号';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.bill_med_cd is '票据介质代码';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.bill_type_cd is '票据类型代码';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.margin_acct_num is '保证金账号';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.margin_dep_term is '保证金存期';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.draw_dt is '出票日期';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.close_dt is '关闭日期';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.close_flow is '关闭流水';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.exp_dt is '到期日期';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.bill_status is '票据状态';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.close_way is '关闭方式';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.pymc_acct_num is '备款账号';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.pymc_dt is '备款日期';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.pymc_flow is '备款流水';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.pymc_way is '备款方式';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.advc_flg is '垫款标志';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.advc_dubil_id is '垫款借据编号';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.advc_exec_int_rat is '垫款执行利率';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.advc_int_rat_cu_ratio is '垫款利率上浮比例';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.int_rat_base_type_cd is '利率基准类型代码';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.fac_val_curr is '票面币种';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.margin_curr is '保证金币种';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.margin_ratio is '保证金比例';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.margin_amt is '保证金金额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.advc_amt is '垫款金额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.comm_fee is '手续费';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.fac_val_amt is '票面金额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.currt_bal is '当期余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_currt_bal is '折本币当期余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.ear_d_bal is '日初余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.ear_m_bal is '月初余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.ear_s_bal is '季初余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.ear_y_bal is '年初余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.y_acm_bal is '年累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.s_acm_bal is '季累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.m_acm_bal is '月累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_d_bal is '折本币日初余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_m_bal is '折本币月初余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_s_bal is '折本币季初余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_y_bal is '折本币年初余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_y_acm_bal is '折本币年累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_d_y_acm_bal is '折本币日初年累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_m_y_acm_bal is '折本币月初年累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_s_y_acm_bal is '折本币季初年累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_y_y_acm_bal is '折本币年初年累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_s_acm_bal is '折本币季累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_d_s_acm_bal is '折本币日初季累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_s_s_acm_bal is '折本币季初季累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_y_s_acm_bal is '折本币年初季累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_m_acm_bal is '折本币月累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_d_m_acm_bal is '折本币日初月累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_m_m_acm_bal is '折本币月初月累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.cl_curr_ear_y_m_acm_bal is '折本币年初月累计余额';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.job_cd is '任务代码';
comment on column ${idl_schema}.aml_cmm_ba_acct_info.etl_timestamp is 'ETL处理时间戳';