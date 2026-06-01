/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_white_relative_edit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_white_relative_edit
whenever sqlerror continue none;
drop table ${iol_schema}.icms_white_relative_edit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_white_relative_edit(
    serialno varchar2(32) -- 流水号
    ,currency varchar2(18) -- 币种
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,editflag varchar2(2) -- 操作标识(1新增2修改3删除)
    ,rotative varchar2(2) -- 是否循环
    ,linesum2 number(24,4) -- 敞口限额
    ,linesum1 number(24,4) -- 授信限额
    ,serialnowf varchar2(32) -- 白名单流水号
    ,businesstype varchar2(32) -- 业务品种
    ,ifexclusivecredit varchar2(2) -- 是否专属额度
    ,contractserialno varchar2(32) -- 合同流水号
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
grant select on ${iol_schema}.icms_white_relative_edit to ${iml_schema};
grant select on ${iol_schema}.icms_white_relative_edit to ${icl_schema};
grant select on ${iol_schema}.icms_white_relative_edit to ${idl_schema};
grant select on ${iol_schema}.icms_white_relative_edit to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_white_relative_edit is '流程中的sxd白名单已关联额度合同';
comment on column ${iol_schema}.icms_white_relative_edit.serialno is '流水号';
comment on column ${iol_schema}.icms_white_relative_edit.currency is '币种';
comment on column ${iol_schema}.icms_white_relative_edit.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_white_relative_edit.editflag is '操作标识(1新增2修改3删除)';
comment on column ${iol_schema}.icms_white_relative_edit.rotative is '是否循环';
comment on column ${iol_schema}.icms_white_relative_edit.linesum2 is '敞口限额';
comment on column ${iol_schema}.icms_white_relative_edit.linesum1 is '授信限额';
comment on column ${iol_schema}.icms_white_relative_edit.serialnowf is '白名单流水号';
comment on column ${iol_schema}.icms_white_relative_edit.businesstype is '业务品种';
comment on column ${iol_schema}.icms_white_relative_edit.ifexclusivecredit is '是否专属额度';
comment on column ${iol_schema}.icms_white_relative_edit.contractserialno is '合同流水号';
comment on column ${iol_schema}.icms_white_relative_edit.start_dt is '开始时间';
comment on column ${iol_schema}.icms_white_relative_edit.end_dt is '结束时间';
comment on column ${iol_schema}.icms_white_relative_edit.id_mark is '增删标志';
comment on column ${iol_schema}.icms_white_relative_edit.etl_timestamp is 'ETL处理时间戳';
