/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdws_a_chnl_process_index_statis
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdws_a_chnl_process_index_statis
whenever sqlerror continue none;
drop table ${iol_schema}.bdws_a_chnl_process_index_statis purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdws_a_chnl_process_index_statis(
    etl_dt_ora varchar2(4000) -- 数据日期
    ,execut_org_id varchar2(4000) -- 管户/共管机构编号
    ,execut_org_name varchar2(4000) -- 管户/共管机构名称
    ,execut_type varchar2(4000) -- 管户类型
    ,execut_clerk_id varchar2(4000) -- 管户/共管人员工号
    ,execut_clerk_name varchar2(4000) -- 管户/共管人名称
    ,cust_id varchar2(4000) -- 客户号
    ,open_acct_dt varchar2(4000) -- 开户时间
    ,monthly_act_examine varchar2(4000) -- 是否满足月活考核口径
    ,mobile_bank_open varchar2(4000) -- 是否开通手机银行
    ,mobile_bank_login_m varchar2(4000) -- 当月是否登录手机银行
    ,fin_risk_sign varchar2(4000) -- 是否签约理财风评
    ,bind_card_examine varchar2(4000) -- 是否符合绑卡考核口径
    ,wct_bank_bind varchar2(4000) -- 是否绑定微信银行
    ,quick_pay_bind varchar2(4000) -- 是否绑定快捷支付
    ,cust_acct_nature varchar2(4000) -- 客户账户性质
    ,new_open_y varchar2(4000) -- 是否当年内新开户
    ,if_message_sign varchar2(4000) -- 是否同意接收营销短信
    ,aum_m_avg_bal number(22,6) -- 客户aum月日均
    ,aum_acct_bal number(22,6) -- 客户aum余额
    ,first_aum number(22,6) -- 开户当日的余额
    ,three_aum number(22,6) -- 开户后3天余额
    ,seven_aum number(22,6) -- 开户后7天余额
    ,fifteen_aum number(22,6) -- 开户后15天余额
    ,thirty_aum number(22,6) -- 开户后30天余额
    ,if_day varchar2(4000) -- 是否开户满30天
    ,is_payroll_cust varchar2(4000) -- 是否代发客户
    ,open_acct_chn_cd varchar2(4000) -- 开户渠道
    ,is_hav_prod varchar2(4000) -- 是否持有产品
    ,aum_sum number(22,6) -- 持有产品总余额（不含活期）
    ,all_label varchar2(4000) -- 持有产品类型（大类，存款不包含活期）
    ,if_bill varchar2(4000) -- 是否收单
    ,bind_remv_flg varchar2(4000) -- 是否添加企业微信
    ,new_open_m varchar2(4000) -- 是否当月内新开户
    ,open_acct_teller_name varchar2(4000) -- 开户柜员名称
    ,if_new_open_t0_amt varchar2(4000) -- 是否T0入金
    ,load_date varchar2(4000) -- 分区字段
    ,kqhf varchar2(4000) -- 客群划分
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdws_a_chnl_process_index_statis to ${iml_schema};
grant select on ${iol_schema}.bdws_a_chnl_process_index_statis to ${icl_schema};
grant select on ${iol_schema}.bdws_a_chnl_process_index_statis to ${idl_schema};
grant select on ${iol_schema}.bdws_a_chnl_process_index_statis to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdws_a_chnl_process_index_statis is '渠道过程指标统计';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.execut_org_id is '管户/共管机构编号';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.execut_org_name is '管户/共管机构名称';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.execut_type is '管户类型';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.execut_clerk_id is '管户/共管人员工号';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.execut_clerk_name is '管户/共管人名称';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.cust_id is '客户号';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.open_acct_dt is '开户时间';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.monthly_act_examine is '是否满足月活考核口径';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.mobile_bank_open is '是否开通手机银行';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.mobile_bank_login_m is '当月是否登录手机银行';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.fin_risk_sign is '是否签约理财风评';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.bind_card_examine is '是否符合绑卡考核口径';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.wct_bank_bind is '是否绑定微信银行';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.quick_pay_bind is '是否绑定快捷支付';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.cust_acct_nature is '客户账户性质';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.new_open_y is '是否当年内新开户';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.if_message_sign is '是否同意接收营销短信';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.aum_m_avg_bal is '客户aum月日均';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.aum_acct_bal is '客户aum余额';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.first_aum is '开户当日的余额';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.three_aum is '开户后3天余额';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.seven_aum is '开户后7天余额';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.fifteen_aum is '开户后15天余额';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.thirty_aum is '开户后30天余额';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.if_day is '是否开户满30天';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.is_payroll_cust is '是否代发客户';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.open_acct_chn_cd is '开户渠道';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.is_hav_prod is '是否持有产品';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.aum_sum is '持有产品总余额（不含活期）';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.all_label is '持有产品类型（大类，存款不包含活期）';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.if_bill is '是否收单';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.bind_remv_flg is '是否添加企业微信';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.new_open_m is '是否当月内新开户';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.open_acct_teller_name is '开户柜员名称';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.if_new_open_t0_amt is '是否T0入金';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.load_date is '分区字段';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.kqhf is '客群划分';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdws_a_chnl_process_index_statis.etl_timestamp is 'ETL处理时间戳';
