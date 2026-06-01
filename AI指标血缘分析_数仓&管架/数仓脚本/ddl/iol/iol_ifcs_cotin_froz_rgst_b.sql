/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_cotin_froz_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_cotin_froz_rgst_b
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_cotin_froz_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_cotin_froz_rgst_b(
    cotin_froz_dt varchar2(12) -- 续冻日期
    ,cotin_froz_flow_num varchar2(90) -- 续冻流水
    ,cotin_froz_amt number(18,2) -- 续冻金额
    ,init_froz_end_dt varchar2(12) -- 原冻结截至日
    ,init_proof_cate varchar2(2) -- 原证明类别
    ,init_proof_num varchar2(300) -- 原证明书号
    ,init_froz_rs varchar2(150) -- 原冻结原因
    ,init_exec_org varchar2(768) -- 原执行机关
    ,init_exec_cert_01 varchar2(3) -- 原执行证件一
    ,init_exec_num_01 varchar2(72) -- 原执行号码一
    ,init_exec_cert_02 varchar2(3) -- 原执行证件二
    ,init_exec_num_02 varchar2(72) -- 原执行号码二
    ,init_exec_ps_01 varchar2(30) -- 原执行人
    ,init_froz_dt varchar2(12) -- 原冻结日期
    ,init_froz_flow varchar2(90) -- 原冻结流水
    ,init_froz_seq_num number(22,0) -- 原冻结序号
    ,init_exec_ps_02 varchar2(30) -- 原执行人二
    ,con_froz_tm varchar2(32) -- 续冻时间
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
grant select on ${iol_schema}.ifcs_cotin_froz_rgst_b to ${iml_schema};
grant select on ${iol_schema}.ifcs_cotin_froz_rgst_b to ${icl_schema};
grant select on ${iol_schema}.ifcs_cotin_froz_rgst_b to ${idl_schema};
grant select on ${iol_schema}.ifcs_cotin_froz_rgst_b to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_cotin_froz_rgst_b is '续冻登记簿';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.cotin_froz_dt is '续冻日期';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.cotin_froz_flow_num is '续冻流水';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.cotin_froz_amt is '续冻金额';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_froz_end_dt is '原冻结截至日';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_proof_cate is '原证明类别';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_proof_num is '原证明书号';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_froz_rs is '原冻结原因';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_exec_org is '原执行机关';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_exec_cert_01 is '原执行证件一';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_exec_num_01 is '原执行号码一';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_exec_cert_02 is '原执行证件二';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_exec_num_02 is '原执行号码二';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_exec_ps_01 is '原执行人';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_froz_dt is '原冻结日期';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_froz_flow is '原冻结流水';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_froz_seq_num is '原冻结序号';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.init_exec_ps_02 is '原执行人二';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.con_froz_tm is '续冻时间';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_cotin_froz_rgst_b.etl_timestamp is 'ETL处理时间戳';
