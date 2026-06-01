/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_guaranty_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_guaranty_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_guaranty_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_guaranty_relative(
    objecttype varchar2(64) -- 对象类型
    ,objectno varchar2(64) -- 对象编号
    ,guarantycontractno varchar2(50) -- 担保合同编号
    ,clrid varchar2(64) -- 担保物编号
    ,relationstatus varchar2(12) -- 关联状态
    ,guarantysum number(24,6) -- 担保金额
    ,guarantycurrency varchar2(18) -- 担保金额币种
    ,guarantyrate number(24,6) -- 抵/质押率（%）
    ,actualguarantyrate number(24,6) -- 实际抵、质押率%
    ,remark varchar2(1000) -- 备注
    ,inputorgid varchar2(200) -- 登记机构
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(200) -- 更新机构
    ,updateuserid varchar2(64) -- 更新人
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_wph_guaranty_relative to ${iml_schema};
grant select on ${iol_schema}.icms_wph_guaranty_relative to ${icl_schema};
grant select on ${iol_schema}.icms_wph_guaranty_relative to ${idl_schema};
grant select on ${iol_schema}.icms_wph_guaranty_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_guaranty_relative is '唯品会担保合同与押品关联关系表';
comment on column ${iol_schema}.icms_wph_guaranty_relative.objecttype is '对象类型';
comment on column ${iol_schema}.icms_wph_guaranty_relative.objectno is '对象编号';
comment on column ${iol_schema}.icms_wph_guaranty_relative.guarantycontractno is '担保合同编号';
comment on column ${iol_schema}.icms_wph_guaranty_relative.clrid is '担保物编号';
comment on column ${iol_schema}.icms_wph_guaranty_relative.relationstatus is '关联状态';
comment on column ${iol_schema}.icms_wph_guaranty_relative.guarantysum is '担保金额';
comment on column ${iol_schema}.icms_wph_guaranty_relative.guarantycurrency is '担保金额币种';
comment on column ${iol_schema}.icms_wph_guaranty_relative.guarantyrate is '抵/质押率（%）';
comment on column ${iol_schema}.icms_wph_guaranty_relative.actualguarantyrate is '实际抵、质押率%';
comment on column ${iol_schema}.icms_wph_guaranty_relative.remark is '备注';
comment on column ${iol_schema}.icms_wph_guaranty_relative.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_wph_guaranty_relative.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wph_guaranty_relative.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wph_guaranty_relative.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wph_guaranty_relative.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wph_guaranty_relative.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wph_guaranty_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wph_guaranty_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wph_guaranty_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wph_guaranty_relative.etl_timestamp is 'ETL处理时间戳';
