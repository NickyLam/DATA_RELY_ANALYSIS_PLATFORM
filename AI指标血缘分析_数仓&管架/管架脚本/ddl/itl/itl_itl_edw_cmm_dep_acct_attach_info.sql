/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_cmm_dep_acct_attach_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_cmm_dep_acct_attach_info
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_cmm_dep_acct_attach_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_cmm_dep_acct_attach_info(
    lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,acct_name varchar2(150) -- 账户名称
    ,cust_id varchar2(60) -- 客户编号
    ,src_agt_id varchar2(100) -- 源协议编号
    ,fx_acct_char_cd varchar2(10) -- 外汇账户性质代码
    ,agt_dep_type_cd varchar2(30) -- 协议存款类型代码
    ,acct_lics_num varchar2(60) -- 账户许可证号
    ,acct_lics_issue_dt date -- 账户许可证签发日期
    ,cap_char_cd varchar2(10) -- 资金性质代码
    ,acct_close_rs_descb varchar2(500) -- 账户关闭原因描述
    ,l_six_m_no_tran_flg varchar2(10) -- 六个月无交易标志
    ,supv_type_cd varchar2(30) -- 监管类型代码
    ,xhc_flg varchar2(10) -- 兴惠存标志
    ,long_hang_amt number(18,2) -- 久悬金额
    ,init_open_acct_dt date -- 原始开户日期
    ,init_exp_dt date -- 原始到期日期
    ,sub_acct_int_rat_float_ratio number(30,8) -- 协定存款利率浮动比例
    ,sub_acct_int_rat_float_point number(30,8) -- 协定存款利率浮动点数
    ,delay_pay_int_int_float_point number(30,8) -- 延期付息利息浮动点
    ,txy_main_agt_files_int_rat number(30,8) -- 同兴赢主协议超档利率
    ,txy_sub_agt_agree_int_rat number(30,8) -- 同兴赢子协议协定利率
    ,cap_pool_agt_rat number(30,8) -- 资金池协议利率
    ,cert_print_flg varchar2(10) -- 证实书打印标志
    ,precon_wdraw_flg varchar2(10) -- 预约支取标志
    ,precon_wdraw_dt date -- 预约支取日期
    ,apot_tenor_start_dt date -- 约期开始日期
    ,apot_tenor_end_dt date -- 约期结束日期
    ,heat_insu_acct_flg varchar2(10) -- 医保账户标志
    ,travel_card_acct_flg varchar2(10) -- 旅行通账户标志
    ,soci_secu_fin_acct_flg varchar2(10) -- 社保卡下金融账户标志
    ,supv_idf_set_dt date -- 监管标识设置日期
    ,supv_idf_cancel_dt date -- 监管标识取消日期
    ,int_rat_apv_form_odd_no varchar2(100) -- 利率审批单单号
    ,etl_dt date -- ETL处理日期
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
grant select on ${itl_schema}.itl_edw_cmm_dep_acct_attach_info to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_cmm_dep_acct_attach_info is '存款分户补充信息';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.acct_id is '账户编号';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.acct_name is '账户名称';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.cust_id is '客户编号';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.src_agt_id is '源协议编号';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.fx_acct_char_cd is '外汇账户性质代码';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.agt_dep_type_cd is '协议存款类型代码';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.acct_lics_num is '账户许可证号';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.acct_lics_issue_dt is '账户许可证签发日期';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.cap_char_cd is '资金性质代码';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.acct_close_rs_descb is '账户关闭原因描述';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.l_six_m_no_tran_flg is '六个月无交易标志';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.supv_type_cd is '监管类型代码';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.xhc_flg is '兴惠存标志';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.long_hang_amt is '久悬金额';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.init_open_acct_dt is '原始开户日期';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.init_exp_dt is '原始到期日期';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.sub_acct_int_rat_float_ratio is '协定存款利率浮动比例';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.sub_acct_int_rat_float_point is '协定存款利率浮动点数';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.delay_pay_int_int_float_point is '延期付息利息浮动点';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.txy_main_agt_files_int_rat is '同兴赢主协议超档利率';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.txy_sub_agt_agree_int_rat is '同兴赢子协议协定利率';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.cap_pool_agt_rat is '资金池协议利率';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.cert_print_flg is '证实书打印标志';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.precon_wdraw_flg is '预约支取标志';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.precon_wdraw_dt is '预约支取日期';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.apot_tenor_start_dt is '约期开始日期';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.apot_tenor_end_dt is '约期结束日期';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.heat_insu_acct_flg is '医保账户标志';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.travel_card_acct_flg is '旅行通账户标志';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.soci_secu_fin_acct_flg is '社保卡下金融账户标志';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.supv_idf_set_dt is '监管标识设置日期';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.supv_idf_cancel_dt is '监管标识取消日期';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.int_rat_apv_form_odd_no is '利率审批单单号';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_cmm_dep_acct_attach_info.etl_timestamp is 'ETL处理时间戳';
