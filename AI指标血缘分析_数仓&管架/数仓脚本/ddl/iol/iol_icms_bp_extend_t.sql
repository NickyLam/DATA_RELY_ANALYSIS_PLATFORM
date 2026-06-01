/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bp_extend_t
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bp_extend_t
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bp_extend_t purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bp_extend_t(
    serialno varchar2(64) -- 出账流水号
    ,paybacktimestype varchar2(18) -- 还款次数类型
    ,migtflag varchar2(80) -- 
    ,iccyc varchar2(18) -- 计息周期
    ,aboutbankid varchar2(32) -- 收款账户账号
    ,fundsource varchar2(4) -- 资金来源
    ,lprtype varchar2(10) -- LPR参照方式
    ,ret_msg varchar2(2000) -- 开户行地址
    ,acceptorbankname varchar2(180) -- 开户行名称
    ,financier varchar2(32) -- 实际融资人编号
    ,clearingtype varchar2(10) -- 开户行类别
    ,principalaccountname varchar2(80) -- 划款账户名称
    ,principalbankname varchar2(80) -- 划款账户开户行名称
    ,adjustratedate number(10,0) -- 利率调整日
    ,acceptorbankno varchar2(12) -- 开户行行号
    ,gatheringname varchar2(100) -- 收款账户名称
    ,principalaccountno varchar2(40) -- 划款账号
    ,accountcatagory varchar2(40) -- 账户类别AccountCatagory
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
grant select on ${iol_schema}.icms_bp_extend_t to ${iml_schema};
grant select on ${iol_schema}.icms_bp_extend_t to ${icl_schema};
grant select on ${iol_schema}.icms_bp_extend_t to ${idl_schema};
grant select on ${iol_schema}.icms_bp_extend_t to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bp_extend_t is '同业投融资业务出账附表';
comment on column ${iol_schema}.icms_bp_extend_t.serialno is '出账流水号';
comment on column ${iol_schema}.icms_bp_extend_t.paybacktimestype is '还款次数类型';
comment on column ${iol_schema}.icms_bp_extend_t.migtflag is '';
comment on column ${iol_schema}.icms_bp_extend_t.iccyc is '计息周期';
comment on column ${iol_schema}.icms_bp_extend_t.aboutbankid is '收款账户账号';
comment on column ${iol_schema}.icms_bp_extend_t.fundsource is '资金来源';
comment on column ${iol_schema}.icms_bp_extend_t.lprtype is 'LPR参照方式';
comment on column ${iol_schema}.icms_bp_extend_t.ret_msg is '开户行地址';
comment on column ${iol_schema}.icms_bp_extend_t.acceptorbankname is '开户行名称';
comment on column ${iol_schema}.icms_bp_extend_t.financier is '实际融资人编号';
comment on column ${iol_schema}.icms_bp_extend_t.clearingtype is '开户行类别';
comment on column ${iol_schema}.icms_bp_extend_t.principalaccountname is '划款账户名称';
comment on column ${iol_schema}.icms_bp_extend_t.principalbankname is '划款账户开户行名称';
comment on column ${iol_schema}.icms_bp_extend_t.adjustratedate is '利率调整日';
comment on column ${iol_schema}.icms_bp_extend_t.acceptorbankno is '开户行行号';
comment on column ${iol_schema}.icms_bp_extend_t.gatheringname is '收款账户名称';
comment on column ${iol_schema}.icms_bp_extend_t.principalaccountno is '划款账号';
comment on column ${iol_schema}.icms_bp_extend_t.accountcatagory is '账户类别AccountCatagory';
comment on column ${iol_schema}.icms_bp_extend_t.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bp_extend_t.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bp_extend_t.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bp_extend_t.etl_timestamp is 'ETL处理时间戳';
