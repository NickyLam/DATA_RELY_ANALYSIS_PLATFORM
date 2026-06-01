/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ifs_jud_remit_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ifs_jud_remit_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ifs_jud_remit_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ifs_jud_remit_rgst_b(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,unfrz_dt date -- 解冻日期
    ,unfrz_tm varchar2(30) -- 解冻时间
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,remit_way_cd varchar2(10) -- 解除方式代码
    ,remit_proof_cate_cd varchar2(10) -- 解除证明类别代码
    ,proof_num varchar2(250) -- 证明文号
    ,exec_org varchar2(1500) -- 执行机关
    ,exec_ps_cert_type_cd_1 varchar2(10) -- 执行人证件类型代码1
    ,exec_ps_cert_no_1 varchar2(60) -- 执行人证件号码1
    ,exec_ps_cert_type_cd_2 varchar2(100) -- 执行人证件类型代码2
    ,exec_ps_cert_no_2 varchar2(60) -- 执行人证件号码2
    ,exec_ps_name varchar2(150) -- 执行人姓名
    ,remit_rs varchar2(375) -- 解除原因
    ,oper_teller_id varchar2(60) -- 操作柜员编号
    ,org_id varchar2(60) -- 机构编号
    ,init_froz_dt date -- 原冻结日期
    ,init_froz_flow_num varchar2(60) -- 原冻结流水号
    ,remit_amt number(30,2) -- 解除金额
    ,oper_teller_id_2 varchar2(60) -- 操作柜员编号2
    ,jud_remit_chn_id varchar2(60) -- 解冻解止渠道编号
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
grant select on ${iml_schema}.evt_ifs_jud_remit_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_ifs_jud_remit_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_ifs_jud_remit_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ifs_jud_remit_rgst_b is '联合存款解冻解止登记簿';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.unfrz_dt is '解冻日期';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.unfrz_tm is '解冻时间';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.remit_way_cd is '解除方式代码';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.remit_proof_cate_cd is '解除证明类别代码';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.proof_num is '证明文号';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.exec_org is '执行机关';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.exec_ps_cert_type_cd_1 is '执行人证件类型代码1';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.exec_ps_cert_no_1 is '执行人证件号码1';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.exec_ps_cert_type_cd_2 is '执行人证件类型代码2';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.exec_ps_cert_no_2 is '执行人证件号码2';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.exec_ps_name is '执行人姓名';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.remit_rs is '解除原因';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.oper_teller_id is '操作柜员编号';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.org_id is '机构编号';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.init_froz_dt is '原冻结日期';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.init_froz_flow_num is '原冻结流水号';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.remit_amt is '解除金额';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.oper_teller_id_2 is '操作柜员编号2';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.jud_remit_chn_id is '解冻解止渠道编号';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ifs_jud_remit_rgst_b.etl_timestamp is 'ETL处理时间戳';
