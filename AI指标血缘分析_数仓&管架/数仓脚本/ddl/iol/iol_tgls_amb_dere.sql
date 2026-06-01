/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amb_dere
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amb_dere
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amb_dere purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amb_dere(
    stacid number(19) -- 账套标记
    ,systid varchar2(30) -- 来源系统编号
    ,datadt varchar2(8) -- 业务日期
    ,loanno varchar2(60) -- 贷款账户编号
    ,remotp varchar2(1) -- 撤并类型(0-整机构撤并，1-条件撤并,2-转移)
    ,bedecd varchar2(12) -- 撤并前机构编号
    ,afdecd varchar2(12) -- 撤并后机构编号
    ,intesm number(20,2) -- 变更时利息收入总金额
    ,intein number(20,2) -- 记录利息收入
    ,assesm number(20,2) -- 变更时减值损失总金额总金额
    ,asselo number(20,2) -- 记录减值损失
    ,impasm number(20,2) -- 变更时已减值利息收入总金额
    ,impaii number(20,2) -- 记录已减值利息收入
    ,invesm number(20,2) -- 变更时投资收益总金额
    ,invein number(20,2) -- 记录投资收益
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
grant select on ${iol_schema}.tgls_amb_dere to ${iml_schema};
grant select on ${iol_schema}.tgls_amb_dere to ${icl_schema};
grant select on ${iol_schema}.tgls_amb_dere to ${idl_schema};
grant select on ${iol_schema}.tgls_amb_dere to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amb_dere is '机构撤并登记表';
comment on column ${iol_schema}.tgls_amb_dere.stacid is '账套标记';
comment on column ${iol_schema}.tgls_amb_dere.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_amb_dere.datadt is '业务日期';
comment on column ${iol_schema}.tgls_amb_dere.loanno is '贷款账户编号';
comment on column ${iol_schema}.tgls_amb_dere.remotp is '撤并类型(0-整机构撤并，1-条件撤并,2-转移)';
comment on column ${iol_schema}.tgls_amb_dere.bedecd is '撤并前机构编号';
comment on column ${iol_schema}.tgls_amb_dere.afdecd is '撤并后机构编号';
comment on column ${iol_schema}.tgls_amb_dere.intesm is '变更时利息收入总金额';
comment on column ${iol_schema}.tgls_amb_dere.intein is '记录利息收入';
comment on column ${iol_schema}.tgls_amb_dere.assesm is '变更时减值损失总金额总金额';
comment on column ${iol_schema}.tgls_amb_dere.asselo is '记录减值损失';
comment on column ${iol_schema}.tgls_amb_dere.impasm is '变更时已减值利息收入总金额';
comment on column ${iol_schema}.tgls_amb_dere.impaii is '记录已减值利息收入';
comment on column ${iol_schema}.tgls_amb_dere.invesm is '变更时投资收益总金额';
comment on column ${iol_schema}.tgls_amb_dere.invein is '记录投资收益';
comment on column ${iol_schema}.tgls_amb_dere.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amb_dere.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amb_dere.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amb_dere.etl_timestamp is 'ETL处理时间戳';
