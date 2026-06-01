/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_pjtxsy_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_pjtxsy_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_pjtxsy_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_pjtxsy_recal(
    recal_dt number(22) -- 重算日期
    ,tjrq number(22) -- 统计日期
    ,zhdh varchar2(180) -- 账户代号
    ,pch varchar2(180) -- 批次号
    ,jgdh varchar2(180) -- 机构代号
    ,pjh varchar2(180) -- 票据号
    ,zqjh varchar2(180) -- 子区间号
    ,pmje number(30,2) -- 票面金额
    ,txsqr varchar2(180) -- 贴现申请人
    ,txll number(18,6) -- 贴现利率
    ,txrq number(22) -- 贴现日期
    ,dqrq number(22) -- 到期日期
    ,txlxsr number(25,4) -- 贴现利息收入
    ,ldjg varchar2(180) -- 联动机构
    ,ldll number(18,6) -- 联动利率
    ,zhfpsy number(25,4) -- 总行分配收益
    ,fhfpsy number(25,4) -- 分行分配收益
    ,tzjjx number(25,4) -- 调整加减项
    ,zhtzhsy number(25,4) -- 总行调整后收益
    ,fhtzhsy number(25,4) -- 分行调整后收益
    ,shtxlxsr number(30,2) -- 税后贴现利息收入
    ,cprmc varchar2(750) -- 出票人名称
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
grant select on ${iol_schema}.pams_jxdx_pjtxsy_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_pjtxsy_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_pjtxsy_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_pjtxsy_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_pjtxsy_recal is '绩效对象-票据贴现收益_重算';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.pch is '批次号';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.pjh is '票据号';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.zqjh is '子区间号';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.pmje is '票面金额';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.txsqr is '贴现申请人';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.txll is '贴现利率';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.txrq is '贴现日期';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.txlxsr is '贴现利息收入';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.ldjg is '联动机构';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.ldll is '联动利率';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.zhfpsy is '总行分配收益';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.fhfpsy is '分行分配收益';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.tzjjx is '调整加减项';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.zhtzhsy is '总行调整后收益';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.fhtzhsy is '分行调整后收益';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.shtxlxsr is '税后贴现利息收入';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.cprmc is '出票人名称';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxdx_pjtxsy_recal.etl_timestamp is 'ETL处理时间戳';
