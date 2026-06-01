/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_dep_prod_acct_info_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_dep_prod_acct_info_history
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_dep_prod_acct_info_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_dep_prod_acct_info_history(
    part_id varchar2(6) -- hash分区id
    ,dep_prod_sub_acct_id varchar2(15) -- 存款产品分户编号
    ,dep_acct_id varchar2(90) -- 存款账户编号
    ,acct_name varchar2(150) -- 账户名称
    ,cust_id varchar2(90) -- 客户编号
    ,prod_id varchar2(90) -- 产品编号
    ,ext_prod_id varchar2(150) -- 外部产品代码
    ,dep_acct_status_cd varchar2(15) -- 存款账户状态代码
    ,acpt_pay_status varchar2(15) -- 收付标志
    ,froz_status varchar2(15) -- 冻结状态
    ,stpay_status_cd varchar2(15) -- 止付状态
    ,int_accr_flg varchar2(15) -- 计息标志
    ,open_acct_dt varchar2(15) -- 开户日期
    ,value_dt varchar2(15) -- 起息日期
    ,exp_dt varchar2(15) -- 到期日期
    ,bal number(18,2) -- 本金金额（余额）
    ,froz_amt number(18,2) -- 冻结金额
    ,stpaybl number(18,2) -- 止付金额
    ,acct_instit_id varchar2(45) -- 账务机构编号
    ,open_acct_org_id varchar2(90) -- 开户机构编号
    ,open_acct_chn_id varchar2(45) -- 开户渠道编号
    ,open_acct_flow_num varchar2(90) -- 开户流水号
    ,last_activ_acct_dt varchar2(15) -- 上次动户日期
    ,exec_int_rat number(18,8) -- 执行利率
    ,base_rat number(11,7) -- 基准利率
    ,spread_val number(11,7) -- 浮动值（点差值）
    ,close_acct_dt varchar2(15) -- 销户日期
    ,close_acct_flow_num varchar2(90) -- 销户流水号
    ,pa_ext_cnt number(22) -- 部提次数
    ,dep_term_cd varchar2(15) -- 存期代码
    ,ext_acct_dt varchar2(30) -- 对接行的账务日期
    ,open_acct_ti varchar2(32) -- 开户时间
    ,close_acct_ti varchar2(32) -- 销户时间
    ,fee_dt varchar2(30) -- 费用日期
    ,bind_acct_id varchar2(150) -- 微众银行卡号
    ,dps_type_cd varchar2(5) -- 储种
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
grant select on ${iol_schema}.ifcs_dep_prod_acct_info_history to ${iml_schema};
grant select on ${iol_schema}.ifcs_dep_prod_acct_info_history to ${icl_schema};
grant select on ${iol_schema}.ifcs_dep_prod_acct_info_history to ${idl_schema};
grant select on ${iol_schema}.ifcs_dep_prod_acct_info_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_dep_prod_acct_info_history is '联合存款账户历史表';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.part_id is 'hash分区id';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.dep_prod_sub_acct_id is '存款产品分户编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.dep_acct_id is '存款账户编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.acct_name is '账户名称';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.cust_id is '客户编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.prod_id is '产品编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.ext_prod_id is '外部产品代码';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.dep_acct_status_cd is '存款账户状态代码';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.acpt_pay_status is '收付标志';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.froz_status is '冻结状态';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.stpay_status_cd is '止付状态';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.int_accr_flg is '计息标志';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.open_acct_dt is '开户日期';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.value_dt is '起息日期';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.exp_dt is '到期日期';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.bal is '本金金额（余额）';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.froz_amt is '冻结金额';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.stpaybl is '止付金额';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.acct_instit_id is '账务机构编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.open_acct_org_id is '开户机构编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.open_acct_chn_id is '开户渠道编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.open_acct_flow_num is '开户流水号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.last_activ_acct_dt is '上次动户日期';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.exec_int_rat is '执行利率';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.base_rat is '基准利率';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.spread_val is '浮动值（点差值）';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.close_acct_dt is '销户日期';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.close_acct_flow_num is '销户流水号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.pa_ext_cnt is '部提次数';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.dep_term_cd is '存期代码';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.ext_acct_dt is '对接行的账务日期';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.open_acct_ti is '开户时间';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.close_acct_ti is '销户时间';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.fee_dt is '费用日期';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.bind_acct_id is '微众银行卡号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.dps_type_cd is '储种';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_dep_prod_acct_info_history.etl_timestamp is 'ETL处理时间戳';
