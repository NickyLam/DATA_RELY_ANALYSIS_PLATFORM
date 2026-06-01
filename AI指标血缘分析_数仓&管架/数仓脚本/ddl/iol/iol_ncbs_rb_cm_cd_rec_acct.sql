/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_cm_cd_rec_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_cm_cd_rec_acct
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_cm_cd_rec_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_cm_cd_rec_acct(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,rec_acct_name varchar2(200) -- 回收账户名称
    ,rec_base_acct_no varchar2(50) -- 回收账户
    ,rec_internal_key number(15) -- 白名单账户主键
    ,sub_acct_no varchar2(50) -- 子账户
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_rb_cm_cd_rec_acct to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_cm_cd_rec_acct to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_cm_cd_rec_acct to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_cm_cd_rec_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_cm_cd_rec_acct is '现管存管白名单同步记录表';
comment on column ${iol_schema}.ncbs_rb_cm_cd_rec_acct.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_cm_cd_rec_acct.company is '法人';
comment on column ${iol_schema}.ncbs_rb_cm_cd_rec_acct.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_cm_cd_rec_acct.rec_acct_name is '回收账户名称';
comment on column ${iol_schema}.ncbs_rb_cm_cd_rec_acct.rec_base_acct_no is '回收账户';
comment on column ${iol_schema}.ncbs_rb_cm_cd_rec_acct.rec_internal_key is '白名单账户主键';
comment on column ${iol_schema}.ncbs_rb_cm_cd_rec_acct.sub_acct_no is '子账户';
comment on column ${iol_schema}.ncbs_rb_cm_cd_rec_acct.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_cm_cd_rec_acct.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_cm_cd_rec_acct.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_cm_cd_rec_acct.etl_timestamp is 'ETL处理时间戳';
