/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1wsp_batch_dtl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1wsp_batch_dtl_info
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1wsp_batch_dtl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1wsp_batch_dtl_info(
    detail_no varchar2(192) -- 明细编号
    ,batch_no varchar2(192) -- 批次编号
    ,trans_status varchar2(12) -- 交易状态(00-初始化;01-交易成功;02-交易失败;03-状态未知;99-处理中)
    ,payee_acct_no varchar2(192) -- 收款账号
    ,trans_amt number(20,2) -- 交易金额
    ,trans_split_amt varchar2(4000) -- 交易金额(超限拆分)
    ,dtl_remark varchar2(1536) -- 明细备注
    ,employee_id varchar2(192) -- 员工ID
    ,employee_name varchar2(1536) -- 员工姓名
    ,phone_no varchar2(108) -- 员工电话
    ,cert_no varchar2(192) -- 员工证件号码
    ,company_id varchar2(192) -- 企业ID
    ,company_name varchar2(768) -- 企业名称
    ,row_num number(16) -- 行号
    ,create_timestamp varchar2(144) -- 创建时间戳
    ,update_timestamp varchar2(144) -- 更新时间戳
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
grant select on ${iol_schema}.mpcs_a1wsp_batch_dtl_info to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1wsp_batch_dtl_info to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1wsp_batch_dtl_info to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1wsp_batch_dtl_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1wsp_batch_dtl_info is '代发批次明细信息表';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.detail_no is '明细编号';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.batch_no is '批次编号';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.trans_status is '交易状态(00-初始化;01-交易成功;02-交易失败;03-状态未知;99-处理中)';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.payee_acct_no is '收款账号';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.trans_amt is '交易金额';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.trans_split_amt is '交易金额(超限拆分)';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.dtl_remark is '明细备注';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.employee_id is '员工ID';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.employee_name is '员工姓名';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.phone_no is '员工电话';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.cert_no is '员工证件号码';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.company_id is '企业ID';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.company_name is '企业名称';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.row_num is '行号';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1wsp_batch_dtl_info.etl_timestamp is 'ETL处理时间戳';
