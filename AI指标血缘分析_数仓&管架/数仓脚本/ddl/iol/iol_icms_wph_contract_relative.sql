/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_contract_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_contract_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_contract_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_contract_relative(
    serialno varchar2(64) -- 流水号
    ,objecttype varchar2(64) -- 对象类型
    ,objectno varchar2(64) -- 对象编号
    ,relativesum number(24,6) -- 关联金额
    ,migtflag varchar2(80) -- 迁移标志
    ,relationstatus varchar2(3) -- 关联关系是否有效
    ,renewsum number(24,6) -- 展期金额
    ,renewdate date -- 展期后到期日
    ,syncremovestatus varchar2(3) -- 同步解除业务合同关系状态：0否，1是
    ,isoldyr varchar2(4) -- 是否引入原额度合同的担保合同
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
grant select on ${iol_schema}.icms_wph_contract_relative to ${iml_schema};
grant select on ${iol_schema}.icms_wph_contract_relative to ${icl_schema};
grant select on ${iol_schema}.icms_wph_contract_relative to ${idl_schema};
grant select on ${iol_schema}.icms_wph_contract_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_contract_relative is '唯品会贷款合同与担保合同关联关系表';
comment on column ${iol_schema}.icms_wph_contract_relative.serialno is '流水号';
comment on column ${iol_schema}.icms_wph_contract_relative.objecttype is '对象类型';
comment on column ${iol_schema}.icms_wph_contract_relative.objectno is '对象编号';
comment on column ${iol_schema}.icms_wph_contract_relative.relativesum is '关联金额';
comment on column ${iol_schema}.icms_wph_contract_relative.migtflag is '迁移标志';
comment on column ${iol_schema}.icms_wph_contract_relative.relationstatus is '关联关系是否有效';
comment on column ${iol_schema}.icms_wph_contract_relative.renewsum is '展期金额';
comment on column ${iol_schema}.icms_wph_contract_relative.renewdate is '展期后到期日';
comment on column ${iol_schema}.icms_wph_contract_relative.syncremovestatus is '同步解除业务合同关系状态：0否，1是';
comment on column ${iol_schema}.icms_wph_contract_relative.isoldyr is '是否引入原额度合同的担保合同';
comment on column ${iol_schema}.icms_wph_contract_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wph_contract_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wph_contract_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wph_contract_relative.etl_timestamp is 'ETL处理时间戳';
