/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_agt_indv_e_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_agt_indv_e_acct
whenever sqlerror continue none;
drop table ${idl_schema}.aml_agt_indv_e_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_agt_indv_e_acct(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,prod_acct_id varchar2(60) -- 产品账户编号
    ,fund_cust_id varchar2(60) -- 基金客户编号
    ,fund_acct_id varchar2(60) -- 基金账户编号
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,acct_id varchar2(60) -- 账户编号
    ,cust_id varchar2(60) -- 客户编号
    ,acct_name varchar2(100) -- 账户名称
    ,agt_effect_tm timestamp -- 协议生效时间
    ,agt_invalid_tm timestamp -- 协议失效时间
    ,last_activ_acct_tm timestamp -- 上次动户时间
    ,acct_tm timestamp -- 账务时间
    ,fin_acct_type_cd varchar2(20) -- 金融账户类型代码
    ,acct_status_cd varchar2(10) -- 账户状态代码
    ,curr_cd varchar2(10) -- 币种代码
    ,post_to_gl_flg varchar2(20) -- 过总账标志
    ,attach_pay_cd varchar2(10) -- 补充付款代码
    ,actl_bal number(30,2) -- 实际余额
    ,acct_level_cls_cd varchar2(20) -- 账户等级分类代码
    ,acct_type_cd varchar2(10) -- 账户类型代码
    ,vrif_status_cd varchar2(10) -- 核实状态代码
    ,froz_status_cd varchar2(10) -- 冻结状态代码
    ,netw_vrfction_flg varchar2(10) -- 联网核查标志
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- 数据日期
    ,id_mark varchar2(10) -- 删除标识
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务代码
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
grant select on ${idl_schema}.aml_agt_indv_e_acct to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_agt_indv_e_acct is '个人电子账户';
comment on column ${idl_schema}.aml_agt_indv_e_acct.agt_id is '协议编号';
comment on column ${idl_schema}.aml_agt_indv_e_acct.lp_id is '法人编号';
comment on column ${idl_schema}.aml_agt_indv_e_acct.prod_acct_id is '产品账户编号';
comment on column ${idl_schema}.aml_agt_indv_e_acct.fund_cust_id is '基金客户编号';
comment on column ${idl_schema}.aml_agt_indv_e_acct.fund_acct_id is '基金账户编号';
comment on column ${idl_schema}.aml_agt_indv_e_acct.open_acct_org_id is '开户机构编号';
comment on column ${idl_schema}.aml_agt_indv_e_acct.acct_id is '账户编号';
comment on column ${idl_schema}.aml_agt_indv_e_acct.cust_id is '客户编号';
comment on column ${idl_schema}.aml_agt_indv_e_acct.acct_name is '账户名称';
comment on column ${idl_schema}.aml_agt_indv_e_acct.agt_effect_tm is '协议生效时间';
comment on column ${idl_schema}.aml_agt_indv_e_acct.agt_invalid_tm is '协议失效时间';
comment on column ${idl_schema}.aml_agt_indv_e_acct.last_activ_acct_tm is '上次动户时间';
comment on column ${idl_schema}.aml_agt_indv_e_acct.acct_tm is '账务时间';
comment on column ${idl_schema}.aml_agt_indv_e_acct.fin_acct_type_cd is '金融账户类型代码';
comment on column ${idl_schema}.aml_agt_indv_e_acct.acct_status_cd is '账户状态代码';
comment on column ${idl_schema}.aml_agt_indv_e_acct.curr_cd is '币种代码';
comment on column ${idl_schema}.aml_agt_indv_e_acct.post_to_gl_flg is '过总账标志';
comment on column ${idl_schema}.aml_agt_indv_e_acct.attach_pay_cd is '补充付款代码';
comment on column ${idl_schema}.aml_agt_indv_e_acct.actl_bal is '实际余额';
comment on column ${idl_schema}.aml_agt_indv_e_acct.acct_level_cls_cd is '账户等级分类代码';
comment on column ${idl_schema}.aml_agt_indv_e_acct.acct_type_cd is '账户类型代码';
comment on column ${idl_schema}.aml_agt_indv_e_acct.vrif_status_cd is '核实状态代码';
comment on column ${idl_schema}.aml_agt_indv_e_acct.froz_status_cd is '冻结状态代码';
comment on column ${idl_schema}.aml_agt_indv_e_acct.netw_vrfction_flg is '联网核查标志';
comment on column ${idl_schema}.aml_agt_indv_e_acct.create_dt is '创建日期';
comment on column ${idl_schema}.aml_agt_indv_e_acct.update_dt is '更新日期';
comment on column ${idl_schema}.aml_agt_indv_e_acct.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_agt_indv_e_acct.id_mark is '删除标识';
comment on column ${idl_schema}.aml_agt_indv_e_acct.src_table_name is '源表名称';
comment on column ${idl_schema}.aml_agt_indv_e_acct.job_cd is '任务代码';
comment on column ${idl_schema}.aml_agt_indv_e_acct.etl_timestamp is '数据处理时间';