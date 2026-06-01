/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ifs_ct_froz_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ifs_ct_froz_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ifs_ct_froz_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ifs_ct_froz_rgst_b(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,ct_froz_dt date -- 续冻日期
    ,ct_froz_tm varchar2(30) -- 续冻时间
    ,ct_froz_amt number(30,2) -- 续冻金额
    ,init_froz_end_dt date -- 原冻结截至日期
    ,init_proof_cate_cd varchar2(10) -- 原证明类别代码
    ,init_cert_num varchar2(250) -- 原证明书号
    ,init_froz_rs varchar2(375) -- 原冻结原因
    ,init_exec_org varchar2(1500) -- 原执行机关
    ,init_exec_cert_1 varchar2(15) -- 原执行证件1
    ,init_exec_num_1 varchar2(60) -- 原执行号码1
    ,init_exec_cert_2 varchar2(15) -- 原执行证件2
    ,init_exec_num_2 varchar2(60) -- 原执行号码2
    ,init_exec_ps varchar2(45) -- 原执行人
    ,init_froz_dt date -- 原冻结日期
    ,init_froz_flow varchar2(90) -- 原冻结流水
    ,init_froz_seq_num varchar2(60) -- 原冻结序号
    ,init_exec_ps_2 varchar2(45) -- 原执行人2
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
grant select on ${iml_schema}.evt_ifs_ct_froz_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_ifs_ct_froz_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_ifs_ct_froz_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ifs_ct_froz_rgst_b is '联合存款续冻登记簿';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.ct_froz_dt is '续冻日期';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.ct_froz_tm is '续冻时间';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.ct_froz_amt is '续冻金额';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_froz_end_dt is '原冻结截至日期';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_proof_cate_cd is '原证明类别代码';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_cert_num is '原证明书号';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_froz_rs is '原冻结原因';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_exec_org is '原执行机关';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_exec_cert_1 is '原执行证件1';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_exec_num_1 is '原执行号码1';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_exec_cert_2 is '原执行证件2';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_exec_num_2 is '原执行号码2';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_exec_ps is '原执行人';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_froz_dt is '原冻结日期';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_froz_flow is '原冻结流水';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_froz_seq_num is '原冻结序号';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.init_exec_ps_2 is '原执行人2';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ifs_ct_froz_rgst_b.etl_timestamp is 'ETL处理时间戳';
