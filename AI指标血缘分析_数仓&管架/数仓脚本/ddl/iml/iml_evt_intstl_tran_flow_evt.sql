/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_intstl_tran_flow_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_intstl_tran_flow_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_intstl_tran_flow_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_intstl_tran_flow_evt(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_evt_id varchar2(100) -- 源事件编号
    ,tran_tm timestamp -- 交易时间
    ,tran_code varchar2(45) -- 交易码
    ,rgst_teller_id varchar2(60) -- 登记柜员编号
    ,tran_name varchar2(375) -- 交易名称
    ,tran_id varchar2(60) -- 交易编号
    ,bus_table_name varchar2(375) -- 业务表名称
    ,bus_tab_flow_num varchar2(60) -- 业务表流水号
    ,tran_descb varchar2(375) -- 交易描述
    ,bus_teller_id varchar2(60) -- 业务柜员编号
    ,tran_cmplt_tm timestamp -- 交易完成时间
    ,remark varchar2(750) -- 备注
    ,auth_status_cd varchar2(30) -- 授权状态代码
    ,submit_status_cd varchar2(30) -- 提交状态代码
    ,check_dt date -- 复核日期
    ,auth_curr_cd varchar2(30) -- 授权币种代码
    ,auth_amt number(30,8) -- 授权金额
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_amt number(30,8) -- 交易金额
    ,modif_teller_id varchar2(60) -- 修改柜员编号
    ,ord_tab_flow_num varchar2(60) -- ORD表流水号
    ,org_id varchar2(60) -- 机构编号
    ,entry_org_id varchar2(60) -- 记账机构编号
    ,bus_belong_org_id varchar2(60) -- 业务所属机构编号
    ,org_idf_cd varchar2(30) -- 机构标识代码
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,revs_flow_num varchar2(100) -- 冲正流水号
    ,revs_rs varchar2(750) -- 冲正原因
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_intstl_tran_flow_evt to ${icl_schema};
grant select on ${iml_schema}.evt_intstl_tran_flow_evt to ${idl_schema};
grant select on ${iml_schema}.evt_intstl_tran_flow_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_intstl_tran_flow_evt is '国结交易流水事件';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.src_evt_id is '源事件编号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.tran_code is '交易码';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.tran_name is '交易名称';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.tran_id is '交易编号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.bus_table_name is '业务表名称';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.bus_tab_flow_num is '业务表流水号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.tran_descb is '交易描述';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.bus_teller_id is '业务柜员编号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.tran_cmplt_tm is '交易完成时间';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.remark is '备注';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.auth_status_cd is '授权状态代码';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.submit_status_cd is '提交状态代码';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.check_dt is '复核日期';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.auth_curr_cd is '授权币种代码';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.auth_amt is '授权金额';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.modif_teller_id is '修改柜员编号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.ord_tab_flow_num is 'ORD表流水号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.org_id is '机构编号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.entry_org_id is '记账机构编号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.bus_belong_org_id is '业务所属机构编号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.org_idf_cd is '机构标识代码';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.revs_flow_num is '冲正流水号';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.revs_rs is '冲正原因';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.start_dt is '开始时间';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.end_dt is '结束时间';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.id_mark is '增删标志';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_intstl_tran_flow_evt.etl_timestamp is 'ETL处理时间戳';
