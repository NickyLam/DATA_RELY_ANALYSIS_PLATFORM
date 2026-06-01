/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_com_itch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_com_itch
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_com_itch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_itch(
    stacid number(19) -- 账套标识
    ,itemfm varchar2(30) -- 被调整科目编号
    ,itemto varchar2(30) -- 调整科目编号
    ,efctdt varchar2(8) -- 科目生效日期
    ,transt varchar2(1) -- 状态(1、已调整0、未调整）
    ,usercd varchar2(20) -- 操作员
    ,userbr varchar2(12) -- 操作员所属机构编号
    ,oprtcd varchar2(6) -- 科目替换：replac科目拆分：splitt科目合并：mergee
    ,tranti date -- 操作时间
    ,toname varchar2(200) -- 拆分后的科目名称
    ,weight number(3) -- 拆分科目比例
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
grant select on ${iol_schema}.tgls_com_itch to ${iml_schema};
grant select on ${iol_schema}.tgls_com_itch to ${icl_schema};
grant select on ${iol_schema}.tgls_com_itch to ${idl_schema};
grant select on ${iol_schema}.tgls_com_itch to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_com_itch is '科目调整，包括合并、替换、拆分等';
comment on column ${iol_schema}.tgls_com_itch.stacid is '账套标识';
comment on column ${iol_schema}.tgls_com_itch.itemfm is '被调整科目编号';
comment on column ${iol_schema}.tgls_com_itch.itemto is '调整科目编号';
comment on column ${iol_schema}.tgls_com_itch.efctdt is '科目生效日期';
comment on column ${iol_schema}.tgls_com_itch.transt is '状态(1、已调整0、未调整）';
comment on column ${iol_schema}.tgls_com_itch.usercd is '操作员';
comment on column ${iol_schema}.tgls_com_itch.userbr is '操作员所属机构编号';
comment on column ${iol_schema}.tgls_com_itch.oprtcd is '科目替换：replac科目拆分：splitt科目合并：mergee';
comment on column ${iol_schema}.tgls_com_itch.tranti is '操作时间';
comment on column ${iol_schema}.tgls_com_itch.toname is '拆分后的科目名称';
comment on column ${iol_schema}.tgls_com_itch.weight is '拆分科目比例';
comment on column ${iol_schema}.tgls_com_itch.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_com_itch.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_com_itch.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_com_itch.etl_timestamp is 'ETL处理时间戳';
