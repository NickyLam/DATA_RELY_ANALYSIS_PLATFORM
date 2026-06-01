/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cc_guarcorres
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cc_guarcorres
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cc_guarcorres purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cc_guarcorres(
    guarno varchar2(32) -- 押品编号 抵质押合同-押品编号（SI_SECURITYINFO.SCCODE）      保证合同-保证人编号（SI_GUARUSERINFO.GUARUSERCODE）
    ,bussno varchar2(50) -- 担保合同号码
    ,assconttype varchar2(12) -- 担保合同类型 保证合同 1        抵押合同 2        质押合同 3
    ,period varchar2(6) -- 对应贷款阶段 信贷字典        01-授信申请/审批阶段        02-合同签订阶段        03-额度启用阶段        04-出账审核阶段        05-风险监测阶段        06-清收处置阶段
    ,useassamt number(16,2) -- 担保金额
    ,useasscurrency varchar2(9) -- 担保币种
    ,state varchar2(12) -- 生效状态 SAMPLESTATUS      1有效      2无效
    ,state2 varchar2(3) -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止      ENDSTATE
    ,guarrate number(16,2) -- 审批抵质押率
    ,adguarrate number(16,2) -- 客户经理建议抵质押率
    ,mainguartype varchar2(3) -- 主担保/附属担保 0-主要担保          1-附属担保
    ,isimp varchar2(3) -- 首次出账前是否必须落实 1-是；0-否
    ,guarorder varchar2(3) -- 是否允许先出账后落实担保 1-是；0-否
    ,guardate number(38,0) -- 担保落实期限（天）
    ,guarvalue number(16,2) -- 审批时押品认定价值
    ,datasourceflag varchar2(3) -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
    ,startdate varchar2(10) -- 建立日期
    ,barsign varchar2(36) -- 条线
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
grant select on ${iol_schema}.icms_cc_guarcorres to ${iml_schema};
grant select on ${iol_schema}.icms_cc_guarcorres to ${icl_schema};
grant select on ${iol_schema}.icms_cc_guarcorres to ${idl_schema};
grant select on ${iol_schema}.icms_cc_guarcorres to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cc_guarcorres is '押品与担保合同对应表';
comment on column ${iol_schema}.icms_cc_guarcorres.guarno is '押品编号 抵质押合同-押品编号（SI_SECURITYINFO.SCCODE）      保证合同-保证人编号（SI_GUARUSERINFO.GUARUSERCODE）';
comment on column ${iol_schema}.icms_cc_guarcorres.bussno is '担保合同号码';
comment on column ${iol_schema}.icms_cc_guarcorres.assconttype is '担保合同类型 保证合同 1        抵押合同 2        质押合同 3';
comment on column ${iol_schema}.icms_cc_guarcorres.period is '对应贷款阶段 信贷字典        01-授信申请/审批阶段        02-合同签订阶段        03-额度启用阶段        04-出账审核阶段        05-风险监测阶段        06-清收处置阶段';
comment on column ${iol_schema}.icms_cc_guarcorres.useassamt is '担保金额';
comment on column ${iol_schema}.icms_cc_guarcorres.useasscurrency is '担保币种';
comment on column ${iol_schema}.icms_cc_guarcorres.state is '生效状态 SAMPLESTATUS      1有效      2无效';
comment on column ${iol_schema}.icms_cc_guarcorres.state2 is '到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止      ENDSTATE';
comment on column ${iol_schema}.icms_cc_guarcorres.guarrate is '审批抵质押率';
comment on column ${iol_schema}.icms_cc_guarcorres.adguarrate is '客户经理建议抵质押率';
comment on column ${iol_schema}.icms_cc_guarcorres.mainguartype is '主担保/附属担保 0-主要担保          1-附属担保';
comment on column ${iol_schema}.icms_cc_guarcorres.isimp is '首次出账前是否必须落实 1-是；0-否';
comment on column ${iol_schema}.icms_cc_guarcorres.guarorder is '是否允许先出账后落实担保 1-是；0-否';
comment on column ${iol_schema}.icms_cc_guarcorres.guardate is '担保落实期限（天）';
comment on column ${iol_schema}.icms_cc_guarcorres.guarvalue is '审批时押品认定价值';
comment on column ${iol_schema}.icms_cc_guarcorres.datasourceflag is '数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷';
comment on column ${iol_schema}.icms_cc_guarcorres.startdate is '建立日期';
comment on column ${iol_schema}.icms_cc_guarcorres.barsign is '条线';
comment on column ${iol_schema}.icms_cc_guarcorres.start_dt is '开始时间';
comment on column ${iol_schema}.icms_cc_guarcorres.end_dt is '结束时间';
comment on column ${iol_schema}.icms_cc_guarcorres.id_mark is '增删标志';
comment on column ${iol_schema}.icms_cc_guarcorres.etl_timestamp is 'ETL处理时间戳';
