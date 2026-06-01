/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_aeuv_detl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_aeuv_detl_h
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_aeuv_detl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_aeuv_detl_h(
    stacid number(19) -- 账套标记
    ,sourst varchar2(4) -- 源系统标识（ltts综合业务系统acct财务系统glis总账系统）
    ,sourdt varchar2(8) -- 源系统日期
    ,soursq varchar2(30) -- 源系统流水
    ,dispsq number -- 序号
    ,acctbr varchar2(16) -- 账务机构
    ,itemcd varchar2(30) -- 科目编号
    ,amntcd varchar2(9) -- 借贷方向
    ,tranam number(20,2) -- 交易金额
    ,trannm number -- 交易笔数
    ,smrytx varchar2(400) -- 摘要
    ,exchcn number(15,8) -- 中间价
    ,exchus number(11,7) -- 折算率
    ,assis0 varchar2(6) -- 渠道编号
    ,assis1 varchar2(12) -- 产品编号
    ,assis2 varchar2(30) -- 辅助核算2（往来核算）
    ,assis3 varchar2(30) -- 辅助核算3（产品核算）
    ,assis4 varchar2(30) -- 辅助核算4（责任中心）
    ,assis5 varchar2(30) -- 辅助核算5（项目核算）
    ,assis6 varchar2(30) -- 辅助核算6（自定义）
    ,assis7 varchar2(30) -- 辅助核算7（自定义）
    ,assis8 varchar2(30) -- 辅助核算8（自定义）
    ,assis9 varchar2(30) -- 辅助核算9（自定义）
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tgls_gla_aeuv_detl_h to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_aeuv_detl_h to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_aeuv_detl_h to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_aeuv_detl_h to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_aeuv_detl_h is '会计分录历史明细';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.sourst is '源系统标识（ltts综合业务系统acct财务系统glis总账系统）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.sourdt is '源系统日期';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.soursq is '源系统流水';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.dispsq is '序号';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.acctbr is '账务机构';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.amntcd is '借贷方向';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.tranam is '交易金额';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.trannm is '交易笔数';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.smrytx is '摘要';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.exchcn is '中间价';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.exchus is '折算率';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.assis0 is '渠道编号';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.assis1 is '产品编号';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.assis2 is '辅助核算2（往来核算）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.assis3 is '辅助核算3（产品核算）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.assis4 is '辅助核算4（责任中心）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.assis5 is '辅助核算5（项目核算）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_aeuv_detl_h.etl_timestamp is 'ETL处理时间戳';
