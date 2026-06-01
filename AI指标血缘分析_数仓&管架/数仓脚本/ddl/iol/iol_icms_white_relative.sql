/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_white_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_white_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_white_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_white_relative(
    serialno varchar2(32) -- 流水号
    ,serialnowf varchar2(32) -- 白名单流水号
    ,currency varchar2(18) -- 币种
    ,migtflag varchar2(80) -- 
    ,rotative varchar2(2) -- 是否循环
    ,ifexclusivecredit varchar2(2) -- 是否专属额度
    ,businesstype varchar2(32) -- 业务品种
    ,linesum1 number(24,4) -- 授信限额
    ,contractserialno varchar2(32) -- 合同流水号
    ,linesum2 number(24,4) -- 敞口限额
    ,editflag varchar2(2) -- 操作标识(1新增2修改3删除)
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
grant select on ${iol_schema}.icms_white_relative to ${iml_schema};
grant select on ${iol_schema}.icms_white_relative to ${icl_schema};
grant select on ${iol_schema}.icms_white_relative to ${idl_schema};
grant select on ${iol_schema}.icms_white_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_white_relative is '线上业务sxd白名单已关联额度合同';
comment on column ${iol_schema}.icms_white_relative.serialno is '流水号';
comment on column ${iol_schema}.icms_white_relative.serialnowf is '白名单流水号';
comment on column ${iol_schema}.icms_white_relative.currency is '币种';
comment on column ${iol_schema}.icms_white_relative.migtflag is '';
comment on column ${iol_schema}.icms_white_relative.rotative is '是否循环';
comment on column ${iol_schema}.icms_white_relative.ifexclusivecredit is '是否专属额度';
comment on column ${iol_schema}.icms_white_relative.businesstype is '业务品种';
comment on column ${iol_schema}.icms_white_relative.linesum1 is '授信限额';
comment on column ${iol_schema}.icms_white_relative.contractserialno is '合同流水号';
comment on column ${iol_schema}.icms_white_relative.linesum2 is '敞口限额';
comment on column ${iol_schema}.icms_white_relative.editflag is '操作标识(1新增2修改3删除)';
comment on column ${iol_schema}.icms_white_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_white_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_white_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_white_relative.etl_timestamp is 'ETL处理时间戳';
