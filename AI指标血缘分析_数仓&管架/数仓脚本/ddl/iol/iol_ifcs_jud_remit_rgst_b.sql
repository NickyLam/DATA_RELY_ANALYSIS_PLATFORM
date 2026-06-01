/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_jud_remit_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_jud_remit_rgst_b
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_jud_remit_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_jud_remit_rgst_b(
    remit_dt varchar2(12) -- 解除日期
    ,remit_flow_num varchar2(90) -- 解除流水
    ,tran_flow_num varchar2(90) -- 交易流水
    ,remit_way varchar2(2) -- 解除方式
    ,remit_proof_type varchar2(2) -- 解除证明类别
    ,proof_num varchar2(300) -- 证明文号
    ,exec_org_cd varchar2(768) -- 执行机关
    ,exec_cert_type_01 varchar2(6) -- 执行人证件1
    ,exec_cert_no_01 varchar2(72) -- 执行人证件号码1
    ,exec_cert_type_02 varchar2(90) -- 执行人证件2
    ,exec_cert_no_02 varchar2(72) -- 执行人证件号码2
    ,exec_ps_01 varchar2(30) -- 执行人姓名
    ,remit_rs varchar2(150) -- 解除原因
    ,teller_no varchar2(15) -- 柜员
    ,org_no varchar2(15) -- 机构
    ,init_froz_dt varchar2(12) -- 原冻结日期
    ,init_froz_flow varchar2(48) -- 原冻结流水
    ,remit_amt number(18,2) -- 解除金额
    ,exec_ps_02 varchar2(30) -- 执行人员二
    ,remit_chn varchar2(9) -- 解冻解止渠道
    ,remit_tm varchar2(32) -- 解冻时间
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
grant select on ${iol_schema}.ifcs_jud_remit_rgst_b to ${iml_schema};
grant select on ${iol_schema}.ifcs_jud_remit_rgst_b to ${icl_schema};
grant select on ${iol_schema}.ifcs_jud_remit_rgst_b to ${idl_schema};
grant select on ${iol_schema}.ifcs_jud_remit_rgst_b to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_jud_remit_rgst_b is '解冻解止登记簿';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.remit_dt is '解除日期';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.remit_flow_num is '解除流水';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.tran_flow_num is '交易流水';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.remit_way is '解除方式';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.remit_proof_type is '解除证明类别';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.proof_num is '证明文号';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.exec_org_cd is '执行机关';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.exec_cert_type_01 is '执行人证件1';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.exec_cert_no_01 is '执行人证件号码1';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.exec_cert_type_02 is '执行人证件2';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.exec_cert_no_02 is '执行人证件号码2';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.exec_ps_01 is '执行人姓名';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.remit_rs is '解除原因';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.teller_no is '柜员';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.org_no is '机构';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.init_froz_dt is '原冻结日期';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.init_froz_flow is '原冻结流水';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.remit_amt is '解除金额';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.exec_ps_02 is '执行人员二';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.remit_chn is '解冻解止渠道';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.remit_tm is '解冻时间';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_jud_remit_rgst_b.etl_timestamp is 'ETL处理时间戳';
