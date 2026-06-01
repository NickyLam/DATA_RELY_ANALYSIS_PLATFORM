/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_tbox_cash_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_tbox_cash_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.ref_tbox_cash_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tbox_cash_tran_flow(
    tran_flow_num varchar2(100) -- 转移流水号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_type_cd varchar2(30) -- 转移类型代码
    ,tran_status_cd varchar2(30) -- 转移状态代码
    ,tran_dt date -- 转移日期
    ,tran_out_org_id varchar2(100) -- 转出机构编号
    ,cntpty_org_type_cd varchar2(30) -- 对手机构类型代码
    ,cntpty_org_id varchar2(100) -- 对手机构编号
    ,tran_out_tail_box_id varchar2(100) -- 转出尾箱编号
    ,cntpty_tail_box_id varchar2(100) -- 对手尾箱编号
    ,tran_out_teller_id varchar2(100) -- 转出柜员编号
    ,cntpty_teller_id varchar2(100) -- 对手柜员编号
    ,tran_ref_no varchar2(60) -- 转出交易参考号
    ,cntpty_tran_ref_no varchar2(60) -- 对手交易参考号
    ,tran_code varchar2(100) -- 交易码
    ,tran_descb varchar2(500) -- 交易描述
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cust_acct_num varchar2(60) -- 客户账号
    ,sub_acct_num varchar2(60) -- 子账号
    ,cntpty_cust_id varchar2(100) -- 对手客户编号
    ,vouch_type_cd varchar2(30) -- 凭证类型代码
    ,vouch_no varchar2(60) -- 凭证号码
    ,pbc_cash_out_in_whs_type_cd varchar2(30) -- 人行现金出入库类型代码
    ,remark varchar2(500) -- 备注
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
grant select on ${iml_schema}.ref_tbox_cash_tran_flow to ${icl_schema};
grant select on ${iml_schema}.ref_tbox_cash_tran_flow to ${idl_schema};
grant select on ${iml_schema}.ref_tbox_cash_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_tbox_cash_tran_flow is '尾箱现金转移登记流水';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.tran_flow_num is '转移流水号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.tran_type_cd is '转移类型代码';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.tran_status_cd is '转移状态代码';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.tran_dt is '转移日期';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.tran_out_org_id is '转出机构编号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.cntpty_org_type_cd is '对手机构类型代码';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.cntpty_org_id is '对手机构编号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.tran_out_tail_box_id is '转出尾箱编号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.cntpty_tail_box_id is '对手尾箱编号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.tran_out_teller_id is '转出柜员编号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.cntpty_teller_id is '对手柜员编号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.tran_ref_no is '转出交易参考号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.cntpty_tran_ref_no is '对手交易参考号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.tran_code is '交易码';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.tran_descb is '交易描述';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.cust_id is '客户编号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.cust_name is '客户名称';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.cust_acct_num is '客户账号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.sub_acct_num is '子账号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.cntpty_cust_id is '对手客户编号';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.vouch_type_cd is '凭证类型代码';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.vouch_no is '凭证号码';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.pbc_cash_out_in_whs_type_cd is '人行现金出入库类型代码';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.remark is '备注';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.start_dt is '开始时间';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.end_dt is '结束时间';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.id_mark is '增删标志';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.ref_tbox_cash_tran_flow.etl_timestamp is 'ETL处理时间戳';
