/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_comn_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_comn_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_comn_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_comn_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,sob_id varchar2(100) -- 账套编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,cust_id varchar2(100) -- 客户编号
    ,bus_acct_id varchar2(100) -- 业务账户编号
    ,bus_type_id varchar2(100) -- 业务类型编号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_code varchar2(60) -- 交易码
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,tran_dir_cd varchar2(30) -- 交易方向代码
    ,tard_way_cd varchar2(30) -- 交易方式代码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,acct_instit_id varchar2(100) -- 账务机构编号
    ,revs_flg varchar2(10) -- 冲正标志
    ,brevs_bus_tran_dt date -- 被冲正业务交易日期
    ,brevs_bus_tran_flow_num varchar2(100) -- 被冲正业务交易流水号
    ,sorc_sys_cd varchar2(30) -- 源系统代码
    ,bal_type_cd varchar2(30) -- 余额类型代码
    ,charge_doc_id varchar2(100) -- 收费单据编号
    ,evt_type_id varchar2(100) -- 事件类型编号
    ,amt_8 number(30,2) -- 金额8
    ,amt_6 number(30,2) -- 金额6
    ,amt_5 number(30,2) -- 金额5
    ,process_cd varchar2(30) -- 处理码
    ,remark varchar2(100) -- 备注
    ,cap_char_cd varchar2(30) -- 资金性质代码
    ,taxable_flg varchar2(10) -- 应税标志
    ,int_accr_way_cd varchar2(30) -- 计息方式代码
    ,core_tran_dt date -- 核心交易日期
    ,batch_no varchar2(60) -- 批次号
    ,emply_id varchar2(100) -- 员工编号
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
grant select on ${iml_schema}.evt_comn_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_comn_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_comn_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_comn_tran_flow is '通用交易流水';
comment on column ${iml_schema}.evt_comn_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_comn_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_comn_tran_flow.sob_id is '账套编号';
comment on column ${iml_schema}.evt_comn_tran_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_comn_tran_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_comn_tran_flow.bus_acct_id is '业务账户编号';
comment on column ${iml_schema}.evt_comn_tran_flow.bus_type_id is '业务类型编号';
comment on column ${iml_schema}.evt_comn_tran_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_comn_tran_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_comn_tran_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_comn_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_comn_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_comn_tran_flow.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.evt_comn_tran_flow.tard_way_cd is '交易方式代码';
comment on column ${iml_schema}.evt_comn_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_comn_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_comn_tran_flow.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.evt_comn_tran_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_comn_tran_flow.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.evt_comn_tran_flow.revs_flg is '冲正标志';
comment on column ${iml_schema}.evt_comn_tran_flow.brevs_bus_tran_dt is '被冲正业务交易日期';
comment on column ${iml_schema}.evt_comn_tran_flow.brevs_bus_tran_flow_num is '被冲正业务交易流水号';
comment on column ${iml_schema}.evt_comn_tran_flow.sorc_sys_cd is '源系统代码';
comment on column ${iml_schema}.evt_comn_tran_flow.bal_type_cd is '余额类型代码';
comment on column ${iml_schema}.evt_comn_tran_flow.charge_doc_id is '收费单据编号';
comment on column ${iml_schema}.evt_comn_tran_flow.evt_type_id is '事件类型编号';
comment on column ${iml_schema}.evt_comn_tran_flow.amt_8 is '金额8';
comment on column ${iml_schema}.evt_comn_tran_flow.amt_6 is '金额6';
comment on column ${iml_schema}.evt_comn_tran_flow.amt_5 is '金额5';
comment on column ${iml_schema}.evt_comn_tran_flow.process_cd is '处理码';
comment on column ${iml_schema}.evt_comn_tran_flow.remark is '备注';
comment on column ${iml_schema}.evt_comn_tran_flow.cap_char_cd is '资金性质代码';
comment on column ${iml_schema}.evt_comn_tran_flow.taxable_flg is '应税标志';
comment on column ${iml_schema}.evt_comn_tran_flow.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.evt_comn_tran_flow.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_comn_tran_flow.batch_no is '批次号';
comment on column ${iml_schema}.evt_comn_tran_flow.emply_id is '员工编号';
comment on column ${iml_schema}.evt_comn_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_comn_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_comn_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_comn_tran_flow.etl_timestamp is 'ETL处理时间戳';
