/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_dgsdmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_dgsdmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_dgsdmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_dgsdmx_recal(
    tjrq number -- 统计日期
    ,khdxdh number -- 考核对象代号
    ,jxdxdh number -- 绩效对象代号
    ,jgkhdxdh number -- 机构考核对象代号
    ,jgdh varchar2(30) -- 机构代号
    ,zhdh varchar2(120) -- 账户代号
    ,bz varchar2(30) -- 币种
    ,khh varchar2(90) -- 客户号
    ,cph varchar2(150) -- 产品号
    ,tzbl number(10,4) -- 调整比例
    ,hyye number(25,4) -- 行员余额
    ,yrj number(25,4) -- 行员月日均
    ,jrj number(25,4) -- 行员季日均
    ,nrj number(25,4) -- 行员年日均
    ,ftplxzc number(25,4) -- FTP利息支出
    ,ftplxzcylj number(25,4) -- FTP利息支出月累计
    ,ftplxzcjlj number(25,4) -- FTP利息支出季累计
    ,ftplxzcnlj number(25,4) -- FTP利息支出年累计
    ,ftpsr number(25,4) -- FTP收入
    ,ftpsrylj number(25,4) -- FTP收入月累计
    ,ftpsrjlj number(25,4) -- FTP收入季累计
    ,ftpsrnlj number(25,4) -- FTP收入年累计
    ,yxrq number -- 有效日期
    ,sxrq number -- 失效日期
    ,yxts number -- 有效天数
    ,recal_dt number -- 重算日期
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
grant select on ${iol_schema}.pams_jxbb_dgsdmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_dgsdmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_dgsdmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_dgsdmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_dgsdmx_recal is '绩效报表-对公收单明细_重算';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.cph is '产品号';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.tzbl is '调整比例';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.hyye is '行员余额';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.yrj is '行员月日均';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.jrj is '行员季日均';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.nrj is '行员年日均';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.ftplxzc is 'FTP利息支出';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.ftplxzcylj is 'FTP利息支出月累计';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.ftplxzcjlj is 'FTP利息支出季累计';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.ftplxzcnlj is 'FTP利息支出年累计';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.ftpsr is 'FTP收入';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.ftpsrylj is 'FTP收入月累计';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.ftpsrjlj is 'FTP收入季累计';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.ftpsrnlj is 'FTP收入年累计';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.yxrq is '有效日期';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.sxrq is '失效日期';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.yxts is '有效天数';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_dgsdmx_recal.etl_timestamp is 'ETL处理时间戳';
