/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ibank_manual_entry_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ibank_manual_entry_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ibank_manual_entry_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibank_manual_entry_evt(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,rec_id varchar2(150) -- 记录ID
    ,entry_dt date -- 记账日期
    ,bus_org_id varchar2(100) -- 业务机构编号
    ,entry_flow_num varchar2(100) -- 分录流水号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_teller_name varchar2(375) -- 登记柜员名称
    ,entry_teller_id varchar2(100) -- 记账柜员编号
    ,entry_teller_name varchar2(375) -- 记账柜员名称
    ,rgst_tm timestamp -- 登记时间
    ,entry_tm timestamp -- 记账时间
    ,entry_status_cd varchar2(30) -- 记账状态代码
    ,remark varchar2(1500) -- 备注
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,check_teller_name varchar2(375) -- 复核柜员名称
    ,entry_type_cd varchar2(30) -- 记账类型代码
    ,tran_id varchar2(250) -- 交易编号
    ,entry_idf_cd varchar2(30) -- 记账标识代码
    ,accti_bal_id varchar2(150) -- 核算余额ID
    ,cntpty_id varchar2(250) -- 交易对手编号
    ,cntpty_name varchar2(500) -- 交易对手名称
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
grant select on ${iml_schema}.evt_ibank_manual_entry_evt to ${icl_schema};
grant select on ${iml_schema}.evt_ibank_manual_entry_evt to ${idl_schema};
grant select on ${iml_schema}.evt_ibank_manual_entry_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ibank_manual_entry_evt is '同业手工记账事件';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.rec_id is '记录ID';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.entry_dt is '记账日期';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.bus_org_id is '业务机构编号';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.entry_flow_num is '分录流水号';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.rgst_teller_name is '登记柜员名称';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.entry_teller_id is '记账柜员编号';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.entry_teller_name is '记账柜员名称';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.rgst_tm is '登记时间';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.entry_tm is '记账时间';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.remark is '备注';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.check_teller_name is '复核柜员名称';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.entry_type_cd is '记账类型代码';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.tran_id is '交易编号';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.entry_idf_cd is '记账标识代码';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.accti_bal_id is '核算余额ID';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ibank_manual_entry_evt.etl_timestamp is 'ETL处理时间戳';
