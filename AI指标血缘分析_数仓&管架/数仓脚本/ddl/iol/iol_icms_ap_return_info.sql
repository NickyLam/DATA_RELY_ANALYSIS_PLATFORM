/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_return_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_return_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_return_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_return_info(
    returnno varchar2(64) -- 回款编号
    ,updateuserid varchar2(64) -- 更新人编号
    ,inputuserid varchar2(64) -- 登记人编号
    ,liquidatecost number(24,6) -- 清收费用
    ,returndate date -- 回款日期
    ,tmsp varchar2(64) -- 时间戳
    ,caseprogramstage varchar2(36) -- 程序阶段
    ,updateorgid varchar2(64) -- 更新机构编号
    ,remark varchar2(1000) -- 备注
    ,payno varchar2(160) -- 还款账号
    ,updatedate date -- 更新日期
    ,caseno varchar2(64) -- 关联案件项目编号
    ,liquidateinterest number(24,6) -- 清收利息
    ,inputorgid varchar2(64) -- 登记机构编号
    ,inputdate date -- 登记日期
    ,returnsum number(24,6) -- 本次回款金额
    ,liquidatesum number(24,6) -- 清收本金
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
grant select on ${iol_schema}.icms_ap_return_info to ${iml_schema};
grant select on ${iol_schema}.icms_ap_return_info to ${icl_schema};
grant select on ${iol_schema}.icms_ap_return_info to ${idl_schema};
grant select on ${iol_schema}.icms_ap_return_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_return_info is '执行回款信息表';
comment on column ${iol_schema}.icms_ap_return_info.returnno is '回款编号';
comment on column ${iol_schema}.icms_ap_return_info.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_ap_return_info.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_ap_return_info.liquidatecost is '清收费用';
comment on column ${iol_schema}.icms_ap_return_info.returndate is '回款日期';
comment on column ${iol_schema}.icms_ap_return_info.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_return_info.caseprogramstage is '程序阶段';
comment on column ${iol_schema}.icms_ap_return_info.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_ap_return_info.remark is '备注';
comment on column ${iol_schema}.icms_ap_return_info.payno is '还款账号';
comment on column ${iol_schema}.icms_ap_return_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_return_info.caseno is '关联案件项目编号';
comment on column ${iol_schema}.icms_ap_return_info.liquidateinterest is '清收利息';
comment on column ${iol_schema}.icms_ap_return_info.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_ap_return_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_return_info.returnsum is '本次回款金额';
comment on column ${iol_schema}.icms_ap_return_info.liquidatesum is '清收本金';
comment on column ${iol_schema}.icms_ap_return_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_return_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_return_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_return_info.etl_timestamp is 'ETL处理时间戳';
