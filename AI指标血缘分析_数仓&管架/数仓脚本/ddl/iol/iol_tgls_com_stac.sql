/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_com_stac
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_com_stac
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_com_stac purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_stac(
    stacid number(19) -- 账套标记
    ,linkid number(19) -- 关联账套（目前不使用）
    ,stacna varchar2(40) -- 账套名称
    ,brchna varchar2(200) -- 机构名称
    ,crcycd varchar2(3) -- 币种代码
    ,starmh varchar2(6) -- 启用期间
    ,mesglt number(2) -- 日志保留长度
    ,autoup varchar2(1) -- 账目时间自动更新
    ,stacst number(2) -- 交易状态(20、正常状态99、总账日终28、日终错误)
    ,curtmh varchar2(6) -- 当前会计期间
    ,closmh varchar2(6) -- 已结账期数
    ,glisdt varchar2(8) -- 总账会计日期
    ,realbl varchar2(1) -- 实时计算余额
    ,blncck varchar2(1) -- 平衡检查
    ,rstrvc varchar2(1) -- 限制制证
    ,stacmt varchar2(1) -- 是否关联主账套(0－否，1－是)（目前不使用）
    ,keepac varchar2(1) -- 是否需要记账(0－不需要，1－需要)
    ,vlidtg varchar2(1) -- 0：未生效1：当前已生效9：已冻结
    ,bsnsdt varchar2(8) -- 业务日期
    ,acctdt varchar2(8) -- 账务会计日期
    ,crcyiv varchar2(3) -- 开票币种
    ,acctsy varchar2(2) -- 记账制
    ,musctg varchar2(1) -- 多准则核算标志(n－否，y－是)
    ,stactp varchar2(20) -- 账套类型
    ,linktp varchar2(20) -- 关联账套类型
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
grant select on ${iol_schema}.tgls_com_stac to ${iml_schema};
grant select on ${iol_schema}.tgls_com_stac to ${icl_schema};
grant select on ${iol_schema}.tgls_com_stac to ${idl_schema};
grant select on ${iol_schema}.tgls_com_stac to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_com_stac is '账套信息';
comment on column ${iol_schema}.tgls_com_stac.stacid is '账套标记';
comment on column ${iol_schema}.tgls_com_stac.linkid is '关联账套（目前不使用）';
comment on column ${iol_schema}.tgls_com_stac.stacna is '账套名称';
comment on column ${iol_schema}.tgls_com_stac.brchna is '机构名称';
comment on column ${iol_schema}.tgls_com_stac.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_com_stac.starmh is '启用期间';
comment on column ${iol_schema}.tgls_com_stac.mesglt is '日志保留长度';
comment on column ${iol_schema}.tgls_com_stac.autoup is '账目时间自动更新';
comment on column ${iol_schema}.tgls_com_stac.stacst is '交易状态(20、正常状态99、总账日终28、日终错误)';
comment on column ${iol_schema}.tgls_com_stac.curtmh is '当前会计期间';
comment on column ${iol_schema}.tgls_com_stac.closmh is '已结账期数';
comment on column ${iol_schema}.tgls_com_stac.glisdt is '总账会计日期';
comment on column ${iol_schema}.tgls_com_stac.realbl is '实时计算余额';
comment on column ${iol_schema}.tgls_com_stac.blncck is '平衡检查';
comment on column ${iol_schema}.tgls_com_stac.rstrvc is '限制制证';
comment on column ${iol_schema}.tgls_com_stac.stacmt is '是否关联主账套(0－否，1－是)（目前不使用）';
comment on column ${iol_schema}.tgls_com_stac.keepac is '是否需要记账(0－不需要，1－需要)';
comment on column ${iol_schema}.tgls_com_stac.vlidtg is '0：未生效1：当前已生效9：已冻结';
comment on column ${iol_schema}.tgls_com_stac.bsnsdt is '业务日期';
comment on column ${iol_schema}.tgls_com_stac.acctdt is '账务会计日期';
comment on column ${iol_schema}.tgls_com_stac.crcyiv is '开票币种';
comment on column ${iol_schema}.tgls_com_stac.acctsy is '记账制';
comment on column ${iol_schema}.tgls_com_stac.musctg is '多准则核算标志(n－否，y－是)';
comment on column ${iol_schema}.tgls_com_stac.stactp is '账套类型';
comment on column ${iol_schema}.tgls_com_stac.linktp is '关联账套类型';
comment on column ${iol_schema}.tgls_com_stac.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_com_stac.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_com_stac.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_com_stac.etl_timestamp is 'ETL处理时间戳';
