/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_gsckcpmx_jg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_gsckcpmx_jg
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_gsckcpmx_jg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_gsckcpmx_jg(
    tjrq number(22,0) -- 数据日期
    ,jgkhdxdh number(22,0) -- 机构考核对象代号
    ,fpjs varchar2(3) -- 分配角色
    ,cpbh varchar2(30) -- 产品编号
    ,cpmc varchar2(750) -- 产品名称
    ,kmh varchar2(30) -- 科目号
    ,bz varchar2(5) -- 币种
    ,zzh varchar2(60) -- 子账户
    ,zhdh varchar2(60) -- 账户
    ,zhbs varchar2(2) -- 账户标识
    ,khh varchar2(45) -- 客户号
    ,bzbs varchar2(2) -- 币种标识
    ,zhye number(25,4) -- 余额
    ,zhyrjye number(25,4) -- 月日均
    ,zhjrjye number(25,4) -- 季日均
    ,zhnrjye number(25,4) -- 年日均
    ,ftpsy number(25,4) -- ftp净收入
    ,ftpsyylj number(25,4) -- ftp净收入月累计
    ,ftpsyjlj number(25,4) -- ftp净收入季累计
    ,ftpsynlj number(25,4) -- ftp净收入年累计
    ,ftplxzc number(25,4) -- FTP利息支出
    ,ftplxzcylj number(25,4) -- FTP利息支出月累计
    ,ftplxzcjlj number(25,4) -- FTP利息支出季累计
    ,ftplxzcnlj number(25,4) -- FTP利息支出年累计
    ,ftpsr number(25,4) -- 累计利息收入时点
    ,ftpsrylj number(25,4) -- 累计利息收入月累计
    ,ftpsrjlj number(25,4) -- 累计利息收入季累计
    ,ftpsrnlj number(25,4) -- 累计利息收入年累计
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
grant select on ${iol_schema}.pams_jxbb_gsckcpmx_jg to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_gsckcpmx_jg to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_gsckcpmx_jg to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_gsckcpmx_jg to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_gsckcpmx_jg is '绩效报表-公司存款产品明细-机构';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.tjrq is '数据日期';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.fpjs is '分配角色';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.zzh is '子账户';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.zhdh is '账户';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.bzbs is '币种标识';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.zhye is '余额';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.zhyrjye is '月日均';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.zhjrjye is '季日均';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.zhnrjye is '年日均';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.ftpsy is 'ftp净收入';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.ftpsyylj is 'ftp净收入月累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.ftpsyjlj is 'ftp净收入季累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.ftpsynlj is 'ftp净收入年累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.ftplxzc is 'FTP利息支出';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.ftplxzcylj is 'FTP利息支出月累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.ftplxzcjlj is 'FTP利息支出季累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.ftplxzcnlj is 'FTP利息支出年累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.ftpsr is '累计利息收入时点';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.ftpsrylj is '累计利息收入月累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.ftpsrjlj is '累计利息收入季累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.ftpsrnlj is '累计利息收入年累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_jg.etl_timestamp is 'ETL处理时间戳';
