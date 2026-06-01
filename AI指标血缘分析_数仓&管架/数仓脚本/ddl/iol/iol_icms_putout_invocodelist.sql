/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_putout_invocodelist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_putout_invocodelist
whenever sqlerror continue none;
drop table ${iol_schema}.icms_putout_invocodelist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_putout_invocodelist(
    serialno varchar2(64) -- 流水号
    ,putoutserialno varchar2(64) -- 出账流水号
    ,invoserial varchar2(10) -- 序号
    ,trdno varchar2(500) -- 行外发票唯一号码
    ,invocode varchar2(100) -- 发票代码
    ,invonum varchar2(100) -- 发票号码
    ,invoamttax number(24,6) -- 发票金额（含税金额）
    ,invoamt number(24,6) -- 发票金额（不含税金额）
    ,invodate date -- 开票日期
    ,checkcode varchar2(20) -- 发票校验码
    ,invooccupamt number(24,6) -- 本次融资发票占用金额
    ,invoremainamt number(24,6) -- 剩余可用金额
    ,buyer varchar2(255) -- 购买方
    ,seller varchar2(255) -- 销售方
    ,invoicecheckresult varchar2(20) -- 查验结果
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
grant select on ${iol_schema}.icms_putout_invocodelist to ${iml_schema};
grant select on ${iol_schema}.icms_putout_invocodelist to ${icl_schema};
grant select on ${iol_schema}.icms_putout_invocodelist to ${idl_schema};
grant select on ${iol_schema}.icms_putout_invocodelist to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_putout_invocodelist is '兴链贷发票列表';
comment on column ${iol_schema}.icms_putout_invocodelist.serialno is '流水号';
comment on column ${iol_schema}.icms_putout_invocodelist.putoutserialno is '出账流水号';
comment on column ${iol_schema}.icms_putout_invocodelist.invoserial is '序号';
comment on column ${iol_schema}.icms_putout_invocodelist.trdno is '行外发票唯一号码';
comment on column ${iol_schema}.icms_putout_invocodelist.invocode is '发票代码';
comment on column ${iol_schema}.icms_putout_invocodelist.invonum is '发票号码';
comment on column ${iol_schema}.icms_putout_invocodelist.invoamttax is '发票金额（含税金额）';
comment on column ${iol_schema}.icms_putout_invocodelist.invoamt is '发票金额（不含税金额）';
comment on column ${iol_schema}.icms_putout_invocodelist.invodate is '开票日期';
comment on column ${iol_schema}.icms_putout_invocodelist.checkcode is '发票校验码';
comment on column ${iol_schema}.icms_putout_invocodelist.invooccupamt is '本次融资发票占用金额';
comment on column ${iol_schema}.icms_putout_invocodelist.invoremainamt is '剩余可用金额';
comment on column ${iol_schema}.icms_putout_invocodelist.buyer is '购买方';
comment on column ${iol_schema}.icms_putout_invocodelist.seller is '销售方';
comment on column ${iol_schema}.icms_putout_invocodelist.invoicecheckresult is '查验结果';
comment on column ${iol_schema}.icms_putout_invocodelist.start_dt is '开始时间';
comment on column ${iol_schema}.icms_putout_invocodelist.end_dt is '结束时间';
comment on column ${iol_schema}.icms_putout_invocodelist.id_mark is '增删标志';
comment on column ${iol_schema}.icms_putout_invocodelist.etl_timestamp is 'ETL处理时间戳';
