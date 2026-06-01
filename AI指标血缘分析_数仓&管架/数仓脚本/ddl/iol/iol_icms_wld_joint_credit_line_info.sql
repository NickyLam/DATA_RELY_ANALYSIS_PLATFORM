/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wld_joint_credit_line_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wld_joint_credit_line_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wld_joint_credit_line_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wld_joint_credit_line_info(
    bizno varchar2(32) -- 流水号
    ,custid varchar2(32) -- 客户号
    ,idtype varchar2(4) -- 证件类型
    ,idno varchar2(30) -- 证件号码
    ,loancode varchar2(32) -- 产品类型
    ,currentlimit number(15,2) -- 可用额度
    ,settledate date -- 结清日期
    ,applydate date -- 申请日期
    ,signage varchar2(2) -- 新旧微粒贷标识
    ,limitamount number(15,2) -- 额度金额
    ,effectiveflag varchar2(2) -- 生效标识
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
grant select on ${iol_schema}.icms_wld_joint_credit_line_info to ${iml_schema};
grant select on ${iol_schema}.icms_wld_joint_credit_line_info to ${icl_schema};
grant select on ${iol_schema}.icms_wld_joint_credit_line_info to ${idl_schema};
grant select on ${iol_schema}.icms_wld_joint_credit_line_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wld_joint_credit_line_info is '联合贷额度信息表';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.bizno is '流水号';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.custid is '客户号';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.idtype is '证件类型';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.idno is '证件号码';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.loancode is '产品类型';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.currentlimit is '可用额度';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.settledate is '结清日期';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.applydate is '申请日期';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.signage is '新旧微粒贷标识';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.limitamount is '额度金额';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.effectiveflag is '生效标识';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wld_joint_credit_line_info.etl_timestamp is 'ETL处理时间戳';
