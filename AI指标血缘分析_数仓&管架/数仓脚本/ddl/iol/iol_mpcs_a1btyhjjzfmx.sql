/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1btyhjjzfmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1btyhjjzfmx
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1btyhjjzfmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1btyhjjzfmx(
    transdt varchar2(12) -- 登记日期
    ,transtm varchar2(9) -- 登记时间
    ,rwlsh varchar2(53) -- 任务流水号
    ,zh varchar2(75) -- 账号
    ,zhzzh varchar2(75) -- 账号子账号
    ,zzhye varchar2(30) -- 子账号余额
    ,bz varchar2(30) -- 币种
    ,updttm varchar2(21) -- 更新时间
    ,result varchar2(2) -- 处理结果 0-录入 1-已冻结 2-冻结失败 3-已解冻 4-解冻失败
    ,hostdt varchar2(30) -- 核心交易日期
    ,hostseqno varchar2(30) -- 核心交易流水
    ,dataid varchar2(30) -- 中台流水
    ,zzhxh varchar2(75) -- 子账号序号
    ,chbz varchar2(30) -- 钞汇标志
    ,zfkssj varchar2(21) -- 止付起始日期
    ,zfjssj varchar2(21) -- 止付结束日期
    ,zxjg varchar2(3) -- 执行结果
    ,zxjgyy varchar2(750) -- 执行失败原因
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
grant select on ${iol_schema}.mpcs_a1btyhjjzfmx to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1btyhjjzfmx to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1btyhjjzfmx to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1btyhjjzfmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1btyhjjzfmx is '紧急止付明细表';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.transdt is '登记日期';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.transtm is '登记时间';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.rwlsh is '任务流水号';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.zh is '账号';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.zhzzh is '账号子账号';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.zzhye is '子账号余额';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.bz is '币种';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.updttm is '更新时间';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.result is '处理结果 0-录入 1-已冻结 2-冻结失败 3-已解冻 4-解冻失败';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.hostdt is '核心交易日期';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.hostseqno is '核心交易流水';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.dataid is '中台流水';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.zzhxh is '子账号序号';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.chbz is '钞汇标志';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.zfkssj is '止付起始日期';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.zfjssj is '止付结束日期';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.zxjg is '执行结果';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.zxjgyy is '执行失败原因';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.openbr is '';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1btyhjjzfmx.etl_timestamp is 'ETL处理时间戳';
