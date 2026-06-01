/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_cmm_lc_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_cmm_lc_acct_info
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_cmm_lc_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_cmm_lc_acct_info(
    etl_dt date -- 数据日期   
    ,lp_id varchar2(60) -- 法人编号   
    ,acct_id varchar2(60) -- 账户编号   
    ,lc_id varchar2(60) -- 信用证编号   
    ,issue_bank_lc_id varchar2(60) -- 开证行信用证编号   
    ,dubil_num varchar2(60) -- 借据号   
    ,cust_id varchar2(60) -- 客户编号   
    ,stl_acct_num varchar2(60) -- 结算帐号   
    ,subj_id varchar2(60) -- 科目编号   
    ,fwd_flg varchar2(10) -- 远期标志   
    ,circl_flg varchar2(10) -- 循环标志   
    ,mx_lc_flg varchar2(10) -- 进出口信用证标志   
    ,lc_type_cd varchar2(10) -- 信用证类型代码   
    ,lc_pay_type_cd varchar2(10) -- 信用证支付类型代码   
    ,issue_chn_cd varchar2(10) -- 开证渠道代码   
    ,bus_breed_id varchar2(60) -- 业务品种编号   
    ,lc_status_cd varchar2(10) -- 信用证状态代码   
    ,issue_bank_cfm_status_cd varchar2(10) -- 开证行保兑状态代码   
    ,curr_cd varchar2(10) -- 币种代码   
    ,oper_teller_id varchar2(60) -- 经办柜员编号   
    ,sign_org_id varchar2(60) -- 签署机构编号   
    ,mgmt_org_id varchar2(60) -- 管理机构编号   
    ,acct_instit_id varchar2(60) -- 账务机构编号   
    ,oper_org_id varchar2(60) -- 经办机构编号   
    ,effect_dt date -- 生效日期   
    ,wrtoff_dt date -- 注销日期   
    ,issue_dt date -- 开证日期   
    ,exp_dt date -- 到期日期   
    ,cfm_dt date -- 保兑日期   
    ,issue_bank_name varchar2(200) -- 开证行名称   
    ,advise_bank_name varchar2(200) -- 通知行名称   
    ,applit_name varchar2(200) -- 申请人名称   
    ,benefc_name varchar2(200) -- 受益人名称   
    ,benefc_cty_cd varchar2(60) -- 受益人国家代码   
    ,cargo_descb varchar2(4000) -- 货物描述   
    ,open_bank_name varchar2(200) -- 代开行名称   
    ,fwd_tenor number(10, 0) -- 远期期限   
    ,comm_fee_rat number(18,6) -- 手续费费率   
    ,comm_fee_amt number(30,2) -- 手续费金额   
    ,lc_higt_lmt number(30,2) -- 信用证最高限额   
    ,issue_amt number(30,2) -- 开证金额   
    ,acpty_bal number(30,2) -- 可承兑余额   
    ,lc_bal number(30,2) -- 信用证余额   
    ,cl_curr_lc_bal number(30,2) -- 折本币信用证余额   
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
    ,job_cd varchar2(10) -- 任务代码 
    ,std_prod_id          varchar2(60)     --标准产品编号      
    ,issue_bank_cn_name   varchar2(100)    --开证行中文名称     
    ,issue_bank_swiftcode varchar2(60)     --开证行swiftcode
    ,acpty_tot            number(30,2)     --可承兑总额       
    ,y_avg_bal            number(30,2)     --年日均余额       
    ,q_avg_bal            number(30,2)     --季日均余额       
    ,m_avg_bal            number(30,2)     --月日均余额       
    ,cl_curr_y_avg_bal    number(30,2)     --折本币年日均余额    
    ,cl_curr_q_avg_bal    number(30,2)     --折本币季日均余额    
    ,cl_curr_m_avg_bal    number(30,2)     --折本币月日均余额      
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_cmm_lc_acct_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_cmm_lc_acct_info is '信用证账户信息';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.acct_id is '账户编号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.lc_id is '信用证编号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.issue_bank_lc_id is '开证行信用证编号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.dubil_num is '借据号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cust_id is '客户编号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.stl_acct_num is '结算帐号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.subj_id is '科目编号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.fwd_flg is '远期标志';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.circl_flg is '循环标志';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.mx_lc_flg is '进出口信用证标志';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.lc_type_cd is '信用证类型代码';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.lc_pay_type_cd is '信用证支付类型代码';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.issue_chn_cd is '开证渠道代码';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.bus_breed_id is '业务品种编号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.lc_status_cd is '信用证状态代码';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.issue_bank_cfm_status_cd is '开证行保兑状态代码';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.curr_cd is '币种代码';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.oper_teller_id is '经办柜员编号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.sign_org_id is '签署机构编号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.mgmt_org_id is '管理机构编号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.acct_instit_id is '账务机构编号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.oper_org_id is '经办机构编号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.effect_dt is '生效日期';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.wrtoff_dt is '注销日期';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.issue_dt is '开证日期';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.exp_dt is '到期日期';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cfm_dt is '保兑日期';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.issue_bank_name is '开证行名称';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.advise_bank_name is '通知行名称';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.applit_name is '申请人名称';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.benefc_name is '受益人名称';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.benefc_cty_cd is '受益人国家代码';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cargo_descb is '货物描述';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.open_bank_name is '代开行名称';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.fwd_tenor is '远期期限';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.comm_fee_rat is '手续费费率';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.comm_fee_amt is '手续费金额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.lc_higt_lmt is '信用证最高限额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.issue_amt is '开证金额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.acpty_bal is '可承兑余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.lc_bal is '信用证余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_lc_bal is '折本币信用证余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.ear_d_bal is '日初余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.ear_m_bal is '月初余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.ear_s_bal is '季初余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.ear_y_bal is '年初余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.y_acm_bal is '年累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.s_acm_bal is '季累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.m_acm_bal is '月累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_d_bal is '折本币日初余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_m_bal is '折本币月初余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_s_bal is '折本币季初余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_y_bal is '折本币年初余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_y_acm_bal is '折本币年累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_d_y_acm_bal is '折本币日初年累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_m_y_acm_bal is '折本币月初年累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_s_y_acm_bal is '折本币季初年累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_y_y_acm_bal is '折本币年初年累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_s_acm_bal is '折本币季累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_d_s_acm_bal is '折本币日初季累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_s_s_acm_bal is '折本币季初季累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_y_s_acm_bal is '折本币年初季累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_m_acm_bal is '折本币月累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_d_m_acm_bal is '折本币日初月累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_m_m_acm_bal is '折本币月初月累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_ear_y_m_acm_bal is '折本币年初月累计余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.etl_timestamp is '数据处理时间';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.std_prod_id is '标准产品编号';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.issue_bank_cn_name is '开证行中文名称';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.issue_bank_swiftcode is '开证行swiftcode';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.acpty_tot is '可承兑总额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.y_avg_bal is '年日均余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.q_avg_bal is '季日均余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.m_avg_bal is '月日均余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_y_avg_bal is '折本币年日均余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_q_avg_bal is '折本币季日均余额';
comment on column ${idl_schema}.icrm_cmm_lc_acct_info.cl_curr_m_avg_bal is '折本币月日均余额';
