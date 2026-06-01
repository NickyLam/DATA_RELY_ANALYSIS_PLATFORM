/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wqd_risk_impawn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wqd_risk_impawn
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wqd_risk_impawn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wqd_risk_impawn(
    serialno varchar2(64) -- 流水号
    ,objecttype varchar2(32) -- 决策对象
    ,objectno varchar2(32) -- 决策编号
    ,applyno varchar2(64) -- 信贷申请流水号
    ,buildingtype   varchar2(12) -- 抵押物类型
    ,buildingaddress    varchar2(300) -- 抵押物地址
    ,finalvaluationtotal         number(24,6) -- 最终评估价值
    ,valuationamount number(24,6) -- 单个抵押物审批额度
    ,serialnumber varchar2(16) -- 序号
    ,valuationcompany varchar2(200) -- 评估公司名称
    ,valuationtotal number(24,6) -- 评估总价
    ,isfinalvaluationtotal varchar2(4) -- 是否被引用为最终评估价值
    ,remark1 varchar2(32) -- 备用字段1
    ,remark2 varchar2(32) -- 备用字段2
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
grant select on ${iol_schema}.icms_wqd_risk_impawn to ${iml_schema};
grant select on ${iol_schema}.icms_wqd_risk_impawn to ${icl_schema};
grant select on ${iol_schema}.icms_wqd_risk_impawn to ${idl_schema};
grant select on ${iol_schema}.icms_wqd_risk_impawn to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wqd_risk_impawn is '风控抵押物评估信息表';
comment on column ${iol_schema}.icms_wqd_risk_impawn.serialno is '流水号';
comment on column ${iol_schema}.icms_wqd_risk_impawn.objecttype is '决策对象';
comment on column ${iol_schema}.icms_wqd_risk_impawn.objectno is '决策编号';
comment on column ${iol_schema}.icms_wqd_risk_impawn.applyno is '信贷申请流水号';
comment on column ${iol_schema}.icms_wqd_risk_impawn.buildingtype   is '抵押物类型';
comment on column ${iol_schema}.icms_wqd_risk_impawn.buildingaddress    is '抵押物地址';
comment on column ${iol_schema}.icms_wqd_risk_impawn.finalvaluationtotal         is '最终评估价值';
comment on column ${iol_schema}.icms_wqd_risk_impawn.valuationamount is '单个抵押物审批额度';
comment on column ${iol_schema}.icms_wqd_risk_impawn.serialnumber is '序号';
comment on column ${iol_schema}.icms_wqd_risk_impawn.valuationcompany is '评估公司名称';
comment on column ${iol_schema}.icms_wqd_risk_impawn.valuationtotal is '评估总价';
comment on column ${iol_schema}.icms_wqd_risk_impawn.isfinalvaluationtotal is '是否被引用为最终评估价值';
comment on column ${iol_schema}.icms_wqd_risk_impawn.remark1 is '备用字段1';
comment on column ${iol_schema}.icms_wqd_risk_impawn.remark2 is '备用字段2';
comment on column ${iol_schema}.icms_wqd_risk_impawn.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wqd_risk_impawn.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wqd_risk_impawn.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wqd_risk_impawn.etl_timestamp is 'ETL处理时间戳';
