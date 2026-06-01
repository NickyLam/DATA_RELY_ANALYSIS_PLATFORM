/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_lcmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_lcmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_lcmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_lcmx_recal(
    tjrq number(22) -- 统计日期
    ,recal_dt number(22) -- 重算日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,kmh varchar2(60) -- 科目号
    ,bz varchar2(9) -- 币种
    ,fpjs varchar2(6) -- 分配角色
    ,zhye number(25,4) -- 账户余额
    ,zlbl number(19,5) -- 认领比例
    ,hyye number(25,4) -- 行员余额
    ,hyylj number(25,4) -- 行员月累计
    ,hyjlj number(25,4) -- 行员季累计
    ,hybnlj number(25,4) -- 行员半年累计
    ,hynlj number(25,4) -- 行员年累计
    ,hyymlj number(25,4) -- 行员月末累计
    ,zlblylj number(19,5) -- 增量比例月累计
    ,zlbljlj number(19,5) -- 增量比例季累计
    ,zlblnlj number(19,5) -- 增量比例年累计
    ,zlblymlj number(19,5) -- 增量比例月末累计
    ,gxsj timestamp -- 更新时间
    ,zhnrjye number(25,4) -- 账户年日均余额
    ,zhjrjye number(25,4) -- 账户季日均余额
    ,zhyrjye number(25,4) -- 账户月日均余额
    ,kzhlcbz varchar2(3) -- 跨支行理财标志
    ,ztbz varchar2(3) -- 在途标志：0-否，1-是
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
grant select on ${iol_schema}.pams_nbzz_lcmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_lcmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_lcmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_lcmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_lcmx_recal is '内部总账_理财账户明细_重算';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.zhye is '账户余额';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.zlbl is '认领比例';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.hyye is '行员余额';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.hyylj is '行员月累计';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.hyjlj is '行员季累计';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.hybnlj is '行员半年累计';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.hynlj is '行员年累计';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.hyymlj is '行员月末累计';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.zlblylj is '增量比例月累计';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.zlbljlj is '增量比例季累计';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.zlblnlj is '增量比例年累计';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.zlblymlj is '增量比例月末累计';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.gxsj is '更新时间';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.zhnrjye is '账户年日均余额';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.zhjrjye is '账户季日均余额';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.zhyrjye is '账户月日均余额';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.kzhlcbz is '跨支行理财标志';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.ztbz is '在途标志：0-否，1-是';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_lcmx_recal.etl_timestamp is 'ETL处理时间戳';
