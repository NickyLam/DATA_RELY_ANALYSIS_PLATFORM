/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_loancard
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_loancard
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_loancard purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_loancard(
    id varchar2(96) -- 
    ,cr_supr_rcrd_id varchar2(96) -- 
    ,msgidno varchar2(53) -- 
    ,crnotclsgllpsninstnum number(3,0) -- 
    ,acc_num number(3,0) -- 
    ,crgln number(38,0) -- 
    ,hgamt number(38,0) -- 
    ,crlncrdrcy6mavguselmt number(38,0) -- 
    ,lwst_amt number(38,0) -- 
    ,crnotcnclalcrdusedlmt number(38,0) -- 
    ,multi_tenancy_id varchar2(30) -- 
    ,crt_dt_tm date -- 
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
grant select on ${iol_schema}.cqss_i_r_loancard to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_loancard to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_loancard to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_loancard to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_loancard is '二代贷记卡账户信息';
comment on column ${iol_schema}.cqss_i_r_loancard.id is '';
comment on column ${iol_schema}.cqss_i_r_loancard.cr_supr_rcrd_id is '';
comment on column ${iol_schema}.cqss_i_r_loancard.msgidno is '';
comment on column ${iol_schema}.cqss_i_r_loancard.crnotclsgllpsninstnum is '';
comment on column ${iol_schema}.cqss_i_r_loancard.acc_num is '';
comment on column ${iol_schema}.cqss_i_r_loancard.crgln is '';
comment on column ${iol_schema}.cqss_i_r_loancard.hgamt is '';
comment on column ${iol_schema}.cqss_i_r_loancard.crlncrdrcy6mavguselmt is '';
comment on column ${iol_schema}.cqss_i_r_loancard.lwst_amt is '';
comment on column ${iol_schema}.cqss_i_r_loancard.crnotcnclalcrdusedlmt is '';
comment on column ${iol_schema}.cqss_i_r_loancard.multi_tenancy_id is '';
comment on column ${iol_schema}.cqss_i_r_loancard.crt_dt_tm is '';
comment on column ${iol_schema}.cqss_i_r_loancard.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_loancard.etl_timestamp is 'ETL处理时间戳';
