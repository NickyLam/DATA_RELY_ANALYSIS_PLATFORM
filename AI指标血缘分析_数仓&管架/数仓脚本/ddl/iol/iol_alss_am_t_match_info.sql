/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_am_t_match_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_am_t_match_info
whenever sqlerror continue none;
drop table ${iol_schema}.alss_am_t_match_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_am_t_match_info(
    cust_no varchar2(150) -- 客户号
    ,own_organ varchar2(150) -- 开户上级机构
    ,organ_code varchar2(150) -- 开户机构
    ,acct_num varchar2(300) -- 账号
    ,acct_name varchar2(750) -- 账户名称
    ,acct_type varchar2(150) -- 账户性质
    ,licence_regist_num varchar2(300) -- 营业执照(注册号)编号
    ,licence_social_num varchar2(300) -- 营业执照（统一社会信用代码）编号
    ,other_credtype varchar2(300) -- 是否为其他证件种类
    ,core_people varchar2(3000) -- 核心与人行账户管理系统比对
    ,core_business varchar2(3000) -- 核心与商事信息
    ,people_business varchar2(3000) -- 人行账户管理系统与商事信息
    ,suspend_info varchar2(4000) -- 久悬账户情况
    ,manage_state varchar2(150) -- 经营状态
    ,abnormal_con varchar2(3000) -- 是否被列入企业异常名录
    ,illegal_breach varchar2(3000) -- 是否为严重违法失信企业
    ,last_inspect varchar2(150) -- 最后年检年度
    ,check_dt varchar2(150) -- 核查日期
    ,inspect_dt varchar2(150) -- 年检日期
    ,etl_dt_ora timestamp -- 创建日期
    ,org_num varchar2(75) -- 所属机构
    ,establish_dt varchar2(150) -- 企业开立日期
    ,handle_flag varchar2(15) -- 账户处示标示 1-是(已处置)
    ,core_proof varchar2(3000) -- 核心与验印系统比对
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
grant select on ${iol_schema}.alss_am_t_match_info to ${iml_schema};
grant select on ${iol_schema}.alss_am_t_match_info to ${icl_schema};
grant select on ${iol_schema}.alss_am_t_match_info to ${idl_schema};
grant select on ${iol_schema}.alss_am_t_match_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_am_t_match_info is '对公年检信息表';
comment on column ${iol_schema}.alss_am_t_match_info.cust_no is '客户号';
comment on column ${iol_schema}.alss_am_t_match_info.own_organ is '开户上级机构';
comment on column ${iol_schema}.alss_am_t_match_info.organ_code is '开户机构';
comment on column ${iol_schema}.alss_am_t_match_info.acct_num is '账号';
comment on column ${iol_schema}.alss_am_t_match_info.acct_name is '账户名称';
comment on column ${iol_schema}.alss_am_t_match_info.acct_type is '账户性质';
comment on column ${iol_schema}.alss_am_t_match_info.licence_regist_num is '营业执照(注册号)编号';
comment on column ${iol_schema}.alss_am_t_match_info.licence_social_num is '营业执照（统一社会信用代码）编号';
comment on column ${iol_schema}.alss_am_t_match_info.other_credtype is '是否为其他证件种类';
comment on column ${iol_schema}.alss_am_t_match_info.core_people is '核心与人行账户管理系统比对';
comment on column ${iol_schema}.alss_am_t_match_info.core_business is '核心与商事信息';
comment on column ${iol_schema}.alss_am_t_match_info.people_business is '人行账户管理系统与商事信息';
comment on column ${iol_schema}.alss_am_t_match_info.suspend_info is '久悬账户情况';
comment on column ${iol_schema}.alss_am_t_match_info.manage_state is '经营状态';
comment on column ${iol_schema}.alss_am_t_match_info.abnormal_con is '是否被列入企业异常名录';
comment on column ${iol_schema}.alss_am_t_match_info.illegal_breach is '是否为严重违法失信企业';
comment on column ${iol_schema}.alss_am_t_match_info.last_inspect is '最后年检年度';
comment on column ${iol_schema}.alss_am_t_match_info.check_dt is '核查日期';
comment on column ${iol_schema}.alss_am_t_match_info.inspect_dt is '年检日期';
comment on column ${iol_schema}.alss_am_t_match_info.etl_dt_ora is '创建日期';
comment on column ${iol_schema}.alss_am_t_match_info.org_num is '所属机构';
comment on column ${iol_schema}.alss_am_t_match_info.establish_dt is '企业开立日期';
comment on column ${iol_schema}.alss_am_t_match_info.handle_flag is '账户处示标示 1-是(已处置)';
comment on column ${iol_schema}.alss_am_t_match_info.core_proof is '核心与验印系统比对';
comment on column ${iol_schema}.alss_am_t_match_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alss_am_t_match_info.etl_timestamp is 'ETL处理时间戳';
