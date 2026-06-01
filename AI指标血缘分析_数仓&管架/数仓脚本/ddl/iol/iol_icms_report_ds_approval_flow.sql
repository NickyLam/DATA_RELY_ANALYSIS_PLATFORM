/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_report_ds_approval_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_report_ds_approval_flow
whenever sqlerror continue none;
drop table ${iol_schema}.icms_report_ds_approval_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_report_ds_approval_flow(
    partitiondate varchar2(10) -- 分区日期
    ,bizno varchar2(32) -- 流水号
    ,bankno varchar2(10) -- 银行号
    ,custscore number(10,2) -- 客户评分
    ,finalret varchar2(20) -- 最终审批结果
    ,oursapprovalret varchar2(20) -- 合作行审批结果
    ,codeblock varchar2(300) -- 拒绝码
    ,isfirst varchar2(10) -- 是否首借
    ,outerret varchar2(20) -- 合作行机房审批结果
    ,pszret varchar2(20) -- psz区审批结果
    ,biznbr varchar2(32) -- 流水nbr
    ,rstuserfield1 number(22) -- 是否使用审批额度
    ,rstuserfield2 number(22) -- 备用字段2
    ,rstuserfield3 number(22) -- 备用字段3
    ,rstuserfield4 number(22) -- 备用字段4
    ,rstuserfield5 number(22) -- 备用字段5
    ,rstuserfield6 number(15,2) -- 审批额度
    ,rstuserfield7 number(15,2) -- 建议额度
    ,rstuserfield8 number(15,6) -- 备用字段8
    ,rstuserfield9 number(19,6) -- 备用字段9
    ,rstuserfield10 number(19,6) -- 备用字段10
    ,rstuserfield11 varchar2(2) -- 是否同意签约
    ,rstuserfield12 varchar2(2) -- 是否同意放款
    ,rstuserfield13 varchar2(20) -- 用途类型
    ,rstuserfield14 number(20) -- 客户号
    ,rstuserfield15 varchar2(50) -- 送审时方案
    ,rstuserfield16 varchar2(50) -- 审批额度到期日
    ,rstuserfield17 varchar2(50) -- 备用字段17
    ,rstuserfield18 varchar2(50) -- 备用字段18
    ,rstuserfield19 varchar2(50) -- 备用字段19
    ,rstuserfield20 varchar2(50) -- 备用字段20
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
grant select on ${iol_schema}.icms_report_ds_approval_flow to ${iml_schema};
grant select on ${iol_schema}.icms_report_ds_approval_flow to ${icl_schema};
grant select on ${iol_schema}.icms_report_ds_approval_flow to ${idl_schema};
grant select on ${iol_schema}.icms_report_ds_approval_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_report_ds_approval_flow is '微粒贷双边审批结果表';
comment on column ${iol_schema}.icms_report_ds_approval_flow.partitiondate is '分区日期';
comment on column ${iol_schema}.icms_report_ds_approval_flow.bizno is '流水号';
comment on column ${iol_schema}.icms_report_ds_approval_flow.bankno is '银行号';
comment on column ${iol_schema}.icms_report_ds_approval_flow.custscore is '客户评分';
comment on column ${iol_schema}.icms_report_ds_approval_flow.finalret is '最终审批结果';
comment on column ${iol_schema}.icms_report_ds_approval_flow.oursapprovalret is '合作行审批结果';
comment on column ${iol_schema}.icms_report_ds_approval_flow.codeblock is '拒绝码';
comment on column ${iol_schema}.icms_report_ds_approval_flow.isfirst is '是否首借';
comment on column ${iol_schema}.icms_report_ds_approval_flow.outerret is '合作行机房审批结果';
comment on column ${iol_schema}.icms_report_ds_approval_flow.pszret is 'psz区审批结果';
comment on column ${iol_schema}.icms_report_ds_approval_flow.biznbr is '流水nbr';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield1 is '是否使用审批额度';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield2 is '备用字段2';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield3 is '备用字段3';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield4 is '备用字段4';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield5 is '备用字段5';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield6 is '审批额度';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield7 is '建议额度';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield8 is '备用字段8';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield9 is '备用字段9';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield10 is '备用字段10';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield11 is '是否同意签约';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield12 is '是否同意放款';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield13 is '用途类型';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield14 is '客户号';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield15 is '送审时方案';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield16 is '审批额度到期日';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield17 is '备用字段17';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield18 is '备用字段18';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield19 is '备用字段19';
comment on column ${iol_schema}.icms_report_ds_approval_flow.rstuserfield20 is '备用字段20';
comment on column ${iol_schema}.icms_report_ds_approval_flow.start_dt is '开始时间';
comment on column ${iol_schema}.icms_report_ds_approval_flow.end_dt is '结束时间';
comment on column ${iol_schema}.icms_report_ds_approval_flow.id_mark is '增删标志';
comment on column ${iol_schema}.icms_report_ds_approval_flow.etl_timestamp is 'ETL处理时间戳';
