/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1btyhxzdjmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1btyhxzdjmx
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1btyhxzdjmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1btyhxzdjmx(
    transdt varchar2(12) -- 登记日期
    ,transtm varchar2(9) -- 登记时间
    ,rwlsh varchar2(53) -- 任务流水号
    ,yrwlsh varchar2(53) -- 原任务流水号
    ,zh varchar2(60) -- 卡号
    ,zhzzh varchar2(75) -- 账号子账号
    ,zzhye varchar2(30) -- 子账号余额
    ,bz varchar2(30) -- 币种
    ,updttm varchar2(21) -- 更新时间
    ,result varchar2(2) -- 处理结果 0-录入;1-已冻结/续冻/解冻;2-冻结/续冻/解冻失败;5-金额超限
    ,hostdt varchar2(30) -- 核心交易日期
    ,hostseqno varchar2(30) -- 核心交易流水
    ,dataid varchar2(30) -- 中台流水
    ,zzhxh varchar2(75) -- 子账号序号
    ,djkssj varchar2(21) -- 冻结开始时间
    ,djjssj varchar2(21) -- 冻结结束时间
    ,chbz varchar2(30) -- 钞汇标志
    ,zxjg varchar2(15) -- 执行结果
    ,zxjgyy varchar2(750) -- 执行失败原因
    ,djjg varchar2(1500) -- 在先冻结机关
    ,zxdjje varchar2(30) -- 在先冻结金额
    ,djjzrq varchar2(12) -- 在先冻结到期日
    ,wdjje varchar2(30) -- 未冻结金额
    ,djje varchar2(30) -- 未冻结金额
    ,openbr varchar2(15) -- 
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
grant select on ${iol_schema}.mpcs_a1btyhxzdjmx to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1btyhxzdjmx to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1btyhxzdjmx to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1btyhxzdjmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1btyhxzdjmx is '协助冻结明细表';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.transdt is '登记日期';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.transtm is '登记时间';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.rwlsh is '任务流水号';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.yrwlsh is '原任务流水号';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.zh is '卡号';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.zhzzh is '账号子账号';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.zzhye is '子账号余额';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.bz is '币种';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.updttm is '更新时间';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.result is '处理结果 0-录入;1-已冻结/续冻/解冻;2-冻结/续冻/解冻失败;5-金额超限';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.hostdt is '核心交易日期';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.hostseqno is '核心交易流水';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.dataid is '中台流水';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.zzhxh is '子账号序号';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.djkssj is '冻结开始时间';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.djjssj is '冻结结束时间';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.chbz is '钞汇标志';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.zxjg is '执行结果';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.zxjgyy is '执行失败原因';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.djjg is '在先冻结机关';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.zxdjje is '在先冻结金额';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.djjzrq is '在先冻结到期日';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.wdjje is '未冻结金额';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.djje is '未冻结金额';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.openbr is '';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1btyhxzdjmx.etl_timestamp is 'ETL处理时间戳';
