/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_reg_debit_crdt_sign_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_reg_debit_crdt_sign_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_reg_debit_crdt_sign_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_reg_debit_crdt_sign_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(100) -- 合同编号
    ,sign_corp_id varchar2(100) -- 签约单位编号
    ,cont_seq_num varchar2(60) -- 合同顺序号
    ,city_cd varchar2(30) -- 所在城市代码
    ,cont_type_cd varchar2(30) -- 合同类型代码
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,bus_kind_cd varchar2(30) -- 业务种类代码
    ,cont_status_cd varchar2(30) -- 合同状态代码
    ,obank_init_flg varchar2(10) -- 他行发起标志
    ,obank_no varchar2(100) -- 他行行号
    ,obank_name varchar2(750) -- 他行行名
    ,obank_acct_num varchar2(100) -- 他行账号
    ,obank_acct_name varchar2(750) -- 他行户名
    ,ghb_bank_no varchar2(100) -- 本行行号
    ,ghb_bank_name varchar2(750) -- 本行行名
    ,ghb_acct_num varchar2(100) -- 本行账号
    ,ghb_acct_name varchar2(750) -- 本行户名
    ,cont_sign_dt date -- 合同签订日期
    ,cont_revo_dt date -- 合同撤销日期
    ,teller_id varchar2(250) -- 柜员编号
    ,org_id varchar2(250) -- 机构编号
    ,remark varchar2(750) -- 备注
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_reg_debit_crdt_sign_h to ${icl_schema};
grant select on ${iml_schema}.agt_reg_debit_crdt_sign_h to ${idl_schema};
grant select on ${iml_schema}.agt_reg_debit_crdt_sign_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_reg_debit_crdt_sign_h is '定期借贷记签约历史';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.sign_corp_id is '签约单位编号';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.cont_seq_num is '合同顺序号';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.city_cd is '所在城市代码';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.cont_type_cd is '合同类型代码';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.bus_kind_cd is '业务种类代码';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.cont_status_cd is '合同状态代码';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.obank_init_flg is '他行发起标志';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.obank_no is '他行行号';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.obank_name is '他行行名';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.obank_acct_num is '他行账号';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.obank_acct_name is '他行户名';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.ghb_bank_no is '本行行号';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.ghb_bank_name is '本行行名';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.ghb_acct_num is '本行账号';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.ghb_acct_name is '本行户名';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.cont_sign_dt is '合同签订日期';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.cont_revo_dt is '合同撤销日期';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.teller_id is '柜员编号';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.remark is '备注';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_reg_debit_crdt_sign_h.etl_timestamp is 'ETL处理时间戳';
