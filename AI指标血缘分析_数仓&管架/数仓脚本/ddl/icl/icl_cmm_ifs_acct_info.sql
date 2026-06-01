/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_ifs_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_ifs_acct_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ifs_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ifs_acct_info(
    etl_dt date -- 数据日期
    ,cl_curr_ear_s_s_acm_bal number(30,2) -- 折本币季初季累计余额
    ,lp_id varchar2(60) -- 法人编号
    ,cl_curr_ear_y_s_acm_bal number(30,2) -- 折本币年初季累计余额
    ,cust_acct_sub_acct_num varchar2(10) -- 客户账户子户号
    ,cl_curr_m_acm_bal number(30,2) -- 折本币月累计余额
    ,cust_acct_id varchar2(60) -- 客户账户编号
    ,cl_curr_ear_d_m_acm_bal number(30,2) -- 折本币日初月累计余额
    ,acct_name varchar2(150) -- 账户名称
    ,cl_curr_ear_m_m_acm_bal number(30,2) -- 折本币月初月累计余额
    ,cust_id varchar2(60) -- 客户编号
    ,cl_curr_ear_y_m_acm_bal number(30,2) -- 折本币年初月累计余额
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,y_avg_bal number(30,2) -- 年日均余额
    ,prod_id varchar2(60) -- 产品编号
    ,q_avg_bal number(30,2) -- 季日均余额
    ,bind_webank_card_no varchar2(100) -- 绑定微众银行卡号
    ,m_avg_bal number(30,2) -- 月日均余额
    ,subj_id varchar2(10) -- 科目编号
    ,cl_curr_y_avg_bal number(30,2) -- 折本币年日均余额
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,cl_curr_q_avg_bal number(30,2) -- 折本币季日均余额
    ,ext_prod_id varchar2(100) -- 外部产品编号
    ,cl_curr_m_avg_bal number(30,2) -- 折本币月日均余额
    ,dep_acct_status_cd varchar2(10) -- 存款账户状态代码
    ,job_cd varchar2(10) -- 任务代码
    ,acpt_pay_status_cd varchar2(10) -- 收付状态代码
    ,etl_timestamp timestamp -- 数据处理时间
    ,froz_status_cd varchar2(10) -- 冻结状态代码
    ,stop_pay_status_cd varchar2(10) -- 止付状态代码
    ,dep_term varchar2(15) -- 存期
    ,sav_type_cd varchar2(10) -- 储种代码
    ,exec_int_rat_cate_cd varchar2(10) -- 执行利率类别代码
    ,pa_ext_int_rat_cate_cd varchar2(10) -- 部提利率类别代码
    ,ovdue_int_rat_cate_cd varchar2(10) -- 逾期利率类别代码
    ,base_rat_type_cd varchar2(10) -- 基准利率类型代码
    ,int_set_way_cd varchar2(10) -- 结息方式代码
    ,int_accr_way_cd varchar2(10) -- 计息方式代码
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,corp_acct_flg varchar2(10) -- 对公账户标志
    ,rc_flg varchar2(10) -- 定活标志
    ,web_dep_flg varchar2(10) -- 网络存款标志
    ,int_accr_flg varchar2(10) -- 计息标志
    ,part_draw_cnt number(10) -- 部分提取次数
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,open_acct_teller_id varchar2(60) -- 开户柜员编号
    ,open_acct_flow_num varchar2(60) -- 开户流水号
    ,open_acct_chn_cd varchar2(10) -- 开户渠道代码
    ,open_acct_dt date -- 开户日期
    ,open_acct_tm timestamp(6) -- 开户时间
    ,close_acct_org_id varchar2(60) -- 销户机构编号
    ,clos_acct_teller_id varchar2(60) -- 销户柜员编号
    ,clos_acct_flow_num varchar2(60) -- 销户流水号
    ,clos_acct_dt date -- 销户日期
    ,clos_acct_tm timestamp(6) -- 销户时间
    ,acct_dt date -- 账务日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,final_activ_acct_dt date -- 最后动户日期
    ,last_int_set_dt date -- 上次结息日期
    ,next_int_set_dt date -- 下次结息日期
    ,fir_value_dt date -- 首次起息日期
    ,base_rat number(18,8) -- 基准利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,int_rat_flo_val number(18,6) -- 利率浮动值
    ,curr_cd varchar2(10) -- 币种代码
    ,td_acru_int number(30,8) -- 当日应计利息
    ,currt_acru_int number(30,8) -- 当期应计利息
    ,currt_bal number(18,2) -- 当期余额
    ,froz_amt number(18,2) -- 冻结金额
    ,aval_bal number(18,2) -- 可用余额
    ,stop_pay_amt number(18,2) -- 止付金额
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
grant select on ${icl_schema}.cmm_ifs_acct_info to ${idl_schema};
grant select on ${icl_schema}.cmm_ifs_acct_info to ${iel_schema};
grant select on ${icl_schema}.cmm_ifs_acct_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_ifs_acct_info is '联合存款分户信息';
comment on column ${icl_schema}.cmm_ifs_acct_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_s_s_acm_bal is '折本币季初季累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_y_s_acm_bal is '折本币年初季累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cust_acct_sub_acct_num is '客户账户子户号';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_m_acm_bal is '折本币月累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cust_acct_id is '客户账户编号';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_d_m_acm_bal is '折本币日初月累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_m_m_acm_bal is '折本币月初月累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_y_m_acm_bal is '折本币年初月累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_ifs_acct_info.y_avg_bal is '年日均余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_ifs_acct_info.q_avg_bal is '季日均余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.bind_webank_card_no is '绑定微众银行卡号';
comment on column ${icl_schema}.cmm_ifs_acct_info.m_avg_bal is '月日均余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_y_avg_bal is '折本币年日均余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cust_type_cd is '客户类型代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_q_avg_bal is '折本币季日均余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.ext_prod_id is '外部产品编号';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_m_avg_bal is '折本币月日均余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.dep_acct_status_cd is '存款账户状态代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.acpt_pay_status_cd is '收付状态代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.etl_timestamp is '数据处理时间';
comment on column ${icl_schema}.cmm_ifs_acct_info.froz_status_cd is '冻结状态代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.stop_pay_status_cd is '止付状态代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.dep_term is '存期';
comment on column ${icl_schema}.cmm_ifs_acct_info.sav_type_cd is '储种代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.exec_int_rat_cate_cd is '执行利率类别代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.pa_ext_int_rat_cate_cd is '部提利率类别代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.ovdue_int_rat_cate_cd is '逾期利率类别代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.base_rat_type_cd is '基准利率类型代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.int_set_way_cd is '结息方式代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.int_accr_way_cd is '计息方式代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.corp_acct_flg is '对公账户标志';
comment on column ${icl_schema}.cmm_ifs_acct_info.rc_flg is '定活标志';
comment on column ${icl_schema}.cmm_ifs_acct_info.web_dep_flg is '网络存款标志';
comment on column ${icl_schema}.cmm_ifs_acct_info.int_accr_flg is '计息标志';
comment on column ${icl_schema}.cmm_ifs_acct_info.part_draw_cnt is '部分提取次数';
comment on column ${icl_schema}.cmm_ifs_acct_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_ifs_acct_info.open_acct_org_id is '开户机构编号';
comment on column ${icl_schema}.cmm_ifs_acct_info.open_acct_teller_id is '开户柜员编号';
comment on column ${icl_schema}.cmm_ifs_acct_info.open_acct_flow_num is '开户流水号';
comment on column ${icl_schema}.cmm_ifs_acct_info.open_acct_chn_cd is '开户渠道代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.open_acct_dt is '开户日期';
comment on column ${icl_schema}.cmm_ifs_acct_info.open_acct_tm is '开户时间';
comment on column ${icl_schema}.cmm_ifs_acct_info.close_acct_org_id is '销户机构编号';
comment on column ${icl_schema}.cmm_ifs_acct_info.clos_acct_teller_id is '销户柜员编号';
comment on column ${icl_schema}.cmm_ifs_acct_info.clos_acct_flow_num is '销户流水号';
comment on column ${icl_schema}.cmm_ifs_acct_info.clos_acct_dt is '销户日期';
comment on column ${icl_schema}.cmm_ifs_acct_info.clos_acct_tm is '销户时间';
comment on column ${icl_schema}.cmm_ifs_acct_info.acct_dt is '账务日期';
comment on column ${icl_schema}.cmm_ifs_acct_info.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_ifs_acct_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_ifs_acct_info.final_activ_acct_dt is '最后动户日期';
comment on column ${icl_schema}.cmm_ifs_acct_info.last_int_set_dt is '上次结息日期';
comment on column ${icl_schema}.cmm_ifs_acct_info.next_int_set_dt is '下次结息日期';
comment on column ${icl_schema}.cmm_ifs_acct_info.fir_value_dt is '首次起息日期';
comment on column ${icl_schema}.cmm_ifs_acct_info.base_rat is '基准利率';
comment on column ${icl_schema}.cmm_ifs_acct_info.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_ifs_acct_info.int_rat_flo_val is '利率浮动值';
comment on column ${icl_schema}.cmm_ifs_acct_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_ifs_acct_info.td_acru_int is '当日应计利息';
comment on column ${icl_schema}.cmm_ifs_acct_info.currt_acru_int is '当期应计利息';
comment on column ${icl_schema}.cmm_ifs_acct_info.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.froz_amt is '冻结金额';
comment on column ${icl_schema}.cmm_ifs_acct_info.aval_bal is '可用余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.stop_pay_amt is '止付金额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_currt_bal is '折本币当期余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.ear_d_bal is '日初余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.ear_m_bal is '月初余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.ear_s_bal is '季初余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.ear_y_bal is '年初余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.y_acm_bal is '年累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.s_acm_bal is '季累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.m_acm_bal is '月累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_d_bal is '折本币日初余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_m_bal is '折本币月初余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_s_bal is '折本币季初余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_y_bal is '折本币年初余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_y_acm_bal is '折本币年累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_d_y_acm_bal is '折本币日初年累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_m_y_acm_bal is '折本币月初年累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_s_y_acm_bal is '折本币季初年累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_y_y_acm_bal is '折本币年初年累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_s_acm_bal is '折本币季累计余额';
comment on column ${icl_schema}.cmm_ifs_acct_info.cl_curr_ear_d_s_acm_bal is '折本币日初季累计余额';
--comment on column ${icl_schema}.cmm_ifs_acct_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_ifs_acct_info.etl_timestamp is 'ETL处理时间戳';
