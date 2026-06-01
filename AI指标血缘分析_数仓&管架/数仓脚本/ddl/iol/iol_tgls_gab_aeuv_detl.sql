/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gab_aeuv_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gab_aeuv_detl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gab_aeuv_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gab_aeuv_detl(
    stacid number(19) -- 账套标记
    ,aeuvid number(19) -- 分录标识
    ,dispsq number -- 序号
    ,bsnsdt varchar2(8) -- 审计日期
    ,bsnssq varchar2(33) -- 业务流水号
    ,acctbr varchar2(12) -- 账务机构编号
    ,itemcd varchar2(30) -- 科目编号
    ,amntcd varchar2(9) -- 借贷方向
    ,tranam number(20,2) -- 交易金额
    ,trannm number -- 交易笔数
    ,smrytx varchar2(400) -- 摘要
    ,exchcn number(15,8) -- 中间价
    ,exchus number(15,8) -- 折算汇率
    ,toacno varchar2(50) -- 往来对方账号
    ,prlncd varchar2(16) -- 业务条线
    ,assis0 varchar2(6) -- 渠道编号
    ,assis1 varchar2(12) -- 产品编号
    ,assis2 varchar2(30) -- 辅助核算2（自定义）
    ,assis3 varchar2(30) -- 辅助核算3（自定义）
    ,assis4 varchar2(30) -- 辅助核算4（自定义）
    ,assis5 varchar2(30) -- 辅助核算5（自定义）
    ,assis6 varchar2(30) -- 辅助核算6（自定义）
    ,assis7 varchar2(30) -- 辅助核算7（自定义）
    ,assis8 varchar2(30) -- 辅助核算8（自定义）
    ,assis9 varchar2(30) -- 辅助核算9（自定义）
    ,prducd varchar2(16) -- 产品（辅助）
    ,custcd varchar2(16) -- 往来单位（辅助）
    ,prsncd varchar2(16) -- 职员（辅助）
    ,acctno varchar2(30) -- 账户（辅助）
    ,centcd varchar2(16) -- 部门（辅助）
    ,trandt varchar2(8) -- 入账会计日期
    ,foldcn number(20,2) -- 折本位币
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
grant select on ${iol_schema}.tgls_gab_aeuv_detl to ${iml_schema};
grant select on ${iol_schema}.tgls_gab_aeuv_detl to ${icl_schema};
grant select on ${iol_schema}.tgls_gab_aeuv_detl to ${idl_schema};
grant select on ${iol_schema}.tgls_gab_aeuv_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gab_aeuv_detl is '审计调账分录明细';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.aeuvid is '分录标识';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.dispsq is '序号';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.bsnsdt is '审计日期';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.bsnssq is '业务流水号';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.amntcd is '借贷方向';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.tranam is '交易金额';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.trannm is '交易笔数';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.smrytx is '摘要';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.exchcn is '中间价';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.exchus is '折算汇率';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.toacno is '往来对方账号';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.prlncd is '业务条线';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.assis0 is '渠道编号';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.assis1 is '产品编号';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.prducd is '产品（辅助）';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.custcd is '往来单位（辅助）';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.prsncd is '职员（辅助）';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.acctno is '账户（辅助）';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.centcd is '部门（辅助）';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.trandt is '入账会计日期';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.foldcn is '折本位币';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_gab_aeuv_detl.etl_timestamp is 'ETL处理时间戳';
