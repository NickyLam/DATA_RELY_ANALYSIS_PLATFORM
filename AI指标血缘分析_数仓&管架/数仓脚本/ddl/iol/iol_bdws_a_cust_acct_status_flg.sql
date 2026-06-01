/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdws_a_cust_acct_status_flg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdws_a_cust_acct_status_flg
whenever sqlerror continue none;
drop table ${iol_schema}.bdws_a_cust_acct_status_flg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdws_a_cust_acct_status_flg(
    cust_id varchar2(4000) -- 客户号
    ,acct_type varchar2(4000) -- 账户类型（取最高等级的账户，按I>II>III>定期>临时>虚拟>其它>未知）
    ,if_allacct_close varchar2(4000) -- 是否所有账户已销户
    ,acct_type_i varchar2(4000) -- 是否持有I类户
    ,acct_type_ii varchar2(4000) -- 是否持有II类户
    ,acct_type_iii varchar2(4000) -- 是否持有III类户
    ,acct_type_dept varchar2(4000) -- 是否持有定期户
    ,acct_type_tmp varchar2(4000) -- 是否持有临时户
    ,acct_type_virt varchar2(4000) -- 是否持有虚拟户
    ,acct_type_oth varchar2(4000) -- 是否持有其它账户
    ,acct_type_und varchar2(4000) -- 是否持有未知账户
    ,last_clos_dt varchar2(4000) -- 最后一个销户日期
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
grant select on ${iol_schema}.bdws_a_cust_acct_status_flg to ${iml_schema};
grant select on ${iol_schema}.bdws_a_cust_acct_status_flg to ${icl_schema};
grant select on ${iol_schema}.bdws_a_cust_acct_status_flg to ${idl_schema};
grant select on ${iol_schema}.bdws_a_cust_acct_status_flg to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdws_a_cust_acct_status_flg is '客户账户类型持有情况';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.cust_id is '客户号';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.acct_type is '账户类型（取最高等级的账户，按I>II>III>定期>临时>虚拟>其它>未知）';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.if_allacct_close is '是否所有账户已销户';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.acct_type_i is '是否持有I类户';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.acct_type_ii is '是否持有II类户';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.acct_type_iii is '是否持有III类户';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.acct_type_dept is '是否持有定期户';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.acct_type_tmp is '是否持有临时户';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.acct_type_virt is '是否持有虚拟户';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.acct_type_oth is '是否持有其它账户';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.acct_type_und is '是否持有未知账户';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.last_clos_dt is '最后一个销户日期';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdws_a_cust_acct_status_flg.etl_timestamp is 'ETL处理时间戳';
