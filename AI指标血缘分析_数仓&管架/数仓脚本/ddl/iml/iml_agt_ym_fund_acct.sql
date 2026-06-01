/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ym_fund_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ym_fund_acct
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ym_fund_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ym_fund_acct(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(100) -- 客户编号
    ,open_dt date -- 开户日期
    ,open_tm date -- 开户时间
    ,serv_plat_abbr varchar2(150) -- 服务平台简称
    ,open_flow_num varchar2(100) -- 开户流水号
    ,mercht_id varchar2(100) -- 商户编号
    ,ym_riches_acct_id varchar2(100) -- 盈米财富账户编号
    ,post_acct_bill_flg varchar2(10) -- 寄送账单标志
    ,acct_bill_post_way_cd varchar2(30) -- 账单寄送方式代码
    ,cust_bear_risk_level_cd varchar2(30) -- 客户承受风险等级代码
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,invtor_lev_cd varchar2(30) -- 投资者级别代码
    ,info_integy_flg varchar2(10) -- 信息完整标志
    ,actl_invtor_name varchar2(750) -- 实际投资者姓名
    ,actl_invtor_cert_type_cd varchar2(30) -- 实际投资者证件类型代码
    ,actl_invtor_cert_no varchar2(100) -- 实际投资者证件号码
    ,actl_invtor_cert_exp_dt date -- 实际投资者证件到期日期
    ,invest_benefc_name varchar2(750) -- 投资受益人姓名
    ,invest_benefc_cert_type_cd varchar2(30) -- 投资受益人证件类型代码
    ,invest_benefc_cert_no varchar2(100) -- 投资受益人证件号码
    ,invest_benefc_cert_exp_dt date -- 投资受益人证件到期日期
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,name varchar2(150) -- 姓名
    ,zip_cd varchar2(45) -- 邮政编码
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_ym_fund_acct to ${icl_schema};
grant select on ${iml_schema}.agt_ym_fund_acct to ${idl_schema};
grant select on ${iml_schema}.agt_ym_fund_acct to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ym_fund_acct is '盈米基金账户';
comment on column ${iml_schema}.agt_ym_fund_acct.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ym_fund_acct.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ym_fund_acct.cust_id is '客户编号';
comment on column ${iml_schema}.agt_ym_fund_acct.open_dt is '开户日期';
comment on column ${iml_schema}.agt_ym_fund_acct.open_tm is '开户时间';
comment on column ${iml_schema}.agt_ym_fund_acct.serv_plat_abbr is '服务平台简称';
comment on column ${iml_schema}.agt_ym_fund_acct.open_flow_num is '开户流水号';
comment on column ${iml_schema}.agt_ym_fund_acct.mercht_id is '商户编号';
comment on column ${iml_schema}.agt_ym_fund_acct.ym_riches_acct_id is '盈米财富账户编号';
comment on column ${iml_schema}.agt_ym_fund_acct.post_acct_bill_flg is '寄送账单标志';
comment on column ${iml_schema}.agt_ym_fund_acct.acct_bill_post_way_cd is '账单寄送方式代码';
comment on column ${iml_schema}.agt_ym_fund_acct.cust_bear_risk_level_cd is '客户承受风险等级代码';
comment on column ${iml_schema}.agt_ym_fund_acct.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.agt_ym_fund_acct.invtor_lev_cd is '投资者级别代码';
comment on column ${iml_schema}.agt_ym_fund_acct.info_integy_flg is '信息完整标志';
comment on column ${iml_schema}.agt_ym_fund_acct.actl_invtor_name is '实际投资者姓名';
comment on column ${iml_schema}.agt_ym_fund_acct.actl_invtor_cert_type_cd is '实际投资者证件类型代码';
comment on column ${iml_schema}.agt_ym_fund_acct.actl_invtor_cert_no is '实际投资者证件号码';
comment on column ${iml_schema}.agt_ym_fund_acct.actl_invtor_cert_exp_dt is '实际投资者证件到期日期';
comment on column ${iml_schema}.agt_ym_fund_acct.invest_benefc_name is '投资受益人姓名';
comment on column ${iml_schema}.agt_ym_fund_acct.invest_benefc_cert_type_cd is '投资受益人证件类型代码';
comment on column ${iml_schema}.agt_ym_fund_acct.invest_benefc_cert_no is '投资受益人证件号码';
comment on column ${iml_schema}.agt_ym_fund_acct.invest_benefc_cert_exp_dt is '投资受益人证件到期日期';
comment on column ${iml_schema}.agt_ym_fund_acct.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_ym_fund_acct.name is '姓名';
comment on column ${iml_schema}.agt_ym_fund_acct.zip_cd is '邮政编码';
comment on column ${iml_schema}.agt_ym_fund_acct.create_dt is '创建日期';
comment on column ${iml_schema}.agt_ym_fund_acct.update_dt is '更新日期';
comment on column ${iml_schema}.agt_ym_fund_acct.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_ym_fund_acct.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ym_fund_acct.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ym_fund_acct.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ym_fund_acct.etl_timestamp is 'ETL处理时间戳';
