/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bd_upl_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bd_upl_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bd_upl_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bd_upl_loan(
    serialno varchar2(32) -- 借据号
    ,surplusphases number(24,6) -- 剩余期数
    ,eacmprincipal number(24,6) -- 每期扣款额本金利息
    ,yqtotalsum number(24,6) -- 逾期管理累计应还
    ,yqfuli number(24,6) -- 逾期管理复利
    ,duebalance number(24,6) -- 暂存借据余额
    ,yqinterest number(24,6) -- 逾期管理利息
    ,acceptinttype varchar2(20) -- 计息方式
    ,logoutdate date -- 销账日期
    ,hxinrate number(24,6) -- 核销表内利息
    ,migtflag varchar2(80) -- migtflag
    ,nextperiodreturninterestsum number(24,6) -- 下一期还息金额
    ,changepayaccountname varchar2(100) -- 变更后的还款账号名称
    ,nextperiodreturninterestdate varchar2(10) -- 下一期还息日期
    ,legal number(24,6) -- 诉讼费
    ,raccrint number(18,2) -- 未结正常利息
    ,preinttype varchar2(20) -- 预收息标志
    ,yqfaxi number(24,6) -- 逾期管理罚息
    ,changepayaccountno varchar2(32) -- 变更后的还款账号
    ,yqnormalbalance number(24,6) -- 逾期管理正常本金
    ,yqbadbalance number(24,6) -- 逾期管理逾期本金
    ,nextperiodreturnprincipalsum number(24,6) -- 下一期还本金额
    ,bdflag varchar2(2) -- 买断清收标志
    ,fixterm number(24,6) -- 周期
    ,hxoutrate number(24,6) -- 核销表外利息
    ,loanspecies varchar2(5) -- 贷款种类
    ,nextperiodreturnprincipaldate varchar2(10) -- 下一期还本日期
    ,hxtype varchar2(5) -- 核销类别
    ,loantype varchar2(20) -- 贷款类型
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
grant select on ${iol_schema}.icms_bd_upl_loan to ${iml_schema};
grant select on ${iol_schema}.icms_bd_upl_loan to ${icl_schema};
grant select on ${iol_schema}.icms_bd_upl_loan to ${idl_schema};
grant select on ${iol_schema}.icms_bd_upl_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bd_upl_loan is '借据微贷附属表';
comment on column ${iol_schema}.icms_bd_upl_loan.serialno is '借据号';
comment on column ${iol_schema}.icms_bd_upl_loan.surplusphases is '剩余期数';
comment on column ${iol_schema}.icms_bd_upl_loan.eacmprincipal is '每期扣款额本金利息';
comment on column ${iol_schema}.icms_bd_upl_loan.yqtotalsum is '逾期管理累计应还';
comment on column ${iol_schema}.icms_bd_upl_loan.yqfuli is '逾期管理复利';
comment on column ${iol_schema}.icms_bd_upl_loan.duebalance is '暂存借据余额';
comment on column ${iol_schema}.icms_bd_upl_loan.yqinterest is '逾期管理利息';
comment on column ${iol_schema}.icms_bd_upl_loan.acceptinttype is '计息方式';
comment on column ${iol_schema}.icms_bd_upl_loan.logoutdate is '销账日期';
comment on column ${iol_schema}.icms_bd_upl_loan.hxinrate is '核销表内利息';
comment on column ${iol_schema}.icms_bd_upl_loan.migtflag is 'migtflag';
comment on column ${iol_schema}.icms_bd_upl_loan.nextperiodreturninterestsum is '下一期还息金额';
comment on column ${iol_schema}.icms_bd_upl_loan.changepayaccountname is '变更后的还款账号名称';
comment on column ${iol_schema}.icms_bd_upl_loan.nextperiodreturninterestdate is '下一期还息日期';
comment on column ${iol_schema}.icms_bd_upl_loan.legal is '诉讼费';
comment on column ${iol_schema}.icms_bd_upl_loan.raccrint is '未结正常利息';
comment on column ${iol_schema}.icms_bd_upl_loan.preinttype is '预收息标志';
comment on column ${iol_schema}.icms_bd_upl_loan.yqfaxi is '逾期管理罚息';
comment on column ${iol_schema}.icms_bd_upl_loan.changepayaccountno is '变更后的还款账号';
comment on column ${iol_schema}.icms_bd_upl_loan.yqnormalbalance is '逾期管理正常本金';
comment on column ${iol_schema}.icms_bd_upl_loan.yqbadbalance is '逾期管理逾期本金';
comment on column ${iol_schema}.icms_bd_upl_loan.nextperiodreturnprincipalsum is '下一期还本金额';
comment on column ${iol_schema}.icms_bd_upl_loan.bdflag is '买断清收标志';
comment on column ${iol_schema}.icms_bd_upl_loan.fixterm is '周期';
comment on column ${iol_schema}.icms_bd_upl_loan.hxoutrate is '核销表外利息';
comment on column ${iol_schema}.icms_bd_upl_loan.loanspecies is '贷款种类';
comment on column ${iol_schema}.icms_bd_upl_loan.nextperiodreturnprincipaldate is '下一期还本日期';
comment on column ${iol_schema}.icms_bd_upl_loan.hxtype is '核销类别';
comment on column ${iol_schema}.icms_bd_upl_loan.loantype is '贷款类型';
comment on column ${iol_schema}.icms_bd_upl_loan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bd_upl_loan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bd_upl_loan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bd_upl_loan.etl_timestamp is 'ETL处理时间戳';
