/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_cpes_bill_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_cpes_bill_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_cpes_bill_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cpes_bill_info(
    vouch_id varchar2(60) -- 凭证编号
    ,lp_id varchar2(60) -- 法人编号
    ,bill_id varchar2(60) -- 票据编号
    ,bill_num varchar2(60) -- 票据号码
    ,bill_med_cd varchar2(10) -- 票据介质代码
    ,bill_type_cd varchar2(10) -- 票据类型代码
    ,draw_dt date -- 出票日期
    ,exp_dt date -- 到期日期
    ,fac_val_amt number(30,2) -- 票面金额
    ,drawer_name varchar2(150) -- 出票人名称
    ,drawer_acct_num varchar2(60) -- 出票人账号
    ,drawer_soci_crdt_cd varchar2(60) -- 出票人社会信用代码
    ,drawer_open_acct_org_cd varchar2(60) -- 出票人开户机构代码
    ,drawer_open_bank_no varchar2(60) -- 出票人开户行行号
    ,drawer_open_bank_name varchar2(750) -- 出票人开户行名称
    ,accptor_name varchar2(150) -- 承兑人名称
    ,accptor_acct_num varchar2(60) -- 承兑人账号
    ,accptor_soci_crdt_cd varchar2(60) -- 承兑人社会信用代码
    ,accptor_open_acct_org_cd varchar2(60) -- 承兑人开户机构代码
    ,accptor_open_bank_no varchar2(60) -- 承兑人开户行行号
    ,accptor_open_bank_name varchar2(500) -- 承兑人开户行名称
    ,recver_name varchar2(150) -- 收款人名称
    ,recver_acct_num varchar2(60) -- 收款人账号
    ,recver_soci_crdt_cd varchar2(60) -- 收款人社会信用代码
    ,recver_open_acct_org_cd varchar2(60) -- 收款人开户机构代码
    ,recver_open_bank_no varchar2(60) -- 收款人开户行行号
    ,recver_open_bank_name varchar2(750) -- 收款人开户行名称
    ,pay_bank_org_cd varchar2(60) -- 付款行机构代码
    ,pay_bank_no varchar2(60) -- 付款行行号
    ,pay_cfm_org_cd varchar2(60) -- 付款确认机构代码
    ,discnt_bk_org_cd varchar2(60) -- 贴现行机构代码
    ,discnt_guar_org_cd varchar2(60) -- 贴现保证机构代码
    ,invtry_org_cd varchar2(60) -- 库存机构代码
    ,bill_ccution_status_cd varchar2(10) -- 票据流转状态代码
    ,risk_bill_status_cd varchar2(10) -- 风险票据状态代码
    ,bill_invtry_status_cd varchar2(10) -- 票据库存状态代码
    ,bill_status_cd varchar2(10) -- 票据状态代码
    ,init_ccution_status_cd varchar2(10) -- 原流转状态代码
    ,init_risk_bill_status_cd varchar2(10) -- 原风险票据状态代码
    ,init_bill_status_cd varchar2(10) -- 原票据状态代码
    ,init_bill_invtry_status_cd varchar2(10) -- 原票据库存状态代码
    ,discnt_dt date -- 贴现日期
    ,bill_sub_intrv_id varchar2(60) -- 票据子区间编号
    ,bill_intrv_std_amt number(30,2) -- 票据区间标准金额
    ,payoff_dt date -- 结清日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_cpes_bill_info to ${icl_schema};
grant select on ${iml_schema}.agt_cpes_bill_info to ${idl_schema};
grant select on ${iml_schema}.agt_cpes_bill_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_cpes_bill_info is '票交所票据信息';
comment on column ${iml_schema}.agt_cpes_bill_info.vouch_id is '凭证编号';
comment on column ${iml_schema}.agt_cpes_bill_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_cpes_bill_info.bill_id is '票据编号';
comment on column ${iml_schema}.agt_cpes_bill_info.bill_num is '票据号码';
comment on column ${iml_schema}.agt_cpes_bill_info.bill_med_cd is '票据介质代码';
comment on column ${iml_schema}.agt_cpes_bill_info.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.agt_cpes_bill_info.draw_dt is '出票日期';
comment on column ${iml_schema}.agt_cpes_bill_info.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_cpes_bill_info.fac_val_amt is '票面金额';
comment on column ${iml_schema}.agt_cpes_bill_info.drawer_name is '出票人名称';
comment on column ${iml_schema}.agt_cpes_bill_info.drawer_acct_num is '出票人账号';
comment on column ${iml_schema}.agt_cpes_bill_info.drawer_soci_crdt_cd is '出票人社会信用代码';
comment on column ${iml_schema}.agt_cpes_bill_info.drawer_open_acct_org_cd is '出票人开户机构代码';
comment on column ${iml_schema}.agt_cpes_bill_info.drawer_open_bank_no is '出票人开户行行号';
comment on column ${iml_schema}.agt_cpes_bill_info.drawer_open_bank_name is '出票人开户行名称';
comment on column ${iml_schema}.agt_cpes_bill_info.accptor_name is '承兑人名称';
comment on column ${iml_schema}.agt_cpes_bill_info.accptor_acct_num is '承兑人账号';
comment on column ${iml_schema}.agt_cpes_bill_info.accptor_soci_crdt_cd is '承兑人社会信用代码';
comment on column ${iml_schema}.agt_cpes_bill_info.accptor_open_acct_org_cd is '承兑人开户机构代码';
comment on column ${iml_schema}.agt_cpes_bill_info.accptor_open_bank_no is '承兑人开户行行号';
comment on column ${iml_schema}.agt_cpes_bill_info.accptor_open_bank_name is '承兑人开户行名称';
comment on column ${iml_schema}.agt_cpes_bill_info.recver_name is '收款人名称';
comment on column ${iml_schema}.agt_cpes_bill_info.recver_acct_num is '收款人账号';
comment on column ${iml_schema}.agt_cpes_bill_info.recver_soci_crdt_cd is '收款人社会信用代码';
comment on column ${iml_schema}.agt_cpes_bill_info.recver_open_acct_org_cd is '收款人开户机构代码';
comment on column ${iml_schema}.agt_cpes_bill_info.recver_open_bank_no is '收款人开户行行号';
comment on column ${iml_schema}.agt_cpes_bill_info.recver_open_bank_name is '收款人开户行名称';
comment on column ${iml_schema}.agt_cpes_bill_info.pay_bank_org_cd is '付款行机构代码';
comment on column ${iml_schema}.agt_cpes_bill_info.pay_bank_no is '付款行行号';
comment on column ${iml_schema}.agt_cpes_bill_info.pay_cfm_org_cd is '付款确认机构代码';
comment on column ${iml_schema}.agt_cpes_bill_info.discnt_bk_org_cd is '贴现行机构代码';
comment on column ${iml_schema}.agt_cpes_bill_info.discnt_guar_org_cd is '贴现保证机构代码';
comment on column ${iml_schema}.agt_cpes_bill_info.invtry_org_cd is '库存机构代码';
comment on column ${iml_schema}.agt_cpes_bill_info.bill_ccution_status_cd is '票据流转状态代码';
comment on column ${iml_schema}.agt_cpes_bill_info.risk_bill_status_cd is '风险票据状态代码';
comment on column ${iml_schema}.agt_cpes_bill_info.bill_invtry_status_cd is '票据库存状态代码';
comment on column ${iml_schema}.agt_cpes_bill_info.bill_status_cd is '票据状态代码';
comment on column ${iml_schema}.agt_cpes_bill_info.init_ccution_status_cd is '原流转状态代码';
comment on column ${iml_schema}.agt_cpes_bill_info.init_risk_bill_status_cd is '原风险票据状态代码';
comment on column ${iml_schema}.agt_cpes_bill_info.init_bill_status_cd is '原票据状态代码';
comment on column ${iml_schema}.agt_cpes_bill_info.init_bill_invtry_status_cd is '原票据库存状态代码';
comment on column ${iml_schema}.agt_cpes_bill_info.discnt_dt is '贴现日期';
comment on column ${iml_schema}.agt_cpes_bill_info.bill_sub_intrv_id is '票据子区间编号';
comment on column ${iml_schema}.agt_cpes_bill_info.bill_intrv_std_amt is '票据区间标准金额';
comment on column ${iml_schema}.agt_cpes_bill_info.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_cpes_bill_info.start_dt is '开始时间';
comment on column ${iml_schema}.agt_cpes_bill_info.end_dt is '结束时间';
comment on column ${iml_schema}.agt_cpes_bill_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_cpes_bill_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_cpes_bill_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_cpes_bill_info.etl_timestamp is 'ETL处理时间戳';
