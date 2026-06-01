/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cc_asscontcorres
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cc_asscontcorres
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cc_asscontcorres purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cc_asscontcorres(
    contno varchar2(100) -- 合同编号
    ,asscontno varchar2(50) -- 担保合同号码
    ,assconttype varchar2(12) -- 担保合同类型 1保证合同 2抵押合同 3质押合同
    ,useassamt number(16,2) -- 担保金额
    ,useasscurrency varchar2(9) -- 担保币种
    ,state varchar2(12) -- 生效状态 0－未生效，1-生效
    ,state2 varchar2(3) -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止
    ,iscopy varchar2(3) -- 是否引用 0：是 1：否
    ,datasourceflag varchar2(3) -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
    ,barsign varchar2(36) -- 条线
    ,contype varchar2(3) -- 合同类型 1 额度合同  2 贷款合同
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
grant select on ${iol_schema}.icms_cc_asscontcorres to ${iml_schema};
grant select on ${iol_schema}.icms_cc_asscontcorres to ${icl_schema};
grant select on ${iol_schema}.icms_cc_asscontcorres to ${idl_schema};
grant select on ${iol_schema}.icms_cc_asscontcorres to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cc_asscontcorres is '合同与担保合同对应表';
comment on column ${iol_schema}.icms_cc_asscontcorres.contno is '合同编号';
comment on column ${iol_schema}.icms_cc_asscontcorres.asscontno is '担保合同号码';
comment on column ${iol_schema}.icms_cc_asscontcorres.assconttype is '担保合同类型 1保证合同 2抵押合同 3质押合同';
comment on column ${iol_schema}.icms_cc_asscontcorres.useassamt is '担保金额';
comment on column ${iol_schema}.icms_cc_asscontcorres.useasscurrency is '担保币种';
comment on column ${iol_schema}.icms_cc_asscontcorres.state is '生效状态 0－未生效，1-生效';
comment on column ${iol_schema}.icms_cc_asscontcorres.state2 is '到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止';
comment on column ${iol_schema}.icms_cc_asscontcorres.iscopy is '是否引用 0：是 1：否';
comment on column ${iol_schema}.icms_cc_asscontcorres.datasourceflag is '数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷';
comment on column ${iol_schema}.icms_cc_asscontcorres.barsign is '条线';
comment on column ${iol_schema}.icms_cc_asscontcorres.contype is '合同类型 1 额度合同  2 贷款合同';
comment on column ${iol_schema}.icms_cc_asscontcorres.start_dt is '开始时间';
comment on column ${iol_schema}.icms_cc_asscontcorres.end_dt is '结束时间';
comment on column ${iol_schema}.icms_cc_asscontcorres.id_mark is '增删标志';
comment on column ${iol_schema}.icms_cc_asscontcorres.etl_timestamp is 'ETL处理时间戳';
