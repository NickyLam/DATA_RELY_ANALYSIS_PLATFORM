/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_agt_cds_subscr_cont_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_agt_cds_subscr_cont_info
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_agt_cds_subscr_cont_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_agt_cds_subscr_cont_info(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(60) -- 合约编号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,cust_name varchar2(200) -- 客户名称
    ,prod_id varchar2(60) -- 产品编号
    ,src_prod_id varchar2(60) -- 源产品编号
    ,cont_status_cd varchar2(10) -- 合约状态代码
    ,curr_cd varchar2(10) -- 币种代码
    ,subscr_tot number(30,2) -- 认购总额
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,exp_dt date -- 到期日期
    ,value_dt date -- 起息日期
    ,sign_chn_cd varchar2(10) -- 签订渠道代码
    ,dep_term_cd varchar2(10) -- 存期代码
    ,agt_rat number(18,8) -- 协议利率
    ,pric_tran_in_acct_num varchar2(60) -- 本金转入账号
    ,int_tran_in_acct_num varchar2(60) -- 利息转入账号
    ,liab_acct_num varchar2(60) -- 负债账号
    ,dep_rcpt_acct_num varchar2(60) -- 存单账号
    ,acct_org_id varchar2(60) -- 账户机构编号
    ,sign_org_id varchar2(60) -- 签约机构编号
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,sign_emply_id varchar2(60) -- 签约员工编号
    ,sign_teller_id varchar2(60) -- 签约柜员编号
    ,sign_dt date -- 签订日期
    ,sign_flow_num varchar2(60) -- 签约流水号
    ,revo_dt date -- 撤销日期
    ,dep_prod_acct_id varchar2(60) -- 存款产品户编号
    ,matn_teller_id varchar2(60) -- 维护柜员编号
    ,matn_org_id varchar2(60) -- 维护机构编号
    ,matn_tm varchar2(10) -- 维护时间
    ,tm_stamp timestamp -- 时间戳
    ,rec_status_cd varchar2(10) -- 记录状态代码
    ,etl_dt date -- 数据日期
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
grant select on ${itl_schema}.itl_edw_agt_cds_subscr_cont_info to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_agt_cds_subscr_cont_info is '大额存单认购合约信息';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.agt_id is '协议编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.cont_id is '合约编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.cust_id is '客户编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.cust_acct_num is '客户账号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.cust_name is '客户名称';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.prod_id is '产品编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.src_prod_id is '源产品编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.cont_status_cd is '合约状态代码';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.curr_cd is '币种代码';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.subscr_tot is '认购总额';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.effect_dt is '生效日期';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.invalid_dt is '失效日期';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.exp_dt is '到期日期';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.value_dt is '起息日期';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.sign_chn_cd is '签订渠道代码';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.dep_term_cd is '存期代码';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.agt_rat is '协议利率';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.pric_tran_in_acct_num is '本金转入账号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.int_tran_in_acct_num is '利息转入账号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.liab_acct_num is '负债账号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.dep_rcpt_acct_num is '存单账号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.acct_org_id is '账户机构编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.sign_org_id is '签约机构编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.mgmt_org_id is '管理机构编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.sign_emply_id is '签约员工编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.sign_teller_id is '签约柜员编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.sign_dt is '签订日期';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.sign_flow_num is '签约流水号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.revo_dt is '撤销日期';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.dep_prod_acct_id is '存款产品户编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.matn_teller_id is '维护柜员编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.matn_org_id is '维护机构编号';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.matn_tm is '维护时间';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.tm_stamp is '时间戳';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.rec_status_cd is '记录状态代码';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_agt_cds_subscr_cont_info.etl_timestamp is 'ETL处理时间戳';
