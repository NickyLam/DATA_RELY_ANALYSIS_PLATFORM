/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_we_dep_acct_ip_check_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_we_dep_acct_ip_check_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_we_dep_acct_ip_check_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_we_dep_acct_ip_check_dtl(
    agt_id varchar2(100) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cust_name varchar2(150) -- 客户姓名
    ,cert_no varchar2(100) -- 证件号码
    ,cust_id varchar2(100) -- 客户编号
    ,ghb_card_no varchar2(100) -- 本行卡号
    ,webank_card_no varchar2(100) -- 微众银行卡号
    ,open_ip varchar2(150) -- 开户IP
    ,permt_ip varchar2(150) -- 常驻IP
    ,check_ip_flg varchar2(10) -- 核对IP标志
    ,gd_prov_int_flg varchar2(10) -- 广东省内标志
    ,check_tm timestamp -- 核对时间
    ,wdraw_flg varchar2(10) -- 回撤标志
    ,wdraw_tm timestamp -- 回撤时间
    ,wdraw_return_code varchar2(90) -- 回撤返回码
    ,wdraw_return_code_descb varchar2(750) -- 回撤返回码描述
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.agt_we_dep_acct_ip_check_dtl to ${icl_schema};
grant select on ${iml_schema}.agt_we_dep_acct_ip_check_dtl to ${idl_schema};
grant select on ${iml_schema}.agt_we_dep_acct_ip_check_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_we_dep_acct_ip_check_dtl is '微众存款账户IP核对明细';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.agt_id is '协议编号';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.cust_name is '客户姓名';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.cert_no is '证件号码';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.ghb_card_no is '本行卡号';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.webank_card_no is '微众银行卡号';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.open_ip is '开户IP';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.permt_ip is '常驻IP';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.check_ip_flg is '核对IP标志';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.gd_prov_int_flg is '广东省内标志';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.check_tm is '核对时间';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.wdraw_flg is '回撤标志';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.wdraw_tm is '回撤时间';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.wdraw_return_code is '回撤返回码';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.wdraw_return_code_descb is '回撤返回码描述';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_we_dep_acct_ip_check_dtl.etl_timestamp is 'ETL处理时间戳';
